#include "Protheus.ch"
#include "APWEBSRV.ch" //Include principal dos WebServices
#include "TOPCONN.ch"


/*Estrutura de dados que será retornada pelo WebService na chamada pelo CLIENT*/
WSSTRUCT STCliente

    WSDATA clienteA1COD         AS STRING OPTIONAL
    WSDATA clienteA1LOJA        AS STRING OPTIONAL
    WSDATA clienteA1NOME        AS STRING OPTIONAL
    WSDATA clienteA1CGC         AS STRING OPTIONAL
    WSDATA clienteA1EST         AS STRING OPTIONAL
    WSDATA clienteA1MUN         AS STRING OPTIONAL
    WSDATA clienteA1END         AS STRING OPTIONAL
    WSDATA clienteA1BAIRRO      AS STRING OPTIONAL
    WSDATA clienteA1CEP         AS STRING OPTIONAL

ENDWSSTRUCT

//Estrutura de retorno sucesso/sem sucesso
WSSTRUCT STRetMsg
    WSDATA cRet                 AS STRING OPTIONAL
    WSDATA cMessage             AS STRING OPTIONAL
ENDWSSTRUCT

//REtorno do WebService
WSSTRUCT STRetornoGeral
    WSDATA WSSTClient   AS STCliente
    WSDATA WsSTRetMsg   AS STRetMsg
ENDWSSTRUCT


          //ESSE NOME AQUI APARECE NA LISTA DE WS DISPONIVEIS NA ENTRADA DO WS COM A DESCRIÇÃO.  
WSSERVICE WSCLISA1 DESCRIPTION "Serviço para retornar os dados de cliente específico"
    //REQUISICAO DO SOAP
    WSDATA  _cCodClienteLoja    AS STRING

    WSDATA WSRetornoGeral       AS STRetornoGeral
             //NOME DO METODO   //ESSA DESCRIÇÃO AQUI ESTÁ AO ACESSAR O WS DESCRICAO DO MÉTODO
    WSMETHOD BuscaCliente       DESCRIPTION "Busca Clientes na tabela SA1 com base no codigo e loja"

ENDWSSERVICE

//          MÉTODO          PARAMETRO DE ENTRADA        RETORNO DO WS          WS A QUAL PERTENCE
WSMETHOD    BuscaCliente    WSRECEIVE _cCodClienteLoja  WSSEND  WSRetornoGeral WSSERVICE WSCLISA1
Local cCliCodLoja  := ::_cCodClienteLoja

DBSELECTAREA("SA1")
SA1->(DBSETORDER(1))

IF SA1->(DbSeek(xFilial("SA1")+cCliCodLoja))
        ::WsRetornoGeral:WsSTRetMsg:cRet                    := "[T]"
        ::WsRetornoGeral:WsSTRetMsg:cMessage                := "Sucesso! Registro encontrado, dados listados."
        ::WSRetornoGeral:WSSTClient:clienteA1COD            := SA1->A1_COD
        ::WSRetornoGeral:WSSTClient:clienteA1LOJA           := SA1->A1_LOJA
        ::WSRetornoGeral:WSSTClient:clienteA1NOME           := SA1->A1_NOME
        ::WSRetornoGeral:WSSTClient:clienteA1CGC            := SA1->A1_CGC
        ::WSRetornoGeral:WSSTClient:clienteA1EST            := SA1->A1_EST
        ::WSRetornoGeral:WSSTClient:clienteA1MUN            := SA1->A1_MUN
        ::WSRetornoGeral:WSSTClient:clienteA1BAIRRO         := SA1->A1_BAIRRO
        ::WSRetornoGeral:WSSTClient:clienteA1CEP            := SA1->A1_CEP
ELSE 
    ::WsRetornoGeral:WsSTRetMsg:cRet                := "[F]"
    ::WsRetornoGeral:WsSTRetMsg:cMessage            := "Falha! Não existe registro relacionado à esta entrada(Código + Loja) " + cCliCodLoja + " "

ENDIF

    SA1->(DBCLOSEAREA())

RETURN .T.

 
