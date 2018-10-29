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

echo "008 URL - Cria ISO somento com ID e os campos alterados"
$DIRISIS/mx seq=$DIROUTS/$1/cpo008_Upload.txt create=url008_1 -all now 
$DIRISIS/mx url008_1 "proc=if v8:'$URL_UPLOAD/lildbi/docsonline/get.php?id=' then else 'd100','<100 0>ALERTA</100>' fi" create=url008_2 -all now tell=100

echo "traz gizmo de acento do diretorio tabs"
$DIRISIS/id2i gansna.id create=gansna

echo "Gera campo de path na tag20 e tag21"
$DIRISIS/mx url008_2 "proc='d20',if v100:'ALERTA' then else '<20 0>$1/'if p(v4) then if val(v4.4)<1985 or val(v4.4)>$ANO then 'year/' else v4'/' fi, else 'year/' fi,if p(v1) then v1'/' else v2'/' fi,'</20>', fi" create=url008_3 -all now

$DIRISIS/mx url008_3 gizmo=gansna,10 "proc='d21',if v100:'ALERTA' then else '<21 0>'if p(v1) then v1 else v2 fi,if p(v10) then '-'replace(replace(left(v10,instr(v10,' ')-1),'.',''),',','') fi,'.pdf</21>', fi" create=url008_4 -all now

$DIRISIS/mx url008_4 "proc='d22',if v100:'ALERTA' then else '<22 0>'mid(v8,instr(v8,'id=')+3,size(v8))'</22>',fi" create=url008_5 -all now

$DIRISIS/mx $DIRDATA/${1}/url008_5 "pft=if v100:'ALERTA' then else v1'-'v22'|'v8'|'v1/ fi" -all now lw=0  >get_upload.txt
echo "$LG"

if [ -s get_upload.txt ]; then

	[ -d 'file_upload' ] || mkdir file_upload
        cd file_upload

        while read linha
        do
		tmpFILE=`echo $linha | awk -F"|" '{ print $1 }'`;
		tmpURL=`echo $linha | awk -F"|" '{ print $2 }'`;
                #echo "Nome do arquivo $tmpFILE e a URL de coleta $tmpURL"
			# WGET monitorado por timeout faz $TENTA tentativas de obter resposta (tmpFILE)
			if [ $TIMOUT -eq 0 ]; then
                                echo "wget -o $LG -O $tmpFILE $tmpURL"
				wget -o $LG -O $tmpFILE $tmpURL	# Executa wget com valores caretas
			else
				timeout $TIMOUT wget --timeout $TOWGET -t $TENTA -o $$LG -O $tmpFILE $tmpURL
			fi
				RSP=$?; [ "$NOERRO" = "1" ] && RSP=0	# Se estamos ignorando erros simula que tudo bem

        done < $DIRDATA/${1}/get_upload.txt
	cd ..
fi

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
