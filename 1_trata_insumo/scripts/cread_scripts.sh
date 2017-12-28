#!/bin/bash
# -------------------------------------------------------------------------- #
# cread_scripts.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
#
#     Chamada : cread_scripts.sh
#     Exemplo : ./cread_scripts.sh <FI>
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
vrs:  1.00 20171203, Ana Katia Camilo
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
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso>"
  echo "Exemplo: $0 bbo"
  exit 0
fi

#echo "  -> Base origem"
# Verifica se existe arquivo inicial
#if [ ! -f $DIRDATA/${1}/$2.mst ]; then
#  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/${1}/$2.mst ]"; exit 0
#else
#  echo "  OK - $DIRDATA/${1}/$2.mst"
#fi

echo
echo "INICIO ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Analise"

echo "Area de trabalho"
cd $DIRDATA/${1}

echo "Gera o Scripts dos campos de check"
$DIRISIS/mx script_fields "pft=if v8='001' and p(v100) then '$RAIZ/scripts/'v7'.sh $1 'v4' 'v7/ fi" -all now lw=0 >$DIRDATA/$1/fields_scritp001.sh
$DIRISIS/mx script_fields "pft=if v8='002' and p(v100) then '$RAIZ/scripts/'v7'.sh $1 'v4' 'v7/ fi" -all now lw=0 >$DIRDATA/$1/fields_scritp002.sh
$DIRISIS/mx script_fields "pft=if v8='003' and p(v100) then '$RAIZ/scripts/'v7'.sh $1 'v4' 'v7/ fi" -all now lw=0 >$DIRDATA/$1/fields_scritp003.sh
$DIRISIS/mx script_fields "pft=if v8='004' and p(v100) then '$RAIZ/scripts/'v7'.sh $1 'v4' 'v7/ fi" -all now lw=0 >$DIRDATA/$1/fields_scritp004.sh
$DIRISIS/mx script_fields "pft=if v8='005' and p(v100) then '$RAIZ/scripts/'v7'.sh $1 'v4' 'v7/ fi" -all now lw=0 >$DIRDATA/$1/fields_scritp005.sh

echo "Da permissao"
[ -s $DIRDATA/$1/fields_scritp001.sh ] && chmod 777 $DIRDATA/$1/fields_scritp001.sh
[ -s $DIRDATA/$1/fields_scritp002.sh ] && chmod 777 $DIRDATA/$1/fields_scritp002.sh
[ -s $DIRDATA/$1/fields_scritp003.sh ] && chmod 777 $DIRDATA/$1/fields_scritp003.sh
[ -s $DIRDATA/$1/fields_scritp004.sh ] && chmod 777 $DIRDATA/$1/fields_scritp004.sh
[ -s $DIRDATA/$1/fields_scritp005.sh ] && chmod 777 $DIRDATA/$1/fields_scritp005.sh

echo "----------------------------------------------------------------------------------------"

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


