
DROP TABLE IF EXISTS dbo.#TrialBalance


CREATE TABLE #TrialBalance
( Symbol varchar(max) NOT NULL,
LastEntryDate varchar(max) NOT NULL,
SaldoBOWn varchar(max),
SaldoBOMa varchar(max),
ObrotyWn varchar(max),
ObrotyMa varchar(max),
ObrotyNWn varchar(max),
ObrotyNMa varchar(max),
SaldoWn varchar(max),
SaldoMa varchar(max),
PerSaldo varchar(max)
)

-- Import danych do tabeli tymczasowej
  BULK INSERT #TrialBalance 
  FROM 'C:\Users\marci\OneDrive\Dokumenty\GitHub\sulmar-tpa-sql\samples-data\Szkolenie_TrialBalance_v2.csv'
  WITH (FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', FIRSTROW = 2, CODEPAGE = '65001')

 
 -- Zamiana kolumn na rekordy (Unpivot)

  ;WITH CTE_ConvertedTrialBalance
  AS
  (
	SELECT 
	  Symbol,
	  TRY_PARSE(LastEntryDate AS datetime using 'pl-PL') AS LastEntryDate,
	  TRY_PARSE(SaldoBOWn AS decimal(10,6) USING 'pl-PL') AS SaldoBOWn,
	  TRY_PARSE(SaldoBOMa AS decimal(10,6) USING 'pl-PL') AS SaldoBOMa,
	  TRY_PARSE(ObrotyWn AS decimal(10,6) USING 'pl-PL') AS ObrotyWn,
	  TRY_PARSE(ObrotyMa AS decimal(10,6) USING 'pl-PL') AS ObrotyMa,
	  TRY_PARSE(ObrotyNWn AS decimal(10,6) USING 'pl-PL') AS ObrotyNWn,
	  TRY_PARSE(ObrotyNMa AS decimal(10,6) USING 'pl-PL') AS ObrotyNMa,
	  TRY_PARSE(SaldoWn AS decimal(10,6) USING 'pl-PL') AS SaldoWn,
	  TRY_PARSE(SaldoMa AS decimal(10,6) USING 'pl-PL') AS SaldoMa,
	  TRY_PARSE(PerSaldo AS decimal(10,6) USING 'pl-PL') AS PerSaldo
  FROM #TrialBalance
  ),

  CTE_TrialBalanceUnpiv
  AS 
  (
  SELECT Symbol, 
  TRY_PARSE(LastEntryDate AS datetime using 'pl-PL')  AS LastEntryDate,
  Amount,
  AmountType
  FROM #TrialBalance
  UNPIVOT
  (
	Amount 
	FOR AmountType 
	IN(
		SaldoBOWn,SaldoBOMa,ObrotyWn,ObrotyMa,ObrotyNWn,ObrotyNMa,SaldoWn,SaldoMa,PerSaldo)
  ) AS TrialBalanceUnpivot),

-- Zamiana kolumn na rekordy (Pivot)
  CTE_TrialBalancePivot
  AS
  (
  SELECT 
	  Symbol, 
	  LastEntryDate,
	  SaldoBOWn,
	  SaldoBOMa,
	  ObrotyWn,
	  ObrotyMa,
	  ObrotyNWn,
	  ObrotyNMa,
	  SaldoWn,
	  SaldoMa,
	  PerSaldo
  FROM CTE_TrialBalanceUnpiv
  PIVOT
  (
	MAX(Amount)
	FOR AmountType
	IN
	(
		SaldoBOWn,SaldoBOMa,ObrotyWn,ObrotyMa,ObrotyNWn,ObrotyNMa,SaldoWn,SaldoMa,PerSaldo -- Raczej nie automatyzowaæ
	)
  ) AS TrialBalancePivot
  )
  
 -- SELECT Symbol, 
 -- CAST(LastEntryDate AS datetime) AS LastEntryDate,
 -- AmountType,
 -- Amount 
 -- FROM #TrialBalance
 -- UNPIVOT
 -- (
	--Amount 
	--FOR AmountType 
	--IN(
	--	SaldoBOWn,SaldoBOMa,ObrotyWn,ObrotyMa,ObrotyNWn,ObrotyNMa,SaldoWn,SaldoMa,PerSaldo)
 -- ) AS TrialBalanceUnpivot
  
--  select * from CTE_TrialBalanceUnpiv

  -- SELECT * FROM CTE_TrialBalancePivot


  -- Utworzenie tabeli na podstawie zapytania

	select * 
		into TrialBalances
	from CTE_TrialBalancePivot
		 


  -- Wstawianie danych do istniej¹cej tabeli
 -- insert into TrialBalances
	--select * from CTE_TrialBalancePivot

  

