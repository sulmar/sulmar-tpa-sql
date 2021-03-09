select * from [dbo].[TrialBalances]

-- indeksy nieklastrowe

create nonclustered index ix_TrialBalances_Symbol
	on [dbo].[TrialBalances](Symbol)


	select * from [dbo].[TrialBalances] 
		where 
			Symbol = '645-2400'
 
 -- indeksy klastrowe

GO

 CREATE CLUSTERED INDEX ix_TrialBalances_Symbol ON  [dbo].[TrialBalances] 
(
	Symbol ASC
)