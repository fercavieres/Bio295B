# ============================================================
# 1. HETEROCIGOSIDAD
# ============================================================
echo "============================================"
echo " HET: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for ESPECIE in skua pomarinus longicaudus parasiticus; do
    echo "[$ESPECIE] HET..."
    vcftools --gzvcf $VCF \
        --keep $POPDIR/${ESPECIE}.txt \
        --het \
        --out $OUTDIR/het/${ESPECIE}
    echo "[$ESPECIE] HET OK"
done