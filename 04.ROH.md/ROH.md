## ROH (Runs of Homozygosity)

Análisis de endogamia genómica mediante la detección de segmentos de homocigosidad en el genoma. Se utilizó `bcftools roh` con los VCF filtrados por especie (MAF 0.05, 59 muestras reproductivas).

### Paso 1: Correr bcftools roh por especie

Se corrió bcftools roh de forma separada para cada especie, usando sus propios VCFs, para evitar que las frecuencias alélicas multiespecie distorsionen los resultados.

```bash
bcftools roh --AF-dflt 0.1 --skip-indels -G30 --threads 10 \
    ${VCFDIR}/${SP}_maf005.recode.vcf.gz \
    -o ${OUTDIR}/${SP}_ROH.txt
```

Script completo: `bcftools_roh_por_especie.sh`

### Paso 2: Extraer segmentos ROH

Se extrajeron solo las líneas RG (segmentos ROH) del output, que es el archivo necesario para graficar.

```bash
grep "^RG" ${SP}_ROH.txt > ${SP}_ROH_segments.txt
```

Script completo: `grep_segments_por_especie.sh`

### Paso 3: Graficar FROH en R

Se calculó FROH por individuo filtrando segmentos ≥ 100 kb y se graficó por especie.

Script: `plot_ROH.R`
