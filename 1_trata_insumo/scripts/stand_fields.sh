#!/bin/bash
# -------------------------------------------------------------------------- #
# stand_fields.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
#
#     Chamada : stand_fields.sh
#     Exemplo : ./stand_fields.sh <FI> 
#
# -------------------------------------------------------------------------- #
#  Centro Latino-Americano e do Caribe de InformaÃ§Ã£o em CiÃªncias da SaÃºde
#     Ã© um centro especialidado da OrganizaÃ§Ã£o Pan-Americana da SaÃºde,
#           escritÃ³rio regional da OrganizaÃ§Ã£o Mundial da SaÃºde
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

# Verifica passagem obrigatoria de 1 parametro
if [ "$#" -ne "1" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> "
  echo "Exemplo: $0 bbo "
  exit 0
fi
# -------------------------------------------------------------------------- #
echo "Inicio do processamento - stand_fields.sh"

echo "Primeiro Nivel `date '+%Y.%m.%d %H:%M:%S'`"
#./cpo002.sh $1 01_lil cpo002
$DIRDATA/$1/fields_scritp001.sh

echo "Segundo Nivel `date '+%Y.%m.%d %H:%M:%S'`"
$DIRDATA/$1/fields_scritp002.sh
#./cpo004.sh $1 cpo002 cpo004
#./cpo040.sh $1 cpo002 cpo040
#./cpo071.sh $1 cpo002 cpo071
#./cpo001.sh $1 cpo002 cpo001
#./cpo005.sh $1 cpo002 cpo005
#./cpo010.sh $1 cpo002 cpo010
#./cpo014.sh $1 cpo002 cpo014
#./cpo016.sh $1 cpo002 cpo016
#./cpo023.sh $1 cpo002 cpo023
#./cpo038.sh $1 cpo002 cpo038
#./cpo057.sh $1 cpo002 cpo057
#./cpo067.sh $1 cpo002 cpo067
#./cpo083.sh $1 cpo002 cpo083
#./cpo091.sh $1 cpo002 cpo091
#./cpo087.sh $1 cpo002 cpo087
#./cpo111.sh $1 cpo002 cpo111 
#./cpo112.sh $1 cpo002 cpo112
#./cpo114.sh $1 cpo002 cpo114
#./cpo115.sh $1 cpo002 cpo115
#./cpo700.sh $1 cpo002 cpo700

echo "Terceiro Nivel `date '+%Y.%m.%d %H:%M:%S'`"
$DIRDATA/$1/fields_scritp003.sh
#./cpo008.sh $1 cpo040 cpo008
#./cpo065.sh $1 cpo004 cpo065
#./cpo006.sh $1 cpo005 cpo006
#./cpo012.sh $1 cpo040 cpo012
#./cpo018.sh $1 cpo040 cpo018
#./cpo025.sh $1 cpo040 cpo025
#./cpo088.sh $1 cpo071 cpo088

echo "Quarto Nivel `date '+%Y.%m.%d %H:%M:%S'`" 
$DIRDATA/$1/fields_scritp004.sh
#./cpo009.sh $1 cpo008 cpo009
#./cpo113.sh $1 cpo006 cpo113
#./cpo030.sh $1 cpo065 cpo030

echo "Quinto Nivel `date '+%Y.%m.%d %H:%M:%S'`"
$DIRDATA/$1/fields_scritp005.sh
#./cpo110.sh $1 cpo009 cpo110


# ---------------------------------------------------------------------------#

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

