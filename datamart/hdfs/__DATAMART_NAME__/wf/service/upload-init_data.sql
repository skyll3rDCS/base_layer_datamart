--Проверяем, что переменные не определены
if ($app.target.date.from == none) then
    log_info("Parameter app.target.date.from is None ! Set app.target.date.from to empty string.");
    let app.target.date.from = "";
end if;
if ($app.target.date.to == none) then
    log_info("Parameter app.target.date.to is None ! Set app.target.date.to to empty string.");
    let app.target.date.to = "";
end if;

--проверка ввода даты загрузки - если не заполнена, то полная загрузка
let loadDt = "";

if ($app.target.date.from != "" and $app.target.date.to != "") then
    let loadDt = " between '$app.target.date.from' and '$app.target.date.to' ";
elif ($app.target.date.to != "" ) then
    let loadDt = " <= '$app.target.date.to' ";
elif ($app.target.date.from != "") then
    let loadDt = " >= '$app.target.date.from' ";
else
    let dateFrom = (select date_format(current_date, "yyyy-MM-dd"))[0][0];
    let loadDt = "< '$dateFrom' ";
end if;
log_info("LOG: Load param is '$loadDt' ");

let sqlFilesPath = concat($datamart.sql.path, "/init");

run_sql_hdfs(concat($sqlFilesPath, "/", $app.stg.table.sql));

--вызов функции для склейки и укрупнения файлов stg таблицы
log_info("LOG: Starting coalesce_files function");
coalesce_files("/data/custom/b2c/enrollment_and_collection/stg/$app.stg.table.name",
               "/data/custom/b2c/enrollment_and_collection/stg/coalesce_snp_service",
               128, "snappy", 20);
log_info("LOG: Finished coalesce_files function");

-- Удаляем целевую таблицу и создаем заново
--let ddlSqlFilesPath = case when ends_with($datamart.sql.path, "/") then $datamart.sql.path else concat($datamart.sql.path, "/") end;
let ddlSqlFilesPath = concat($datamart.sql.path, "/");
log_info("Calculated ddlSqlFilesPath = $ddlSqlFilesPath");

run_sql_hdfs(concat($ddlSqlFilesPath, $app.ddl.target.table.sql));

--вызов функции для перемещения данных в PA (целевую таблицу)
log_info("LOG: Starting move_table_to_schema function");
move_table_to_schema(
        s2tTableList="$app.stg.table.name->$app.target.table.name",
        srcSchema="$app.stg.schema.name",
        tgtSchema="$app.target.schema.name",
        compressionType="snappy",
        workMode="arc",
        truncateIncFilterList="",
        instanceFilter="",
        truncateStgFromPa=false);

log_info("LOG: Finished move_table_to_schema function");

-- Формируем статистики загрузки
let statsDt = (select date_format(current_timestamp(), 'yyyy-MM-dd HH:mm:ss'))[0][0];
let statsMap = '{2: "1", 11: "$statsDt", 51201: "$statsDt"}';
publish($statsMap, "$app.ctl.entity");




