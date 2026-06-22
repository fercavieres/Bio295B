# ============================================================
# COMPARACIÓN HET - 3 PDFs (MAF005, MAF001, noMAF)
# Cada PDF = boxplot con las 4 especies
# Paleta oficial del proyecto
# ============================================================

library(ggplot2)
library(dplyr)
library(readr)

setwd("~/Desktop/PCA_norte/diversidad")

# Paleta oficial
species_colors <- c(
  "S. longicaudus" = "#C85555",  # Pomegranate
  "S. pomarinus"   = "#767B39",  # Spanish Bistre
  "S. skua"        = "#AADCF2",  # Van Gogh Blue
  "S. parasiticus" = "#EAA624"   # Glazed Apricot
)

# Tema GraphPad
tema_paper <- theme_classic(base_size = 13) +
  theme(
    axis.line = element_line(colour = "black", linewidth = 0.8),
    axis.ticks = element_line(colour = "black", linewidth = 0.6),
    axis.ticks.length = unit(4, "pt"),
    axis.title = element_text(face = "bold", colour = "black"),
    axis.title.x = element_text(face = "bold", margin = margin(t = 8)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 8)),
    axis.text = element_text(colour = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1, face = "italic"),
    legend.position = "none",
    plot.title = element_text(size = 13, face = "bold"),
    plot.margin = margin(t = 10, r = 15, b = 5, l = 10)
  )

# Función
plot_het <- function(archivos, titulo, nombre_pdf) {
  data_list <- lapply(names(archivos), function(file_path) {
    df <- read_table(file_path, col_types = cols())
    df$Species <- archivos[[file_path]]
    df$Ho <- 1 - (as.numeric(df$`O(HOM)`) / as.numeric(df$N_SITES))
    df
  })
  
  combined <- bind_rows(data_list) %>%
    filter(!is.na(Species)) %>%
    mutate(Species = factor(Species, levels = names(species_colors)))
  
  p <- ggplot(combined, aes(x = Species, y = Ho, fill = Species)) +
    geom_boxplot(outlier.shape = NA, alpha = 1, color = "black",
                 linewidth = 0.5, width = 0.7) +
    geom_jitter(width = 0.2, size = 1.5, alpha = 0.6, color = "black") +
    scale_fill_manual(values = species_colors) +
    labs(title = titulo,
         x = "Species",
         y = expression(Observed ~ Heterozygosity ~ (italic(H)[o]))) +
    tema_paper
  
  print(p)
  ggsave(paste0(nombre_pdf, ".pdf"), plot = p, width = 8, height = 6)
  cat(paste0(nombre_pdf, ".pdf guardado!\n"))
}

# MAF 0.05
plot_het(
  list("skua.het" = "S. skua", "pomarinus.het" = "S. pomarinus",
       "parasiticus.het" = "S. parasiticus", "longicaudus.het" = "S. longicaudus"),
  titulo = "Observed Heterozygosity - MAF 0.05", nombre_pdf = "HET_maf005"
)

# MAF 0.01
plot_het(
  list("skua_maf001.het" = "S. skua", "pomarinus_maf001.het" = "S. pomarinus",
       "parasiticus_maf001.het" = "S. parasiticus", "longicaudus_maf001.het" = "S. longicaudus"),
  titulo = "Observed Heterozygosity - MAF 0.01", nombre_pdf = "HET_maf001"
)

# Sin filtro MAF
plot_het(
  list("skua_noMAF.het" = "S. skua", "pomarinus_noMAF.het" = "S. pomarinus",
       "parasiticus_noMAF.het" = "S. parasiticus", "longicaudus_noMAF.het" = "S. longicaudus"),
  titulo = "Observed Heterozygosity - Sin filtro MAF", nombre_pdf = "HET_noMAF"
)

cat("Listo! 3 PDFs guardados.\n")