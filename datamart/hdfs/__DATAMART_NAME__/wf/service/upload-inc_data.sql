-- Константы для скрипта
let c_DateTimeRegExp = "^([0-9]{4})-?(1[0-2]|0[1-9])-?(3[01]|0[1-9]|[12][0-9]) (2[0-3]|[01][0-9]):?([0-5][0-9]):?([0-5][0-9])\$";  -- RegExp для строки "<Дата ISO> <Время> <TZ>"
let c_DateRegExp = "^([0-9]{4})-?(1[0-2]|0[1-9])-?(3[01]|0[1-9]|[12][0-9])";                                                      -- RegExp для строки "<Дата ISO>"

-- Функция получения списка файлов для выполнения
let execSqlFilesFunc = (p_sqlFilesPath, p_sqlFilesDelimStr) ->
begin
   log_info("LOG: p_sqlFilesPath = $p_sqlFilesPath");

   -- Получаем список sql-запросов для формирования инкремента данных
   let v_SqlList = split($p_sqlFilesDelimStr, ";", -1);

   log_info("Getted list of sql scripts files. List size is: ${size($v_SqlList)}");

   --Последовательно выполняем скрипты формирования данных в stage-таблице инкремента
   for sqlFileName in $v_SqlList loop
       let v_fullSqlFilePath = concat($p_sqlFilesPath, "/", ltrim(rtrim($sqlFileName," "), " "));
       log_info("LOG: execute sql query in $v_fullSqlFilePath file !!");

       run_sql_hdfs($v_fullSqlFilePath);
   end loop

   log_info("LOG: Finished execution of sql files !");
end;

let calcStatiscsFunc = (p_sqlFilePath) ->
begin
   log_info("LOG: Path to Sql file - $p_sqlFilePath");

   -- Читаем текст SQL-запроса из поставленного файдв
   let sqlStatsQuery = read_hdfs_file($p_sqlFilePath);

   let statisticsArray = run_sql($sqlStatsQuery);

   log_info("LOG: calculated statistics - $statisticsArray");

   let statsString = "";
   let statsCount = 0;
   for statistic, stat_value in $statisticsArray loop
      let statsCount = $statsCount + 1;
      if $statsCount > 1 then
         let statsString = concat($statsString, ',', '$statistic : "$stat_value"');
      else
         let statsString = '$statistic : "$stat_value"';
      end if;
   end loop

   $statsString;
end;

--Проверяем,что переменные не определены(none)
if ($app.target.date.from == none) then
   log_info("Parameter app.target.date.from is None ! Set app.target.date.from to empty string.");
   let app.target.date.from = "";
end if;
if ($app.target.date.to == none) then
    log_info("Parameter app.target.date.to is None ! Set app.target.date.to to empty string.");
    let app.target.date.to = "";
end if;

--проверка ввода дат - если заполнены, то загрузка за период
let loadDt = "";
if ($app.target.date.from != "" and $app.target.date.to != "") then
    let dateFrom = "";   
    let dateTo = ""; 
    
    if (select regexp('$app.target.date.to', '$c_DateTimeRegExp'))[0][0] or (select regexp('$app.target.date.to', '$c_DateRegExp'))[0][0]  then 
        let dateFrom = (select to_timestamp('$app.target.date.from'))[0][0] ; 
    else     
        let dateFrom = $app.target.date.from;
    end if; 
    
    if (select regexp('$app.target.date.to', '$c_DateTimeRegExp'))[0][0] then 
        let dateTo = $app.target.date.to;  
    elif (select regexp('$app.target.date.to', '$c_DateRegExp'))[0][0]   then     
        let dateTo = (select date_add(to_date('$app.target.date.to', 'yyyy-MM-dd'), 1) - interval '1' microsecond)[0][0];
    else 
        let dateTo = $app.target.date.to;    
    end if;
    
    let loadDt = "between '$dateFrom' and '$dateTo' ";
else
    --если не заданы даты для пересчета, то считаем вчерашний день
    let dateFrom = (select cast(date_add(current_date, -1) as timestamp))[0][0];
    let dateTo   = (select cast(current_date - interval '1' microsecond as timestamp))[0][0];
    let loadDt = "between '$dateFrom' and '$dateTo' ";
end if;

log_info("LOG: Load param is '$loadDt' ");

--Маршрут до файлов, содержащих sql-запросы
let v_sqlFilesPath = concat($datamart.sql.path, "/dml");

-- Формируем данные инкремента в stage-таблице
execSqlFilesFunc($v_sqlFilesPath, "$app.stg.table.sql");

-- Формируем инкремент бизнесс истории
let incDtCnt = (select count(1) from $app.stg.schema.name.$app.stg.table.name)[0][0];

log_info("Fetched rows of increment: $incDtCnt");

let statistics = '910: "0", 911: "0", 912: "0" ';

if ($incDtCnt > 0) then
    --вызов функции для склейки и укрупнения файлов в hdfs
    log_info("LOG: Start coalesce_files function of increment table");
    coalesce_files("/data/custom/b2c/enrollment_and_collection/stg/$app.stg.table.name",
                   "/data/custom/b2c/enrollment_and_collection/stg/coalesce_snp_service",
                   128, "snappy", 10);
    log_info("LOG: Finish coalesce_files function of increment table");

    --Формируем snapshot инкремента
    execSqlFilesFunc($v_sqlFilesPath, "$app.stg.snp.inc.sql");

    --вызов функции для склейки и укрупнения файлов в hdfs
    log_info("LOG: Start coalesce_files function of history increment table");
    coalesce_files("/data/custom/b2c/enrollment_and_collection/stg/$app.stg.snp.inc.table.name",
                   "/data/custom/b2c/enrollment_and_collection/stg/coalesce_snp_service",
                    128, "snappy", 20);
    log_info("LOG: Finish coalesce_files function of snapshot increment table");

     try
         -- Считаем статистики потока
        let statistics = calcStatiscsFunc(concat($datamart.sql.path, "$app.stat.sql"));
        log_info("LOG: statistics are - $statistics");
     catch ex then
        log_info("LOG: exception type - $ex["type"]");
        log_info("LOG: numeric statistics isnt available !");
     end

    --вызов функции для перемещения данных в PA (целевую таблицу)
    log_info("LOG: Starting move_table_to_schema function");

    move_table_to_schema(
        s2tTableList="$app.stg.snp.inc.table.name->$app.target.table.name",
        srcSchema="$app.stg.schema.name",
        tgtSchema="$app.target.schema.name",
        compressionType="snappy",
        workMode="inc",
        truncateIncFilterList="",
        instanceFilter="",
        truncateStgFromPa=true
    );
    log_info("LOG: Finished move_table_to_schema function");

     -- Publish statistics
    let curDtm = (select date_format(current_timestamp(), 'yyyy-MM-dd HH:mm:ss'))[0][0];

    let statsMap = case
                      when is_empty($statistics) then  '{ 2 : "1", 11: "$curDtm", 51201: "$curDtm"}'
                      else concat('{', '2 : "1", 11: "$curDtm", 51201: "$curDtm",', $statistics, '}')
                   end;
    log_info("LOG: json to publish - $statsMap");

    publish($statsMap, "$app.ctl.entity");
else
    let curDtm = (select date_format(current_timestamp(), 'yyyy-MM-dd HH:mm:ss'))[0][0];

    let statsMap = case
                      when is_empty($statistics) then '{2 : "0", 51201: "$curDtm"}'
                      else concat('{', '2 : "0", 51201: "$curDtm",', $statistics, '}')
                   end;
    log_info("LOG: publish json - $statsMap");

    publish($statsMap, "$app.ctl.entity");

    log_info("LOG: Upload skipped (no data)");
end if;


