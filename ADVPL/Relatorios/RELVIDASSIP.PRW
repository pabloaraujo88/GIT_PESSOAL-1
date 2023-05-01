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

User Function RELVIDASSIP()
cPerg := "RELVIDASIP"
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

c_Qry := "SELECT 'NUMERO DE MULHERES ENTRE 50 A 69 ANOS' AS DESCR, COUNT(*) AS QUANTIDADE "
c_Qry += "FROM  " + RetSqlName("BA1") + " BA1 (NOLOCK)    "
IF mv_par04 == 1	
    c_Qry += "WHERE BA1_CODEMP = '0001'" 	
ELSEIF mv_par04 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '3' "
ELSEIF mv_par04 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5 ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE BA1_CODEMP BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "'
ENDIF
c_Qry += "AND BA1.D_E_L_E_T_ = ''	
c_Qry += "AND BA1_DATCON <= '" + Dtos(mv_par03) + "'                                                         "
c_Qry += "AND (BA1_DATBLO >='" + Dtos(mv_par03) + "' OR BA1_DATBLO = '')                                     "
c_Qry += "AND BA1_SEXO = '2'         "
c_Qry += "AND Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 50 AND 69       "
c_Qry += "UNION                      "
c_Qry += "SELECT 'NUMERO DE MULHERES ENTRE 25 A 59 ANOS' AS DESCR, COUNT(*) AS QUANTIDADE "
c_Qry += "FROM  " + RetSqlName("BA1") + " BA1 (NOLOCK)    "
IF mv_par04 == 1	
    c_Qry += "WHERE BA1_CODEMP = '0001'" 	
ELSEIF mv_par04 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '3' "
ELSEIF mv_par04 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5 ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE BA1_CODEMP BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "'
ENDIF
c_Qry += "AND BA1.D_E_L_E_T_ = ''	
c_Qry += "AND BA1_DATCON <= '" + Dtos(mv_par03) + "'                                                         "
c_Qry += "AND (BA1_DATBLO >='" + Dtos(mv_par03) + "' OR BA1_DATBLO = '')                                     "
c_Qry += "AND BA1_SEXO = '2'         "
c_Qry += "AND Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 25 AND 59       "
c_Qry += "UNION                      "
c_Qry += "SELECT 'NUMERO DE CRIANÇAS ENTRE 0 A 5 ANOS' AS DESCR, COUNT(*) AS QUANTIDADE "
c_Qry += "FROM  " + RetSqlName("BA1") + " BA1 (NOLOCK)    "
IF mv_par04 == 1	
    c_Qry += "WHERE BA1_CODEMP = '0001'" 	
ELSEIF mv_par04 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '3' "
ELSEIF mv_par04 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5 ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE BA1_CODEMP BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "'
ENDIF
c_Qry += "AND BA1.D_E_L_E_T_ = ''	
c_Qry += "AND BA1_DATCON <= '" + Dtos(mv_par03) + "'                                                         "
c_Qry += "AND (BA1_DATBLO >='" + Dtos(mv_par03) + "' OR BA1_DATBLO = '')                                     "
c_Qry += "AND Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) <= 5                    "
c_Qry += "UNION                      "
c_Qry += "SELECT 'NUMERO DE IDOSOS (+ 60 ANOS )' AS DESCR, COUNT(*) AS QUANTIDADE "
c_Qry += "FROM  " + RetSqlName("BA1") + " BA1 (NOLOCK)    "
IF mv_par04 == 1	
    c_Qry += "WHERE BA1_CODEMP = '0001'" 	
ELSEIF mv_par04 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '3' "
ELSEIF mv_par04 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5 ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE BA1_CODEMP BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "'
ENDIF
c_Qry += "AND BA1.D_E_L_E_T_ = ''	
c_Qry += "AND BA1_DATCON <= '" + Dtos(mv_par03) + "'                                                         "
c_Qry += "AND (BA1_DATBLO >='" + Dtos(mv_par03) + "' OR BA1_DATBLO = '')                                     "
c_Qry += "AND Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) >60                     "
c_Qry += "UNION                      "
c_Qry += "SELECT 'NUMERO DE IDOSOS ENTRE 59 a 69 ANOS' AS DESCR, COUNT(*) AS QUANTIDADE  "
c_Qry += "FROM  " + RetSqlName("BA1") + " BA1 (NOLOCK)    "
IF mv_par04 == 1	
    c_Qry += "WHERE BA1_CODEMP = '0001'" 	
ELSEIF mv_par04 == 2
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5  ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '3' "
ELSEIF mv_par04 == 3
    c_Qry += "INNER JOIN " + RetSqlName("BT5") + " BT5 ON(BA1_CODINT+BA1_CODEMP+BA1_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    c_Qry += "					INNER JOIN " + RetSqlName("BII") + " BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    c_Qry += "WHERE    BA1.BA1_FILIAL = '  '  AND BII_CODIGO = '2' "
ELSE
    c_Qry += "WHERE BA1_CODEMP BETWEEN  '" + mv_par01 + "' AND '" + mv_par02 + "'
ENDIF
c_Qry += "AND BA1.D_E_L_E_T_ = ''	
c_Qry += "AND BA1_DATCON <= '" + Dtos(mv_par03) + "'                                                         "
c_Qry += "AND (BA1_DATBLO >='" + Dtos(mv_par03) + "' OR BA1_DATBLO = '')                                     "
c_Qry += "AND Datediff(yyyy,Convert(Datetime,BA1_DATNAS,03),GETDATE()) BETWEEN 59 AND 69       "

                                                                                                                        
				
																																		   

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
cAba    := "VIDAS UNIX"
cTabela := "Grupo Empresa: " +  mv_par01 + " Ate: " +  mv_par02 
//cDescri := "Total de atendimentos prestados, em regime ambulatorial, de caráter eletivo, urgência ou emergência."
// Criação de nova aba 
oExcel:AddworkSheet(cAba)

// Criação de tabela
//oExcel:AddTable (cAba,cDescri)
oExcel:AddTable (cAba,cTabela)



// Criação de colunas 
oExcel:AddColumn(cAba,cTabela,"Descricao" ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"Quantidade"    ,2,1,.T.) 



While !QRY->(Eof())
 
    // Criação de Linhas 
    oExcel:AddRow(cAba,cTabela, { QRY->DESCR , ;
                                 QRY->QUANTIDADE })

    QRY->(dbSkip())

End


If !Empty(oExcel:aWorkSheet)

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)
 
    CpyS2T("\SYSTEM\"+cArquivo, cPath)

    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
    oExcelApp:SetVisible(.T.)

EndIf


Return

