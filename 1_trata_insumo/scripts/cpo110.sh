#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo110.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo110.sh  
#     Exemplo : ./cpo110.sh <FI>
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
  echo "Exemplo: $0 bbo cpo009 cpo110"
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

echo "110 Forma do item se nao tiver os campos 8 e 9 apaga o 1101 que vira 110"
$DIRISIS/mx $2 "proc=if p(v110) and v110:'s' and a(v908) and a(v909) then 'd110' fi" "proc=if v110:'^i' then 'd110',(if v110.1='^' then else '<110>'v110.1'</110>' fi),fi" create=$3_1 -all now tell=5000

echo "110 Forma do item --> Inclui o campo 110 quando presente os campos 908 e 909"
$DIRISIS/mx $3_1 "proc=if p(v908) and p(v909) and a(v110) then '<110 0>s</110>' fi" "proc=if v110:'Eletr' then 'd110','<110 0>s</110>' fi" "proc=if p(v110^i) or size(v110)>1 then 'd110',if p(v8^u) then '<110 0>s</110>' fi,fi" create=$3_2 -all now

echo "Apaga n para colocar o pipe |"
#$DIRISIS/mx cpo110_2 "pft=if v110='n' then v2'|CPO110|'v110/ fi" -all now lw=0 >$DIROUTS/$1/Rel_Descr_cpo110.txt
$DIRISIS/mx $3_2 "proc=if v110='pipe' then 'd110' fi" create=$3_3 -all now tell=5000

echo "Problema do pipe I"
$DIRISIS/mx $3_3 "proc=if v110='|' then 'd110','<110 0>pipe</110>' fi" create=$3_4 -all now tell=5000

echo "Traz tabela de controle para join"
$DIRISIS/mx seq=$DIRTAB/tab_110.txt create=tab_110 -all now
$DIRISIS/mx tab_110 "fst=1 0 v1/" fullinv=tab_110 tell=1

echo "Join dos campos validos"
$DIRISIS/mx $3_4 "join=tab_110,980:1=s(mpu,v110,mpl)" "proc='d32001'" create=$3_5 -all now tell=5000

echo "Problema do pipe II"
$DIRISIS/mx $3_5 "proc=if v980='pipe' then 'd980','<980 0>|</980>' fi" create=$3_6 -all now tell=5000

echo "Cria master e ISO"
$DIRISIS/mx $3_6 "proc='S'" create=$3 -all now tell=5000
$DIRISIS/mx $3 "proc='d*',if p(v980) then |<2 0>|v2|</2>|,(|<980>|v980|</980>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=5000

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
