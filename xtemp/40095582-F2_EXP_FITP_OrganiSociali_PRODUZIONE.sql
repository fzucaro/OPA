USE [PART0]
GO

/****** Object:  StoredProcedure [SK_F2_FLUSSI].[F2_EXP_FITP_OrganiSociali]    Script Date: 2/26/2018 3:14:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [SK_F2_FLUSSI].[F2_EXP_FITP_OrganiSociali]
@dataEstrazione date, @outputNum int OUTPUT, @outputMsg nvarchar(500) OUTPUT
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
  declare @flagScarto           bit
  declare @motivoScarto         nvarchar(2000)
  declare @sndgPartecipata      nvarchar(16)
  declare @esisteABI            int
  declare @idPersonaCG          int
  declare @idPF                 int
  declare @idSocietaGruppo      int
  declare @idOrgano             int
  declare @idIncarico           int
  declare @codFiscalePers       nvarchar(16)
  declare @nominativo           nvarchar(120)
  declare @descOrgano           nvarchar(50)
  declare @descIncarico         nvarchar(50)
  declare @flagDesignatore      char(1)
  declare @esecutivoFitProper   char(1)
  declare @indipendenza         char(1)
  declare @sndgEsponente        nvarchar(16)
  declare @codMacrocat          int
  declare @descMacrocat         nvarchar(50)
  declare @dataDecorrenza       date
  declare @dataFine             date
  declare @motivoCessazione     nvarchar(250)
  
  set @outputNum = 0
	set @outputMsg = 'OK'

	BEGIN TRANSACTION;
  
  BEGIN TRY
  
  ---- Verifico esistenza ABI 
  --SELECT @esisteABI = COUNT(*) FROM SK_F2.F2_D_Banche where ABI_BANCA = @abi
  --IF @esisteABI > 0 
  --BEGIN
    
      -- Se esiste già un'estrazione per la stessa data e la stessa segnalante,
      -- cancello i dati precedenti
      DELETE FROM SK_F2_FLUSSI.F2_T_EXP_FITP_OrganiSociali
       WHERE Data_estrazione = @dataEstrazione
         --AND ABI_Segnalante = @abi

      SELECT @idSegnalante = p.ID, @sndgSegnalante = p.SNDG, @contesto = b.CONT
        FROM SK_F2.F2_D_Banche b, SK_F2.F2_T_Persona p
       WHERE p.SNDG = b.SNDG_BANCA 
         --AND b.ABI_BANCA = @abi
         AND p.Data_Fine IS NULL
         
      -- Recupero Dati Capogruppo
      SELECT @idPersonaCG = p.ID
        FROM SK_F2.F2_D_Banche b, SK_F2.F2_T_Persona p
       WHERE p.SNDG = b.SNDG_BANCA 
         AND b.FLAG_CAPOGRUPPO = 'S'
         AND p.Data_Fine IS NULL
           
      DECLARE Operazioni_CUR CURSOR FOR
      SELECT op.ID, op.ID_Persona, ISNULL(p.SNDG,'') as SNDG, 
             ltrim(rtrim(ISNULL(p.Partita_IVA,''))) as Partita_IVA, 
             ltrim(rtrim(ISNULL(p.Codice_Fiscale,''))) as Codice_Fiscale,
             ltrim(rtrim(ISNULL(pg.Codice_UIC,''))) as Codice_UIC 
        FROM SK_F2.F2_T_Operazioni op, SK_F2.F2_T_Persona p, SK_F2.F2_T_Persona_Giuridica pg
       WHERE op.Data_Fine IS NULL
         AND op.ID_Tipo_Operazione = 'CG'
         AND p.ID = op.ID_Persona
         AND pg.ID_persona = p.ID
         AND p.Data_Fine IS NULL
         AND pg.Data_fine IS NULL
         AND @dataEstrazione between op.Data_Inizio and ISNULL(op.Data_Fine, '31/12/9999') 
         AND (op.Cancellata is null OR op.Cancellata = 0)
         and op.ID_Stato_Operazione <> 3
          -- non devo considerare eventuali OP in stato EOL
                  
      OPEN Operazioni_CUR
      FETCH NEXT FROM Operazioni_CUR INTO @idOperazione, @idPartecipata, @sndgPartecipata, @pIVA, @cFisc, @codUIC
      
      WHILE (@@FETCH_STATUS = 0)
      BEGIN    
        set @flagScarto = 0
        set @motivoScarto = ''
        
        -- Ricavo Esponenti
        DECLARE Esponenti_CUR CURSOR FOR
         SELECT distinct esp.ID_Persona_Fisica, ISNULL(esp.ID_Societa_Gruppo,0), org.ID_Organo, inc.ID_Incarico,
				ISNULL(esp.EsecutivoFitProper,0),
				ISNULL(esp.Indipendenza,0), mac.ID, mac.Descrizione, 
				ISNULL(esp.Data_Decorrenza, esp.Data_Inizio), ISNULL(esp.Data_Fine, '01/01/1900'),
				case when esp.Data_Fine is null then '' else case when esp.ID_Motivo_Cessazione = 1 then ISNULL(esp.Motivo_Cessazione, '') else mot.Descrizione end end
           FROM SK_F2.F2_T_Organi_Societa org, SK_F2.F2_T_Incarichi_Societa inc,
                SK_F2.F2_T_Esponenti esp, SK_F2.F2_D_Macrocategorie_Organo mac, SK_F2.F2_D_Motivi_Cessazione mot
          WHERE org.ID_Operazione = @idOperazione
            AND @dataEstrazione between org.Data_Inizio and ISNULL(org.Data_Fine, '31/12/9999')
            AND (org.Cancellata IS NULL or org.Cancellata = 0)
            AND inc.ID_Organo_Societa = org.ID
            AND @dataEstrazione between inc.Data_Inizio and ISNULL(inc.Data_Fine, '31/12/9999')
            AND (inc.Cancellata IS NULL or inc.Cancellata = 0)
            AND esp.ID_Incarico_Societa = inc.ID
            AND @dataEstrazione between esp.Data_Inizio and ISNULL(esp.Data_Fine, '31/12/9999')
            AND (esp.Cancellata IS NULL or esp.Cancellata = 0)
			AND mac.ID = org.ID_Macro_Categoria
			AND (esp.Data_Fine is null or mot.ID = esp.ID_Motivo_Cessazione)
        
        OPEN Esponenti_CUR
        FETCH NEXT FROM Esponenti_CUR INTO @idPF, @idSocietaGruppo, @idOrgano, @idIncarico, 
						@esecutivoFitProper,
						@indipendenza, @codMacrocat, @descMacrocat, @dataDecorrenza, @dataFine, @motivoCessazione
      
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 
        
            -- Ricavo Dati Persona Fisica
            set @codFiscalePers = NULL
            set @nominativo = NULL
            SELECT @codFiscalePers = ISNULL(pers.Codice_Fiscale,''),
                   @nominativo = ISNULL(ltrim(rtrim(pf.Cognome)) + ' ' + ltrim(rtrim(pf.Nome)), ''),
				   @sndgEsponente = ISNULL(pers.SNDG,'')
              FROM SK_F2.F2_T_Persona pers, SK_F2.F2_T_Persona_Fisica pf
             WHERE pf.ID_Persona = pers.ID
               AND pers.ID = @idPF
               AND pf.Data_Fine IS NULL
            set @codFiscalePers = ISNULL(@codFiscalePers,'')
            set @nominativo = ISNULL(@nominativo,'')
			set @sndgEsponente = ISNULL(@sndgEsponente,'')
               
            -- Ricavo Descrizione Organo
            set @descOrgano = NULL
            SELECT @descOrgano = ISNULL(o.Descrizione,'')
              FROM SK_F2.F2_D_Organi o
             WHERE o.ID = @idOrgano
            set @descOrgano = ISNULL(@descOrgano,'')
            
            -- Ricavo Descrizione Incarico
            set @descIncarico = NULL
            SELECT @descIncarico = ISNULL(i.Descrizione,'')
              FROM SK_F2.F2_D_Incarichi i
             WHERE i.ID = @idIncarico
            set @descIncarico = ISNULL(@descIncarico,'')
           
            -- Flag Designatore
            set @flagDesignatore = '0'
            IF @idSocietaGruppo = @idPersonaCG
            BEGIN
               set @flagDesignatore = 1
            END
            
            INSERT INTO SK_F2_FLUSSI.F2_T_EXP_FITP_OrganiSociali (
               Data_estrazione
              ,ABI_Segnalante
              ,SNDG_Partecipata
              ,Codice_Istituto
              ,Partita_IVA
              ,Codice_UIC
              ,Nominativo
              ,Codice_Fiscale
              ,Codice_Incarico
              ,Codice_Organo
              ,Flag_Designatore
              ,Descrizione_Incarico
              ,Descrizione_Organo
			  ,EsecutivoFitProper
			  ,Indipendenza
			  ,SNDG_Esponente
			  ,Codice_Macrocategoria
			  ,Descrizione_Macrocategoria
			  ,Data_Decorrenza_Esponente
			  ,Data_Fine_Esponente
			  ,Motivo_Cessazione_Esponente
              ,Flag_Scarto
              ,Motivo_Scarto
            ) VALUES (
               @dataEstrazione  -- Data_estrazione - date
              ,'00000' -- ABI_Segnalante - nvarchar(5)
              ,@sndgPartecipata -- SNDG_Partecipata - nvarchar(16)
              ,@contesto -- Codice_Istituto - nvarchar(2)
              ,CASE WHEN @pIVA IS NULL or @pIVA = '' THEN @cFisc ELSE @pIVA END -- Partita_IVA - nvarchar(16)
              ,@codUIC -- Codice_UIC - nvarchar(16)
              ,@nominativo -- Nominativo - nvarchar(150)
              ,@codFiscalePers -- Codice_Fiscale - nvarchar(16)
              ,convert(varchar,@idIncarico) -- Codice_Incarico - nvarchar(10)
              ,convert(varchar,@idOrgano) -- Codice_Organo - nvarchar(10)
              ,@flagDesignatore  -- Flag_Designatore - char(1)
              ,@descIncarico -- Descrizione_Incarico - nvarchar(50)
              ,@descOrgano -- Descrizione_Organo - nvarchar(50)
			  ,@esecutivoFitProper -- Flag esecutivo Fit&Proper
			  ,@indipendenza -- Flag indipendenza esponente
			  ,@sndgEsponente -- SNDG esponente
			  ,@codMacrocat -- Codice macrocategoria organo
			  ,@descMacrocat -- Codice macrocategoria organo
			  ,convert(nvarchar, @dataDecorrenza, 112) -- Data decorrenza esponente - nvarchar(8)
              ,case when @dataFine = '01/01/1900' then '' else convert(nvarchar, @dataFine, 112) end -- Data fine esponente - nvarchar(8)
			  ,case when @dataFine = '01/01/1900' then '' else @motivoCessazione end  -- Motivo cessazione esponente - nvarchar(250)
              ,@flagScarto   -- Flag_Scarto - int
              ,@motivoScarto -- Motivo_Scarto - nvarchar(2000)
            ) 
            
            FETCH NEXT FROM Esponenti_CUR INTO @idPF, @idSocietaGruppo, @idOrgano, @idIncarico, 
						@esecutivoFitProper,
						@indipendenza, @codMacrocat, @descMacrocat, @dataDecorrenza, @dataFine, @motivoCessazione
        END
        CLOSE Esponenti_CUR
        DEALLOCATE Esponenti_CUR
        
        FETCH NEXT FROM Operazioni_CUR INTO @idOperazione, @idPartecipata, @sndgPartecipata, @pIVA, @cFisc, @codUIC
     
      END
        
      CLOSE Operazioni_CUR
      DEALLOCATE Operazioni_CUR
      
      -- Gestione scarti
      UPDATE SK_F2_FLUSSI.F2_T_EXP_FITP_OrganiSociali
         SET Flag_Scarto = 1,
             Motivo_Scarto = 'Codice SNDG non valorizzato.'
       WHERE Data_estrazione = @dataEstrazione
         --AND ABI_Segnalante = @abi
         AND (SNDG_Partecipata IS NULL OR LTRIM(RTRIM(SNDG_Partecipata)) = '')

      UPDATE SK_F2_FLUSSI.F2_T_EXP_FITP_OrganiSociali
         SET Flag_Scarto = 2,
             Motivo_Scarto = 'Nominativo Esponente non valorizzato.'
       WHERE Data_estrazione = @dataEstrazione
         --AND ABI_Segnalante = @abi
         AND (Nominativo IS NULL OR LTRIM(RTRIM(Nominativo)) = '')
         
      UPDATE SK_F2_FLUSSI.F2_T_EXP_FITP_OrganiSociali
         SET Flag_Scarto = 3,
             Motivo_Scarto = 'Organo non valorizzato.'
       WHERE Data_estrazione = @dataEstrazione
         --AND ABI_Segnalante = @abi
         AND (Codice_Organo IS NULL OR Descrizione_Organo IS NULL OR LTRIM(RTRIM(Descrizione_Organo)) = '')
         
      UPDATE SK_F2_FLUSSI.F2_T_EXP_FITP_OrganiSociali
         SET Flag_Scarto = 4,
             Motivo_Scarto = 'Incarico non valorizzato.'
       WHERE Data_estrazione = @dataEstrazione
         --AND ABI_Segnalante = @abi
         AND (Codice_Incarico IS NULL OR Descrizione_Incarico IS NULL OR LTRIM(RTRIM(Descrizione_Incarico)) = '')
      
      -- Select Finale da tabella
	  SELECT left(Codice_Istituto + space(2), 2) +
	         right('0000000000000000' + Ltrim(Rtrim(SNDG_Partecipata)), 16) +
			 left(Partita_IVA + space(11), 11) +
			 left(Codice_UIC + space(13), 13) +
			 left(Nominativo + space(120), 120) +
			 left(Codice_Fiscale + space(16), 16) +
			 left(Codice_Incarico + space(7), 7) +
			 left(Codice_Organo + space(7), 7) +
			 ISNULL(Flag_Designatore, '0') +
			 convert(CHAR (8), @dataEstrazione, 112) +
			 left(Descrizione_Incarico + space(50), 50) +
			 left(Descrizione_Organo + space(50), 50) +
			 ISNULL(EsecutivoFitProper, '0') +
			 ISNULL(Indipendenza, '0') +
			 right('0000000000000000' + Ltrim(Rtrim(SNDG_Esponente)), 16) +
			 left(Codice_Macrocategoria + space(10), 10) +
			 left(Descrizione_Macrocategoria + space(50), 50) +
			 convert(CHAR (8), Data_Decorrenza_Esponente, 112) +
			 convert(CHAR (8), Data_Fine_Esponente, 112) +
			 left(Motivo_Cessazione_Esponente + space(250), 250)
		FROM SK_F2_FLUSSI.F2_T_EXP_FITP_OrganiSociali
		WHERE Data_estrazione = @dataEstrazione
		  --AND ABI_Segnalante = @abi
		  AND Flag_Scarto = 0
           
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
GO


