USE [PART0]
GO

/****** Object:  Table [SK_F2_FLUSSI].[F2_T_EXP_PattiParasociali]    Script Date: 07/12/2017 15:48:06 ******/
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
                 WHERE TABLE_SCHEMA = 'SK_F2_FLUSSI' 
                 AND  TABLE_NAME = 'F2_T_EXP_PattiParasociali'))
BEGIN
    DROP  TABLE SK_F2_FLUSSI.F2_T_EXP_PattiParasociali
END
-- ************************************************************************************************************************
CREATE TABLE [SK_F2_FLUSSI].[F2_T_EXP_PattiParasociali](
	[Data_estrazione] [date] NOT NULL,
	[ABI_Segnalante] [nvarchar](5) NOT NULL,
	[SNDG_Partecipata] [nvarchar](16) NULL,
	[Codice_Istituto] [nvarchar](2) NOT NULL,
	[Partita_IVA] [nvarchar](16) NULL,
	[Codice_UIC] [nvarchar](16) NULL,
	[Cod_TipologiaPatto] [nvarchar](20) NULL,
	[Perc_Totale] [decimal](10, 3) NULL,
	[Ragione_Sociale] [nvarchar](max) NULL,
	[Flag_Scarto] [int] NOT NULL,
	[Motivo_Scarto] [nvarchar](2000) NULL
	)
-- ************************************************************************************************************************	
	
	