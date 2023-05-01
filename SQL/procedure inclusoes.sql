-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_VENDASSSA]   
	-- Add the parameters for the stored procedure here
	--<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
if object_id('tempdb..vendas010') is not null
   drop table vendas010

create table vendas010(

  ID int NOT NULL IDENTITY,
	CITY   varchar(40),
    MATR    varchar(255) ,
    DATINC  varchar(10),
    PERIODO varchar(10),
    DTBLO	varchar(10),
    MOTBLO  varchar(10),
	FORPAG  VARCHAR(3),
	CODEQU  VARCHAR(3),
	CODVEN  VARCHAR(6),
	BAIRRO  varchar(50),
	CIDADE  VARCHAR(50)

)

INSERT INTO vendas010 (CITY,MATR, DATINC, PERIODO, DTBLO, MOTBLO, FORPAG,CODEQU, CODVEN, BAIRRO, CIDADE)
(
SELECT DISTINCT *
FROM   (SELECT 'SALVADOR' AS CITY ,BA1_CODINT+BA1_CODEMP+BA1_MATRIC+BA1_TIPREG as MATR,
        
		convert(char(10),convert(datetime, BA1_DATINC,103),103) as DATINC,
		convert(char(2),
		CASE
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0126' AND '0225' THEN '02'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0226' AND '0325' THEN '03'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0326' AND '0425' THEN '04'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0426' AND '0525' THEN '05'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0526' AND '0625' THEN '06'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0626' AND '0725' THEN '07'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0726' AND '0825' THEN '08'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0826' AND '0925' THEN '09'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0926' AND '1025' THEN '10'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '1026' AND '1125' THEN '11'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '1126' AND '1225' THEN '12'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '1226' AND '1231' THEN '01'
		WHEN  substring(BA1_DATINC,5,4) BETWEEN '0101' AND '0125' THEN '01' 
END) + '/'+ convert(char(4),
            CASE 
				WHEN  substring(BA1_DATCON,5,4) BETWEEN '1226' AND '1231' THEN
				CAST(substring(BA1_DATCON,1,4) AS NUMERIC) + 1
				ELSE
				CAST(substring(BA1_DATCON,1,4) AS NUMERIC)
			END) AS  PERIODO	,
			CASE WHEN BA1_MOTBLO = '' THEN ''
			ELSE
               convert(char(10),convert(datetime, BA1_DATBLO,103),103) 
			 END AS DTBLO,
               BA1_MOTBLO,
			   BA3_FORPAG,
               CASE
                 WHEN ( RTRIM(BA1_EQUIPE) <> '' )
                      AND ( BA1_EQUIPE IS NOT NULL ) THEN BA1_EQUIPE
                 WHEN ( RTRIM(BA3_EQUIPE) <> '' )
                      AND ( BA3_EQUIPE IS NOT NULL ) THEN BA3_EQUIPE
                 ELSE BQC_EQUIPE
               END AS CODEQU,
               CASE
                 WHEN ( RTRIM(BA1_CODVEN) <> '' )
                      AND ( BA1_CODVEN IS NOT NULL ) THEN BA1_CODVEN
                 WHEN ( RTRIM(BA3_CODVEN) <> '' )
                      AND ( BA3_CODVEN IS NOT NULL ) THEN BA3_CODVEN
                 ELSE BQC_CODVEN
               END AS CODVEN, 
			   BA1_BAIRRO, BA1_MUNICI
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
        WHERE  BA1_DATINC BETWEEN '20211226' AND '20221225'
               AND BA1.D_E_L_E_T_ <> '*') AS TAB1
WHERE  CODEQU not in ('903','930','941')
       AND CODVEN BETWEEN '      ' AND 'ZZZZZZ'
)

END
GO
/*
drop procedure [PR_VENDASSSA]
EXEC [PR_VENDASSSA]

select * from vendas010
*/