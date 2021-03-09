WITH CTE_OstatnieIdKontrahentow 
AS 
(SELECT MAX(ID) AS maxID,Nazwa
				FROM [UIRE_KS].[dbo].[DaneKontrahentow]
				GROUP BY Nazwa),
CTE_KolejnePodzapytanie 
AS
(SELECT daneKontr.ID, daneKontr.Nazwa, daneKontr.AdresKodKraju
			FROM [UIRE_KS].[dbo].[DaneKontrahentow] AS daneKontr
			INNER JOIN
				CTE_OstatnieIdKontrahentow AS daneKonMaxId
			ON daneKontr.ID = daneKonMaxId.maxID),
CTE_NeverEndingStoryyyy
AS
(SELECT kontr.ID, kontr.Nazwa, latestContractorData.AdresKodKraju
		FROM [UIRE_KS].[dbo].[Kontrahenci] AS kontr
		INNER JOIN
			CTE_KolejnePodzapytanie AS latestContractorData
		ON kontr.Nazwa = latestContractorData.Nazwa),
CTE_NextStep
AS
(SELECT dokEwid.ID, dokEwid.Podmiot, latestContractor.Nazwa, latestContractor.AdresKodKraju
	FROM [UIRE_KS].[dbo].[DokEwidencja] AS dokEwid
	LEFT JOIN
		CTE_NeverEndingStoryyyy AS latestContractor
	ON dokEwid.Podmiot = latestContractor.ID),
CTE_StayinAlive
AS
(SELECT 
dziennik.Data,
dziennik.NumerPelny AS NumerDekretu,
dziennik.NumerDokumentu,
dziennik.NumerEwidencji,
zapKsie.Opis,
Konta.Symbol,
Konta.Nazwa,
CASE zapKsie.Strona
	WHEN 1 THEN zapKsie.KwotaOperacjiValue
	ELSE 0
END AS Winien,
CASE zapKsie.Strona
	WHEN 2 THEN zapKsie.KwotaOperacjiValue
	ELSE 0
END AS Ma,
zapKsie.KwotaOperacjiSymbol AS Waluta,
dokEwidencji.Nazwa AS Kontrahent,
dokEwidencji.AdresKodKraju AS KodKraju
FROM [UIRE_KS].[dbo].[Dziennik] AS dziennik
INNER JOIN [UIRE_KS].[dbo].[ZapisyKsiegowe] AS zapKsie
ON dziennik.ID = zapKsie.Dekret
INNER JOIN [UIRE_KS].[dbo].[Konta]
ON Konta.ID = zapKsie.Konto
INNER JOIN
	CTE_NextStep AS dokEwidencji
ON dziennik.Ewidencja = dokEwidencji.ID
WHERE zapKsie.Typ = 1
AND dziennik.Typ = 1)

SELECT * 
FROM CTE_StayinAlive 
WHERE CTE_StayinAlive.Data 
BETWEEN 
'2020-01-01 00:00:00.000' AND '2020-01-31 00:00:00.000'