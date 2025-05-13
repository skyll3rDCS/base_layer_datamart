insert overwrite $app.stg.schema.name.$app.stg.table.name
(
       initiator_code
     , major_sid
     , minor_sid
     , receiver_tb_code
     , receiver_osb_num
     , receiver_inn_num
     , receiver_account_num
     , receiver_bic_num
     , receiver_full_name
     , receiver_epk_id
     , receiver_bank_name
     , receiver_correspondent_account
     , receiver_address_name
     , payer_acc_num
     , payer_epk_id
     , payer_full_name
     , payer_inn_num
     , payer_tb_code
     , payer_osb_num
     , payment_dttm
     , rub_amt
     , purpose_txt
     , payment_status_code
     , execution_subj_code
     , ctl_action
     , ctl_validfrom
     , ctl_loading
     , row_hash
     , part_day
)

select
	a.originator			as	initiator_code					,	--1
	a.id_major				as	major_sid						, 	--2
	a.id_minor				as	minor_sid						, 	--3
	a.id_mega				as	receiver_tb_code				,  	--4
	a.branch				as	receiver_osb_num				, 	--5
	a.rc_inn				as	receiver_inn_num				, 	--6
	a.rc_account			as	receiver_account_num			,	--7
	a.rc_bank_bic			as	receiver_bic_num				, 	--8
	a.rc_name				as	receiver_full_name				, 	--9
	a.rrn					as	receiver_epk_id					, 	--10
	c.vz_bank				as	receiver_bank_name				,	--11
	c.vz_bank_ks			as	receiver_correspondent_account	,	--12
	c.vz_addr				as	receiver_address_name			,	--13
	a.pr_account			as	payer_acc_num					, 	--14
	b.authcode				as	payer_epk_id					, 	--15
	concat( c.d_surname, ' ', c.d_firstname, ' ', c.d_secondname) as payer_full_name,	--16
	d.d_inn					as 	payer_inn_num					,	--17
	b.deposit_id_mega		as 	payer_tb_code					,	--18
	b.branch				as 	payer_osb_num					,	--19
	a.odday					as 	payment_dttm					, 	--20
	a.totalsum				as 	rub_amt							, 	--21
	a.purpose				as	purpose_txt						, 	--22
	a.state					as	payment_status_code				, 	--23
	c.id_subj				as	execution_subj_code				,	--24
	'I' 					as 	ctl_action  					,   --25
    current_timestamp() 	as 	ctl_validfrom        			,	--26
    cast('$app.ctl.loading' as bigint )   	 as ctl_loading		,   --27
	sha2(
		concat(nvl(a.originator, '0'),nvl(a.id_mega, '0'), nvl(a.id_major, '0'), nvl(a.id_minor, '0'),
		nvl(a.branch, '0'), nvl(a.rc_inn, '0'), nvl(a.odday, '0'),
		nvl(a.rc_account, '0'), nvl(a.totalsum, '0'), nvl(a.pr_account, '0'),
		nvl(a.rc_bank_bic, '0'), nvl(a.rc_name, '0'),nvl(a.purpose, '0'),
		nvl(a.rrn, '0'), nvl(a.state, '0'), nvl(b.authcode, '0'),
		nvl(c.id_subj, '0'), nvl(c.vz_bank, '0'), nvl(c.vz_bank_ks, '0'),
		nvl(c.vz_addr, '0'), nvl(d.d_surname, '0'), nvl(d.d_firstname, '0'),
		nvl(d.d_secondname, '0'), nvl(d.d_inn, '0')
		), 256) as row_hash										,	--28
	cast(to_date(a.odday) as string) as part_day						--29
from
	${$app.src.schema.name}.idoc_acc_payment a --a 1
join
	${$app.src.schema.name}.idoc_acc b --b 2

	on b.id_mega = a.id_mega and b.id_minor = a.idoc_acc_minor and b.id_major = a.idoc_acc_major
join
	${$app.src.schema.name}.idoc c --c 3

	on c.id_mega = b.id_mega and c.id_minor = b.idoc_minor and c.id_major = b.idoc_major
join
	${$app.src.schema.name}.idoc_debtor d --d 4

	on c.id_mega = d.id_mega and c.id_minor = d.idoc_minor and c.id_major = d.idoc_major

where c.id_subj = '51'
	and a.state = 7
	and a.originator like '%SDC'
	and a.rrn is not null
	and (substr(a.rc_account, 0, 5) in ('40817', '40820') or substr(a.rc_account, 0, 3) in ('423', '426'))
;

--вызов функции для склейки и укрупнения файлов в hdfs
log_Info("LOG: Starting coalesce_files function");
coalesce_files("/data/custom/b2c/enrollment_and_collection/aux/t_fct_enforcement_penalty_inc", "/data/custom/b2c/enrollment_and_collection/stg/cs_buffer_enp", 64, "snappy",6);
log_Info("LOG: Finished coalesce_files function");

--вызов функции для перемещения данных в PA (целевую таблицу)
log_Info("LOG: Starting move_table_to_schema function");

--вызов функции для перемещения данных в PA (целевую таблицу)
move_table_to_schema(
"t_fct_enforcement_penalty_inc->t_fct_enforcement_penalty",
"custom_b2c_enrollment_and_collection_aux",
"custom_b2c_enrollment_and_collection",
"snappy",
"arc",
"",
"",
"",
false);

log_info("LOG: Finished move_table_to_schema function");
