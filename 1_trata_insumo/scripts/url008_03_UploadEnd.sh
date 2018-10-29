#!/bin/bash
# -------------------------------------------------------------------------- #
# url008.sh - trata os link dos arquivos que foram upload                    #
# -------------------------------------------------------------------------- #
# 
#     Chamada : url008.sh  
#     Exemplo : ./url008.sh <FI>
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

# Verifica passagem obrigatoria de 1 parametro
if [ "$#" -ne "1" ]; then
  echo "ERROR: Parametro errado"
  echo "Use: $0 <FI - que deve ser o nome do arquivo iso>"
  echo "Exemplo: $0 bbo"
  exit 0
fi

echo " ----------------------------------------------------------------------------------------------------------- "
# Carrega valores padrao

LG=$1`date '+%Y%m%d%-H%M%S'`.log;  #Arquivo de LOG para o WGET
TIMOUT=550;     # Tempo de TIME-OUT geral a monitorar (> 3 * $TOWGET)
OPC_TIMO="";    # Opcao de LC (-t 600)

# Ajustes de WGET
TENTA=3;        # Qtde de tentativas para o wget
TOWGET=180;     # Time-out do wget para cada tentativa

# Verbos e complementos utilizados
export   VERBO="ListRecords"
export FORMATO="metadataPrefix=oai_dc"
export    NEXT="resumptionToken"

# Local para receber  os blocos de dados
export tmpFILE="$$tmp"
# Local para acumular os blocos de dados
export accFILE="$$acc"

ANO="`date '+%Y'`"

echo "Area de trabalho"
cd $DIRDATA/${1}

echo
echo "INICIO DOS AJUSTES ###########################################################################################"
echo "--------------------------------------------------------------------------------------------------------------"
echo "Trata URL de UPLOAD"

echo "008 URL"
[ -s $DIROUTS/$1/cpo008_Upload.txt ] || exit

# base temporaria
#  1  "27345"
#  2  "26513"
#  3  "S"
#  4  "2007"
#  5  "1984-5359"
#  6  "1"
#  7  "1"
#  8  "http://coleciona-sus.bvs.br/lildbi/docsonline/get.php?id=294"
#  9  "php"
# 10  "Brasil. Ministerio da Saude. Secretaria de Atencao a Saude. Instituto Nacional de Cancer" ==>> Autor Monografico [16/17]

##Criado neste arquivo
# 20  "coleciona-sus/S/2007/1984-5359/" ==>> path do diretorio
# 21  "26513.pdf" ==>> talvez o nome do arquivo
# 22  "294" ==>> O ID da URL

#$DIRDATA/${1}/files_Upload_NO.txt
#$DIRDATA/${1}/file_upload/move_files.sh
#$DIRDATA/${1}/gizmo_url.txt

cd /$DIRDATA/${1}

echo "MOVE os arquivos para os diretórios da URL"
./$DIRDATA/${1}/file_upload/move_files.sh

echo "Cria base de Gizmo"
$DIRISIS/mx seq=gizmo_url.txt create=gizmo_url_1 -all now
$DIRISIS/mx gizmo_url_1 "proc=if p(v2) then 'd2','<2 0>http://docs.bvsalud.org/biblioref/'v2'</2>' fi" "proc='S'" create=gizmo_url -all now

echo "Cria base com URL Zerada"
$DIRISIS/mx seq=files_Upload_NO.txt create=files_Upload_NO -all now
$DIRISIS/mx files_Upload_NO "proc=if p(v1) then 'd3','<3 0>'left(v1,instr(v1,'-')-1)'</3>','<4 0>'mid(v1,instr(v1,'-')+1,size(v1))'</4>' fi" create=files_Upload -all now
$DIRISIS/mx files_Upload "fst=1 0 v3/" fullinv=files_Upload tell=1000

echo "Alterar base final do processamento Trata insumo"
$DIRISIS/mx iso=/$DIRWORK/${1}/lil_OK.iso create=/$DIRDATA/${1}/lil_url_1 -all now
$DIRISIS/mx /$DIRDATA/${1}/lil_url_1 "gizmo=gizmo_url,8" create=/$DIRDATA/${1}/lil_url_2 -all now
$DIRISIS/mx /$DIRDATA/${1}/lil_url_2 "join=files_Upload,908:4=v776^i" "proc='d32001'" create=/$DIRDATA/${1}/lil_url -all now 

$DIRISIS/mx /$DIRDATA/${1}/lil_url iso=/$DIRWORK/${1}/lil_OK.iso -all now 

echo "-------------------------ATENÇÃO--------------------------------------------------"
echo "Executar o move_files"
echo "E o Gizmo na Base"
echo "----------------------------------------------------------------------------------"

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
