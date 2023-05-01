 /*CREATE TABLE Vendas010 (
	ID int NOT NULL IDENTITY,
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

);


CREATE TABLE Can_Salvador (
ID int NOT NULL IDENTITY,
PERIODO varchar(10),
TOTAL int)

drop procedure [PR_VENDASSSA]
EXEC [PR_VENDASSSA]

select * from metas_cancelamentos_pbi
update metas_cancelamentos_pbi
SET periodo = '26/12/2022'
where id = '12'

DELETE FROM Vendas010
select * from Vendas010
where PERIODO = '08/2022'
and CODEQU = '941'

CREATE TABLE Can_Salvador (
ID int NOT NULL IDENTITY,
PERIODO varchar(30),
MES_CAN varchar(10),
TOTAL int)

SELECT * FROM  Can_Salvador

INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('JANEIRO/2022','26/01/2022', 1240 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('FEVEREIRO/2022','26/02/2022', 1214 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('MARÇO/2022','26/03/2022', 1173 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('ABRIL/2022','26/04/2022', 1149 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('MAIO/2022','26/05/2022', 1134 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('JUNHO/2022','26/06/2022', 1113 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('JULHO/2022','26/07/2022', 1047 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('AGOSTO/2022','26/08/2022', 1069 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('SETEMBRO/2022','26/09/2022', 1075 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('OUTUBRO/2022','26/10/2022', 851 )
INSERT INTO Can_Salvador (PERIODO,MES_CAN, TOTAL) VALUES ('NOVEMBRO/2022','26/11/2022', 829 )
608

select * from Can_Salvador

Delete from Can_Salvador
where ID = (
select max(ID)  
from Can_Salvador)

*/

 exec PR_MPLSR020 'BA1010','BA3010','BCA010','BDK010','   ','20221026','20221116',              2,'   ','ZZZ','      ','zzzzzz',             0,'  ','        ','20221025',              2 




