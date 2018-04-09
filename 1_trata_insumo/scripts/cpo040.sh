#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo040.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo040.sh  
#     Exemplo : ./cpo040.sh <FI> <file_in> <file_out>
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
  echo "Exemplo: $0 bbo cpo002 cpo040"
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

cp $DIRTAB/gutf8ans.id .

$DIRISIS/id2i gutf8ans.id create=gutf8ans
$DIRISIS/mx seq=$DIRTAB/Idioma_coleciona.seq gizmo=gutf8ans create=Idioma_coleciona -all now tell=10

echo "040 Idioma Gizmo no campo de idioma [40]"
cp $DIRTAB/gizIdioma.seq .
$DIRISIS/mx seq=gizIdioma.seq create=gizIdioma -all now

echo "Inclui se não tem pega a informacao do titulo"
$DIRISIS/mx $2 "proc='d940',if p(v40) then ('<940>'v40'</940>') else if p(v12^i) then '<940>'v12^i[1]'</940>' else if p(v18^i) then '<940>'v18^i[1]'</940>'  fi,fi,fi" create=$3_1 -all now

echo "Tornar o campo repetitivo separado por /"
$DIRISIS/mxcp $3_1 create=$3_2 repeat=/,940 

echo "Gizmo"
$DIRISIS/mx $3_2 "gizmo=gizIdioma,940" "gizmo=Idioma_coleciona,940" create=$3_3 -all now 
echo "Relatorio"
$DIRISIS/mx $3_3 "pft=if a(v940) then v2'|CPO040|sem'/ fi" -all now >$DIROUTS/$1/Rel_$3.txt

echo "Cria Master e arquivo ISO"
$DIRISIS/mx $3_3 "proc='S'" create=$3 -all now

$DIRISIS/mx $3 "proc='d*',if p(v940) then |<2 0>|v2|</2>|,(|<940>|v940|</940>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000
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
