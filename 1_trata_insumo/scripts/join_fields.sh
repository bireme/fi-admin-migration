#!/bin/bash
# -------------------------------------------------------------------------- #
# index_master.sh - Realiza conversao de registro LILACS para versao 1.7  #
# -------------------------------------------------------------------------- #
#
#     Chamada : index_master
#     Exemplo : ./index_master.sh <FI> 
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

# Verifica passagem obrigatoria de 1 parametro
if [ "$#" -ne "1" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso> "
  echo "Exemplo: $0 bbo "
  exit 0
fi

echo "  -> Base origem"
# Verifica se existe arquivo insumo de processamento
if [ ! -f $DIRDATA/$1/cpo002.mst ]; then
  echo "ERROR: Base para processamento nao encontrada [ $DIRDATA/$1/cpo002.mst ]"; exit 0
else
  echo "  OK - $DIRDATA/$1/cpo002.mst"
fi

# -------------------------------------------------------------------------- #
echo "Inicio do processamento"

echo "Vai para o diretorio de trabalho"
cd $DIRWORK/$1
i=1
echo "teste = $i"
[ -s cpo001.mst ] && echo "Join cpo001 [1] $i" && $DIRISIS/mx $DIRDATA/$1/cpo002 "join=cpo001,901=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk1 -all now && j=$(($i+1))

[ -s cpo004.mst ] && echo "Join cpo004 - [4,950] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo004,904,950=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo005.mst ] && echo "Join cpo005 [5] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo005,905,955=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1))  && j=$(($j+1))

[ -s cpo006.mst ] && echo "Join cpo006 [6] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo006,906=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1))  && j=$(($j+1))

[ -s cpo008.mst ] && echo "Join cpo008 [8,38,500] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo008,908,938,995=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo009.mst ] && echo "Join cpo009 [9] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo009,909=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo010.mst ] && echo "Join cpo010 [10] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo010,910=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo012.mst ] && echo "Join cpo012 [12] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo012,912=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo013.mst ] && echo "Join cpo013 [13] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo013,913=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo014.mst ] && echo "Join cpo014 [14] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo014,914=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo016.mst ] && echo "Join cpo016 [16] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo016,916=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo018.mst ] && echo "Join cpo018 [18] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo018,918=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo019.mst ] && echo "Join cpo019 [19] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo019,919=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo023.mst ] && echo "Join cpo023 [23] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo023,923=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo025.mst ] && echo "Join cpo025 [25] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo025,925=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo030.mst ] && echo "Join cpo030 [1,30,35,950,(450 - Title)] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo030,902,930,935,945,951:950=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo038.mst ] && echo "Join cpo038 [38] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo038,938=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo040.mst ] && echo "Join cpo040 [40] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo040,940=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo057.mst ] && echo "Join cpo057 [57] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo057,957=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo065.mst ] && echo "Join cpo065 [65] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo065,965=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo067.mst ] && echo "Join cpo023 [67] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo067,967=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo700.mst ] && echo "Join cpo700 [700] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo700,970,995=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo071.mst ] && echo "Join cpo071 [71,76] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo071,971,976=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo083.mst ] && echo "Join cpo083 [83] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo083,983=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo085.mst ] && echo "Join cpo085 [85] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo085,985=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo087.mst ] && echo "Join cpo087 [87] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo087,987=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo088.mst ] && echo "Join cpo088 [88] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo088,988=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo091.mst ] && echo "Join cpo091 [91] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo091,991=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo110.mst ] && echo "Join cpo110 [110] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo110,980=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo111.mst ] && echo "Join cpo111 [111] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo111,981=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo112.mst ] && echo "Join cpo0112 [112] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo110,972=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo113.mst ] && echo "Join cpo0113 [113] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo113,973=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo114.mst ] && echo "Join cpo0114 [114] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo114,974=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now && i=$(($i+1)) && j=$(($j+1))

[ -s cpo115.mst ] && echo "Join cpo0115 [115] file_in=$i file_out=$j" && $DIRISIS/mx wrk$i "join=cpo115,975=s(mpu,v2,mpl)/" "proc='d32001'" create=wrk$j -all now

echo "Final file_out=$j"
[ -s cpo115.mst ] && $DIRISIS/mx wrk$j "proc='S'" create=wrk_f -all now || $DIRISIS/mx wrk$(($j-1)) "proc='S'" create=wrk_f -all now


echo "Ajste do campo de controle 950"
$DIRISIS/mx wrk_f "proc='d950d951',if p(v951) then '<950>'v951'</950>' else if p(v950) then ('<950>'v950'</950>') fi,fi" create=wrk_OK -all now

# ---------------------------------------------------------------------------#

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

