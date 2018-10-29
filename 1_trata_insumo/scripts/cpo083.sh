#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo083.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo083.sh  
#     Exemplo : ./cpo083.sh <FI>
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
  echo "Exemplo: $0 bbo cpo002 cpo083"
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

echo "Gera Relatorio de ocorrencias"
$DIRISIS/mx $2 "pft=if nocc(v83)>4 then v2'|CPO083|'f(nocc(v83),0,0)/ fi" -all now lw=0 tell=5000 >$DIROUTS/$1/Rel_Decr_$3.txt

echo "083 Resumo "
$DIRISIS/mx seq=$DIRTAB/gizTiraAUResumo.seq create=gizTiraAUResumo -all now

$DIRISIS/mx $2 mfrl=8388608 fmtl=8388608 "proc=@$DIRTAB/v83_sub_i.prc" create=$3_1 -all now
$DIRISIS/mx $3_1 "gizmo=gizTiraAUResumo,83" create=$3_2 -all now

echo "Ajustes do subcampo de idioma especificos"
$DIRISIS/mx $3_2 "proc='d83',(if v83:'^ipt)' then '<83>'replace(v83,'^ipt)',')^ipt')'</83>' else if v83^i.1=' ' then '<83 0>'replace(v83,'^i pt','^ipt')'</83>' else if size(v83^i)>3 then '<83>'replace(v83,'^ipt','^ipt|')'</83>' else |<83>|v83|</83>| fi,fi,fi)"  create=$3_3 -all now tell=1000

echo "Cria master"
$DIRISIS/mx $3_3 "proc='S'" create=$3 -all now

echo "cria ISO"
$DIRISIS/mx $3 "proc='d*',if p(v83) then |<2 0>|v2|</2>|,(if v83^i='zh' then else |<983>|v83|</983>| fi) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000

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
