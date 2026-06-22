#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

VCFDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_por_especie"
OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/diversidad"

for ESPECIE in skua pomarinus longicaudus parasiticus; do
    echo "[$ESPECIE] Tajima..."
    vcftools --gzvcf $VCFDIR/${ESPECIE}_maf005.recode.vcf.gz \
        --TajimaD 15000 \
        --out $OUTDIR/tajima/${ESPECIE}_tajima_15kb
    echo "[$ESPECIE] Tajima OK"
done

echo "LISTO! $(date '+%Y-%m-%d %H:%M:%S')"