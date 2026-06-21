#!/bin/bash
# ============================================================
# PCA por especie - PASO 1: filtrar VCF por especie
# ============================================================

export TZ="America/Santiago"

source activate handsonVCF

VCFDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_repro"
OUTDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/pca/pca_por_especie"
mkdir -p "$OUTDIR"

# Archivos de muestras
cat > $OUTDIR/skua_samples.txt << 'SAMPLES'
S1_2019 S1_2019
S3_2019 S3_2019
S4_2019 S4_2019
S5_2019 S5_2019
S6_2019 S6_2019
S7_2019 S7_2019
SRR22267302 SRR22267302
SRR22267303 SRR22267303
SAMPLES

cat > $OUTDIR/pomarinus_samples.txt << 'SAMPLES'
SPO4 SPO4
SPO7 SPO7
SRR22267299 SRR22267299
SRR22267300 SRR22267300
SRR22267301 SRR22267301
ABJ189 ABJ189
UAMX383 UAMX383
UAMX8584 UAMX8584
SAMPLES

cat > $OUTDIR/longicaudus_samples.txt << 'SAMPLES'
JJW5548 JJW5548
F1-21 F1-21
F2-21 F2-21
F3-21 F3-21
F4-21 F4-21
F5-21 F5-21
F6-21 F6-21
UAMX160 UAMX160
UAMX161 UAMX161
SL8 SL8
SL5 SL5
KT-19 KT-19
TH-19 TH-19
OJ-19 OJ-19
OK-19 OK-19
SAMPLES

cat > $OUTDIR/parasiticus_samples.txt << 'SAMPLES'
JJW5680 JJW5680
JJW4274 JJW4274
JJW4273 JJW4273
JJW730 JJW730
T1-15 T1-15
T14-19 T14-19
T2-15 T2-15
T3-10 T3-10
T4-10 T4-10
T7-11 T7-11
TB1-15 TB1-15
TB1-16 TB1-16
TB2-16 TB2-16
TB3-11 TB3-11
TB4-11 TB4-11
TB6-11 TB6-11
TS17-16 TS17-16
AM_2019 AM_2019
AX_2016 AX_2016
JX_2019 JX_2019
ZR_2019 ZR_2019
HK_2019 HK_2019
UAMX5074 UAMX5074
UAMX602 UAMX602
UAMX623 UAMX623
SPA9 SPA9
SPA1 SPA1
SAMPLES

echo "============================================"
echo " PASO 1: Filtrando VCF por especie"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for ESPECIE in skua pomarinus longicaudus parasiticus; do
    echo "[$ESPECIE] Filtrando... $(date '+%H:%M:%S')"
    vcftools --gzvcf $VCFDIR/6_maf005_repro.recode.vcf.gz \
        --keep $OUTDIR/${ESPECIE}_samples.txt \
        --recode --recode-INFO-all \
        --out $OUTDIR/${ESPECIE}_maf005
    echo "[$ESPECIE] OK $(date '+%H:%M:%S')"
done

echo ""
echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"