
CREATE PROCEDURE UpdateParentId
AS
BEGIN

	WITH
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
END


EXECUTE UpdateParentId

GO

CREATE PROCEDURE RecalculateTrialBalance
(
	@Symbol varchar(max)
)
AS
BEGIN
	
	UPDATE [dbo].[TrialBalances]
		SET LastEntryDate = GETDATE()
	WHERE
		Symbol = @Symbol
END


EXEC RecalculateTrialBalance '010'




select * from  [dbo].[TrialBalances]
 


 GO
 

 CREATE PROCEDURE SalesbyYear
 (
	@Beginning_Date DATETIME,
	@Ending_Date DATETIME
 )
 AS
	SELECT * FROM [dbo].[TrialBalances]
		WHERE LastEntryDate between @Beginning_Date and @Ending_Date

GO


EXEC SalesbyYear '2020-01-01', '2020-03-01'

GO

CREATE OR ALTER PROCEDURE GetAccountsByName
(
	@Name nvarchar(150)
)
AS
SELECT * FROM [dbo].[Accounts]
	WHERE [Name] = @Name

GO


EXEC GetAccountsByName 'Kasa PLN'




