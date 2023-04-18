#Include 'Protheus.ch'
#Include 'APWEBSRV.CH'
#Include 'TOPCONN.CH'


//CODIGO, CODIGO, UNIDADE, TIPO, NCM E GRUPO;

WSSTRUCT STProduto
    WSDATA  produtoB1COD    AS STRING OPTIONAL
    WSDATA  produtoB1DESC   AS STRING OPTIONAL
    WSDATA  produtoB1UM     AS STRING OPTIONAL
    WSDATA  produtoB1TIPO   AS STRING OPTIONAL
    WSDATA  produtoB1POSIPI AS STRING OPTIONAL
    WSDATA  produtoB1GRUPO  AS STRING OPTIONAL
ENDWSSTRUCT

//Estrutura de Dados para retorno de mensagem
WSSTRUCT StRetMsgProd    
    WSDATA cRet         AS STRING OPTIONAL
    WSDATA cMessage     AS STRING OPTIONAL
ENDWSSTRUCT

//Classe de dados para retorno geral, aqui será uma ponte para as duas classes/estrutura acima
WSSTRUCT STRetornoProduto
    WSDATA WsBuscaProd  AS StProduto
    WSDATA WsRetMsg     AS StRetMsgProd
ENDWSSTRUCT


WSSERVICE WSPRODSB1 DESCRIPTION "Service para retornar dados de um produto" 

    //Parametro ode Entrada
    WSDATA _cCodProduto AS STRING

    //Parametro de retorno atraves desde dado, ele acessará a classe de dados Stretornogeral
    WSDATA WsRetornoGeral AS STRetornoProduto

    //metodo
    WSMETHOD BuscaProduto DESCRIPTION "lista dados do Produto"
    

ENDWSSERVICE

WSMETHOD BuscaProduto WSRECEIVE _cCodProduto WSSEND WsRetornoGeral WSSERVICE WSPRODSB1

Local cCodProduto   := ::_cCodProduto

DBSELECTAREA("SB1")
SB1->(DBSETORDER(1))
Local cGrupo :=SB1->B1_GRUPO
Local cDescGrupo := ""

if SB1->(DBSEEK( XFILIAL("SB1")+cCodProduto))
        cDescGrupo := POSICIONE("SBM", 1, XFILIAL("SBM")+cGrupo, "BM_DESC" )
        ::WsRetornoGeral:WsRetMsg:cRet                  := "[T]"
        ::WsRetornoGeral:WsRetMsg:cMessage              := "Sucesso! Produto encontrado"
        
        ::WsRetornoGeral:WsBuscaProd:produtoB1COD       :=  SB1->B1_COD
        ::WsRetornoGeral:WsBuscaProd:produtoB1DESC      :=  SB1->B1_DESC
        ::WsRetornoGeral:WsBuscaProd:produtoB1UM        :=  SB1->B1_UM
        ::WsRetornoGeral:WsBuscaProd:produtoB1TIPO      :=  SB1->B1_TIPO
        ::WsRetornoGeral:WsBuscaProd:produtoB1POSIPI    :=  SB1->B1_POSIPI
        ::WsRetornoGeral:WsBuscaProd:produtoB1GRUPO     :=  cDescGrupo

ELSE
        ::WsRetornoGeral:WsRetMsg:cRet                  := "[F]"
        ::WsRetornoGeral:WsRetMsg:cMessage              := "Produto não encontrado"    
ENDIF

SB1->(DBCLOSEAREA())

return .T.




