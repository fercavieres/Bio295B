#!/bin/bash
export TZ="America/Santiago"
source activate handsonVCF

vcf_dir="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/vcf_norte_final"
output_dir="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"

mkdir -p $output_dir

bcftools concat -f $vcf_dir/chromosome_list_sex.txt --threads 8 -Oz -o $output_dir/1_concat_sex_var.vcf.gz

echo "============================================"
echo "Concat terminado"
echo "============================================"