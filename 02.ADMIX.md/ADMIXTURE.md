# ADMIXTURE

Análisis de estructura genética poblacional mediante ADMIXTURE para K=1 a K=10.

**Nota:** Los archivos de input (BED/BIM/FAM) fueron generados en el pipeline de PCA (`01_PCA/PCA_06_reproductiva.sh`). ADMIXTURE parte desde esos archivos.

---

## Paso 1: Preparar archivos de input

Se copian los archivos BED del PCA a la carpeta de ADMIXTURE y se renombran los scaffolds de formato `scaffold_1` a `1` (requerido por ADMIXTURE).

Script: `admixture_prep.sh`

---

## Paso 2: Correr ADMIXTURE K1-10

Se corre ADMIXTURE para cada valor de K usando 8 threads. El mejor K se evalúa por cross-validation (CV error). El K más significativo fue K=3.

Script: `admixture_run.sh`

---

## Visualización en R

### Todos los K (K=2 a K=10)
Para material suplementario. Usa colores genéricos por ancestría.

Script: `admixture_plot_todos.R`

### K=2, K=3 y K=4 (figura principal)
Los colores de ancestría fueron asignados manualmente para calzar con la paleta oficial de cada especie. K4 usa morado (`#E7BA52`) para el segundo grupo de *S. parasiticus*, diferenciándolo del verde de *S. pomarinus*.

Script: `admixture_norte.R`