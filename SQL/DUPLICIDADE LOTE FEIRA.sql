SELECT E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DTDISPO,E5_LOTE, COUNT(*)
FROM
         SE5070
WHERE
         E5_FILIAL BETWEEN '15' AND '15'
		 and E5_HISTOR LIKE 'Baixa por Retorno CNAB / Lote :%'
         AND D_E_L_E_T_ <> '*'
         AND E5_SITUACA <> 'C'
         AND E5_NUMCHEQ <> '%*'
         AND E5_VENCTO  <= E5_DATA
         AND E5_DTDISPO BETWEEN '20221201' AND '20221231'
         AND E5_BANCO BETWEEN '   ' AND 'zzz'
         AND E5_BANCO <> '   '
         AND E5_NATUREZ BETWEEN '310108001 ' AND '310108001 '
         AND E5_DTDIGIT BETWEEN '20000101' AND '20221231'
         AND E5_TIPODOC NOT IN ('DC'
                              ,'JR'
                              ,'MT'
                              ,'BA'
                              ,'MT'
                              ,'CM'
                              ,'D2'
                              ,'J2'
                              ,'M2'
                              ,'C2'
                              ,'V2'
                              ,'CX'
                              ,'CP'
                              ,'TL')
         AND E5_PREFIXO NOT IN ('U  '
                              ,'U1 '
                              ,'10'
                              ,'20')
GROUP BY E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DTDISPO,E5_LOTE
HAVING COUNT(*) > 1
ORDER BY E5_LOTE

SELECT SUM(E5_VALOR) FROM SE5070 
WHERE E5_BANCO='001'
AND E5_AGENCIA='3429'
AND E5_CONTA ='7462' 
AND E5_DTDISPO= '20221107' AND E5_LOTE='00010554'
AND E5_TIPO = ''

SELECT R_E_C_N_O_,* FROM SE5070 
WHERE E5_BANCO='001'
AND E5_AGENCIA='3429'
AND E5_CONTA ='7462' 
AND E5_DTDISPO= '20221107' AND E5_LOTE='00010554'
AND E5_TIPO = ''


UPDATE SE5070
SET E5_VALOR = '10480.93'
WHERE R_E_C_N_O_ = '414221'


UPDATE SE5070
SET D_E_L_E_T_ = '*'
WHERE R_E_C_N_O_ IN(
'414222'
)