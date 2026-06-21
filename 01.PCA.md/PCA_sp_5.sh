#!/bin/bash
# ============================================================
# PCA por especie - PASO 5: plink pca
# ============================================================

export TZ="America/Santiago"

source activate handsonVCF

OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_por_especie"

echo "============================================"
echo " PASO 5: plink PCA"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for ESPECIE in skua pomarinus longicaudus parasiticus; do
    echo "[$ESPECIE] PCA... $(date '+%H:%M:%S')"
    plink --bfile $OUTDIR/${ESPECIE}_bed \
        --allow-extra-chr \
        --pca 10 \
        --out $OUTDIR/${ESPECIE}_pca
    echo "[$ESPECIE] OK $(date '+%H:%M:%S')"
done

echo ""
echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo " Archivos finales:"
echo " $OUTDIR/skua_pca.eigenvec"
echo " $OUTDIR/pomarinus_pca.eigenvec"
echo " $OUTDIR/longicaudus_pca.eigenvec"
echo " $OUTDIR/parasiticus_pca.eigenvec"
echo "============================================"