#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo001.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo001.sh  
#     Exemplo : ./cpo001.sh <FI>
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
  echo "Exemplo: $0 bbo cpo002 cpo001"
  exit 0
fi

echo " ----------------------------------------------------------------------------------------------------------- "

echo "  -> Base origem"
# Verifica se existe arquivo inicial
if [ ! -f $DIRDATA/${1}/$2.mst ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/${1}/$2.mst ]"; exit 0
else
  echo "  OK - $DIRDATA/${1}/cpo$2.mst"
fi

echo "Area de trabalho"
cd $DIRDATA/${1}

echo
echo "INICIO DOS AJUSTES ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Controleo"

echo "001 Codigo do Centro - join com a base da Nmail"
$DIRISIS/mx iso=$DIRTAB/centros.iso create=centros -all now
$DIRISIS/mx centros "fst=1 0 v1/" fullinv=centros
$DIRISIS/mx $2 "join=centros,901:1=s(mpu,v1^*,mpl)" "proc='d32001'" create=$3_1 -all now

echo "Gera Relatorios"
$DIRISIS/mx $3_1 "pft=if a(v901) then mfn'|ID|'v776^i'|01_CC|'v1/ fi" -all now >$DIROUTS/$1/Rel_$3.txt
$DIRISIS/mx seq=$DIROUTS/$1/Rel_cpo001.txt "tab=(v3/)" -all now >$DIROUTS/$1/Rel_$3_tab.txt

echo "Cria Master"
$DIRISIS/mx $3_1 "proc='S'" create=$3 -all now

echo "Gera o ISO"
$DIRISIS/mx $3 "proc='d*',if p(v901) or p(v1) then |<2 0>|v2|</2>|,'<901 0>'if p(v901) then v901 else v1 fi'</901>' fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000

echo
echo "TERMINO DOS AJUSTES ##########################################################################################"

echo "-------------------------------------------------------------------------"
echo
echo "Fim de processamento cpo001" 
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
