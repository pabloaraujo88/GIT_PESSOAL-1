#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FFATR001³ Autor ³Pablo Leite            ³ Data ³ 30/11/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³  GTI FIEB        ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatório de Retorno de transmissão API Focus              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Filial De/Ate Serie De/Ate Data de Emissão De/Ate          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Planilha em Excel                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³  Faturamento                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Pablo Leite Data 30/11/2023                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Versão 1.0    ³ 30/11/2023³                                            ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER FUNCTION FFATR001()

	Local o_Tela	:= clsTelasGen():New()
	Local c_Janela	:= "Notas Transmitidas"
	Local c_Tit1	:= "Relatorio de Notas transmitidas em formato Excel"
	Local c_Tit2	:= ""
	Local c_Tit3	:= ""
	Local c_Perg	:= "FFATR001" 
    Local l_Continua:= .F.
	Private n_TotReg	:= 0
	Private o_Excel		:= FWMsExcelEx():New()
    Private c_Cab       := ""
    Private a_Titulos   := {}

    f_ValidPerg( c_Perg ) 
	If !Pergunte( c_Perg, .T. )
		Return()
	EndIf
    c_Cab:= "Relatório Notas API FOCUS"
	If( o_Tela:mtdParOkCan( c_Janela, c_Tit1, c_Tit2, c_Tit3, c_Perg ) )
        If( FWAlertYesNo( "Confirma a geracao do relatorio?", "" ) )
            FWMsgRun( Nil, {|| f_MontaPlanilha() },Nil, "Relatorio de Notas Transmitidas... Criando objeto Excel..." )
            FWMsgRun( Nil, {|| f_GeraDados( @l_Continua ) },Nil, "Relatorio de Notas Transmitidas... Montando Consulta no banco..." )
            If( l_Continua )
                Processa({|| f_ImprimeRelatorio() },"Relatorio de Notas Transmitidas","Aguarde enquanto o relatorio e gerado...", .F.)
            EndIf
        EndIf
	EndIf
Return()

/*/{Protheus.doc} User Function f_MontaPlanilha
    (long_description)
    @type  Function
    @author user
    @since 20/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function f_MontaPlanilha()
    o_Excel:AddworkSheet("Notas Focus")
    o_Excel:AddTable("Notas Focus",c_Cab)
    o_Excel:AddColumn("Notas Focus",c_Cab,"EMPRESA"  ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"FILIAL"  ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"FILIAL DESC"  ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"DOCUMENTO",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"SERIE",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"NFELETR",1)   
    o_Excel:AddColumn("Notas Focus",c_Cab,"EMISSAO"    ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"CLIENTE"  ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"LOJA" ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"DT_ENVIONFSE"  ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"HORA_ENVIO" ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"STATUS"    ,1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"MSG_ERRO",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"COD_ERRO",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"INSCRICAO",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"TELEFONE",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"EMAIL",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"TES",1)
    o_Excel:AddColumn("Notas Focus",c_Cab,"PRODUTO",1)
Return()

/*/{Protheus.doc} User Function f_ImprimeRelatorios
    (long_description)
    @type  Function
    @author user
    @since 20/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function f_ImprimeRelatorio()

    Local n_Contador	:= 1
    Local c_Caminho		:= "c:\temp\" 
    Local c_Arquivo     := "FFATR001.xml" 
    Local o_Explorer	:= clsExplorer():New()
    Local l_AbreExcel	:= .F.

    If !o_Explorer:mtdExistePasta( c_Caminho )
        if !o_Explorer:mtdCriaPasta( c_Caminho )
            Alert("Falha ao tentar a criar pasta " +  c_Caminho + ". Procure o setor de TI!")
            Return()
        EndIf
    EndIf

    ProcRegua( n_TotReg )
    dbSelectArea( "QRYREG" )
    QRYREG->( dbGoTop() )

    o_Excel:SetCelBold(.T.)
    o_Excel:SetCelFont('Courier New')
    o_Excel:SetCelItalic(.F.)
    o_Excel:SetCelUnderLine(.T.)
    o_Excel:SetCelSizeFont(10)
    o_Excel:SetCelFrColor("#FFFFFF")
    o_Excel:SetCelBgColor("#000333")

    While( QRYREG->( !Eof() ) )
        IncProc("Montando Planilha Excel... Registros " + Alltrim( Str( n_Contador ) )  + " de " + Alltrim( Str( n_TotReg ) ) )
        n_Contador++
        l_AbreExcel := .T.
        o_Excel:AddRow("Notas Focus",c_Cab,{ QRYREG->ENTIDADE,;
                                                    QRYREG->FILIAL,;
                                                    QRYREG->M0_FILIAL,;
                                                    QRYREG->NUM_DOC,;
                                                    QRYREG->SERIE,;
                                                    QRYREG->AUTORIZADA,;
                                                    QRYREG->EMISSAO,;
                                                    QRYREG->CLIENTE,;
                                                    QRYREG->LOJA,;
                                                    QRYREG->DT_ENVIONFSE,;
                                                    QRYREG->HORA_ENVIO,;
                                                    QRYREG->Z36_STATUS,;
                                                    QRYREG->Z36_ERRMSG,;
                                                    QRYREG->Z36_ERRCOD,;
                                                    QRYREG->A1_INSCRM,;
                                                    QRYREG->TEL,;
                                                    QRYREG->A1_EMAIL,;
                                                    QRYREG->D2_TES,;
                                                    QRYREG->D2_COD}) 
        QRYREG->( dbSkip() )
    EndDo
    QRYREG->( dbCloseArea() )
    If l_AbreExcel
        o_Excel:Activate()
        o_Excel:GetXMLFile( c_Caminho + c_Arquivo )
        o_Excel := MsExcel():New()           //Abre uma nova conexão com Excel
        o_Excel:WorkBooks:Open( c_Caminho + c_Arquivo )     //Abre uma planilha
        o_Excel:SetVisible(.T.)              //Visualiza a planilha
        o_Excel:Destroy()                    //Encerra o processo do gerenciador de tarefas
    EndIf
Return()

/*/{Protheus.doc} User Function f_GeraDados
    (long_description)
    @type  Function
    @author user
    @since 20/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function f_GeraDados( l_Continua )
    Local c_Query	:= ""
c_Query += "SELECT SUBSTRING(F2_FILIAL,1,4) AS ENTIDADE,F2_FILIAL AS FILIAL,M0_FILIAL,F2_DOC AS NUM_DOC,F2_SERIE AS SERIE,F2_NFELETR AS AUTORIZADA,F2_FIMP,			"
c_Query += "D2_COD,D2_TES,A1_EMAIL, A1_TEL AS TEL,                                                                                    "
c_Query += "SUBSTRING(F2_EMINFE,7,2)+ '/'+SUBSTRING(F2_EMINFE,5,2)+'/'+SUBSTRING(F2_EMINFE,0,5) AS  DT_ENVIONFSE,                              "
c_Query += "F2_HORA AS HORA_ENVIO,F2_CLIENTE AS CLIENTE,F2_LOJA AS LOJA,                                                                       "
c_Query += "SUBSTRING(F2_EMISSAO,7,2)+ '/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,0,5) AS  EMISSAO,                                "
c_Query += "F2_MENNOTA AS MENNOTA,A1_INSCRM,                                                                                   "
c_Query += "Z36_STATUS,Z36_ERRCOD,Z36_ERRMSG,Z36_DATA                                                                                          "
c_Query += "FROM " + RetSQLName("SF2") + " SF2 WITH(NOLOCK)                                                                                                       "
c_Query += "		LEFT JOIN " + RetSQLName("SA1") + " SA1 WITH(NOLOCK)  ON	SF2.F2_CLIENT   = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '' "
c_Query += "		INNER JOIN SYS_COMPANY  EMP 	   ON   SF2.F2_FILIAL   = M0_CODFIL                                                        "
c_Query += "		INNER JOIN " + RetSQLName("Z36") + " Z36 WITH(NOLOCK) ON   SF2.F2_FILIAL   = Z36.Z36_FILIAL   AND                                             "
c_Query += "												SF2.F2_DOC	   = Z36.Z36_DOC       AND                                             "
c_Query += "												SF2.F2_CLIENT  = Z36.Z36_CLIENT    AND                                             "
c_Query += "												SF2.F2_LOJA = Z36.Z36_LOJA		   AND                                             "
c_Query += "												SF2.F2_SERIE   = Z36.Z36_SERIE     AND                                             "
c_Query += "		 										Z36.D_E_L_E_T_='' 	                                                               "
c_Query += "        INNER JOIN " + RetSQLName("SD2") + " SD2 WITH(NOLOCK) ON	SF2.F2_FILIAL  = SD2.D2_FILIAL   AND                                               "
c_Query += "												SF2.F2_DOC	   = SD2.D2_DOC      AND                                               "
c_Query += "												SF2.F2_CLIENT  = SD2.D2_CLIENTE  AND                                               "
c_Query += "												SF2.F2_LOJA	   = SD2.D2_LOJA     AND                                               "
c_Query += "												SF2.F2_SERIE   = SD2.D2_SERIE    AND                                               "
c_Query += "		 										SD2.D_E_L_E_T_='' 	                                                               "
c_Query += "                                                                                                                                   "
c_Query += "		WHERE SF2.D_E_L_E_T_ = ''  and EMP.D_E_L_E_T_=''                                                                           "
c_Query += "		AND F2_EMISSAO BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "'                                                                        "
//c_Query += "		--AND F2_EMINFE =''                                                                                                        "
c_Query += "		AND F2_FILIAL between '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "                                                                                         "
//c_Query += "		AND LEN (F2_LOJA)=2                                                                                                        "
//c_Query += "		AND LEN (F2_DOC)=9                                                                                                         "

IF MV_PAR05 == 2
    c_Query += "		AND Z36_STATUS = 'autorizado'   "
ELSEIF MV_PAR05  == 3
    c_Query += "		AND Z36_STATUS = 'processando_autorizacao'   "    
ELSEIF  MV_PAR05 == 4
    c_Query += "		AND Z36_STATUS = 'erro_autorizacao'   " 
ELSEIF MV_PAR05  == 5
    c_Query += "		AND Z36_STATUS = 'cancelado'   "   
ENDIF                                  
                     

//c_Query += "		AND Z36_STATUS <> 'autorizado'                                                                                             "
//c_Query += "	   	AND F2_SERIE IN ('A','D','1')                                                                                              "
//c_Query += "        AND ( F2_FIMP = ' ' OR F2_FIMP = 'N' )                                                                                     "
	If( Select("QRYREG") <> 0 )
		QRYREG->( dbCloseArea() )
	EndIf
	memowrit("C:\TEMP\ffatr001.sql",c_Query)
	TcQuery c_Query New Alias QRYREG
	If( QRYREG->( Eof() ) )
		MsgAlert("Nao foram encontradas dados para os parametros informados.","Aviso")
		QRYREG->( dbCloseArea() )
		l_Continua:= .F.
	Else
		n_TotReg := Contar( "QRYREG","!Eof()" )
		QRYREG->( DbGoTop() )
		l_Continua:= .T.
	EndIf
Return()

Static Function f_ValidPerg( c_Perg )
	Local o_Perguntas	:= clsComponentes():New()
	//                        1        2           3           4        5           6         7         8           9           10       11        12         13        14         15          16        17         18       19        20           21           22       23         24       25          26         26         28        28       30           31           32        33       34         35          36          37      38      39       40         41       42          43
	//o_Perguntas:mtdPutSX1( X1_GRUPO, X1_ORDEM, X1_PERGUNT, X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_VAR01, X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_VAR02, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_CNT02, X1_VAR03, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_CNT03, X1_VAR04, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_CNT04, X1_VAR05, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, X1_CNT05, X1_F3, X1_PYME, X1_GRPSXG, X1_HELP, X1_PICTURE, X1_IDFIL )
	o_Perguntas:mtdPutSX1( c_Perg, "01", "Da Filial?            ", "", "", "mv_ch1", "C", 08, 0, 0, "G", "" , "MV_PAR01", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0"   , "", "","", "", "" )
	o_Perguntas:mtdPutSX1( c_Perg, "02", "Ate Filial?           ", "", "", "mv_ch2", "C", 08, 0, 0, "G", "" , "MV_PAR02", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0"   , "", "", "", "", "" )
	o_Perguntas:mtdPutSX1( c_Perg, "03", "Da Emissao?           ", "", "", "mv_ch3", "D", 08, 0, 0, "G", "" , "MV_PAR03", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" )
	o_Perguntas:mtdPutSX1( c_Perg, "04", "Ate Emissao?          ", "", "", "mv_ch4", "D", 08, 0, 0, "G", "" , "MV_PAR04", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" )
    o_Perguntas:mtdPutSX1( c_Perg, "05", "Status?		        ", "", "", "mv_ch5", "C", 01, 0, 0, "C", "" , "MV_PAR05", "Todos", "", "", "", "", "Autorizadas", "", "", "", "", "Pendentes", "", "", "", "", "Erro", "", "", "", "", "Canceladas", "", "", "", "", "", "", "", "", "" )
Return()    
