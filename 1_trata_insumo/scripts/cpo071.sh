#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo071.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo071migra_TEMPLATE.sh  
#     Exemplo : ./cpo071.sh <FI>
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
  echo "Exemplo: $0 bbo cpo002 cpo700"
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
echo "Indexacao"

echo "071 Tipo de Publicacao"
echo "076 Pre-codificados"
echo "Gera os arquivos para o gizmo"
$DIRISIS/mx seq=$DIRTAB/gResearcd.seq create=gResearcd -all now
$DIRISIS/mx seq=$DIRTAB/gtplil.seq create=gtplil -all now
$DIRISIS/mx seq=$DIRTAB/gpclil.seq create=gpclil -all now
$DIRISIS/mx seq=$DIRTAB/gpcbbo.seq create=gpcbbo -all now

$DIRISIS/mx seq=$DIRTAB/tpall.txt create=tpall -all now
$DIRISIS/mx seq=$DIRTAB/precod.txt create=precod -all now

$DIRISIS/mx tpall actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "fst=@$DIRTAB/tpall.fst" fullinv=tpall tell=10
$DIRISIS/mx precod actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "fst=@$DIRTAB/precod.fst" fullinv=precod tell=10

$DIRISIS/mx $2 gizmo=gResearcd,71 create=$3_1 -all now 
$DIRISIS/mx $3_1 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "proc='d71d76',if p(v71) then ('<71 0>'s(mpu,v71,mpl)'</71>') fi,if p(v76) then if s(mpu,v76,mpl):'^S' then else ('<76 0>'if v76.1:'^' then s(mpu,v76*2,mpl) else s(mpu,v76,mpl) fi'</76>') fi,fi"  "proc='s'" create=$3_2 -all now
$DIRISIS/mx $3_2 gizmo=gtplil,71 gizmo=gpclil,76 create=$3_3 -all now
$DIRISIS/mx $3_3 gizmo=gpcbbo,76 create=$3_4 -all now tell=5000
$DIRISIS/mx $3_4 "proc=if p(v76) then 'd76',(if v76='IN VITRO' then '<88 0>^dIn Vitro Techniques</88>' else if v76='ESTUDO COMPARATIVO' then '<971 0>Comparative Study</971>' else if s(mpu,v76,mpl):'RELATO DE CASO' then '<971 0>Case Reports</971>' else  if s(mpu,v76,mpl):'ADOLECENCIA' or s(mpu,v76,mpl):'ADOLESCENTS' then '<976 0>Adolescent</976>' else if s(mpu,v76,mpl):'FEMALE' then '<976 0>Female</976>' else if s(mpu,v76,mpl):'MALE' then '<976 0>Male</976>' else '<76 0>'v76'</76>' fi,fi,fi,fi,fi,fi)fi" "proc=if p(v71) then 'd71',(if s(mpu,v71,mpl)='IN VITRO' then '<88 0>^dIn Vitro Techniques</88>' else if s(mpu,v71,mpl)='RESUMO' then '<971 0>Abstracts</971>' else if s(mpu,v71,mpl)='CONGRESSO' then '<971 0>Congresses</971>' else if s(mpu,v71,mpl)='BIOGRAFICO' then '<971 0>Biography</971>' else if s(mpu,v71,mpl)='HISTORICO' then '<971 0>Historical Article</971>' else '<71 0>'v71'</71>' fi,fi,fi,fi,fi) fi" create=$3_5 -all now

$DIRISIS/mx $3_5 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "join=tpall,971:1=(s(mpu,v71,mpl)/)" "join=tpall,971:1=(s(mpu,v76,mpl)/)" "proc='d32001d32002'" create=$3_6 -all now

$DIRISIS/mx $3_6 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "join=precod,976:1=(s(mpu,v76,mpl)/)" "join=precod,976:1=(s(mpu,v71,mpl)/)" "proc='d32001d32002'" create=$3_7 -all now

$DIRISIS/mx $3_7 "proc=@$DIRTAB/lil071.prc" "proc=@$DIRTAB/lil076.prc" create=$3_8 -all now

echo "Cria Master"
$DIRISIS/mx $3_8 "proc='S'" create=$3 -all now

echo "Cria ISO"
$DIRISIS/mx $3 "proc='d*',if p(v971) or p(v976) then |<2 0>|v2|</2>|,(|<971>|v971|</971>|),(|<976>|v976|</976>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000

echo
echo "TERMINO DOS AJUSTES ##########################################################################################"

echo "-------------------------------------------------------------------------"
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
