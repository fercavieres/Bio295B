#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

# Renombrar scaffolds en .bim
for f in maf001 maf005; do
    sed -i \
        -e 's/^scaffold_1\b/1/' \
        -e 's/^scaffold_2\b/2/' \
        -e 's/^scaffold_3\b/3/' \
        -e 's/^scaffold_4\b/4/' \
        -e 's/^scaffold_5\b/5/' \
        -e 's/^scaffold_6\b/6/' \
        -e 's/^scaffold_7\b/7/' \
        -e 's/^scaffold_8\b/8/' \
        -e 's/^scaffold_9\b/9/' \
        -e 's/^scaffold_10\b/10/' \
        -e 's/^scaffold_11\b/11/' \
        -e 's/^scaffold_12\b/12/' \
        -e 's/^scaffold_13\b/13/' \
        -e 's/^scaffold_14\b/14/' \
        -e 's/^scaffold_15\b/15/' \
        -e 's/^scaffold_16\b/16/' \
        -e 's/^scaffold_17\b/17/' \
        -e 's/^scaffold_18\b/18/' \
        -e 's/^scaffold_19\b/19/' \
        -e 's/^scaffold_20\b/20/' \
        $pca/pca_pruned_${f}.bim
    echo "Renombrado: pca_pruned_${f}.bim"
done

# Frecuencias alélicas
plink --bfile $pca/pca_pruned_maf001 --freq --allow-extra-chr --out $pca/allele_freq_maf001 &
plink --bfile $pca/pca_pruned_maf005 --freq --allow-extra-chr --out $pca/allele_freq_maf005 &

wait
echo "============================================"
echo "Change name + PCA 4 terminado"
echo "============================================"