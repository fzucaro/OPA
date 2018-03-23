/****** Object: Table [SK_F2_FLUSSI].[F2_T_EXP_FITP_OrganiSociali]   Script Date: 26/02/2018 12.21.15 ******/
USE [PART0];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE TABLE [SK_F2_FLUSSI].[F2_T_EXP_FITP_OrganiSociali] (
[Data_estrazione] date NOT NULL,
[ABI_Segnalante] nvarchar(5) NOT NULL,
[SNDG_Partecipata] nvarchar(16) NULL,
[Codice_Istituto] nvarchar(2) NOT NULL,
[Partita_IVA] nvarchar(16) NULL,
[Codice_UIC] nvarchar(16) NULL,
[Nominativo] nvarchar(150) NULL,
[Codice_Fiscale] nvarchar(16) NULL,
[Codice_Incarico] nvarchar(10) NULL,
[Codice_Organo] nvarchar(10) NULL,
[Flag_Designatore] char(1) NULL,
[Descrizione_Incarico] nvarchar(50) NULL,
[Descrizione_Organo] nvarchar(50) NULL,
[Flag_Scarto] int NOT NULL,
[Motivo_Scarto] nvarchar(2000) NULL,
[EsecutivoFitProper] char(1) NULL,
[Indipendenza] char(1) NULL,
[SNDG_Esponente] nvarchar(16) NULL,
[Codice_Macrocategoria] nvarchar(10) NULL,
[Descrizione_Macrocategoria] nvarchar(50) NULL,
[Data_Decorrenza_Esponente] nvarchar(8) NULL,
[Data_Fine_Esponente] nvarchar(8) NULL,
[Motivo_Cessazione_Esponente] nvarchar(250) NULL)
ON [PRIMARY]
WITH (DATA_COMPRESSION = NONE);
GO


