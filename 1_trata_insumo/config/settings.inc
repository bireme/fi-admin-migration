# PATH´s de processamento

export RAIZ="/bases/fi-admin-migration/1_trata_insumo"

VTELL="100000"

# utilizado em migra_versao
export DIRTPL="$RAIZ/tpl"
export DIRTAB="$RAIZ/tabs"
# export DIRTAB="/bases/fiadmin/lilacs/tabs"
export DIRINSUMO="$RAIZ/original"
export DIRDATA="$RAIZ/data"
export DIRGIZMO="/bases/fiadmin/migration/gizmo"
export GIZMOBIG="/bases/fiadmin/big-migration/gizmo"
export WRK_ISOS="$RAIZ/isos_particionados"
export DIRFONTE="/bases/fiadmin2/tools/wrk"
export DEDUP="/home/javaapps/sbt-projects/DCDup"
export DIRTOOLS="/bases/fiadmin2/tools/tpl"
export DIRISIS="/usr/local/bireme/cisis/5.7c/linux64/ffiG_1024K-256"
export DIROUTS="$RAIZ/outs"
export DIRTITL="/bases/iahx/proc/coletas/main/title/isis_id"
export DIRWORK="$RAIZ/wrk"

# particiona_MNT
export BASE_MNT="tipo_MNT"

# particiona_SAS
export BASE_SAS="tipo_SAS"



# Verificando diretorios do processamento
if [ ! -d "$RAIZ" ]; then echo "ERROR: path nao existe : $RAIZ"; exit 0; fi
if [ ! -d "$DIRTAB" ]; then echo "ERROR: path nao existe : $DIRTAB"; exit 0; fi
if [ ! -d "$DIRINSUMO" ]; then echo "ERROR: path nao existe : $DIRINSUMO"; exit 0; fi
if [ ! -d "$DIRGIZMO" ]; then echo "ERROR: path nao existe : $DIRGIZMO"; exit 0; fi
if [ ! -d "$GIZMOBIG" ]; then echo "ERROR: path nao existe : $GIZMOBIG"; exit 0; fi
if [ ! -d "$WRK_ISOS" ]; then echo "ERROR: path nao existe : $WRK_ISOS"; exit 0; fi
if [ ! -d "$DIRFONTE" ]; then echo "ERROR: path nao existe : $DIRFONTE"; exit 0; fi
if [ ! -d "$DEDUP" ]; then echo "ERROR: path nao existe : $DEDUP"; exit 0; fi


