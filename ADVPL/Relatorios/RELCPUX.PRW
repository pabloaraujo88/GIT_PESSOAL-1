#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#include "shell.ch"
#include "fileio.ch"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

/*/{Protheus.doc} FFINR003
Programa relatório  Contraprestações Pecuniárias/Prêmios por Período de Cobertura - DIOPS
@author Pablo Leite
@since 16/06/2022
@version 12.1.27

O relatório Contraprestações Pecuniárias/Prêmios por Período de Cobertura  foi desenvolvido para atender o quadro Contrap 
por Per. Cobertura do DIOPS. Nesse quadro as Operadoras deverão identificar os valores correspondentes a contraprestação 
associada ao período de cobertura.

Valor Emitido: Corresponde ao somatório das demais colunas de valor Recebido, Vencido e A Vencer.  A quantidade de títulos
 apresentados nesta coluna poderá ser conferida utilizando o relatório ACR302AA.
Valor Recebido: Serão considerados todos os títulos com emissão e liquidação ocorrida dentro do último mês do trimestre gerado. 
Os valores desta coluna poderão ser conferidos utilizando o relatório ACR304AA, fechando a emissão dentro do último mês gerado.

Ex.: Geração do 1º trimestre de 2020 - Serão considerados títulos com emissão e liquidação dentro do mês 03/2020.

Valor Vencido (em atraso): Serão considerados todos os títulos com emissão menor ou igual ao último dia do trimestre e gerado, 
que ainda possui valor de saldo (não liquidado, ou liquidado parcialmente) e que o vencimento seja menor que o último dia do 
trimestre gerado. Os valores desta coluna poderão ser conferidos utilizando o relatório ACR303AA, informando a data de posição 
como último dia do trimestre gerado.
Ex.: Geração do 1º trimestre de 2020 - Serão considerados títulos em aberto com vencimento menor que  31/03/2020.

Valor a Vencer: Serão considerados todos os títulos com emissão menor ou igual ao último dia do trimestre e gerado, que ainda 
possui valor de saldo (não liquidado, ou liquidado parcialmente) e que o vencimento seja maior que o último dia do trimestre 
gerado. Os valores desta coluna poderão ser conferidos utilizando o relatório ACR303AA, informando a data de posição como último
 dia do trimestre gerado.
Ex.: Geração do 1º trimestre de 2020 - Serão considerados títulos em aberto com vencimento maior que  31/03/2020.
*/

User Function RELCPUX()
cPerg := "MPLSRQCP"
//MV_PAR01  ANO C   4

If 	Pergunte(cPerg,.T.)
	Processa({|| IMPCP() },"CONTRAPRESTACOES UNIX","Aguarde ...", .F.)
Endif

Return .T.  

Static Function IMPCP(c_Titulo)

Local cArquivo  := "PLANCONTRAPRESTACOES.XLS"
Local oExcelApp := Nil
Local cPath     := "C:\WINDOWS\TEMP\"
Local oExcel

aColunas := {}
aLocais := {} 
//oBrush1 := TBrush():New(, RGB(193,205,205))

c_Qry := " SELECT dEmissao, MAX(EMITIDO) AS EMITIDO, MAX(RECEBIDO) AS RECEBIDO,	 "                                                                             
c_Qry += " MAX(VENCIDO) AS VENCIDO, MAX(VENCER) AS VENCER                        "                                                                             
c_Qry += " FROM (                                                                "                                                                             
c_Qry += "	SELECT dEmissao,                                                     "                                                                             
c_Qry += "	EMITIDO= ( CASE TIPO  WHEN 'EMITIDO' THEN TOTAL ELSE 0 END ),        "                                                                             
c_Qry += "	VENCIDO= ( CASE TIPO  WHEN 'VENCIDO' THEN TOTAL ELSE 0 END ),        "                                                                             
c_Qry += "	RECEBIDO= ( CASE TIPO  WHEN 'RECEBIDO' THEN TOTAL ELSE 0 END ),      "                                                                             
c_Qry += "	VENCER= ( CASE TIPO  WHEN 'VENCER' THEN TOTAL ELSE 0 END )           "                                                                             
c_Qry += "	FROM (  	/*EMITIDO*/                                              "                                                                             
c_Qry += "				SELECT   convert(char(10),convert(datetime, E1_EMISSAO,103),103)  dEmissao, "                                                          
c_Qry += " 										SUM(E1_VALOR) as TOTAL, 'EMITIDO'  AS TIPO "                                                                   
c_Qry += "				FROM  " + RetSqlName("SE1") + " SE1 (NOLOCK)"                                                                                          
c_Qry += "				left join " + RetSqlName("BA3") + " BA3 (NOLOCK) on (BA3_CODEMP = E1_CODEMP and BA3_MATRIC = E1_MATRIC and BA3_CODINT = E1_CODINT )  " 
c_Qry += "				left join " + RetSqlName("BDC") + " BDC (NOLOCK) on (E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO AND BDC.D_E_L_E_T_ <> '*' ) "              
c_Qry += "				WHERE       "                                                                                                                          
c_Qry += "				   BDC_ANOINI = '" + Substring(Dtos(mv_par02),1,4) + "'	      "                                                                                                        
c_Qry += "				   AND BDC_ANOFIM = '" + Substring(Dtos(mv_par03),1,4) + "'	    "                                                                                                        
c_Qry += "				   AND BDC_MESINI = '" + Substring(Dtos(mv_par02),5,2) + "'	      "  
c_Qry += "                 AND E1_EMISSAO BETWEEN '" + Dtos(mv_par02) + "' AND '" + Dtos(mv_par03) + "'"                                                                                                      
c_Qry += "				   AND BDC_MESFIM = '" + Substring(Dtos(mv_par03),5,2) + "'      "                                                                                                        
c_Qry += "				   AND BDC_GRPCOB BETWEEN '" + mv_par06 + "' AND'" + mv_par07 + "' "                                                                                     
c_Qry += "				   AND E1_FILIAL = '01'                          "                                                                                     
c_Qry += "				   AND E1_PREFIXO IN ('11','UNI')                "                                                                                     
c_Qry += "				   AND E1_TIPO NOT IN ('IS')                     "                                                                                     
c_Qry += "				   AND E1_CODEMP = '" + mv_par01 + "'                       "                                                                                     
c_Qry += "				   AND SUBSTRING(E1_ORIGEM,1,3) = 'PLS'          "                                                                                     
c_Qry += "				   AND SE1.D_E_L_E_T_ = ' ' AND (BA3.D_E_L_E_T_ <> '*' or BA3.D_E_L_E_T_ is null)   "                                                  
c_Qry += "				GROUP BY E1_EMISSAO "                                                                                                                  
c_Qry += "				UNION               "                                                                                                                  
c_Qry += "				/*vRecebido*/       "                                                                                                                  
c_Qry += "				SELECT   convert(char(10),convert(datetime, E1_EMISSAO,103),103)  dEmissao, "                                                          
c_Qry += "				 SUM(E1_VALOR) as TOTAL, 'RECEBIDO' AS TIPO "                                                                                          
c_Qry += "				FROM  " + RetSqlName("SE1") + " SE1 (NOLOCK)   "                                                                                       
c_Qry += "				left join " + RetSqlName("BA3") + " BA3 (NOLOCK) on "                                                                                  
c_Qry += "				(BA3_CODEMP = E1_CODEMP and BA3_MATRIC = E1_MATRIC and BA3_CODINT = E1_CODINT ) "                                                      
c_Qry += "				left join " + RetSqlName("BDC") + " BDC (NOLOCK)  on "                                                                              
c_Qry += "				(E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO AND BDC.D_E_L_E_T_ <> '*' ) "                                                                      
c_Qry += "				WHERE E1_FILIAL = '01'               "                                                                                                 
c_Qry += "				   AND E1_PREFIXO IN ('11','UNI')    "                                                                                                 
c_Qry += "				   AND E1_BAIXA BETWEEN   '" + Dtos(mv_par04) + "' AND '" + Dtos(mv_par05) + "'"                                                      
c_Qry += "				   AND E1_EMISSAO BETWEEN '" + Dtos(mv_par02) + "' AND '" + Dtos(mv_par03) + "'"                                                      
c_Qry += "				   AND E1_TIPO NOT IN ('IS')                                                      "                                                    
c_Qry += "				   AND E1_CODEMP = '" + mv_par01 + "'                                             "                                                    
c_Qry += "				   AND E1_SALDO = '0'                                                             "                                                    
c_Qry += "				   AND SUBSTRING(E1_ORIGEM,1,3) = 'PLS'                                           "                                                    
c_Qry += "				   AND SE1.D_E_L_E_T_ = ' ' AND (BA3.D_E_L_E_T_ <> '*' or BA3.D_E_L_E_T_ is null)"                                               
c_Qry += "				   AND BDC_GRPCOB BETWEEN '" + mv_par06 + "' AND'" + mv_par07 + "'    "                                                               
c_Qry += "				GROUP BY E1_EMISSAO  "                                                                                                                 
c_Qry += "				UNION                "                                                                                                                 
c_Qry += "				/*vVencido*/         "                                                                                                                 
c_Qry += "				SELECT  convert(char(10),convert(datetime, E1_EMISSAO,103),103)  dEmissao,  "                                                          
c_Qry += "						SUM(E1_VALLIQ) as TOTAL ,'VENCIDO' AS TIPO   "                                                                                  
c_Qry += "				FROM  " + RetSqlName("SE1") + " SE1 (NOLOCK) "                                                                                         
c_Qry += "				left join " + RetSqlName("BA3") + " BA3 (NOLOCK) on "                                                                                  
c_Qry += "				(BA3_CODEMP = E1_CODEMP and BA3_MATRIC = E1_MATRIC and BA3_CODINT = E1_CODINT )    "                                                   
c_Qry += "				left join " + RetSqlName("BDC") + " BDC (NOLOCK)  on (E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO AND BDC.D_E_L_E_T_ <> '*' ) "              
c_Qry += "				WHERE E1_FILIAL = '01'"                                                                                                                
c_Qry += "				   AND E1_PREFIXO IN ('11','UNI') "                                                                                                    
//c_Qry += "				   AND E1_VENCORI BETWEEN '" + Dtos(mv_par02) + "' AND '" + Dtos(mv_par03) + "'"                                                       
c_Qry += "				   AND E1_EMISSAO BETWEEN '" + Dtos(mv_par02) + "' AND '" + Dtos(mv_par03) + "'"                                                       
c_Qry += "				   AND E1_SALDO > 0                      "                                                                                             
c_Qry += "				   AND E1_TIPO NOT IN ('IS')             "                                                                                             
c_Qry += "				   AND E1_CODEMP = '" + mv_par01 + "'               "                                                                                             
c_Qry += "				   AND SUBSTRING(E1_ORIGEM,1,3) = 'PLS'  "                                                                                             
c_Qry += "				   AND SE1.D_E_L_E_T_ = ' ' AND (BA3.D_E_L_E_T_ <> '*' or BA3.D_E_L_E_T_ is null)  "                                             
c_Qry += "				   AND BDC_GRPCOB BETWEEN '" + mv_par06 + "' AND'" + mv_par07 + "'                      "                                             
c_Qry += "				GROUP BY E1_EMISSAO                                                                      "                                             
c_Qry += "				UNION                                                                                    "                                             
c_Qry += "				/*vVencER*/                                                                              "                                             
c_Qry += "				SELECT   convert(char(10),convert(datetime, E1_EMISSAO,103),103)  dEmissao,                                                            
c_Qry += "				SUM(E1_VALOR) as TOTAL, 'VENCER' AS TIPO   "                                                                                           
c_Qry += "				FROM  " + RetSqlName("SE1") + " SE1 (NOLOCK)                                              							    "              
c_Qry += "				left join " + RetSqlName("BA3") + " BA3 (NOLOCK) on (BA3_CODEMP = E1_CODEMP and BA3_MATRIC = E1_MATRIC and BA3_CODINT = E1_CODINT )"    
c_Qry += "				left join " + RetSqlName("BDC") + " BDC (NOLOCK) on (E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO AND BDC.D_E_L_E_T_ <> '*' ) "              
c_Qry += "				WHERE E1_FILIAL = '01'             "                                                                                                   
c_Qry += "				   AND E1_PREFIXO IN ('11','UNI')  "                                                                                                   
c_Qry += "				   AND E1_BAIXA > '" + Dtos(mv_par03) + "'"                                                                                            
c_Qry += "				   AND E1_EMISSAO BETWEEN '" + Dtos(mv_par02) + "' AND '" + Dtos(mv_par03) + "'"                                                       
c_Qry += "				   AND E1_TIPO NOT IN ('IS')     "                                                                                                     
c_Qry += "				   AND E1_CODEMP = '" + mv_par01 + "'       "                                                                                                     
c_Qry += "				   AND SUBSTRING(E1_ORIGEM,1,3) = 'PLS'  "                                                                                             
c_Qry += "				   AND SE1.D_E_L_E_T_ = ' ' AND (BA3.D_E_L_E_T_ <> '*' or BA3.D_E_L_E_T_ is null)   "                                            
c_Qry += "				   AND BDC_GRPCOB BETWEEN '" + mv_par06 + "' AND'" + mv_par07 + "'                       "                                            
c_Qry += "				GROUP BY E1_EMISSAO                                                                       "                                            
c_Qry += "	) AS TABELA                                                                                           "                                            
c_Qry += " ) AS TABELA2                                                                                           "                                            
c_Qry += " GROUP BY dEmissao                                                                                                                                   
																																							   
memowrit("C:\temp\contraprestacao.sql",c_Qry)		

	TcQuery c_Qry New Alias QRY

	DbSelectArea("QRY")
	QRY->( DbGoTop() )

	If 	QRY->(Eof())
		ShowHelpDlg("Relatório de Contraprestações Pecuniárias / Prêmios por Período de Cobertura" ,;
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
cAba    := "CONTRAPRESTAÇÕES UNIX"
cTabela := "VALORES"

// Criação de nova aba 
oExcel:AddworkSheet(cAba)

// Criação de tabela
oExcel:AddTable (cAba,cTabela)

// Criação de colunas 
oExcel:AddColumn(cAba,cTabela,"D.Emissao"     ,1,4,.F.) 
oExcel:AddColumn(cAba,cTabela,"Emitido"       ,1,3,.T.) 
oExcel:AddColumn(cAba,cTabela,"Recebido"      ,1,3,.T.) 
oExcel:AddColumn(cAba,cTabela,"Vencido"       ,1,3,.T.) 
oExcel:AddColumn(cAba,cTabela,"A Vencer"      ,1,3,.T.)


While !QRY->(Eof())
 
    // Criação de Linhas 
    oExcel:AddRow(cAba,cTabela, { QRY->dEmissao ,;
                                 QRY->EMITIDO ,; 
                                 QRY->RECEBIDO,; 
                                 QRY->VENCIDO,; 
                                 QRY->VENCER })

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

