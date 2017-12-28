#!/bin/bash
# -------------------------------------------------------------------------- #
# clean_fields.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
#
#     Chamada : clean_fields.sh
#     Exemplo : ./clean_fields.sh <FI>
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

# Verifica passagem obrigatoria de 2 parametro
if [ "$#" -ne "2" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> <file_in>"
  echo "Exemplo: $0 bbo 01_lil" 
  exit 0
fi

echo "INICIO ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Analise  -> Inicio"
# Verifica se existe arquivo inicial

if [ ! -f $DIROUTS/$1/fields_proc_$1.txt ]; then
  echo "O Arquivo [ $DIROUTS/$1/fields_proc_$1.txt ] não bases usadas no processamento"; exit 0
else
   echo "Area de trabalho"
   cd $DIRDATA/${1}

   for i in $(< $DIROUTS/$1/fields_proc_$1.txt)
   do
      echo "Campo $i"
      $DIRISIS/mx $2 "proc=if p(v$i) then 'd$i','<61 0>Campo $i: 'v$i'</61>' fi" copy=$2 -all now 
   done
   echo "Limpa"
   $DIRISIS/mxcp $2 create=clean_$2 clean 
   echo "Ordena" 
   $DIRISIS/mx clean_$2 "proc='S'" create=$2 -all now
fi



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
