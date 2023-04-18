SELECT *
INTO   #SZV0102022
FROM   SZV010 ZV
WHERE  D_E_L_E_T_ = ''
       AND ZV_ANO = '2022'

SELECT ZV.ZV_ITCTB,
       Z2.ZV_ITCTB,
       *
FROM   SZV010 ZV
       JOIN #SZV0102022 Z2
         ON ( Z2.ZV_CODEMP = ZV.ZV_CODEMP
              AND Z2.ZV_ITEM = ZV.ZV_ITEM
              AND Z2.ZV_ITEMSZU = ZV.ZV_ITEMSZU )
WHERE  ZV.D_E_L_E_T_ = ''
       AND ZV.ZV_ANO = '2023'

/*
BEGIN TRAN 
UPDATE SZV010
SET ZV_ITCTB = Z2.ZV_ITCTB
FROM SZV010 ZV JOIN #SZV0102022 Z2 ON (Z2.ZV_CODEMP = ZV.ZV_CODEMP AND Z2.ZV_ITEM=ZV.ZV_ITEM
AND Z2.ZV_ITEMSZU = ZV.ZV_ITEMSZU)
WHERE ZV.D_E_L_E_T_ = ''
AND ZV.ZV_ANO = '2023'
AND ZV.ZV_ITCTB = ''

COMMIT
*/
SELECT count(*)
FROM   SZT010 ZT (NOLOCK)
       INNER JOIN SZU010 ZU (NOLOCK)
               ON ( ZU_FILIAL = ZT_FILIAL
                    AND ZU_ANO = ZT_ANO
                    AND ZU.D_E_L_E_T_ = '' )
       INNER JOIN SZV010 ZV (NOLOCK)
               ON ( ZU_FILIAL = ZV_FILIAL
                    AND ZU_ANO = ZV_ANO
                    AND ZU_REVISAO = ZV_REVISAO
                    AND ZV.D_E_L_E_T_ = '' )
WHERE  ZT.ZT_STATUS = '2'
       AND ZT_ANO = '2023'
       AND ZT.D_E_L_E_T_ = ''
       AND ZV_ITCTB = '40101010010001001'

SELECT count(*)
FROM   SZT010 ZT (NOLOCK)
       INNER JOIN SZU010 ZU (NOLOCK)
               ON ( ZU_FILIAL = ZT_FILIAL
                    AND ZU_ANO = ZT_ANO
                    AND ZU.D_E_L_E_T_ = '' )
       INNER JOIN SZV010 ZV (NOLOCK)
               ON ( ZU_FILIAL = ZV_FILIAL
                    AND ZU_ANO = ZV_ANO
                    AND ZU_REVISAO = ZV_REVISAO
                    AND ZV.D_E_L_E_T_ = '' )
WHERE  ZT.ZT_STATUS = '2'
       AND ZT_ANO = '2022'
       AND ZT.D_E_L_E_T_ = ''
       AND ZV_ITCTB = '40101010010001001' 