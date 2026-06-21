#!/bin/bash
# ============================================================
# ADMIXTURE - PASO 4: correr admixture K1-10
# ============================================================

export TZ="America/Santiago"

source activate admixture

OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/ADMIXTURE"
BEDFILE="$OUTDIR/admix_norte59_pruned"

cd $OUTDIR

echo "============================================"
echo " PASO 4: ADMIXTURE K1-10"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for K in 1 2 3 4 5 6 7 8 9 10
do
    echo "Corriendo K=$K... $(date '+%H:%M:%S')"
    admixture --cv "${BEDFILE}.bed" $K -j8 | tee "ADMX_K${K}.out"
    echo "K=$K listo! $(date '+%H:%M:%S')"
done

echo ""
echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"