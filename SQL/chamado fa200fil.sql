/*Na tabela FI0, existe o campo: FI0_LASTLN, onde informa qual foi a última linha 
processada do arquivo de retorno. Quando este campo está preenchido com a quantidade total 
de linhas referente ao "detalhe" no arquivo de retorno, o sistema entende que foi processado 
todas as linhas do arquivo, então não teria o que reprocessar. A rotina somente reprocessa a 
partir do ponto que foi interrompido, por exemplo, caso o arquivo tenha 10 registros e somente 
foi processado 06 devido a uma queda de energia, ao selecionar reprocessar, será processado 
as 4 linhas restantes.



E se o título for baixado então o sistema atualiza a FI1.*/
SELECT * FROM SE5010 NOLOCK
WHERE E5_NUMERO = '000158137'
AND E5_PREFIXO = 'A'
AND D_E_L_E_T_ = ''

SELECT E1_ORIGEM, E1_FATURA,* FROM SE1010 NOLOCK
WHERE D_E_L_E_T_ = ''
AND E1_NUM IN ('000158137')
AND E1_PREFIXO = 'A'

update SE5010
set D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_
WHERE E5_NUMERO = '000158137'
AND E5_PREFIXO = 'A'
AND D_E_L_E_T_ = ''

UPDATE FK1010
SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_
WHERE D_E_L_E_T_ = ''
AND FK1_IDFK1 IN (
SELECT E5_IDORIG
FROM SE5010
WHERE E5_NUMERO = '000158137'
AND E5_PREFIXO = 'A'
AND D_E_L_E_T_ = '*')


UPDATE SE1010
SET E1_BAIXA = '', E1_SALDO = E1_VALOR, E1_VALLIQ ='', E1_MOVIMEN  = '', E1_STATUS = 'A'
WHERE D_E_L_E_T_ = ''
AND E1_NUM IN ('000158137')
AND E1_PREFIXO = 'A'
/*
FI0 - Cabeçalho do LOG de processamento 

FI1 - Detalhe do LOG de Processamento.
*/
SELECT * FROM FI0010 
WHERE FI0_ARQ = '022114.RET'

UPDATE FI0010 
SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_
WHERE FI0_IDARQ = 'A362878075'

UPDATE FI1010 
SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_
WHERE FI1_IDARQ = 'A362878075'


