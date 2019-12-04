-- Для примера взял задачу - создание очереди, для отправки клиентам СМС-собщений.
 
--1. Включаем сервиc-брокер на базе, раздаем права
USE master
ALTER DATABASE WideWorldImporters
SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE; 

ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON;
ALTER AUTHORIZATION ON DATABASE::WideWorldImporters TO [sa];
GO

--2. Создаем типы сообщений
USE WideWorldImporters
CREATE MESSAGE TYPE ReqMessage VALIDATION=WELL_FORMED_XML;
CREATE MESSAGE TYPE AnsMessage VALIDATION=WELL_FORMED_XML; 

GO
--3. Создаем контракты - описываем кто инициатор, кто отвечает
CREATE CONTRACT HWContract
      (ReqMessage SENT BY INITIATOR,
       AnsMessage SENT BY TARGET
      );
GO
--4. Создаем очереди
CREATE QUEUE TargetQueueWWI;
CREATE QUEUE InitiatorQueueWWI;

GO
--5. Создаем сервис.
-- Прим. Сервис садится на очередь и оговаривает контракт, по которому он готов общаться.
CREATE SERVICE TargetService ON QUEUE TargetQueueWWI(HWContract);
CREATE SERVICE InitiatorService ON QUEUE InitiatorQueueWWI(HWContract);
GO

--6. Процедура создания сообщения в очередь
CREATE PROCEDURE Sales.InitSendSMS
	@Phone NVARCHAR(15),
	@Msg   NVARCHAR(255)  
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER,
	        @ReqMsg xml
	BEGIN TRAN 
	    SET @ReqMsg = '<Phone>'+@Phone+'</Phone>' + '<Msg>'+@Msg+'</Msg>'
		--Determine the Initiator Service, Target Service and the Contract 
		BEGIN DIALOG @InitDlgHandle
		FROM SERVICE InitiatorService
		TO SERVICE 'TargetService'
		ON CONTRACT	HWContract
		WITH ENCRYPTION=OFF; 

		--Send the Message
		SEND ON CONVERSATION @InitDlgHandle 
		MESSAGE TYPE ReqMessage	(@ReqMsg)
	COMMIT TRAN 
END
GO

--7. Процедура инициирующая отправку СМС
CREATE PROCEDURE Sales.SendSMS
AS
BEGIN
	DECLARE @xml XML,
	        @TargetDlgHandle UNIQUEIDENTIFIER,
	        @Phone NVARCHAR(15),
	        @Msg   NVARCHAR(255) 

	SELECT TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@xml = Message_Body
	FROM dbo.TargetQueueWWI
        -- Здесь должна быть связь с таблицей отправленных СМС сообщений по Conversation_Handle, чтобы повторно не обрабатывать
        -- одно и тоже сообщение, пока нет ответа от оператора, мы по нему не отправили ответ инициатору. 
	SET @Phone=@xml.value('Phone[1]','nvarchar(15)')
	SET @Msg = @xml.value('Msg[1]','nvarchar(255)')

---- Здесь должна быть запущена процедура отправки СМС с папаметрами из селекта ниже -------
     SELECT @Phone,@Msg,@TargetDlgHandle
--------------------------------------------------------------------------------------------	
END

--8. Процедура ответа инициатору, по результатам ответа полученного от СМС оператора
CREATE PROCEDURE Sales.AnsResultSendSMS
AS
BEGIN
	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER,
			@MessageType Sysname,
			@AnsMessage xml

	BEGIN TRAN; 
	------
	--TODO: Здесь запускаем процедуру, где получаем самый старый @TargetDlgHandle, по которым ответил сотовый оператор 
	-- с конечным статусом(например Доставлено,Недоставлено и т.д.). Сейчас прописал их константами. 
	  SELECT @AnsMessage=N'<Status>Доставлено</Status><Comment>NoComment</Comment>'
--	  SELECT @AnsMessage=N'<Status>Не доставлено</Status><Comment>Абонент вне зоны действия сети...</Comment>'
	  SELECT @TargetDlgHandle='C764BF9E-7B16-EA11-A429-88D7F6C4C32A';
	---------------------------------------------------------------------------------------------------------------
	
	--Receive message from Initiator
	  RECEIVE TOP(1)	@MessageType = Message_Type_Name
	  FROM dbo.TargetQueueWWI
 	  WHERE Conversation_Handle=@TargetDlgHandle; 
		
	-- Confirm and Send a reply
	  IF @MessageType='ReqMessage'
	  BEGIN
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE AnsMessage	(@AnsMessage);
		END CONVERSATION @TargetDlgHandle;
	  END 

	COMMIT TRAN;
END

--9. Процедура подтверждения получения ответа инициатором
CREATE PROCEDURE Sales.ConfirmSendSMS
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER,
		@xml xml,
		@Status NVARCHAR(20),
		@Comment NVARCHAR(255)
	BEGIN TRAN; 
		RECEIVE TOP(1)
			@InitiatorReplyDlgHandle=Conversation_Handle
			,@xml=Message_Body
		FROM dbo.InitiatorQueueWWI; 
		IF @InitiatorReplyDlgHandle IS NOT NULL
		  BEGIN
			END CONVERSATION @InitiatorReplyDlgHandle; 
			SET @Status=@xml.value('Status[1]','nvarchar(15)')
  			SET @Comment = @xml.value('Comment[1]','nvarchar(255)')
			SELECT @Status AS Status,@Comment AS Comment
          END  
	COMMIT TRAN; 
END



--10. Запуск процедур.
--Отправка собщения в очередь
EXEC Sales.InitSendSMS
	@Phone = N'+79029999998',
	@Msg = N'Тестовое сообщение'
--Инициируем отправку СМС
EXEC Sales.SendSMS
--Отправляем ответ инициатору
EXEC Sales.AnsResultSendSMS
--Получаем подтверждение от инициатора
EXEC Sales.ConfirmSendSMS

