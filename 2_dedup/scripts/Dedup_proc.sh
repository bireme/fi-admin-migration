#!/bin/bash
# -------------------------------------------------------------------------- #
# Dedup_proc.sh  - Checa se os registro estão duplicados utilizando o DeDup  #
# -------------------------------------------------------------------------- #
#
#     Chamada : Dedup_proc.sh                                                #
#     Exemplo : ./Dedup_proc.sh <nome do diretorio do lote>                  #
#                               <iso-8859-1/utf-8>                           #
#                               <Sas|MNT|MNTam>                              #
#                               <Seven|Four|Five>                            #
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
if [ "$#" -ne "4" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <nome do diretorio do lote> <iso-8859-1/utf-8> <Sas|MNT|MNTam> <Seven|Four|Five>"
  echo "Exemplo: $0 bbo iso-8859-1 Sas Seven"
  exit 0
fi


# JAVA_HOME=/usr/local/oracle-8-jdk

DIRISIS=/usr/local/bireme/cisis/5.7c/linux64/ffiG_1024K-256
DEDUP=/home/javaapps/sbt-projects/DCDup
DIRRAIZ=/bases/fiadmin2/DeDup
DIRDATA=$DIRRAIZ/data/$1
DIRWRK=$DIRRAIZ/wrk/$1
DIROUTS=$DIRRAIZ/outs/$1

# ------------------------------------------------------------------------- #
# Ajustes de ambiente

[ -d $DIROUTS ] || mkdir $DIROUTS

## -------------------------------------------------------------------------- #
##

echo "Gera Arquivo para checagem de Duplicacao!"
echo "Diretorio de processamento $DEDUP"
echo "Diretorio de trabalho e arquivo $DIRWRK/in_$1.txt   "

$DEDUP/GeraPipedFile_$3.sh $DIRWRK/$1_LILACS $DIRWRK/in_$1_$3.txt

echo "Comando para check de DeDup LILACS_$3_$4 fileout $3_out_$1"

$DEDUP/WebDoubleCheckDuplicated.sh $DIRWRK/in_$1_$3.txt $2 http://serverofi5.bireme.br:8180/DeDup/services lilacs_$3 LILACS_$3_$4 $DIROUTS/$3_out1.txt $DIROUTS/$3_out2.txt $DIROUTS/$3_outok.txt $2

echo
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

