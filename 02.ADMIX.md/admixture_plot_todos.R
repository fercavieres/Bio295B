# ============================================================
# ADMIXTURE - K=2 a K=10 (todos los K)
# Para material suplementario
# ============================================================

library(tidyverse)
library(ggtext)

setwd("~/Desktop/PCA_norte/ADMIXTURE")

# -------------------------------
# COLORES
# -------------------------------
ancestry_colors_list <- list(
  "1"  = c("K1"="#009ACD"),
  "2"  = c("K1"="#009ACD", "K2"="#FFFF00"),
  "3"  = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00"),
  "4"  = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00", "K4"="#8B4513"),
  "5"  = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00", "K4"="#8B4513", "K5"="#E41A1C"),
  "6"  = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00", "K4"="#8B4513", "K5"="#E41A1C", "K6"="#984EA3"),
  "7"  = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00", "K4"="#8B4513", "K5"="#E41A1C", "K6"="#984EA3", "K7"="#FF7F00"),
  "8"  = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00", "K4"="#8B4513", "K5"="#E41A1C", "K6"="#984EA3", "K7"="#FF7F00", "K8"="#F781BF"),
  "9"  = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00", "K4"="#8B4513", "K5"="#E41A1C", "K6"="#984EA3", "K7"="#FF7F00", "K8"="#F781BF", "K9"="#377EB8"),
  "10" = c("K1"="#009ACD", "K2"="#FFFF00", "K3"="#00CD00", "K4"="#8B4513", "K5"="#E41A1C", "K6"="#984EA3", "K7"="#FF7F00", "K8"="#F781BF", "K9"="#377EB8", "K10"="#A65628")
)

# Paleta oficial del proyecto
species_colors <- c(
  "S.skua"        = "#2a6db5",
  "S.pomarinus"   = "#3a8a52",
  "S.parasiticus" = "#d4732a",
  "S.longicaudus" = "#b83c3c"
)

species_order <- c("S.parasiticus", "S.longicaudus", "S.pomarinus", "S.skua")

metadata <- read.table("metadata_admix.tsv", sep = "\t", header = TRUE)

# -------------------------------
# FUNCIÓN PLOT
# -------------------------------
plot_admixture <- function(K) {
  Q_file <- paste0("admix_norte59_pruned.", K, ".Q")
  Q <- read.table(Q_file, header = FALSE)
  K_cols <- paste0("K", 1:K)
  colnames(Q) <- K_cols
  Q$SampleID <- metadata$SampleID
  Q <- Q %>% left_join(metadata, by = "SampleID")
  Q$Species <- factor(Q$Species, levels = species_order)

  Q[K_cols] <- lapply(Q[K_cols], as.numeric)
  row_tot <- rowSums(Q[K_cols], na.rm = TRUE)
  Q[K_cols] <- sweep(Q[K_cols], 1, ifelse(row_tot == 0, 1, row_tot), "/")
  Q[K_cols] <- as.data.frame(pmax(pmin(as.matrix(Q[K_cols]), 1), 0))
  Q[K_cols][is.na(Q[K_cols])] <- 0

  ancestry_colors <- ancestry_colors_list[[as.character(K)]]

  Q_ord <- Q %>%
    mutate(
      domK    = K_cols[max.col(select(., all_of(K_cols)), ties.method = "first")],
      domProp = pmax(!!!syms(K_cols)),
      domRank = match(domK, K_cols)
    ) %>%
    group_by(Species) %>%
    arrange(domRank, desc(domProp), .by_group = TRUE) %>%
    ungroup()

  Q_ord$SampleID <- factor(Q_ord$SampleID, levels = Q_ord$SampleID)

  n_by_species <- Q_ord %>% count(Species) %>% deframe()
  colored_labels <- setNames(
    paste0(
      "<span style='color:", species_colors[names(species_colors)], "'><b><i>",
      names(species_colors), "</i></b></span>",
      "<br><span style='font-size:9pt; color:#666'>(n=", n_by_species[names(species_colors)], ")</span>"
    ),
    names(species_colors)
  )

  admix_long <- Q_ord %>%
    pivot_longer(cols = all_of(K_cols), names_to = "Ancestry", values_to = "Proportion")

  pos_df <- Q_ord %>% group_by(Species) %>% mutate(pos = row_number()) %>% ungroup()
  sep_df <- pos_df %>% group_by(Species) %>% filter(pos < max(pos)) %>%
    transmute(Species, x = pos + 0.5) %>% ungroup()

  p <- ggplot(admix_long, aes(x = SampleID, y = Proportion, fill = Ancestry)) +
    geom_bar(stat = "identity", width = 1, color = NA) +
    facet_grid(~ Species, scales = "free_x", space = "free_x",
               labeller = as_labeller(colored_labels)) +
    scale_fill_manual(values = ancestry_colors, drop = FALSE) +
    geom_segment(
      data = pos_df %>% group_by(Species) %>%
        summarise(xstart = 0.5, xend = n() + 0.5, .groups = "drop"),
      aes(x = xstart, xend = xend, y = -0.03, yend = -0.03, color = Species),
      inherit.aes = FALSE, linewidth = 2.2, lineend = "butt"
    ) +
    scale_color_manual(values = species_colors, guide = "none") +
    geom_segment(data = sep_df,
                 aes(x = x, xend = x, y = -0.035, yend = 1),
                 inherit.aes = FALSE, linewidth = 0.25, color = "white") +
    scale_y_continuous(breaks = seq(0, 1, 0.25), expand = c(0, 0)) +
    coord_cartesian(ylim = c(-0.035, 1)) +
    labs(title = paste("ADMIXTURE (K =", K, ")"),
         x = "Species", y = "Ancestry Proportion", fill = "Ancestry") +
    theme_minimal(base_size = 12) +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      panel.grid = element_blank(),
      strip.text = element_markdown(size = 12, face = "bold"),
      panel.spacing.x = unit(0.8, "lines"),
      plot.title = element_text(size = 14, face = "bold"),
      plot.margin = margin(10, 15, 20, 15)
    )
  return(p)
}

# -------------------------------
# PASO 1 - VER EN RSTUDIO
# -------------------------------
plot_admixture(2)
plot_admixture(3)
plot_admixture(4)

# -------------------------------
# PASO 2 - GUARDAR TODOS LOS K EN PDF
# -------------------------------
for (K in 2:10) {
  p <- plot_admixture(K)
  ggsave(filename = paste0("ADMIXTURE_K", K, ".pdf"),
         plot = p, width = 16, height = 6)
  cat(paste0("K=", K, " guardado!\n"))
}

cat("Todos los plots guardados!\n")