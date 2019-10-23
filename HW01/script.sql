CREATE TABLE Dbo.tInstitution ( 
	InstitutionID        numeric(15,0) NOT NULL   IDENTITY,
	Brief                nvarchar(20) NOT NULL   ,
	Name                 nvarchar(50) NOT NULL   ,
	Name1                nvarchar(50) NOT NULL   ,
	Name2                nvarchar(50)    ,
	BirthDate            date NOT NULL   ,
	Comment              nvarchar(255)    ,
	CONSTRAINT Pk_tInstitution_InstitutionID PRIMARY KEY  ( InstitutionID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица клиентов физ.лиц (в ней же заносится информация о сотрудниках)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'сокращенное наименование клиента' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'Brief';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Фамилия' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'Name';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Имя' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'Name1';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Отчество' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'Name2';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Дата рождения' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'BirthDate';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Примечание' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstitution', @level2type=N'COLUMN',@level2name=N'Comment';

---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tEmployee ( 
	EmployeeID           numeric(15,0) NOT NULL   IDENTITY,
	TabNumber            nvarchar(15) NOT NULL   ,
	OrganizationUnitID   numeric(15,0)    ,
	InstitutionID        numeric(15,0)    ,
	Status               int NOT NULL CONSTRAINT defo_tEmployee_Status DEFAULT 1  ,
	SysStartDateTime         datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndDateTime           datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
        PERIOD FOR SYSTEM_TIME (SysStartDateTime,SysEndDateTime),
	CONSTRAINT Pk_tEmployee_EmployeeID PRIMARY KEY  ( EmployeeID )
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=Dbo.tEmployeeHistory));

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица сотрудники' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Табельный номер' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'TabNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей подразделений' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'OrganizationUnitID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Связь с таблицей клиентов ФЛ' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'1-работает, 2- больничный,3 – коммандировка,0-уволен' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'Status';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysStartDateTime';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tEmployee', @level2type=N'COLUMN',@level2name=N'SysEndDateTime';

---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tOrganizationUnit ( 
	OrganizationUnitID   numeric(15,0) NOT NULL   IDENTITY,
	ParentID             numeric(15,0)    ,
	Name                 nvarchar(100) NOT NULL   ,
	SysStartDateTime         datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndDateTime           datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
        PERIOD FOR SYSTEM_TIME (SysStartDateTime,SysEndDateTime),
	CONSTRAINT Pk_tOrganizationUnit_OrganizationUnitID PRIMARY KEY  ( OrganizationUnitID )
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=Dbo.tOrganizationUnitHistory));

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'список подразделений - темпоральная' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'вышестоящее подразделение' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'ParentID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Наименование подразделения' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'Name';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'SysStartDateTime';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'поле обеспечивающе темпоральность' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tOrganizationUnit', @level2type=N'COLUMN',@level2name=N'SysEndDateTime';
---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tInstLicense ( 
	InstLicenseID        numeric(15,0) NOT NULL   IDENTITY,
	InstitutionID        numeric(15,0) NOT NULL   ,
	TypeDocID            numeric(15,0) NOT NULL   ,
	Series               nvarchar(10)    ,
	Number               nvarchar(50)    ,
	Organization         nvarchar(100)    ,
	DateStart            date    ,
	DateEnd              date    ,
	DopNumber1           nvarchar(50)    ,
	Flag                 int NOT NULL CONSTRAINT defo_tInstLicense_Flag DEFAULT 1  ,
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

---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeDoc ( 
	TypeDocID            numeric(15,0) NOT NULL   ,
	Name                 nvarchar(50)    ,
	MaskSeries           nvarchar(30)    ,
	MaskNumber           nvarchar(50)    ,
	MaskDopNumber1       nvarchar(30)    ,
	CONSTRAINT Pk_tTypeDoc_TypeDocID PRIMARY KEY  ( TypeDocID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов документов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Название документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'Name';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'маска ввода серии документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskSeries';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'маска ввода номера документа' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskNumber';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'дополнительный номер документа (например код подразделения в паспорте)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeDoc', @level2type=N'COLUMN',@level2name=N'MaskDopNumber1';
---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tInstAddress ( 
	InstAddressID        numeric(15,0) NOT NULL   IDENTITY,
	InstitutionID        numeric(15,0) NOT NULL   ,
	Address              nvarchar(255) NOT NULL   ,
	TypeAddressID        numeric(15,0) NOT NULL   ,
	Flag                 int NOT NULL CONSTRAINT defo_tInstAddress_Flag DEFAULT 1  ,
	CONSTRAINT Pk_tInstAddress_InstAddressID PRIMARY KEY  ( InstAddressID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Таблица адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'адрес строкой' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'Address';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типов адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'TypeAddressID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'признак действия (1- действующий, 0 - недействующий)' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstAddress', @level2type=N'COLUMN',@level2name=N'Flag';

---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeAddress ( 
	TypeAddressID        numeric(15,0) NOT NULL   IDENTITY,
	Name                 nvarchar(50) NOT NULL   ,
	CONSTRAINT Pk_tTypeAddress_tTypeAddress PRIMARY KEY  ( TypeAddressID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов адресов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeAddress';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Название типа адреса' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeAddress', @level2type=N'COLUMN',@level2name=N'Name';
---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tInstContact ( 
	InstContactID        numeric(15,0) NOT NULL   IDENTITY,
	InstitutionID        numeric(15,0) NOT NULL   ,
	TypeContactID        numeric(15,0) NOT NULL   ,
	Contact              nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tInstContact_InstContactID PRIMARY KEY  ( InstContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Контактные данные клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей клиентов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'InstitutionID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'связь с таблицей типы контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'TypeContactID';
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'информация о контакте' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tInstContact', @level2type=N'COLUMN',@level2name=N'Contact';

---------------------------------------------------------------------------------------------
CREATE TABLE Dbo.tTypeContact ( 
	TypeContactID        numeric(15,0) NOT NULL   IDENTITY,
	ContactName          nvarchar(100) NOT NULL   ,
	CONSTRAINT Pk_tTypeContact_TypeContactID PRIMARY KEY  ( TypeContactID )
 );

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Справочник типов контактов' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact';;
exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Наименование типа контакта' , @level0type=N'SCHEMA',@level0name=N'Dbo', @level1type=N'TABLE',@level1name=N'tTypeContact', @level2type=N'COLUMN',@level2name=N'ContactName';
----------------------------------------------------------------------------------------------
ALTER TABLE Dbo.tEmployee ADD CONSTRAINT Fk_tEmployee_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Dbo.tEmployee ADD CONSTRAINT Fk_tEmployee_tOrganizationUnit FOREIGN KEY ( OrganizationUnitID ) REFERENCES Dbo.tOrganizationUnit( OrganizationUnitID ) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Dbo.tInstLicense ADD CONSTRAINT Fk_tInstLicense_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Dbo.tInstLicense ADD CONSTRAINT Fk_tInstLicense_tTypeDoc FOREIGN KEY ( TypeDocID ) REFERENCES Dbo.tTypeDoc( TypeDocID ) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Dbo.tInstAddress ADD CONSTRAINT Fk_tInstAddress_tTypeAddress FOREIGN KEY ( TypeAddressID ) REFERENCES Dbo.tTypeAddress( TypeAddressID ) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Dbo.tInstAddress ADD CONSTRAINT Fk_tInstAddress_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Dbo.tInstContact ADD CONSTRAINT Fk_tInstContact_tInstitution FOREIGN KEY ( InstitutionID ) REFERENCES Dbo.tInstitution( InstitutionID ) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Dbo.tInstContact ADD CONSTRAINT Fk_tInstContact_tTypeContact FOREIGN KEY ( TypeContactID ) REFERENCES Dbo.tTypeContact( TypeContactID ) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE UNIQUE NONCLUSTERED INDEX [Idx_tInstitution_Brief] ON [dbo].[tInstitution] ([Brief])
CREATE UNIQUE NONCLUSTERED INDEX [Idx_tInstitution_FIO_BirthDate] ON [dbo].[tInstitution] ([Name],[Name1],[Name2],[BirthDate])
CREATE UNIQUE NONCLUSTERED INDEX [Idx_tInstLicense_Series_Number] ON [dbo].[tInstLicense] ([Series],[Number])