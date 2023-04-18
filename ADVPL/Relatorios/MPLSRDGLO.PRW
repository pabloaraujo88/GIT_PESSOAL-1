#INCLUDE 'protheus.ch'
#INCLUDE 'topconn.ch'
#INCLUDE "REPORT.CH"

User Function MPLSRDGLO()
	Private oReport := Nil
	Private oSecCab := Nil
	Private cPerg   := PadR("MPLSRDGLO", Len(SX1->X1_GRUPO))
	/*
	PutSx1(cPerg,"01","Código de?"  ,'','',"mv_ch1","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Código ate?" ,'','',"mv_ch2","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
	*/
	ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	oReport := TReport():New("MPLSRDGLO","Demonstrativo de glosas",cPerg ,{|oReport| PrintReport(oReport)},"Impressão de cadastro relatório Demonstrativo de glosas.")
	oReport:SetLandscape(.T.)
	
	oSecCab := TRSection():New( oReport , "Demonstrativo de Glosas", {"QRY"} )

	TRCell():New( oSecCab, "BENEF"     , "QRY", "Beneficiario",, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New( oSecCab, "PEG"    , "QRY","Protocolo", ,10, ,,,,,,,,,,)
	TRCell():New( oSecCab, "NUMGUIA"    , "QRY","Guia",, 10, ,,,,,,,,,,)
	TRCell():New( oSecCab, "BD6_CODPRO"      , "QRY","Procedimento",, 10, ,,,,,,,,,,)
	TRCell():New( oSecCab, "QTDAPR"      , "QRY","Qtd Apresentada",, 8, ,,,,,,,,,,)
	TRCell():New( oSecCab, "QTDGLO"      , "QRY","Qtd Glosada",, 8, ,,,,,,,,,,)
	TRCell():New( oSecCab, "VLRAPR"      , "QRY","Vlr Apresentado",, 8, ,,,,,,,,,,)
	TRCell():New( oSecCab, "VLRGLO"      , "QRY","Vlr Glosado",, 8, ,,,,,,,,,,)
	TRCell():New( oSecCab, "VLRPAG"      , "QRY","Vlr Pago",, 8, ,,,,,,,,,,)
	TRCell():New( oSecCab, "OBS"      , "QRY","Observações",, 100, ,,,,,,,,,,)

	TRFunction():New(oSecCab:Cell("VLRGLO"),/*cId*/,"COUNT"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)
Return

Static Function PrintReport(oReport)
	Local cQuery := Nil

	cQuery := "SELECT BD6_NOMUSR AS BENEF, BD6_CODPEG AS PEG,BD6_NUMERO AS NUMGUIA, BD6_CODPRO, "
	cQuery += "BD6_QTDAPR AS QTDAPR, BDX_QTDGLO AS QTDGLO, BD6_VLRAPR AS VLRAPR, BDX_VLRGLO AS VLRGLO , BD6_VLRPAG AS  VLRPAG "
	cQuery += ",ISNULL(CAST(CAST(BDX_OBS AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS "
	cQuery += " FROM " + RetSqlName("BDX") + " BDX INNER JOIN " + RetSqlName("BD6") + " BD6 ON (BDX_CODOPE = BD6_CODOPE "
	cQuery += " AND BDX_CODLDP = BD6_CODLDP AND BDX_CODPEG = BD6_CODPEG AND BDX_NUMERO = BD6_NUMERO AND BDX_CODPAD = BD6_CODPAD "
	cQuery += " AND BDX_CODPRO = BD6_CODPRO) "
	cQuery += "WHERE BDX.D_E_L_E_T_ = ''"
	cQuery += "AND BD6.D_E_L_E_T_ = ''"
	cQuery += "AND BDX_CODOPE = '" + mv_par01 + "' "
	cQuery += "AND BD6_CODRDA between '" + mv_par04 + "' AND '" + mv_par05 + "' "
	cQuery += "AND BDX_CODLDP = '0002'"
	cQuery += "AND BDX_CODPEG BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "' "
	cQuery += "AND BD6_DTANAL  BETWEEN '" + Dtos(mv_par06) + "' AND '" + Dtos(mv_par07) + "' "
	cQuery += "ORDER BY BD6_CODPEG, BD6_NUMERO"

	cQuery := ChangeQuery(cQuery)

		If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbCloseArea())
	EndIF
	
	TcQuery cQuery New Alias "QRY"
	
	//oSecCab:BeginQuery()
	//oSecCab:EndQuery({{"QRY"},cQuery})
	oSecCab:setQuery("QRY",cQuery)
	oSecCab:Print()
Return

