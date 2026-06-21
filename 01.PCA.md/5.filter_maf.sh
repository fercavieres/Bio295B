#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

vcftools --gzvcf $pca/4_filter_norm_concat_sex_var.vcf.gz \
    --maf 0.01 --recode --stdout | bgzip -c > $pca/5_filter_maf001_norte.vcf.gz &

vcftools --gzvcf $pca/4_filter_norm_concat_sex_var.vcf.gz \
    --maf 0.05 --recode --stdout | bgzip -c > $pca/5_filter_maf005_norte.vcf.gz &

wait
echo "============================================"
echo "Filter MAF terminado"
echo "============================================"