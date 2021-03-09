-- Funkcje


-- Funkcje dyskretna

with cteTrialBalances as
(
select 
	Symbol,
	TRY_PARSE(SaldoBOWn AS decimal(10,2 ) ) as SaldoBOWn,
	TRY_PARSE(SaldoBOMa AS decimal(10,2 ) ) as SaldoBOMa

from [dbo].[TrialBalances]) 


--select 
--	 Symbol,
--	 SaldoBOWn,
--	 SaldoBOMa,
--	 SaldoBOWn * 1.23 as SaldoBOWnGross,
--	 SaldoBOMa * 1.23 as SaldoBOMaGross
--from cteTrialBalances


select 
	 Symbol,
	 SaldoBOWn,
	 SaldoBOMa,	 
	 dbo.udfAmountGross(SaldoBOWn, 1.23) as SaldoBOWnGross,
	 dbo.udfAmountGross(SaldoBOMa, 1.23) as SaldoBOMaGross
from cteTrialBalances

GO

CREATE OR ALTER FUNCTION udfAmountGross
(
	@amount decimal(18,2),
	@tax decimal(10, 2)
)
RETURNS decimal(18,2)
AS
BEGIN

	RETURN @amount * @tax

END

select dbo.udfAmountGross(100, 1.23)



select 
	Symbol, 	
	dbo.udfGetParentSymbol(Symbol) as ParentSymbol
from Accounts

GO

CREATE OR ALTER FUNCTION udfGetParentSymbol
(
	@symbol varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
	RETURN LEFT(@symbol, LEN(@symbol)-CHARINDEX('-', REVERSE(@symbol)))
END

GO


-- Funkcje tabelaryczne (Table-Valued Functions)


CREATE FUNCTION udfGetTrialBalancesByYear
(
    @year int
)
RETURNS TABLE
AS
RETURN 
	select * from [dbo].[TrialBalances]
		where year(LastEntryDate) = @year

GO


SELECT * FROM dbo.udfGetTrialBalancesByYear(2020)



GO

CREATE FUNCTION GetDates(
  @start datetime,
  @stop datetime
)
RETURNS 
 @dates table 
 (
	[Date] datetime
 )
 AS
 begin
	declare @currentdate datetime = @start

	while @currentdate <= @stop
	BEGIN
		insert into @dates 
			values (@currentdate)

		set @currentdate = DATEADD(day, 1, @currentdate)
	END

	RETURN

 end
 

select * from dbo.GetDates('2021-05-01' , '2021-06-01')



