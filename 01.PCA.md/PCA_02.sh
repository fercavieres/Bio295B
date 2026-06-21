#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

plink --vcf $pca/5_filter_maf001_norte.vcf.gz --double-id --allow-extra-chr \
    --extract $pca/pca_maf001.prune.in \
    --make-bed --out $pca/pca_pruned_maf001 &

plink --vcf $pca/5_filter_maf005_norte.vcf.gz --double-id --allow-extra-chr \
    --extract $pca/pca_maf005.prune.in \
    --make-bed --out $pca/pca_pruned_maf005 &

wait
echo "============================================"
echo "PCA 2 terminado"
echo "============================================"