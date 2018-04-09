#!/bin/bash
# -------------------------------------------------------------------------- #
# MySQL2Lucene.sh - Realiza atualização do indice da base do Dedup a partir  #
# dos registros que estão no FI-ADMIN zerando a base de indice antes         #					     #
# -------------------------------------------------------------------------- #
#
#     Chamada : MySQL2Luceni.sh
#     Exemplo : ./MySQL2Luceni.sh
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
vrs:  1.00 20180207, Ana Katia Camilo / Heitor Barbieri
        - Edicao original
HISTORICO

# -------------------------------------------------------------------------- #

# Anota hora de inicio de processamento
export HORA_INICIO=`date '+ %s'`
export HI="`date '+%Y.%m.%d %H:%M:%S'`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa ${0} ${1} ${2} ${3} ${4}"
echo ""

# -------------------------------------------------------------------------- #
# Ajustando variaveis para processamento

source /bases/fiadmin2/DeDup/config/settings.inc

# -------------------------------------------------------------------------- #

echo "!!! ATENÇÃO !!! Com o usuario operacao XXbirXX !!! ATENÇÂO !!!"
echo ""
echo "   <MySQL server> - IP or domain of the MySQL server"
echo "   <MySQL user> - MySQL user name"
echo "   <MySQL password> - MySQL user password"
echo "   <MySQL database> - MySQL database name"
echo "   <MySQL sql file list> - comma separated sql file names"
echo "       LILACS_MNTam_ingles.sql,LILACS_MNTam.sql"
echo "       LILACS_MNT_ingles.sql,LILACS_MNT.sql"
echo "       LILACS_Sas_ingles.sql,LILACS_Sas.sql"
echo "   <DeDupServiceBase> - url of DeDup service"
echo "              http://serverofi5.bireme.br:8180/DeDup/services/ or http://dedup.bireme.org/services"
echo "   <indexName> - DeDup index where the new documents will be inserted"
echo "<lilacs_Sas | lilacs_MNT | lilacs_MNTam>"
echo "<schemaName> - DeDup schema file (describing document structure)"
echo "http://dedup.bireme.org/services/schema"
echo "LILACS_Sas_Seven, LILACS_MNT_Four, LILACS_MNTam_Five"

# ------------------------------------------------------------------------- #
echo ""
echo "Comandos:"
echo ""

cd $DEDUP
pwd

echo ""
echo "Sas"
echo ""
echo "./MySQL2Lucene.sh $mysqlserver $servername $serverpassword $serverdatabase $DIRSQL/LILACS_Sas.sql,$DIRSQL/LILACS_Sas_ingles.sql $urldedup lilacs_Sas LILACS_Sas_Seven"

#./MySQL2Lucene.sh $mysqlserver $servername $serverpassword $serverdatabase $DIRSQL/LILACS_Sas.sql,$DIRSQL/LILACS_Sas_ingles.sql $urldedup lilacs_Sas LILACS_Sas_Seven
echo ""
echo "MNT"
echo ""
echo "./MySQL2Lucene.sh $mysqlserver $servername $serverpassword $serverdatabase $DIRSQL/LILACS_MNT.sql,$DIRSQL/LILACS_MNT_ingles.sql $urldedup lilacs_MNT LILACS_MNT_Four"

#./MySQL2Lucene.sh $mysqlserver $servername $serverpassword $serverdatabase $DIRSQL/LILACS_MNT.sql,$DIRSQL/LILACS_MNT_ingles.sql $urldedup lilacs_MNT LILACS_MNT_Four
echo ""
echo "MNTam"
echo ""
echo "./MySQL2Lucene.sh $mysqlserver $servername $serverpassword $serverdatabase $DIRSQL/LILACS_MNTam.sql,$DIRSQL/LILACS_MNTam_ingles.sql $urldedup lilacs_MNTam LILACS_MNTam_Five"

#./MySQL2Lucene.sh $mysqlserver $servername $serverpassword $serverdatabase $DIRSQL/LILACS_MNTam.sql,$DIRSQL/LILACS_MNTam_ingles.sql $urldedup lilacs_MNTam LILACS_MNTam_Five

# ---------------------------------------------------------------------------#

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

