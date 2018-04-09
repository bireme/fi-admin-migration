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
if [ "$#" -ne "6" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $1 Nome do diretorio do lote <sci_201710 | bbo>"
  echo "Use: $2 Tipo de formato pipe <Sas | MNT | MNTam | SciELO>"
  echo "Use: $3 Encode <iso-8859-1 | utf-8>"
  echo "Use: $4 DeDupBaseUrl - DeDup url service "
  echo "      <http://serverofi5.bireme.br:8180/DeDup/services | http://dedup.bireme.org/services> "
  echo "Use: $5 indexName DeDup index name <lilacs_Sas | lilacs_MNT | lilacs_MNTam>"
  echo "Use: $6 schemaName DeDup schema name <LILACS_Sas_Seven | LILACS_MNT_Four | LILACS_MNTam_Five>"
  exit 0
fi


#Ajustando variaveis para processamento
source /bases/fiadmin2/DeDup/config/settings.inc

## -------------------------------------------------------------------------- #

echo "Gera Arquivo para checagem de Duplicacao!"
echo "Diretorio de processamento $DEDUP"
echo "Diretorio de trabalho e arquivo $DIRWRK/$1/in_$1.txt"
echo "Formato utilizado"
echo "pft=if v5.1='S' then s1:=(if p(v10) then (|//@//|+v10^*) else (|//@//|+v11^*) fi), s3:=(v30^*),(if p(v12) then 'LILACS_Sas|',v2[1],'|',replace(v12^*,'|',''),'|',s3,'|',v65[1].4,'|',v31[1],'|',v32[1]'|',s1,'|',if v14[1]^*>'' then v14[1]^* fi,/ fi),(if p(v13) then 'LILACS_Sas|',v2[1],'|',replace(v13^*,'|',''),'|',s3,'|',v65[1].4,'|',v31[1],'|',v32[1]'|',s1,'|',if v14[1]^*>'' then v14[1]^* fi,/ fi),fi"

echo "Gera o txt de entrada para o check de duplicado"
echo "$GPIPE/GeraPipedFile_$2.sh $DIRWRK/$1/lil_OK $DIRWRK/$1/in_$1_$2.txt"
$GPIPE/GeraPipedFile_$2.sh $DIRWRK/$1/lil_OK $DIRWRK/$1/in_$1_$2.txt


if  test -s $DIRWRK/$1/in_$1_$2.txt; then 
	echo "Comando para check de DeDup $2"
	echo "$DEDUP/DoubleCheckDuplicated.sh $DIRWRK/$1/in_$1_$2.txt $3 $4 $5 $6 $DIRWRK/$1/out1_$1_$2.txt $DIRWRK/$1/out2_$1_$2.txt $DIRWRK/$1/out_ok_$1_$2.txt $3"
	$DEDUP/DoubleCheckDuplicated.sh $DIRWRK/$1/in_$1_$2.txt $3 $4 $5 $6 $DIRWRK/$1/out1_$1_$2.txt $DIRWRK/$1/out2_$1_$2.txt $DIRWRK/$1/out_ok_$1_$2.txt $3
else
        echo "NÃO TEM REGISTROS DO TIPO $2"
fi

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

