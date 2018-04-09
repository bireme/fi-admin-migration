#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo008.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo008.sh  
#     Exemplo : ./cpo008.sh <FI>
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

# Verifica passagem obrigatoria de 3 parametro
if [ "$#" -ne "3" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> <file_in> <file_out>"
  echo "Exemplo: $0 bbo cpo040 cpo008"
  exit 0
fi

echo " ----------------------------------------------------------------------------------------------------------- "

echo "  -> Base origem"
# Verifica se existe arquivo inicial
if [ ! -f $DIRDATA/${1}/$2.mst ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/${1}/$2.mst ]"; exit 0
else
  echo "  OK - $DIRDATA/${1}/$2.mst"
fi

echo "Area de trabalho"
cd $DIRDATA/${1}

echo
echo "INICIO DOS AJUSTES ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Descricao"

echo "008 URL - Gizmo Intranet Subcampo u e i"
cp $DIRTAB/gizcpo008.seq .
$DIRISIS/mx seq=gizcpo008.seq create=gizcpo008 -all now

$DIRISIS/mx $2 gizmo=gizcpo008,8 "proc='d8',(if s(mpu,v8^*,mpl):'@' then '<995 0>E-mail: 'v8'</995>' else |<8 0>|v8|</8>| fi,)" create=$3_1  -all now

echo "008 URL - Tira os registros que tem CD-ROM e Disquete do campo 8 para o 38 e Nota [500] informações adicionais"
$DIRISIS/mx $3_1 "proc='d908',(if p(v8) then if s(mpu,v8^*,mpl)='CD-ROM' or s(mpu,v8^*,mpl)='CR-ROM' then if p(v8^i) or p(v8^a) then '<938 0>^aCD-ROM</938>','<995 0>Inf. do CD-ROM: 'if p(v8^i) then v8^i else v8^a fi'</995>' else '<938 0>^aCD-ROM</938>' fi, else if s(mpu,v8^*,mpl)='DISQUETE' then '<938 0>^aDisquete</938>', else if size(v8)>22 then if s(mpu,v8,mpl):'INTERNET' and p(v8^i) then '<908 0>^u'v8^i'</908>' else if size(v8^i)>3 then '<908 0>^u'v8^i'</908>' else |<908 0>|v8|</908>| fi,fi,fi,fi,fi,fi)" create=$3_2 -all now

echo "008 URL - Arruma os subcampos controlados - Idioma ^i - Extensao ^q - Tipo ^y"
#echo "$DIRISIS/mx cpo008_2 "proc='d908',(if p(v908^u) then if s(mpu,v908^*,mpl):'PDF' then '<908 0>^u'v908^u,'^yPDF^qpdf','^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' else if s(mpu,v908^*,mpl):'HTM' then '<908 0>^u'v908^u,'^yHTM^qhtm','^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' else if s(mpu,v908^*,mpl):'PHP' then '<908 0>^u'v908^u,'^yHTM^qphp','^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' else '<908 0>^u'v908^u,|^q|v908^q,|^y|v908^y,'^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' fi,fi,fi, else if p(v908) then if v908:'^' then  '<908 0>'v908'</908>' else '<908 0>^u'v908'</908>' fi, fi, fi)" create=cpo008_3 -all now tell=5000"

$DIRISIS/mx $3_2 "proc='d908',(if p(v8) then if p(v908^u) then if s(mpu,v908^*,mpl):'PDF' then '<908 0>^u'v908^u,'^yPDF^qpdf','^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' else if s(mpu,v908^*,mpl):'HTM' then '<908 0>^u'v908^u,'^yHTM^qhtm','^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' else if s(mpu,v908^*,mpl):'PHP' then '<908 0>^u'v908^u,'^yHTM^qphp','^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' else '<908 0>^u'v908^u,|^q|v908^q,|^y|v908^y,'^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' fi,fi,fi, else if p(v908) then if v908:'^' then  '<908 0>'v908'</908>' else if s(mpu,v908^*,mpl):'PDF' then '<908 0>^u'v908,'^yPDF^qpdf','^i',if p(v908^i) then v908^i else v940[1] fi,|^g|v908^g,|^s|v908^s'</908>' else '<908 0>^u'v908,'^yHTM^qhtm','^i',if p(v908^i) then v908^i else v940[1] fi,'</908>' fi,fi,fi,fi,fi)" create=$3_3 -all now tell=5000

echo "008 URL - coloca http nas URLs que começam com o WWW"
$DIRISIS/mx $3_3 "proc='d908',(if v908^u.4='www.' then '<908 0>',replace(v908,'^uwww.','^uhttp://www.'),'</908>' else if v908^u.3='ww.' then '<908 0>',replace(v908,'^uww.','^uhttp://www.'),'</908>' else if v908^u.5='www2.' then '<908 0>',replace(v908,'^uwww2.','^uhttp://www2.'),'</908>' else |<908 0>|v908|</908>| fi,fi,fi)" create=$3_4 -all now tell=5000

echo "Especifido ca BBO"
$DIRISIS/mx $3_4 "proc=if v8:'^u^u' then 'd8d908',if p(v888^u) then '<908 0>'v888'</908>' fi,fi" create=$3_5 -all now

echo "008 URL - Cria master"
$DIRISIS/mx $3_5 "proc='S'" create=$3 -all now tell=10000

echo "008 URL - Cria ISO somento com ID e os campos alterados"
$DIRISIS/mx $3 "proc='d*',if p(v908) or p(v938) or p(v995) then |<2 0>|v2|</2>|,(|<908>|v908|</908>|),(|<938>|v938|</938>|)(|<995>|v995|</995>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000

echo
echo "TERMINO DOS AJUSTES ##########################################################################################"

echo "-------------------------------------------------------------------------"o
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
