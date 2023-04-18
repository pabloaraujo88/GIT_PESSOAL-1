SELECT * FROM  v_Vendas010
/*
Motivo Bloqueio?              
Data Bloqueio Inicial?        
Data Bloqueio Final?          
Agrupar Por?                  
Equipe Inicial?               
Equipe Final?                 
Vendedor Inicial?             
Vendedor Final?               
Dia Vencimento?               
Forma de Pagamento?           
Data Adesao Inicial?          
Data Adesao Final?            
PJ ou PF?                     
*/

Declare @DataFim char(8)
set @DataFim =  CONVERT(VARCHAR, GETDATE(), 112);


exec PR_MPLSR020 'BA1010','BA3010','BCA010','BDK010','','20220926',@DataFim,2,'   ','ZZZ','      ','zzzzzz',           0,'  ','        ','20220925',2 


SELECT                 BA1_DATINC,   
				   from BA1010
/*
DROP VIEW V_VENDAS010
CREATE VIEW v_Vendas010
AS
  SELECT DISTINCT *
  FROM   (SELECT BA1_CODINT + BA1_CODEMP + BA1_MATRIC + BA1_TIPREG          AS
                 MATR,
                 CONVERT(CHAR(10), CONVERT(DATETIME, BA1_DATINC, 103), 103) AS
                 DATINC,
                 CASE
                   WHEN DATEPART (DAY, CONVERT(DATE, BA1_DATINC, 103)) >= 26
                 THEN
					'01'+substring(CONVERT(VARCHAR, DATEADD(MM, 1, CONVERT(DATE, BA1_DATINC, 103)) , 103),3,11)		
                   ELSE 
				   '01'+substring(CONVERT(VARCHAR(10), CAST (BA1_DATINC AS DATE), 103),3,11)
                 END                                                        AS
                 PERIODO,
                 CASE
                   WHEN BA1_MOTBLO = '' THEN ''
                   ELSE CONVERT(CHAR(10), CONVERT(DATETIME, BA1_DATBLO, 103),
                        103)
                 END                                                        AS
                 DTBLO,
                 BA1_MOTBLO,
                 BA3_FORPAG,
                 CASE
                   WHEN ( RTRIM(BA1_EQUIPE) <> '' )
                        AND ( BA1_EQUIPE IS NOT NULL ) THEN BA1_EQUIPE
                   WHEN ( RTRIM(BA3_EQUIPE) <> '' )
                        AND ( BA3_EQUIPE IS NOT NULL ) THEN BA3_EQUIPE
                   ELSE BQC_EQUIPE
                 END                                                        AS
                 CODEQU,
                 CASE
                   WHEN ( RTRIM(BA1_CODVEN) <> '' )
                        AND ( BA1_CODVEN IS NOT NULL ) THEN BA1_CODVEN
                   WHEN ( RTRIM(BA3_CODVEN) <> '' )
                        AND ( BA3_CODVEN IS NOT NULL ) THEN BA3_CODVEN
                   ELSE BQC_CODVEN
                 END                                                        AS
                 CODVEN,
                 BA1_BAIRRO,
                 BA1_MUNICI
          FROM   BA1010 BA1
                 LEFT JOIN BA3010 BA3
                        ON ( BA1_CODINT = BA3_CODINT
                             AND BA1_CODEMP = BA3_CODEMP
                             AND BA1_MATRIC = BA3_MATRIC
                             AND BA3.D_E_L_E_T_ <> '*' )
                 LEFT JOIN BQC010 BQC
                        ON ( BA1_CODEMP = BQC_CODEMP
                             AND BA1_CONEMP = BQC_NUMCON
                             AND BA1_SUBCON = BQC_SUBCON
                             AND BQC.D_E_L_E_T_ = ' ' )
                 LEFT JOIN BI3010 BI3
                        ON ( BA1_CODINT = BI3_CODINT
                             AND BA1_CODPLA = BI3_CODIGO
                             AND BI3.D_E_L_E_T_ <> '*' )
                 LEFT JOIN BG3010 BG3
                        ON ( BA1_MOTBLO = BG3_CODBLO
                             AND BG3.D_E_L_E_T_ <> '*' )
          WHERE  BA1_DATINC BETWEEN '20211226' AND CONVERT(VARCHAR, GETDATE(), 112)
                 AND BA1.D_E_L_E_T_ <> '*') AS TAB1
  WHERE  CODEQU NOT IN ( '903', '941' )
         AND CODVEN BETWEEN '      ' AND 'ZZZZZZ' */