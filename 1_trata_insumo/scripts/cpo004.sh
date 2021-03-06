#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo004.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo004.sh  
#     Exemplo : ./cpo004.sh <FI> <file_in>
#
# -------------------------------------------------------------------------- #
#  Centro Latino-Americano e do Caribe de Informação em Ciências da Saúde
#     é um centro especialidado da Organização Pan-Americana da Saúde,
#           escritório regional da Organização Mundial da Saúde
#                      BIREME / OPS / OMS (P)2016
# -------------------------------------------------------------------------- #

# Historico
# versao data, Responsavel
#       - Descricao
cat > /dev/null <<HISTORICO
vrs:  1.00 20170103, Ana Katia Camilo / Fabio Luis de Brito
        - Edicao original
HISTORICO
# -------------------------------------------------------------------------- #

# Anota hora de inicio de processamento
export HORA_INICIO=`date '+ %s'`
export HI="`date '+%Y.%m.%d %H:%M:%S'`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa ${0} ${1} ${2} ${3} ${4}"
echo ""
# ------------------------------------------------------------------------- #

# Ajustando variaveis para processamento
source /bases/fiadmin2/1_trata_insumo/tpl/settings.inc
source /bases/fiadmin2/config/$1.inc

# -------------------------------------------------------------------------- #

echo "- Verificacoes iniciais"

# Verifica passagem obrigatoria de 3 parametro
if [ "$#" -ne "3" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> <file_in> <file_out>"
  echo "Exemplo: $0 bbo cpo002 cpo004"
  exit 0
fi

echo " ----------------------------------------------------------------------------------------------------------- "

echo "  -> Base origem"
# Verifica se existe arquivo inicial
if [ ! -f $DIRDATA/${1}/$2.mst ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/${1}/$2.mst ]"; exit 0
else
  echo "  OK - $DIRDATA/${1}/$2.mst"
fi

echo "Area de trabalho"
cd $DIRDATA/${1}


echo "Arquivo de configuracao"
echo "--------------------------------------------------------------------------------------------------------------"
[ -s /bases/fiadmin2/config/$1.inc ] || echo "ERRO - Arquivo de configuracao nao encontrado /bases/fiadmin2/config/$1.inc"
echo "--------------------------------------------------------------------------------------------------------------"

echo
echo "INICIO DOS AJUSTES ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Descricao"

echo "004 Base de Dados - Verifica se e lilacs"
echo "Codigo da base: $SIGLA_DB // Nome da proc: $DIRTAB/$PRC_CPO004"

if [ -n "$SIGLA_DB" ]; then 
	echo "SIM - 1"
        if [ $SIGLA_DB = "1" ]; then
               echo "SIM - 2"
	        $DIRISIS/mx $2 "proc='<950>^b1</950>'" create=$3_1 -all now
	else
		echo "NÃO - 2"
                if [ -n "$PRC_CPO004" ]; then
                        $DIRISIS/mx $2 "proc=@$DIRTAB/$PRC_CPO004" create=$3_1 -all now
	                echo "SIM - 3"
		else
                        $DIRISIS/mx $2 "proc=,if s(mpu,v4,mpl):'LILACS' then '<950>^b1</950>' fi" "proc='<950>^b$SIGLA_DB</950>'" create=$3_1 -all now
			echo "NÃO - 3"
		fi
	fi
else
	echo "NÃO - 1"
        $DIRISIS/mx $2 "proc=,if s(mpu,v4,mpl):'LILACS' then '<950>^b1</950>' fi" create=$3_1 -all now
fi

echo "LILACS_indexed"
$DIRISIS/mx $3_1 "proc=,if s(mpu,v4,mpl):'LILACS' then '<950>^i1</950>' fi" create=$3_2 -all now

echo "Status"
if [ "$STATUS" ]; then
	$DIRISIS/mx $3_2 "proc='<950>^s$STATUS</950>'" create=$3_3 -all now
else
$DIRISIS/mx $3_2 "proc='<950>^s-3</950>'" create=$3_3 -all now
fi

$DIRISIS/mx $3_3 "proc='d904',if p(v4) then (if s(mpu,v4,mpl)='LILACS' then else '<904 0>'v4'</904>' fi),fi" create=$3_4 -all now

$DIRISIS/mx $3_4 "proc='S'" create=$3 -all now

echo "Gera Relatorios"
$DIRISIS/mx $2 "tab=(v4/)" -all now >$DIROUTS/$1/cpo004_ori.txt
$DIRISIS/mx $3 "tab=(v904/)" -all now >$DIROUTS/$1/cpo004_db.txt
$DIRISIS/mx $3 "tab=(v950^b/)" -all now >$DIROUTS/$1/cpo004_idb.txt
$DIRISIS/mx $3 "tab=(v950^s/)" -all now >$DIROUTS/$1/cpo004_st.txt

$DIRISIS/mx $3 "proc='d*',if p(v904) or p(v950) then |<2 0>|v2|</2>|,(|<950>|v950|</950>|),(|<904>|v904|</904>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000

echo
echo "TERMINO DOS AJUSTES ##########################################################################################"

echo "-------------------------------------------------------------------------"
echo
echo "Fim de processamento"
echo


HORA_FIM=`date '+ %s'`
DURACAO=`expr ${HORA_FIM} - ${HORA_INICIO}`
HORAS=`expr ${DURACAO} / 60 / 60`
MINUTOS=`expr ${DURACAO} / 60 % 60`
SEGUNDOS=`expr ${DURACAO} % 60`

echo
echo "DURACAO DE PROCESSAMENTO"
echo "-------------------------------------------------------------------------"
echo " - Inicio:  ${HI}"
echo " - Termino: `date '+%Y.%m.%d %H:%M:%S'`"
echo
echo " Tempo de execucao: ${DURACAO} [s]"
echo " Ou ${HORAS}h ${MINUTOS}m ${SEGUNDOS}s"
echo

# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Processa  ${0} ${1} ${2} ${3} ${4}"
# ------------------------------------------------------------------------- #
echo
echo
