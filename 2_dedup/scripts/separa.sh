#!/bin/bash
# -------------------------------------------------------------------------- #
# separa.sh - Checa se os registro estão duplicados utilizando o DeDup  #
# -------------------------------------------------------------------------- #
#
#     Chamada : separa.sh
#     Exemplo : ./separa.sh <Diretorio> <iso-8859-1/utf-8>
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

# Verifica passagem obrigatoria de 1 parametro
if [ "$#" -ne "1" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $1 Nome do diretorio do lote <sci_201710 | bbo>"
  exit 0
fi

# Ajustando variaveis para processamento
source /bases/fiadmin2/DeDup/config/settings.inc

## -------------------------------------------------------------------------- #

cd $DIRWRK/$1
echo "$DIROUT/$1"


echo "Separa base $1 lil_all em lil_OK"
$DIRISIS/mx $DIRWRK/$1/lil_all "proc=if a(v998) then 'd*' fi" iso=$DIROUTS/$1/lil_all_ok.iso -all now

echo "Separa base $1 lil_all em lil_dup"
$DIRISIS/mx $DIRWRK/$1/lil_all "proc=if a(v996) then 'd*' fi" iso=$DIROUTS/$1/lil_all_dup_out2.iso -all now
 
echo "Separa base $1 lil_all em lil_dup"
$DIRISIS/mx $DIRWRK/$1/lil_all "proc=if a(v995) then 'd*' fi" iso=$DIROUTS/$1/lil_all_dup_out1.iso -all now

echo "Separa base $1 lil_all em lil_erro"
$DIRISIS/mx $DIRWRK/$1/lil_all "proc=if a(v996) or a(v998) then 'd*' fi" iso=$DIROUTS/$1/lil_all_erro.iso -all now

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

