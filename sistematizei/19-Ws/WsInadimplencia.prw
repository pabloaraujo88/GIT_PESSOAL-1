#Include 'Protheus.ch'
#Include 'APWEBSRV.CH'
#Include 'TOPCONN.CH'

WSSTRUCT STInadimplencia
    /*
    WSDATA  produtoB1COD    AS STRING OPTIONAL
    WSDATA  produtoB1DESC   AS STRING OPTIONAL
    WSDATA  produtoB1UM     AS STRING OPTIONAL
    WSDATA  produtoB1TIPO   AS STRING OPTIONAL
    WSDATA  produtoB1POSIPI AS STRING OPTIONAL
    WSDATA  produtoB1GRUPO  AS STRING OPTIONAL
    */
ENDWSSTRUCT

WSSTRUCT StRetMsgInadimplencia   
    WSDATA cRet         AS STRING OPTIONAL
    WSDATA cMessage     AS STRING OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRetornoInadimplencia
    WSDATA WsBuscaInadimp  AS STInadimplencia
    WSDATA WsRetMsg        AS StRetMsgInadimplencia
ENDWSSTRUCT

WSSERVICE WSINADIMP DESCRIPTION "retorna dados de inadimplencia" 

    //Parametro ode Entrada
    WSDATA CGC AS STRING

    //Parametro de retorno atraves desde dado, ele acessará a classe de dados Stretornogeral
    WSDATA WsRetornoGeral AS STRetornoInadimplencia

    //metodo
    WSMETHOD BuscaInadimplencia DESCRIPTION "lista dados de inadimplencia"
    

ENDWSSERVICE

WSMETHOD BuscaInadimplencia WSRECEIVE CGC WSSEND WsRetornoGeral WSSERVICE WSINADIMP

Local cCgc   := :: CGC

