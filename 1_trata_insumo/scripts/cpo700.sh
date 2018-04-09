#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo700.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo700.sh  
#     Exemplo : ./cpo700.sh <FI>
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

echo "700 Nome do Registro de Ensaio Clinico - Sub campo Base de Dados - Comando para padronizar as bases de Ensaio Clinico"
echo "traz tabela controlada para gizmo e check"
cp $DIRTAB/gEnsaioClinico.fst .
$DIRISIS/mx seq=$DIRTAB/gEnsaioClinico.seq create=gEnsaioClinico -all now tell=1
$DIRISIS/mx gEnsaioClinico "fst=@$DIRTAB/gEnsaioClinico.fst" fullinv=gEnsaioClinico -all now 

echo "Faz o join"
$DIRISIS/mx $2 gizmo=gEnsaioClinico,700 "proc='d970d701'" create=$3_1 -all now 
$DIRISIS/mx $3_1 "join=gEnsaioClinico,701:2=s(mpu,v700^*)" "proc='d32001'" create=$3_2 -all now

echo "Gera o Relatorio"
$DIRISIS/mx $3_2 "pft=if p(v700) and a(v701) then v2'|CPO700|'v700/ fi" -all now lw=0 >$DIROUTS/$1/Rel_$3.txt

echo "Cria master"
$DIRISIS/mx $3_2 "proc='S'" create=$3 -all now tell=10000

echo "Cria ISO"
$DIRISIS/mx $3 "proc='d*',if p(v701) and p(v700) then |<2 0>|v2|</2>|,(|<970>|v700|</970>|) else if p(v700) and a(v701) then if s(mpu,v8,mpl):'SCIELO' then |<2 0>|v2|</2>|,(|<970>|v700|</970>|) else |<2 0>|v2|</2>|,|<995>|v700|</995>| fi,fi,fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000
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
