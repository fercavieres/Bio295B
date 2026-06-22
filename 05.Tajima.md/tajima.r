# ============================================================
# TAJIMA'S D - 4 especies norte
# Boxplot por especie
# Paleta oficial del proyecto
# ============================================================

library(ggplot2)
library(dplyr)
library(readr)

setwd("~/Desktop/PCA_norte/diversidad")

# 1. Paleta oficial
species_colors <- c(
  "S. skua"        = "#AADCF2",  # Van Gogh Blue
  "S. pomarinus"   = "#767B39",  # Spanish Bistre
  "S. parasiticus" = "#EAA624",  # Glazed Apricot
  "S. longicaudus" = "#C85555"   # Pomegranate
)

# 2. Leer archivos
files <- list(
  "skua_tajima_15kb.Tajima.D"        = "S. skua",
  "pomarinus_tajima_15kb.Tajima.D"   = "S. pomarinus",
  "parasiticus_tajima_15kb.Tajima.D" = "S. parasiticus",
  "longicaudus_tajima_15kb.Tajima.D" = "S. longicaudus"
)

data_list <- lapply(names(files), function(f) {
  df <- read_table(f, col_types = cols())
  df$Species <- files[[f]]
  df
})

combined <- bind_rows(data_list) %>%
  filter(!is.na(TajimaD)) %>%
  mutate(Species = factor(Species, levels = names(species_colors)))

# 3. Resumen consola
cat("N ventanas por especie:\n")
print(table(combined$Species))
cat("\nTajimaD promedio por especie:\n")
print(combined %>% group_by(Species) %>%
        summarise(mean_D = round(mean(TajimaD), 4),
                  median_D = round(median(TajimaD), 4), n = n()))

# 4. Tema GraphPad
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

# 5. Graficar
plot_tajima <- ggplot(combined, aes(x = Species, y = TajimaD, fill = Species)) +
  geom_boxplot(outlier.shape = NA, alpha = 1, color = "black",
               linewidth = 0.5, width = 0.7) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50", linewidth = 0.5) +
  scale_fill_manual(values = species_colors) +
  labs(
    title = "Tajima's D per Species (15 kb windows)",
    x = "Species",
    y = "Tajima's D"
  ) +
  tema_paper

plot_tajima

# 6. Guardar
ggsave("plot_Tajima.pdf", plot = plot_tajima, width = 8, height = 6)
cat("\nListo! plot_Tajima.pdf guardado.\n")