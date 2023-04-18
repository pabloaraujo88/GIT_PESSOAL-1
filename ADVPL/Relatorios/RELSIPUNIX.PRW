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

User Function RELSIPUNIX()
cPerg := "RELSIPUNIX"
//MV_PAR01  ANO C   4

If 	Pergunte(cPerg,.T.)
	Processa({|| IMPCP() },"INDICADORES SIP","Aguarde ...", .F.)
Endif

Return .T.  

Static Function IMPCP(c_Titulo)

Local cArquivo  := "INDICADORES_SIP.XLS"
Local oExcelApp := Nil
Local cPath     := "C:\WINDOWS\TEMP\"
Local oExcel


aColunas := {}
aLocais := {} 
oBrush1 := TBrush():New(, RGB(193,205,205))

c_Qry := "SELECT BAQ_DESCRI,BD6_DESPRO,count(BD6_CODPRO) AS QUANTIDADE "
c_Qry += "FROM " + RetSqlName("BD6") + " BD6 (NOLOCK) JOIN " + RetSqlName("BAQ") + " BAQ (NOLOCK) ON (BD6_CODESP = BAQ_CODESP) "

IF mv_par05 == 1	
    c_Qry += "WHERE " 	
ELSEIF mv_par05 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON(BD6_OPEUSR+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '3' "
ELSEIF mv_par05 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5 ON(BD6_OPEUSR+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE  "
ENDIF
c_Qry += "BD6.D_E_L_E_T_ = '' and BD6_FASE = '4' AND BD6_VLRPAG > '0' "
c_Qry += "AND BAQ.D_E_L_E_T_ = '' "
c_Qry += "and BD6_CODEMP BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
c_Qry += "AND BD6_DATPRO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' "
c_Qry += "AND BD6_CODPRO IN ("
c_Qry += "'80000004', '00010006','10101128','80000003',    "  
c_Qry += "'80000008','30402042','80000001','10101047','20101074','30205093',"
c_Qry += "'80000002','10101179','10101012','80000100','30501083','80000097',"
c_Qry += "'99999994','50000462','00010014','10106014','10106030','20101082',"
c_Qry += "'40401022','20101015','20101090','10106049','10106146','20101210',"
c_Qry += "'20101228','20101236','20201133','10101039','50000144','50000160',"
c_Qry += "'50000195','50000209','50000217','50000233','50000713','50000721',"
c_Qry += "'50000730','50000748','50000756','50000764','50000772','50000780',"
c_Qry += "'50000853','50000861','50000870','50001060','50001078','50000586',"
c_Qry += "'50000616','50000640','50000659','50000560','50000012','50000020',"
c_Qry += "'50000039','50000047','50000055','50000080','50000110','50000128',"
c_Qry += "'50000136','50000462','50000470','50000489','50000497','50000500',"
c_Qry += "'50000519','8000000008', '8000000024','8000000004')"
c_Qry += "GROUP BY BD6_DESPRO,BD6_CODESP,BAQ_DESCRI "
c_Qry += "ORDER BY BAQ_DESCRI "
                                                                                                                             
																																							   

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
cAba    := "Consultas UNIX"
cTabela := "Grupo Empresa: " +  mv_par01 
//cDescri := "Total de atendimentos prestados, em regime ambulatorial, de caráter eletivo, urgência ou emergência."
// Criação de nova aba 
oExcel:AddworkSheet(cAba)

// Criação de tabela
//oExcel:AddTable (cAba,cDescri)
oExcel:AddTable (cAba,cTabela)



// Criação de colunas 
oExcel:AddColumn(cAba,cTabela,"Item do SIP" ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"Procedimento TUSS" ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"Quantidade"    ,2,1,.T.) 



While !QRY->(Eof())
 
    // Criação de Linhas 
    oExcel:AddRow(cAba,cTabela, { QRY->BAQ_DESCRI , QRY->BD6_DESPRO,;
                                 QRY->QUANTIDADE })

    QRY->(dbSkip())

End

DBCloseArea()

If !Empty(oExcel:aWorkSheet)

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)
 
    CpyS2T("\SYSTEM\"+cArquivo, cPath)

    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
    oExcelApp:SetVisible(.T.)

EndIf


Return

