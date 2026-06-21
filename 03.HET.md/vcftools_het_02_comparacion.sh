#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

VCF_NOFILT="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/4_filter_norm_concat_sex_var.vcf.gz"
VCF_MAF001="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_repro/6_maf001_repro.recode.vcf.gz"
EXCLUIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_repro/muestras_excluir.txt"
POPDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/scripts/muestras_norte_final/diversidad"
OUT="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/diversidad/het"

# ============================================================
# HET sin filtro MAF (59 muestras, removiendo no-reproductivos)
# ============================================================
echo "============================================"
echo " HET sin filtro MAF"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for SP in skua pomarinus parasiticus longicaudus; do
    echo "[${SP} noMAF] corriendo..."
    vcftools --gzvcf $VCF_NOFILT \
        --remove $EXCLUIR \
        --keep $POPDIR/${SP}.txt \
        --het \
        --out ${OUT}/${SP}_noMAF
    echo "[${SP} noMAF] OK"
done

# ============================================================
# HET MAF 0.01
# ============================================================
echo ""
echo "============================================"
echo " HET MAF 0.01"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for SP in skua pomarinus parasiticus longicaudus; do
    echo "[${SP} maf001] corriendo..."
    vcftools --gzvcf $VCF_MAF001 \
        --keep $POPDIR/${SP}.txt \
        --het \
        --out ${OUT}/${SP}_maf001
    echo "[${SP} maf001] OK"
done

echo ""
echo "============================================"
echo " TODO LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"