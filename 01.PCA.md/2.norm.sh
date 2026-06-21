#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

ref="/data2/lab2/lucila/01.anotacion/SterChil1.hic.hap1.yahs_scaffolds_final.fa.MicroFinder.ordered.fa.masked"
pca="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

bcftools norm --check-ref w -f $ref -o $pca/2_norm_concat_sex_var.vcf.gz -Oz --threads 8 $pca/1_concat_sex_var.vcf.gz

echo "============================================"
echo "Norm terminado"
echo "============================================"