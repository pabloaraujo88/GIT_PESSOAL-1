--EXEC PR_POOLDERISCO '2023-03-31';

--DROP PROCEDURE PR_POOLDERISCO;
CREATE PROCEDURE PR_POOLDERISCO(@data DATE)
AS
BEGIN

--DECLARE @data DATE = '2023-02-25';

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
    DROP TABLE #temp;

CREATE TABLE #temp (
    dat_ano_mes varchar(max),
	Vidas int,
	Despesas int,
	Receita int,
	Receita_COPA int
   

    
);

WHILE @data >= '2020-01-25'
BEGIN
	INSERT INTO #temp (dat_ano_mes,Vidas,Despesas,Receita,Receita_COPA )
	SELECT dat_ano_mes, MAX(Vidas) AS Vidas, MAX(Despesas) AS Despesas, MAX(Receita) AS Receita,MAX(Receita_COPA) AS Receita_COPA
	FROM ( 
	SELECT dat_ano_mes,                                                                                                                                
	Vidas= ( CASE tipo  WHEN 'Vidas' THEN valor ELSE 0 END ),                                                                                     
	Despesas= ( CASE tipo  WHEN 'Despesas' THEN valor ELSE 0 END ),   
	Receita_COPA= ( CASE tipo  WHEN 'Receita_COPA' THEN valor ELSE 0 END ),
	Receita= ( CASE tipo  WHEN 'Receita' THEN valor ELSE 0 END )            
	FROM (
	(
	SELECT COUNT(BA1.R_E_C_N_O_) valor ,convert(char(4), year(@data)) + '/'+ convert(char(2), month(@data)) as dat_ano_mes, 'Vidas' as tipo
	FROM BA1020 BA1 INNER JOIN BQC020 BQC ON (BQC_NUMCON = BA1_CONEMP AND BQC_SUBCON = BA1_SUBCON  AND BQC.D_E_L_E_T_='')
	WHERE BA1.D_E_L_E_T_ = ''
	AND BQC_CIE309 = 'S'
	AND BA1_CODEMP = '0002'
	AND BA1_DATINC <= REPLACE(@data, '-', '')
	AND (BA1_DATBLO = '' OR BA1_DATINC >=REPLACE(@data, '-', ''))
	
	UNION

	SELECT sum(BD6_VLRPAG),  convert(char(4), year(@data)) + '/'+ convert(char(2), month(@data)) as dat_ano_mes, 'Despesas' as tipo
	FROM BD6020   BD6 INNER JOIN BQC020 BQC ON (BQC_NUMCON = BD6_CONEMP AND BQC_SUBCON = BD6_SUBCON  AND BQC.D_E_L_E_T_='')
	 WHERE  
	 BD6_OPEUSR = '0001' 
	 AND BQC_CIE309 = 'S'
	 AND BD6_CODEMP = '0002' 
	 AND BD6.D_E_L_E_T_ = '' 
	 and BD6_FASE = '4' 
	 AND BD6_VLRPAG > '0' 
	 AND BD6_ANOPAG = convert(char(4), year(@data))
	 AND BD6_MESPAG = SUBSTRING(REPLACE(@data, '-', ''),5,2)
	 AND BD6_BLOPAG <> '1'
	
	UNION

	SELECT SUM(BM1_VALOR), convert(char(4), year(@data)) + '/'+ convert(char(2), month(@data)) as dat_ano_mes, 'Receita_COPA' as tipo
	FROM  BM1020 BM1 INNER JOIN BQC020 BQC ON (BQC_NUMCON = BM1_CONEMP AND BQC_SUBCON = BM1_SUBCON  AND BQC.D_E_L_E_T_='')
	WHERE  BM1.D_E_L_E_T_ = ''
	 AND BM1_CODINT = '0001'
	 AND BM1_CODTIP IN ('116','141') 
	 AND  BM1_ANO = convert(char(4), year(@data))
	 AND BM1_MES = SUBSTRING(REPLACE(@data, '-', ''),5,2) 

	UNION

	SELECT SUM(BM1_VALOR), convert(char(4), year(@data)) + '/'+ convert(char(2), month(@data)) as dat_ano_mes, 'Receita' as tipo
	FROM  BM1020 BM1 INNER JOIN BQC020 BQC ON (BQC_NUMCON = BM1_CONEMP AND BQC_SUBCON = BM1_SUBCON  AND BQC.D_E_L_E_T_='')
	WHERE  BM1.D_E_L_E_T_ = ''
	 AND BM1_CODINT = '0001'
	 AND BM1_CODTIP = '101'
	 AND  BM1_ANO = convert(char(4), year(@data))
	 AND BM1_MES = SUBSTRING(REPLACE(@data, '-', ''),5,2) )) as tabela
	 ) AS tabela2  
	 GROUP BY dat_ano_mes  ;

    SET @data = DATEADD(day, -30, @data);
END



SELECT * FROM #temp

END;