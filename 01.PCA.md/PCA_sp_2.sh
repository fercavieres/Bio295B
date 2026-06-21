#!/bin/bash
# ============================================================
# PCA por especie - PASO 2: bgzip + tabix
# ============================================================

export TZ="America/Santiago"

source activate handsonVCF

OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_por_especie"

echo "============================================"
echo " PASO 2: bgzip + tabix"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for ESPECIE in skua pomarinus longicaudus parasiticus; do
    echo "[$ESPECIE] bgzip... $(date '+%H:%M:%S')"
    bgzip $OUTDIR/${ESPECIE}_maf005.recode.vcf
    echo "[$ESPECIE] tabix... $(date '+%H:%M:%S')"
    tabix -p vcf $OUTDIR/${ESPECIE}_maf005.recode.vcf.gz
    echo "[$ESPECIE] OK $(date '+%H:%M:%S')"
done

echo ""
echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"