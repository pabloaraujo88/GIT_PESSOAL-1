#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#include "shell.ch"
#include "fileio.ch"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

/*/{Protheus.doc} FFINR003
Programa relatório  SIP UNIX
@author Pablo Leite
@since 16/07/2022
@version 12.1.27

*/

User Function RELPROCSIP()
cPerg := "RELSIPUNIX"
//MV_PAR01  ANO C   4

If 	Pergunte(cPerg,.T.)
	Processa({|| IMPCP() },"INDICADORES SIP","Aguarde ...", .F.)
Endif

Return .T.  

Static Function IMPCP(c_Titulo)

Local cArquivo  := Nil
Local oExcelApp := Nil
Local cPath     := "C:\WINDOWS\TEMP\"
Local oExcel


aColunas := {}
aLocais := {} 
oBrush1 := TBrush():New(, RGB(193,205,205))

c_Qry := "SELECT BD6_CODPRO,BD6_DESPRO,BR8_CLASIP,count(BD6_CODPRO) AS QUANTIDADE  "
c_Qry += "FROM " + RetSqlName("BD6") + " BD6 (NOLOCK) JOIN " + RetSqlName("BAQ") + " BAQ (NOLOCK) ON (BD6_CODESP = BAQ_CODESP and BD6.D_E_L_E_T_ = '' and BAQ.D_E_L_E_T_ = '') "
c_Qry += "INNER JOIN " + RetSqlName("BR8") + " BR8 ON (BR8_CODPAD = BD6_CODPAD AND BR8_CODPSA = BD6_CODPRO AND BR8.D_E_L_E_T_ <> '*' AND BR8_CLASIP <> '' )"

IF mv_par05 == 1	
    c_Qry += "WHERE BD6_CODEMP = '0001' AND BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'" 	
ELSEIF mv_par05 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON (BD6_CODOPE+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "WHERE  BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"
    c_Qry += " AND BII_CODIGO = '3' "
ELSEIF mv_par05 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON (BD6_CODOPE+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "WHERE  BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"
    c_Qry += " AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE  BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"

ENDIF
c_Qry += "and BD6.D_E_L_E_T_ = '' and BD6_FASE = '4' AND BD6_VLRPAG > '0' "
c_Qry += "AND (BD6_CODPRO IN ('40808033','40808041') AND Datediff(yyyy,Convert(Datetime,BD6_DATNAS,03),GETDATE()) < 50 "
c_Qry += "OR BD6_CODPRO IN ('40808033','40808041') AND Datediff(yyyy,Convert(Datetime,BD6_DATNAS,03),GETDATE()) >= 70 "
c_Qry += "OR BD6_CODPRO NOT IN ('40808033','40808041','40303136')) "
c_Qry += "AND BAQ.D_E_L_E_T_ = '' "
c_Qry += "GROUP BY BD6_CODPRO,BD6_DESPRO,BR8_CLASIP "

c_Qry += "UNION "

c_Qry += "SELECT BD6_CODPRO,RTRIM(BD6_DESPRO) + ' 50 A 69 ANOS' AS BD6_DESPRO,BR8_CLASIP,count(BD6_CODPRO) AS QUANTIDADE  "
c_Qry += "FROM " + RetSqlName("BD6") + " BD6 (NOLOCK) JOIN " + RetSqlName("BAQ") + " BAQ (NOLOCK) ON (BD6_CODESP = BAQ_CODESP) "
c_Qry += "INNER JOIN " + RetSqlName("BR8") + " BR8 ON (BR8_CODPAD = BD6_CODPAD AND BR8_CODPSA = BD6_CODPRO AND BR8.D_E_L_E_T_ <> '*' AND BR8_CLASIP <> '' )"
IF mv_par05 == 1	
    c_Qry += "WHERE BD6_CODEMP = '0001' AND BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'" 	
ELSEIF mv_par05 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON (BD6_CODOPE+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "WHERE  BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"
    c_Qry += " AND BII_CODIGO = '3' "
ELSEIF mv_par05 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON (BD6_CODOPE+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '')"
    c_Qry += "WHERE  BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"
    c_Qry += " AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE  BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"

ENDIF

c_Qry += "and BD6.D_E_L_E_T_ = '' and BD6_FASE = '4' AND BD6_VLRPAG > '0' "
c_Qry += "AND BD6_CODPRO  IN ('40808033','40808041','40303136') "
c_Qry += "AND Datediff(yyyy,Convert(Datetime,BD6_DATNAS,03),GETDATE()) BETWEEN '50' AND '69' "
c_Qry += "AND BAQ.D_E_L_E_T_ = '' "
c_Qry += "and BD6_CODEMP BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
c_Qry += "GROUP BY BD6_CODPRO,BD6_DESPRO,BR8_CLASIP "
c_Qry += "order by BD6_CODPRO"	                                                                                                                      
				
		memowrit("C:\temp\proc.sql",c_Qry)																																	   

	TcQuery c_Qry New Alias QRY

	DbSelectArea("QRY")
	QRY->( DbGoTop() )

	If 	QRY->(Eof())
		ShowHelpDlg("Relatório de Indicadores SIP" ,;
		{"Nenhum registro foi encontrado."},5,;
		{"Verifique se os parâmetros informados estão corretos."},5)
		QRY->( DbCloseArea() )
		Return
	Endif

// Verifica se o Excel está instalado na máquina
 
If !ApOleClient("MSExcel")

    MsgAlert("Microsoft Excel não instalado!")
    Return

EndIf

oExcel  := FWMSExcel():New()
cAba    := "Procedimentos UNIX"
cTabela := "Procedimento SIP - UNIX Grupo Empresa: " +  mv_par01 + " ate " +  mv_par02 
//cDescri := "Total de atendimentos prestados, em regime ambulatorial, de caráter eletivo, urgência ou emergência."
// Criação de nova aba 
oExcel:AddworkSheet(cAba)

// Criação de tabela
//oExcel:AddTable (cAba,cDescri)
oExcel:AddTable (cAba,cTabela)



// Criação de colunas 
oExcel:AddColumn(cAba,cTabela,"Procedimento TUSS" ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"Descricao" ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"Quantidade"    ,2,1,.T.) 



While !QRY->(Eof())
 
    // Criação de Linhas 
    oExcel:AddRow(cAba,cTabela, { QRY->BD6_CODPRO , QRY->BD6_DESPRO,;
                                 QRY->QUANTIDADE })

    QRY->(dbSkip())

End
DBCloseArea()

IF mv_par05 == 1
     cArquivo  := "pf_proc_SIP.XLS"
ELSEIF mv_par05 == 2
     cArquivo  := "empresarial_proc_SIP.XLS"
ELSEIF mv_par05 == 3
     cArquivo  := "cadesao_proc_SIP.XLS"
else
     cArquivo  := "carteira_proc_SIP.XLS"
Endif

If !Empty(oExcel:aWorkSheet)

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)
 
    CpyS2T("\SYSTEM\"+cArquivo, cPath)

    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
    oExcelApp:SetVisible(.T.)

EndIf


Return

