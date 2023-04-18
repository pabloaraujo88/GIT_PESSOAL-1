#INCLUDE 'protheus.ch'
#INCLUDE 'topconn.ch'
#INCLUDE "REPORT.CH"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

/*/{Protheus.doc} FFINR003
Programa relatório Vidas por Faixa UNIX
@author Pablo Leite
@since 16/06/2022
@version 12.1.27


*/

User Function RELVIFX()
	Private oReport := Nil
	Private oSecCab := Nil
	Private cPerg   := PadR("RELVIFX", Len(SX1->X1_GRUPO))
	/*
	PutSx1(cPerg,"01","Código de?"  ,'','',"mv_ch1","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Código ate?" ,'','',"mv_ch2","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
	*/
	ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	oReport := TReport():New("RELVIFX","VIDAS POR FAIXA ETARIA",cPerg ,{|oReport| PrintReport(oReport)},"Impressão de VIDAS POR FAIXA ETARIA.")
	oReport:SetLandscape(.T.)
	oreport:nfontbody:=10
    //oreport:cfontbody:="Arial"

	oSecCab := TRSection():New( oReport , "VIDAS POR FAIXA ETARIA", {"QRY"} )
	
    TRCell():New( oSecCab, "FAIXA"     , "QRY", "Faixa Etária",, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New( oSecCab, "VIDAS"    , "QRY","Qtd Vidas", ,10, ,,,,,,,,,,)
	
    TRFunction():New(oSecCab:Cell("VIDAS"),/*cId*/,"SUM"     ,/*oBreak*/,,/*cPicture*/,/*uFormula*/,.F.           ,.F.           ,.F.        ,oSecCab)
Return


Static Function PrintReport(oReport)

Local cQuery := Nil


cQuery := "SELECT "
cQuery += "		CASE "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 0 AND 18 THEn '0 a 18 anos'		  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 19 AND 23 THEn '19 a 23 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 24 AND 28 THEn '24 a 28 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 29 AND 33 THEn '29 a 33 anos'	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 34 AND 38 THEn '34 a 38 anos'	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 39 AND 43 THEn '39 a 43 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 44 AND 48 THEn '44 a 48 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 49 AND 53 THEn '49 a 53 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 54 AND 58 THEn '54 a 58 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) >= 59 THEN'59 anos ou mais'				  "
cQuery += "																										  "
cQuery += "		end as FAIXA,																					  "
cQuery += "COUNT(*) VIDAS     "
cQuery += "FROM  " + RetSqlName("BA1") + " BA1 (NOLOCK)  inner join " + RetSqlName("BI3") + " BI3 ON (BA1_CODPLA = BI3_CODIGO AND BA1_VERSAO = BI3_VERSAO)  "
IF mv_par04 == 1	
    cQuery += "WHERE BA1_CODEMP = '0001'" 	
ELSEIF mv_par04 == 2
    cQuery += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    cQuery += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    cQuery += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '3' "
ELSEIF mv_par04 == 3
    cQuery += "INNER JOIN " + RetSqlName("BT5") + " BT5 ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    cQuery += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    cQuery += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '2' "
ELSE
    cQuery += "WHERE BA1_CODEMP BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "'
ENDIF
	cQuery += "AND BA1.D_E_L_E_T_ = ''
IF MV_PAR05 == 1 //homem
	cQuery += "AND BA1_SEXO = '1'
ELSEIF MV_PAR05 == 2 //FEMININO
	cQuery += "AND BA1_SEXO = '2'
ELSE
	cQuery += "				"
ENDIF																						  "
cQuery += "AND BA1_DATINC <= '" + Dtos(mv_par03) + "'																			  "
cQuery += "AND (BA1_DATBLO = '   ' OR BA1_DATBLO >'"+DTOS(mv_par03)+"') " 											  "
cQuery += "AND BI3.D_E_L_E_T_ = '' AND 	BI3_SUSEP BETWEEN  '" + mv_par06 + "' AND '" + mv_par07 +"'		"
cQuery += "GROUP BY CASE 																						  "
cQuery += "		WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 0 AND 18 THEn '0 a 18 anos' "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 19 AND 23 THEn '19 a 23 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 24 AND 28 THEn '24 a 28 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 29 AND 33 THEn '29 a 33 anos'	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 34 AND 38 THEn '34 a 38 anos'	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 39 AND 43 THEn '39 a 43 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 44 AND 48 THEn '44 a 48 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 49 AND 53 THEn '49 a 53 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 54 AND 58 THEn '54 a 58 anos' 	  "
cQuery += "WHEN Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) >= 59 THEN'59 anos ou mais'				  "
cQuery += "	END		"																							  "
cQuery += "ORDER BY FAIXA"

                                                                                                                   
	memowrit("C:\temp\VIDASFAIXA.sql",cQuery)																																						   

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
