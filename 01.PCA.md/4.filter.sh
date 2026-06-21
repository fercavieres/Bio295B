#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

bcftools filter --SnpGap 5 --IndelGap 5 --threads 8 -Oz \
    -o $pca/4_filter_norm_concat_sex_var.vcf.gz \
    $pca/3_filter_norm_concat_sex_var.vcf.gz

echo "============================================"
echo "Filter 2 terminado"
echo "============================================"