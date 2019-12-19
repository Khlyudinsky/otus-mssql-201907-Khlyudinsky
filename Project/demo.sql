USE [OtusDb]
--Таблица клиентов организации
SELECT [ClientID]
      ,[Brief]
      ,[SecondName]
      ,[FirstName]
      ,[MiddleName]
      ,[BirthDate]
      ,[Comment]
      ,[IsDelete]
  FROM [dbo].[tClient]

--Таблица организационной структуры компании
SELECT [OrganizationUnitID]
      ,[ParentID]
      ,[Name]
      ,[SysStartDateTime]
      ,[SysEndDateTime]
  FROM [Org].[tOrganizationUnit]

--Таблица сотрудников
SELECT * FROM [Org].[tEmployee]

-- Таблица с инф. по клиентам
SELECT * 
FROM [OtusDb].[dbo].[tClient] c
  LEFT JOIN [dbo].[tCltLicense] cl ON c.ClientID = cl.ClientID
  LEFT JOIN [dbo].[tTypeDoc] td ON td.TypeDocID = cl.TypeDocID
  LEFT JOIN [dbo].[tCltAddress] ca ON c.ClientID = ca.ClientID
  LEFT JOIN [dbo].[tTypeAddress] ta ON ta.TypeAddressID = ca.TypeAddressID
  LEFT JOIN [dbo].[tCltContact] cc ON c.ClientID = cc.ClientID
  LEFT JOIN [dbo].[tTypeContact] tc ON tc.TypeContactID = cc.TypeContactID

SELECT c.ClientID,c.brief,ca.CltAddressID,ca.Address,ta.TypeAddressID 
FROM [OtusDb].[dbo].[tClient] c
  LEFT JOIN [dbo].[tCltAddress] ca ON c.ClientID = ca.ClientID
  LEFT JOIN [dbo].[tTypeAddress] ta ON ta.TypeAddressID = ca.TypeAddressID
ORDER BY ca.CltAddressID

--РОССИЯ, 115093, Москва г, Дубининская ул, д. 394,
EXEC dbo.tCltAddressUpdate 
		@CltAddressID = 5,
		@TypeAddressID  = 2,
		@Address        = N'РОССИЯ, 352812, Краснодарский край, Туапсинский р-н, , пансионат Гизельдере п, Центральная ул, 2, , 17',
		@Flag = 0

SELECT * FROM log.tAudit ORDER BY AuditID DESC

EXEC dbo.tCltAddressDelete @CltAddressID = 7

SELECT * FROM log.tAudit ORDER BY AuditID DESC

-- Хайям О.
EXEC dbo.tClientUpdate 
      @ClientID = 4,
      @Brief = N'Омар Х.'


SELECT * FROM org.vwEmployeeContact   

-- Сделаем сотрудником А.П. Чехова
DECLARE @EmplID Pkey
EXEC Org.tEmployeeInsert 
	@TabNumber = '523',
	@OrganizationUnitID  = 20,  -- Казначейство
	@ClientID = 13,  -- Чехов А.П.
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

SELECT * FROM log.tAudit ORDER BY AuditID DESC

SELECT * FROM org.vwEmployeeContact   
FOR SYSTEM_TIME AS OF '2019-12-16 T17:40:00';  

SELECT * FROM org.tOrganizationUnit

EXEC org.tOrganizationUnitUpdate
      @OrganizationUnitID  = 1,
      @Name = N'АО "Банковская организация"'

SELECT [Level]
      ,[OrganizationUnitID]
      ,[ParentID]
      ,[Structure]
--      ,[hierarchy]
FROM [OtusDb].[Org].[vwOrganizationStruct]
FOR SYSTEM_TIME AS OF '2019-12-16 T11:20:00'
ORDER BY [hierarchy]



WITH PhoneBook AS
(
SELECT Structure AS Brief, 
       Hierarchy,
	   '' AS Phone
FROM org.vwOrganizationStruct v
UNION
SELECT REPLICATE ('     ',v.Level - 1) + '-> ' + c.Brief AS Brief,
       v.hierarchy,
	   cc.Contact
FROM org.tEmployee e
  JOIN dbo.tClient c ON e.ClientID = c.ClientID
  JOIN org.vwOrganizationStruct v ON e.OrganizationUnitID = v.OrganizationUnitID
  LEFT JOIN dbo.tCltContact cc ON cc.ClientID = e.ClientID
  LEFT JOIN dbo.tTypeContact tc ON tc.TypeContactID = cc.TypeContactID
WHERE isnull(tc.ContactName,N'Сотовый телефон') = N'Сотовый телефон'
)
SELECT Brief,Phone FROM PhoneBook
ORDER BY Hierarchy,Brief DESC
