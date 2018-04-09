USE [PART0]
GO

/****** Object:  Table [SK_F2.F2_T_ALERT_LIMITI_DOPA]   
Tabella limiti DOPA - Semafori

 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*
Se tabella esiste la droppo

*/
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'SK_F2' 
                 AND  TABLE_NAME = 'F2_T_ALERT_LIMITI_DOPA'))
BEGIN
    DROP  TABLE SK_F2.F2_T_ALERT_LIMITI_DOPA
END
-- ************************************************************************************************************************
CREATE TABLE [SK_F2].[F2_T_ALERT_LIMITI_DOPA](
	[SNDG] [varchar](20) NOT NULL,
	[COLORE] [varchar](3) NULL,
	[BLOCCO] bit NULL,
	[SOGLIA] decimal(20,3) NULL,
	[DATA_RIF] [date] NOT NULL
)
GO
-- ************************************************************************************************************************	
ALTER TABLE [SK_F2].[F2_T_ALERT_LIMITI_DOPA]
ADD CONSTRAINT PK_ALERT_LIMITI_DOPA PRIMARY KEY CLUSTERED (SNDG,DATA_RIF);  
GO 
	
	