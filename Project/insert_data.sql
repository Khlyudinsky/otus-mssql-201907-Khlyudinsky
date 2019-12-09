DECLARE @CltID pkey,
        @LicID  pkey,
	@AddressID pkey,
	@ContactID pkey,
	@OrgUnitID pkey,
	@TypeDocID int,
	@TypeAddressID int,
	@TypeContactID int,
        @ParentID pkey,
	@RetVal  int 

EXEC Org.tOrganizationUnitInsert @Name = N'ОАО "Банковская организация"', @ParentID = 0, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Департамент корпоративного бизнеса', @ParentID = 1, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Департамент малого и среднего бизнеса', @ParentID = 1, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Департамент технологического развития бизнеса', @ParentID = 1, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Инвестиционный департамент', @ParentID = 1, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Бухгалтерия', @ParentID = 1, @ObjectID=@OrgUnitID OUTPUT

EXEC Org.tEmployeeInsert 
	@TabNumber = '233',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 1,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '233',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 2,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT


SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Департамент корпоративного бизнеса'
EXEC Org.tOrganizationUnitInsert @Name = N'Управление корпоративного кредитования', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '233',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 3,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

EXEC Org.tOrganizationUnitInsert @Name = N'Управление сервиса и развития продаж', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел факторинга', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '234',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 4,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

EXEC Org.tOrganizationUnitInsert @Name = N'Служба информационного обслуживания клиентов', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '236',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 5,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT


SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Управление сервиса и развития продаж'
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел рекламы', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT


SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Департамент технологического развития бизнеса'
EXEC Org.tOrganizationUnitInsert @Name = N'Управление автоматизированных банковских систем', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '256',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 6,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

EXEC Org.tOrganizationUnitInsert @Name = N'Отдел дистанционного банковского обслуживания', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '2324',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 7,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

EXEC Org.tOrganizationUnitInsert @Name = N'Отдел инфраструктуры', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел сопровождения прикладных систем', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '143',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 8,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

EXEC Org.tOrganizationUnitInsert @Name = N'Отдел эквайринга', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '546',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 9,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Управление автоматизированных банковских систем'
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел банковских систем', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел систем банковских карт', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT

SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Инвестиционный департамент'
EXEC Org.tOrganizationUnitInsert @Name = N'Управление операций на фондовом рынке', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Казначейство', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT

SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Управление операций на фондовом рынке'
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел брокерских операций', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел операций по доверительному управлению', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел собственных торговых операций', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT

SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Казначейство'
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел ведения позиций и регулирования ликвидности', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел мониторинга финансовых операций', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел операций на денежных и валютных рынках', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT

SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Бухгалтерия'
EXEC Org.tOrganizationUnitInsert @Name = N'Управление сводно-аналитической и статистической отчетности', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Управление финансовой отчетности по российским и международным стандартам', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел внутренней бухгалтерии', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '5233',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 10,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

EXEC Org.tOrganizationUnitInsert @Name = N'Отдел учета активно-пассивных операций', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '766',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 11,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT
EXEC Org.tEmployeeInsert 
	@TabNumber = '7733',
	@OrganizationUnitID  = @OrgUnitID,
	@ClientID = 12,
	@StatusID =2, 
	@ObjectID = @EmplID OUTPUT

SELECT @ParentID = OrganizationUnitID From Org.tOrganizationUnit Where Name = N'Управление финансовой отчетности по российским и международным стандартам'

EXEC Org.tOrganizationUnitInsert @Name = N'Отдел консолидированной финансовой отчетности', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT
EXEC Org.tOrganizationUnitInsert @Name = N'Отдел сводной отчетности', @ParentID = @ParentID, @ObjectID=@OrgUnitID OUTPUT

--------------------------------------------------------------------------------------------------------------

EXEC @RetVal = dbo.tclientInsert 
		@Brief      = N'Пушкин А.С.', 
	    @SecondName = N'Пушкин', 
	    @FirstName  = N'Александр', 
	    @MiddleName = N'Сергеевич',
	    @BirthDate  = '1799-06-06',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '1298',
	    @Number        = '216760',
	    @Organization  = N'ОТДЕЛОМ УФМС РОССИИ ПО ГОР. МОСКВЕ ПО РАЙОНУ ОРЕХОВО-БОРИСОВО ЮЖНОЕ',
	    @DateStart     = '20150312',
	    @DopNumber     = '770-040',
        @ObjectID      = @LicID OUTPUT	

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 123060, Москва г, , , , Маршала Рыбалко ул, 176, 1,',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79050630223',
        @ObjectID      = @ContactID OUTPUT	
SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Email'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = 'pushkin@mail.ru',
        @ObjectID      = @ContactID OUTPUT	

--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
		@Brief      = N'Достоевский Ф.М.', 
	    @SecondName = N'Достоевский', 
	    @FirstName  = N'Федор', 
	    @MiddleName = N'Михайлович',
	    @BirthDate  = '1821-11-11',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '4512',
	    @Number        = '384327',
	    @Organization  = N'Отделением по району Соколиная гора ОУФМС России по гор. Москве в ВАО',
	    @DateStart     = '20141123',
	    @DopNumber     = '770-040',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 353901, Краснодарский край, , Новороссийск г, , Портовая ул, 310, , офис 15',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Места регистрации'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 172124, Тверская обл, Кувшиновский р-н, , Лукино д, , 2, ,',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79870630674',
        @ObjectID      = @ContactID OUTPUT	
SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Email'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = 'dostoevsky.fm@gmail.com',
        @ObjectID      = @ContactID OUTPUT	

--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
		@Brief      = N'Лермонтов М.Ю.', 
	    @SecondName = N'Лермонтов', 
	    @FirstName  = N'Михаил', 
	    @MiddleName = N'Юрьевич',
	    @BirthDate  = '1814-10-15',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '2915',
	    @Number        = '352780',
	    @Organization  = N'Отделением по району Соколиная гора ОУФМС России по гор. Москве в ВАО',
	    @DateStart     = '20141123',
	    @DopNumber     = '770-040',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт иностранного гражданина'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = 'АС',
	    @Number        = '1513310',
	    @Organization  = N'MIA республика Таджикистан',
	    @DateStart     = '20090331',
	    @DopNumber     = '770-040',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 309502, Белгородская обл, , Старый Оскол г, , Королева мкр, 5, , 140',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Фактический'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 115093, Москва г, Дубининская ул, д. 394,',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79182308723',
        @ObjectID      = @ContactID OUTPUT	
SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Skype'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = 'M.Lermontov',
        @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
		@Brief      = N'Хайям О.', 
	    @SecondName = N'Хайям', 
	    @FirstName  = N'Омар', 
	    @BirthDate  = '1048-05-18',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT


SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт иностранного гражданина'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = 'АС',
	    @Number        = '1513310',
	    @Organization  = N'MIA IRAN',
	    @DateStart     = '20180427',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Места регистрации'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 109316, Москва г,Талалихина ул, д. 41, стр. 13,45',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Фактический'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 352812, Краснодарский край, Туапсинский р-н, , пансионата Гизельдере п, Центральная ул, 2, , 7',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79182308222',
        @ObjectID      = @ContactID OUTPUT	
SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Email'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = 'omar@hayam.com',
        @ObjectID      = @ContactID OUTPUT	

--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
		@Brief      = N'Фет А.А.', 
	    @SecondName = N'Фет', 
	    @FirstName  = N'Афанасий', 
	    @MiddleName = N'Афанасьевич',
	    @BirthDate  = '1820-12-05',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '2367',
	    @Number        = '385673',
	    @Organization  = N'Управлением внутренних дел Центрального округа гор.Новороссийска Краснодарского края',
	    @DateStart     = '20131121',
	    @DopNumber     = '440-041',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 111024, Москва г, Авиамоторная ул, д. 50, стр. 2, пом. I, комн. 6',
                @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79870630333',
                @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
		@Brief      = N'Толстой Л.Н.', 
	    @SecondName = N'Толстой', 
	    @FirstName  = N'Лев', 
	    @MiddleName = N'Николаевич',
	    @BirthDate  = '1828-09-09',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '4362',
	    @Number        = '578245',
	    @Organization  = N'ОТДЕЛОМ УФМС РОССИИ ПО ГОР. МОСКВЕ ПО РАЙОНУ ОРЕХОВО-БОРИСОВО ЮЖНОЕ',
	    @DateStart     = '20141002',
	    @DopNumber     = '350-452',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'Ясная Поляна, Крапивенский уезд, Тульская губерния, Российская империя',
        @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79576834516',
        @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
	    @Brief      = N'Грибоедов А.С.', 
	    @SecondName = N'Грибоедов', 
	    @FirstName  = N'Александр', 
	    @MiddleName = N'Сергеевич',
	    @BirthDate  = '1795-01-15',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '3315',
	    @Number        = '552550',
	    @Organization  = N'УВД ЛЕНИНСКОГО АДМИНИСТРАТИВНОГО ОКРУГА ГОРОДА ОМСКА',
	    @DateStart     = '20120228',
	    @DopNumber     = '570-064',
	    @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 394038, Воронежская обл, , Воронеж г, , Пионеров б-р, 1 В, , 134',
		@ObjectID      = @AddressID OUTPUT	

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Места регистрации'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'Краснодарский край, , Новороссийск г, , Портовая ул, 20, ,4',
        @ObjectID      = @AddressID OUTPUT	

SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79459790777',
        @ObjectID      = @ContactID OUTPUT	
SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Skype'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = 'Griboedov',
        @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
		@Brief      = N'Крылов И.А.', 
	    @SecondName = N'Крылов', 
	    @FirstName  = N'Иван', 
	    @MiddleName = N'Андреевич',
	    @BirthDate  = '1769-02-13',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '5632',
	    @Number        = '744564',
	    @Organization  = N'ТП №4 ОУФМС России по Московской обл. по городскому округк Коломна',
	    @DateStart     = '20030331',
	    @DopNumber     = '721-348',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Юридический'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 355031, Ставропольский край, , Ставрополь г, , Партизанская ул, 2, , 184',
                @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79175636228',
                @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
    	    @Brief      = N'Лесков Н.С.', 
	    @SecondName = N'Лесков', 
	    @FirstName  = N'Николай', 
	    @MiddleName = N'Семенович',
	    @BirthDate  = '1831-02-16',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '5431',
	    @Number        = '873214',
	    @Organization  = N'ОТДЕЛОМ МИЛИЦИИ БАЛАШИХИНСКОГО УВД МОСКОВСКОЙ ОБЛАСТИ',
	    @DateStart     = '20080425',
	    @DopNumber     = '561-321',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Юридический'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 361203, Кабардино-Балкарская Респ, , Терек г, , Ленина ул, 53, , 62',
                @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79054536351',
                @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
    	    @Brief      = N'Салтыков-Щедрин М.Е.', 
	    @SecondName = N'Салтыков-Щедрин', 
	    @FirstName  = N'Михаил', 
	    @MiddleName = N'Ефграфович',
	    @BirthDate  = '1826-01-27',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '9437',
	    @Number        = '568722',
	    @Organization  = N'Отделом внутренних дел Промышленного района города Ставрополя',
	    @DateStart     = '20101225',
	    @DopNumber     = '321-100',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 143072, Московская обл, Одинцовский р-н, , ВНИИССОК п, Рябиновая ул, 34, , 239',
                @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79024346573',
                @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
    	    @Brief      = N'Тургенев И.С.', 
	    @SecondName = N'Тургенев', 
	    @FirstName  = N'Иван', 
	    @MiddleName = N'Сергеевич',
	    @BirthDate  = '1818-11-09',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '7647',
	    @Number        = '357252',
	    @Organization  = N'Отделом УФМС России по Иркутской области в Октябрьском р-не гор.Иркутска',
	    @DateStart     = '20041120',
	    @DopNumber     = '331-121',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 144001, Московская обл, , Электросталь г, , Октябрьская ул, 5, , 81',
                @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79179278888',
                @ObjectID      = @ContactID OUTPUT	
--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
    	    @Brief      = N'Тютчев Ф.И.', 
	    @SecondName = N'Тютчев', 
	    @FirstName  = N'Федор', 
	    @MiddleName = N'Иванович',
	    @BirthDate  = '1803-12-05',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '5437',
	    @Number        = '975766',
	    @Organization  = N'ОТДЕЛОМ УФМС РОССИИ ПО ВОРОНЕЖСКОЙ ОБЛАСТИ В СОВЕТСКОМ РАЙОНЕ Г. ВОРОНЕЖА',
	    @DateStart     = '20141005',
	    @DopNumber     = '231-346',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 117638, Москва г, , , , Электролитный проезд, 16, 2, 67',
                @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79173346682',
                @ObjectID      = @ContactID OUTPUT	

--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tclientInsert 
    	    @Brief      = N'Чехов А.П.', 
	    @SecondName = N'Чехов', 
	    @FirstName  = N'Антон', 
	    @MiddleName = N'Павлович',
	    @BirthDate  = '1860-01-29',
	    @Comment    = '',
	    @ObjectID   = @CltID OUTPUT

SELECT @TypeDocID = TypeDocID FROM dbo.tTypeDoc (nolock) WHERE Name=N'Паспорт гражданина Российской Федерации'
EXEC @RetVal = dbo.tCltLicenseInsert 
	    @clientID = @CltID,
	    @TypeDocID     = @TypeDocID,
	    @Series        = '3478',
	    @Number        = '423561',
	    @Organization  = N'Крымским РОВД Краснодарского края',
	    @DateStart     = '20121205',
	    @DopNumber     = '245-231',
        @ObjectID      = @LicID OUTPUT			

SELECT @TypeAddressID = TypeAddressID FROM dbo.tTypeAddress (nolock) WHERE Name=N'Почтовый'
EXEC @RetVal = dbo.tCltAddressInsert 
		@clientID = @CltID,
		@TypeAddressID     = @TypeAddressID,
		@Address        = 'РОССИЯ, 140186, Московская обл, , Жуковский г, , Солнечная ул, 7, , 213',
                @ObjectID      = @AddressID OUTPUT	


SELECT @TypeContactID = TypeContactID FROM dbo.tTypeContact (nolock) WHERE ContactName=N'Сотовый телефон'
EXEC @RetVal = dbo.tCltContactInsert 
		@clientID = @CltID,
		@TypeContactID     = @TypeContactID,
		@Contact        = '+79276743555',
                @ObjectID      = @ContactID OUTPUT	

--------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tCltAddressUpdate 
		@CltAddressID = 7,
		@TypeAddressID  = 2,
		@Address        = 'РОССИЯ, 352812, Краснодарский край, Туапсинский р-н, , пансионат Гизельдере п, Центральная ул, 2, , 17',
		@Flag = 0
-------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tClientUpdate 
      @ClientID = 3,
      @Comment = 'писатель'

-------------------------------------------------------------------------------------------------------------
EXEC @RetVal = dbo.tCltLicenseUpdate 
		@CltLicenseID = 4,
		@Organization  = 'MIA республика Таджикистан!!!',
		@Comment = '2 визы'  
-------------------------------------------------------------------------------------------------------------
EXEC dbo.tCltContactUpdate  
        @CltContactID = 7,
	@Contact  = '+79182308223'
--------------------------------------------------------------------------------------------------------------
EXEC dbo.tCltContactDelete @CltContactID=7
--------------------------------------------------------------------------------------------------------------
EXEC dbo.tCltLicenseDelete @CltLicenseID = 4
--------------------------------------------------------------------------------------------------------------
EXEC dbo.tCltAddressDelete @CltAddressID = 7
--------------------------------------------------------------------------------------------------------------
EXEC dbo.tClientDelete @ClientID=1
--------------------------------------------------------------------------------------------------------------
EXEC dbo.tClientUpdate @ClientID=1, @IsDelete=0
--------------------------------------------------------------------------------------------------------------
SELECT * FROM org.vwEmployeeContact   
FOR SYSTEM_TIME AS OF '2019-12-08 T19:00:00' ;  

SELECT * FROM org.vwEmployeeContact   
FOR SYSTEM_TIME AS OF '2019-12-08 T20:00:00' ;  
--------------------------------------------------------------------------------------------------------------
SELECT Structure FROM org.vwOrganizationStruct
FOR SYSTEM_TIME AS OF '2019-12-08 T20:00:00'
ORDER BY hierarchy

