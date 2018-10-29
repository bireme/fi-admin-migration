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

echo "Confere se tem o arquivo get_upload.txt"
[ -s get_upload.txt ] && echo "Sim" || echo "Não"
[ -s $DIRDATA/${1}/file_upload/files_OK.txt ] && rm $DIRDATA/${1}/file_upload/files_OK.txt
[ -s $DIRDATA/${1}/files_Upload_NO.txt ] && rm $DIRDATA/${1}/files_Upload_NO.txt
[ -s $DIRDATA/${1}/file_upload/files_ext.txt ] && rm $DIRDATA/${1}/file_upload/files_ext.txt

if [ -s get_upload.txt ]; then 

       cd file_upload

        while read linha
        do
               tmpFILE=`echo $linha | awk -F"|" '{ print $1 }'`;
                echo "Arquivo $tmpFILE"
                if [ -s $tmpFILE ]; then 
			echo "$tmpFILE|OK" >>$DIRDATA/${1}/file_upload/files_OK.txt
			file --separator \| --mime-type $tmpFILE >>$DIRDATA/${1}/file_upload/files_ext.txt
		else
			echo "$tmpFILE|NO" >>$DIRDATA/${1}/files_Upload_NO.txt
		fi
        done < $DIRDATA/${1}/get_upload.txt

        cd ..
fi

echo "Join dos arquivos bom para a base url008_5"
if [ -s $DIRDATA/${1}/file_upload/files_OK.txt ]; then
	$DIRISIS/mx seq=$DIRDATA/${1}/file_upload/files_OK.txt create=$DIRDATA/${1}/file_upload/files_OK -all now
	$DIRISIS/mx $DIRDATA/${1}/file_upload/files_OK "fst=1 0 v1/" fullinv=$DIRDATA/${1}/file_upload/files_OK tell=1000
	$DIRISIS/mx $DIRDATA/${1}/url008_5 "join=$DIRDATA/${1}/file_upload/files_OK,30:2=v1'-'v22/" "proc='d32001'" create=$DIRDATA/${1}/url008_6 -all now
fi

echo "Join da extensao dos arquivos para a base url008_6"
if [ -s $DIRDATA/${1}/file_upload/files_ext.txt ]; then
        $DIRISIS/mx seq=$DIRDATA/${1}/file_upload/files_ext.txt create=$DIRDATA/${1}/file_upload/files_ext -all now
        $DIRISIS/mx $DIRDATA/${1}/file_upload/files_ext "fst=1 0 v1/" fullinv=$DIRDATA/${1}/file_upload/files_ext tell=1000
        $DIRISIS/mx $DIRDATA/${1}/url008_6 "join=$DIRDATA/${1}/file_upload/files_ext,31:2=v1'-'v22/" "proc='d32001'" create=$DIRDATA/${1}/url008_7 -all now
        $DIRISIS/mx $DIRDATA/${1}/url008_7 "proc=if p(v31) then if s(mpu,v31,mpl):'PDF' then '<35 0>pdf</35>' else if s(mpu,v31,mpl):'WORD' then '<35 0>doc</35>' fi,fi,fi" create=$DIRDATA/${1}/url008_8 -all now
fi

echo "Cria a estrura de diretorios"
$DIRISIS/mx $DIRDATA/${1}/url008_8 "pft=if v30:'OK' then v20/ fi" -all now |sort -u >diretorio.txt
[ -s diretorio.txt ] && echo "Sim" || echo "Não"
[ -d $1 ] && rm -Rf $1

if [ -s diretorio.txt ]; then

       cd $DIRDATA/${1}/file_upload

        while read linha
        do
                echo "Diretorio $linha"
                [ -d $linha ] || mkdir -p $linha

        done < $DIRDATA/${1}/diretorio.txt

        cd ..
fi

echo "Cria script para mover os arquivos do upload"
[ -s $DIRDATA/${1}/file_upload/move_files.sh ] && rm $DIRDATA/${1}/file_upload/move_files.sh
[ -s $DIRDATA/${1}/gizmo_url.txt ] && rm $DIRDATA/${1}/gizmo_url.txt

$DIRISIS/mx $DIRDATA/${1}/url008_8 "pft=if v30:'OK' then v1'-'v22'|'v20'|'v35'|'v8/ fi" -all now lw=0  >file_move.txt
if [ -s file_move.txt ]; then
        cd file_upload

        while read linha
        do
                tmpFILE1=`echo $linha | awk -F"|" '{ print $1 }'`;
                tmpPath=`echo $linha | awk -F"|" '{ print $2 }'`;
                tmpExte=`echo $linha | awk -F"|" '{ print $3 }'`;
		tmpURL=`echo $linha | awk -F"|" '{ print $4 }'`;
                echo "mv $tmpFILE1 $tmpPath$tmpFILE1.$tmpExte" >> $DIRDATA/${1}/file_upload/move_files.sh
		echo "$tmpURL|$tmpPath$tmpFILE1.$tmpExte|$tmpExte" >> $DIRDATA/${1}/gizmo_url.txt
        done < $DIRDATA/${1}/file_move.txt
fi


chmod 777 $DIRDATA/${1}/file_upload/move_files.sh

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
