#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

vcftools --gzvcf $pca/2_norm_concat_sex_var.vcf.gz \
--remove-indels \
--min-alleles 2 \
--max-alleles 2 \
--mac 3 \
--minQ 30 \
--min-meanDP 3 \
--max-missing 1 \
--recode \
--recode-INFO-all \
--stdout | bgzip -@ 30 > $pca/3_filter_norm_concat_sex_var.vcf.gz

echo "============================================"
echo "Filter terminado"
echo "============================================"