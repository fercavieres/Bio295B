#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

plink --bfile $pca/pca_pruned_maf001 --pca --allow-extra-chr --out $pca/pca_final_maf001 &

plink --bfile $pca/pca_pruned_maf005 --pca --allow-extra-chr --out $pca/pca_final_maf005 &

wait
echo "============================================"
echo "PCA 3 terminado"
echo "============================================"