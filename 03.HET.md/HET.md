# HET (Heterozygosity)

Análisis de heterocigosidad observada (Ho) por especie usando vcftools. Se compararon tres filtros MAF para evaluar su efecto sobre los resultados.

---

## Paso 1: Calcular HET con MAF 0.05

Se usó el VCF conjunto de las 59 muestras reproductivas con MAF 0.05, separando por especie con `--keep`.

Script: `vcftools_het.sh`

---

## Paso 2: Comparar filtros MAF

A solicitud de la tutora se recalculó el HET con MAF 0.01 y sin filtro MAF para comparar el efecto sobre Ho. Los resultados fueron consistentes entre los tres filtros — el patrón de heterocigosidad por especie se mantiene independiente del filtro usado.

Script: `vcftools_het_comparacion.sh`

---

## Visualización en R

Se generaron 3 PDFs, uno por filtro MAF, cada uno con boxplot de las 4 especies.

Script: `plot_HET_comparacion.R`

**Resultado:** *S. longicaudus* presenta la mayor heterocigosidad y *S. parasiticus* la menor, patrón consistente en los tres filtros.