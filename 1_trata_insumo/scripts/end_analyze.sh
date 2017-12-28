#!/bin/bash
# -------------------------------------------------------------------------- #
# analyze.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
#
#     Chamada : analyze.sh
#     Exemplo : ./analyze.sh <FI>
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

# Verifica passagem obrigatoria de 2 parametro
if [ "$#" -ne "3" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> <arquivo intermediario>"
  echo "Exemplo: $0 bbo wrk_OK lil_OK"
  exit 0
fi

echo "  -> Base origem"
# Verifica se existe arquivo inicial
if [ ! -f $DIRWORK/${1}/$3.iso ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRWORK/${1}/$3.iso ]"; exit 0
else
  echo "  OK - $DIRWORK/${1}/$3.iso"
fi

echo
echo "INICIO ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Analise"

echo "Area de trabalho"
cd $DIRDATA/${1}

echo "Gera o master"
$DIRISIS/mx iso=$DIRWORK/${1}/$3.iso create=$3

echo "Gera o relatorio do mxf0"
$DIRISIS/mxf0 $3 create=$3_analise

$DIRISIS/mx $3_analise "pft='File= 'v1001/'Date= 'v1003/'Total= 'v1009/(v1020^t,'|'v1020^d,'|'v1020^l'|',v1020^u,'|'v1020^n/)##" -all now >$DIROUTS/$1/end_analysis_$1.txt

echo "Tipo de documento"
$DIRISIS/mx $DIRWORK/${1}/$3 "tab=v5/" -all now lw=0 >$DIROUTS/$1/end_analysis_type_$1.txt

echo "Lista de titulo de Revistas"
$DIRISIS/mx $DIRWORK/${1}/$3 "tab=if v6='as' and p(v30) then v30/ fi" -all now lw=0 >$DIROUTS/$1/end_analysis_title_$1.txt

echo "CC Title"
$DIRISIS/mx $DIRWORK/${1}/$2 "tab=if p(v901) or p(v902) then if p(v902) and not v1=v902 then v1'|'v901'|'v902'|'v930/ fi,fi" -all now lw=0 >$DIROUTS/$1/end_analysis_cc_title_$1.txt

echo "Tipo de publicacao nao LILACS"
$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if a(v905) then v2'|CPO0O5|'v5/ fi,if a(v906) then v2'|CPO006|'v6/ fi" -all now lw=0 >$DIROUTS/$1/end_analysis_type_nivel_$1.txt

echo "Pais de publicacao"
$DIRISIS/mx $DIRWORK/${1}/$3 "tab=(v67/)" -all now lw=0 >$DIROUTS/$1/end_analysis_pubcountry_$1.txt

echo "Pais de afiliacao"
$DIRISIS/mx $DIRWORK/${1}/$3 "tab=(v10^p/)(v16^p/)(v23^p/)" lw=0 -all now >$DIROUTS/$1/end_analysis_afilcountry_$1.txt

$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if nocc(v910)=nocc(v10) then else v2/(v10/)(v910/)# fi" -all now lw=0 >$DIROUTS/$1/end_analysis_afil_10_$1.txt
$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if p(v10) and a(v910) then v2'|'(v10/)# fi" -all now lw=0 >>$DIROUTS/$1/end_analysis_afil_10_$1.txt

$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if nocc(v916)=nocc(v16) then else v2/(v16/)(v916/)# fi" -all now lw=0 >$DIROUTS/$1/end_analysis_afil_16_$1.txt
$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if p(v16) and a(v916) then v2'|'(v16/)# fi" -all now lw=0 >>$DIROUTS/$1/end_analysis_afil_16_$1.txt

$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if nocc(v923)=nocc(v23) then else v2/(v23/)(v923/)# fi" -all now lw=0 >$DIROUTS/$1/end_analysis_afil_23_$1.txt
$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if p(v23) and a(v923) then v2'|'(v23/)# fi" -all now lw=0 >>$DIROUTS/$1/end_analysis_afil_23_$1.txt

$DIRISIS/mx $DIRWORK/${1}/$2 "pft=if p(v914) then if v14=v914 then else v2'|v14: 'v14'|v914: 'v914/ fi,fi" -all now lw=0 >$DIROUTS/$1/end_analysis_page_14_$1.txt

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


