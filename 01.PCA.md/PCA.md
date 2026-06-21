# PCA (Principal Component Analysis)

Análisis de estructura genética poblacional mediante PCA usando plink. Se realizaron dos análisis: uno con todas las muestras (66) y otro intraespecífico por especie separada.

---

## Preparación del VCF

Los VCFs fueron generados por scaffold y se procesaron en los siguientes pasos:

**0. Indexar VCFs por scaffold**
Script: `0_index_vcf.sh`

**1. Concatenar todos los scaffolds en un solo VCF**
Script: `1.concat.sh`

**2. Normalizar variantes**
Script: `2.norm.sh`

**3. Filtrar por calidad**
Script: `3.filter.sh`

**4. Filtrar por missing data y cobertura mínima**
Script: `4.filter.sh`

**5. Filtrar por frecuencia alélica mínima (MAF)**
Genera VCFs con MAF 0.01 y MAF 0.05.
Script: `5.filter_maf.sh`

---

## PCA General (66 muestras)

PCA con todas las muestras usando plink. Se realizaron 4 pasos:

**Paso 1:** Pruning por desequilibrio de ligamiento
Script: `PCA_01.sh`

**Paso 2:** Convertir a formato BED
Script: `PCA_02.sh`

**Paso 3:** Correr PCA
Script: `PCA_03.sh`

**Paso 4:** Filtrar muestras no reproductivas y recalcular
Script: `PCA_04.sh`

**Paso 5:** Graficar en R
Script: `PCA_05.r`

**Paso 6:** PCA solo con muestras reproductivas (59 muestras)
Script: `PCA_06_reproductiva.sh`

---

## PCA Intraespecífico (por especie)

PCA separado para cada especie usando sus propios VCFs, para visualizar estructura poblacional interna.

**Paso 1:** Filtrar VCF por especie
Script: `PCA_sp_1.sh`

**Paso 2:** Comprimir con bgzip
Script: `PCA_sp_2.sh`

**Paso 3:** Pruning por desequilibrio de ligamiento
Script: `PCA_sp_3.sh`

**Paso 4:** Convertir a formato BED
Script: `PCA_sp_4.sh`

**Paso 5:** Correr PCA por especie
Script: `PCA_sp_5.sh`

**Visualización:** `pca_mapas_norte.R`