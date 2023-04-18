/* Beneficiários POR PRODUTO NA DATA BASE */

SELECT BI3_SUSEP, COUNT(BA1.R_E_C_N_O_)
FROM   BI3020 BI3
       INNER JOIN BA1020 BA1
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BI3_CODINT + BI3_CODIGO + BI3_VERSAO =
                        BA1_CODINT + BA1_CODPLA + BA1_VERSAO )
WHERE  BI3.D_E_L_E_T_ = ''
       AND BI3_CODINT = '0001'
       AND BI3_SUSEP <> '' 
	   AND BA1_DATCON <= '20220131'
	   AND (BA1_DATBLO >='20220201' OR BA1_DATBLO = '')
GROUP BY BI3_SUSEP

/* RECEITA X SUSEP POR MES */



SELECT BI3_SUSEP, BM1_MES,
       SUM(BM1_VALOR)
FROM   BI3020 BI3
       INNER JOIN BA1020 BA1
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BI3_CODINT + BI3_CODIGO + BI3_VERSAO =
                        BA1_CODINT + BA1_CODPLA + BA1_VERSAO )
       INNER JOIN BM1020 BM1
               ON ( BM1.D_E_L_E_T_ = ''
                    AND BM1_MATUSU = BA1_CODINT + BA1_CODEMP + BA1_MATRIC +
                                     BA1_TIPREG
                                     + BA1_DIGITO )
WHERE  BI3.D_E_L_E_T_ = ''
       AND BI3_CODINT = '0001'
       AND BI3_SUSEP <> ''
	   --AND BM1_CODTIP = '101'
	   AND BM1_CODTIP IN ('116','141') 
	   AND BM1_ANO = '2022'
GROUP  BY BI3_SUSEP , BM1_MES
ORDER BY BM1_MES

/* RECEITA X SUSEP POR ANO */



SELECT BI3_SUSEP, BM1_ANO,
       SUM(BM1_VALOR)
FROM   BI3020 BI3
       INNER JOIN BA1020 BA1
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BI3_CODINT + BI3_CODIGO + BI3_VERSAO =
                        BA1_CODINT + BA1_CODPLA + BA1_VERSAO )
       INNER JOIN BM1020 BM1
               ON ( BM1.D_E_L_E_T_ = ''
                    AND BM1_MATUSU = BA1_CODINT + BA1_CODEMP + BA1_MATRIC +
                                     BA1_TIPREG
                                     + BA1_DIGITO )
WHERE  BI3.D_E_L_E_T_ = ''
       AND BI3_CODINT = '0001'
       AND BI3_SUSEP <> ''
	   AND BM1_CODTIP = '101'
	  -- AND BM1_CODTIP IN ('116','141') 
GROUP  BY BI3_SUSEP , BM1_ANO
ORDER BY BI3_SUSEP,BM1_ANO


/* DESPESAS ASSISTENCIAIS POR MES */ 

SELECT SUM(BD5_VLRPAG),
       BD5_MESPAG,
       BI3_SUSEP
FROM   BD5020 BD5
       INNER JOIN BA1020 BA1
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BD5_CODOPE + BD5_CODEMP + BD5_MATRIC + BD5_TIPREG =
                        BA1_CODINT + BA1_CODEMP + BA1_MATRIC + BA1_TIPREG )
       INNER JOIN BI3020 BI3
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BI3_CODINT + BI3_CODIGO + BI3_VERSAO =
                        BA1_CODINT + BA1_CODPLA + BA1_VERSAO )
WHERE  BD5_ANOPAG = '2022'
       AND BD5_CODOPE = '0001'
       AND BD5.D_E_L_E_T_ = ''
       AND BD5_FASE = '4'
GROUP  BY BD5_MESPAG,
          BI3_SUSEP
ORDER  BY BI3_SUSEP,BD5_MESPAG 


SELECT SUM(BD5_VLRPAG),
       BD5_ANOPAG,
       BI3_SUSEP
FROM   BD5020 BD5
       INNER JOIN BA1020 BA1
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BD5_CODOPE + BD5_CODEMP + BD5_MATRIC + BD5_TIPREG =
                        BA1_CODINT + BA1_CODEMP + BA1_MATRIC + BA1_TIPREG )
       INNER JOIN BI3020 BI3
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BI3_CODINT + BI3_CODIGO + BI3_VERSAO =
                        BA1_CODINT + BA1_CODPLA + BA1_VERSAO )
WHERE  BD5_CODOPE = '0001'
       AND BD5.D_E_L_E_T_ = ''
       AND BD5_FASE = '4'
GROUP  BY BD5_ANOPAG,
          BI3_SUSEP
ORDER  BY BI3_SUSEP,BD5_ANOPAG 


SELECT COUNT(BA1_CODINT + BA1_CODEMP + BA1_MATRIC + BA1_TIPREG),
       BD5_ANOPAG,
       BI3_SUSEP
FROM   BD5020 BD5
       INNER JOIN BA1020 BA1
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BD5_CODOPE + BD5_CODEMP + BD5_MATRIC + BD5_TIPREG =
                        BA1_CODINT + BA1_CODEMP + BA1_MATRIC + BA1_TIPREG )
       INNER JOIN BI3020 BI3
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BI3_CODINT + BI3_CODIGO + BI3_VERSAO =
                        BA1_CODINT + BA1_CODPLA + BA1_VERSAO )
WHERE  BD5_CODOPE = '0001'
       AND BD5.D_E_L_E_T_ = ''
       AND BD5_FASE = '4'



/* UTILIZAÇÃO */
SELECT BI3_SUSEP, COUNT(BA1.R_E_C_N_O_)
	  FROM   BI3020 BI3
       INNER JOIN BA1020 BA1
               ON ( BA1.D_E_L_E_T_ = ''
                    AND BI3_CODINT + BI3_CODIGO + BI3_VERSAO =
                        BA1_CODINT + BA1_CODPLA + BA1_VERSAO )
WHERE  BI3.D_E_L_E_T_ = ''
       AND BI3_CODINT = '0001'
       AND BI3_SUSEP <> '' 
	   AND BA1_CODINT + BA1_CODEMP + BA1_MATRIC + BA1_TIPREG IN (
	   SELECT DISTINCT BD5_CODOPE + BD5_CODEMP + BD5_MATRIC + BD5_TIPREG FROM BD5020
	   WHERE D_E_L_E_T_ = ''
	   AND BD5_FASE = '4'
	   AND BD5_ANOPAG = '2018')
GROUP BY BI3_SUSEP


