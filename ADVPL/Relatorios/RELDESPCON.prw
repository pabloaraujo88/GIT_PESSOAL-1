#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#include "shell.ch"
#include "fileio.ch"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

/*/{Protheus.doc} FFINR003
Programa relatório Vidas por Faixa UNIX
@author Pablo Leite
@since 16/06/2022
@version 12.1.27


*/

User Function RELDESPCON()
cPerg := "DESPCON"
//MV_PAR01  ANO C   4

If 	Pergunte(cPerg,.T.)
	Processa({|| IMPCP() },"extrato utilizacao UNIX","Aguarde ...", .F.)
Endif

Return .T.  

Static Function IMPCP(c_Titulo)

Local cArquivo  := "utilizacaoUNIX.XLS"
Local oExcelApp := Nil
Local cPath     := "C:\WINDOWS\TEMP\"
Local oExcel



aColunas := {}
aLocais := {} 
oBrush1 := TBrush():New(, RGB(193,205,205))

If mv_par19 == 1	
    cQuery := "SELECT   'INDIVIDUAL FAMILIAR' AS BII_DESCRI,BD6.BD6_OPEUSR+BD6.BD6_CODEMP+BD6.BD6_MATRIC+BD6.BD6_TIPREG+BD6.BD6_DIGITO AS CONTRATO,                                         "
    cQuery += "		 BD6.BD6_OPEUSR+BD6.BD6_CODEMP+BD6.BD6_MATRIC+BD6.BD6_TIPREG+BD6.BD6_DIGITO AS MATRICULA,   "
    cQuery += "         BD6.BD6_ANOPAG+BD6.BD6_MESPAG AS BD6_ANOMES,    "
    cQuery += "         BD6.BD6_CODRDA,BD6.BD6_NOMRDA,"
    cQuery += "         CONVERT(CHAR(10), CONVERT(DATETIME, BD6.BD6_DATPRO, 103), 103) AS BD6_DATPRO ,   "
    cQuery += "         BD6.BD6_CODLDP,BD6.BD6_CODPEG,BD6.BD6_NUMERO,BD6.BD6_QTDPRO,BD6.BD6_CODPRO,     "
    cQuery += "         BD6.BD6_DESPRO,BD6.BD6_VLRPAG,BD6.BD6_VLRTPF    "
    cQuery += "FROM     BD6020 BD6 
    cQuery += "WHERE    BD6.BD6_FILIAL = '  '   "
ELSEIF mv_par19 == 2
    cQuery := "SELECT   BII_DESCRI,BD6_OPEUSR+BD6_CODEMP+BD6_CONEMP+BD6_SUBCON AS CONTRATO,                                         "
    cQuery += "		 BD6.BD6_OPEUSR+BD6.BD6_CODEMP+BD6.BD6_MATRIC+BD6.BD6_TIPREG+BD6.BD6_DIGITO AS MATRICULA,   "
    cQuery += "         BD6.BD6_ANOPAG+BD6.BD6_MESPAG AS BD6_ANOMES,    "
    cQuery += "         BD6.BD6_CODRDA,BD6.BD6_NOMRDA,   "
    cQuery += "         CONVERT(CHAR(10), CONVERT(DATETIME, BD6.BD6_DATPRO, 103), 103) AS BD6_DATPRO ,   "
    cQuery += "         BD6.BD6_CODLDP,BD6.BD6_CODPEG,BD6.BD6_NUMERO,BD6.BD6_QTDPRO,BD6.BD6_CODPRO,     "
    cQuery += "         BD6.BD6_DESPRO,BD6.BD6_VLRPAG,BD6.BD6_VLRTPF    "
    cQuery += "FROM     BD6020 BD6 INNER JOIN BT5020 BT5 ON(BD6_OPEUSR+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    cQuery += "					INNER JOIN BII020 BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    cQuery += "WHERE    BD6.BD6_FILIAL = '  '  AND BII_CODIGO = '3' "

else
    cQuery := "SELECT   BII_DESCRI,BD6_OPEUSR+BD6_CODEMP+BD6_CONEMP+BD6_SUBCON AS CONTRATO,                                         "
    cQuery += "		 BD6.BD6_OPEUSR+BD6.BD6_CODEMP+BD6.BD6_MATRIC+BD6.BD6_TIPREG+BD6.BD6_DIGITO AS MATRICULA,   "
    cQuery += "         BD6.BD6_ANOPAG+BD6.BD6_MESPAG AS BD6_ANOMES,    "
    cQuery += "         BD6.BD6_CODRDA,BD6.BD6_NOMRDA,   "
    cQuery += "         CONVERT(CHAR(10), CONVERT(DATETIME, BD6.BD6_DATPRO, 103), 103) AS BD6_DATPRO ,   "
    cQuery += "         BD6.BD6_CODLDP,BD6.BD6_CODPEG,BD6.BD6_NUMERO,BD6.BD6_QTDPRO,BD6.BD6_CODPRO,     "
    cQuery += "         BD6.BD6_DESPRO,BD6.BD6_VLRPAG,BD6.BD6_VLRTPF    "
    cQuery += "FROM     BD6020 BD6 INNER JOIN BT5020 BT5 ON(BD6_OPEUSR+BD6_CODEMP+BD6_CONEMP = BT5_CODINT+BT5_CODIGO+BT5_NUMCON) "
    cQuery += "					INNER JOIN BII020 BII ON (BII_CODIGO = BT5_TIPCON AND BII.D_E_L_E_T_ = '' AND BT5.D_E_L_E_T_ = '') "
    cQuery += "WHERE    BD6.BD6_FILIAL = '  '  AND BII_CODIGO = '2' "

ENDIF
cQuery += "AND      BD6.BD6_OPEUSR =  '"+MV_PAR01+"' "
cQuery += "AND      BD6.BD6_CODEMP >= '"+MV_PAR02+"'    "
cQuery += "AND      BD6.BD6_CODEMP <= '"+MV_PAR03+"'    "
cQuery += "AND      BD6.BD6_CONEMP >= '"+MV_PAR04+"'    "
cQuery += "AND      BD6.BD6_CONEMP <= '"+MV_PAR05+"'    "
cQuery += "AND      BD6.BD6_SUBCON >= '"+MV_PAR06+"'   "
cQuery += "AND      BD6.BD6_SUBCON <= '"+MV_PAR07+"'   "
cQuery += "AND      BD6.BD6_MATRIC >= '"+MV_PAR08+"'    "
cQuery += "AND      BD6.BD6_MATRIC <= '"+MV_PAR09+"'    "
cQuery += "AND      BD6.BD6_TIPREG >= '"+MV_PAR10+"'  "      
cQuery += "AND      BD6.BD6_TIPREG <= '"+MV_PAR11+"'  "
cQuery += "AND      BD6.BD6_ANOPAG+BD6.BD6_MESPAG >= '"+MV_PAR12+MV_PAR13+"'   "   
cQuery += "AND      BD6.BD6_ANOPAG+BD6.BD6_MESPAG <= '"+MV_PAR14+MV_PAR15+"'   "
cQuery += "AND      BD6.BD6_DATPRO >= '"+DTOS(MV_PAR16)+"'    "
cQuery += "AND      BD6.BD6_DATPRO <= '"+DTOS(MV_PAR17)+"'    and "
If mv_par18 == 1
	cQuery += "BD6.BD6_FASE IN ('2','3','4') AND BD6_SITUAC = '1' AND "
ElseIf mv_par18 == 2
	cQuery += "BD6.BD6_FASE = '2' AND BD6_SITUAC = '1' AND "
ElseIf mv_par18 == 3
	cQuery += "BD6.BD6_FASE = '3' AND BD6_SITUAC = '1' AND "
ElseIf mv_par18 == 4
	cQuery += "BD6.BD6_FASE = '4' AND BD6_SITUAC = '1' AND "
ElseIf mv_par18 == 5
	cQuery += "BD6.BD6_FASE IN ('3','4') AND BD6_SITUAC = '1' AND "
EndIf

cQuery += "BD6.D_E_L_E_T_ <> '*'   "
cQuery += "ORDER BY BD6.BD6_CODEMP, BD6.BD6_MATRIC, BD6.BD6_ANOPAG, BD6.BD6_MESPAG, "
cQuery += "         BD6.BD6_TIPREG, BD6.BD6_DIGITO, BD6.BD6_CODRDA  "


                                                                                                                   
	memowrit("C:\temp\UTILIZACAO_UNIX.sql",cQuery)																																						   

	TcQuery cQuery New Alias QRY

	DbSelectArea("QRY")
	QRY->( DbGoTop() )

	If 	QRY->(Eof())
		ShowHelpDlg("Relatório de extrato de Utilização UNIX" ,;
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
cAba    := "Relatório de extrato de Utilização UNIX"
cTabela := "UNIX SAUDE LTDA - Utilização UNIX"

// Criação de nova aba 
oExcel:AddworkSheet(cAba)

// Criação de tabela
oExcel:AddTable (cAba,cTabela)

// Criação de colunas 
oExcel:AddColumn(cAba,cTabela,"TIPO         " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"CONTRATO     " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"MATRICULA    " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"PERIODO      " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"COD_RDA      " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"NOME_RDA      " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"DATA         " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"LOCAL        " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"PROTOCOLO    " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"GUIA         " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"QUANTIDADE   " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"PROCEDIMENTO " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"DESCRICAO    " ,1,1,.F.) 
oExcel:AddColumn(cAba,cTabela,"VALORPAGO    " ,1,3,.T.)
oExcel:AddColumn(cAba,cTabela,"VALORCOPART  " ,1,3,.T.)


While !QRY->(Eof())
 
    // Criação de Linhas 
oExcel:AddRow(cAba,cTabela, {  QRY->BII_DESCRI ,;
                               QRY->CONTRATO ,;
                               QRY->MATRICULA	,;
                               QRY->BD6_ANOMES  ,;
                               QRY->BD6_CODRDA  ,;
                               QRY->BD6_NOMRDA  ,;
                               QRY->BD6_DATPRO  ,;
                               QRY->BD6_CODLDP  ,;
                               QRY->BD6_CODPEG  ,;
                               QRY->BD6_NUMERO  ,;
                               QRY->BD6_QTDPRO  ,;
                               QRY->BD6_CODPRO  ,;
                               QRY->BD6_DESPRO  ,;
                               QRY->BD6_VLRPAG  ,;
                               QRY->BD6_VLRTPF })
    QRY->(dbSkip())

End
    QRY->(DbCloseArea())
     


If !Empty(oExcel:aWorkSheet)

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)
 
    CpyS2T("\SYSTEM\"+cArquivo, cPath)

    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
    oExcelApp:SetVisible(.T.)

EndIf


Return

