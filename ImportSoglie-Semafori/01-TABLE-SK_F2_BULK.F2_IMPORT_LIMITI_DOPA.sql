USE [PART0]
GO

/****** Object:  Table [SK_F2_BULK.F2_IMPORT_LIMITI_DOPA]   
Tabella STAGE per import limiti DOPA - Semafori

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
                 WHERE TABLE_SCHEMA = 'SK_F2_BULK' 
                 AND  TABLE_NAME = 'F2_IMPORT_LIMITI_DOPA'))
BEGIN
    DROP  TABLE SK_F2_BULK.F2_IMPORT_LIMITI_DOPA
END
-- ************************************************************************************************************************
CREATE TABLE [SK_F2_BULK].[F2_IMPORT_LIMITI_DOPA](
	[ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SNDG] [nvarchar](20) NULL,
	[COLORE] [nvarchar](15) NULL,
	[BLOCCO] [char](1) NULL,
	[SOGLIA] [nvarchar](20) NULL,
	[DATA_RIF] [date] NULL
)
GO
-- ************************************************************************************************************************	
ALTER TABLE [SK_F2_BULK].[F2_IMPORT_LIMITI_DOPA] ADD  CONSTRAINT [DF_SK_F2_BULK.F2_IMPORT_LIMITI_DOPA_DATA_RIF]  DEFAULT (getdate()) FOR [DATA_RIF]
GO
	
	