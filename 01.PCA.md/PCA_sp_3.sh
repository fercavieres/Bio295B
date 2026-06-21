#!/bin/bash
# ============================================================
# PCA por especie - PASO 3: plink pruning
# ============================================================

export TZ="America/Santiago"

source activate handsonVCF

OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_por_especie"

echo "============================================"
echo " PASO 3: plink pruning"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for ESPECIE in skua pomarinus longicaudus parasiticus; do
    echo "[$ESPECIE] Pruning... $(date '+%H:%M:%S')"
    plink --vcf $OUTDIR/${ESPECIE}_maf005.recode.vcf.gz \
        --double-id --allow-extra-chr \
        --set-missing-var-ids @:# \
        --indep-pairwise 50 10 0.1 \
        --out $OUTDIR/${ESPECIE}_pruned
    echo "[$ESPECIE] OK $(date '+%H:%M:%S')"
done

echo ""
echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"