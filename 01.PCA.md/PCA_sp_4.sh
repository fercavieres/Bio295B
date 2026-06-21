#!/bin/bash
# ============================================================
# PCA por especie - PASO 4: plink make-bed
# ============================================================

export TZ="America/Santiago"

source activate handsonVCF

OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_por_especie"

echo "============================================"
echo " PASO 4: plink make-bed"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for ESPECIE in skua pomarinus longicaudus parasiticus; do
    echo "[$ESPECIE] Make-bed... $(date '+%H:%M:%S')"
    plink --vcf $OUTDIR/${ESPECIE}_maf005.recode.vcf.gz \
        --double-id --allow-extra-chr \
        --set-missing-var-ids @:# \
        --extract $OUTDIR/${ESPECIE}_pruned.prune.in \
        --make-bed \
        --out $OUTDIR/${ESPECIE}_bed
    echo "[$ESPECIE] OK $(date '+%H:%M:%S')"
done

echo ""
echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"