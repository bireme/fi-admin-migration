#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo091.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo091.sh  
#     Exemplo : ./cpo091.sh <FI>
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
  echo "Exemplo: $0 bbo cpo002 cpo091"
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
cho "Controle"


echo "091 Data de Entrada - Data de Controle"
echo "Arruma Data de entrada"
$DIRISIS/mx $2 "proc='d91',if a(v91) and p(v84) then '<991>'v84.4,v84*5.2,v84*8.2'</991>' else if v91*4.2>'12' or v91*4.2<'01' then '<991>'v91.4'1231</991>' else if (v91*4.2='04' or v91*4.2='06' or v91*4.2='09' or v91*4.2='11') and (v91*6.2<'01' or v91*6.2>'30') then '<991>'v91.6'30</991>' else if v91*4.2='02' and (v91*6.2<'01' or v91*6.2>'28') then '<991>'v91.6'28</991>' else if size(v91*6.2)<2 then '<991>'v91.6'01</991>' else if (v91*4.2='01' or v91*4.2='03' or v91*4.2='05' or v91*4.2='07' or v91*4.2='08' or v91*4.2='10' or v91*4.2='12') and (v91*6.2<'01' or v91*6.2>'31') then '<991>'v91.6'31</991>' else '<991>'v91.8'</991>' fi,	fi,fi,fi,fi,fi" create=$3_1 -all now tell=5000

#"proc='d91',if a(v91) and p(v84) then '<991>'v84.4,v84*5.2,v84*8.2'</991>' else if v91*4.2>'12' or v91*4.2<'01' then '<991>'v91.4'1231</991>' else if (v91*4.2='04' or v91*4.2='06' or v91*4.2='09' or v91*4.2='11') and (v91*6.2<'01' or v91*6.2>'30') then '<991>'v91.6'30</991>' else if v91*4.2='02' and (v91*6.2<'01' or v91*6.2>'28') then '<991>'v91.6'28</991>' else if size(v91*6.2)<2 then '<991>'v91.6'01</991>' else '<991>'v91.8'</991>' fi,fi,fi,fi,fi" 

echo "Cria Master"
$DIRISIS/mx $3_1 "proc='S'" create=$3 -all now

echo "Gera o ISO"
$DIRISIS/mx $3 "proc='d*',if p(v991) then |<2 0>|v2|</2>|,|<991 0>|v991[1]|</991>| fi" iso=$DIRWORK/$1/$3.iso -all now tell=5000

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
