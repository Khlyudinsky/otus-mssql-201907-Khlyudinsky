/*Домашнее задание
Используем DDL
Начало проектной работы.
Создание таблиц и представлений для своего проекта.
Нужно используя операторы DDL создать:
1. 3-4 основные таблицы для своего проекта.
2. Первичные и внешние ключи для всех созданных таблиц
3. 1-2 индекса на таблицы
*/


CREATE DATABASE [WorkDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = test2, FILENAME = N'C:\Обучение\WorkDb.mdf', 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 65536KB )
 LOG ON 
( NAME = test2_log, FILENAME = N'C:\Обучение\WorkDb.ldf', 
	SIZE = 8MB , 
	MAXSIZE = 10GB , 
	FILEGROWTH = 65536KB )
GO

USE WorkDB
GO
-- Таблица клиентов физ.лиц (в ней же заносится информация о сотрудниках)
CREATE TABLE tInstitution
( 
  InstitutionID numeric(15,0) IDENTITY (1,1) CONSTRAINT PK_tInstitution PRIMARY KEY,
  Brief         varchar(20) NOT NULL,  -- Сокращенное наименование клиента
  Name          varchar(50) NOT NULL,  -- Фамилия
  Name1         varchar(50) NOT NULL,  -- Имя
  Name2         varchar(50),           -- Отчество
  BirthDate     date NOT NULL,         -- Дата рождения
  InstLicenseID numeric(15,0),         -- Связь с таблицей документов удостоверяющих личность
  InstAddressID numeric(15,0),         -- Связь с таблицей адресов
  Comment       varchar(255),          -- Примечание 
  CONSTRAINT CK_tInstitutionBirthDate CHECK (YEAR(BirthDate)>1920)
)

CREATE INDEX IX_tInstitution_Name ON tInstitution(Name)
CREATE INDEX IX_tInstitution_Brief ON tInstitution(Brief)

-- tEmployee  - Таблица сотрудники 
CREATE TABLE tEmployee
( 
  EmployeeID numeric(15,0) IDENTITY (1,1) CONSTRAINT PK_tEmployee PRIMARY KEY,
  InstitutionID numeric(15,0),     -- связь с таблицей tInstitution
  TabNumber  varchar(15) NOT NULL, -- Табельный номер
  OrganizationUnitID numeric(15,0),-- Cвязь с таблицей подразделений
  CONSTRAINT FK_tInstitution FOREIGN KEY (InstitutionID) REFERENCES tInstitution (InstitutionID)
)

CREATE INDEX IX_tEmployee_InstitutionID ON tEmployee(InstitutionID)

-- tEmployeeDate – Таблица с датами окончания и начала статусов (приема на работу, больничных, коммандировок, увольнения)
CREATE TABLE tEmployeeDate
(
  EmployeeDateID numeric(15,0) IDENTITY (1,1) CONSTRAINT PK_tEmployeeDate PRIMARY KEY,
  EmployeeID     numeric(15,0), -- связь с таблицей tEmployee
  DateStart      date,          -- Дата начала статуса,
  DateEnd        date,          -- Дата окончания,
  Status         tinyint,       --  (1-работает, 2- больничный,3 – коммандировка,0-уволен)
  CONSTRAINT FK_tEmployee FOREIGN KEY (EmployeeID) REFERENCES tEmployee (EmployeeID)
)

CREATE INDEX IX_tEmployeeDate_EmployeeID ON tEmployeeDate(EmployeeID)


