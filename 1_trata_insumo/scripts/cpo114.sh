#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo114.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo114.sh  
#     Exemplo : ./cpo114.sh <FI>
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

# -------------------------------------------------------------------------- #

echo "- Verificacoes iniciais"

# Verifica passagem obrigatoria de 3 parametro
if [ "$#" -ne "3" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> <file_in> <file_out>"
  echo "Exemplo: $0 bbo cpo002 cpo114"
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

echo
echo "INICIO DOS AJUSTES ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Descricao"

echo "114 Tipo de Material Visual"
echo "Apaga n para colocar o pipe |"
$DIRISIS/mx $2 "proc=if v114='pipe' then 'd114' fi" create=$3_1 -all now tell=5000

echo "Problema do pipe I"
$DIRISIS/mx $3_1 "proc=if v114='|' then 'd114','<114 0>pipe</114>' fi" create=$3_2 -all now tell=5000

echo "Traz tabela de controle para join"
$DIRISIS/mx seq=$DIRTAB/tab_114.txt create=tab_114 -all now
$DIRISIS/mx tab_114 "fst=1 0 v1/" fullinv=tab_114 tell=1

echo "Join dos campos validos"
$DIRISIS/mx $3_2 "join=tab_114,974:1=s(mpu,v114,mpl)" "proc='d32001'" create=$3_3 -all now tell=5000

echo "Problema do pipe II"
$DIRISIS/mx $3_3 "proc=if v974='pipe' then 'd974','<974 0>|</974>' fi" create=$3_4 -all now tell=5000

echo "Gera Master"
$DIRISIS/mx $3_4 "proc='S'" create=$3 -all now tell=5000

echo "Gera ISO"
$DIRISIS/mx $3 "proc='d*',if p(v974) then |<2 0>|v2|</2>|,(|<974>|v974|</974>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=5000
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
