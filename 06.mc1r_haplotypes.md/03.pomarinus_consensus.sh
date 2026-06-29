# 05. MC1R bcftools consensus hap1 + hap2 — *S. pomarinus*

```bash
#!/bin/bash
export TZ="America/Santiago"
source activate mc1r_env

REF="/data2/lab2/lucila/01.anotacion/SterChil1.hic.hap1.yahs_scaffolds_final.fa.MicroFinder.ordered.fa.masked"
SAMTOOLS="/home/lab2/.conda/envs/mc1r_env/bin/samtools"
PHASEDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/mc1r_pomarinus/phased"
HAPDIR="/data2/lab2/lucila/BIO295B_FernandaCavieres/data/mc1r_pomarinus/haplotipos"
REGION="scaffold_12:41127919-41128863"

mkdir -p "$HAPDIR"

MUESTRAS=(
    "SPO4" "SPO7"
    "SRR22267299" "SRR22267300" "SRR22267301"
    "ABJ189" "JJW2216" "UAMX383" "UAMX8584"
)

echo "============================================"
echo " PASO 3: bcftools consensus hap1 + hap2"
echo " Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

for NOMBRE in "${MUESTRAS[@]}"; do
    PHASED="$PHASEDIR/${NOMBRE}_phased.vcf.gz"
    if [ -f "$PHASED" ]; then
        echo "Procesando $NOMBRE..."

        # Haplotipo 1
        bcftools consensus --haplotype 1 -f "$REF" "$PHASED" \
            -o "$HAPDIR/${NOMBRE}_hap1_full.fa"
        $SAMTOOLS faidx "$HAPDIR/${NOMBRE}_hap1_full.fa"
        $SAMTOOLS faidx "$HAPDIR/${NOMBRE}_hap1_full.fa" "$REGION" \
            | sed "s/^>.*/>$NOMBRE\_hap1/" > "$HAPDIR/${NOMBRE}_hap1.fa"
        rm "$HAPDIR/${NOMBRE}_hap1_full.fa" "$HAPDIR/${NOMBRE}_hap1_full.fa.fai"

        # Haplotipo 2
        bcftools consensus --haplotype 2 -f "$REF" "$PHASED" \
            -o "$HAPDIR/${NOMBRE}_hap2_full.fa"
        $SAMTOOLS faidx "$HAPDIR/${NOMBRE}_hap2_full.fa"
        $SAMTOOLS faidx "$HAPDIR/${NOMBRE}_hap2_full.fa" "$REGION" \
            | sed "s/^>.*/>$NOMBRE\_hap2/" > "$HAPDIR/${NOMBRE}_hap2.fa"
        rm "$HAPDIR/${NOMBRE}_hap2_full.fa" "$HAPDIR/${NOMBRE}_hap2_full.fa.fai"

        echo "✓ $NOMBRE listo"
    else
        echo "✗ No se encontró VCF faseado para $NOMBRE"
    fi
done

# Juntar todos los haplotipos
echo ""
echo "Juntando haplotipos..."
samtools faidx "$REF" "$REGION" | sed "s/^>.*/>SC_chilensis_ref/" > "$HAPDIR/MC1R_pomarinus_haplotipos.fasta"
for NOMBRE in "${MUESTRAS[@]}"; do
    cat "$HAPDIR/${NOMBRE}_hap1.fa" >> "$HAPDIR/MC1R_pomarinus_haplotipos.fasta"
    cat "$HAPDIR/${NOMBRE}_hap2.fa" >> "$HAPDIR/MC1R_pomarinus_haplotipos.fasta"
done

echo "============================================"
echo " LISTO! $(date '+%Y-%m-%d %H:%M:%S')"
echo " Archivo final: $HAPDIR/MC1R_pomarinus_haplotipos.fasta"
grep -c "^>" "$HAPDIR/MC1R_pomarinus_haplotipos.fasta"
echo " secuencias en total (ref + 2 hap x muestra)"
echo "============================================"
```
# 06. MC1R Traducción a proteína — *S. pomarinus*

Traducción de los haplotipos nucleotídicos a secuencias proteicas con detección automática de frame.

- **Input:** `MC1R_pomarinus_haplotipos.fasta`
- **Output:** `MC1R_pomarinus_proteinas.faa`
- **Herramienta:** `seqkit translate` (conda env: `jcvi_env`)

```bash
source activate jcvi_env

seqkit translate -F \
    /data2/lab2/lucila/BIO295B_FernandaCavieres/data/mc1r_pomarinus/haplotipos/MC1R_pomarinus_haplotipos.fasta \
    > /data2/lab2/lucila/BIO295B_FernandaCavieres/data/mc1r_pomarinus/haplotipos/MC1R_pomarinus_proteinas.faa
```