drop table if exists custom_b2c_enrollment_and_collection.t_fct_enforcement_penalty purge;
create table if not exists custom_b2c_enrollment_and_collection.t_fct_enforcement_penalty (
   initiator_code       			string				comment'Код инициатора',
   major_sid              			string				comment'Уникальный ключ major',
   minor_sid            			string				comment'Уникальный ключ minor',
   receiver_tb_code            		string				comment'Код тербанка получателя',
   receiver_osb_num              	string				comment'Номер отделения ПАО «Сбербанк России» получателя',
   receiver_inn_num     			string				comment'Идентификационный номер налогоплательщика получателя',
   receiver_account_num         	string				comment'Номер счет получателя',
   receiver_bic_num 				string				comment'Банковский идентификационный код получателя',
   receiver_full_name              	string				comment'ФИО получателя',
   receiver_epk_id        			string				comment'epk_id получателя',
   receiver_bank_name     			string				comment'Наименование банка получателя',
   receiver_correspondent_account   string				comment'Корреспондентский счет банка получателя',
   receiver_address_name          	string				comment'Адрес получателя',
   payer_acc_num      				string				comment'Номер счета плательщика',
   payer_epk_id  					string				comment'epk_id плательщика',
   payer_full_name         			string				comment'ФИО плательщика',
   payer_inn_num  					string				comment'Идентификационный номер налогоплательщика плательщика',
   payer_tb_code   					string				comment'Код тербанка плательщика',
   payer_osb_num 					string				comment'Номер отделения ПАО «Сбербанк России» плательщика',
   payment_dttm 					timestamp			comment'Дата и время проведения операции',
   rub_amt      					decimal(38,16)		comment'Итоговая сумма оерации в рублях',
   purpose_txt        				string				comment'Назначение платежа',
   payment_status_code           	string				comment'Статус платежа',
   execution_subj_code          	string				comment'Код предмета исполнения',
   ctl_action        				string				comment'Идентификатор действия над записью',
   ctl_validfrom             		timestamp			comment'ID CTL потока',
   ctl_loading						bigint				comment'Дата загрузки записи',
   row_hash							string				comment'hash семантического ключа'
)
partitioned by (part_day	string	comment 'Секционирование данных по дню')
STORED AS PARQUET TBLPROPERTIES ('PARQUET.COMPRESS'='SNAPPY', 'transactional'='false');



drop table if exists custom_b2c_enrollment_and_collection_aux.t_fct_enforcement_penalty_inc purge;
create table if not exists custom_b2c_enrollment_and_collection_aux.t_fct_enforcement_penalty_inc (
   initiator_code       			string				comment'Код инициатора',
   major_sid              			string				comment'Уникальный ключ major',
   minor_sid            			string				comment'Уникальный ключ minor',
   receiver_tb_code            		string				comment'Код тербанка получателя',
   receiver_osb_num              	string				comment'Номер отделения ПАО «Сбербанк России» получателя',
   receiver_inn_num     			string				comment'Идентификационный номер налогоплательщика получателя',
   receiver_account_num         	string				comment'Номер счет получателя',
   receiver_bic_num 				string				comment'Банковский идентификационный код получателя',
   receiver_full_name              	string				comment'ФИО получателя',
   receiver_epk_id        			string				comment'epk_id получателя',
   receiver_bank_name     			string				comment'Наименование банка получателя',
   receiver_correspondent_account   string				comment'Корреспондентский счет банка получателя',
   receiver_address_name          	string				comment'Адрес получателя',
   payer_acc_num      				string				comment'Номер счета плательщика',
   payer_epk_id  					string				comment'epk_id плательщика',
   payer_full_name         			string				comment'ФИО плательщика',
   payer_inn_num  					string				comment'Идентификационный номер налогоплательщика плательщика',
   payer_tb_code   					string				comment'Код тербанка плательщика',
   payer_osb_num 					string				comment'Номер отделения ПАО «Сбербанк России» плательщика',
   payment_dttm 					timestamp			comment'Дата и время проведения операции',
   rub_amt      					decimal(38,16)		comment'Итоговая сумма оерации в рублях',
   purpose_txt        				string				comment'Назначение платежа',
   payment_status_code           	string				comment'Статус платежа',
   execution_subj_code          	string				comment'Код предмета исполнения',
   ctl_action        				string				comment'Идентификатор действия над записью',
   ctl_validfrom             		timestamp			comment'ID CTL потока',
   ctl_loading						bigint				comment'Дата загрузки записи',
   row_hash							string				comment'hash семантического ключа'
)
partitioned by (part_day	string	comment 'Секционирование данных по дню')
STORED AS PARQUET TBLPROPERTIES ('PARQUET.COMPRESS'='SNAPPY', 'transactional'='false');
