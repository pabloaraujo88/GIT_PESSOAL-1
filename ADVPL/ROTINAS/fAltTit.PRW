#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.ch"
#include 'FWMVCDEF.CH'
#include 'fileio.ch'
#INCLUDE "FWCOMMAND.CH"
#INCLUDE "fweditpanel.ch"

/*
AUTHOR: PABLO LEITE
DATE: 24/11/2023
FUNCTION: fAltTit
DESCRIPTION
A função fAltTit tem como objetivo principal criar uma tela de alteração para registros 
na tabela SE1. Ao executar a função, o código obtém a posição do registro atual na tabela SE1.
Campos alterados: E1_SITUACA| E1_SITUAC2 | E1_XSTNEG| E1_XSTTTCB| E1_XOCORR
GTI23024383
*/

User Function fAltTit()
    
    Local aArea := GetArea()

    private  oDlg
    private  oGetFilial, oGetPrefixo, oGetNumero, oGetParcela, oGetTipo
    private  oBtnBuscar, oBtnOcorr, oBtnCart, oBtnCob, oBtnNeg,oBtnCart2
    private  _cFilial := SPACE(8)
    private  _cPrefixo := SPACE(3)
    private  _cNumero := SPACE(9)
    private  _cParcela := SPACE(3)
    private  _cTipo := SPACE(3)
    private aTitulos := {}
    private aHeader := {}

	//aHeader possui a configuração das colunas do getDados, como: tamanho, nome, tipo, tabela, etc
	aadd(aHeader,{"Filial","E1_FILIAL"   ,"@!"  , 8,0,,"€€€€€€€€€€€€€€","C",,"R"})	
	aadd(aHeader,{"Prefixo","E1_PREFIXO"  ,"@!"  ,3,0,,"€€€€€€€€€€€€€€","C",,"R"})
	aadd(aHeader,{"Numero"    ,"E1_NUM"   ,"@!"  ,9,0,,"€€€€€€€€€€€€€€","C",,"R"})	
	aadd(aHeader,{"Parcela"    ,"E1_PARCELA"   ,"@!"  ,3,0,,"€€€€€€€€€€€€€€","C",,"R"})	
	aadd(aHeader,{"Tipo"      ,"E1_TIPO","@!"  ,3,0,,"€€€€€€€€€€€€€€","C",,"R"})
    aadd(aHeader,{"Sit.Cobranca","E1_XSTTTCB","@!"  ,10,0,,"€€€€€€€€€€€€€€","C",,"R"})
    aadd(aHeader,{"Sit. Negativ","E1_XSTNEG","@!"  ,10,0,,"€€€€€€€€€€€€€€","C",,"R"})
    aadd(aHeader,{"Situacao","E1_SITUACA","@!"  ,3,0,,"€€€€€€€€€€€€€€","C",,"R"})
    aadd(aHeader,{"Ocorr.Banco","E1_XOCORR","@!"  ,3,0,,"€€€€€€€€€€€€€€","C",,"R"})
    aadd(aHeader,{"Situacao 2","E1_SITUAC2","@!"  ,3,0,,"€€€€€€€€€€€€€€","C",,"R"})

    DEFINE MSDIALOG oDlg TITLE "Ajustes Título CR" FROM 000, 000 TO 550, 800 COLORS 0, 16777215 PIXEL

    @ 023, 050 MSGET oGetFilial VAR _cFilial SIZE 025, 010 OF oDlg COLORS 0, 16777215 F3 "SM0" PIXEL
    @ 023, 120 MSGET oGetPrefixo VAR _cPrefixo SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 170 MSGET oGetNumero VAR _cNumero SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 245 MSGET oGetParcela VAR _cParcela SIZE 017, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 290 MSGET oGetTipo VAR _cTipo SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL

    @ 023, 030 SAY oSay1 PROMPT "Filial" SIZE 012, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 100 SAY oSay2 PROMPT "Prefixo" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 150 SAY oSay4 PROMPT "Número" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 220 SAY oSay5 PROMPT "Parcela" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 275 SAY oSay6 PROMPT "Tipo" SIZE 013, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 320 BUTTON oBtnBuscar PROMPT "Buscar" SIZE 040, 015 OF oDlg Action buscaTit(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo) PIXEL
    oGetDados := MsNewGetDados():New(050,030,150,360, , , , , , ,9999, , , , oDlg, aHeader, aTitulos)

    @ 200, 030 BUTTON oBtnOcorr PROMPT "Ocorrência" SIZE 060, 015 OF oDlg Action AltOcorr(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo) PIXEL
    @ 200, 100 BUTTON oBtnCart PROMPT "Situação" SIZE 060, 015 OF oDlg Action AltCar(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo) PIXEL
    @ 200, 170 BUTTON oBtnCob PROMPT "Situação Cob" SIZE 060, 015 OF oDlg Action AltCob(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo) PIXEL
    @ 200, 240 BUTTON oBtnNeg PROMPT "Situação Neg" SIZE 060, 015 OF oDlg Action AltNeg(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo) PIXEL
    @ 200, 320 BUTTON oBtnNeg PROMPT "Sair" SIZE 040, 015 OF oDlg Action (oDlg:end()) PIXEL
    @ 220, 030 BUTTON oBtnCart2 PROMPT "Situacao 2" SIZE 060, 015 OF oDlg Action AltCar2(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo) PIXEL    
    ACTIVATE MSDIALOG oDlg CENTERED

    RestArea(aArea)

Return

// PESQUISAR FILIAL+PREFIXO+TTIULO+PARCELA+FORNECEDOR
static function buscaTit(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo)
    aTitulos := selTitulos(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo) 
    //atualiza/recarrega o oGetDados
    oGetDados:oBrowse:Refresh() 
    //atualiza/recarrega a tela                                                                                                                                
    oDlg:Refresh()   
    oGetDados := MsNewGetDados():New(050,030,150,360, , , , , , ,9999, , , , oDlg, aHeader, aTitulos)

        
return

static function selTitulos(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo)
    //este array terá o conteúdo que será apresentado ao usuário
    private aDados := {}    
    //abre a tabela SA1 (Clientes)
    dbSelectArea("SE1")           
    //configura primeiro índice (Filial + Código Cliente)
    SE1->(dbSetOrder(1))                                    
    if (DBSEEK(_cFilial + _cPrefixo + _cNumero + _cParcela + _cTipo))
    //enquanto houver cliente na tabela ou enquanto não chega ao final da tabela executa as condições abaixo
        aadd(aDados,{allTrim(SE1->E1_FILIAL), allTrim(SE1->E1_PREFIXO), allTrim(SE1->E1_NUM), allTrim(SE1->E1_PARCELA),;
			allTrim(SE1->E1_TIPO),allTrim(SE1->E1_XSTTTCB),allTrim(SE1->E1_XSTNEG),allTrim(SE1->E1_SITUACA) ,allTrim(SE1->E1_XOCORR) ,allTrim(SE1->E1_SITUAC2),.F.})                                                  
    else
        Alert("Título não localizado, conforme chave -> " + _cFilial+"-"+_cPrefixo+"-"+_cNumero+"-"+_cParcela, "Alteração titulo CR" )
    endIf          
//retorna a tabela atualizada

return aDados

STATIC FUNCTION AltOcorr(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo)

    LOCAL oDlgOcorr, oComboOcorr,oBtnAlterar, cCurrentOcorr
    LOCAL nComboOcorr := 1
     
    if (DBSEEK(_cFilial + _cPrefixo + _cNumero + _cParcela + _cTipo))
            cCurrentOcorr := allTrim(SE1->E1_XOCORR) 
    ENDIF

    DEFINE MSDIALOG oDlgOcorr TITLE "Alterar Ocorrência" FROM 100, 100 TO 300, 400 COLORS 0, 16777215 PIXEL

    @ 030, 060 SAY oSayCurrentOcorr PROMPT "Valor Atual:" + cCurrentOcorr SIZE 040, 020 OF oDlgOcorr COLORS 0, 16777215 PIXEL
    @ 040, 050 MSCOMBOBOX oComboOcorr VAR nComboOcorr ITEMS {" ","1 - Boleto Não Gerado","2 - Boleto Não Registrado","3 - Remessa Enviada","4 - Registrado","5 - Rejeitado","6 - Baixado","7 - Baixado Liq","8 - Integração"} SIZE 072, 010 OF oDlgOcorr COLORS 0, 16777215 PIXEL
    @ 070, 050 BUTTON oBtnAlterar PROMPT "Alterar" SIZE 060, 020 OF oDlgOcorr ACTION grvSe1(nComboOcorr, 1,@oDlgOcorr) PIXEL

    // Activate the new MSDIALOG
    ACTIVATE MSDIALOG oDlgOcorr CENTERED

RETURN

STATIC FUNCTION AltCar(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo)

    LOCAL oDlgSit, oComboSit,oBtnAlterar, cCurrentSit
    LOCAL nComboOcSit := 1
     
    if (DBSEEK(_cFilial + _cPrefixo + _cNumero + _cParcela + _cTipo))
            cCurrentSit := allTrim(SE1->E1_SITUACA) 
    ENDIF

    DEFINE MSDIALOG oDlgSit TITLE "Alterar Situacao" FROM 100, 100 TO 300, 400 COLORS 0, 16777215 PIXEL

    @ 030, 060 SAY oSayCurrentSit PROMPT "Valor Atual:" + cCurrentSit SIZE 040, 020 OF oDlgSit COLORS 0, 16777215 PIXEL
    @ 040, 050 MSCOMBOBOX oComboSit VAR nComboOcSit ITEMS {" ","0 - CARTEIRA","1 - COB.SIMPLES","2 - DESCONTADA","3 - CAUCIONADA","4 - VINCULADA","5 - ADVOGADO","6 - JUDICIAL"} SIZE 072, 010 OF oDlgSit COLORS 0, 16777215 PIXEL
    @ 070, 050 BUTTON oBtnAlterar PROMPT "Alterar" SIZE 060, 020 OF oDlgSit ACTION grvSe1(nComboOcSit, 2,@oDlgSit) PIXEL
      
    // Activate the new MSDIALOG
    ACTIVATE MSDIALOG oDlgSit CENTERED

RETURN

STATIC FUNCTION AltCar2(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo)

    LOCAL oDlgSit2, oComboSit2,oBtnAlterar2, cCurrentSit2
    LOCAL nComboOcSit2 := 1
     
    if (DBSEEK(_cFilial + _cPrefixo + _cNumero + _cParcela + _cTipo))
            cCurrentSit := allTrim(SE1->E1_SITUAC2) 
    ENDIF

    DEFINE MSDIALOG oDlgSit2 TITLE "Alterar Situacao2" FROM 100, 100 TO 300, 400 COLORS 0, 16777215 PIXEL

    @ 030, 060 SAY oSayCurrentSit2 PROMPT "Valor Atual:" + cCurrentSit2 SIZE 040, 020 OF oDlgSit2 COLORS 0, 16777215 PIXEL
    @ 040, 050 MSCOMBOBOX oComboSit2 VAR nComboOcSit2 ITEMS {" ","0 - CARTEIRA","1 - COB.SIMPLES","2 - DESCONTADA","3 - CAUCIONADA","4 - VINCULADA","5 - ADVOGADO","6 - JUDICIAL"} SIZE 072, 010 OF oDlgSit2 COLORS 0, 16777215 PIXEL
    @ 070, 050 BUTTON oBtnAlterar2 PROMPT "Alterar" SIZE 060, 020 OF oDlgSit2 ACTION grvSe1(nComboOcSit2, 2,@oDlgSit2) PIXEL
     
    // Activate the new MSDIALOG
    ACTIVATE MSDIALOG oDlgSit2 CENTERED

RETURN

STATIC FUNCTION AltCob(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo)

    LOCAL oDlgCob, oComboCob,oBtnAlterar, cCurrentCob
    LOCAL nComboCob := 1
     
    if (DBSEEK(_cFilial + _cPrefixo + _cNumero + _cParcela + _cTipo))
            cCurrentCob := allTrim(SE1->E1_XSTTTCB) 
    ENDIF

    DEFINE MSDIALOG oDlgCob TITLE "Alterar Situacao" FROM 100, 100 TO 300, 400 COLORS 0, 16777215 PIXEL

    @ 030, 060 SAY oSayCurrentCob PROMPT "Valor Atual:" + cCurrentCob SIZE 040, 020 OF oDlgCob COLORS 0, 16777215 PIXEL
    @ 040, 050 MSCOMBOBOX oComboCob VAR nComboCob ITEMS {" ","0 - SEMSTA","1 - ENV.APR","2 - APR","3 - RECUS","4 - RENE","7 - ENV.COB","9 - INCON",;
        "12 - SEMEXIT","13 - LIB.REC.MAN","14 - BX.EMP.COB","15 - BXCON","16 - SOL.CAN","17 - SOL.AUT"} ;
            SIZE 072, 010 OF oDlgCob COLORS 0, 16777215 PIXEL
    @ 070, 050 BUTTON oBtnAlterar PROMPT "Alterar" SIZE 060, 020 OF oDlgCob ACTION grvSe1(nComboCob, 3, @oDlgCob) PIXEL
    
    // Activate the new MSDIALOG
    ACTIVATE MSDIALOG oDlgCob CENTERED

RETURN

STATIC FUNCTION AltNeg(_cFilial, _cPrefixo, _cNumero, _cParcela, _cTipo)
    LOCAL oDlgNeg, oComboNeg,oBtnAlterar, cCurrentNeg
    LOCAL nComboNeg := 1
     
    if (DBSEEK(_cFilial + _cPrefixo + _cNumero + _cParcela + _cTipo))
            cCurrentNeg := allTrim(SE1->E1_XSTNEG) 
    ENDIF

    DEFINE MSDIALOG oDlgNeg TITLE "Alterar Situacao" FROM 100, 100 TO 300, 400 COLORS 0, 16777215 PIXEL

    @ 030, 060 SAY oSayCurrentNeg PROMPT "Valor Atual:" + cCurrentNeg SIZE 040, 020 OF oDlgNeg COLORS 0, 16777215 PIXEL
    @ 040, 050 MSCOMBOBOX oComboNeg VAR nComboNeg ITEMS {" ","0 - NAO PROCESSADO","1 - REMESSA ENVIO","2 - REMESSA BAIXA","3 - RETORNO INCLUSAO",;
        "4 - RETORNO REJEITADO","5 - RETORNO BAIXA","6 - INTEGRACAO","7 - RET INFOR"};
             SIZE 072, 010 OF oDlgNeg COLORS 0, 16777215 PIXEL
    @ 070, 050 BUTTON oBtnAlterar PROMPT "Alterar" SIZE 060, 020 OF oDlgNeg ACTION grvSe1(nComboNeg, 4,@oDlgNeg) PIXEL
    // Activate the new MSDIALOG
    ACTIVATE MSDIALOG oDlgNeg CENTERED

RETURN



STATIC FUNCTION grvSe1(nValor, nopcao, oDlg)

    LOCAL _nValor := nValor
    Local _nopcao := nopcao

    if(VALTYPE( _nValor ) == "N")
        _nValor := cValToChar(_nValor)
    EndIF 

    _nValor := ALLTRIM(Left(_nValor,AT( " ", _nValor )))

    DBSELECTAREA("SE1")
	DBSETORDER(1)
    DBSEEK(_cFilial + _cPrefixo + _cNumero + _cParcela + _cTipo)
    RECLOCK("SE1", .F.)
        if _nopcao == 1
            SE1->E1_XOCORR := _nValor
            FWAlertSuccess("Ocorrencia alterada com sucesso!","Fim")
        elseif _nopcao == 2 
            SE1->E1_SITUACA := _nValor
            FWAlertSuccess("Situação alterada com sucesso!","Fim")
        elseif _nopcao == 3 
            SE1->E1_XSTTTCB := _nValor
            //SE1->E1_FSENVCB := CTOD("")
            //SE1->E1_FSHORCB := ""
            FWAlertSuccess("Sit. Cobrança alterada com sucesso!","Fim")
        elseif _nopcao == 4 
            SE1->E1_XSTNEG := _nValor
            FWAlertSuccess("Sit. Negativação alterada com sucesso!","Fim")
        elseif _nopcao == 5 
            SE1->E1_SITUAC2 := _nValor
            FWAlertSuccess("Sit. Negativação alterada com sucesso!","Fim")
        endif     
    SE1->(MsUnlock())
    oDlg:End()

RETURN
