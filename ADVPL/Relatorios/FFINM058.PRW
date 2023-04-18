#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'TBICONN.CH'

#define ENTER chr( 13 ) + chr( 10 )


/*/{Protheus.doc} FFINM058
JOB para enviar relatório com titulos em aberto no Contas a Pagar com vencimento próximo e que não estão em borderô
@type function
@version  
@author pablo.araujo
@since 28/09/2022
@return variant, return_description
/*/


User Function FFINM058()
	Local a_Emp		:= {}
	Local nX		:= 0
	Local c_Filial	:= ""
	Local aSM0Data
	Local nI

	prepare environment empresa "01" filial "01BA0001"
/*
	dbUseArea(.T.,"CTREECDX","sigamat.emp","SM0", .T., .F.)

	//Executa para todas as empresas
	DBSELECTAREA( "SM0" )
	SM0->( DBGOTOP() )
	WHILE SM0->( !EOF() )

		If Ascan( a_Emp, Substr( SM0->M0_CODFIL, 1, 2 ) ) == 0
			Aadd( a_Emp, Substr( SM0->M0_CODFIL, 1, 2 ) )
		Endif

		SM0->( DBSKIP() )

	ENDDO
*/
	aSM0Data := FWSM0Util():GetSM0Data(,,{"M0_CODFIL"})
	for nI := 1 to len( aSM0Data )
		If aScan( a_Emp, Substr( aSM0Data[nI][2], 1, 2 ) ) == 0
			aAdd( a_Emp, Substr( aSM0Data[nI][2], 1, 2 ) )
		Endif
	next

	For nX:=1 To Len( a_Emp ) Step 1

		c_Filial := a_Emp[nX] + "BA0001"

		StartJob( "U_FFINM58A", GetEnvServer(), .T., "01", c_Filial )

	Next nX

Return()

User Function FFINM58A( c_Empresa, c_Filial )

	Local d_Server		:= CTOD("  /  /  ") //Date()
	Local c_Html		:= ""
	Local c_Subj		:= ""
	Local c_Qry			:= ""
	Local c_To			:= ""
	Local l_Envia		:= .F.

	RpcSetType(3)
	RpcSetEnv( c_Empresa, c_Filial )


	c_To		:= "tatianes@fieb.org.br;pablo.araujo@fieb.org.br; cleydianes@fieb.org.br; fernanda.graca@fieb.org.br;tania.silva@fieb.org.br; luciana.santana@fieb.org.br; marielef@fieb.org.br"
	//c_To := superGetMv( "FS_CPVCTO",, "pablo.araujo@fieb.org.br" )	
	d_Server	:= dDataBase
	c_Subj		:= "TITULOS COM VENCIMENTO EM ABERTO NA DATA DE " + DTOC( d_Server )



	c_Qry := " SELECT E2_FILIAL,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_NOMFOR,A2_CGC,E2_VENCTO,E2_VALOR,E2_SALDO,E2_XHIST, " + ENTER
    c_Qry += " E2_ZBANCO + ' | ' + E2_ZAGENCI + ' | ' + TRIM(E2_ZCONTA)  AS CONTA " + ENTER
	c_Qry += " FROM " + RETSQLNAME("SE2") + " E2 (NOLOCK) " + ENTER
	c_Qry += "	INNER JOIN " + RETSQLNAME("SA2") + " A2 (NOLOCK) " + ENTER
	c_Qry += "	ON " + ENTER
	c_Qry += "		A2.D_E_L_E_T_ = ''  " + ENTER
	c_Qry += "		AND A2.A2_COD = E2.E2_FORNECE " + ENTER
	c_Qry += "		AND A2.A2_LOJA = E2.E2_LOJA " + ENTER
	c_Qry += " WHERE E2.D_E_L_E_T_ = '' " + ENTER
	//c_Qry += " AND E2_EMISSAO >= convert(varchar(10),getdate(),112)-7 " + ENTER
	c_Qry += "AND E2_FSBLQCP <> '1'" + ENTER
	c_Qry += " and E2_VENCTO = convert(varchar(10),getdate(),112) " + ENTER
	c_Qry += " AND E2_NUMBOR = '' " + ENTER
	c_Qry += " AND E2_SALDO > 0	" + ENTER
	c_Qry += " ORDER BY E2_VENCTO,E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE" + ENTER

	TcQuery c_Qry New Alias "QRY"
	c_Html	:= "<body> " + ENTER
	c_Html	+= "	<table cellspacing='0' cellpadding='0' border='1' width=960px> " + ENTER
	c_Html	+= "		<tr align='center'> " + ENTER
	c_Html	+= "			<th colspan='13' style='background-color:#7798AB; color:white; width:200px'><font face='tahoma' size='2' align='center'>Segue abaixo o(s) titulos em aberto para a vossa análise que ainda não estão em borderô.</font></th> " + ENTER
	c_Html	+= "		</tr> " + ENTER
	c_Html	+= "		<tr align='center'> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:30px'><font face='tahoma' size='2' align='center'>FILIAL</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:10px'><font face='tahoma' size='2' align='center'>PREFIXO</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:40px'><font face='tahoma' size='2' align='center'>NUMERO</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:10px'><font face='tahoma' size='2' align='center'>TIPO</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:20px'><font face='tahoma' size='2' align='center'>FORNECEDOR</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:160px'><font face='tahoma' size='2' align='center'>NOME</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:40px'><font face='tahoma' size='2' align='center'>DATA EMISSAO</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:40px'><font face='tahoma' size='2' align='center'>DATA VENCIMENTO</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:40px'><font face='tahoma' size='2' align='center'>VALOR ORIGINAL</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:40px'><font face='tahoma' size='2' align='center'>SALDO</font></td> " + ENTER
    c_Html	+= "			<td style='background-color:gray; color:white; width:40px'><font face='tahoma' size='2' align='center'>		CONTA	</font></td> " + ENTER
	c_Html	+= "			<td style='background-color:gray; color:white; width:200px'><font face='tahoma' size='2' align='center'>HISTORICO</font></td> " + ENTER
	c_Html	+= "		</tr> " + ENTER

	dbSelectArea("QRY")
	QRY->(dbGoTop() )
	While QRY->(! EOF() )

		c_Html	+= "	<tr align='center'> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:30px'><font face='tahoma' size='2' align='center'>" +  QRY->E2_FILIAL + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:10px'><font face='tahoma' size='2' align='center'>" +  QRY->E2_PREFIXO + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:40px'><font face='tahoma' size='2' align='center'>&#160;" +  QRY->E2_NUM + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:10px'><font face='tahoma' size='2' align='center'>" +  QRY->E2_TIPO + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:20px'><font face='tahoma' size='2' align='center'>" +  QRY->E2_FORNECE + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:160px'><font face='tahoma' size='2' align='center'>" +  QRY->E2_NOMFOR + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:40px'><font face='tahoma' size='2' align='center'>" +  DTOC( STOD( QRY->E2_EMISSAO ) ) + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:40px'><font face='tahoma' size='2' align='center'>" +  DTOC( STOD( QRY->E2_VENCTO ) ) + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:40px'><font face='tahoma' size='2' align='center'>" +  TRANSFORM( QRY->E2_VALOR, "@e 999,999,999.99" ) + "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:40px'><font face='tahoma' size='2' align='center'>" +  TRANSFORM( QRY->E2_SALDO, "@e 999,999,999.99" ) + "</font></td> " + ENTER
    	c_Html	+= "		<td style='background-color:white; color:black; width:40px'><font face='tahoma' size='2' align='center'>" +  QRY->CONTA+ "</font></td> " + ENTER
		c_Html	+= "		<td style='background-color:white; color:black; width:200px'><font face='tahoma' size='2' align='center'>" +  QRY->E2_XHIST + "</font></td> " + ENTER
		c_Html	+= "	</tr> " + ENTER
		l_Envia	:= .T.

		QRY->( dbSkip() )
	EndDo

	c_Html	+= "	</table><br> " + ENTER
	c_Html	+= "	</body> " + ENTER

	If l_Envia
		If U_TBSENDMAIL( c_To, c_Html , c_Subj, .F., "", "" )
			conout("------------ EXECUTANDO JOB ALERTA TITULOS A PAGAR " + DTOC(DATE()) + " " + Time() + " ------------")
		EndIf
	EndIf

Return( .T. )
