#!/bin/bash
# -------------------------------------------------------------------------- #
# initial_analyze.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
#
#     Chamada : initial_analyze.sh
#     Exemplo : ./initial_analyze.sh <FI>
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
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> <file in>"
  echo "Exemplo: $0 bbo 01_lil"
  exit 0
fi

echo "  -> Base origem"
# Verifica se existe arquivo inicial
if [ ! -f $DIRDATA/${1}/$2.mst ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/${1}/$2.mst ]"; exit 0
else
  echo "  OK - $DIRDATA/${1}/$2.mst"
fi

echo
echo "INICIO ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Analise"

echo "Area de trabalho"
cd $DIRDATA/${1}

echo "Gera o relatorio do mxf0"
$DIRISIS/mxf0 $2 create=$2_analise

$DIRISIS/mx $2_analise "pft='File= 'v1001/'Date= 'v1003/'Total= 'v1009/(v1020^t,'|'v1020^d,'|'v1020^l'|',v1020^u,'|'v1020^n/)##" -all now >$DIROUTS/$1/initial_analysis_$1.txt

echo "Campos validos e campos de processamento"
$DIRISIS/mx $2_analise "pft=(v1020^t/)" -all now lw=0 >fields_teste.txt
$DIRISIS/mx seq=fields_$1.txt create=fields_$1 -all now

$DIRISIS/mx seq=$DIRTAB/tab_fields.txt create=tab_fields -all now
$DIRISIS/mx tab_fields "fst=1 0 v1/" fullinv=tab_fields

$DIRISIS/mx fields_$1 "join=tab_fields,2=v1/" "proc='d32001" create=fields_$1_001 -all now 

$DIRISIS/mx fields_$1_001 "pft=if a(v2) then v1/ fi" -all now lw=0 >$DIROUTS/$1/fields_noLILACS_$1.txt
$DIRISIS/mx fields_$1_001 "pft=if v2='p' then v1/ fi" -all now lw=0 >$DIROUTS/$1/fields_proc_$1.txt

$DIRISIS/mx fields_$1_001 "fst=1 0 if v2='l' then v1/ fi" fullinv=fields_$1_001 
$DIRISIS/mx tab_fields "join=fields_$1_001,100:1=v1/" "proc='d32001" create=script_fields -all now

$DIRISIS/mx script_fields "pft=if v3='c' and p(v100) then v1'|'v4'|'v5'|'v6'|'v7'|'v8/ fi" -all now lw=0 >$DIROUTS/$1/fields_scritp_$1.txt

echo "Tipo de documento"
$DIRISIS/mx $2 "tab=v5/" -all now >$DIROUTS/$1/initial_analysis_type_$1.txt

echo "Nivel de tratamento"
$DIRISIS/mx $2 "tab=v6/" -all now >$DIROUTS/$1/initial_analysis_nivel_$1.txt

echo "Lista de titulo de Revistas"
$DIRISIS/mx $2 "tab=if v6='as' and p(v30) then v30/ fi" -all now lw=0 >$DIROUTS/$1/initial_analysis_title_$1.txt

echo "Pais de publicacao"
$DIRISIS/mx $2 "tab=(v67/)" -all now lw=0 >$DIROUTS/$1/initial_analysis_pubcountry_$1.txt

echo "Pais do evento"
$DIRISIS/mx $2 "tab=(v57/)" -all now lw=0 >$DIROUTS/$1/initial_analysis_evencountry_$1.txt

echo "Pais de afiliacao"
$DIRISIS/mx $2 "tab=(v10^p/)(v16^p/)(v23^p/)" lw=0 -all now >$DIROUTS/$1/initial_analysis_afilcountry_$1.txt

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


