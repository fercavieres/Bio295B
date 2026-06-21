#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

plink --vcf $pca/5_filter_maf001_norte.vcf.gz --double-id --allow-extra-chr \
    --indep-pairwise 50 10 0.2 --out $pca/pca_maf001 &

plink --vcf $pca/5_filter_maf005_norte.vcf.gz --double-id --allow-extra-chr \
    --indep-pairwise 50 10 0.2 --out $pca/pca_maf005 &

wait
echo "============================================"
echo "PCA 1 terminado"
echo "============================================"