#!/bin/bash
# -------------------------------------------------------------------------- #
# trata_insumo.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
#
#     Chamada : trata_insumo.sh
#     Exemplo : ./trata_insumo.sh <FI>
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
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> "
  echo "Exemplo: $0 bbo "
  exit 0
fi

echo
echo "INICIO ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"

echo "Cria os diretorios necessario para o processamento"

[ ! -d $DIRDATA/${1} ] && mkdir $DIRDATA/${1}
[ ! -d $DIRWORK/${1} ] && mkdir $DIRWORK/${1}
[ ! -d $DIROUTS/${1} ] && mkdir $DIROUTS/${1}

echo "Vai para o diretorio dos Scripts $RAIZ/scripts"
cd $RAIZ/scripts

echo "Limpeza"
./clean_all.sh $1

echo "Analise inicial" 
./initial_analyze.sh $1 01_lil

echo "Monta os scripts necessarios"
./cread_scripts.sh $1

echo "Apaga campos utilizados no processamento"
./clean_fields.sh $1 01_lil

echo "Executa por campos"
./stand_fields.sh $1

echo "Cria Master"
./cread_master.sh $1

echo "Inverte"
./index_master.sh $1

echo "Join"
./join_fields.sh $1

echo "Cria arquivo de saida"
./file_out.sh $1

echo "Analise final"
cd $RAIZ/scripts
./end_analyze.sh $1 wrk_OK lil_OK

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


