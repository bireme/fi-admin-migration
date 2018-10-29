#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo005.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo005.sh  
#     Exemplo : ./cpo005.sh <FI> <file_in> <file_out>
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
  echo "Exemplo: $0 bbo cpo002 cpo005"
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
echo "Controleo"

echo "005 Tipo de Literatura - Checa segundo os tipos controlados pela metodologia"
$DIRISIS/mx seq=$DIRTAB/tab_005.txt create=tab_005 -all now
$DIRISIS/mx tab_005 "fst=1 0 v1" fullinv=tab_005 tell=1
$DIRISIS/mx $2 "join=tab_005,905:1=s(mpu,v5,mpl)" "proc='d32001'" create=$3_1 -all now

echo "Gera Relatorio metodologia LILACS 1"
$DIRISIS/mx $3_1 "pft=if a(v905) then 'ID_PROC|'v2,'|ID_v2|'v776^i,'|05_TP|'v5/ fi" lw=0 -all now >$DIROUTS/$1/RelMed1_$3.txt

echo "Gera Relatorio metodologia LILACS 2"
$DIRISIS/mx $3_1 "pft=@$DIRTAB/v5_tip.pft" lw=0 -all now >$DIROUTS/$1/RelMed2_$3.txt

echo "Ajusta o Projeto"
$DIRISIS/mx $3_1 "proc=if s(mpu,v5,mpl):'P' then if a(v59) and a(v60) then 'd905','<905 0>'replace(v5,'P','')'</905>', fi, else if p(v59) and p(v60) then 'd905','<905 0>'v5'P</905>' fi, fi," create=$3_2 -all now

echo "Ajusta o Evento"
$DIRISIS/mx $3_2 "proc=if s(mpu,v5.1,mpl)='M' and not s(mpu,v5,mpl):'S' then if v6:'ms' then 'd905','<905 0>'replace(v5,'M','MS')'</905>', fi,fi" create=$3_3 -all now

echo "Ajusta a monografia seriada"
$DIRISIS/mx $3_3 "proc=if s(mpu,v5,mpl):'C' then if a(v53) or a(v54) or a(v56) then 'd905','<905 0>'replace(v5,'C','')'</905>', fi, else if p(v53) or p(v54) or p(v56) then 'd905','<905 0>'v5'C</905>' fi, fi" create=$3_4 -all now

echo "Movendo para Nota Formatada[505] os campos que estão com problema de metodologia"
echo "Tipo monografico"
$DIRISIS/mx $3_4 "proc=if v5.1='M' or v5.1='N' or v5.1='T' then else if p(v18) then '<955>ID: 'v776^i' v18: 'v18'</955>' fi,fi," create=$3_5 -all now

echo "Tipo Serie"
$DIRISIS/mx $3_5 "proc=if v5:'S' then else if p(v30) then '<955>ID: 'v776^i' v30: 'v30'</955>' fi,fi" create=$3_6 -all now

echo "Registros de Tese"
$DIRISIS/mx $3_6 "proc=if v5.1='T' then else if p(v50) or p(v51) then '<955>ID: 'v776^i,| v50: |v50,| v51: |v51'</955>' fi,fi" create=$3_7 -all now

echo "Relatório de comparacao"
$DIRISIS/mx $3_7 "tab=v5'|'v905" lw=0 -all now >$DIROUTS/$1/RelTab1_$3.txt
$DIRISIS/mx $3_7 "pft=if p(v955) then v5'|'v905'|'v955 fi" lw=0 -all now >$DIROUTS/$1/RelNota_$3.txt

echo "Cria Master"
$DIRISIS/mx $3_7 "proc='S'" create=$3 -all now

echo "Gera o ISO"
$DIRISIS/mx $3 "proc='d*',if p(v905) then |<2 0>|v2|</2>|,|<905 0>|v905[1]|</905>|,|<955 0>|v955|</955>| else if p(v955) then |<2 0>|v2|</2>|,|<955 0>|v955|</955>| fi,fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000

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
