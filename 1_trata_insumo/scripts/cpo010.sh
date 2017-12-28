#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo010.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo010.sh  
#     Exemplo : ./cpo010.sh <FI>
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
  echo "Exemplo: $0 bbo cpo002 cpo010"
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
echo "Nivel analitico"

echo "010 Autor Pessoal (Analitico)"

cp $DIRTAB/giz_1016_pa.seq .
$DIRISIS/mx seq=giz_1016_pa.seq gizmo=gutf8ans create=giz_1016_pa -all now

$DIRISIS/mx $2 "proc='d10',(if v10:'^P' and not v10:'^p' then '<10 0>'replace(v10,'^P','^p')'</10>' else if p(v10) then '<10 0>'v10'</10>' fi,fi/)" create=$3_1 lw=0 -all now

$DIRISIS/mx $3_1 "gizmo=giz_1016_pa,10" create=$3_2 -all now

echo "Inclusao de Afiliacao s.af quando nao tem sub 1"
$DIRISIS/mx $3_2 "proc='d10'(if p(v10) then if a(v10^1) then '<10 0>'v10'^1s. af</10>' else '<10 0>'v10'</10>' fi,fi)" create=$3_3 -all now

echo "Tira s.af do comeco do autor"
$DIRISIS/mx $3_3 "proc='d10',if p(v10) then (if v10^*.2='s.' then '<10>'v10*7'</10>' else '<10>'v10'</10>' fi),fi" create=$3_4 -all now

$DIRISIS/mx $3_4 "pft=(if size(v10^p)>2 then v2[1]'|CPO010|'v10^p/ fi)" lw=0 -all now >$DIROUTS/$1/Rel_country_afil_$3.txt

echo "Cria o Master e o arquivo ISO"
$DIRISIS/mx $3_4 "proc='S'" create=$3 -all now

$DIRISIS/mx $3 "proc='d*',if p(v10) then |<2 0>|v2|</2>|,(|<910>|v10|</910>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000
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
