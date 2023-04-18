#INCLUDE "RWMAKE.CH"
#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F090SE5  ºAutor  Pablo Leite          º Data ³  28/10/22   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criado para garantir gravacao correta dos dados bancarios  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GTI22025467                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F090SE5()

	Local a_Area 	:= GetArea()
	Local _cBco		:= ""
	Local _cAgenc	:= ""
	Local _cCta		:= ""
	Local aRecno 	:= ParamIxb[1]
	Local nCntFor 	:= 0

	// Posicionar na tabela se5
	dbSelectArea("SE5")
	DbSetOrder(1)
	For nCntFor := 1 to Len(aRecno)

		// Posicionar na tabela conta a pagar
		DbSelectArea("SE2")
		DbSetOrder(1)
		If DbSeek(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) )

			// Posicionar na tabela de borderos
			DbSelectArea("SEA")
			DbSetOrder(4)
			If DbSeek(SE2->(E2_FILIAL+E2_NUMBOR+"P"+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
				_cBco   := SEA->EA_PORTADO
				_cAgenc := SEA->EA_AGEDEP
				_cCta   := SEA->EA_NUMCON
			EndIf

			// Corrige as informações bancárias
			DbSelectArea("SE5")
			RecLock("SE5",.F.)
			SE5->E5_BANCO 	:= _cBco
			SE5->E5_AGENCIA := _cAgenc
			SE5->E5_CONTA 	:= _cCta
			MsUnLock()

			// Reprocessa saldo na conta correta
			AtuSalBco(_cBco,_cAgenc,_cCta,dDataBase,nValPgto,"+")

		ENDIF

	Next nCntFor

	RestArea(a_Area)

Return
