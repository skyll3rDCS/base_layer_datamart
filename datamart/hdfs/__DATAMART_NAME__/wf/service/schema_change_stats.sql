log_info("LOG: publish schema change statistics");
let curDttm = (select date_format(current_timestamp(), 'yyyy-MM-dd HH:mm:ss'))[0][0];

-- Карта значений статистик потока schema_change для таблиц
let statsMap = '{2 : "1", 11: "$curDttm",  51201 : "$curDttm"}';
publish($statsMap, "935122142,935122143,935122144,935122145");

-- Обновление статистик для сущности хранилища
publish ($statsMap, "935122100");

log_info("LOG: publish schema change statistics finish");