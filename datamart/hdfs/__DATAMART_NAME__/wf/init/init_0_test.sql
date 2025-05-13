

let test_table = 'test_table';
create EXTERNAL table if not exists $app.src.schema.name.$test_table (
sid string,
doc_id string,
total_amount bigint,
prnct decimal(38,16),
sdate timestamp
)
stored as parquet
tblproperties ('PARQUET.COMPRESS'='SNAPPY', 'transactional'='false','external.table.purge'='true');

insert into ${$app.src.schema.name || '.' || $test_table}(sid,doc_id,total_amount,prnct,sdate)
VALUES ('10',null,null,null,null);
