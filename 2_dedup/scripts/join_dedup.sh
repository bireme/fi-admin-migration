#!/bin/bash
# -------------------------------------------------------------------------- #
# join_dedup.sh - Checa se os registro estão duplicados utilizando o DeDup  #
# -------------------------------------------------------------------------- #
#
#     Chamada : join_dedup.sh
#     Exemplo : ./join_dedup.sh <Diretorio> <iso-8859-1/utf-8>
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

# Verifica passagem obrigatoria de 3 parametro
if [ "$#" -ne "3" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 Nome do diretorio do lote <sci_201710 | bbo> Tipo de check <Sas | MNT | MNTam> file in <$DIRTRAT/lil_OK | lil_Sas | lil_MNT >"
  exit 0
fi

# Ajustando variaveis para processamento
source /bases/fiadmin2/DeDup/config/settings.inc

## -------------------------------------------------------------------------- #

cd $DIRWRK/$1

echo "Join OUT1"
echo ~$DIRISIS/mx $3 "join=out1_$2_wrk2,995:101='001_'v2" "join=out1_$2_wrk2,994:1='101_'s(mpu,v2,mpl)" "proc='d32001d32002'" create=lil_wrk1_$2 -all now tell=1000~
$DIRISIS/mx $3 "join=out1_$2_wrk2,995:101='001_'v2" "join=out1_$2_wrk2,994:1='101_'s(mpu,v2,mpl)" "proc='d32001d32002'" create=lil_wrk1_$2 -all now tell=$VTELL

echo "Join OUT2"
echo ~$DIRISIS/mx lil_wrk1_$2 "join=out2_$2,996:4,997:2=s(mpu,v2,mpl)" "proc='d32001'" create=lil_wrk2_$2 -all now tell=1000~
$DIRISIS/mx lil_wrk1_$2 "join=out2_$2,996:4,997:2=s(mpu,v2,mpl)" "proc='d32001'" create=lil_wrk2_$2 -all now tell=$VTELL

echo "Join OUT_OK"
echo ~$DIRISIS/mx lil_wrk2_$2 "join=out_ok_$2,998:2=s(mpu,v2,mpl)" "proc='d32001'" create=lil_$2 -all now tell=1000~
$DIRISIS/mx lil_wrk2_$2 "join=out_ok_$2,998:2=s(mpu,v2,mpl)" "proc='d32001'" create=lil_$2 -all now tell=$VTELL

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

