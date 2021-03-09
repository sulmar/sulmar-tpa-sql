

-- utworzenie tabeli tymczasowej 
CREATE TABLE #Accounts_Import (
Symbol varchar(128) NOT NULL,
[Name] nvarchar(150) NULL,
[Level] int NOT NULL
)

GO

-- import danych z pliku CSV do tabeli
BULK INSERT #Accounts_Import 
  FROM 'C:\Users\marci\OneDrive\Dokumenty\GitHub\sulmar-tpa-sql\samples-data\Szkolenie_Accounts.csv'
  WITH (FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', FIRSTROW = 2, CODEPAGE = '65001')


GO



insert into Accounts 
	select 1 as TenantId, Symbol, [Name], [Level] from #Accounts_Import


update Accounts
	set Symbol = '0' + Symbol
where
	len(symbol) = 2 

select * from Accounts

GO

-- dodanie kolumny ParentId
ALTER TABLE Accounts
	ADD ParentId int null

GO


-- Aktualizacja kolumny ParentId

;WITH
CTE_ParentSymbol
AS (SELECT AccountId, Symbol, LEFT(Symbol, LEN(Symbol)-CHARINDEX('-', REVERSE(Symbol))) AS ParentSymbol FROM Accounts
  WHERE Level > 1),
CTE_ParentChild
AS (SELECT Parent.AccountId AS ParentId, Parent.Symbol AS ParentSymbol, Child.Symbol, Child.AccountId FROM CTE_ParentSymbol AS Child
 INNER JOIN Accounts AS Parent
 ON Parent.Symbol = Child.ParentSymbol)

 UPDATE Accounts
 SET Accounts.ParentId = CTE_ParentChild.ParentId
 FROM CTE_ParentChild
 INNER JOIN Accounts
 ON Accounts.AccountId = CTE_ParentChild.AccountId

 SELECT * FROM Accounts

 UPDATE Accounts
 SET Accounts.ParentId  = null



