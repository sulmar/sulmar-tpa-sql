-- wersjonowanie danych Temporal Tables

select * from [dbo].[TrialBalances]


create table [dbo].[TrialBalances3]
(
    Id int not null IDENTITY primary key clustered,
	Symbol varchar(max) not null,
	PerSaldo decimal(10, 2) null,
	ValidFrom datetime2 generated always as row start,
	ValidTo datetime2 generated always as row end,
	period for system_time (ValidFrom, ValidTo)
)
with (system_versioning = ON (history_table = dbo.TrialBalances3History))



insert into [TrialBalances3] (Symbol, PerSaldo)
	select Symbol, isnull(TRY_PARSE( PerSaldo as decimal(10,2)),0) from [TrialBalances]


	select * from [TrialBalances3]

	update  [TrialBalances3]
	set PerSaldo = 500
	where Symbol = '010'


;with cte_full as 
	(select * from TrialBalances3History
	union all
	select * from [TrialBalances3])

select * from cte_full 
	where '2021-03-09 14:14:20' between ValidFrom  and ValidTo  
	
				
GO

-- https://matthewmcgiffen.com/2017/10/24/implementing-temporal-tables-where-you-have-existing-data/

	ALTER TABLE [dbo].[TrialBalances]
		ADD 
		ValidFrom datetime2 generated always as row start default(getdate()),
		ValidTo datetime2 generated always as row end default('9999-12-31'),
		period for system_time (ValidFrom, ValidTo)


GO
		ALTER TABLE [dbo].[TrialBalances]
	SET
	(	SYSTEM_VERSIONING = ON
           ( HISTORY_TABLE = [dbo].[TrialBalancesHistory])
         
	)
