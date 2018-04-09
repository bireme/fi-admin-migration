#!/bin/bash
# -------------------------------------------------------------------------- #
# faz_join.sh - Checa se os registro estão duplicados utilizando o DeDup  #
# -------------------------------------------------------------------------- #
#
#     Chamada : faz_join.sh
#     Exemplo : ./faz_join.sh <Diretorio> <iso-8859-1/utf-8>
#
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
vrs:  1.00 20170320,  Ana Katia Camilo
        - Edicao original
HISTORICO

# -------------------------------------------------------------------------- #

# Anota hora de inicio de processamento
export HORA_INICIO=`date '+ %s'`
export HI="`date '+%Y.%m.%d %H:%M:%S'`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa ${0} ${1} ${2} ${3} ${4}"
echo ""
# ------------------------------------------------------------------------- #

echo "- Verificacoes iniciais"

# Verifica passagem obrigatoria de 1 parametro
if [ "$#" -ne "1" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 Nome do diretorio do lote <sci_201710 | bbo> "
  exit 0
fi

# Ajustando variaveis para processamento
source /bases/fiadmin2/DeDup/config/settings.inc

## -------------------------------------------------------------------------- #
echo "Vai para area de trabalho"
cd $DIRWRK/$1


#if test -s $DIRWRK/$1/out1_Sas_wrk2.mst; then  
#	echo "Join Sas file_in=$DIRINSUMO/$1/lil_OK | file_out=lil_Sas"
#	$DIRSCRI/join_dedup.sh $1 Sas $DIRINSUMO/$1/lil_OK
#else
#	echo "Não tem o arquivo $DIRWRK/$1/out1_Sas_wrk2.mst"
#fi
#if test -s $DIRWRK/$1/out1_MNT_wrk2.mst; then
#	echo "Join Sas file_in=lil_Sas | file_out=lil_MNT"
#	$DIRSCRI/join_dedup.sh $1 MNT lil_Sas
#else
#        echo "Não tem o arquivo $DIRWRK/$1/out1_MNT_wrk2.mst"
#fi
#echo "Join Sas file_in=lil_MNT | file_out=lil_MNTam"
#$DIRSCRI/join_dedup.sh $1 MNTam lil_MNT

if test -s $DIRWRK/$1/out1_Sas_wrk2.mst; then
	echo "Entrada=$DIRINSUMO/$1/lil_OK - Join=$DIRWRK/$1/out1_Sas_wrk2.mst - OK"
	$DIRSCRI/join_dedup.sh $1 Sas $DIRINSUMO/$1/lil_OK
        if test -s $DIRWRK/$1/out1_MNT_wrk2.mst; then
                echo "Entrada=$DIRWRK/$1/out1_Sas_wrk2.mst - Join=$DIRWRK/$1/out1_MNT_wrk2.mst - OK"
                if test -s $DIRWRK/$1/out1_MNTam_wrk2.mst; then
                        echo "Entrada=$DIRWRK/$1/out1_MNT_wrk2.mst - Join=$DIRWRK/$1/out1_MNTam_wrk2.mst - OK"
			$DIRSCRI/join_dedup.sh $1 MNT lil_Sas
                else
                        echo "$DIRWRK/$1/out1_MNTam_wrk2.mst - Não"
                fi
        else
                echo "$DIRWRK/$1/out1_MNT_wrk2.mst - Não"
	        if test -s $DIRWRK/$1/out1_MNTam_wrk2.mst; then
	                echo "Entrada=$DIRWRK/$1/out1_Sas_wrk2.mst - Join=$DIRWRK/$1/out1_MNTam_wrk2.mst - OK"
			$DIRSCRI/join_dedup.sh $1 MNTam lil_MNT
        	else
                	echo "$DIRWRK/$1/out1_MNTam_wrk2.mst - Não"
        	fi
        fi
else
	echo "$DIRWRK/$1/out1_Sas_wrk2.mst - Não"
	if test -s $DIRWRK/$1/out1_MNT_wrk2.mst; then
		echo "Entrada=$DIRINSUMO/$1/lil_OK - Join=$DIRWRK/$1/out1_MNT_wrk2.mst - OK"
                        $DIRSCRI/join_dedup.sh $1 MNT $DIRINSUMO/$1/lil_OK
                if test -s $DIRWRK/$1/out1_MNTam_wrk2.mst; then
                        echo "Entrada=$DIRWRK/$1/out1_MNT_wrk2.mst - Join=$DIRWRK/$1/out1_MNTam_wrk2.mst - OK"
                        $DIRSCRI/join_dedup.sh $1 MNTam lil_MNT 
                else
                        echo "$DIRWRK/$1/out1_MNTam_wrk2.mst - Não"
                fi
	else
		echo "$DIRWRK/$1/out1_MNT_wrk2.mst - Não"
                if test -s $DIRWRK/$1/out1_MNTam_wrk2.mst; then
                        echo "Entrada=$DIRINSUMO/$1/lil_OK - Join=$DIRWRK/$1/out1_MNTam_wrk2.mst - OK"
                        $DIRSCRI/join_dedup.sh $1 MNTam $DIRINSUMO/$1/lil_OK
                else
                        echo "$DIRWRK/$1/out1_MNTam_wrk2.mst - Não"
                fi
	fi
fi

echo "Limpa e gera lil_all"
pwd

if test -s $DIRWRK/$1/out1_MNTam_wrk2.mst; then
	$DIRISIS/mxcp lil_MNTam create=lil_all clean
else 
	if test -s $DIRWRK/$1/out1_MNT_wrk2.mst; then
        	$DIRISIS/mxcp lil_MNT create=lil_all clean
	else
		$DIRISIS/mxcp lil_Sas create=lil_all clean
	fi
fi

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

