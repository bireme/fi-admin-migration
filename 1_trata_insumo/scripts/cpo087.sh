#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo087.sh - Realiza conversao de registro LILACS para versao 1.7           #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo087.sh  
#     Exemplo : ./cpo087.sh <FI>
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
  echo "Exemplo: $0 bbo cpo002 cpo087"
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

echo "087 Descritores Primario"
$DIRISIS/mx seq=$DIRTAB/gDescSub.seq create=gDescSub -all now
$DIRISIS/mx seq=$DIRTAB/gizesp.seq create=gizesp -all now

[ -s $DIROUTS/$1/Descritoresprimarios.txt ] && rm $DIROUTS/$1/Descritoresprimarios.txt

echo "Se presente descritor secundario e ausente primario"
$DIRISIS/mx $2 "pft=if p(v88) and a(v87) then v776^i/ fi" -all now >$DIROUTS/$1/SEM_DescPr.txt

echo "Quantidade inicial de descritores primairos"
$DIRISIS/mx $2 "pft=(v87/)" lw=0 -all now | wc -l >$DIROUTS/$1/Descritoresprimarios.txt

echo "Gizmo para arrumar os subcampos d e s"
$DIRISIS/mx $2 gizmo=gDescSub,87 create=$3_1 -all now

echo "Tirar os espaços em branco do meio"
$DIRISIS/mx $3_1 gizmo=gizesp,87 create=$3_2 -all now

echo "Coloca o subcampos d no começo se não tiver"
$DIRISIS/mx $3_2 "proc=if p(v87) then 'd87',('<87>'if not v87.1='^' then '^d' fi,v87'</87>') fi" create=$3_3 -all now

echo "Troca a / por subcampos s"
$DIRISIS/mx $3_3 "proc=if p(v87) then 'd87',('<87>'replace(v87,'/','^s')'</87>') fi" create=$3_4 -all now

$DIRISIS/mx $3_4 "proc=if p(v87) then ,(if s(mpu,v87,mpl)='^DBIREME' then if nocc(v87)=1 then 'd87' fi else if s(mpu,v87.2,mpl)='^D' then if v87.2='^D' then '<987 0>^d'v87*2'</987>' else '<987 0>'v87'</987>' fi, else if v87.1='^' then '<987 0>^d'v87*1'</987>' else '<987 0>^d'v87'</987>' fi,fi,fi)fi" create=$3_5 -all now

echo "Transforma em ingles autorizado o campo da base migrada"
$DIRISIS/mx $3_5 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "proc='d987',(if p(v987) then '<987>^t'ref(['$DECS/decs']l(['$DECS/decs']s(mpu,v987^d,mpl)),v1), if p(v987^s) or p(v987^S) then '^c'ref(['$DECS/decs']l(['$DECS/decs']'/'s(mpu,v987^s,mpl)),v11*1) fi,v987'</987>' fi)" create=$3_6 -all now

echo "Gera o com o campo de historico depois que a checagem os historicos"
$DIRISIS/mx $3_6 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "proc='d987',if p(v987) then (if v987*2.1='^' then '<987>^h'ref(['$DECS/decs']l(['$DECS/decs']s(mpu,'HIS_'v987^d,mpl)),v1),if p(v987^s) then '^c',ref(['$DECS/decs']l(['$DECS/decs']'/'s(mpu,v987^s,mpl)),v11*1) fi,|^d|v987^d,|^s|v987^s '</987>'else '<987>'v987'</987>', fi) fi"  create=$3_7 -all now

echo "Relatorios"
$DIRISIS/mx $3_7 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "pft=(if p(v987^h) and not v987*2.1='^' then mfn'|'v776[1]'|'v987 fi/)" -all now lw=0 >$DIROUTS/$1/Rel_desc_hist.txt
$DIRISIS/mx $3_7 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "pft=(if v987*2.1='^' then mfn'|'v776[1]'|'v987 fi/)" -all now lw=0 >$DIROUTS/$1/Rel_ID_NODeCS.txt
$DIRISIS/mx $3_7 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "tab=(if v987*2.1='^' then v987^d fi/)" -all now lw=0 >$DIROUTS/$1/Rel_NODeCS.txt

echo "Arruma o campo 987 para descritores DeCS e 887 para não DeCS"
$DIRISIS/mx $3_7 "proc='d887d987',(if p(v987) then if v987*2.1='^' then '<887>^n'v987^d,|^s|v987^s'</887>' else '<987>^d'if p(v987^t) then v987^t else v987^h fi |^s|v987^c'</987>' fi,fi/)" -all now create=$3_8

echo "Incluir um gizmo especifico"


echo "Cria master e ISO"
$DIRISIS/mx $3_8 "proc='S'" create=$3 -all now


echo "Quantidade final de descritores primairos"
$DIRISIS/mx $3 "pft=(v87/)" lw=0 -all now | wc -l >>$DIROUTS/$1/Descritoresprimarios.txt
$DIRISIS/mx $3 "pft=(v887/)" lw=0 -all now | wc -l >>$DIROUTS/$1/Descritoresprimarios.txt
$DIRISIS/mx $3 "pft=(v987/)" lw=0 -all now | wc -l >>$DIROUTS/$1/Descritoresprimarios.txt


echo "Gera o arquivo iso para join"
$DIRISIS/mx $3 "proc='d*',if p(v987) or p(v887) then |<2 0>|v2|</2>|,(|<887>|v887|</887>|),(|<987>|v987|</987>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=5000

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
