#!/bin/bash
# -------------------------------------------------------------------------- #
# cpo002.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
# 
#     Chamada : cpo002.sh  
#     Exemplo : ./cpo002.sh <FI>
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
  echo "Exemplo: $0 bbo 01_lil cpo002 "
  exit 0
fi

echo "  -> Base origem"
# Verifica se existe arquivo inicial
if [ ! -f $DIRDATA/${1}/$2.mst ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/${1}/$2.mst ]"; exit 0
else
  echo "  OK - $DIRDATA/${1}/cpo$2.mst"
fi

# -------------------------------------------------------------------------- #

echo "  -> Cria o diretorio para processamento e saida se náo tiver"
[ ! -d $DIRWORK/${1} ] && mkdir $DIRWORK/${1}
[ ! -d $DIROUTS/${1} ] && mkdir $DIROUTS/${1}

echo "  -> Traz insumo para processamento"
cd $DIRDATA/${1}
$DIRISIS/mx iso=$DIRINSUMO/${1}.iso create=${1} -all now 

echo "  -> Limpa base - mxcp"
$DIRISIS/mxcp ${1} create=01_lil clean log=/dev/null

echo "  -> Desbloqueia - retag"
$DIRISIS/retag 01_lil unlock

echo
echo "INICIO DOS AJUSTES ###########################################################################################"

echo "----------------------------------------------------------------------------------------"
echo "Campo de Numero de Identificacao"

if [ "$MIGRATION" = "S" ]; then
	echo "AQUI $MIGRATION"
	echo "Checa se tem ID duplicado"
	$DIRISIS/mx $2 "tab=v2/" -all now > lista_cpo002.txt
	echo "Gera o master para check"
	$DIRISIS/mx seq=lista_cpo002.txt create=lista_cpo002 -all now
	echo "Checa se tem duplicado e gera um relatorio"
	$DIRISIS/mx lista_cpo002 "pft=if val(v2)>1 then v3/ fi" -all now lw=0 >$DIROUTS/$1/cpo002_ID_dup.txt
	echo "Se o ID nao e numero gera um relatorio"
	$DIRISIS/mx $2 "pft=if v2=f(val(v2),0,0) then else v2/ fi" -all now lw=0 >$DIROUTS/$1/cpo002_no_number.txt
	echo "002 Identificados - No campo ID[02] vai para o Origem exemplo: 776 BBO^i345 e o campo ID altera o ID para um numero sequencial"
	$DIRISIS/mx $2 "proc='d2d776','<2>'f(val(mfn),0,0)'</2>','<776>$1^i$SIGLA_ID-'v2'</776>'" create=$3 -all now tell=1000
else
	echo "Gera continuacao $MIGRATION"
	if [ "$SIGLA_ID" = "sci" ]; then
                $DIRISIS/mx $2 "proc='d2d776','<2>'f((mfn),0,0)'</2>','<776>^bSciELO^i'v2'</776>'" "proc='S'" create=$3 -all now tell=1000
	else
		$DIRISIS/mx $2 "proc='S'" create=$3 -all now tell=1000
	fi
fi

echo "Gera o ISO so com os campos 2 e 776 necessarios para o join"
$DIRISIS/mx $3 "proc='d*',if p(v776) then |<2 0>|v2|</2>|,(|<776>|v776|</776>|) fi" iso=$DIRWORK/$1/$3.iso -all now tell=10000


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
