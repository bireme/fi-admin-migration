#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo030.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo030.sh  
#     Exemplo : ./cpo030.sh <FI>
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
source /bases/fiadmin2/config/$1.inc
# -------------------------------------------------------------------------- #

echo "- Verificacoes iniciais"

# Verifica passagem obrigatoria de 3 parametro
if [ "$#" -ne "3" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> <file_in> <file_out>"
  echo "Exemplo: $0 bbo cpo065 cpo030"
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

echo "Serie"
cp $DIRTAB/g850ans.id .
cp $DIRTAB/gutf8ans.id .

$DIRISIS/id2i g850ans.id create=g850ans tell=100
$DIRISIS/id2i gutf8ans.id create=gutf8ans tell=100

echo "TITLE - Traz do diretorio da coleta"
$DIRISIS/mx iso=$DIRTITL/title.iso gizmo=g850ans create=tit -all now tell=1000
echo "TITLE - Cria o campo 160 com o titulo abreviado caixa alta sem acento"
$DIRISIS/mx tit actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "proc='d160','<160>'s(mpu,v150,mpl)'</160>'" create=title_wrk -all now

echo "TITLE - Limpa e ordena"
$DIRISIS/mxcp title_wrk create=title_cls clean
$DIRISIS/mx title_cls "proc='S'" create=title -all now

echo "TITLE - Inverte"
$DIRISIS/mx title fst=@$DIRTAB/title.fst fullinv=title tell=10000

echo "30 Titulo (Serie) - Check do Titulo/ISSN com a base Title pelo Titulo Abreviado [30](LILACS)/Titulo Abreviado [150](TITLE)"
$DIRISIS/mx $2 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "join=title,930:150,935:400,945:450=s(mpu,v30,mpl)/" "proc='s'" "proc='d32001'" create=$3_1 -all now

#TAB_CPO030
echo "Se tiver esse arquivo "
if [ -n "$TAB_CPO030" ]; then
        echo "Tem tabela de ISSN para corrigir o titulo da Revista do campo $3 e o nome do arquivo eh $TAB_CPO030"
        $DIRISIS/mx seq=$DIRTAB/$TAB_CPO030.txt create=$TAB_CPO030 -all now
        $DIRISIS/mx $TAB_CPO030 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "fst=1 0 s(mpu,v1,mpl)" fullinv=$TAB_CPO030
        $DIRISIS/mx $3_1  actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab "join=$TAB_CPO030,400:2=s(mpu,v30,mpl)" "proc='d32001'" create=$3_2a -all now
        $DIRISIS/mx $3_2a "pft=if p(v400) then v776^i'|'v30'|'v35/ fi" lw=0 -all now >$DIROUTS/$1/ListaNOtitle_$3.txt
        $DIRISIS/mx $3_2a "proc=if p(v400) then 'd35d400','<35>'v400[1]'</35>' fi" create=$3_2 -all now
else
        $DIRISIS/mx $3_1 "proc='S'" create=$3_2 -all now
fi

echo "Se tem o documento para o Gizmo $DIRTAB/cpo030_$1.seq "
if [ -s "$DIRTAB/cpo030_$1.seq" ]; then
	echo "Tem o arquivo SIM"
	$DIRISIS/mx seq=$DIRTAB/cpo030_$1.seq gizmo=gutf8ans create=cpo030_$1 -all now
        echo "Copia o arquivo original $3_2"
	$DIRISIS/mx $3_2 gizmo=cpo030_$1,30 create=$3_3 -all now
else
	$DIRISIS/mx $3_2 "proc='S'" create=$3_3 -all now
fi

echo "30 Titulo (Serie) - Check do Titulo/ISSN com a base Title pelo ISSN [35](LILACS)/ISSN [400](TITLE)"
$DIRISIS/mx $3_3 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab  "join=title,930:150,935:400,945:450=if a(v930) then s(mpu,v35,mpl)/ fi" "proc='s'" "proc='d32001'" create=$3_4 tell=5000 -all now

echo "30 Titulo (Serie) - Check do Titulo com a base coltitle pelo Titulo [30](LILACS)/[160](coltitle)"
$DIRISIS/mx $3_4 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab  "join=$DIRTAB/title/coltitle_OK,930:5,935:2=if a(v930) then 'TI_'s(mpu,v30,mpl)/ fi" "proc='s'" "proc='d32001'" create=$3_5 tell=5000 -all now

echo "Gera Relatorio"
$DIRISIS/mx $3_5 "pft=if s(mpu,v5.1,mpl)='S' and s(mpu,v6,mpl)='AS' and a(v930) then v776^i'|'v2'|30_TI|'v30[1]'|35_IS|'v35/ fi" -all now lw=0 >$DIROUTS/$1/Rel_$3.txt
$DIRISIS/mx $3_5 "tab=if s(mpu,v5.1,mpl)='S' and s(mpu,v6,mpl)='AS' and a(v930) then '30_TI|'v5'|'v30[1]'|35_IS|'v35/ fi" -all now lw=0 >$DIROUTS/$1/Lista_$3.txt

echo "Passa o gizmo para normalizar os título"
$DIRISIS/mx $3_5 "proc=if s(mpu,v5.1,mpl)='S' and a(v930) then 'd914','<914>'v30[1]'</914>' fi" create=$3_6 -all now
#$DIRISIS/mx $3_3 "gizmo=$DIRTAB/title/bbo_title,914" create=$3_4 -all now

echo "Refaz o join com os titulos corretos para trazer todas as informacoes necessarias da title - NORMALIZAR antes do primeiro join e fazer so uma fez!!"
$DIRISIS/mx $3_6 actab=$DIRTAB/ansiac.tab uctab=$DIRTAB/ansiuc.tab  "join=title,930:150,935:400,945:450=if a(v915) then s(mpu,v914,mpl) fi" "proc='s'" "proc='d32001'" create=$3_7 -all now

echo "Limpa o campo de cobertura de indexacao"
$DIRISIS/mx $3_7 "proc='d945',(if v945^*='LL' then '<945>'v945'</945>' fi)" create=$3_8 -all now
$DIRISIS/mx $3_8 "proc=@$DIRTAB/lil945.prc" create=$3_9 -all now

echo "Marca LILACS em indexed_database"
$DIRISIS/mx $3_9 "proc=if p(v945) then if val(v65.4)<val(v945^c) then else if val(v65.4)=val(v945^c) and val(v32)<val(replace(v945^b,'n.','')) then else, if p(v945^f) then if val(v65.4)>val(v945^f) then else if val(v65.4)=val(v945^f) and val(v32)>val(replace(v945^e,'n.','')) then else if a(v950) then '<950>^b1</950>' fi,fi,fi, else, if a(v950) then '<950>^b1</950>' fi,fi,fi,fi,fi" create=$3_10 -all now

$DIRISIS/mx $3_10 "pft=(if v945^*='LL' and p(v945^g) then if not v945^g=v1[1] then v776^i'|'v2'|01_CC|'v1'|'v5'|'v945^g'|'v30[1]'|35_IS|'v35/ fi,fi)" -all now lw=0 >Rel_CC_CI_dif.txt

#echo "Altera o CC para o CIndexador da Revista"
#MIGRATION="S"
#if [ "$MIGRATION" = "S" ]; then
#	$DIRISIS/mx $3_8 "proc=(if v945^*='LL' and p(v945^g) then if not v945^g=v1[1] then 'd1','<902 0>'v945^g'</902>' fi,fi)" create=$3_9 -all now
#else
#fi


echo "Cria o master e o ISO"
$DIRISIS/mx $3_10 "proc='S'" create=$3 -all now

$DIRISIS/mx $3 "proc='d*',if p(v930) then |<2 0>|v2|</2>|,(|<902>|v902|</902>|),(|<930>|v930|</930>|),(|<935>|v935|</935>|),(|<945>|v945|</945>|),(|<950>|v950|</950>|) else (|<930>^t|v30|</930>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000
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
