-- функция будет расчитывать и публиковать статистику
let statsPub = () ->
begin
let statsDate = (select date_format(current_timestamp, "yyyy-MM-dd HH:mm:ss"))[0][0];--для статистики 11, 51201
--сборка статистики
let statsMap = (SELECT CONCAT('{11:','"','$statsDate','", 51201:','"','$statsDate','", 2: 1}'))[0][0];
publish($statsMap,'935122181'); --публикуем статистику
end;

--пишем статистику
statsPub();
log_info("LOG: WORKFLOW FINISHED");