CREATE DATABASE Szkolenie
go
USE Szkolenie
--ALTER TABLE Accounts
--DROP CONSTRAINT FK_Account_Tenants_TenantId
--DROP TABLE Tenants
--DROP TABLE Accounts

CREATE TABLE Tenants(
TenantId int PRIMARY KEY IDENTITY(1,1),
[Name] nvarchar(128) NOT NULL,
DbName nvarchar(128) NOT NULL,
AccountingSystem nvarchar(128) NOT NULL
)

CREATE TABLE Accounts(
AccountId int PRIMARY KEY IDENTITY(1,1),
TenantId int NOT NULL,
Symbol varchar(128) NOT NULL,
[Name] nvarchar(150) NULL,
[Level] int NOT NULL
CONSTRAINT FK_Account_Tenants_TenantId FOREIGN KEY(TenantId) 
REFERENCES Tenants(TenantId)
)

GO

insert into Tenants
	values('TPA', 'TPADb', 'Demo')

