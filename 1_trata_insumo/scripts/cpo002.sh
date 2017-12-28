#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo002.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo002.sh  
#     Exemplo : ./cpo002.sh <FI>
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
  echo "Exemplo: $0 bbo 01_lil cpo002 "
  exit 0
fi

echo "  -> Base origem"
# Verifica se existe arquivo inicial
if [ ! -f $DIRDATA/${1}/$2.mst ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/${1}/$2.mst ]"; exit 0
else
  echo "  OK - $DIRDATA/${1}/cpo$2.mst"
fi

# -------------------------------------------------------------------------- #

echo "  -> Garante diretorio vazio para processamento"
[ ! -d $DIRDATA/${1} ] && mkdir $DIRDATA/${1}

echo "  -> Traz insumo para processamento"
cd $DIRDATA/${1}
$DIRISIS/mx iso=$DIRINSUMO/${1}.iso create=${1} -all now 

echo "  -> Limpa base - mxcp"
$DIRISIS/mxcp ${1} create=01_lil clean log=/dev/null

echo "  -> Desbloqueia - retag"
$DIRISIS/retag 01_lil unlock

echo
echo "INICIO DOS AJUSTES ###########################################################################################"

echo "----------------------------------------------------------------------------------------"
echo "Campo de Numero de Identificacao"

echo "002 Identificados - No campo ID[02] vai para o Origem exemplo: 776 BBO^i345 e o campo ID recebe um numero sequencial"
$DIRISIS/mx 01_lil "proc='d2d776','<2>'f(val(mfn),0,0)'</2>','<776>${1}-'v2'</776>'" create=$3 -all now tell=10000

$DIRISIS/mx $3 "proc='d*',if p(v776) then |<2 0>|v2|</2>|,(|<776>|v776|</776>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000


echo "----------------------------------------------------------------------------------------"

echo
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
