#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo088.sh - Realiza conversao de registro LILACS para versao 1.7           #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo088.sh  
#     Exemplo : ./cpo088.sh <FI>
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
  echo "Exemplo: $0 bbo cpo071 cpo088"
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

echo "088 Descritores Secundario"
echo "Traz os gizmo do Tabs"
$DIRISIS/mx seq=$DIRTAB/gDescSub.seq create=gDescSub -all now
$DIRISIS/mx seq=$DIRTAB/gizesp.seq create=gizesp -all now

echo "Quantidade inicial de descritores Secundario"
$DIRISIS/mx $2 "pft=(v88/)" lw=0 -all now | wc -l >$DIROUTS/$1/Descritoressecundario.txt

$DIRISIS/mx $2 gizmo=gDescSub,88 create=$3_1 -all now

echo "Tirar os espaços em branco do meio"
$DIRISIS/mx $2 gizmo=gizesp,88 create=$3_1 -all now

echo "Gizmo para arrumar os subcampos d e s"
$DIRISIS/mx $3_1 gizmo=gDescSub,88 create=$3_2 -all now

echo "Coloca o subcampos d no começo se não tiver"
$DIRISIS/mx $3_2 "proc=if p(v88) then 'd88',('<88>'if not v88.1='^' then '^d' fi,v88'</88>') fi" create=$3_3 -all now

echo "Troca a / por subcampos s"
$DIRISIS/mx $3_3 "proc=if p(v88) then 'd88',('<88>'replace(v88,'/','^s')'</88>') fi" create=$3_4 -all now

echo "Transforma em ingles autorizado o campo da base migrada"
$DIRISIS/mx $3_4 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "proc='d988',(if p(v88) then '<988>^t'ref(['$DECS/decs']l(['$DECS/decs']s(mpu,v88^d,mpl)),v1), if p(v88^s) or p(v88^S) then '^c'ref(['$DECS/decs']l(['$DECS/decs']'/'s(mpu,v88^s,mpl)),v11*1) fi,v88'</988>' fi)" create=$3_5 -all now

echo "Gera o com o campo de historico depois que a checagem os historicos"
$DIRISIS/mx $3_5 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "proc='d988',if p(v988) then (if v988*2.1='^' then '<988>^h'ref(['$DECS/decs']l(['$DECS/decs']s(mpu,'HIS_'v988^d,mpl)),v1),if p(v988^s) then '^c',ref(['$DECS/decs']l(['$DECS/decs']'/'s(mpu,v988^s,mpl)),v11*1) fi,|^d|v988^d,|^s|v988^s '</988>'else '<988>'v988'</988>', fi) fi"  create=$3_6 -all now

echo "Relatorios"
$DIRISIS/mx $3_6 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "pft=(if p(v988^h) and not v988*2.1='^' then mfn'|'v776[1]'|'v988 fi/)" -all now lw=0 >$DIROUTS/$1/Rel_desc_hist.txt
$DIRISIS/mx $3_6 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "pft=(if v988*2.1='^' then mfn'|'v776[1]'|'v988 fi/)" -all now lw=0 >$DIROUTS/$1/Rel_ID_NODeCS.txt
$DIRISIS/mx $3_6 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "tab=(if v988*2.1='^' then v988^d fi/)" -all now lw=0 >$DIROUTS/$1/Rel_NODeCS.txt

echo "Arruma o campo 988 para descritores DeCS e 888 para não DeCS"
$DIRISIS/mx $3_6 "proc='d888d988',(if p(v988) then if v988*2.1='^' then '<888>^n'v988^d,|^s|v988^s'</888>' else '<988>^d'if p(v988^t) then v988^t else v988^h fi |^s|v988^c'</988>' fi,fi/)" -all now create=$3_7

echo "Cria master e ISO"
$DIRISIS/mx $3_7 "proc='S'" create=$3 -all now


echo "Quantidade final de descritores primairos"
$DIRISIS/mx $3 "pft=(v88/)" lw=0 -all now | wc -l >>$DIROUTS/$1/Descritoressecundario.txt
$DIRISIS/mx $3 "pft=(v888/)" lw=0 -all now | wc -l >>$DIROUTS/$1/Descritoressecundario.txt
$DIRISIS/mx $3 "pft=(v988/)" lw=0 -all now | wc -l >>$DIROUTS/$1/Descritoressecundario.txt


echo "Gera o arquivo iso para join"
$DIRISIS/mx $3 "proc='d*',if p(v988) or p(v888) then |<2 0>|v2|</2>|,(|<888>|v888|</888>|),(|<988>|v988|</988>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=5000


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
