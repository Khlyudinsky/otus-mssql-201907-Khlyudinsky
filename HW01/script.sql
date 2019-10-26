CREATE DATABASE [OtusDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bd', FILENAME = N'C:\Обучение\OtusDb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'bd_log', FILENAME = N'C:\Обучение\OtusDb.ldf' , SIZE = 8192KB , MAXSIZE = 10485760KB , FILEGROWTH = 65536KB )
GO
Use [OtusDb]
--------------------------------------------------------------------------------------------------
CREATE TYPE Pkey FROM numeric(15,0);
--------------------------------------------------------------------------------------------------
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
	TypeDocID            pkey NOT NULL   ,
	Name                 nvarchar(100)    ,
	MaskSeries           nvarchar(30)    ,
	MaskNumber           nvarchar(150)    ,
	MaskDopNumber1       nvarchar(150)    ,
	CONSTRAINT Pk_tTypeDoc_TypeDocID PRIMARY KEY  ( TypeDocID )
 );
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов документов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Название документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'Name';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'маска ввода серии документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskSeries';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'маска ввода номера документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дополнительный номер документа (например код подразделения в паспорте)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskDopNumber1';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tInstLicense ( 
	InstLicenseID        pkey NOT NULL   IDENTITY,
	InstitutionID        pkey NOT NULL   ,
	TypeDocID            pkey  ,
	Series               nvarchar(10)    ,
	Number               nvarchar(50)    ,
	Organization         nvarchar(255)    ,
	DateStart            date    ,
	DateEnd              date    ,
	DopNumber1           nvarchar(50)    ,
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
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дополнительный номер документа (например код подразделения в паспорте)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'DopNumber1';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'признак действия (1- действующий, 0 - недействующий)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'Flag';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Примечание' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstLicense', @level2type=N'COLUMN',@level2name=N'Comment';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeContact ( 
	TypeContactID        pkey NOT NULL   IDENTITY,
	ContactName          nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tTypeContact_TypeContactID PRIMARY KEY  ( TypeContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Наименование типа контакта' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact', @level2type=N'COLUMN',@level2name=N'ContactName';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tInstContact ( 
	InstContactID        pkey NOT NULL   IDENTITY,
	InstitutionID        pkey NOT NULL   ,
	TypeContactID        pkey  ,
	Contact              nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tInstContact_InstContactID PRIMARY KEY  ( InstContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Контактные данные клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типы контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'TypeContactID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'информация о контакте' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'Contact';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeAddress ( 
	TypeAddressID        pkey NOT NULL   IDENTITY,
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
	TypeAddressID        pkey   ,
	Flag                 tinyint NOT NULL CONSTRAINT defo_tInstAddress_Flag DEFAULT 1  ,
	CONSTRAINT Pk_tInstAddress_InstAddressID PRIMARY KEY  ( InstAddressID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'адрес строкой' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'Address';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типов адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'TypeAddressID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'признак действия (1- действующий, 0 - недействующий)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'Flag';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tStatus ( 
	StatusID             tinyint NOT NULL   IDENTITY,
	Description          nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tStatus_StatusID PRIMARY KEY  ( StatusID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Статусы сотрудников' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tStatus';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Описание статуса' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tStatus', @level2type=N'COLUMN',@level2name=N'Description';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tOrganizationUnit ( 
	OrganizationUnitID   pkey NOT NULL   IDENTITY,
	ParentID             pkey    ,
	Name                 nvarchar(255) NOT NULL   ,
	SysStartTime         datetime2    ,
	SysEndTime           datetime2    ,
	CONSTRAINT Pk_tOrganizationUnit_OrganizationUnitID PRIMARY KEY  ( OrganizationUnitID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'список подразделений - темпоральная' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'вышестоящее подразделение' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'ParentID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Наименование подразделения' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'Name';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'SysStartTime';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'SysEndTime';
--------------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tEmployee ( 
	EmployeeID           pkey NOT NULL   IDENTITY,
	TabNumber            nvarchar(15) NOT NULL   ,
	OrganizationUnitID   pkey    ,
	InstitutionID        pkey    ,
	StatusID             tinyint ,
	SysStartTime         datetime2    ,
	SysEndDateTime       datetime2    ,
	CONSTRAINT Pk_tEmployee_EmployeeID PRIMARY KEY  ( EmployeeID ),
	CONSTRAINT Unq_tEmployee_SysStartTime UNIQUE ( SysStartTime ) 
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица сотрудники' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Табельный номер' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'TabNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей подразделений' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'OrganizationUnitID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей клиентов ФЛ' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей статусов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'StatusID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysStartTime';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysEndDateTime';
--------------------------------------------------------------------------------------------------

ALTER TABLE Dbo.tEmployee ADD CONSTRAINT Fk_tEmployee_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tEmployee ADD CONSTRAINT Fk_tEmployee_tOrganizationUnit FOREIGN KEY ( OrganizationUnitID ) REFERENCES Dbo.tOrganizationUnit( OrganizationUnitID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstLicense ADD CONSTRAINT Fk_tInstLicense_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstLicense ADD CONSTRAINT Fk_tInstLicense_tTypeDoc FOREIGN KEY ( TypeDocID ) REFERENCES Dbo.tTypeDoc( TypeDocID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstAddress ADD CONSTRAINT Fk_tInstAddress_tTypeAddress FOREIGN KEY ( TypeAddressID ) REFERENCES Dbo.tTypeAddress( TypeAddressID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstAddress ADD CONSTRAINT Fk_tInstAddress_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstContact ADD CONSTRAINT Fk_tInstContact_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Dbo.tInstContact ADD CONSTRAINT Fk_tInstContact_tTypeContact FOREIGN KEY ( TypeContactID ) REFERENCES Dbo.tTypeContact( TypeContactID ) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Dbo.tEmployee ADD CONSTRAINT Fk_tEmployee_tStatus FOREIGN KEY ( StatusID ) REFERENCES Dbo.tStatus( StatusID ) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE UNIQUE NONCLUSTERED INDEX [Idx_tInstitution_Brief] ON [dbo].[tInstitution] ([Brief])
CREATE UNIQUE NONCLUSTERED INDEX [Idx_tInstitution_FIO_BirthDate] ON [dbo].[tInstitution] ([SecondName],[FirstName],[MiddleName],[BirthDate])
CREATE NONCLUSTERED INDEX [Idx_tInstLicense_Series_Number] ON [dbo].[tInstLicense] ([Series],[Number])