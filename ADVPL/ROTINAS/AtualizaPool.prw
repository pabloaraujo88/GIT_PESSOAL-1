#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

user function AtualizaPool()

LOCAL Cqry1 :=""
LOCAL Cqry2 :=""


// Primeiro Update
Cqry1 +="UPDATE " + RetSQLName("BQC") + ""
Cqry1 +=   "SET BQC_CIE309 = 'S'"
Cqry1 +=   "WHERE D_E_L_E_T_ = ''"
Cqry1 +=   "AND BQC_CODIGO + BQC_NUMCON + BQC_SUBCON IN "
Cqry1 +=   "(SELECT BA1_CODINT + BA1_CODEMP + BA1_CONEMP + BA1_SUBCON"
Cqry1 +=   "FROM BA1020"
Cqry1 +=   "WHERE BA1_CODEMP IN ('0001', '0002')"
Cqry1 +=           "AND (BA1_DATBLO = '' OR BA1_DATBLO >= '20230324')"
Cqry1 +=           "AND D_E_L_E_T_ = ''"
Cqry1 +=           "GROUP BY BA1_CODINT, BA1_CODEMP, BA1_CONEMP, BA1_SUBCON"
Cqry1 +=           "HAVING COUNT(R_E_C_N_O_) <= 29)"
TCSqlExec(Cqry1)

// Segundo Update
Cqry1 +="UPDATE " + RetSQLName("BQC") + ""
Cqry1 +=           "SET BQC_CIE309 = ''"
Cqry1 +=           "WHERE D_E_L_E_T_ = ''"
Cqry1 +=           "AND BQC_CODIGO + BQC_NUMCON + BQC_SUBCON IN "
Cqry1 +=           "(SELECT BA1_CODINT + BA1_CODEMP + BA1_CONEMP + BA1_SUBCON"
Cqry1 +=           "FROM BA1020"
Cqry1 +=           "WHERE BA1_CODEMP IN ('0001', '0002')"
Cqry1 +=           "AND (BA1_DATBLO = '' OR BA1_DATBLO >= '20230324')"
Cqry1 +=           "AND D_E_L_E_T_ = ''"
Cqry1 +=           "GROUP BY BA1_CODINT, BA1_CODEMP, BA1_CONEMP, BA1_SUBCON"
Cqry1 +=           "HAVING COUNT(R_E_C_N_O_) >= 29)"
TCSqlExec(Cqry2)

return .T.
