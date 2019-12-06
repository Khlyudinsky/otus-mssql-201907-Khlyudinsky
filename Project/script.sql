CREATE DATABASE [OtusDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bd', FILENAME = N'C:\Обучение\OtusDb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'bd_log', FILENAME = N'C:\Обучение\OtusDb.ldf' , SIZE = 8192KB , MAXSIZE = 10485760KB , FILEGROWTH = 65536KB )
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
CREATE TABLE Dbo.tInstitution ( 
	InstitutionID        pkey NOT NULL   IDENTITY,
	Brief                nvarchar(20) NOT NULL   ,
	SecondName           nvarchar(50) NOT NULL   ,
	FirstName            nvarchar(50) NOT NULL   ,
	MiddleName           nvarchar(50)    ,
	BirthDate            date NOT NULL   ,
	Comment              nvarchar(255)    ,
	IsDelete             tinyint    ,
	CONSTRAINT Pk_tInstitution_InstitutionID PRIMARY KEY  ( InstitutionID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица клиентов физ.лиц (в ней же заносится информация о сотрудниках)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'сокращенное наименование клиента' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'Brief';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Фамилия' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'SecondName';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Имя' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'FirstName';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Отчество' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'MiddleName';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Дата рождения' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'BirthDate';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Примечание' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'Comment';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Признак удаления клиента (1 - клиент удален)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'IsDelete';
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
CREATE TABLE Dbo.tInstLicense ( 
	InstLicenseID        pkey NOT NULL   IDENTITY,
	InstitutionID        pkey NOT NULL   ,
	TypeDocID            int  ,
	Series               nvarchar(10)    ,
	Number               nvarchar(50)    ,
	Organization         nvarchar(255)    ,
	DateStart            date   DEFAULT '19000101',
	DateEnd              date   DEFAULT '19000101',
	DopNumber            nvarchar(50)    ,
	Flag                 tinyint NOT NULL CONSTRAINT defo_tInstLicense_Flag DEFAULT 1  ,
	Comment              nvarchar(255)    ,
	CONSTRAINT Pk_tInstLicense_InstLicenseID PRIMARY KEY  ( InstLicenseID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица документов удостоверяющих личность и др.' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типов документов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'TypeDocID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'серия документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'Series';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'номер документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'Number';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'организация выдавшая документ' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'Organization';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дата начала действия документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'DateStart';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дата окончания действия документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'DateEnd';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дополнительный номер документа (например код подразделения в паспорте)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'DopNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'признак действия (1- действующий, 0 - недействующий)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'Flag';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Примечание' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'Comment';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeContact ( 
	TypeContactID        int NOT NULL   IDENTITY,
	ContactName          nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tTypeContact_TypeContactID PRIMARY KEY  ( TypeContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Наименование типа контакта' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact', @level2type=N'COLUMN',@level2name=N'ContactName';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tInstContact ( 
	InstContactID        int NOT NULL   IDENTITY,
	InstitutionID        pkey NOT NULL   ,
	TypeContactID        int  ,
	Contact              nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tInstContact_InstContactID PRIMARY KEY  ( InstContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Контактные данные клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типы контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'TypeContactID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'информация о контакте' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'Contact';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeAddress ( 
	TypeAddressID        int NOT NULL   IDENTITY,
	Name                 nvarchar(50) NOT NULL   ,
	CONSTRAINT Pk_tTypeAddress_tTypeAddress PRIMARY KEY  ( TypeAddressID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeAddress';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Название типа адреса' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeAddress', @level2type=N'COLUMN',@level2name=N'Name';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tInstAddress ( 
	InstAddressID        pkey NOT NULL   IDENTITY,
	InstitutionID        pkey NOT NULL   ,
	Address              nvarchar(255) NOT NULL   ,
	TypeAddressID        int,
	Flag                 tinyint NOT NULL CONSTRAINT defo_tInstAddress_Flag DEFAULT 1  ,
	CONSTRAINT Pk_tInstAddress_InstAddressID PRIMARY KEY  ( InstAddressID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'адрес строкой' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'Address';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типов адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'TypeAddressID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'признак действия (1- действующий, 0 - недействующий)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'Flag';
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
	InstitutionID        pkey    ,
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
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей клиентов ФЛ' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей статусов' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'StatusID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysStartDateTime';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Org', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysEndDateTime';
--------------------------------------------------------------------------------------------------

ALTER TABLE Org.tEmployee ADD CONSTRAINT Fk_tEmployee_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Org.tEmployee ADD CONSTRAINT Fk_tEmployee_tOrganizationUnit FOREIGN KEY ( OrganizationUnitID ) REFERENCES Org.tOrganizationUnit( OrganizationUnitID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstLicense ADD CONSTRAINT Fk_tInstLicense_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstLicense ADD CONSTRAINT Fk_tInstLicense_tTypeDoc FOREIGN KEY ( TypeDocID ) REFERENCES Dbo.tTypeDoc( TypeDocID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstAddress ADD CONSTRAINT Fk_tInstAddress_tTypeAddress FOREIGN KEY ( TypeAddressID ) REFERENCES Dbo.tTypeAddress( TypeAddressID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstAddress ADD CONSTRAINT Fk_tInstAddress_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstContact ADD CONSTRAINT Fk_tInstContact_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstContact ADD CONSTRAINT Fk_tInstContact_tTypeContact FOREIGN KEY ( TypeContactID ) REFERENCES Dbo.tTypeContact( TypeContactID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Org.tEmployee ADD CONSTRAINT Fk_tEmployee_tStatus FOREIGN KEY ( StatusID ) REFERENCES Org.tStatus( StatusID ) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE UNIQUE NONCLUSTERED INDEX [Idx_tInstitution_Brief] ON [dbo].[tInstitution] ([Brief])
CREATE UNIQUE NONCLUSTERED INDEX [Idx_tInstitution_FIO_BirthDate] ON [dbo].[tInstitution] ([SecondName],[FirstName],[MiddleName],[BirthDate])
CREATE NONCLUSTERED INDEX [Idx_tInstLicense_Series_Number] ON [dbo].[tInstLicense] ([Series],[Number])

CREATE TABLE Log.tAudit ( 
	AuditID              pkey NOT NULL   IDENTITY,
	ObjectID             pkey NOT NULL   ,
        ActionID             tinyint  NOT NULL   ,  
        ObjectName           nvarchar(50),
        UserName             nvarchar(50),
	SysDateTime          datetime2  ,
	Comment              nvarchar(255)
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
CREATE PROCEDURE dbo.tInstitutionInsert
	@Brief                nvarchar(20),
	@SecondName           nvarchar(50),
	@FirstName            nvarchar(50),
	@MiddleName           nvarchar(50),
	@BirthDate            date,
	@Comment              nvarchar(255),
	@ObjectID             nvarchar(255) OUTPUT
       
AS
DECLARE @RetVal int = 0

SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT dbo.tInstitution (Brief,SecondName,FirstName,MiddleName,BirthDate,Comment) 
    VALUES (@Brief,@SecondName,@FirstName,@MiddleName,@BirthDate,@Comment) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
	         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tInstitution',
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
CREATE PROCEDURE dbo.tInstLicenseInsert
	@InstitutionID        pkey,
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
    INSERT dbo.tInstLicense(InstitutionID,TypeDocID,Series,Number,Organization,DateStart,DateEnd,DopNumber,Flag,Comment) 
    VALUES (@InstitutionID,@TypeDocID,@Series,@Number,@Organization,@DateStart,@DateEnd,@DopNumber,@Flag,@Comment) 
    SET @ObjectID = SCOPE_IDENTITY()
    EXEC @RetVal = log.tAuditInsert 
	         @ObjectID = @ObjectID,
		 @Action = N'Добавить',
		 @ObjectName = 'tInstLicense',
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




----------------------------------------------------------------------------------------------------------------------------
-- Заполнение БД
-----------------------------------------------------------------------------------------------------------------------------
Insert Log.tAction (Brief) VALUES (N'Добавить')
Insert Log.tAction (Brief) VALUES (N'Удалить')
Insert Log.tAction (Brief) VALUES (N'Изменить')

--exec dbo.tInstitutionInsert N'Пушкин А.С.', N'Пушкин', N'Александр', N'Сергеевич','1799-06-06',''


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

GO
DECLARE @InstID pkey,
        @LicID  pkey,
		@Address pkey,
		@TypeDocID int,
		@TypeAddressID int,
		@InstContactID int,
		@RetVal  int 

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
SELECT @InstContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'

EXEC @RetVal = dbo.tInstitutionInsert 
		@Brief      = N'Пушкин А.С.', 
	    @SecondName = N'Пушкин', 
	    @FirstName  = N'Александр', 
	    @MiddleName = N'Сергеевич',
	    @BirthDate  = '1799-06-06',
	    @Comment    = '',
	    @ObjectID   = @InstID OUTPUT
IF @RetVal = 0 
  BEGIN
    EXEC @RetVal = dbo.tInstLicenseInsert 
	        @InstitutionID = @InstID,
	        @TypeDocID     = @TypeDocID,
	        @Series        = '12 98',
	        @Number        = '384327',
	        @Organization  = N'ОВД по г.Москва',
	        @DateStart     = '20141123',
	        @DopNumber     = '324-001',
        	@ObjectID      = @LicID OUTPUT			
			
  END
