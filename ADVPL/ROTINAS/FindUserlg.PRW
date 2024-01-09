#include "rwmake.ch"
#include "topconn.ch" 
#include "report.ch"
#include "Protheus.ch"

 /*/{Protheus.doc} FindUserlg
    
    Criado para alimentar o campo E2_USERI  
    @type  Function
    @author Pablo Leite
    @since 05/09/2023
/*/
User Function FindUserlg()

Local nRet      := ""

    If (Len(FWLeUserlg("E2_USERLGI", 1)) > 0)

        nRet :=  FWLeUserlg("E2_USERLGI", 1)
    Else 
        If ( AllTrim(SE2->E2_PREFIXO) == 'TRF' .AND. AllTrim(SE2->E2_TIPO) == 'TB' )
            nRet := "RPA TRANSBAN"
        Else
            nRet := "INTEGRACAO"
        EndIf
    EndIf
                                                   
    
Return nRet
