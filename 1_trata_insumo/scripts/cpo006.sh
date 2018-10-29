#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo006.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo006.sh  
#     Exemplo : ./cpo006.sh <FI>
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
  echo "Exemplo: $0 bbo cpo002 cpo006"
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
echo "Controle"

[ -f $DIROUTS/$1/RelMed1_$3.txt ] && rm $DIROUTS/$1/RelMed1_$3.txt

echo "006 Nível de Tratamento - Checa segundo os tipos controlados pela metodologia"
$DIRISIS/mx seq=$DIRTAB/tab_006.txt create=tab_006 -all now
$DIRISIS/mx tab_006 "fst=1 0 v1" fullinv=tab_006 tell=1
$DIRISIS/mx $2 "join=tab_006,906:1=s(mpu,v6,mpl)" "proc='d32001'" create=$3_1 -all now

echo "Gera Relatorio metodologia LILACS 1"
$DIRISIS/mx $3_1 "pft=if a(v906) then 'ID_PROC|'v2,'|ID_v2|'v776^i,'|06_NB|'v6/ fi" lw=0 -all now >>$DIROUTS/$1/RelMed1_$3.txt

echo "Gera Relatorio metodologia LILACS 2"
$DIRISIS/mx $3_1 "pft=@$DIRTAB/v6_niv.pft" lw=0 tell=1000 -all now>$DIROUTS/$1/RelMed2_$3.txt

echo "Ajusta a questao das Analiticas de MNT migrados do LILDBI-WEB que se tornaram fonte"
$DIRISIS/mx $3_1 "proc=if not v6:'a' and p(v12) then 'd906','<906>a'v906'</906>' fi" create=$3_2 -all now

echo "Ajusta a questao dos registros que tem colecao migrados do LILDBI-WEB"
$DIRISIS/mx $3_2 "proc='d906',if v6:'c' then if p(v25) and (p(v23) or p(v24)) then else '<906 0>'replace(v6,'c','')'</906>' fi else if p(v25) then '<906 0>'v6'c</906>' else '<906 0>'v6'</906>' fi,fi" create=$3_3 -all now

echo "Gera Relatorio metodologia LILACS 2"
$DIRISIS/mx $3_3 "tab=v6'|'v906/" lw=0 tell=1000 -all now>$DIROUTS/$1/RelLista_$3.txt

echo "Cria Master"
$DIRISIS/mx $3_3 "proc='S'" create=$3 -all now

echo "Gera o ISO"
$DIRISIS/mx $3 "proc='d*',if p(v906) then |<2 0>|v2|</2>|,|<906 0>|v906[1]|</906>| fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000

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
