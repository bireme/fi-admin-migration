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
# -------------------------------------------------------------------------- #
echo "Inicio do processamento"

echo "Vai para o diretorio de trabalho"
cd $DIRWORK/$1

#for i in `ls -d cpo*.iso |cut -c1-6`
#do

#   echo "Arquivo iso $i"
#   $DIRISIS/mx $i "fst=2 0 v2/" fullinv=$i

#done

echo "cpo001"
$DIRISIS/mx wrk_OK "proc='d1d901d902',if p(v902) then '<1 0>'v902'</1>' else if p(v901) then '<1 0>'v901'</1>' else |<1 0>|v1|</1>| fi,fi" create=lil_001 -all now

echo "cpo004"
$DIRISIS/mx lil_001 "proc='d4d904',if p(v904) then (|<4 0>|v904|</4>|) fi" create=lil_002 -all now

echo "cpo005"
$DIRISIS/mx lil_002 "proc=if a(v905) then 'd*' else 'd5d905','<5 0>'v905'</5>' fi" create=lil_003 -all now

echo "cpo006"
$DIRISIS/mx lil_003 "proc=if a(v906) then 'd*' else 'd6d906','<6 0>'v906'</6>' fi" create=lil_004 -all now

echo "cpo008"
$DIRISIS/mx lil_004 "proc='d8d908',if p(v908) then (|<8 0>|v908|</8>|) fi" create=lil_005 -all now

echo "cpo009"
$DIRISIS/mx lil_005 "proc='d9d909',if p(v909) then '<9 0>'v909'</9>' fi" create=lil_006 -all now

echo "cpo010"
$DIRISIS/mx lil_006 "proc='d10d910',if p(v910) then (|<10 0>|v910|</10>|) fi" create=lil_007 -all now

echo "cpo012"
$DIRISIS/mx lil_007 "proc='d12d912',if p(v912) then (|<12 0>|v912|</12>|) fi" create=lil_008 -all now

echo "cpo014"
$DIRISIS/mx lil_008 "proc='d14d914',if p(v914) then '<14 0>'v914'</14>' else if p(v14) then |<14 0>|v14|</14>| fi,fi" create=lil_009 -all now

echo "cpo016"
$DIRISIS/mx lil_009 "proc='d16d916',if p(v916) then (|<16 0>|v916|</16>|) else if p(v16) then |<16 0>|v16|</16>| fi,fi" create=lil_010 -all now

echo "cpo018"
$DIRISIS/mx lil_010 "proc='d18d918',if p(v918) then (|<18 0>|v918|</18>|) else if p(v18) then |<18 0>|v18|</18>| fi,fi" create=lil_011 -all now

echo "cpo023"
$DIRISIS/mx lil_011 "proc='d23d923',if p(v923) then (|<23 0>|v923|</23>|) else if p(v23) then |<23 0>|v23|</23>| fi,fi" create=lil_012 -all now

echo "cpo025"
$DIRISIS/mx lil_012 "proc='d25d925',if p(v925) then (|<25 0>|v925|</25>|) else if p(v25) then |<25 0>|v25|</25>| fi,fi" create=lil_013 -all now

echo "cpo030"
$DIRISIS/mx lil_013 "proc='d30d930',if p(v930) then (|<30 0>|v930|</30>|) else if p(v30) then |<30 0>|v30|</30>| fi,fi" create=lil_014 -all now

echo "cpo035"
$DIRISIS/mx lil_014 "proc='d35d935',if p(v935) then (|<35 0>|v935|</35>|) else if p(v35) then |<35 0>|v35|</35>| fi,fi" create=lil_015 -all now

echo "cpo038"
$DIRISIS/mx lil_015 "proc='d38d938',if p(v938) then (|<38 0>|v938|</38>|) fi" create=lil_016 -all now

echo "cpo040"
$DIRISIS/mx lil_016 "proc='d40d940',if p(v940) then (|<40 0>|v940|</40>|) else if p(v40) then |<40 0>|v40|</40>| fi,fi" create=lil_017 -all now

echo "cpo057"
$DIRISIS/mx lil_017 "proc='d57d957',if p(v957) then (|<57 0>|v957|</57>|) else if p(v57) then |<57 0>|v57|</57>| fi,fi" create=lil_018 -all now

echo "cpo065"
$DIRISIS/mx lil_018 "proc='d65d965',if p(v965) then (|<65 0>|v965|</65>|) fi" create=lil_019 -all now

echo "cpo067"
$DIRISIS/mx lil_019 "proc='d67d967',if p(v967) then (|<67 0>|v967|</67>|) else if p(v67) then |<67 0>|v67|</67>| fi,fi" create=lil_020 -all now

echo "cpo071"
$DIRISIS/mx lil_020 "proc='d17d971',if p(v971) then (|<71 0>|v971|</71>|) fi" create=lil_021 -all now

echo "cpo076"
$DIRISIS/mx lil_021 "proc='d76d976',if p(v976) then (|<76 0>|v976|</76>|) fi" create=lil_022 -all now

echo "cpo083"
$DIRISIS/mx lil_022 "proc='d83d983',if p(v983) then (|<83 0>|v983|</83>|) else if p(v83) then |<83 0>|v83|</83>| fi,fi" create=lil_023 -all now

echo "cpo087"
$DIRISIS/mx lil_023 "proc='d87d987',if p(v987) then (|<87 0>|v987|</87>|) fi" create=lil_024 -all now

echo "cpo088"
$DIRISIS/mx lil_024 "proc='d88d988',if p(v988) then (|<88 0>|v988|</88>|) fi" create=lil_025 -all now

echo "cpo091"
$DIRISIS/mx lil_025 "proc='d91d991',if p(v991) then (|<91 0>|v991|</91>|) else if p(v91) then |<91 0>|v91|</91>| fi,fi" create=lil_026 -all now

echo "cpo110"
$DIRISIS/mx lil_026 "proc='d110d980',if p(v980) then (|<110 0>|v980|</110>|) fi" create=lil_027 -all now

echo "cpo111"
$DIRISIS/mx lil_027 "proc='d111d981',if p(v981) then (|<111 0>|v981|</111>|) fi" create=lil_028 -all now

echo "cpo112"
$DIRISIS/mx lil_028 "proc='d112d972',if p(v972) then (|<112 0>|v972|</112>|) fi" create=lil_029 -all now

echo "cpo113"
$DIRISIS/mx lil_029 "proc='d113d973',if p(v973) then (|<113 0>|v973|</113>|) fi" create=lil_030 -all now

echo "cpo114"
$DIRISIS/mx lil_030 "proc='d114d974',if p(v974) then (|<114 0>|v974|</114>|) fi" create=lil_031 -all now

echo "cpo115"
$DIRISIS/mx lil_031 "proc='d115d975',if p(v975) then (|<115 0>|v975|</115>|) fi" create=lil_032 -all now

echo "cpo700"
$DIRISIS/mx lil_032 "proc='d700d970',if p(v970) then (|<700 0>|v970|</700>|) fi" create=lil_033 -all now

echo "cpo950"
$DIRISIS/mx lil_033 "proc='d950',if p(v950) then (|<950 0>|v950|</950>|) fi" create=lil_034 -all now

echo "cpo500"
$DIRISIS/mx lil_034 "proc='d995',if p(v995) then (|<500 0>|v950|</500>|) fi" create=lil_035 -all now

echo "Final"
$DIRISIS/mx lil_035 "proc='S'" iso=lil_OK.iso -all now

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

