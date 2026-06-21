# ============================================================
# PCA GENERAL - 4 especies norte (66 muestras)
# Paleta oficial del proyecto
# ============================================================

library(ggplot2)
library(gridExtra)
library(readxl)

setwd("~/Desktop/PCA_norte/intento_1")

# 1. Metadata
metadata <- read_excel("Dataset_norte.xlsx")

# 2. Paleta oficial
colores <- c(
  "S. skua"        = "#2a6db5",
  "S. pomarinus"   = "#3a8a52",
  "S. parasiticus" = "#d4732a",
  "S. longicaudus" = "#b83c3c"
)

# 3. Tema GraphPad
tema_paper <- theme_classic(base_size = 13) +
  theme(
    axis.line = element_line(colour = "black", linewidth = 0.8),
    axis.ticks = element_line(colour = "black", linewidth = 0.6),
    axis.ticks.length = unit(4, "pt"),
    axis.title = element_text(face = "bold", colour = "black"),
    axis.title.x = element_text(face = "bold", margin = margin(t = 8)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 8)),
    axis.text = element_text(colour = "black"),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(face = "italic"),
    plot.title = element_text(size = 13, face = "bold"),
    plot.margin = margin(t = 10, r = 15, b = 5, l = 10)
  )

# 4. Función PCA
plot_pca <- function(eigenvec_file, eigenval_file, titulo) {
  pca <- read.table(eigenvec_file, header = FALSE)
  colnames(pca)[1:5] <- c("FID", "ID", "PC1", "PC2", "PC3")
  eigenval <- read.table(eigenval_file, header = FALSE)
  var_exp <- round(eigenval$V1 / sum(eigenval$V1) * 100, 2)
  pca <- merge(pca, metadata, by = "ID")
  
  p1 <- ggplot(pca, aes(x = PC1, y = PC2, color = Especie)) +
    geom_point(size = 3, alpha = 0.9) +
    scale_color_manual(values = colores) +
    labs(title = paste(titulo, "- PC1 vs PC2"),
         x = paste0("PC1 (", var_exp[1], "%)"),
         y = paste0("PC2 (", var_exp[2], "%)"),
         color = "Species") +
    tema_paper
  
  p2 <- ggplot(pca, aes(x = PC1, y = PC3, color = Especie)) +
    geom_point(size = 3, alpha = 0.9) +
    scale_color_manual(values = colores) +
    labs(title = paste(titulo, "- PC1 vs PC3"),
         x = paste0("PC1 (", var_exp[1], "%)"),
         y = paste0("PC3 (", var_exp[3], "%)"),
         color = "Species") +
    tema_paper
  
  list(p1, p2)
}

# 5. Generar plots
plots_005 <- plot_pca("pca_final_maf005.eigenvec", "pca_final_maf005.eigenval", "MAF 0.05")
plots_001 <- plot_pca("pca_final_maf001.eigenvec", "pca_final_maf001.eigenval", "MAF 0.01")

# 6. Ver en RStudio
plots_005[[1]]
plots_005[[2]]
plots_001[[1]]
plots_001[[2]]

# 7. Guardar PDFs
pdf("PCA_norte_maf005.pdf", width = 14, height = 6)
grid.arrange(plots_005[[1]], plots_005[[2]], ncol = 2)
dev.off()

pdf("PCA_norte_maf001.pdf", width = 14, height = 6)
grid.arrange(plots_001[[1]], plots_001[[2]], ncol = 2)
dev.off()

cat("Listo! PDFs guardados.\n")