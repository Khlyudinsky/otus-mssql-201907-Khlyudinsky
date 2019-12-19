CREATE DATABASE [OtusDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bd', FILENAME = N'C:\Обучение\otus-mssql-201907-Khlyudinsky\Project\OtusDb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'bd_log', FILENAME = N'C:\Обучение\otus-mssql-201907-Khlyudinsky\Project\OtusDb.ldf' , SIZE = 8192KB , MAXSIZE = 10485760KB , FILEGROWTH = 65536KB )
GO
Use [OtusDb]
--------------------------------------------------------------------------------------------------
GO
CREATE SCHEMA Log
GO
CREATE SCHEMA Org
GO
--------------------------------------------------------------------------------------------------
CREATE TYPE Pkey FROM numeric(15,0);
--------------------------------------------------------------------------------------------------
GO
CREATE TABLE Dbo.tClient ( 
	ClientID        pkey NOT NULL   IDENTITY,
	Brief                nvarchar(20) NOT NULL   ,
	SecondName           nvarchar(50) NOT NULL   ,
	FirstName            nvarchar(50) NOT NULL   ,
	MiddleName           nvarchar(50)    ,
	BirthDate            date NOT NULL   ,
	Comment              nvarchar(255)    ,
	IsDelete             tinyint    ,
	CONSTRAINT Pk_tClient_ClientID PRIMARY KEY  ( ClientID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица клиентов физ.лиц (в ней же заносится информация о сотрудниках)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'сокращенное наименование клиента' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient', @level2type=N'COLUMN',@level2name=N'Brief';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Фамилия' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient', @level2type=N'COLUMN',@level2name=N'SecondName';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Имя' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient', @level2type=N'COLUMN',@level2name=N'FirstName';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Отчество' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient', @level2type=N'COLUMN',@level2name=N'MiddleName';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Дата рождения' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient', @level2type=N'COLUMN',@level2name=N'BirthDate';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Примечание' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient', @level2type=N'COLUMN',@level2name=N'Comment';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Признак удаления клиента (1 - клиент удален)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tClient', @level2type=N'COLUMN',@level2name=N'IsDelete';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeDoc ( 
	TypeDocID            int NOT NULL   ,
	Name                 nvarchar(100)    ,
	MaskSeries           nvarchar(30)    ,
	MaskNumber           nvarchar(150)    ,
	MaskDopNumber        nvarchar(150)    ,
	CONSTRAINT Pk_tTypeDoc_TypeDocID PRIMARY KEY  ( TypeDocID )
 );
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов документов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Название документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'Name';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'маска ввода серии документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskSeries';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'маска ввода номера документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дополнительный номер документа (например код подразделения в паспорте)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskDopNumber';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tCltLicense ( 
	CltLicenseID        pkey NOT NULL   IDENTITY,
	ClientID        pkey NOT NULL   ,
	TypeDocID            int  ,
	Series               nvarchar(10)    ,
	Number               nvarchar(50)    ,
	Organization         nvarchar(255)    ,
	DateStart            date   DEFAULT '19000101',
	DateEnd              date   DEFAULT '19000101',
	DopNumber            nvarchar(50)    ,
	Flag                 tinyint NOT NULL CONSTRAINT defo_tCltLicense_Flag DEFAULT 1  ,
	Comment              nvarchar(255)    ,
	CONSTRAINT Pk_tCltLicense_CltLicenseID PRIMARY KEY  ( CltLicenseID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица документов удостоверяющих личность и др.' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'ClientID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типов документов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'TypeDocID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'серия документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'Series';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'номер документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'Number';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'организация выдавшая документ' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'Organization';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дата начала действия документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'DateStart';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дата окончания действия документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'DateEnd';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дополнительный номер документа (например код подразделения в паспорте)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'DopNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'признак действия (1- действующий, 0 - недействующий)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'Flag';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Примечание' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltLicense', @level2type=N'COLUMN',@level2name=N'Comment';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeContact ( 
	TypeContactID        int NOT NULL   IDENTITY,
	ContactName          nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tTypeContact_TypeContactID PRIMARY KEY  ( TypeContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Наименование типа контакта' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact', @level2type=N'COLUMN',@level2name=N'ContactName';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tCltContact ( 
	CltContactID    pkey NOT NULL   IDENTITY,
	ClientID        pkey NOT NULL   ,
	TypeContactID        int  ,
	Contact              nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tCltContact_CltContactID PRIMARY KEY  ( CltContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Контактные данные клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltContact', @level2type=N'COLUMN',@level2name=N'ClientID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типы контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltContact', @level2type=N'COLUMN',@level2name=N'TypeContactID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'информация о контакте' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltContact', @level2type=N'COLUMN',@level2name=N'Contact';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeAddress ( 
	TypeAddressID        int NOT NULL   IDENTITY,
	Name                 nvarchar(50) NOT NULL   ,
	CONSTRAINT Pk_tTypeAddress_tTypeAddress PRIMARY KEY  ( TypeAddressID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeAddress';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Название типа адреса' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeAddress', @level2type=N'COLUMN',@level2name=N'Name';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tCltAddress ( 
	CltAddressID        pkey NOT NULL   IDENTITY,
	ClientID        pkey NOT NULL   ,
	Address              nvarchar(255) NOT NULL   ,
	TypeAddressID        int,
	Flag                 tinyint NOT NULL CONSTRAINT defo_tCltAddress_Flag DEFAULT 1  ,
	CONSTRAINT Pk_tCltAddress_CltAddressID PRIMARY KEY  ( CltAddressID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltAddress';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltAddress', @level2type=N'COLUMN',@level2name=N'ClientID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'адрес строкой' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltAddress', @level2type=N'COLUMN',@level2name=N'Address';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типов адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltAddress', @level2type=N'COLUMN',@level2name=N'TypeAddressID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'признак действия (1- действующий, 0 - недействующий)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tCltAddress', @level2type=N'COLUMN',@level2name=N'Flag';
--------------------------------------------------------------------------------------------------
CREATE TABLE Org.tStatus ( 
	StatusID             tinyint NOT NULL   IDENTITY,
	Description          nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tStatus_StatusID PRIMARY KEY  ( StatusID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Статусы сотрудников' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tStatus';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Описание статуса' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tStatus', @level2type=N'COLUMN',@level2name=N'Description';
--------------------------------------------------------------------------------------------------
CREATE TABLE Org.tOrganizationUnit ( 
	OrganizationUnitID   pkey NOT NULL   IDENTITY,
	ParentID             pkey    ,
	Name                 nvarchar(255) NOT NULL   ,
	SysStartDateTime     datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndDateTime       datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	CONSTRAINT Pk_tOrganizationUnit_OrganizationUnitID PRIMARY KEY  ( OrganizationUnitID ),
        PERIOD FOR SYSTEM_TIME (SysStartDateTime, SysEndDateTime)
)
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = Org.tOrganizationUnitHistory )
)
GO


exec sp_addextendedproperty  @name=N'MS_Description', @value=N'список подразделений - темпоральная' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tOrganizationUnit';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'вышестоящее подразделение' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'ParentID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Наименование подразделения' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'Name';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'SysStartDateTime';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'SysEndDateTime';
--------------------------------------------------------------------------------------------------
CREATE TABLE Org.tEmployee ( 
	EmployeeID           pkey NOT NULL   IDENTITY,
	TabNumber            nvarchar(15) NOT NULL   ,
	OrganizationUnitID   pkey    ,
	ClientID        pkey    ,
	StatusID             tinyint ,
	SysStartDateTime     datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndDateTime       datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	CONSTRAINT Pk_tEmployee_EmployeeID PRIMARY KEY  ( EmployeeID ),
	CONSTRAINT Unq_tEmployee_SysStartDateTime UNIQUE ( SysStartDateTime ), 
    PERIOD FOR SYSTEM_TIME (SysStartDateTime, SysEndDateTime)
)
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = Org.tEmployeeHistory )
)
GO

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица сотрудники' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Табельный номер' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'TabNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей подразделений' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'OrganizationUnitID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей клиентов ФЛ' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'ClientID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей статусов' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'StatusID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysStartDateTime';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysEndDateTime';
--------------------------------------------------------------------------------------------------

ALTER TABLE Org.tEmployee ADD CONSTRAINT Fk_tEmployee_tClient FOREIGN KEY ( ClientID ) REFERENCES Dbo.tClient( ClientID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Org.tEmployee ADD CONSTRAINT Fk_tEmployee_tOrganizationUnit FOREIGN KEY ( OrganizationUnitID ) REFERENCES Org.tOrganizationUnit( OrganizationUnitID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tCltLicense ADD CONSTRAINT Fk_tCltLicense_tClient FOREIGN KEY ( ClientID ) REFERENCES Dbo.tClient( ClientID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tCltLicense ADD CONSTRAINT Fk_tCltLicense_tTypeDoc FOREIGN KEY ( TypeDocID ) REFERENCES Dbo.tTypeDoc( TypeDocID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tCltAddress ADD CONSTRAINT Fk_tCltAddress_tTypeAddress FOREIGN KEY ( TypeAddressID ) REFERENCES Dbo.tTypeAddress( TypeAddressID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tCltAddress ADD CONSTRAINT Fk_tCltAddress_tClient FOREIGN KEY ( ClientID ) REFERENCES Dbo.tClient( ClientID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tCltContact ADD CONSTRAINT Fk_tCltContact_tClient FOREIGN KEY ( ClientID ) REFERENCES Dbo.tClient( ClientID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tCltContact ADD CONSTRAINT Fk_tCltContact_tTypeContact FOREIGN KEY ( TypeContactID ) REFERENCES Dbo.tTypeContact( TypeContactID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Org.tEmployee ADD CONSTRAINT Fk_tEmployee_tStatus FOREIGN KEY ( StatusID ) REFERENCES Org.tStatus( StatusID ) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE UNIQUE NONCLUSTERED INDEX [Idx_tClient_Brief] ON [dbo].[tClient] ([Brief])
CREATE UNIQUE NONCLUSTERED INDEX [Idx_tClient_FIO_BirthDate] ON [dbo].[tClient] ([SecondName],[FirstName],[MiddleName],[BirthDate])
CREATE NONCLUSTERED INDEX [Idx_tCltLicense_Series_Number] ON [dbo].[tCltLicense] ([Series],[Number])

CREATE TABLE Log.tAudit ( 
	AuditID              pkey NOT NULL   IDENTITY,
	ObjectID             pkey NOT NULL   ,
        ActionID             tinyint  NOT NULL   ,  
        ObjectName           nvarchar(50),
        UserName             nvarchar(50),
	SysDateTime          datetime2  ,
	Comment              nvarchar(4000)
	CONSTRAINT Pk_tAudit_AuditID PRIMARY KEY  ( AuditID )
 );
CREATE NONCLUSTERED INDEX [Idx_tAudit_SysDateTime] ON [Log].[tAudit] ([SysDateTime])
CREATE NONCLUSTERED INDEX [Idx_tAudit_ObjectID] ON [Log].[tAudit] ([ObjectID])

CREATE TABLE Log.tAction ( 
	ActionID             tinyint NOT NULL   IDENTITY,
	Brief                nvarchar(20)   ,
	Comment              nvarchar(255)
	CONSTRAINT Pk_tAction_ActionID PRIMARY KEY  ( ActionID )
 );
GO
ALTER TABLE Log.tAudit ADD CONSTRAINT Fk_tAudit_tAction FOREIGN KEY ( ActionID ) REFERENCES Log.tAction( ActionID );
----------------------------------------------------------------------------------------------------------------------------
-- Создание процедур
----------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE log.tAuditInsert
    @ObjectID             pkey,
    @Action               nVarchar(20),  
    @ObjectName           nvarchar(50),
    @Comment              nvarchar(255)    
AS
DECLARE @RetVal int = 0,
        @ActionID tinyint 
SET NOCOUNT ON;

SELECT @ActionID = ActionID 
FROM log.tAction (nolock) 
WHERE Brief = @Action 

  BEGIN TRY
    INSERT Log.tAudit (ObjectID,ActionID,ObjectName,UserName,SysDateTime,Comment) 
    VALUES (@ObjectID,@ActionID,@ObjectName,Suser_Name(),SysDateTime(),@Comment) 
  END TRY
  BEGIN CATCH
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tClientInsert
	@Brief                nvarchar(20),
	@SecondName           nvarchar(50),
	@FirstName            nvarchar(50),
	@MiddleName           nvarchar(50) = NULL,
	@BirthDate            date,
	@Comment              nvarchar(255) = NULL,
	@ObjectID             nvarchar(255) OUTPUT
       
AS
DECLARE @RetVal int = 0

SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT dbo.tClient (Brief,SecondName,FirstName,MiddleName,BirthDate,Comment) 
    VALUES (@Brief,@SecondName,@FirstName,@MiddleName,@BirthDate,@Comment) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
	         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tClient',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltLicenseInsert
	@ClientID        pkey,
	@TypeDocID            int = NULL,
	@Series               nvarchar(10) = NULL,
	@Number               nvarchar(50) = NULL,
	@Organization         nvarchar(255) = NULL,
	@DateStart            date = '19000101',
	@DateEnd              date = '19000101',
	@DopNumber            nvarchar(50) = NULL,
	@Flag                 tinyint = 1,
	@Comment              nvarchar(255) = NULL,
	@ObjectID             pkey OUTPUT
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT dbo.tCltLicense(ClientID,TypeDocID,Series,Number,Organization,DateStart,DateEnd,DopNumber,Flag,Comment) 
    VALUES (@ClientID,@TypeDocID,@Series,@Number,@Organization,@DateStart,@DateEnd,@DopNumber,@Flag,@Comment) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
	         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tCltLicense',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO

-----------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltAddressInsert
	@ClientID        pkey,
	@TypeAddressID        int,
	@Address              nvarchar(255),
	@Flag                 tinyint = 1,
	@ObjectID             pkey OUTPUT
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT dbo.tCltAddress(ClientID,TypeAddressID,Address,Flag) 
    VALUES (@ClientID,@TypeAddressID,@Address,@Flag) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
	         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tCltAddress',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
-----------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltContactInsert
	@ClientID        pkey,
	@TypeContactID        int,
	@Contact              nvarchar(100),
	@ObjectID             pkey OUTPUT
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT dbo.tCltContact(ClientID,TypeContactID,Contact) 
    VALUES (@ClientID,@TypeContactID,@Contact) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tCltContact',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
---------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltAddressUpdate
	@CltAddressID        pkey,
	@TypeAddressID        int = NULL,
	@Address              nvarchar(255) = NULL,
	@Flag                 tinyint = NULL
AS
DECLARE @RetVal int = 0,
        @AuditComment nvarchar(4000)
SET NOCOUNT ON;

SELECT @AuditComment = 'TypeAddressID = ' + ISNULL(CONVERT(VARCHAR(10),TypeAddressID),'NULL') +', Address = ' + ISNULL(Address,'NULL') + ', Flag = ' + ISNULL(CONVERT(VARCHAR(1),Flag),'NULL') 
FROM dbo.tCltAddress
WHERE CltAddressID = @CltAddressID
  BEGIN TRY
    BEGIN TRANSACTION
    UPDATE dbo.tCltAddress 
	  SET TypeAddressID = isnull(@TypeAddressID,TypeAddressID), 
              Address = isnull(@Address,Address), 
              Flag = isnull(@Flag,Flag) 
    WHERE CltAddressID = @CltAddressID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @CltAddressID,
		 @Action = N'Изменить',
		 @ObjectName = 'tCltAddress',
		 @Comment = @AuditComment
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tClientUpdate
    @ClientID             pkey,
	@Brief                nvarchar(20) = NULL,
	@SecondName           nvarchar(50) = NULL,
	@FirstName            nvarchar(50) = NULL,
	@MiddleName           nvarchar(50) = NULL,
	@BirthDate            date = NULL,
	@Comment              nvarchar(255) = NULL,
	@IsDelete             tinyint = NULL
AS
DECLARE @RetVal int = 0,
        @AuditComment nvarchar(4000)
SET NOCOUNT ON;

SELECT @AuditComment = 'Brief = ' + ISNULL(Brief,'NULL') +', SecondName = ' + ISNULL(SecondName,'NULL') + ', FirstName ' + ISNULL(FirstName,'NULL') + ', MiddleName ' + ISNULL(MiddleName,'NULL')  + ', BirthDate = ' + ISNULL(CONVERT(VARCHAR(10),BirthDate),'NULL') 

FROM dbo.tClient
WHERE ClientID = @ClientID
  BEGIN TRY
    BEGIN TRANSACTION
    UPDATE dbo.tClient
	  SET Brief = isnull(@Brief,Brief), 
              SecondName = isnull(@SecondName,SecondName), 
              FirstName = isnull(@FirstName,FirstName), 
              MiddleName = isnull(@MiddleName,MiddleName),
              BirthDate = isnull(@BirthDate,BirthDate),
              Comment = isnull(@Comment,Comment),
              IsDelete = isnull(@IsDelete,IsDelete)
    WHERE ClientID = @ClientID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @ClientID,
		 @Action = N'Изменить',
		 @ObjectName = 'tClient',
		 @Comment = @AuditComment
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltLicenseUpdate
	@CltLicenseID        pkey,
	@TypeDocID            int = NULL,
	@Series               nvarchar(10) = NULL,
	@Number               nvarchar(50) = NULL,
	@Organization         nvarchar(255) = NULL,
	@DateStart            date = NULL,
	@DateEnd              date = NULL,
	@DopNumber            nvarchar(50) = NULL,
	@Flag                 tinyint = NULL,
	@Comment              nvarchar(255) = NULL   
AS
DECLARE @RetVal int = 0,
        @AuditComment nvarchar(4000)
SET NOCOUNT ON;

SELECT @AuditComment = 'TypeDocID = ' + 
       ISNULL(CONVERT(VARCHAR(10),TypeDocID),'NULL') +
	   ', Series = ' + ISNULL(Series,'NULL') + 
	   ', Number = ' + ISNULL(Number,'NULL') + 
	   ', Organization = ' + ISNULL(Organization,'NULL') + 
	   ', DateStart = ' + ISNULL(CONVERT(VARCHAR(10),DateStart),'NULL') + 
	   ', DateEnd = ' + ISNULL(CONVERT(VARCHAR(10),DateEnd),'NULL') + 
	   ', DopNumber = ' + ISNULL(DopNumber,'NULL') + 
	   ', Series = ' + ISNULL(Series,'NULL') +
	   ', Flag = ' + ISNULL(CONVERT(VARCHAR(1),Flag),'NULL') 
FROM dbo.tCltLicense
WHERE CltLicenseID = @CltLicenseID
  BEGIN TRY
    BEGIN TRANSACTION
    UPDATE dbo.tCltLicense
	  SET TypeDocID = isnull(@TypeDocID,TypeDocID), 
            Series = isnull(@Series,Series), 
            Number = isnull(@Number,Number), 
            Organization = isnull(@Organization,Organization), 
            DateStart = isnull(@DateStart,DateStart), 
            DateEnd = isnull(@DateEnd,DateEnd), 
            DopNumber = isnull(@DopNumber,DopNumber), 
            Comment = isnull(@Comment,Comment), 
            Flag = isnull(@Flag,Flag) 
    WHERE CltLicenseID = @CltLicenseID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @CltLicenseID,
		 @Action = N'Изменить',
		 @ObjectName = 'tCltLicense',
		 @Comment = @AuditComment
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltContactUpdate
	@CltContactID        pkey,
	@TypeContactID        int = NULL,
	@Contact              nvarchar(100) = NULL
AS
DECLARE @RetVal int = 0,
        @AuditComment nvarchar(4000)
SET NOCOUNT ON;

SELECT @AuditComment = 'TypeContactID = ' + ISNULL(CONVERT(VARCHAR(10),TypeContactID),'NULL') +', Contact = ' + ISNULL(Contact,'NULL')
FROM dbo.tCltContact
WHERE CltContactID = @CltContactID
  BEGIN TRY
    BEGIN TRANSACTION
    UPDATE dbo.tCltContact 
	  SET TypeContactID = isnull(@TypeContactID,TypeContactID), 
          Contact = isnull(@Contact,Contact) 
    WHERE CltContactID = @CltContactID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @CltContactID,
		 @Action = N'Изменить',
		 @ObjectName = 'tCltContact',
		 @Comment = @AuditComment
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltContactDelete
	@CltContactID        pkey
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION
    DELETE dbo.tCltContact  WHERE CltContactID = @CltContactID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @CltContactID,
		 @Action = N'Удалить',
		 @ObjectName = 'tCltContact',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltAddressDelete
	@CltAddressID        pkey
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION
    DELETE dbo.tCltAddress  WHERE CltAddressID = @CltAddressID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @CltAddressID,
		 @Action = N'Удалить',
		 @ObjectName = 'tCltAddress',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tCltLicenseDelete
	@CltLicenseID        pkey
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION
    DELETE dbo.tCltLicense  WHERE CltLicenseID = @CltLicenseID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @CltLicenseID,
		 @Action = N'Удалить',
		 @ObjectName = 'tCltLicense',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.tClientDelete
	@ClientID        pkey
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION
    UPDATE dbo.tClient  SET IsDelete = 1 WHERE ClientID = @ClientID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @ClientID,
		 @Action = N'Удалить',
		 @ObjectName = 'tClient',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
----------------------------------------------------------------------------------
CREATE PROCEDURE Org.tOrganizationUnitInsert
	@ParentID             pkey   = NULL ,
	@Name                 nvarchar(255),
	@ObjectID             pkey OUTPUT
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT Org.tOrganizationUnit(ParentID,Name) 
    VALUES (@ParentID,@Name) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tOrganizationUnit',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
----------------------------------------------------------------------------------
CREATE PROCEDURE Org.tEmployeeInsert
	@TabNumber            nvarchar(15),
	@OrganizationUnitID   pkey,
	@ClientID             pkey,
	@StatusID             tinyint, 
	@ObjectID            pkey OUTPUT
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT Org.tEmployee(TabNumber,OrganizationUnitID,ClientID,StatusID) 
    VALUES (@TabNumber,@OrganizationUnitID,@ClientID,@StatusID) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tEmployee',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
---------------------------------------------------------------------------------
CREATE VIEW org.vwEmployeeContact
AS   
SELECT o.Name,
       c.Brief,
       isnull(cc.Contact,'') as Contact
FROM org.tEmployee e
  JOIN dbo.tClient c ON e.ClientID = c.ClientID
  JOIN org.tOrganizationUnit o ON o.OrganizationUnitID = e.OrganizationUnitID
  LEFT JOIN dbo.tCltContact cc ON cc.ClientID = e.ClientID
  LEFT JOIN dbo.tTypeContact tc ON tc.TypeContactID = cc.TypeContactID
WHERE isnull(tc.ContactName,N'Сотовый телефон') = N'Сотовый телефон'
------------------------------------------------------------------------
GO
CREATE VIEW org.vwOrganizationStruct
AS   
WITH OUnit AS
(
  SELECT OrganizationUnitID, Name, 1 AS level,ParentID,CONVERT(VARCHAR(8000), 0) + ' ' AS hierarchy
  FROM org.tOrganizationUnit
  WHERE ParentID = 0
  UNION ALL
  SELECT o.OrganizationUnitID, o.Name, Level + 1,o.ParentID,hierarchy + ' ' + CONVERT(VARCHAR(15),o.ParentID) + ' ' + CONVERT(VARCHAR(15),o.OrganizationUnitID)
  FROM org.tOrganizationUnit o
    JOIN OUnit ou ON o.ParentID=ou.OrganizationUnitID
)
SELECT Level,
       OrganizationUnitID,
       ParentID, 
       REPLICATE ('     ',Level - 1) + Name AS Structure,
	   hierarchy
FROM OUnit
------------------------------------------------------------------------
-----------------------------------------------------------------------------------
GO
CREATE PROCEDURE org.tOrganizationUnitDelete
	@OrganizationUnitID        pkey
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION
    DELETE org.tOrganizationUnit WHERE OrganizationUnitID = @OrganizationUnitID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @OrganizationUnitID,
		 @Action = N'Удалить',
		 @ObjectName = 'tOrganizationUnit',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO

CREATE PROCEDURE org.tEmployeeDelete
	@EmployeeID        pkey
AS
DECLARE @RetVal int = 0
SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION
    DELETE org.tEmployee WHERE EmployeeID = @EmployeeID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @EmployeeID,
		 @Action = N'Удалить',
		 @ObjectName = 'tEmployee',
		 @Comment = ''
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
----------------------------------------------------------------------------------
CREATE PROCEDURE org.tOrganizationUnitUpdate
	@OrganizationUnitID   pkey,
	@ParentID             pkey = NULL,
	@Name                 nvarchar(255) = NULL
AS
DECLARE @RetVal int = 0,
        @AuditComment nvarchar(4000)
SET NOCOUNT ON;

SELECT @AuditComment = 'ParentID = ' + ISNULL(CONVERT(VARCHAR(10),ParentID),'NULL') +', Name = ' + ISNULL(Name,'NULL')
FROM org.tOrganizationUnit
WHERE OrganizationUnitID = @OrganizationUnitID
  BEGIN TRY
    BEGIN TRANSACTION
    UPDATE org.tOrganizationUnit
	  SET ParentID = isnull(@ParentID,ParentID), 
          Name = isnull(@Name,Name) 
    WHERE OrganizationUnitID = @OrganizationUnitID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @OrganizationUnitID,
		 @Action = N'Изменить',
		 @ObjectName = 'tOrganizationUnit',
		 @Comment = @AuditComment
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO
-------------------------------------------------------------------------------
CREATE PROCEDURE org.tEmployeeUpdate
	@EmployeeID   pkey,
	@TabNumber     nvarchar(15) = NULL,
	@OrganizationUnitID pkey = NULL,
	@ClientID      pkey = NULL,
	@StatusID      tinyint = NULL
AS
DECLARE @RetVal int = 0,
        @AuditComment nvarchar(4000)
SET NOCOUNT ON;

SELECT @AuditComment = 'TabNumber = ' + ISNULL(TabNumber,'NULL') +
                       ', OrganizationUnitID = ' + ISNULL(CONVERT(VARCHAR(10),OrganizationUnitID),'NULL') + 
                       ', ClientID = ' + ISNULL(CONVERT(VARCHAR(10),ClientID),'NULL') + 
                       ', StatusID = ' + ISNULL(CONVERT(VARCHAR(10),StatusID),'NULL') 
FROM org.tEmployee
WHERE EmployeeID = @EmployeeID
  BEGIN TRY
    BEGIN TRANSACTION
    UPDATE org.tEmployee
	  SET TabNumber = isnull(@TabNumber,TabNumber), 
          OrganizationUnitID = isnull(@OrganizationUnitID,OrganizationUnitID),
		  ClientID = isnull(@ClientID,ClientID),
		  StatusID = isnull(@StatusID,StatusID)
    WHERE EmployeeID = @EmployeeID
	IF @@rowcount > 0
	  EXEC @RetVal = log.tAuditInsert 
	     @ObjectID = @EmployeeID,
		 @Action = N'Изменить',
		 @ObjectName = 'tEmployee',
		 @Comment = @AuditComment
    IF @RetVal <> 0
      ROLLBACK TRANSACTION;
    ELSE
      COMMIT;    
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION
    SET @RetVal=ERROR_NUMBER()
  END CATCH
Return @RetVal
GO




----------------------------------------------------------------------------------------------------------------------------
-- Заполнение БД
-----------------------------------------------------------------------------------------------------------------------------
Insert Log.tAction (Brief) VALUES (N'Добавить')
Insert Log.tAction (Brief) VALUES (N'Удалить')
Insert Log.tAction (Brief) VALUES (N'Изменить')

--exec dbo.tClientInsert N'Пушкин А.С.', N'Пушкин', N'Александр', N'Сергеевич','1799-06-06',''


Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (3,N'Свидетельство о рождении','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (7,N'Военный билет','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (8,N'Временное удостоверение, выданное взамен военного билета','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (10,N'Паспорт иностранного гражданина','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (11,N'Свидетельство о рассмотрении ходатайства о признании лица беженцем на территории РФ по существу','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (12,N'Вид на жительство в Российской Федерации','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (13,N'Удостоверение беженца','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (15,N'Разрешение на временное проживание в Российской Федерации','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (18,N'Свидетельство о предоставлении временного убежища на территории Российской Федерации','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (21,N'Паспорт гражданина Российской Федерации','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (23,N'Свидетельство о рождении, выданное уполномоченным органом иностранного государства','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (24,N'Удостоверение личности военнослужащего Российской Федерации','%','%','%')
Insert Dbo.tTypeDoc (TypeDocID,Name,MaskSeries,MaskNumber,MaskDopNumber) Values (91,N'Иные документы','%','%','%')

Insert Dbo.tTypeAddress (Name) Values (N'Почтовый')
Insert Dbo.tTypeAddress (Name) Values (N'Юридический')
Insert Dbo.tTypeAddress (Name) Values (N'Фактический')
Insert Dbo.tTypeAddress (Name) Values (N'Места регистрации')

Insert Dbo.tTypeContact (ContactName) Values (N'Email')
Insert Dbo.tTypeContact (ContactName) Values (N'Сотовый телефон')
Insert Dbo.tTypeContact (ContactName) Values (N'Домашний телефон')
Insert Dbo.tTypeContact (ContactName) Values (N'Факс')
Insert Dbo.tTypeContact (ContactName) Values (N'Skype')

Insert Org.tStatus (Description) Values (N'Уволен')
Insert Org.tStatus (Description) Values (N'Работает')
Insert Org.tStatus (Description) Values (N'Болеет')
Insert Org.tStatus (Description) Values (N'Коммандировка')
Insert Org.tStatus (Description) Values (N'Отпуск')
-------------------------------------------------------------------------------------

