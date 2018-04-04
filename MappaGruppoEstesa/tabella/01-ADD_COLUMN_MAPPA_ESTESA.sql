IF EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'tipo_persona'
          AND Object_ID = Object_ID(N'SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa'))
BEGIN
    ALTER TABLE SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
    DROP COLUMN tipo_persona
END

ALTER TABLE SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
   ADD tipo_persona char(2)
GO
IF EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'flagGruppo'
          AND Object_ID = Object_ID(N'SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa'))
BEGIN
    ALTER TABLE SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
    DROP COLUMN flagGruppo
END

ALTER TABLE SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
   ADD flagGruppo bit
