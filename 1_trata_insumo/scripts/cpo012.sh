#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo012.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo012.sh  
#     Exemplo : ./cpo012.sh <FI>
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
  echo "Exemplo: $0 bbo cpo040 cpo012"
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

echo "012 Titulo (Analitico) - Idioma do titulo da analitica"
$DIRISIS/mx $2 mfrl=8388608 fmtl=8388608 "proc=@$DIRTAB/v12_sub_i.prc" create=$3_1 -all now
$DIRISIS/mx $3_1 "proc=(if p(v1200) then  '<12 0>',v1200,|^i|v940,'</12>' fi)" create=$3_2 -all now

$DIRISIS/mx $3_2 "proc='d912',(if v12^i='pt' or v12^i='es' or v12^i='en' or v12^i='fr' then |<912>|v12|</912>| fi)" create=$3_3 -all now

$DIRISIS/mx $3_3 "proc='d912',(if s(mpu,v912^*,mpl)=v912^* then '<812>'v912'</812>' else '<912>'v912'</912>' fi)" create=$3_4 -all now

$DIRISIS/id2i $TABS/gansmi.id create=gansmi

$DIRISIS/mx $3_4 "gizmo=gansmi,812" create=$3_5 -all now

$DIRISIS/mx $3_5 "proc='d812',(if p(v812) then '<912>'s(mpu,v812.1,mpl),v812*1'</912>' fi)" -all now create=$3_6

$DIRISIS/mx $3_6  "proc='d912',(if v912:'.^' then '<912>'replace(v912,'.^','^')'</912>' else '<912>'v912'</912>' fi)" -all now create=$3_7

echo "Cria Master"
$DIRISIS/mx $3_7 "proc='S'" create=$3 -all now

echo "Cria Iso"
$DIRISIS/mx $3 "proc='d*',if p(v912) then |<2 0>|v2|</2>|,(|<912>|v912|</912>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000
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
