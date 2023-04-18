SELECT E2_IDCNAB, E5_AUTBCO, E5.R_E_C_N_O_,*
FROM SE2010 E2 WITH (NOLOCK)
LEFT JOIN SE5010 E5 WITH (NOLOCK) ON E2_FILIAL = E5_FILIAL 
                                  AND E2_PREFIXO = E5_PREFIXO 
                                  AND E2_NUM = E5_NUMERO 
                                  AND E2_PARCELA = E5_PARCELA 
                                  AND E2_TIPO = E5_TIPO 
                                  AND E2_FORNECE = E5_CLIFOR 
WHERE E2.D_E_L_E_T_='' 
  AND (E5.D_E_L_E_T_='' OR E5.D_E_L_E_T_ IS NULL) -- incluir condição de verificação da tabela SE5010
  AND E2_NUM = '1833961';

select E1_INSS, * from SE1010 WITH (NOLOCK)
WHERE D_E_L_E_T_ =''
AND E1_IDCNAB <> ''
AND E1_EMISSAO >= '20230301'
AND E1_INSS > 0

select E1_IDCNAB,E1_NUMBOR,* from SE1010 WITH (NOLOCK)
WHERE D_E_L_E_T_ =''
AND E1_NUM = '000164984'
/*
UPDATE SE1010
SET E1_FILIAL = '04BA0001'
WHERE D_E_L_E_T_ =''
AND E1_NUM = '000164984'
*/


select * from SE5010_TTAT_LOG
WHERE TTAT_RECNO='6585556'