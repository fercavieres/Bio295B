#!/bin/bash
source activate handsonVCF

for i in $(seq 1 20); do
    echo "Indexando scaffold_${i}"
    bcftools index /data2/lab2/lucila/BIO295B_FernandaCavieres/data/vcf_norte_final/scaffold_${i}.vcf.gz
done

echo "Indexado terminado"