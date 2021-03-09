select * from [dbo].[Accounts]

-- Syntax
/*
WITH cte_alias (column_aliases) 
AS 
(
cte_query_definition   -- initialization (anchor)
UNION ALL
cte_query_definition2 -- recursive execution
) 
SELECT * FROM cte_alias 
*/


with CTE_Query as
(select						-- initialization
	AccountId,
	Symbol,
	ParentId,
	1 AS [Level]
 from Accounts
	where ParentId is null

union all

select					 -- recursive execution
	a.AccountId,
	a.Symbol,
	a.ParentId,
	c.[Level] + 1
from Accounts as a
	inner join CTE_Query as c
		on a.ParentId = c.AccountId
)

select * from CTE_Query order by [Level]

ctr
select 
	TRY_PARSE(SaldoBOWn AS decimal(10,2 ) )
select *
 from [dbo].[TrialBalances]


