USE [PART0]
GO
/****** Object:  StoredProcedure [SK_F2_BULK].[F2_IMP_LIMITI_DOPA]    Script Date: 06/02/2018 10:21:53 ******/
IF EXISTS (SELECT *
             FROM sys.objects
            WHERE OBJECT_ID = OBJECT_ID(N'[SK_F2_BULK].[F2_IMP_LIMITI_DOPA]')
              AND TYPE IN (N'P', N'RF', N'PC'))
BEGIN
    DROP PROCEDURE SK_F2_BULK.F2_IMP_LIMITI_DOPA;
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ********************************************************************************************************************************
CREATE PROCEDURE SK_F2_BULK.F2_IMP_LIMITI_DOPA
@outputNum int OUTPUT, @outputMsg nvarchar(500) OUTPUT
WITH EXEC AS CALLER
AS
BEGIN    
	DECLARE @dataRif date
	DECLARE @id int
	DECLARE @sndg nvarchar(20)
	DECLARE @colore nvarchar(15)
	DECLARE @blocco char(1)
	DECLARE @soglia nvarchar(20)



-- [SK_F2].[F2_T_LogErrori]
-- [SK_F2].[F2_T_ALERT_LIMITI_DOPA]
-- [SK_F2_BULK].[F2_IMPORT_LIMITI_DOPA]


    SET @outputNum = 0
    SET @outputMsg = 'OK'

    BEGIN TRANSACTION;

    BEGIN TRY

	-- Seleziono record da elaborare
	-- ultimi inseriti in area stage
	DECLARE  LIMITI_CUR CURSOR FOR
		SELECT ID
			  ,SNDG
			  ,COLORE
			  ,BLOCCO
			  ,SOGLIA
			  ,DATA_RIF
		  FROM SK_F2_BULK.F2_IMPORT_LIMITI_DOPA
		  WHERE DATA_RIF = (select max(DATA_RIF) FROM SK_F2_BULK.F2_IMPORT_LIMITI_DOPA)
		  		
		OPEN LIMITI_CUR
		FETCH NEXT FROM LIMITI_CUR
		INTO @id,@sndg,@colore,@blocco,@soglia,@dataRif
		 WHILE (@@FETCH_STATUS = 0)
			BEGIN
			INSERT INTO [SK_F2].[F2_T_ALERT_LIMITI_DOPA]
					   ([SNDG]
					   ,[COLORE]
					   ,[BLOCCO]
					   ,[SOGLIA]
					   ,[DATA_RIF])
				 VALUES
					   (@sndg
					   ,CASE 
							WHEN @blocco = '1' THEN 'R'
							WHEN @colore = 'rosso' AND @blocco = '0' THEN 'R'
							WHEN  @colore = 'verde' AND @blocco = '0'THEN 'V'
							WHEN  @colore = 'giallo' AND @blocco = '0' THEN 'G'
							WHEN  @colore = 'nero' AND @blocco = '0'THEN 'R'
					    END
					   ,CONVERT(bit,@blocco)
					   ,convert(decimal(20,3),@soglia)
					   ,@dataRif)
			FETCH NEXT FROM LIMITI_CUR
				INTO @id,@sndg,@colore,@blocco,@soglia,@dataRif
			END

    END TRY
    BEGIN CATCH

    SET @outputNum = -1
    SELECT @outputMsg = CONCAT('Errore elaborazione id record: ',@id,'--',ERROR_MESSAGE() )

    IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;
    END CATCH;

    IF @@TRANCOUNT > 0
      COMMIT TRANSACTION;

  END
GO


  -- ********************************************************************************************************************************
