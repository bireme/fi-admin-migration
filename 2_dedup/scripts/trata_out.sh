#!/bin/bash
# -------------------------------------------------------------------------- #
# trata_out.sh - Checa se os registro estão duplicados utilizando o DeDup  #
# -------------------------------------------------------------------------- #
#
#     Chamada : trata_out.sh
#     Exemplo : ./trata_out.sh <Diretorio> <iso-8859-1/utf-8>
#
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
vrs:  1.00 20170320,  Ana Katia Camilo
        - Edicao original
HISTORICO

# -------------------------------------------------------------------------- #

# Anota hora de inicio de processamento
export HORA_INICIO=`date '+ %s'`
export HI="`date '+%Y.%m.%d %H:%M:%S'`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa ${0} ${1} ${2} ${3} ${4}"
echo ""
# ------------------------------------------------------------------------- #

echo "- Verificacoes iniciais"

# Verifica passagem obrigatoria de 2 parametro
if [ "$#" -ne "2" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 Nome do diretorio do lote <sci_201710 | bbo> Tipo de check <Sas | MNT | MNTam>"
  exit 0
fi

# Ajustando variaveis para processamento
source /bases/fiadmin2/DeDup/config/settings.inc

# ------------------------------------------------------------------------- #

cd $DIRWRK/$1

if [ -s $DIRWRK/$1/out1_$1_$2.txt ]; then 
	echo "Executa o trata out 1"
	$DIRSCRI/trata_out1.sh $1 $2
else 
	echo "Arquivo OUT 1 não encontrado $DIRWRK/$1/out1_$1_$2.txt "
fi

if [ -s $DIRWRK/$1/out2_$1_$2.txt ]; then
        echo "Executa o trata out 2"
        $DIRSCRI/trata_out2.sh $1 $2
else
        echo "Arquivo OUT 2 não encontrado $DIRWRK/$1/out2_$1_$2.txt"
fi
if [ -s $DIRWRK/$1/out_ok_$1_$2.txt ]; then
        echo "Executa o trata out OK"
        $DIRSCRI/trata_out_ok.sh $1 $2
else
        echo "Arquivo OUT OK não encontrado $DIRWRK/$1/out_ok_$1_$2.txt"
fi

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

