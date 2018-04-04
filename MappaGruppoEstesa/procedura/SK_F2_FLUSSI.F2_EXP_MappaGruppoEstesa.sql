USE [PART0]
GO
/****** Object:  StoredProcedure [SK_F2_FLUSSI].[F2_EXP_MappaGruppo_Estesa]    Script Date: 06/02/2018 10:21:53 ******/
IF EXISTS (SELECT *
             FROM sys.objects
            WHERE OBJECT_ID = OBJECT_ID(N'[SK_F2_FLUSSI].[F2_EXP_MappaGruppo_Estesa_FITP]')
              AND TYPE IN (N'P', N'RF', N'PC'))
BEGIN
    DROP PROCEDURE SK_F2_FLUSSI.F2_EXP_MappaGruppo_Estesa_FITP;
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ********************************************************************************************************************************

CREATE PROCEDURE [SK_F2_FLUSSI].[F2_EXP_MappaGruppo_Estesa_FITP]
@dataEstrazione date, @destinazione nvarchar(10), @cruscotto char(1), @outputNum int OUTPUT, @outputMsg nvarchar(500) OUTPUT
WITH EXEC AS CALLER
AS
BEGIN

    DECLARE @idOperazione INT
    DECLARE @idPartecipata INT
    DECLARE @tipoOperazione NVARCHAR(5)
    DECLARE @flagScarto BIT
    DECLARE @motivoScarto NVARCHAR(2000)
    DECLARE @sndgPartecipata NVARCHAR(16)
    DECLARE @abiPrevPartecipata NVARCHAR(5)
    DECLARE @ndgPrevPartecipata NVARCHAR(16)
    DECLARE @ndgCGPartecipata NVARCHAR(16)
    DECLARE @tipoNDG NVARCHAR(5)
    DECLARE @SAE NVARCHAR(6)
    DECLARE @RAE NVARCHAR(6)
    DECLARE @codFiscale NVARCHAR(16)
    DECLARE @partitaIVA NVARCHAR(16)
    DECLARE @valutaBilancio NVARCHAR(5)
    DECLARE @indPartecipata NVARCHAR(100)
    DECLARE @capPartecipata NVARCHAR(10)
    DECLARE @cittaPartecipata NVARCHAR(100)
    DECLARE @provPartecipata NVARCHAR(2)
    DECLARE @statoPartecipata NVARCHAR(100)
    DECLARE @nazionalita CHAR(1)
    DECLARE @denomPartecipata NVARCHAR(150)
    DECLARE @ateco NVARCHAR(10)
    DECLARE @codiceCR NVARCHAR(16)
    DECLARE @codiceUIC NVARCHAR(16)
    DECLARE @extraUE NVARCHAR(100)
    DECLARE @descrAttivita NVARCHAR(150)
    DECLARE @classBI NVARCHAR(100)
    DECLARE @quotata NVARCHAR(60)
    DECLARE @tipoQuot NVARCHAR(100)
    DECLARE @classIASgruppo NVARCHAR(100)
    DECLARE @class2359gruppo NVARCHAR(100)
    DECLARE @classMonit NVARCHAR(100)
    DECLARE @classPNF NVARCHAR(100)
    DECLARE @classAntitrust NVARCHAR(100)
    DECLARE @orgInterposto CHAR(1)
    DECLARE @opQualificata CHAR(1)
    DECLARE @centroResp NVARCHAR(100)
    DECLARE @CGU NVARCHAR(100)
    DECLARE @tipologiaFAG NVARCHAR(100)
    DECLARE @tipoLookT NVARCHAR(100)
    DECLARE @gestorePart NVARCHAR(100)
    DECLARE @cmgPartecipata NVARCHAR(16)
    DECLARE @cmgPartecipante NVARCHAR(16)
    DECLARE @metodoConsBI NVARCHAR(100)
    DECLARE @metodoConsIAS NVARCHAR(100)
    DECLARE @metodoConsFinrep NVARCHAR(100)
    DECLARE @grpBancario CHAR(1)
    DECLARE @grpCivilist CHAR(1)
    DECLARE @grpAssicur CHAR(1)
    DECLARE @dataINS DATE
    DECLARE @valutaCS NVARCHAR(3)
    DECLARE @valutaPartecipante NVARCHAR(3)
    DECLARE @CSsottoscrValuta NVARCHAR(30)
    DECLARE @CSsottoscrEuro NVARCHAR(30)
    DECLARE @CSdelibValuta NVARCHAR(30)
    DECLARE @CSsdelibEuro NVARCHAR(30)
    DECLARE @CSversatoValuta NVARCHAR(30)
    DECLARE @CSversatoEuro NVARCHAR(30)
    DECLARE @CSvalNominUnit NVARCHAR(30)
    DECLARE @totAzioniCS NVARCHAR(30)
    DECLARE @totAzioniDVCS NVARCHAR(30)
    DECLARE @totAzioniDVAOCS NVARCHAR(30)
    DECLARE @dataIniCS DATE
    DECLARE @idCS INT
    DECLARE @superISIN NVARCHAR(16)
    DECLARE @PATRvalComplValuta NVARCHAR(30)
    DECLARE @PATRvalComplEuro NVARCHAR(30)
    DECLARE @PATRtotQuote NVARCHAR(30)
    DECLARE @totAzioniGruppo NVARCHAR(30)
    DECLARE @percGruppoTotale NVARCHAR(10)
    DECLARE @totAzioniDVGruppo NVARCHAR(30)
    DECLARE @percGruppoDVTotale NVARCHAR(10)
    DECLARE @idRappPart INT
    DECLARE @idPartecipante INT
    DECLARE @classIASIndivid NVARCHAR(100)
    DECLARE @class2359Individ NVARCHAR(100)
    DECLARE @guidRP UNIQUEIDENTIFIER
    DECLARE @indPartecipante NVARCHAR(100)
    DECLARE @capPartecipante NVARCHAR(10)
    DECLARE @cittaPartecipante NVARCHAR(100)
    DECLARE @provPartecipante NVARCHAR(2)
    DECLARE @statoPartecipante NVARCHAR(100)
    DECLARE @denomPartecipante NVARCHAR(150)
    DECLARE @livelloFV NVARCHAR(3)
    DECLARE @percEquityRatio NVARCHAR(10)
    DECLARE @percDirettaTot NVARCHAR(10)
    DECLARE @percDirettaDVTot NVARCHAR(10)
    DECLARE @idRP INT
    DECLARE @idTitolo INT
    DECLARE @codTitolo NVARCHAR(20)
    DECLARE @isinTitolo NVARCHAR(20)
    DECLARE @descrTitolo NVARCHAR(100)
    DECLARE @azioniPartecipanteTitolo NVARCHAR(30)
    DECLARE @percDirettaTitolo NVARCHAR(10)
    DECLARE @azioniPartecipanteDVTitolo NVARCHAR(30)
    DECLARE @percDirettaDVTitolo NVARCHAR(10)
    DECLARE @percGruppoTitolo NVARCHAR(10)
    DECLARE @percDVGruppoTitolo NVARCHAR(10)
    DECLARE @idQuota INT
    DECLARE @codQuota NVARCHAR(20)
    DECLARE @isinQuota NVARCHAR(20)
    DECLARE @descrQuota NVARCHAR(100)
    DECLARE @valBilancioIndivValuta NVARCHAR(30)
    DECLARE @valBilancioIndivEuro NVARCHAR(30)
    DECLARE @valBilancioGruppo NVARCHAR(30)
    DECLARE @valNominPartecipanteTitolo NVARCHAR(30)
    DECLARE @valNominPartecipanteTitoloEuro NVARCHAR(30)
    DECLARE @numPartecipanti INT
    DECLARE @prezzoIASEuro NVARCHAR(30)
    DECLARE @esisteClassAnag INT
    DECLARE @esisteClassCont INT
    DECLARE @impSuOperazione NVARCHAR(5)
    DECLARE @numAzioniTitCS DECIMAL(28, 8)
    DECLARE @numQuotePatr DECIMAL(28, 8)

------ PER OPA CAMPI AGGIUNTIVI
    DECLARE @sndgPartecipante    NVARCHAR(16)
    DECLARE @percSFPConvertibile NVARCHAR(10) = '0.000'
------ FITP0 campi aggiuntivi
/*
	Flag appartenete Gruppo
	Tipo Persona PF o PG
*/    
	DECLARE @flagAppartieneGruppo bit
	DECLARE @tipoPersona char(2)
-- Parametro per gestire partecipanti appartenenti al gruppo o meno
	DECLARE @filtroAppGruppo int

    SET @outputNum = 0
    SET @outputMsg = 'OK'

    BEGIN TRANSACTION;

    BEGIN TRY

    -- Se esiste già un'estrazione per la stessa data e per la stessa destinazione
    -- e l'estrazione NON è automatica cancello i dati precedenti (la richiesta applicativa da cruscotto
    -- viene considerata sempre come una nuova estrazione; la richiesta automatica invece utilizza sempre
    -- i dati eventualmente già elaborati a parità di data e destinazione
    --IF upper(@cruscotto) = 'S'
    --BEGIN
    DELETE FROM SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
    WHERE Data_estrazione = @dataEstrazione
          AND Destinazione = @destinazione
    --END

	/*
	Calcolo filtroGruppo in base a destinazione
	FITP: tutti i partecipanti
	negli altri casi solo quelli appartenenti al gruppo
		Se @filtroAppGruppo = -1 allora considero tutti i partecipanti
		Se @filtroAppGruppo = 0 allora includo nei partecipanti solo gli appartenenti al gruppo
	*/

	IF (@destinazione = 'FITP')
		BEGIN
			set @filtroAppGruppo = -1 	
		END 
	ELSE
		BEGIN
			set @filtroAppGruppo = 0
		END





    -- Tutte le Operazioni ad esclusione di Patti Parasociali e Corporate Governance
    DECLARE Operazioni_CUR CURSOR FOR
      SELECT
        op.ID,
        op.ID_Tipo_Operazione,
        op.ID_Persona,
        p.SNDG,
        p.ABI_Riferimento,
        p.NDG_Riferimento,
        p.NDG_CapoGruppo,
        p.ID_Tipo_NDG,
        p.ID_SAE,
        p.ID_RAE,
        p.Codice_Fiscale,
        p.Partita_IVA,
        op.Data_Inizio
      FROM SK_F2.F2_T_Operazioni op, SK_F2.F2_T_Persona p
      WHERE op.Data_Fine IS NULL
            AND op.ID_Tipo_Operazione NOT IN ('PP', 'CG')
            AND p.ID = op.ID_Persona
            AND p.Data_Fine IS NULL
            AND op.ID_Stato_Operazione = 1
    --AND op.ID = 56880
    --AND op.ID in (56504)--, 56039) -- per i test -- DA ELIMINARE

    OPEN Operazioni_CUR
    FETCH NEXT FROM Operazioni_CUR
    INTO @idOperazione, @tipoOperazione, @idPartecipata,
      @sndgPartecipata, @abiPrevPartecipata, @ndgPrevPartecipata,
      @ndgCGPartecipata, @tipoNDG, @SAE, @RAE, @codFiscale, @partitaIVA, @dataINS
    WHILE (@@FETCH_STATUS = 0)
      BEGIN
        SET @flagScarto = 0
        SET @motivoScarto = ''

        --print 'ID op: ' + convert(varchar,@idOperazione)
        --print 'SNDG Partecipata ' + @sndgPartecipata

        -- Ricavo dati Attributi Bilancio
        SET @valutaBilancio = ''
        SELECT @valutaBilancio = ID_Valuta
        FROM SK_F2.F2_T_Attributi_Bilancio
        WHERE ID_Persona = @idPartecipata
              AND @dataEstrazione BETWEEN CONVERT(DATE, Data_Inizio) AND isnull(Data_Fine, '31/12/9999')

        -- Ricavo dati Sede Legale Partecipata
        SET @indPartecipata = ''
        SET @capPartecipata = ''
        SET @cittaPartecipata = ''
        SET @provPartecipata = ''
        SET @statoPartecipata = ''
        SELECT
          @indPartecipata = upper(Indirizzo),
          @capPartecipata = upper(Cap),
          @cittaPartecipata = upper(Citta),
          @provPartecipata = (SELECT upper(Sigla_Provincia)
                              FROM SK_F2.F2_V_Province
                              WHERE upper(Descrizione_Provincia) = upper(Provincia)),
          @statoPartecipata = upper(Stato)
        FROM SK_F2.F2_T_Indirizzi_Persona
        WHERE ID_Persona = @idPartecipata
              AND ID_Tipo_Indirizzo = 4
              AND @dataEstrazione BETWEEN CONVERT(DATE, Data_Inizio) AND isnull(Data_Fine, '31/12/9999')

        SET @nazionalita = 'E'
        IF @statoPartecipata IS NULL OR len(ltrim(rtrim(@statoPartecipata))) = 0 OR @statoPartecipata = 'ITALIA'
          BEGIN
            SET @nazionalita = 'I'
          END

        -- Ricavo dati anagrafici Persona Giuridica Partecipata
        SET @denomPartecipata = ''
        SET @ateco = ''
        SET @codiceCR = ''
        SET @codiceUIC = ''
        SET @extraUE = ''
        SELECT
          @denomPartecipata = pg.Ragione_Sociale,
          @ateco = pg.ID_ATECO,
          @codiceCR = pg.Codice_CR,
          @codiceUIC = pg.Codice_UIC,
          @extraUE = (SELECT Descrizione
                      FROM SK_F2.F2_D_Extra_UE
                      WHERE ID = pg.ID_Extra_UE)
        FROM SK_F2.F2_T_Persona_Giuridica pg
        WHERE pg.ID_Persona = @idPartecipata
              AND @dataEstrazione BETWEEN CONVERT(DATE, pg.Data_Inizio) AND isnull(pg.Data_Fine, '31/12/9999')

        -- Ricavo Dati Classificazioni Anagrafiche
        SET @esisteClassAnag = 0
        SET @esisteClassCont = 0

        SET @descrAttivita = ''
        SET @classBI = ''
        SET @quotata = ''
        SET @tipoQuot = ''
        SET @classIASgruppo = ''
        SET @class2359gruppo = ''
        SET @classMonit = ''
        SET @classPNF = ''
        SET @classAntitrust = ''
        SET @orgInterposto = ''
        SET @opQualificata = ''
        SET @centroResp = ''
        SET @CGU = ''
        SET @tipologiaFAG = ''
        SET @tipoLookT = ''
        SET @gestorePart = ''

        SELECT
          @descrAttivita = cla.Descrizione_Attivita,
          @classBI = (SELECT descrizione
                      FROM SK_F2.F2_D_Classificazione_Banca_Italia
                      WHERE ID = cla.ID_Classificazione_Banca_Italia),
          @quotata = (SELECT descrizione
                      FROM SK_F2.F2_D_Classificazione_Quotata
                      WHERE ID = cla.ID_Quotata),
          @tipoQuot = (SELECT descrizione
                       FROM SK_F2.F2_D_Tipo_Quotazione
                       WHERE ID = cla.ID_Tipo_Quotazione),
          @classIASgruppo = (SELECT descrizione
                             FROM SK_F2.F2_D_Classificazione_IAS
                             WHERE ID = cla.ID_Classificazione_IAS),
          @class2359gruppo = (SELECT descrizione
                              FROM SK_F2.F2_D_Classificazione_art2359
                              WHERE ID = cla.ID_Classificazione_art_2359),
          @classMonit = (SELECT descrizione
                         FROM SK_F2.F2_D_Classificazione_Monitoraggio_Interno
                         WHERE ID = ID_Classificazione_monitoraggio_interno),
          @classPNF = (SELECT descrizione
                       FROM SK_F2.F2_D_Classificazione_PNF
                       WHERE ID = cla.ID_Classificazione_PNF),
          @classAntitrust = (SELECT descrizione
                             FROM SK_F2.F2_D_Classificazione_Antitrust
                             WHERE ID = cla.ID_Classificazione_Antitrust),
          @orgInterposto = CASE WHEN cla.Flag_organismo_interposto IS NULL OR cla.Flag_organismo_interposto = 0
            THEN 'N'
                           ELSE 'S' END,
          @opQualificata = CASE WHEN cla.partecipazione_qualificata IS NULL OR cla.partecipazione_qualificata = 0
            THEN 'N'
                           ELSE 'S' END,
          @centroResp = (SELECT descrizione
                         FROM SK_F2.F2_D_Centro_Reponsabilita
                         WHERE ID = cla.ID_Centro_Responsabilita),
          @CGU = (SELECT descrizione
                  FROM SK_F2.F2_D_Cash_Generating_Unit
                  WHERE ID = cla.ID_Cash_Generating_Unit),
          @tipologiaFAG = (SELECT descrizione
                           FROM SK_F2.F2_D_FAG
                           WHERE ID = cla.Tipologia_FAG),
          @tipoLookT = (SELECT descrizione
                        FROM SK_F2.F2_D_Tipo_Look_Through
                        WHERE ID = cla.ID_tipo_look_through),
          @gestorePart = (SELECT descr_daisy
                          FROM SK_F2.F2_D_Gestori_Partecipazione
                          WHERE ID = cla.Gestore_Partecipazione)
        FROM SK_F2.F2_T_Classificazioni_Anagrafiche cla
        WHERE cla.ID_Operazione = @idOperazione
              AND @dataEstrazione BETWEEN CONVERT(DATE, cla.Data_Inizio) AND isnull(cla.Data_Fine, '31/12/9999')
              AND (cla.Cancellata = 0 OR cla.Cancellata IS NULL)

        SET @esisteClassAnag = @@ROWCOUNT

        -- Ricavo Dati Classificazioni Contabili
        SET @cmgPartecipata = ''
        SET @metodoConsBI = ''
        SET @metodoConsIAS = ''
        SET @metodoConsFinrep = ''
        SET @grpBancario = ''
        SET @grpCivilist = ''
        SET @grpAssicur = ''
        SELECT
          @cmgPartecipata = Codice_Mappa_Gruppo,
          @metodoConsBI = (SELECT descrizione
                           FROM SK_F2.F2_D_Metodo_Consolidamento
                           WHERE ID = clc.ID_Metodo_Consolidamento_Banca_Italia),
          @metodoConsIAS = (SELECT descrizione
                            FROM SK_F2.F2_D_Metodo_Consolidamento
                            WHERE ID = clc.ID_Metodo_Consolidamento_IAS),
          @metodoConsFinrep = (SELECT descrizione
                               FROM SK_F2.F2_D_Metodo_Consolidamento
                               WHERE ID = clc.ID_Metodo_Consolidamento_Finrep),
          @grpBancario = CASE WHEN clc.Appartenente_Gruppo_Bancario IS NULL OR clc.Appartenente_Gruppo_Bancario = 0
            THEN 'N'
                         ELSE 'S' END,
          @grpCivilist =
          CASE WHEN clc.Appartentente_Gruppo_Civilistico IS NULL OR clc.Appartentente_Gruppo_Civilistico = 0
            THEN 'N'
          ELSE 'S' END,
          @grpAssicur =
          CASE WHEN clc.Appartentente_Gruppo_Assicurativo IS NULL OR clc.Appartentente_Gruppo_Assicurativo = 0
            THEN 'N'
          ELSE 'S' END
        FROM SK_F2.F2_T_Classificazioni_Contabili clc
        WHERE clc.ID_Operazione = @idOperazione
              AND @dataEstrazione BETWEEN CONVERT(DATE, clc.Data_Inizio) AND isnull(clc.Data_Fine, '31/12/9999')
              AND (clc.Cancellata = 0 OR clc.Cancellata IS NULL)

        SET @esisteClassCont = @@ROWCOUNT

        IF @esisteClassAnag = 0 AND @esisteClassCont = 0
          BEGIN
            SET @flagScarto = 1
            SET @motivoScarto = 'Non esistono dati di classificazione'
          END
        ELSE
          BEGIN
            -- Ricavo Dati Capitale Sociale
            SET @idCS = 0
            SET @valutaCS = ''
            SET @CSsottoscrValuta = ''
            SET @CSsottoscrEuro = ''
            SET @CSdelibValuta = ''
            SET @CSsdelibEuro = ''
            SET @CSversatoValuta = ''
            SET @CSversatoEuro = ''
            SET @CSvalNominUnit = ''
            SET @totAzioniCS = ''
            SET @totAzioniDVCS = ''
            SET @totAzioniDVAOCS = ''
            SET @dataIniCS = ''

            SELECT
              @idCS = ID,
              @valutaCS = Divisa,
              @CSsottoscrValuta = convert(NVARCHAR, convert(DECIMAL(28, 2), Capitale_Sociale_Sottoscritto_Valuta)),
              @CSsottoscrEuro = convert(NVARCHAR, convert(DECIMAL(28, 2), Capitale_Sociale_Sottoscritto_Euro)),
              @CSdelibValuta = convert(NVARCHAR, convert(DECIMAL(28, 2), Capitale_Sociale_Deliberato_Valuta)),
              @CSsdelibEuro = convert(NVARCHAR, convert(DECIMAL(28, 2), Capitale_Sociale_Deliberato_Euro)),
              @CSversatoValuta = convert(NVARCHAR, convert(DECIMAL(28, 2), Capitale_Sociale_Versato_Valuta)),
              @CSversatoEuro = convert(NVARCHAR, convert(DECIMAL(28, 2), Capitale_Sociale_Versato_Euro)),
              @CSvalNominUnit = convert(NVARCHAR, convert(DECIMAL(28, 2), CASE WHEN Totale_Azioni_Complessive = 0
                THEN 0
                                                                          ELSE (Capitale_Sociale_Sottoscritto_Valuta /
                                                                                Totale_Azioni_Complessive) END)),
              @totAzioniCS = convert(NVARCHAR, convert(DECIMAL(28, 2), Totale_Azioni_Complessive)),
              @totAzioniDVCS = convert(NVARCHAR, convert(DECIMAL(28, 2), Totale_Azioni_Diritto_Voto)),
              @totAzioniDVAOCS = convert(NVARCHAR, convert(DECIMAL(28, 2), Totale_Azioni_Solo_Assemblea_Ordinaria)),
              @dataIniCS = Data_Inizio
            FROM SK_F2.F2_T_CapitaleSociale
            WHERE ID_Persona = @idPartecipata
                  AND @dataEstrazione BETWEEN CONVERT(DATE, Data_Inizio) AND isnull(Data_Fine, '31/12/9999')
                  AND (Cancellata = 0 OR Cancellata IS NULL)

            -- Ricavo SUPER ISIN
            SET @superISIN = ''
            SELECT @superISIN = ISNULL(Codice_ISIN, '')
            FROM SK_F2.F2_T_Titoli
            WHERE ID_CapitaleSociale = @idCS
                  AND superisin = 1
                  AND (Cancellata = 0 OR Cancellata IS NULL)

            -- Ricavo Dati Patrimonio
            SET @PATRvalComplValuta = ''
            SET @PATRvalComplEuro = ''
            SET @PATRtotQuote = ''
            SELECT
              @PATRvalComplValuta = convert(NVARCHAR, convert(DECIMAL(28, 2), Valore_complessivo_Valuta)),
              @PATRvalComplEuro = convert(NVARCHAR, convert(DECIMAL(28, 2), Valore_complessivo__Euro)),
              @PATRtotQuote = convert(NVARCHAR, convert(DECIMAL(28, 2), Totale_Quote))
            FROM SK_F2.F2_T_Patrimonio
            WHERE ID_Persona = @idPartecipata and ID_Operazione = @idOperazione
                  AND @dataEstrazione BETWEEN CONVERT(DATE, Data_Inizio) AND isnull(Data_Fine, '31/12/9999')
                  AND (Cancellata = 0 OR Cancellata IS NULL)

            -- Ricavo dati di possesso a livello di gruppo (numero azioni gruppo, %possesso gruppo totale)
            SET @totAzioniGruppo = ''
            SET @totAzioniDVGruppo = ''
            SET @percGruppoTotale = ''
            SET @percGruppoDVTotale = ''
            IF @tipoOperazione = 'IMP'
              BEGIN
                SELECT
                  @totAzioniGruppo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                               SK_F2_REPORT.getNumeroAzioniGruppoImpegni(@idOperazione,
                                                                                                         @dataEstrazione))),
                  @totAzioniDVGruppo = convert(NVARCHAR, 0),
                  -- Info non significativa per IMPEGNI
                  @percGruppoTotale = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                SK_F2.getQuotaGruppoImpegni(@idOperazione,
                                                                                            @dataEstrazione) * 100)),
                  @percGruppoDVTotale = convert(NVARCHAR, 0) -- Info non significativa per IMPEGNI
              END
            ELSE
              BEGIN
                SELECT
                  @totAzioniGruppo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                               SK_F2_REPORT.getNumeroAzioniGruppo(@idOperazione,
                                                                                                  @dataEstrazione))),
                  @totAzioniDVGruppo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                 SK_F2_REPORT.getNumeroAzioniGruppoDV(@idOperazione,
                                                                                                      @dataEstrazione))),
                  @percGruppoTotale = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                SK_F2_REPORT.getQuotaGruppo(@idOperazione,
                                                                                            @dataEstrazione) * 100)),
                  @percGruppoDVTotale = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                  SK_F2_REPORT.getQuotaDVGruppo(@idOperazione,
                                                                                                @dataEstrazione) * 100))
              END

            -- Ricavo Dati Rapporti Partecipativi
            IF @tipoOperazione = 'IMP'
              BEGIN
                DECLARE Partecipanti_CUR CURSOR FOR
                  SELECT
                    rp.ID,
                    rp.ID_Partecipante,
                    '',
                    '',
                    rp.GUID_Imp_COntabili,
                    ''		
                  FROM SK_F2.F2_T_Impegni_Contabili rp
                  WHERE rp.ID_Operazione = @idOperazione
                        AND @dataEstrazione BETWEEN CONVERT(DATE, rp.Data_Inizio) AND isnull(rp.Data_Fine, '31/12/9999')
                        AND (rp.Cancellata = 0 OR rp.Cancellata IS NULL)
						-- Modifca per gestire i partecipanti del gruppo e non
						AND SK_F2_REPORT.AppartenenteGruppo(rp.id_partecipante,@dataEstrazione) > @filtroAppGruppo
                        --AND (sk_f2.isSocietaGruppo(rp.id_partecipante, 'B', @dataEstrazione) = 1 OR
                        --     sk_f2.isSocietaGruppo(rp.id_partecipante, 'C', @dataEstrazione) = 1)
              END
            ELSE IF @tipoOperazione = 'IND'
              BEGIN
                DECLARE Partecipanti_CUR CURSOR FOR
                  SELECT
                    rp.ID,
                    rp.ID_Partecipante,
                    '',
                    '',
                    rp.GUID_Indirette_OI,
                    ''
                  FROM SK_F2.F2_T_Indirette_OI rp
                  WHERE rp.ID_Operazione = @idOperazione
                        AND @dataEstrazione BETWEEN CONVERT(DATE, rp.Data_Inizio) AND isnull(rp.Data_Fine, '31/12/9999')
                        AND (rp.Cancellata = 0 OR rp.Cancellata IS NULL)
                        --AND (sk_f2.isSocietaGruppo(rp.id_partecipante, 'B', @dataEstrazione) = 1 OR
                        --     sk_f2.isSocietaGruppo(rp.id_partecipante, 'C', @dataEstrazione) = 1)
              END
            ELSE
              BEGIN
                DECLARE Partecipanti_CUR CURSOR FOR
                  SELECT
                    rp.ID,
                    rp.ID_Partecipante,
                    (SELECT descrizione
                     FROM SK_F2.F2_D_Classificazione_IAS
                     WHERE ID = rp.ID_Classif_IAS_Individuale),
                    (SELECT descrizione
                     FROM SK_F2.F2_D_Classificazione_art2359
                     WHERE ID = rp.ID_Classif_art_2359_Individuale),
                    rp.GUID_Rapp_Partecipativi,
                    convert(NVARCHAR, ID_Gerarchia_Fair_Value)
                  FROM SK_F2.F2_T_Rapporti_Partecipativi rp
                  WHERE rp.ID_Operazione = @idOperazione
                        AND @dataEstrazione BETWEEN CONVERT(DATE, rp.Data_Inizio) AND isnull(rp.Data_Fine, '31/12/9999')
                        AND (rp.Cancellata = 0 OR rp.Cancellata IS NULL)
						-- Modifca per gestire i partecipanti del gruppo e non
						AND SK_F2_REPORT.AppartenenteGruppo(rp.id_partecipante,@dataEstrazione) > @filtroAppGruppo
                        --AND (sk_f2.isSocietaGruppo(rp.id_partecipante, 'B', @dataEstrazione) = 1 OR
                         --sk_f2.isSocietaGruppo(rp.id_partecipante, 'C', @dataEstrazione) = 1)
              END
            SET @numPartecipanti = 0
            OPEN Partecipanti_CUR
            FETCH NEXT FROM Partecipanti_CUR
            INTO @idRappPart, @idPartecipante, @classIASIndivid, @class2359Individ, @guidRP, @livelloFV
            WHILE (@@FETCH_STATUS = 0)
              BEGIN
                -- Conto il numero dei partecipanti
                SET @numPartecipanti = @numPartecipanti + 1

                -- Ricavo SNDG e Ragione Sociale Partecipante
                SET @SNDGPartecipante = ''
                SET @denomPartecipante = ''
                SELECT @SNDGPartecipante = p.SNDG, 
                       @denomPartecipante = coalesce(pg.Ragione_Sociale,'') + coalesce(pf.Cognome,'') + coalesce('-' + pf.Nome,''),
					   @tipoPersona = CASE 
										WHEN pf.ID IS NOT NULL THEN 'PF'
										ELSE 'PG'
									  END,
				@flagAppartieneGruppo =  SK_F2_REPORT.AppartenenteGruppo(@idPartecipante,@dataEstrazione)
                FROM 
				SK_F2.F2_T_Persona p 
				LEFT JOIN  SK_F2.F2_T_Persona_Fisica pf on p.ID = pf.ID_Persona
				LEFT JOIN  SK_F2.F2_T_Persona_Giuridica pg on p.ID = pg.ID_Persona
                WHERE 
				p.ID =  @idPartecipante
                AND (@dataEstrazione BETWEEN CONVERT(DATE, pg.Data_Inizio) AND isnull(pg.Data_Fine, '31/12/9999')
				     OR @dataEstrazione BETWEEN CONVERT(DATE, pf.Data_Inizio) AND isnull(pf.Data_Fine, '31/12/9999'))

                -- Ricavo dati Sede Legale Partecipante
                SET @indPartecipante = ''
                SET @capPartecipante = ''
                SET @cittaPartecipante = ''
                SET @provPartecipante = ''
                SET @statoPartecipante = ''
                SELECT
                  @indPartecipante = upper(Indirizzo),
                  @capPartecipante = upper(Cap),
                  @cittaPartecipante = upper(Citta),
                  @provPartecipante = (SELECT upper(Sigla_Provincia)
                                       FROM SK_F2.F2_V_Province
                                       WHERE upper(Descrizione_Provincia) = upper(Provincia)),
                  @statoPartecipante = upper(Stato)
                FROM SK_F2.F2_T_Indirizzi_Persona
                WHERE ID_Persona = @idPartecipante
                      AND ID_Tipo_Indirizzo = 4
                      AND @dataEstrazione BETWEEN CONVERT(DATE, Data_Inizio) AND isnull(Data_Fine, '31/12/9999')
					  
                -- Ricavo Codice Mappa di Gruppo Partecipante (su eventuale operazione di partecipazione)
                SET @cmgPartecipante = ''
                -- Sostituito pezzo commentato con richiamo della funzione di lettura CMG
                SELECT @cmgPartecipante = SK_F2_REPORT.getCodiceMappaGruppo(@idPartecipante, 'P', @dataEstrazione)
                SET @cmgPartecipante = ISNULL(@cmgPartecipante, '')

                -- Ricavo dati di possesso a livello di partecipante
                SET @idRP = 0
                SET @valutaPartecipante = ''
				SET @percEquityRatio = ''
                SET @percDirettaTot = ''
                SET @percDirettaDVTot = ''
                SET @valBilancioIndivValuta = ''
                SET @valBilancioIndivEuro = ''
                SET @valBilancioGruppo = ''
                SET @impSuOperazione = ''
                IF @tipoOperazione = 'IMP'
                  BEGIN
                    SET @idRP = @idRappPart

                    SELECT TOP 1
                      @valutaPartecipante = ID_Valuta,
                      @impSuOperazione = ID_Tipo_Operazione
                    FROM SK_F2.F2_T_Impegni_Contabili
                    WHERE ID = @idRP

                    SELECT
                      @percDirettaTot = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                  SK_F2.getQuotaPartecipanteImpegni(@idRP,
                                                                                                    @dataEstrazione) *
                                                                  100)),
                      @percDirettaDVTot = convert(NVARCHAR, 0),
                      @valBilancioIndivValuta = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                          SK_F2_REPORT.getValoreBilancioPartecipanteImpegni(
                                                                              @idRP, @dataEstrazione))),
                      @valBilancioIndivEuro = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                        SK_F2_REPORT.getValoreBilancioPartecipanteImpegniEuro(
                                                                            @idRP, @dataEstrazione))),
                      @valBilancioGruppo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                     SK_F2_REPORT.getValoreBilancioGruppoImpegni(
                                                                         @idOperazione, @dataEstrazione)))
                  END
                ELSE IF @tipoOperazione = 'IND'
                  BEGIN
                    SET @idRP = @idRappPart

                    SELECT TOP 1
                      @valutaPartecipante = ID_Valuta,
                      @impSuOperazione = ID_Tipo_Operazione
                    FROM SK_F2.F2_T_Saldi_Indirette_OI sal, SK_F2.F2_T_Operazioni op
                    WHERE sal.ID_Indiretta = @idRP and op.ID = @idOperazione

                    DECLARE @quotaPartecipanteIndiretta DECIMAL(10, 3)
                    SET @quotaPartecipanteIndiretta = convert(DECIMAL(10, 3), SK_F2.getQuotaPartecipanteIndirette(@idRP,
                                                                                                                  @dataEstrazione)
                                                                              * 100);

                    SELECT
                      @percEquityRatio = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                   SK_F2.calculate_EquityRatio_OI(@idRP, @quotaPartecipanteIndiretta,
                                                                                                  @dataEstrazione))),
                      @percDirettaTot = convert(NVARCHAR, @quotaPartecipanteIndiretta),
                      @percDirettaDVTot = convert(NVARCHAR, 0),
                      @valBilancioIndivValuta = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                          SK_F2_REPORT.getValoreBilancioIndirette(
                                                                              @idRP, @dataEstrazione))),
                      @valBilancioIndivEuro = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                        SK_F2_REPORT.getValoreBilancioIndiretteEuro(
                                                                            @idRP, @dataEstrazione))),
                      @valBilancioGruppo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                     SK_F2_REPORT.getValoreBilancioGruppoIndirette(
                                                                         @idOperazione, @dataEstrazione)))
                  END
                ELSE
                  BEGIN

                    SELECT TOP 1 @idRP = ID
                    FROM SK_F2.F2_T_Rapporti_Partecipativi
                    WHERE GUID_Rapp_Partecipativi = @guidRP
                    ORDER BY Data_Inizio DESC

                    SET @valutaPartecipante = NULL
                    SELECT TOP 1 @valutaPartecipante = ID_Valuta
                    FROM SK_F2.F2_T_Saldi
                    WHERE ID_Rapporto_Partecipativo = @idRP
                          AND ID_Valuta IS NOT NULL AND ltrim(rtrim(ID_Valuta)) <> ''
                    ORDER BY Data_Saldo DESC
                    SET @valutaPartecipante = isnull(@valutaPartecipante, '242')

                    SELECT
                      @percDirettaTot = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                  SK_F2_REPORT.getQuotaPartecipante(@idRP,
                                                                                                    @dataEstrazione) *
                                                                  100)),
                      @percDirettaDVTot = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                    SK_F2_REPORT.getQuotaDVPartecipante(@idRP,
                                                                                                        @dataEstrazione)
                                                                    * 100)),
                      @valBilancioIndivValuta = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                          SK_F2_REPORT.getValoreBilancioPartecipante(
                                                                              @idRP, @dataEstrazione, 'V'))),
                      @valBilancioIndivEuro = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                        SK_F2_REPORT.getValoreBilancioPartecipante(
                                                                            @idRP, @dataEstrazione, 'E'))),
                      @valBilancioGruppo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                     SK_F2_REPORT.getValoreBilancioGruppo(@idOperazione,
                                                                                                          @dataEstrazione)))
                  END

                --IF @tipoOperazione = 'P' -- Operazioni assimilabili a Partecipazione ???? TODO
                IF @tipoOperazione IN ('P', 'D', 'OC', 'IND') OR
                   (@tipoOperazione = 'IMP' AND @impSuOperazione IN ('P', 'D', 'OC'))
                  BEGIN
                    -- Titoli del Capitale Sociale
                    DECLARE Titoli_CUR CURSOR FOR
                      SELECT DISTINCT
                        tit.ID,
                        tit.ID_Titolo_Azione,
                        tit.Codice_ISIN,
                        tit.Descrizione,
                        tit.Numero_Azioni
                      FROM sk_f2.f2_t_titoli tit
                      WHERE tit.ID_Persona = @idPartecipata
                            AND @dataEstrazione BETWEEN CONVERT(DATE, tit.Data_Inizio) AND isnull(tit.Data_Fine, '31/12/9999')
                            AND (tit.Cancellata = 0 OR tit.Cancellata IS NULL)

                    OPEN Titoli_CUR
                    FETCH NEXT FROM Titoli_CUR
                    INTO @idTitolo, @codTitolo, @isinTitolo, @descrTitolo, @numAzioniTitCS

                    WHILE (@@FETCH_STATUS = 0)
                      BEGIN

                        -- Ricavo dati di possesso sul titolo
                        SET @azioniPartecipanteTitolo = ''
                        SET @percDirettaTitolo = ''
                        SET @azioniPartecipanteDVTitolo = ''
                        SET @percDirettaDVTitolo = ''
                        SET @percGruppoTitolo = ''
                        SET @percDVGruppoTitolo = ''
                        SET @valNominPartecipanteTitolo = ''
                        SET @valNominPartecipanteTitoloEuro = ''
                        IF @tipoOperazione = 'IMP'
                          BEGIN
                            SELECT
                              @azioniPartecipanteTitolo = convert(NVARCHAR, ic.Numero_Azioni),
                              @percDirettaTitolo = CASE WHEN isnull(@numAzioniTitCS, 0) = 0
                                THEN convert(NVARCHAR, 0)
                                                   ELSE convert(NVARCHAR, (ic.Numero_Azioni / @numAzioniTitCS) * 100)
                                                   END,
                              @azioniPartecipanteDVTitolo = convert(NVARCHAR, 0),
                              @percDirettaDVTitolo = convert(NVARCHAR, 0),
                              @percGruppoTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                            SK_F2.getQuotaGruppoImpegni(@idOperazione,
                                                                                                        @dataEstrazione)
                                                                            * 100)),
                              @percDVGruppoTitolo = convert(NVARCHAR, 0),
                              @valNominPartecipanteTitolo = convert(NVARCHAR, ic.Numero_Azioni *
                                                                              (SK_F2_REPORT.getValNominaleUnitarioTitolo(
                                                                                  @idTitolo, @dataEstrazione))),
                              @valNominPartecipanteTitoloEuro = convert(NVARCHAR, ic.Numero_Azioni *
                                                                                  (SK_F2_REPORT.getValNominaleUnitarioTitoloEuro(
                                                                                      @idTitolo, @dataEstrazione)))
                            FROM SK_F2.F2_T_Impegni_Contabili ic
                            WHERE ic.ID = @idRP

                          END
                        ELSE
                          BEGIN
                            SELECT
                              @azioniPartecipanteTitolo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                    SK_F2_REPORT.getNumeroAzioniTitoloPartecipante(
                                                                                        @idRP, @dataEstrazione,
                                                                                        @idTitolo))),
                              @percDirettaTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                             SK_F2_REPORT.getQuotaTitoloPartecipante(
                                                                                 @idRP, @dataEstrazione, @idTitolo) *
                                                                             100)),
                              @azioniPartecipanteDVTitolo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                      SK_F2_REPORT.getNumeroAzioniTitoloPartecipanteDV(
                                                                                          @idRP, @dataEstrazione,
                                                                                          @idTitolo))),
                              @percDirettaDVTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                               SK_F2_REPORT.getQuotaDVTitoloPartecipante(
                                                                                   @idRP, @dataEstrazione, @idTitolo) *
                                                                               100)),
                              @percGruppoTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                            SK_F2_REPORT.getQuotaGruppoTitolo(
                                                                                @idOperazione, @dataEstrazione,
                                                                                @idTitolo) * 100)),
                              @percDVGruppoTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                              SK_F2_REPORT.getQuotaDVGruppoTitolo(
                                                                                  @idOperazione, @dataEstrazione,
                                                                                  @idTitolo) * 100)),
                              @valNominPartecipanteTitolo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                      SK_F2_REPORT.getValNominaleComplTitoloPartecipante(
                                                                                          @idRP, @dataEstrazione,
                                                                                          @idTitolo))),
                              @valNominPartecipanteTitoloEuro = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                          SK_F2_REPORT.getValNominaleComplTitoloPartecipanteEuro(
                                                                                              @idRP, @dataEstrazione,
                                                                                              @idTitolo)))
                          END

                        SET @prezzoIASEuro = ''
                        SET @prezzoIASEuro = convert(NVARCHAR, convert(DECIMAL(28, 2), CASE WHEN
                          convert(DECIMAL(28, 2), @azioniPartecipanteTitolo) = 0
                          THEN 0
                                                                                       ELSE (convert(DECIMAL(28, 2),
                                                                                                     @valBilancioIndivEuro)
                                                                                             / convert(DECIMAL(28, 2),
                                                                                                       @azioniPartecipanteTitolo)) END))

                        -- Inserimento record in tabella SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
                        INSERT INTO SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa (
                          Data_estrazione
                          , Destinazione
                          , Codice_Titolo
                          , Descrizione_Titolo
                          , Codice_Partecipata
                          , Denom_Partecipata
                          , Tipo_Operazione
                          , Codice_Partecipante
                          , Denom_Partecipante
                          , Ind_Legale_Partecipata
                          , Cap_Legale_Partecipata
                          , Citta_Legale_Partecipata
                          , Prov_Legale_Partecipata
                          , Stato_Legale_Partecipata
                          , Ex_Art_3639RM
                          , Ind_Legale_Partecipante
                          , Cap_Legale_Partecipante
                          , Citta_Legale_Partecipante
                          , Prov_Legale_Partecipante
                          , Stato_Legale_Partecipante
                          , Valuta_CS_Partecipante
                          , CR_Partecipata
                          , CF_Partecipata
                          , Forma_Giuridica
                          , UIC_Partecipata
                          , Valuta_Bilancio
                          , PIVA_Partecipata
                          , Descrizione_ClassBI
                          , Descrizione_Attivita
                          , SNDG
                          , ABI_Prevalente
                          , NDG_Prevalente
                          , NDG_Capogruppo
                          , Gruppo_Bancario
                          , Gruppo_Civilistico
                          , Gruppo_Assicurativo
                          , SAE
                          , RAE
                          , ATECO
                          , Nazionalita
                          , Gestore_Partecipazione
                          , Quotata
                          , Tipo_Quotazione
                          , Metodo_ConsBI
                          , Metodo_ConsIAS
                          , Metodo_ConsFinrep
                          , Data_Inserimento
                          , Class_IAS_Gruppo
                          , Class_Art2359_Gruppo
                          , Class_IAS_Individuale
                          , Class_Art2359_Individuale
                          , Class_Monitoraggio
                          , Class_Antitrust
                          , Tipologia_FAG
                          , Centro_Resp
                          , CGU
                          , SNDG_ControllataRif
                          , Flag_OrgInterposto
                          , Flag_OpQualificata
                          , Tipo_LookThrough
                          , Class_PNF
                          , CS_Data
                          , CS_Valuta
                          , CS_Sottoscritto_Valuta
                          , CS_Sottoscritto_Euro
                          , CS_Deliberato_Valuta
                          , CS_Deliberato_Euro
                          , CS_Versato_Valuta
                          , CS_Versato_Euro
                          , CS_ValNominale_Unitario
                          , CS_Azioni
                          , CS_AzioniDV
                          , CS_AzioniDVAO
                          , PATR_ValoreCompl_Valuta
                          , PATR_ValoreCompl_Euro
                          , PATR_Quote
                          , Valuta_Operazione
                          , Valore_Civilistico_Valuta
                          , Valore_Civilistico_Euro
                          , Valore_Prezzo_IAS
                          , Valore_NominaleCompl_Divisa
                          , Valore_NominaleCompl_Euro
                          , Valore_Civilistico_Gruppo
                          , Autonomia
                          , Azioni_Partecipante
                          , Perc_Diretta_Titolo
                          , Perc_Diretta_Totale
                          , AzioniDV_Partecipante
                          , PercDV_Diretta_Titolo
                          , PercDV_Diretta_Totale
                          , Azioni_Gruppo
                          , Perc_Gruppo_Titolo
                          , Perc_Gruppo_Totale
                          , AzioniDV_Gruppo
                          , PercDV_Gruppo_Titolo
                          , PercDV_Gruppo_Totale
                          , Livello_FairValue
                          , Perc_Equity_Ratio
                          , Valore_Package
                          , Riserva_AFS_Netta
                          , Impairment_Anno_Individuale
                          , Impairment_Anno_Consolidato
                          , Valore_Consolidato
                          , Valore_Consolidato_Gruppo
                          , Di_Cui_Avviamenti
                          , Riserva_AFS_Lorda
                          , Delta_Valore_Civilistico
                          , Data_Rif_BOFinance
                          , Super_ISIN
                          , SNDG_Partecipante
                          , Perc_SFP_Convertibile
						  , tipo_persona
						  , flagGruppo
                          , Flag_Scarto
                          , Motivo_Scarto)
                        VALUES (convert(NVARCHAR, @dataEstrazione, 112)  -- Data_estrazione - date
                          , @destinazione -- Destinazione del flusso - nvarchar(10)
                          , ISNULL(@codTitolo, '') -- Codice_Titolo - nvarchar(20)
                          , ISNULL(@descrTitolo, '') -- Descrizione_Titolo - nvarchar(200)
                          , ISNULL(@cmgPartecipata, '') -- Codice_Partecipata - nvarchar(16)
                          , ISNULL(@denomPartecipata, '') -- Denom_Partecipata - nvarchar(150)
                          , ISNULL(@tipoOperazione, '') -- Tipo_Operazione - nvarchar(5)
                          , ISNULL(@cmgPartecipante, '') -- Codice_Partecipante - nvarchar(16)
                          , ISNULL(@denomPartecipante, '') -- Denom_Partecipante - nvarchar(150)
                          , ISNULL(@indPartecipata, '') -- Ind_Legale_Partecipata - nvarchar(100)
                          , ISNULL(@capPartecipata, '') -- Cap_Legale_Partecipata - nvarchar(10)
                          , ISNULL(@cittaPartecipata, '') -- Citta_Legale_Partecipata - nvarchar(100)
                          , ISNULL(@provPartecipata, '') -- Prov_Legale_Partecipata - nvarchar(2)
                          , ISNULL(@statoPartecipata, '') -- Stato_Legale_Partecipata - nvarchar(100)
                          , ISNULL(@extraUE, '') -- Ex_Art_3639RM - nvarchar(100)
                          , ISNULL(@indPartecipante, '') -- Ind_Legale_Partecipante - nvarchar(100)
                          , ISNULL(@capPartecipante, '') -- Cap_Legale_Partecipante - nvarchar(10)
                          , ISNULL(@cittaPartecipante, '') -- Citta_Legale_Partecipante - nvarchar(100)
                          , ISNULL(@provPartecipante, '') -- Prov_Legale_Partecipante - nvarchar(2)
                          , ISNULL(@statoPartecipante, '') -- Stato_Legale_Partecipante - nvarchar(100)
                          , ISNULL(@valutaPartecipante, '242') -- Valuta_CS_Partecipante - nvarchar(3)
                          , ISNULL(@codiceCR, '') -- CR_Partecipata - nvarchar(16)
                          , ISNULL(@codFiscale, '') -- CF_Partecipata - nvarchar(16)
                          , ISNULL(@tipoNDG, '') -- Forma_Giuridica - nvarchar(5)
                          , ISNULL(@codiceUIC, '') -- UIC_Partecipata - nvarchar(16)
                          , ISNULL(@valutaBilancio, '') -- Valuta_Bilancio - nvarchar(3)
                          , ISNULL(@partitaIVA, '') -- PIVA_Partecipata - nvarchar(16)
                          , ISNULL(@classBI, '') -- Descrizione_ClassBI - nvarchar(100)
                          , ISNULL(@descrAttivita, '') -- Descrizione_Attivita - nvarchar(150)
                          , ISNULL(@sndgPartecipata, '') -- SNDG - nvarchar(16)
                          , ISNULL(@abiPrevPartecipata, '') -- ABI_Prevalente - nvarchar(5)
                          , ISNULL(@ndgPrevPartecipata, '') -- NDG_Prevalente - nvarchar(16)
                          , ISNULL(@ndgCGPartecipata, '') -- NDG_Capogruppo - nvarchar(16)
                          , ISNULL(@grpBancario, '') -- Gruppo_Bancario - nvarchar(1)
                          , ISNULL(@grpCivilist, '') -- Gruppo_Civilistico - nvarchar(1)
                          , ISNULL(@grpAssicur, '') -- Gruppo_Assicurativo - nvarchar(1)
                          , ISNULL(@SAE, '') -- SAE - nvarchar(6)
                          , ISNULL(@RAE, '') -- RAE - nvarchar(6)
                          , ISNULL(@ateco, '') -- ATECO - nvarchar(10)
                          , ISNULL(@nazionalita, '') -- Nazionalita - nvarchar(1)
                          , ISNULL(@gestorePart, '') -- Gestore_Partecipazione - nvarchar(100)
                          , ISNULL(@quotata, '') -- Quotata - nvarchar(60)
                          , ISNULL(@tipoQuot, '') -- Tipo_Quotazione - nvarchar(100)
                          , ISNULL(@metodoConsBI, '') -- Metodo_ConsBI - nvarchar(100)
                          , ISNULL(@metodoConsIAS, '') -- Metodo_ConsIAS - nvarchar(100)
                          , ISNULL(@metodoConsFinrep, '') -- Metodo_ConsFinrep - nvarchar(100)
                          , convert(NVARCHAR, @dataINS, 112) -- Data_Inserimento - nvarchar(8)
                          , ISNULL(@classIASgruppo, '') -- Class_IAS_Gruppo - nvarchar(100)
                          , ISNULL(@class2359gruppo, '') -- Class_Art2359_Gruppo - nvarchar(100)
                          , ISNULL(@classIASIndivid, '') -- Class_IAS_Individuale - nvarchar(100)
                          , ISNULL(@class2359Individ, '') -- Class_Art2359_Individuale - nvarchar(100)
                          , ISNULL(@classMonit, '') -- Class_Monitoraggio - nvarchar(100)
                          , ISNULL(@classAntitrust, '') -- Class_Antitrust - nvarchar(100)
                          , ISNULL(@tipologiaFAG, '') -- Tipologia_FAG - nvarchar(100)
                          , ISNULL(@centroResp, '') -- Centro_Resp - nvarchar(100)
                          , ISNULL(@CGU, '') -- CGU - nvarchar(100)
                          , N'' -- SNDG_ControllataRif - nvarchar(16)
                          , ISNULL(@orgInterposto, '') -- Flag_OrgInterposto - nvarchar(1)
                          , ISNULL(@opQualificata, '') -- Flag_OpQualificata - nvarchar(1)
                          , ISNULL(@tipoLookT, '') -- Tipo_LookThrough - nvarchar(100)
                          , ISNULL(@classPNF, '') -- Class_PNF - nvarchar(100)
                          , convert(NVARCHAR, @dataIniCS, 112) -- CS_Data - nvarchar(8)
                          , ISNULL(@valutaCS, '') -- CS_Valuta - nvarchar(3)
                          , replace(ISNULL(@CSsottoscrValuta, ''), '.', ',') -- CS_Sottoscritto_Valuta - nvarchar(28)
                          , replace(ISNULL(@CSsottoscrEuro, ''), '.', ',') -- CS_Sottoscritto_Euro - nvarchar(28)
                          , replace(ISNULL(@CSdelibValuta, ''), '.', ',') -- CS_Deliberato_Valuta - nvarchar(28)
                          , replace(ISNULL(@CSsdelibEuro, ''), '.', ',') -- CS_Deliberato_Euro - nvarchar(28)
                          , replace(ISNULL(@CSversatoValuta, ''), '.', ',') -- CS_Versato_Valuta - nvarchar(28)
                          , replace(ISNULL(@CSversatoEuro, ''), '.', ',') -- CS_Versato_Euro - nvarchar(28)
                          , replace(ISNULL(@CSvalNominUnit, ''), '.', ',') -- CS_ValNominale_Unitario - nvarchar(28)
                          , replace(ISNULL(@totAzioniCS, ''), '.', ',') -- CS_Azioni - nvarchar(28)
                          , replace(ISNULL(@totAzioniDVCS, ''), '.', ',') -- CS_AzioniDV - nvarchar(28)
                          , replace(ISNULL(@totAzioniDVAOCS, ''), '.', ',') -- CS_AzioniDVAO - nvarchar(28)
                          , replace(ISNULL(@PATRvalComplValuta, ''), '.', ',') -- PATR_ValoreCompl_Valuta - nvarchar(28)
                          , replace(ISNULL(@PATRvalComplEuro, ''), '.', ',') -- PATR_ValoreCompl_Euro - nvarchar(28)
                          , replace(ISNULL(@PATRtotQuote, ''), '.', ',') -- PATR_Quote - nvarchar(28)
                          , replace(ISNULL(@valutaBilancio, ''), '.', ',') -- Valuta_Operazione - nvarchar(3)
                          , replace(ISNULL(@valBilancioIndivValuta, ''), '.', ',')
                                                                        -- Valore_Civilistico_Valuta - nvarchar(28)
                          , replace(ISNULL(@valBilancioIndivEuro, ''), '.', ',')
                                                                        -- Valore_Civilistico_Euro - nvarchar(28)
                          , replace(ISNULL(@prezzoIASEuro, ''), '.', ',')
                                                                        -- Valore_Prezzo_IAS - nvarchar(28) Valore civ euro / num azioni partecipante
                          , replace(ISNULL(@valNominPartecipanteTitolo, ''), '.', ',')
                          -- Valore_NominaleCompl_Divisa - nvarchar(28)
                          , replace(ISNULL(@valNominPartecipanteTitoloEuro, ''), '.', ',')
                          -- Valore_NominaleCompl_Euro - nvarchar(28)
                          , replace(ISNULL(@valBilancioGruppo, ''), '.', ',')
                          -- Valore_Civilistico_Gruppo - nvarchar(28)
                          , '' -- Autonomia - nvarchar(100) -- SEMPRE VUOTO
                          , replace(ISNULL(@azioniPartecipanteTitolo, ''), '.', ',')
                          -- Azioni_Partecipante - nvarchar(28)
                          , replace(ISNULL(@percDirettaTitolo, ''), '.', ',') -- Perc_Diretta_Titolo - nvarchar(10)
                          , replace(ISNULL(@percDirettaTot, ''), '.', ',') -- Perc_Diretta_Totale - nvarchar(10)
                          , replace(ISNULL(@azioniPartecipanteDVTitolo, ''), '.', ',')
                          -- AzioniDV_Partecipante - nvarchar(28)
                          , replace(ISNULL(@percDirettaDVTitolo, ''), '.', ',') -- PercDV_Diretta_Titolo - nvarchar(10)
                          , replace(ISNULL(@percDirettaDVTot, ''), '.', ',') -- PercDV_Diretta_Totale - nvarchar(10)
                          , replace(ISNULL(@totAzioniGruppo, ''), '.', ',') -- Azioni_Gruppo - nvarchar(28)
                          , replace(ISNULL(@percGruppoTitolo, ''), '.', ',') -- Perc_Gruppo_Titolo - nvarchar(10)
                          , replace(ISNULL(@percGruppoTotale, ''), '.', ',') -- Perc_Gruppo_Totale - nvarchar(10)
                          , replace(ISNULL(@totAzioniDVGruppo, ''), '.', ',') -- AzioniDV_Gruppo - nvarchar(28)
                          , replace(ISNULL(@percDVGruppoTitolo, ''), '.', ',') -- PercDV_Gruppo_Titolo - nvarchar(10)
                          , replace(ISNULL(@percGruppoDVTotale, ''), '.', ',') -- PercDV_Gruppo_Totale - nvarchar(10)
                          , ISNULL(@livelloFV, '') -- Livello_FairValue - nvarchar(3)
                          , replace(ISNULL(@percEquityRatio, ''), '.', ',') --  Perc_Equity_Ratio - nvarchar(10)
                          , '' -- TODO --  Valore_Package - nvarchar(28)
                          , '' -- TODO --  Riserva_AFS_Netta - nvarchar(28)
                          , '' -- TODO --  Impairment_Anno_Individuale - nvarchar(28)
                          , '' -- TODO --  Impairment_Anno_Consolidato - nvarchar(28)
                          , '' -- TODO --  Valore_Consolidato - nvarchar(28)
                          , '' -- TODO --  Valore_Consolidato_Gruppo - nvarchar(28)
                          , '' -- TODO --  Di_Cui_Avviamenti - nvarchar(28)
                          , '' -- TODO --  Riserva_AFS_Lorda - nvarchar(28)
                          , '' -- TODO --  Delta_Valore_Civilistico - nvarchar(28)
                          , '' -- TODO --  Data_Rif_BOFinance - nvarchar(8)
                          , ISNULL(@superISIN, '') -- Super_ISIN - nvarchar(16)
                          , ISNULL(@sndgPartecipante, '') -- SNDG_Partecipante - nvarchar(16)
                          , replace(ISNULL(@percSFPConvertibile, ''), '.', ',') -- Perc_SFP_Convertibile - nvarchar(10)
						   , ISNULL(@tipoPersona,'')
						  , @flagAppartieneGruppo  
                          , @flagScarto  -- Flag_Scarto - bit
                          , @motivoScarto -- Motivo_Scarto - nvarchar(2000)
                        )
                        
                        FETCH NEXT FROM Titoli_CUR
                        INTO @idTitolo, @codTitolo, @isinTitolo, @descrTitolo, @numAzioniTitCS
                      END
                    CLOSE Titoli_CUR
                    DEALLOCATE Titoli_CUR

                  END
                ELSE
                  BEGIN

                    -- Quote del patrimonio
                    DECLARE Quote_CUR CURSOR FOR
                      SELECT DISTINCT
                        quo.ID,
                        quo.ID_Quota,
                        qdes.Codice_ISIN,
                        qdes.Descrizione,
                        quo.Numero_Quote
                      FROM sk_f2.f2_t_quote quo, SK_F2.F2_D_Quote qdes
                      WHERE quo.ID_Persona = @idPartecipata
                            AND qdes.ID = quo.ID_Quota
                            AND @dataEstrazione BETWEEN quo.Data_Inizio AND isnull(quo.Data_Fine, '31/12/9999')
                            AND (quo.Cancellata = 0 OR quo.Cancellata IS NULL)

                    OPEN Quote_CUR
                    FETCH NEXT FROM Quote_CUR
                    INTO @idQuota, @codQuota, @isinQuota, @descrQuota, @numQuotePatr

                    WHILE (@@FETCH_STATUS = 0)
                      BEGIN
                        -- Ricavo dati di possesso sulla quota
                        SET @azioniPartecipanteTitolo = ''
                        SET @percDirettaTitolo = ''
                        SET @azioniPartecipanteDVTitolo = ''
                        SET @percDirettaDVTitolo = ''
                        SET @percGruppoTitolo = ''
                        SET @percDVGruppoTitolo = ''
                        SET @valNominPartecipanteTitolo = ''
                        SET @valNominPartecipanteTitoloEuro = ''

                        IF @tipoOperazione = 'IMP'
                          BEGIN
                            SELECT
                              @azioniPartecipanteTitolo = convert(NVARCHAR, ic.Numero_Azioni),
                              @percDirettaTitolo = CASE WHEN isnull(@numQuotePatr, 0) = 0
                                THEN convert(NVARCHAR, 0)
                                                   ELSE convert(NVARCHAR, (ic.Numero_Azioni / @numQuotePatr) * 100)
                                                   END,
                              @azioniPartecipanteDVTitolo = convert(NVARCHAR, 0),
                              @percDirettaDVTitolo = convert(NVARCHAR, 0),
                              @percGruppoTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                            SK_F2.getQuotaGruppoImpegni(@idOperazione,
                                                                                                        @dataEstrazione)
                                                                            * 100)),
                              @percDVGruppoTitolo = convert(NVARCHAR, 0),
                              @valNominPartecipanteTitolo = convert(NVARCHAR, ic.Numero_Azioni *
                                                                              (SK_F2_REPORT.getValNominaleUnitarioQuota(
                                                                                  @idQuota, @dataEstrazione))),
                              @valNominPartecipanteTitoloEuro = convert(NVARCHAR, ic.Numero_Azioni *
                                                                                  (SK_F2_REPORT.getValNominaleUnitarioQuotaEuro(
                                                                                      @idQuota, @dataEstrazione)))
                            FROM SK_F2.F2_T_Impegni_Contabili ic
                            WHERE ic.ID = @idRP
                          END
                        ELSE
                          BEGIN
                            SELECT
                              @azioniPartecipanteTitolo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                    SK_F2_REPORT.getNumeroAzioniTitoloPartecipante(
                                                                                        @idRP, @dataEstrazione,
                                                                                        @idQuota))),
                              @percDirettaTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                             SK_F2_REPORT.getQuotaTitoloPartecipante(
                                                                                 @idRP, @dataEstrazione, @idQuota) *
                                                                             100)),
                              @azioniPartecipanteDVTitolo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                      SK_F2_REPORT.getNumeroAzioniTitoloPartecipanteDV(
                                                                                          @idRP, @dataEstrazione,
                                                                                          @idQuota))),
                              @percDirettaDVTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                               SK_F2_REPORT.getQuotaDVTitoloPartecipante(
                                                                                   @idRP, @dataEstrazione, @idQuota) *
                                                                               100)),
                              @percGruppoTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                            SK_F2_REPORT.getQuotaGruppoTitolo(
                                                                                @idOperazione, @dataEstrazione,
                                                                                @idQuota) * 100)),
                              @percDVGruppoTitolo = convert(NVARCHAR, convert(DECIMAL(10, 3),
                                                                              SK_F2_REPORT.getQuotaDVGruppoTitolo(
                                                                                  @idOperazione, @dataEstrazione,
                                                                                  @idQuota) * 100)),
                              @valNominPartecipanteTitolo = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                      SK_F2_REPORT.getValNominaleComplTitoloPartecipante(
                                                                                          @idRP, @dataEstrazione,
                                                                                          @idQuota))),
                              @valNominPartecipanteTitoloEuro = convert(NVARCHAR, convert(DECIMAL(28, 2),
                                                                                          SK_F2_REPORT.getValNominaleComplTitoloPartecipanteEuro(
                                                                                              @idRP, @dataEstrazione,
                                                                                              @idQuota)))
                          END

                        SET @prezzoIASEuro = ''
                        SET @prezzoIASEuro = convert(NVARCHAR, convert(DECIMAL(28, 2), CASE WHEN
                          convert(DECIMAL(28, 2), @azioniPartecipanteTitolo) = 0
                          THEN 0
                                                                                       ELSE (convert(DECIMAL(28, 2),
                                                                                                     @valBilancioIndivEuro)
                                                                                             / convert(DECIMAL(28, 2),
                                                                                                       @azioniPartecipanteTitolo)) END))

                        -- Inserimento record in tabella SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
                        INSERT INTO SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa (
                          Data_estrazione
                          , Destinazione
                          , Codice_Titolo
                          , Descrizione_Titolo
                          , Codice_Partecipata
                          , Denom_Partecipata
                          , Tipo_Operazione
                          , Codice_Partecipante
                          , Denom_Partecipante
                          , Ind_Legale_Partecipata
                          , Cap_Legale_Partecipata
                          , Citta_Legale_Partecipata
                          , Prov_Legale_Partecipata
                          , Stato_Legale_Partecipata
                          , Ex_Art_3639RM
                          , Ind_Legale_Partecipante
                          , Cap_Legale_Partecipante
                          , Citta_Legale_Partecipante
                          , Prov_Legale_Partecipante
                          , Stato_Legale_Partecipante
                          , Valuta_CS_Partecipante
                          , CR_Partecipata
                          , CF_Partecipata
                          , Forma_Giuridica
                          , UIC_Partecipata
                          , Valuta_Bilancio
                          , PIVA_Partecipata
                          , Descrizione_ClassBI
                          , Descrizione_Attivita
                          , SNDG
                          , ABI_Prevalente
                          , NDG_Prevalente
                          , NDG_Capogruppo
                          , Gruppo_Bancario
                          , Gruppo_Civilistico
                          , Gruppo_Assicurativo
                          , SAE
                          , RAE
                          , ATECO
                          , Nazionalita
                          , Gestore_Partecipazione
                          , Quotata
                          , Tipo_Quotazione
                          , Metodo_ConsBI
                          , Metodo_ConsIAS
                          , Metodo_ConsFinrep
                          , Data_Inserimento
                          , Class_IAS_Gruppo
                          , Class_Art2359_Gruppo
                          , Class_IAS_Individuale
                          , Class_Art2359_Individuale
                          , Class_Monitoraggio
                          , Class_Antitrust
                          , Tipologia_FAG
                          , Centro_Resp
                          , CGU
                          , SNDG_ControllataRif
                          , Flag_OrgInterposto
                          , Flag_OpQualificata
                          , Tipo_LookThrough
                          , Class_PNF
                          , CS_Data
                          , CS_Valuta
                          , CS_Sottoscritto_Valuta
                          , CS_Sottoscritto_Euro
                          , CS_Deliberato_Valuta
                          , CS_Deliberato_Euro
                          , CS_Versato_Valuta
                          , CS_Versato_Euro
                          , CS_ValNominale_Unitario
                          , CS_Azioni
                          , CS_AzioniDV
                          , CS_AzioniDVAO
                          , PATR_ValoreCompl_Valuta
                          , PATR_ValoreCompl_Euro
                          , PATR_Quote
                          , Valuta_Operazione
                          , Valore_Civilistico_Valuta
                          , Valore_Civilistico_Euro
                          , Valore_Prezzo_IAS
                          , Valore_NominaleCompl_Divisa
                          , Valore_NominaleCompl_Euro
                          , Valore_Civilistico_Gruppo
                          , Autonomia
                          , Azioni_Partecipante
                          , Perc_Diretta_Titolo
                          , Perc_Diretta_Totale
                          , AzioniDV_Partecipante
                          , PercDV_Diretta_Titolo
                          , PercDV_Diretta_Totale
                          , Azioni_Gruppo
                          , Perc_Gruppo_Titolo
                          , Perc_Gruppo_Totale
                          , AzioniDV_Gruppo
                          , PercDV_Gruppo_Titolo
                          , PercDV_Gruppo_Totale
                          , Livello_FairValue
                          , Perc_Equity_Ratio
                          , Valore_Package
                          , Riserva_AFS_Netta
                          , Impairment_Anno_Individuale
                          , Impairment_Anno_Consolidato
                          , Valore_Consolidato
                          , Valore_Consolidato_Gruppo
                          , Di_Cui_Avviamenti
                          , Riserva_AFS_Lorda
                          , Delta_Valore_Civilistico
                          , Data_Rif_BOFinance
                          , Super_ISIN
                          , SNDG_Partecipante
                          , Perc_SFP_Convertibile
						  , tipo_persona
						  , flagGruppo
                          , Flag_Scarto
                          , Motivo_Scarto)
                        VALUES (convert(NVARCHAR, @dataEstrazione, 112)  -- Data_estrazione - date
                          , @destinazione -- Destinazione del flusso - nvarchar(10)
                          , ISNULL(@codQuota, '') -- Codice_Titolo - nvarchar(20)
                          , ISNULL(@descrQuota, '') -- Descrizione_Titolo - nvarchar(200)
                          , ISNULL(@cmgPartecipata, '') -- Codice_Partecipata - nvarchar(16)
                          , ISNULL(@denomPartecipata, '') -- Denom_Partecipata - nvarchar(150)
                          , ISNULL(@tipoOperazione, '') -- Tipo_Operazione - nvarchar(5)
                          , ISNULL(@cmgPartecipante, '') -- Codice_Partecipante - nvarchar(16)
                          , ISNULL(@denomPartecipante, '') -- Denom_Partecipante - nvarchar(150)
                          , ISNULL(@indPartecipata, '') -- Ind_Legale_Partecipata - nvarchar(100)
                          , ISNULL(@capPartecipata, '') -- Cap_Legale_Partecipata - nvarchar(10)
                          , ISNULL(@cittaPartecipata, '') -- Citta_Legale_Partecipata - nvarchar(100)
                          , ISNULL(@provPartecipata, '') -- Prov_Legale_Partecipata - nvarchar(2)
                          , ISNULL(@statoPartecipata, '') -- Stato_Legale_Partecipata - nvarchar(100)
                          , ISNULL(@extraUE, '') -- Ex_Art_3639RM - nvarchar(100)
                          , ISNULL(@indPartecipante, '') -- Ind_Legale_Partecipante - nvarchar(100)
                          , ISNULL(@capPartecipante, '') -- Cap_Legale_Partecipante - nvarchar(10)
                          , ISNULL(@cittaPartecipante, '') -- Citta_Legale_Partecipante - nvarchar(100)
                          , ISNULL(@provPartecipante, '') -- Prov_Legale_Partecipante - nvarchar(2)
                          , ISNULL(@statoPartecipante, '') -- Stato_Legale_Partecipante - nvarchar(100)
                          , ISNULL(@valutaPartecipante, '242') -- Valuta_CS_Partecipante - nvarchar(3)
                          , ISNULL(@codiceCR, '') -- CR_Partecipata - nvarchar(16)
                          , ISNULL(@codFiscale, '') -- CF_Partecipata - nvarchar(16)
                          , ISNULL(@tipoNDG, '') -- Forma_Giuridica - nvarchar(5)
                          , ISNULL(@codiceUIC, '') -- UIC_Partecipata - nvarchar(16)
                          , ISNULL(@valutaBilancio, '') -- Valuta_Bilancio - nvarchar(3)
                          , ISNULL(@partitaIVA, '') -- PIVA_Partecipata - nvarchar(16)
                          , ISNULL(@classBI, '') -- Descrizione_ClassBI - nvarchar(100)
                          , ISNULL(@descrAttivita, '') -- Descrizione_Attivita - nvarchar(150)
                          , ISNULL(@sndgPartecipata, '') -- SNDG - nvarchar(16)
                          , ISNULL(@abiPrevPartecipata, '') -- ABI_Prevalente - nvarchar(5)
                          , ISNULL(@ndgPrevPartecipata, '') -- NDG_Prevalente - nvarchar(16)
                          , ISNULL(@ndgCGPartecipata, '') -- NDG_Capogruppo - nvarchar(16)
                          , ISNULL(@grpBancario, '') -- Gruppo_Bancario - nvarchar(1)
                          , ISNULL(@grpCivilist, '') -- Gruppo_Civilistico - nvarchar(1)
                          , ISNULL(@grpAssicur, '') -- Gruppo_Assicurativo - nvarchar(1)
                          , ISNULL(@SAE, '') -- SAE - nvarchar(6)
                          , ISNULL(@RAE, '') -- RAE - nvarchar(6)
                          , ISNULL(@ateco, '') -- ATECO - nvarchar(10)
                          , ISNULL(@nazionalita, '') -- Nazionalita - nvarchar(1)
                          , ISNULL(@gestorePart, '') -- Gestore_Partecipazione - nvarchar(100)
                          , ISNULL(@quotata, '') -- Quotata - nvarchar(60)
                          , ISNULL(@tipoQuot, '') -- Tipo_Quotazione - nvarchar(100)
                          , ISNULL(@metodoConsBI, '') -- Metodo_ConsBI - nvarchar(100)
                          , ISNULL(@metodoConsIAS, '') -- Metodo_ConsIAS - nvarchar(100)
                          , ISNULL(@metodoConsFinrep, '') -- Metodo_ConsFinrep - nvarchar(100)
                          , convert(NVARCHAR, @dataINS, 112) -- Data_Inserimento - nvarchar(8)
                          , ISNULL(@classIASgruppo, '') -- Class_IAS_Gruppo - nvarchar(100)
                          , ISNULL(@class2359gruppo, '') -- Class_Art2359_Gruppo - nvarchar(100)
                          , ISNULL(@classIASIndivid, '') -- Class_IAS_Individuale - nvarchar(100)
                          , ISNULL(@class2359Individ, '') -- Class_Art2359_Individuale - nvarchar(100)
                          , ISNULL(@classMonit, '') -- Class_Monitoraggio - nvarchar(100)
                          , ISNULL(@classAntitrust, '') -- Class_Antitrust - nvarchar(100)
                          , ISNULL(@tipologiaFAG, '') -- Tipologia_FAG - nvarchar(100)
                          , ISNULL(@centroResp, '') -- Centro_Resp - nvarchar(100)
                          , ISNULL(@CGU, '') -- CGU - nvarchar(100)
                          , N'' -- SNDG_ControllataRif - nvarchar(16)
                          , ISNULL(@orgInterposto, '') -- Flag_OrgInterposto - nvarchar(1)
                          , ISNULL(@opQualificata, '') -- Flag_OpQualificata - nvarchar(1)
                          , ISNULL(@tipoLookT, '') -- Tipo_LookThrough - nvarchar(100)
                          , ISNULL(@classPNF, '') -- Class_PNF - nvarchar(100)
                          , convert(NVARCHAR, @dataIniCS, 112) -- CS_Data - nvarchar(8)
                          , ISNULL(@valutaCS, '') -- CS_Valuta - nvarchar(3)
                          , replace(ISNULL(@CSsottoscrValuta, ''), '.', ',') -- CS_Sottoscritto_Valuta - nvarchar(28)
                          , replace(ISNULL(@CSsottoscrEuro, ''), '.', ',') -- CS_Sottoscritto_Euro - nvarchar(28)
                          , replace(ISNULL(@CSdelibValuta, ''), '.', ',') -- CS_Deliberato_Valuta - nvarchar(28)
                          , replace(ISNULL(@CSsdelibEuro, ''), '.', ',') -- CS_Deliberato_Euro - nvarchar(28)
                          , replace(ISNULL(@CSversatoValuta, ''), '.', ',') -- CS_Versato_Valuta - nvarchar(28)
                          , replace(ISNULL(@CSversatoEuro, ''), '.', ',') -- CS_Versato_Euro - nvarchar(28)
                          , replace(ISNULL(@CSvalNominUnit, ''), '.', ',') -- CS_ValNominale_Unitario - nvarchar(28)
                          , replace(ISNULL(@totAzioniCS, ''), '.', ',') -- CS_Azioni - nvarchar(28)
                          , replace(ISNULL(@totAzioniDVCS, ''), '.', ',') -- CS_AzioniDV - nvarchar(28)
                          , replace(ISNULL(@totAzioniDVAOCS, ''), '.', ',') -- CS_AzioniDVAO - nvarchar(28)
                          , replace(ISNULL(@PATRvalComplValuta, ''), '.', ',')-- PATR_ValoreCompl_Valuta - nvarchar(28)
                          , replace(ISNULL(@PATRvalComplEuro, ''), '.', ',') -- PATR_ValoreCompl_Euro - nvarchar(28)
                          , replace(ISNULL(@PATRtotQuote, ''), '.', ',') -- PATR_Quote - nvarchar(28)
                          , ISNULL(@valutaBilancio, '') -- Valuta_Operazione - nvarchar(3)
                          , replace(ISNULL(@valBilancioIndivValuta, ''), '.', ',')
                                                                        -- Valore_Civilistico_Valuta - nvarchar(28)
                          , replace(ISNULL(@valBilancioIndivEuro, ''), '.', ',')
                                                                        -- Valore_Civilistico_Euro - nvarchar(28)
                          , replace(ISNULL(@prezzoIASEuro, ''), '.', ',') -- Valore_Prezzo_IAS - nvarchar(28)
                          , replace(ISNULL(@valNominPartecipanteTitolo, ''), '.', ',')
                          -- Valore_NominaleCompl_Divisa - nvarchar(28)
                          , replace(ISNULL(@valNominPartecipanteTitoloEuro, ''), '.', ',')
                          -- Valore_NominaleCompl_Euro - nvarchar(28)
                          , replace(ISNULL(@valBilancioGruppo, ''), '.', ',')
                          -- Valore_Civilistico_Gruppo - nvarchar(28)
                          , '' -- Autonomia - nvarchar(100)
                          , replace(ISNULL(@azioniPartecipanteTitolo, ''), '.', ',')
                          -- Azioni_Partecipante - nvarchar(28)
                          , replace(ISNULL(@percDirettaTitolo, ''), '.', ',') -- Perc_Diretta_Titolo - nvarchar(10)
                          , replace(ISNULL(@percDirettaTot, ''), '.', ',') -- Perc_Diretta_Totale - nvarchar(10)
                          , replace(ISNULL(@azioniPartecipanteDVTitolo, ''), '.', ',')
                          -- AzioniDV_Partecipante - nvarchar(28)
                          , replace(ISNULL(@percDirettaDVTitolo, ''), '.', ',') -- PercDV_Diretta_Titolo - nvarchar(10)
                          , replace(ISNULL(@percDirettaDVTot, ''), '.', ',') -- PercDV_Diretta_Totale - nvarchar(10)
                          , replace(ISNULL(@totAzioniGruppo, ''), '.', ',') -- Azioni_Gruppo - nvarchar(28)
                          , replace(ISNULL(@percGruppoTitolo, ''), '.', ',') -- Perc_Gruppo_Titolo - nvarchar(10)
                          , replace(ISNULL(@percGruppoTotale, ''), '.', ',') -- Perc_Gruppo_Totale - nvarchar(10)
                          , replace(ISNULL(@totAzioniDVGruppo, ''), '.', ',') -- AzioniDV_Gruppo - nvarchar(28)
                          , replace(ISNULL(@percDVGruppoTitolo, ''), '.', ',') -- PercDV_Gruppo_Titolo - nvarchar(10)
                          , replace(ISNULL(@percGruppoDVTotale, ''), '.', ',') -- PercDV_Gruppo_Totale - nvarchar(10)
                          , ISNULL(@livelloFV, '') -- Livello_FairValue - nvarchar(3)
                          , replace(ISNULL(@percEquityRatio, ''), '.', ',') --  Perc_Equity_Ratio - nvarchar(10)
                          , '' -- TODO --  Valore_Package - nvarchar(28)
                          , '' -- TODO --  Riserva_AFS_Netta - nvarchar(28)
                          , '' -- TODO --  Impairment_Anno_Individuale - nvarchar(28)
                          , '' -- TODO --  Impairment_Anno_Consolidato - nvarchar(28)
                          , '' -- TODO --  Valore_Consolidato - nvarchar(28)
                          , '' -- TODO --  Valore_Consolidato_Gruppo - nvarchar(28)
                          , '' -- TODO --  Di_Cui_Avviamenti - nvarchar(28)
                          , '' -- TODO --  Riserva_AFS_Lorda - nvarchar(28)
                          , '' -- TODO --  Delta_Valore_Civilistico - nvarchar(28)
                          , '' -- TODO -- Data_Rif_BOFinance - nvarchar(8)
                          , ISNULL(@superISIN, '') -- Super_ISIN - nvarchar(16)
                          , ISNULL(@sndgPartecipante, '') -- SNDG_Partecipante - nvarchar(16)
                          , replace(ISNULL(@percSFPConvertibile, ''), '.', ',') -- Perc_SFP_Convertibile - nvarchar(10)  
						  , ISNULL(@tipoPersona,'')
						  , @flagAppartieneGruppo                      
                          , @flagScarto  -- Flag_Scarto - bit
                          , @motivoScarto -- Motivo_Scarto - nvarchar(2000)
                        )

                        FETCH NEXT FROM Quote_CUR
                        INTO @idQuota, @codQuota, @isinQuota, @descrQuota, @numQuotePatr
                      END
                    CLOSE Quote_CUR
                    DEALLOCATE Quote_CUR
                  END

                FETCH NEXT FROM Partecipanti_CUR
                INTO @idRappPart, @idPartecipante, @classIASIndivid, @class2359Individ, @guidRP, @livelloFV
              END
            CLOSE Partecipanti_CUR
            DEALLOCATE Partecipanti_CUR
          END -- Controllo esistenza classificazioni

        -- Se non ci sono partecipanti e non si tratta di una Partecipazione,
        -- inserisco nel flusso i soli dati anagrafici
        -- (anagrafica + classificazioni + capitale sociale/patrimonio)
        IF @numPartecipanti = 0 AND @tipoOperazione NOT IN ('P', 'D', 'OC', 'IMP', 'IND')
          BEGIN
            INSERT INTO SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa (
              Data_estrazione
              , Destinazione
              , Codice_Titolo
              , Descrizione_Titolo
              , Codice_Partecipata
              , Denom_Partecipata
              , Tipo_Operazione
              , Codice_Partecipante
              , Denom_Partecipante
              , Ind_Legale_Partecipata
              , Cap_Legale_Partecipata
              , Citta_Legale_Partecipata
              , Prov_Legale_Partecipata
              , Stato_Legale_Partecipata
              , Ex_Art_3639RM
              , Ind_Legale_Partecipante
              , Cap_Legale_Partecipante
              , Citta_Legale_Partecipante
              , Prov_Legale_Partecipante
              , Stato_Legale_Partecipante
              , Valuta_CS_Partecipante
              , CR_Partecipata
              , CF_Partecipata
              , Forma_Giuridica
              , UIC_Partecipata
              , Valuta_Bilancio
              , PIVA_Partecipata
              , Descrizione_ClassBI
              , Descrizione_Attivita
              , SNDG
              , ABI_Prevalente
              , NDG_Prevalente
              , NDG_Capogruppo
              , Gruppo_Bancario
              , Gruppo_Civilistico
              , Gruppo_Assicurativo
              , SAE
              , RAE
              , ATECO
              , Nazionalita
              , Gestore_Partecipazione
              , Quotata
              , Tipo_Quotazione
              , Metodo_ConsBI
              , Metodo_ConsIAS
              , Metodo_ConsFinrep
              , Data_Inserimento
              , Class_IAS_Gruppo
              , Class_Art2359_Gruppo
              , Class_IAS_Individuale
              , Class_Art2359_Individuale
              , Class_Monitoraggio
              , Class_Antitrust
              , Tipologia_FAG
              , Centro_Resp
              , CGU
              , SNDG_ControllataRif
              , Flag_OrgInterposto
              , Flag_OpQualificata
              , Tipo_LookThrough
              , Class_PNF
              , CS_Data
              , CS_Valuta
              , CS_Sottoscritto_Valuta
              , CS_Sottoscritto_Euro
              , CS_Deliberato_Valuta
              , CS_Deliberato_Euro
              , CS_Versato_Valuta
              , CS_Versato_Euro
              , CS_ValNominale_Unitario
              , CS_Azioni
              , CS_AzioniDV
              , CS_AzioniDVAO
              , PATR_ValoreCompl_Valuta
              , PATR_ValoreCompl_Euro
              , PATR_Quote
              , Valuta_Operazione
              , Valore_Civilistico_Valuta
              , Valore_Civilistico_Euro
              , Valore_Prezzo_IAS
              , Valore_NominaleCompl_Divisa
              , Valore_NominaleCompl_Euro
              , Valore_Civilistico_Gruppo
              , Autonomia
              , Azioni_Partecipante
              , Perc_Diretta_Titolo
              , Perc_Diretta_Totale
              , AzioniDV_Partecipante
              , PercDV_Diretta_Titolo
              , PercDV_Diretta_Totale
              , Azioni_Gruppo
              , Perc_Gruppo_Titolo
              , Perc_Gruppo_Totale
              , AzioniDV_Gruppo
              , PercDV_Gruppo_Titolo
              , PercDV_Gruppo_Totale
              , Livello_FairValue
              , Perc_Equity_Ratio
              , Valore_Package
              , Riserva_AFS_Netta
              , Impairment_Anno_Individuale
              , Impairment_Anno_Consolidato
              , Valore_Consolidato
              , Valore_Consolidato_Gruppo
              , Di_Cui_Avviamenti
              , Riserva_AFS_Lorda
              , Delta_Valore_Civilistico
              , Data_Rif_BOFinance
              , Super_ISIN
              , SNDG_Partecipante
              , Perc_SFP_Convertibile
			  , tipo_persona
			  , flagGruppo   
              , Flag_Scarto
              , Motivo_Scarto)
            VALUES (convert(NVARCHAR, @dataEstrazione, 112)  -- Data_estrazione - date
              , @destinazione -- Destinazione del flusso - nvarchar(10)
              , '' -- Codice_Titolo - nvarchar(20)
              , '' -- Descrizione_Titolo - nvarchar(200)
              , ISNULL(@cmgPartecipata, '') -- Codice_Partecipata - nvarchar(16)
              , ISNULL(@denomPartecipata, '') -- Denom_Partecipata - nvarchar(150)
              , ISNULL(@tipoOperazione, '') -- Tipo_Operazione - nvarchar(5)
              , '' -- Codice_Partecipante - nvarchar(16)
              , '' -- Denom_Partecipante - nvarchar(150)
              , ISNULL(@indPartecipata, '') -- Ind_Legale_Partecipata - nvarchar(100)
              , ISNULL(@capPartecipata, '') -- Cap_Legale_Partecipata - nvarchar(10)
              , ISNULL(@cittaPartecipata, '') -- Citta_Legale_Partecipata - nvarchar(100)
              , ISNULL(@provPartecipata, '') -- Prov_Legale_Partecipata - nvarchar(2)
              , ISNULL(@statoPartecipata, '') -- Stato_Legale_Partecipata - nvarchar(100)
              , ISNULL(@extraUE, '') -- Ex_Art_3639RM - nvarchar(100)
              , '' -- Ind_Legale_Partecipante - nvarchar(100)
              , '' -- Cap_Legale_Partecipante - nvarchar(10)
              , '' -- Citta_Legale_Partecipante - nvarchar(100)
              , '' -- Prov_Legale_Partecipante - nvarchar(2)
              , '' -- Stato_Legale_Partecipante - nvarchar(100)
              , '' -- Valuta_CS_Partecipante - nvarchar(3)
              , ISNULL(@codiceCR, '') -- CR_Partecipata - nvarchar(16)
              , ISNULL(@codFiscale, '') -- CF_Partecipata - nvarchar(16)
              , ISNULL(@tipoNDG, '') -- Forma_Giuridica - nvarchar(5)
              , ISNULL(@codiceUIC, '') -- UIC_Partecipata - nvarchar(16)
              , ISNULL(@valutaBilancio, '') -- Valuta_Bilancio - nvarchar(3)
              , ISNULL(@partitaIVA, '') -- PIVA_Partecipata - nvarchar(16)
              , ISNULL(@classBI, '') -- Descrizione_ClassBI - nvarchar(100)
              , ISNULL(@descrAttivita, '') -- Descrizione_Attivita - nvarchar(150)
              , ISNULL(@sndgPartecipata, '') -- SNDG - nvarchar(16)
              , ISNULL(@abiPrevPartecipata, '') -- ABI_Prevalente - nvarchar(5)
              , ISNULL(@ndgPrevPartecipata, '') -- NDG_Prevalente - nvarchar(16)
              , ISNULL(@ndgCGPartecipata, '') -- NDG_Capogruppo - nvarchar(16)
              , ISNULL(@grpBancario, '') -- Gruppo_Bancario - nvarchar(1)
              , ISNULL(@grpCivilist, '') -- Gruppo_Civilistico - nvarchar(1)
              , ISNULL(@grpAssicur, '') -- Gruppo_Assicurativo - nvarchar(1)
              , ISNULL(@SAE, '') -- SAE - nvarchar(6)
              , ISNULL(@RAE, '') -- RAE - nvarchar(6)
              , ISNULL(@ateco, '') -- ATECO - nvarchar(10)
              , ISNULL(@nazionalita, '') -- Nazionalita - nvarchar(1)
              , ISNULL(@gestorePart, '') -- Gestore_Partecipazione - nvarchar(100)
              , ISNULL(@quotata, '') -- Quotata - nvarchar(60)
              , ISNULL(@tipoQuot, '') -- Tipo_Quotazione - nvarchar(100)
              , ISNULL(@metodoConsBI, '') -- Metodo_ConsBI - nvarchar(100)
              , ISNULL(@metodoConsIAS, '') -- Metodo_ConsIAS - nvarchar(100)
              , ISNULL(@metodoConsFinrep, '') -- Metodo_ConsFinrep - nvarchar(100)
              , convert(NVARCHAR, @dataINS, 112) -- Data_Inserimento - nvarchar(8)
              , ISNULL(@classIASgruppo, '') -- Class_IAS_Gruppo - nvarchar(100)
              , ISNULL(@class2359gruppo, '') -- Class_Art2359_Gruppo - nvarchar(100)
              , '' -- Class_IAS_Individuale - nvarchar(100)
              , '' -- Class_Art2359_Individuale - nvarchar(100)
              , ISNULL(@classMonit, '') -- Class_Monitoraggio - nvarchar(100)
              , ISNULL(@classAntitrust, '') -- Class_Antitrust - nvarchar(100)
              , ISNULL(@tipologiaFAG, '') -- Tipologia_FAG - nvarchar(100)
              , ISNULL(@centroResp, '') -- Centro_Resp - nvarchar(100)
              , ISNULL(@CGU, '') -- CGU - nvarchar(100)
              , N'' -- SNDG_ControllataRif - nvarchar(16)
              , ISNULL(@orgInterposto, '') -- Flag_OrgInterposto - nvarchar(1)
              , ISNULL(@opQualificata, '') -- Flag_OpQualificata - nvarchar(1)
              , ISNULL(@tipoLookT, '') -- Tipo_LookThrough - nvarchar(100)
              , ISNULL(@classPNF, '') -- Class_PNF - nvarchar(100)
              , convert(NVARCHAR, @dataIniCS, 112) -- CS_Data - nvarchar(8)
              , ISNULL(@valutaCS, '') -- CS_Valuta - nvarchar(3)
              , replace(ISNULL(@CSsottoscrValuta, ''), '.', ',') -- CS_Sottoscritto_Valuta - nvarchar(28)
              , replace(ISNULL(@CSsottoscrEuro, ''), '.', ',') -- CS_Sottoscritto_Euro - nvarchar(28)
              , replace(ISNULL(@CSdelibValuta, ''), '.', ',') -- CS_Deliberato_Valuta - nvarchar(28)
              , replace(ISNULL(@CSsdelibEuro, ''), '.', ',') -- CS_Deliberato_Euro - nvarchar(28)
              , replace(ISNULL(@CSversatoValuta, ''), '.', ',') -- CS_Versato_Valuta - nvarchar(28)
              , replace(ISNULL(@CSversatoEuro, ''), '.', ',') -- CS_Versato_Euro - nvarchar(28)
              , replace(ISNULL(@CSvalNominUnit, ''), '.', ',') -- CS_ValNominale_Unitario - nvarchar(28)
              , replace(ISNULL(@totAzioniCS, ''), '.', ',') -- CS_Azioni - nvarchar(28)
              , replace(ISNULL(@totAzioniDVCS, ''), '.', ',') -- CS_AzioniDV - nvarchar(28)
              , replace(ISNULL(@totAzioniDVAOCS, ''), '.', ',') -- CS_AzioniDVAO - nvarchar(28)
              , replace(ISNULL(@PATRvalComplValuta, ''), '.', ',') -- PATR_ValoreCompl_Valuta - nvarchar(28)
              , replace(ISNULL(@PATRvalComplEuro, ''), '.', ',') -- PATR_ValoreCompl_Euro - nvarchar(28)
              , replace(ISNULL(@PATRtotQuote, ''), '.', ',') -- PATR_Quote - nvarchar(28)
              , ISNULL(@valutaBilancio, '') -- Valuta_Operazione - nvarchar(3)
              , '' -- Valore_Civilistico_Valuta - nvarchar(28)
              , '' -- Valore_Civilistico_Euro - nvarchar(28)
              , '' -- Valore_Prezzo_IAS - nvarchar(28)
              , '' -- Valore_NominaleCompl_Divisa - nvarchar(28)
              , '' -- Valore_NominaleCompl_Euro - nvarchar(28)
              , '' -- Valore_Civilistico_Gruppo - nvarchar(28)
              , '' -- Autonomia - nvarchar(100)
              , '' -- Azioni_Partecipante - nvarchar(28)
              , '' -- Perc_Diretta_Titolo - nvarchar(10)
              , '' -- Perc_Diretta_Totale - nvarchar(10)
              , '' -- AzioniDV_Partecipante - nvarchar(28)
              , '' -- PercDV_Diretta_Titolo - nvarchar(10)
              , '' -- PercDV_Diretta_Totale - nvarchar(10)
              , '' -- Azioni_Gruppo - nvarchar(28)
              , '' -- Perc_Gruppo_Titolo - nvarchar(10)
              , '' -- Perc_Gruppo_Totale - nvarchar(10)
              , '' -- AzioniDV_Gruppo - nvarchar(28)
              , '' -- PercDV_Gruppo_Titolo - nvarchar(10)
              , '' -- PercDV_Gruppo_Totale - nvarchar(10)
              , '' -- Livello_FairValue - nvarchar(3)
              , '' -- Perc_Equity_Ratio - nvarchar(10)
              , '' -- Valore_Package - nvarchar(28)
              , '' -- Riserva_AFS_Netta - nvarchar(28)
              , '' -- Impairment_Anno_Individuale - nvarchar(28)
              , '' -- Impairment_Anno_Consolidato - nvarchar(28)
              , '' -- Valore_Consolidato - nvarchar(28)
              , '' -- Valore_Consolidato_Gruppo - nvarchar(28)
              , '' -- Di_Cui_Avviamenti - nvarchar(28)
              , '' -- Riserva_AFS_Lorda - nvarchar(28)
              , '' -- Delta_Valore_Civilistico - nvarchar(28)
              , '' -- Data_Rif_BOFinance - nvarchar(8)
              , ISNULL(@superISIN, '') -- Super_ISIN - nvarchar(16)
              , '' -- SNDG_Partecipante - nvarchar(16)
              , '' -- Perc_SFP_Convertibile - nvarchar(10)
			  , ISNULL(@tipoPersona,'')
			  , @flagAppartieneGruppo   
              , @flagScarto  -- Flag_Scarto - bit
              , @motivoScarto -- Motivo_Scarto - nvarchar(2000)
            )
          END

        FETCH NEXT FROM Operazioni_CUR
        INTO @idOperazione, @tipoOperazione, @idPartecipata,
          @sndgPartecipata, @abiPrevPartecipata, @ndgPrevPartecipata,
          @ndgCGPartecipata, @tipoNDG, @SAE, @RAE, @codFiscale, @partitaIVA, @dataINS
      END
    CLOSE Operazioni_CUR
    DEALLOCATE Operazioni_CUR

    -- Set degli Scarti
    UPDATE SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
    SET Flag_Scarto = 1,
      Motivo_Scarto = 'SNDG non valorizzato.'
    WHERE Data_estrazione = @dataEstrazione
          AND (SNDG IS NULL OR ltrim(rtrim(SNDG)) = '')
          AND Flag_Scarto = 0

/*    Gestione delle destinazioni 
Destinazioni conosciute: BFD
						 LP
						 FITP (????)

*/


	IF  (@destinazione = 'BFD') 
		BEGIN
			SELECT *
			INTO #tempMappaGruppoBDF
			FROM (
				   SELECT
					 '00000' AS Azienda,
					 0       AS TipoRec,
					 '00' + -- fisso
					 'U5MANA01  ' + -- SSA + Periodicita + Tipo Info + Progressivo Flusso + 2 spazi
					 left((format(GETDATE(), 'yyyy-MM-dd-HH.mm.ss.fff')) + '000000000000000', 26) +
					 -- timestamp estrazione da
					 left((format(GETDATE(), 'yyyy-MM-dd-HH.mm.ss.fff')) + '000000000000000', 26) +
					 -- timestamp estrazione a
					 'M' + -- Periodicita flusso
					 left((format(GETDATE(), 'yyyy-MM-dd-HH.mm.00.000')) + '000000000000000', 26) +
					 -- timestamp schedulazione
					 format(GETDATE(), '0yyyyMMdd') + --  periodo rif
					 'MULTI' + -- fisso a multibanca
					 space(3395) -- filler
							 AS record,
					 space(928) -- filler
							 AS record_1
				   UNION ALL
				   SELECT
					 Codice_Partecipata               AS Azienda,
					 1                                AS TipoRec,
					 '010' + space(26) +
					 -- fisso 01 + 0 (0=recordo in vita; 1=record cancellato) + 26 spazi (in quanto recordo in vita)
					 convert(NVARCHAR, Data_estrazione, 112) +
					 left(Codice_Titolo + space(20), 20) + left(Descrizione_Titolo + space(30), 30) +
					 left(Codice_Partecipata + space(16), 16) + left(Denom_Partecipata + space(150), 150) +
					 left(Tipo_Operazione + space(5), 5) + left(Codice_Partecipante + space(16), 16) +
					 left(Denom_Partecipante + space(150), 150) +
					 left(Ind_Legale_Partecipata + space(100), 100) + left(Cap_Legale_Partecipata + space(10), 10) +
					 left(Citta_Legale_Partecipata + space(100), 100) +
					 left(Prov_Legale_Partecipata + space(2), 2) + left(Stato_Legale_Partecipata + space(40), 40) +
					 left(Ex_Art_3639RM + space(100), 100) +
					 left(Ind_Legale_Partecipante + space(100), 100) + left(Cap_Legale_Partecipante + space(10), 10) +
					 left(Citta_Legale_Partecipante + space(100), 100) +
					 left(Prov_Legale_Partecipante + space(2), 2) + left(Stato_Legale_Partecipante + space(40), 40) +
					 left(Valuta_CS_Partecipante + space(3), 3) + left(CR_Partecipata + space(13), 13) +
					 left(CF_Partecipata + space(16), 16) + left(Forma_Giuridica + space(40), 40) +
					 left(UIC_Partecipata + space(16), 16) + left(Valuta_Bilancio + space(3), 3) +
					 left(PIVA_Partecipata + space(11), 11) + left(Descrizione_ClassBI + space(100), 100) +
					 left(Descrizione_Attivita + space(150), 150) + left(SNDG + space(16), 16) +
					 left(ABI_Prevalente + space(5), 5) + left(NDG_Prevalente + space(16), 16) +
					 left(NDG_Capogruppo + space(16), 16) + left(Gruppo_Bancario + space(1), 1) +
					 left(Gruppo_Civilistico + space(1), 1) + left(Gruppo_Assicurativo + space(1), 1) +
					 left(SAE + space(60), 60) + left(RAE + space(100), 100) + left(ATECO + space(100), 100) +
					 left(Nazionalita + space(1), 1) + left(Gestore_Partecipazione + space(100), 100) +
					 left(Quotata + space(60), 60) + left(Tipo_Quotazione + space(100), 100) +
					 left(Metodo_ConsBI + space(100), 100) + left(Metodo_ConsIAS + space(100), 100) +
					 left(Metodo_ConsFinrep + space(100), 100) + left(Data_Inserimento + space(8), 8) +
					 left(Class_IAS_Gruppo + space(100), 100) + left(Class_Art2359_Gruppo + space(100), 100) +
					 left(Class_IAS_Individuale + space(100), 100) +
					 left(Class_Art2359_Individuale + space(100), 100) + left(Class_Monitoraggio + space(100), 100) +
					 left(Class_Antitrust + space(100), 100) +
					 left(Tipologia_FAG + space(100), 100) + left(Centro_Resp + space(100), 100) +
					 left(CGU + space(100), 100) + left(SNDG_ControllataRif + space(100), 100) +
					 left(Flag_OrgInterposto + space(1), 1) + left(Flag_OpQualificata + space(1), 1) +
					 left(Tipo_LookThrough + space(100), 100) + left(Class_PNF + space(100), 100)
													  AS record,
					 left(CS_Data + space(8), 8) + left(CS_Valuta + space(3), 3) +
					 CASE WHEN len(CS_Sottoscritto_Valuta) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(CS_Sottoscritto_Valuta, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_Sottoscritto_Euro) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(CS_Sottoscritto_Euro, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_Deliberato_Valuta) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(CS_Deliberato_Valuta, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_Deliberato_Euro) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(CS_Deliberato_Euro, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_Versato_Valuta) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(CS_Versato_Valuta, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_Versato_Euro) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(CS_Versato_Euro, ',', '.')), '0000000000000000.00'),
						   20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_ValNominale_Unitario) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(CS_ValNominale_Unitario, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_Azioni) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(CS_Azioni, ',', '.')), '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_AzioniDV) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(CS_AzioniDV, ',', '.')), '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(CS_AzioniDVAO) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(CS_AzioniDVAO, ',', '.')), '0000000000000000.00'),
						   20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(PATR_ValoreCompl_Valuta) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(PATR_ValoreCompl_Valuta, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(PATR_ValoreCompl_Euro) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(PATR_ValoreCompl_Euro, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(PATR_Quote) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(PATR_Quote, ',', '.')), '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 left(Valuta_Operazione + space(3), 3) +
					 CASE WHEN len(Valore_Civilistico_Valuta) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_Civilistico_Valuta, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Valore_Civilistico_Euro) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_Civilistico_Euro, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Valore_Prezzo_IAS) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_Prezzo_IAS, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Valore_NominaleCompl_Divisa) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_NominaleCompl_Divisa, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Valore_NominaleCompl_Euro) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_NominaleCompl_Euro, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Valore_Civilistico_Gruppo) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_Civilistico_Gruppo, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 left(Autonomia + space(100), 100) +
					 CASE WHEN len(Azioni_Partecipante) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Azioni_Partecipante, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Perc_Diretta_Titolo) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(Perc_Diretta_Titolo, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(Perc_Diretta_Totale) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(Perc_Diretta_Totale, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(AzioniDV_Partecipante) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(AzioniDV_Partecipante, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(PercDV_Diretta_Titolo) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(PercDV_Diretta_Titolo, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(PercDV_Diretta_Totale) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(PercDV_Diretta_Totale, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(Azioni_Gruppo) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(Azioni_Gruppo, ',', '.')), '0000000000000000.00'),
						   20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Perc_Gruppo_Titolo) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(Perc_Gruppo_Titolo, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(Perc_Gruppo_Totale) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(Perc_Gruppo_Totale, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(AzioniDV_Gruppo) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(AzioniDV_Gruppo, ',', '.')), '0000000000000000.00'),
						   20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(PercDV_Gruppo_Titolo) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(PercDV_Gruppo_Titolo, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(PercDV_Gruppo_Totale) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(PercDV_Gruppo_Totale, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 left(Livello_FairValue + space(3), 3) +
					 CASE WHEN len(Perc_Equity_Ratio) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(Perc_Equity_Ratio, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 CASE WHEN len(Valore_Package) > 0
					   THEN right(
						   '+' + format(convert(DECIMAL(28, 2), replace(Valore_Package, ',', '.')), '0000000000000000.00'),
						   20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Riserva_AFS_Netta) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Riserva_AFS_Netta, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Impairment_Anno_Individuale) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Impairment_Anno_Individuale, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Impairment_Anno_Consolidato) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Impairment_Anno_Consolidato, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Valore_Consolidato) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_Consolidato, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Valore_Consolidato_Gruppo) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Valore_Consolidato_Gruppo, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Di_Cui_Avviamenti) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Di_Cui_Avviamenti, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Riserva_AFS_Lorda) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Riserva_AFS_Lorda, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 CASE WHEN len(Delta_Valore_Civilistico) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 2), replace(Delta_Valore_Civilistico, ',', '.')),
											   '0000000000000000.00'), 20)
					 ELSE '+' + replicate('0', 16) + ',00' END +
					 left(Data_Rif_BOFinance + space(8), 8) +
					 left(Super_ISIN + space(16), 16) +
					 left(SNDG_Partecipante + space(16), 16) +
					 CASE WHEN len(Perc_SFP_Convertibile) > 0
					   THEN right('+' + format(convert(DECIMAL(28, 3), replace(Perc_SFP_Convertibile, ',', '.')),
											   '000000000000000.000'), 20)
					 ELSE '+' + replicate('0', 15) + ',000' END +
					 space(250) -- Filler
					 AS record_1
				   FROM SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
				   WHERE Data_estrazione = @dataEstrazione
						 AND Destinazione = @destinazione
						 AND Flag_Scarto = 0
				   UNION ALL
				   SELECT
					 '00000' AS Azienda,
					 2       AS TipoRec,
					 '99' + -- fisso
					 'U5MANA01  ' + -- SSA + Periodicita + Tipo Info + Progressivo Flusso + 2 spazi
					 left((format(GETDATE(), 'yyyy-MM-dd-HH.mm.ss.fff')) + '000000000000000', 26) +
					 -- timestamp estrazione da
					 left((format(GETDATE(), 'yyyy-MM-dd-HH.mm.ss.fff')) + '000000000000000', 26) +
					 -- timestamp estrazione a
					 'M' + -- Periodicita flusso
					 left((format(GETDATE(), 'yyyy-MM-dd-HH.mm.00.000')) + '000000000000000', 26) +
					 -- timestamp schedulazione
					 right('0000000000' + cast((SELECT count(*)
												FROM SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
												WHERE Data_estrazione = @dataEstrazione AND Destinazione = @destinazione AND
													  Flag_Scarto = 0) AS NVARCHAR), 9) +
					 --  numero record senza testa e coda
					 'MULTI' + -- fisso a multibanca
					 space(3395) -- filler
							 AS record,
					 space(928) -- filler
							 AS record_1
				 ) tab

			SELECT
			  record,
			  record_1
			FROM #tempMappaGruppoBDF
			ORDER BY TipoRec, Azienda
		END -- end destinazione BFS
	ELSE IF (@destinazione = 'FITP') -- Gestione del tracciato in caso di FITP
		BEGIN
			-- Aggiungere i campi in più al tracciato TipoPersona ed AppartenenteGruppo
			 SELECT *
				INTO #tempMappaGruppoFITP
						FROM (
							   SELECT
								 Codice_Partecipata                                                     AS Azienda,
								 1                                                                      AS TipoRec,
								 convert(NVARCHAR, Data_estrazione, 112) + ';' + Codice_Titolo + ';' + Descrizione_Titolo + ';' +
								 Codice_Partecipata + ';' + Denom_Partecipata + ';' +
								 Tipo_Operazione + ';' + Codice_Partecipante + ';' + Denom_Partecipante + ';' + Ind_Legale_Partecipata +
								 ';' +
								 Cap_Legale_Partecipata + ';' + Citta_Legale_Partecipata + ';' + Prov_Legale_Partecipata + ';' +
								 Stato_Legale_Partecipata + ';' + Ex_Art_3639RM + ';' + Ind_Legale_Partecipante + ';' +
								 Cap_Legale_Partecipante + ';' + Citta_Legale_Partecipante + ';' + Prov_Legale_Partecipante + ';' +
								 Stato_Legale_Partecipante + ';' + Valuta_CS_Partecipante + ';' + CR_Partecipata + ';' +
								 CF_Partecipata + ';' + Forma_Giuridica + ';' + UIC_Partecipata + ';' + Valuta_Bilancio + ';' +
								 PIVA_Partecipata + ';' + Descrizione_ClassBI + ';' + Descrizione_Attivita + ';' + SNDG + ';' +
								 ABI_Prevalente + ';' + NDG_Prevalente + ';' + NDG_Capogruppo + ';' + Gruppo_Bancario + ';' +
								 Gruppo_Civilistico + ';' + Gruppo_Assicurativo + ';' + SAE + ';' + RAE + ';' + ATECO + ';' +
								 Nazionalita + ';' + Gestore_Partecipazione + ';' + Quotata + ';' + Tipo_Quotazione + ';' +
								 Metodo_ConsBI + ';' + Metodo_ConsIAS + ';' + Metodo_ConsFinrep + ';' + Data_Inserimento + ';' +
								 Class_IAS_Gruppo + ';' + Class_Art2359_Gruppo + ';' + Class_IAS_Individuale + ';' +
								 Class_Art2359_Individuale + ';' + Class_Monitoraggio + ';' + Class_Antitrust + ';' +
								 Tipologia_FAG + ';' + Centro_Resp + ';' + CGU + ';' + SNDG_ControllataRif + ';' +
								 Flag_OrgInterposto + ';' + Flag_OpQualificata + ';' + Tipo_LookThrough + ';' + Class_PNF + ';' +
								 CS_Data + ';' + CS_Valuta + ';' + CS_Sottoscritto_Valuta + ';' + CS_Sottoscritto_Euro + ';' +
								 CS_Deliberato_Valuta + ';' + CS_Deliberato_Euro + ';' + CS_Versato_Valuta + ';' + CS_Versato_Euro + ';'
								 +
								 CS_ValNominale_Unitario + ';' + CS_Azioni + ';' + CS_AzioniDV + ';' + CS_AzioniDVAO + ';' +
								 PATR_ValoreCompl_Valuta + ';' + PATR_ValoreCompl_Euro + ';' + PATR_Quote + ';' + Valuta_Operazione +
								 ';' +
								 Valore_Civilistico_Valuta + ';' + Valore_Civilistico_Euro + ';' + Valore_Prezzo_IAS + ';' +
								 Valore_NominaleCompl_Divisa + ';' + Valore_NominaleCompl_Euro + ';' + Valore_Civilistico_Gruppo + ';' +
								 Autonomia + ';' + Azioni_Partecipante + ';' + Perc_Diretta_Titolo + ';' + Perc_Diretta_Totale + ';' +
								 AzioniDV_Partecipante + ';' + PercDV_Diretta_Titolo + ';' + PercDV_Diretta_Totale + ';' +
								 Azioni_Gruppo + ';' + Perc_Gruppo_Titolo + ';' + Perc_Gruppo_Totale + ';' + AzioniDV_Gruppo + ';' +
								 PercDV_Gruppo_Titolo + ';' + PercDV_Gruppo_Totale + ';' + Livello_FairValue + ';' +
								 Perc_Equity_Ratio + ';' + Valore_Package + ';' + Riserva_AFS_Netta + ';' +
								 Impairment_Anno_Individuale + ';' + Impairment_Anno_Consolidato + ';' + Valore_Consolidato + ';' +
								 Valore_Consolidato_Gruppo + ';' + Di_Cui_Avviamenti + ';' + Riserva_AFS_Lorda + ';' +
								 Delta_Valore_Civilistico + ';' + Data_Rif_BOFinance + ';' + Super_ISIN + ';' + 
								 SNDG_Partecipante + ';' + Perc_SFP_Convertibile + ';' 
								 + ISNULL(tipo_persona,'') + ';'
								 + ISNULL(CONVERT(CHAR,flagGruppo),'') +';'
								 + space(250) AS record
							   FROM SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
							   WHERE Data_estrazione = @dataEstrazione
									 AND Destinazione = @destinazione
									 AND Flag_Scarto = 0
							 ) t2

							 SELECT record
							 FROM #tempMappaGruppoFITP
							 ORDER BY TipoRec, Azienda
		END -- caso FITP
	ELSE    -- tutti gli altri casi non trattati
		BEGIN
			IF @destinazione <> 'LP'
        -- se la destinazione NON è Legami Partecipativi e Finanziari ci deve essere il primo record di intestazione, altrimenti no
          BEGIN
            SELECT *
            INTO #tempMappaGruppoInt
            FROM (
                   SELECT
                     '00000'                                                                                     AS Azienda,
                     0                                                                                           AS TipoRec,
                     'Data Riferimento;Codice Titolo;Descrizione Titolo;Codice Partecipata;Azienda Partecipata;' +
                     'Tipo Operazione;Codice Partecipante;Azienda Partecipante;Sede Legale Partecipata;' +
                     'Cap Legale Partecipata;Città Legale Partecipata;Provincia Legale Partecipata;Nazione Legale Partecipata;'
                     +
                     'Articolo 36-39 RM;Sede Legale Partecipante;Cap Legale Partecipante;Città Legale Partecipante;' +
                     'Provincia Legale Partecipante;Nazione Legale Partecipante;Valuta Cap. Soc. Pante;' +
                     'Codice Centrale Rischi Partecipata;Codice Fiscale Partecipata;FormaGiuridica;Codice UIC;' +
                     'Valuta di Bilancio;Partita IVA Partecipata;Descrizione Bankit;Descrizione Attività;' +
                     'Codice NDG Di Gruppo;ABI Prevalente;NDG Prevalente;NDG Capogruppo;' +
                     'Gruppo Bancario;Gruppo Civilistico;Gruppo Assicurativo;Settore di Attività Economica;Ramo Attività;'
                     +
                     'ATECO;Nazionalità;Gestore della Partecipazione;Quotata;Tipo Quotazione;' +
                     'Metodo Consolidamento Bankit;Metodo Consolidamento Ias;Metodo Consolidamento Finrep;' +
                     'Data Inserimento;Classificazione IAS Gruppo;Classificazione Ex Art 2359 Gruppo;' +
                     'Classificazione IAS Individuale;Classificazione Ex Art 2359 Individuale;' +
                     'Classificazione per Monitoraggio;Classificazione Antitrust;Tipologia FAG;' +
                     'Centro di Responsabilità;CGU;Controllata di Riferimento;Flag Organismo Interposto;' +
                     'Partecipazione Qualificata;Tipologia Look Through;Classificazione PNF;' +
                     'Data Capitale Sociale;Divisa Capitale Sociale;Capitale Sociale Sottoscritto Valuta;' +
                     'Capitale Sociale Sottoscritto Euro;Capitale Sociale Deliberato Valuta;Capitale Sociale Deliberato Euro;'
                     +
                     'Capitale Sociale Versato Valuta;Capitale Sociale Versato Euro;Nominale Unitario Capitale Sociale;'
                     +
                     'Azioni Capitale Sociale;Azioni DV Capitale Sociale;Azioni DVAO Capitale Sociale;' +
                     'Valore Complessivo Valuta Patrimonio;Valore Complessivo Euro Patrimonio;Totale Quote Patrimonio;'
                     +
                     'Divisa Partecipazione;Valore Civilistico Valuta;Valore Civilistico Euro;Valore Prezzo IAS Euro;' +
                     'Valore Nominale Comp. Divisa;Valore Nominale Comp. Euro;Valore Civilistico Gruppo/Controllate;' +
                     'Autonomia;Numero Azioni Partecipante;% Diretta Titolo;% Diretta Totale;Numero DV;' +
                     '% DV Diretta Titolo;% DV Diretta Totale;Numero Azioni Gruppo;% Gruppo/Controllate Titolo;' +
                     '% Gruppo/Controllate Totale;Numero DV Gruppo;% DV Gruppo/Controllate Titolo;% DV Gruppo/Controllate Totale;'
                     +
                     'LivelliFairValue;% Equity Ratio;Valore Package eur;Riserva AFS Netta;Impairment Individuale Anno;'
                     +
                     'Impairment Consolidato Anno;Valore Consolidato;Valore Consolidato Somma Gruppo;Di cui Avviamenti;'
                     +
                     'Riserva AFS Lorda;Delta Differenza Valore Civilistico;Data Rif Dati BO Finance;Super ISIN;' 
                     +
                     'SNDG Partecipante;% SFP Convertibile;Filler' AS record
                 ) t1
          END

        -- per tutte le destinazioni
        SELECT *
        INTO #tempMappaGruppo
        FROM (
               SELECT
                 Codice_Partecipata                                                     AS Azienda,
                 1                                                                      AS TipoRec,
                 convert(NVARCHAR, Data_estrazione, 112) + ';' + Codice_Titolo + ';' + Descrizione_Titolo + ';' +
                 Codice_Partecipata + ';' + Denom_Partecipata + ';' +
                 Tipo_Operazione + ';' + Codice_Partecipante + ';' + Denom_Partecipante + ';' + Ind_Legale_Partecipata +
                 ';' +
                 Cap_Legale_Partecipata + ';' + Citta_Legale_Partecipata + ';' + Prov_Legale_Partecipata + ';' +
                 Stato_Legale_Partecipata + ';' + Ex_Art_3639RM + ';' + Ind_Legale_Partecipante + ';' +
                 Cap_Legale_Partecipante + ';' + Citta_Legale_Partecipante + ';' + Prov_Legale_Partecipante + ';' +
                 Stato_Legale_Partecipante + ';' + Valuta_CS_Partecipante + ';' + CR_Partecipata + ';' +
                 CF_Partecipata + ';' + Forma_Giuridica + ';' + UIC_Partecipata + ';' + Valuta_Bilancio + ';' +
                 PIVA_Partecipata + ';' + Descrizione_ClassBI + ';' + Descrizione_Attivita + ';' + SNDG + ';' +
                 ABI_Prevalente + ';' + NDG_Prevalente + ';' + NDG_Capogruppo + ';' + Gruppo_Bancario + ';' +
                 Gruppo_Civilistico + ';' + Gruppo_Assicurativo + ';' + SAE + ';' + RAE + ';' + ATECO + ';' +
                 Nazionalita + ';' + Gestore_Partecipazione + ';' + Quotata + ';' + Tipo_Quotazione + ';' +
                 Metodo_ConsBI + ';' + Metodo_ConsIAS + ';' + Metodo_ConsFinrep + ';' + Data_Inserimento + ';' +
                 Class_IAS_Gruppo + ';' + Class_Art2359_Gruppo + ';' + Class_IAS_Individuale + ';' +
                 Class_Art2359_Individuale + ';' + Class_Monitoraggio + ';' + Class_Antitrust + ';' +
                 Tipologia_FAG + ';' + Centro_Resp + ';' + CGU + ';' + SNDG_ControllataRif + ';' +
                 Flag_OrgInterposto + ';' + Flag_OpQualificata + ';' + Tipo_LookThrough + ';' + Class_PNF + ';' +
                 CS_Data + ';' + CS_Valuta + ';' + CS_Sottoscritto_Valuta + ';' + CS_Sottoscritto_Euro + ';' +
                 CS_Deliberato_Valuta + ';' + CS_Deliberato_Euro + ';' + CS_Versato_Valuta + ';' + CS_Versato_Euro + ';'
                 +
                 CS_ValNominale_Unitario + ';' + CS_Azioni + ';' + CS_AzioniDV + ';' + CS_AzioniDVAO + ';' +
                 PATR_ValoreCompl_Valuta + ';' + PATR_ValoreCompl_Euro + ';' + PATR_Quote + ';' + Valuta_Operazione +
                 ';' +
                 Valore_Civilistico_Valuta + ';' + Valore_Civilistico_Euro + ';' + Valore_Prezzo_IAS + ';' +
                 Valore_NominaleCompl_Divisa + ';' + Valore_NominaleCompl_Euro + ';' + Valore_Civilistico_Gruppo + ';' +
                 Autonomia + ';' + Azioni_Partecipante + ';' + Perc_Diretta_Titolo + ';' + Perc_Diretta_Totale + ';' +
                 AzioniDV_Partecipante + ';' + PercDV_Diretta_Titolo + ';' + PercDV_Diretta_Totale + ';' +
                 Azioni_Gruppo + ';' + Perc_Gruppo_Titolo + ';' + Perc_Gruppo_Totale + ';' + AzioniDV_Gruppo + ';' +
                 PercDV_Gruppo_Titolo + ';' + PercDV_Gruppo_Totale + ';' + Livello_FairValue + ';' +
                 Perc_Equity_Ratio + ';' + Valore_Package + ';' + Riserva_AFS_Netta + ';' +
                 Impairment_Anno_Individuale + ';' + Impairment_Anno_Consolidato + ';' + Valore_Consolidato + ';' +
                 Valore_Consolidato_Gruppo + ';' + Di_Cui_Avviamenti + ';' + Riserva_AFS_Lorda + ';' +
                 Delta_Valore_Civilistico + ';' + Data_Rif_BOFinance + ';' + Super_ISIN + ';' + 
                 SNDG_Partecipante + ';' + Perc_SFP_Convertibile + ';' + space(250) AS record
               FROM SK_F2_FLUSSI.F2_T_EXP_MappaGruppo_Estesa
               WHERE Data_estrazione = @dataEstrazione
                     AND Destinazione = @destinazione
                     AND Flag_Scarto = 0
             ) t2

        IF @destinazione <> 'LP'
          BEGIN
            SELECT record
            FROM (
                   SELECT
                     azienda,
                     tiporec,
                     record
                   FROM #tempMappaGruppoInt
                   UNION ALL
                   SELECT
                     azienda,
                     tiporec,
                     record
                   FROM #tempMappaGruppo
                 ) t2
            ORDER BY t2.TipoRec, t2.Azienda
          END
        ELSE SELECT record
             FROM #tempMappaGruppo
             ORDER BY TipoRec, Azienda
		END  -- gestione di tutte le altre casistiche





    END TRY
    BEGIN CATCH
    SET @outputNum = -1
    SELECT @outputMsg = ERROR_MESSAGE()

    IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;
    END CATCH;

    IF @@TRANCOUNT > 0
      COMMIT TRANSACTION;

  END
  GO