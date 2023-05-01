
SELECT dEmissao,
       MAX(EMITIDO) AS EMITIDO,
       MAX(RECEBIDO) AS RECEBIDO,
       MAX(VENCIDO) AS VENCIDO,
       MAX(VENCER) AS VENCER
FROM
  (SELECT dEmissao,
          EMITIDO= (CASE TIPO
                        WHEN 'EMITIDO' THEN TOTAL
                        ELSE 0
                    END),
          VENCIDO= (CASE TIPO
                        WHEN 'VENCIDO' THEN TOTAL
                        ELSE 0
                    END),
          RECEBIDO= (CASE TIPO
                         WHEN 'RECEBIDO' THEN TOTAL
                         ELSE 0
                     END),
          VENCER= (CASE TIPO
                       WHEN 'VENCER' THEN TOTAL
                       ELSE 0
                   END)
   FROM
     (/*EMITIDO*/ SELECT convert(char(10), convert(datetime, E1_EMISSAO, 103), 103) dEmissao,
                         SUM(E1_VALOR) AS TOTAL,
                         'EMITIDO' AS TIPO
      FROM SE1020 SE1 (NOLOCK)
      LEFT JOIN BA3020 BA3 (NOLOCK) ON (BA3_CODEMP = E1_CODEMP
                                        AND BA3_MATRIC = E1_MATRIC
                                        AND BA3_CODINT = E1_CODINT)
      LEFT JOIN BDC020 BDC (NOLOCK) ON (E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO
                                        AND BDC.D_E_L_E_T_ <> '*')
      WHERE BDC_ANOINI = '2022'
        AND BDC_ANOFIM = '2022'
        AND BDC_MESINI = '06'
        AND BDC_MESFIM = '06'
        AND BDC_GRPCOB BETWEEN '0004  ' AND '0099  '
        AND E1_FILIAL = '01'
        AND E1_PREFIXO IN ('11',
                           'UNI')
        AND E1_TIPO NOT IN ('IS')
        AND E1_CODEMP = '0002'
        AND SUBSTRING(E1_ORIGEM, 1, 3) = 'PLS'
        AND SE1.D_E_L_E_T_ = ' '
        AND (BA3.D_E_L_E_T_ <> '*'
             OR BA3.D_E_L_E_T_ IS NULL)
      GROUP BY E1_EMISSAO
      UNION /*vRecebido*/ SELECT convert(char(10), convert(datetime, E1_EMISSAO, 103), 103) dEmissao,
                                 SUM(E1_VALOR) AS TOTAL,
                                 'RECEBIDO' AS TIPO
      FROM SE1020 SE1 (NOLOCK)
      LEFT JOIN BA3020 BA3 (NOLOCK) ON (BA3_CODEMP = E1_CODEMP
                                        AND BA3_MATRIC = E1_MATRIC
                                        AND BA3_CODINT = E1_CODINT)
      LEFT JOIN BDC020 BDC (NOLOCK) ON (E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO
                                        AND BDC.D_E_L_E_T_ <> '*')
      WHERE E1_FILIAL = '01'
        AND E1_PREFIXO IN ('11',
                           'UNI')
        AND E1_BAIXA BETWEEN '20220601' AND '20220630'
        AND E1_EMISSAO BETWEEN '20220601' AND '20220630'
        AND E1_TIPO NOT IN ('IS')
        AND E1_CODEMP = '0002'
        AND E1_SALDO = '0'
        AND SUBSTRING(E1_ORIGEM, 1, 3) = 'PLS'
        AND SE1.D_E_L_E_T_ = ' '
        AND (BA3.D_E_L_E_T_ <> '*'
             OR BA3.D_E_L_E_T_ IS NULL)
        AND BDC_GRPCOB BETWEEN '0004' AND'9999'
      GROUP BY E1_EMISSAO
      UNION /*vVencido*/ SELECT convert(char(10), convert(datetime, E1_EMISSAO, 103), 103) dEmissao,
                                SUM(E1_VALOR) AS TOTAL,
                                'VENCIDO' AS TIPO
      FROM SE1020 SE1 (NOLOCK)
      LEFT JOIN BA3020 BA3 (NOLOCK) ON (BA3_CODEMP = E1_CODEMP
                                        AND BA3_MATRIC = E1_MATRIC
                                        AND BA3_CODINT = E1_CODINT)
      LEFT JOIN BDC020 BDC (NOLOCK) ON (E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO
                                        AND BDC.D_E_L_E_T_ <> '*')
      WHERE E1_FILIAL = '01'
        AND E1_PREFIXO IN ('11',
                           'UNI')
        AND E1_VENCORI BETWEEN '20220601' AND '20220630'
        AND E1_EMISSAO BETWEEN '20220601' AND '20220630'
        AND E1_SALDO > 0
        AND E1_TIPO NOT IN ('IS')
        AND E1_CODEMP = '0002'
        AND SUBSTRING(E1_ORIGEM, 1, 3) = 'PLS'
        AND SE1.D_E_L_E_T_ = ' '
        AND (BA3.D_E_L_E_T_ <> '*'
             OR BA3.D_E_L_E_T_ IS NULL)
        AND BDC_GRPCOB BETWEEN '0004' AND'9999'
      GROUP BY E1_EMISSAO
      UNION /*vVencER*/ SELECT convert(char(10), convert(datetime, E1_EMISSAO, 103), 103) dEmissao,
                               SUM(E1_VALOR) AS TOTAL,
                               'VENCER' AS TIPO
      FROM SE1020 SE1 (NOLOCK)
      LEFT JOIN BA3020 BA3 (NOLOCK) ON (BA3_CODEMP = E1_CODEMP
                                        AND BA3_MATRIC = E1_MATRIC
                                        AND BA3_CODINT = E1_CODINT)
      LEFT JOIN BDC020 BDC (NOLOCK) ON (E1_PLNUCOB = BDC_CODOPE+BDC_NUMERO
                                        AND BDC.D_E_L_E_T_ <> '*')
      WHERE E1_FILIAL = '01'
        AND E1_PREFIXO IN ('11',
                           'UNI')
        AND E1_BAIXA > '20220630'
        AND E1_EMISSAO BETWEEN '20220601' AND '20220630'
        AND E1_TIPO NOT IN ('IS')
        AND E1_CODEMP = '0002'
        AND SUBSTRING(E1_ORIGEM, 1, 3) = 'PLS'
        AND SE1.D_E_L_E_T_ = ' '
        AND (BA3.D_E_L_E_T_ <> '*'
             OR BA3.D_E_L_E_T_ IS NULL)
        AND BDC_GRPCOB BETWEEN '0004' AND'9999'
      GROUP BY E1_EMISSAO) AS TABELA) AS TABELA2
GROUP BY dEmissao