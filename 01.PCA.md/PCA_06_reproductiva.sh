#!/bin/bash
# ============================================================
# PCA reproductivo - Stercorarius norte
# Fefi - BIO295B
# Todo de una, con timestamps
# ============================================================

source activate handsonVCF

PCADIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca"
OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_repro"

echo "============================================"
echo " INICIO: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

# --- Limpiar archivos incompletos ---
echo "[$(date '+%H:%M:%S')] Limpiando archivos incompletos..."
rm -f $OUTDIR/6_maf001_repro.recode.vcf
rm -f $OUTDIR/6_maf001_repro.recode.vcf.gz
rm -f $OUTDIR/6_maf001_repro.recode.vcf.gz.tbi
rm -f $OUTDIR/6_maf001_repro.log
rm -f $OUTDIR/6_maf005_repro.recode.vcf
rm -f $OUTDIR/6_maf005_repro.recode.vcf.gz
rm -f $OUTDIR/6_maf005_repro.recode.vcf.gz.tbi
rm -f $OUTDIR/6_maf005_repro.log

# ============================================================
# PASO 1: vcftools MAF001
# ============================================================
echo ""
echo "============================================"
echo " PASO 1: vcftools MAF001"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

vcftools --gzvcf $PCADIR/5_filter_maf001_norte.vcf.gz \
    --remove $OUTDIR/muestras_excluir.txt \
    --recode --recode-INFO-all \
    --out $OUTDIR/6_maf001_repro

echo "[$(date '+%H:%M:%S')] vcftools MAF001 terminado"

# ============================================================
# PASO 2: bgzip + tabix MAF001
# ============================================================
echo ""
echo "============================================"
echo " PASO 2: bgzip + tabix MAF001"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

bgzip $OUTDIR/6_maf001_repro.recode.vcf
echo "[$(date '+%H:%M:%S')] bgzip MAF001 terminado"
tabix -p vcf $OUTDIR/6_maf001_repro.recode.vcf.gz
echo "[$(date '+%H:%M:%S')] tabix MAF001 terminado"

# ============================================================
# PASO 3: vcftools MAF005
# ============================================================
echo ""
echo "============================================"
echo " PASO 3: vcftools MAF005"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

vcftools --gzvcf $PCADIR/5_filter_maf005_norte.vcf.gz \
    --remove $OUTDIR/muestras_excluir.txt \
    --recode --recode-INFO-all \
    --out $OUTDIR/6_maf005_repro

echo "[$(date '+%H:%M:%S')] vcftools MAF005 terminado"

# ============================================================
# PASO 4: bgzip + tabix MAF005
# ============================================================
echo ""
echo "============================================"
echo " PASO 4: bgzip + tabix MAF005"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

bgzip $OUTDIR/6_maf005_repro.recode.vcf
echo "[$(date '+%H:%M:%S')] bgzip MAF005 terminado"
tabix -p vcf $OUTDIR/6_maf005_repro.recode.vcf.gz
echo "[$(date '+%H:%M:%S')] tabix MAF005 terminado"

# ============================================================
# PASO 5: plink MAF001
# ============================================================
echo ""
echo "============================================"
echo " PASO 5: plink MAF001"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

plink --vcf $OUTDIR/6_maf001_repro.recode.vcf.gz \
    --double-id --allow-extra-chr \
    --set-missing-var-ids @:# \
    --indep-pairwise 50 10 0.1 \
    --out $OUTDIR/pca_repro_maf001_pruned
echo "[$(date '+%H:%M:%S')] pruning MAF001 terminado"

plink --vcf $OUTDIR/6_maf001_repro.recode.vcf.gz \
    --double-id --allow-extra-chr \
    --set-missing-var-ids @:# \
    --extract $OUTDIR/pca_repro_maf001_pruned.prune.in \
    --make-bed \
    --out $OUTDIR/pca_repro_maf001_bed
echo "[$(date '+%H:%M:%S')] make-bed MAF001 terminado"

plink --bfile $OUTDIR/pca_repro_maf001_bed \
    --allow-extra-chr \
    --pca 10 \
    --out $OUTDIR/pca_repro_maf001
echo "[$(date '+%H:%M:%S')] PCA MAF001 terminado"

# ============================================================
# PASO 6: plink MAF005
# ============================================================
echo ""
echo "============================================"
echo " PASO 6: plink MAF005"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

plink --vcf $OUTDIR/6_maf005_repro.recode.vcf.gz \
    --double-id --allow-extra-chr \
    --set-missing-var-ids @:# \
    --indep-pairwise 50 10 0.1 \
    --out $OUTDIR/pca_repro_maf005_pruned
echo "[$(date '+%H:%M:%S')] pruning MAF005 terminado"

plink --vcf $OUTDIR/6_maf005_repro.recode.vcf.gz \
    --double-id --allow-extra-chr \
    --set-missing-var-ids @:# \
    --extract $OUTDIR/pca_repro_maf005_pruned.prune.in \
    --make-bed \
    --out $OUTDIR/pca_repro_maf005_bed
echo "[$(date '+%H:%M:%S')] make-bed MAF005 terminado"

plink --bfile $OUTDIR/pca_repro_maf005_bed \
    --allow-extra-chr \
    --pca 10 \
    --out $OUTDIR/pca_repro_maf005
echo "[$(date '+%H:%M:%S')] PCA MAF005 terminado"

echo ""
echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo " Archivos finales:"
echo " $OUTDIR/pca_repro_maf001.eigenvec"
echo " $OUTDIR/pca_repro_maf001.eigenval"
echo " $OUTDIR/pca_repro_maf005.eigenvec"
echo " $OUTDIR/pca_repro_maf005.eigenval"
echo "============================================"