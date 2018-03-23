USE [PART0]
GO
/****** Object:  StoredProcedure [SK_F2_FLUSSI].[F2_EXP_PattiParasociali]    Script Date: 06/02/2018 10:21:53 ******/
IF EXISTS (SELECT *
             FROM sys.objects
            WHERE OBJECT_ID = OBJECT_ID(N'[SK_F2_FLUSSI].[F2_EXP_PattiParasociali]')
              AND TYPE IN (N'P', N'RF', N'PC'))
BEGIN
    DROP PROCEDURE SK_F2_FLUSSI.F2_EXP_PattiParasociali;
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ********************************************************************************************************************************
CREATE PROCEDURE [SK_F2_FLUSSI].[F2_EXP_PattiParasociali]
@dataEstrazione date, @abi char(5), @outputNum int OUTPUT, @outputMsg nvarchar(500) OUTPUT
WITH EXEC AS CALLER
AS
BEGIN
  declare @idSegnalante         int
  declare @sndgSegnalante       nvarchar(16)
  declare @contesto             nvarchar(2)
  declare @idOperazione         int
  declare @idPartecipata        int
  declare @pIVA                 nvarchar(16)
  declare @cFisc                nvarchar(16)
  declare @codUIC               nvarchar(16)
  declare @codTipoPatto         nvarchar(2)
  declare @flagScarto           bit
  declare @motivoScarto         nvarchar(2000)
  declare @sndgPartecipata      nvarchar(16)
  declare @esisteABI            int
  declare @percTotale           decimal(10,3)
  declare @ragioneSociale       nvarchar(max)

  set @outputNum = 0
 set @outputMsg = 'OK'

	BEGIN TRANSACTION;
  
  BEGIN TRY
  
  -- Verifico esistenza ABI 
  -- Da capire se serve
  SELECT @esisteABI = COUNT(*) FROM SK_F2.F2_D_Banche where ABI_BANCA = @abi
  IF @esisteABI > 0 
  BEGIN
    
      -- Se esiste già un'estrazione per la stessa data e la stessa segnalante,
      -- cancello i dati precedenti
      DELETE FROM SK_F2_FLUSSI.F2_T_EXP_CI_PattiParasociali
       WHERE Data_estrazione = @dataEstrazione
         AND ABI_Segnalante = @abi

      SELECT @idSegnalante = p.ID, @sndgSegnalante = p.SNDG, @contesto = b.CONT
        FROM SK_F2.F2_D_Banche b, SK_F2.F2_T_Persona p
       WHERE p.SNDG = b.SNDG_BANCA 
         AND b.ABI_BANCA = @abi
         AND p.Data_Fine IS NULL
           
      DECLARE Operazioni_CUR CURSOR FOR
      SELECT op.ID, op.ID_Persona, ISNULL(p.SNDG,'') as SNDG, 
             ltrim(rtrim(ISNULL(p.Partita_IVA,''))) as Partita_IVA, 
             ltrim(rtrim(ISNULL(p.Codice_Fiscale,''))) as Codice_Fiscale,
             ltrim(rtrim(ISNULL(pg.Codice_UIC,''))) as Codice_UIC ,
             ltrim(rtrim(pg.Ragione_Sociale)) as RagioneSociale
        FROM SK_F2.F2_T_Operazioni op, SK_F2.F2_T_Persona p, SK_F2.F2_T_Persona_Giuridica pg
        --,SK_F2.F2_T_Aderenti_Patto_Parasociale ader
       WHERE op.Data_Fine IS NULL
         AND op.ID_Tipo_Operazione = 'PP'
         AND p.ID = op.ID_Persona
         AND pg.ID_persona = p.ID
         AND p.Data_Fine IS NULL
         AND pg.Data_fine IS NULL
         --AND ader.ID_Aderente_Patto = @idSegnalante
         --AND ader.ID_Operazione = op.ID
         --and @dataEstrazione between ader.Data_Adesione and ISNULL(ader.Data_Disdetta, '31/12/9999') 
         AND @dataEstrazione between op.Data_Inizio and ISNULL(op.Data_Fine, '31/12/9999') 
         AND (op.Cancellata is null OR op.Cancellata = 0)
         and op.ID_Stato_Operazione <> 3
          -- non devo considerare eventuali OP in stato EOL
                  
      OPEN Operazioni_CUR
      FETCH NEXT FROM Operazioni_CUR INTO @idOperazione, @idPartecipata, @sndgPartecipata, 
                                          @pIVA, @cFisc, @codUIC, @ragioneSociale
      
      WHILE (@@FETCH_STATUS = 0)
      BEGIN    
        set @flagScarto = 0
        set @motivoScarto = ''
        
        -- Ricavo tipologia patto
        set @codTipoPatto = NULL
        SELECT @codTipoPatto = ISNULL(convert(varchar,ID_Tipo_Patto), '')
          FROM SK_F2.F2_T_Patti_Parasociale 
         WHERE ID_Operazione = @idOperazione
        set @codTipoPatto = ISNULL(@codTipoPatto,'')
        
        -- Ricavo percentuale totale di aderenza al patto
        set @percTotale = NULL
        SELECT @percTotale = SUM(ISNULL(Percentuale_Disp,0)) 
		 FROM SK_F2.F2_T_Aderenti_Patto_Parasociale ap
         WHERE ID_Operazione = @idOperazione
           AND (Cancellata IS NULL or Cancellata = 0)
		   -- aderenti al gruppo
		   AND Flag_GruppoISP = 1
		   -- in alternativa
		   AND SK_F2_REPORT.AppartenenteGruppo(ap.ID_Aderente_Patto,@dataEstrazione) = 1
        --set @percTotale = ISNULL(@percTotale, 0) 
        
        INSERT INTO SK_F2_FLUSSI.F2_T_EXP_CI_PattiParasociali (
           Data_estrazione
          ,ABI_Segnalante
          ,SNDG_Partecipata
          ,Codice_Istituto
          ,Partita_IVA
          ,Codice_UIC
          ,Cod_TipologiaPatto
          ,Perc_Totale
          ,Ragione_sociale
          ,Flag_Scarto
          ,Motivo_Scarto
        ) VALUES (
           @dataEstrazione  -- Data_estrazione - date
          ,@abi -- ABI_Segnalante - nvarchar(5)
          ,@sndgPartecipata -- SNDG_Partecipata - nvarchar(16)
          ,@contesto -- Codice_Istituto - nvarchar(2)
          ,CASE WHEN @pIVA IS NULL OR @pIVA = '' THEN @cFisc ELSE @pIVA END -- Partita_IVA - nvarchar(16)
          ,@codUIC -- Codice_UIC - nvarchar(16)
          ,@codTipoPatto -- Cod_TipologiaPatto - nvarchar(20)
          ,@percTotale   -- Perc_Totale - decimal(10,3)
          ,@ragioneSociale -- Ragione_sociale - nvarchar(max)
          ,@flagScarto  -- Flag_Scarto - bit
          ,@motivoScarto -- Motivo_Scarto - nvarchar(2000)
        ) 
        
        FETCH NEXT FROM Operazioni_CUR INTO @idOperazione, @idPartecipata, @sndgPartecipata, 
                                            @pIVA, @cFisc, @codUIC, @ragioneSociale
     
      END
        
      CLOSE Operazioni_CUR
      DEALLOCATE Operazioni_CUR
      
      -- Gestione scarti
      UPDATE SK_F2_FLUSSI.F2_T_EXP_CI_PattiParasociali
         SET Flag_Scarto = 1,
             Motivo_Scarto = 'Codice SNDG non valorizzato.'
       WHERE Data_estrazione = @dataEstrazione
         AND ABI_Segnalante = @abi
         AND (SNDG_Partecipata IS NULL OR LTRIM(RTRIM(SNDG_Partecipata)) = '')

      --UPDATE SK_F2_FLUSSI.F2_T_EXP_CI_PattiParasociali
      --   SET Flag_Scarto = 2,
      --       Motivo_Scarto = 'Percentuale di Partecipazione degli Aderenti minore del 5%: [' + convert(varchar, @percTotale) + ']'
      -- WHERE Data_estrazione = @dataEstrazione
      --   AND ABI_Segnalante = @abi
      --   AND Perc_Totale < 5
      
      -- Select Finale da tabella
      SELECT DISTINCT Codice_Istituto +
             right('0000000000000000' + Ltrim(Rtrim(SNDG_Partecipata)), 16) +
             left(Partita_IVA + space(11), 11) +
             left(Codice_UIC + space(13), 13) +
             left(Cod_TipologiaPatto + space(20), 20) +
             convert(char(8), @dataEstrazione, 112) +
             left(Ragione_Sociale + space(150), 150)
        FROM SK_F2_FLUSSI.F2_T_EXP_CI_PattiParasociali
       WHERE Data_estrazione = @dataEstrazione
         AND ABI_Segnalante = @abi
         AND Flag_Scarto = 0 
 END
 ELSE
 BEGIN
 		set @outputNum = -1
		SELECT @outputMsg = 'ABI ' + @abi + ' Inesistente.'
 END
           
 END TRY
	BEGIN CATCH
		set @outputNum = -1
		SELECT @outputMsg = ERROR_MESSAGE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;

END
