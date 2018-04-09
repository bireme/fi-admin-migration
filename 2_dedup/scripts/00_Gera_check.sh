#!/bin/bash
# -------------------------------------------------------------------------- #
# dedup_check.sh - Checa se os registro estão duplicados utilizando o DeDup  #
# -------------------------------------------------------------------------- #
#
#     Chamada : dedup_check.sh
#     Exemplo : ./dedup_check.sh <Diretorio> <iso-8859-1/utf-8>
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

#Ajustando variaveis para processamento
source /bases/fiadmin2/DeDup/config/settings.inc

# ------------------------------------------------------------------------- #
# Ajustes de ambiente

[ -d {$DIROUTS/$1} ] || mkdir $DIROUTS/$1
[ -d {$DIRWRK/$1} ] || mkdir $DIRWRK/$1

## -------------------------------------------------------------------------- #
##

echo " Se não tem Gera o Master"
echo "$DIRLIND/mx iso=$DIRINSUMO/$1/lil_OK.iso create=$DIRWRK/$1/lil_OK -all now"
#[ -s $DIRWRK/$1/lil_OK.mst ] && $DIRLIND/mx iso=$DIRINSUMO/$1/lil_OK.iso create=$DIRWRK/$1/lil_OK -all now
$DIRLIND/mx iso=$DIRINSUMO/$1/lil_OK.iso create=$DIRWRK/$1/lil_OK -all now

#http://dedup.bireme.org/services
# http://serverofi5.bireme.br:8180/DeDup/services

echo "Executa o dedup do Sas" 
#nohup ./dedup_check.sh $1 Sas iso-8859-1 http://dedup.bireme.org/services lilacs_Sas LILACS_Sas_Seven &> $DIROUTS/$1/oust_Sas.txt &
./dedup_check.sh $1 Sas iso-8859-1 http://dedup.bireme.org/services lilacs_Sas LILACS_Sas_Seven 

echo "Executa o dedup do MNT"
#nohup ./dedup_check.sh $1 MNT iso-8859-1 http://dedup.bireme.org/services lilacs_MNT LILACS_MNT_Four &> $DIROUTS/$1/out_MNT.txt &
./dedup_check.sh $1 MNT iso-8859-1 http://dedup.bireme.org/services lilacs_MNT LILACS_MNT_Four

echo "Executa o dedup do MNTam"
#nohup ./dedup_check.sh $1 MNTam iso-8859-1 http://dedup.bireme.org/services lilacs_MNTam LILACS_MNTam_Five &> $DIROUTS/$1/out_MNTam.txt &
./dedup_check.sh $1 MNTam iso-8859-1 http://dedup.bireme.org/services lilacs_MNTam LILACS_MNTam_Five 

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

