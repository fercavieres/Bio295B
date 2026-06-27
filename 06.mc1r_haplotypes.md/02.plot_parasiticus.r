# 02. MC1R Haplotype Frequency Map — *S. parasiticus*

Visualización de las frecuencias haplotípicas de MC1R por localidad de muestreo en un mapa circumpolár ártico, usando pie charts superpuestos sobre cada localidad.

- **Input:** `MC1R_parasiticus_haplotipos.fasta`
- **Output:** `plot_MC1R_pie_mapa_v2.pdf`
- **Librerías R:** `ggplot2`, `sf`, `rnaturalearth`, `dplyr`, `tidyr`, `scatterpie`

El script lee el FASTA, identifica haplotipos únicos por comparación de secuencias, los agrupa en 4 haplotipos frecuentes nombrados por sus cambios aminoacídicos clave + categoría "Otros", y los plotea en mapa.

**Haplotipos frecuentes identificados:**

| ID | Nombre | Cambios aminoacídicos |
|---|---|---|
| H3 | R8H/C230R | `#C85555` |
| H1 | E12K/C230H | `#AADCF2` |
| H4 | R8H/I38V/C230R | `#EAA624` |
| H10 | E12K/C230R | `#767B39` |
| — | Otros | `grey70` |

**Localidades:**

| Código | Nombre | País |
|---|---|---|
| SVAL | Svalbard | Noruega |
| BREN | Brensholmen | Noruega |
| SLET | Slettnes | Noruega |
| ALEU | Aleutian Islands | Alaska |
| BERI | Bering Sea | Alaska |
| CHIR | Chirikof Island | Alaska |
| BEAU | Beaufort Sea | Alaska |

---

## Script — `02.mc1r_haplotype_map.R`

```r
# ============================================================
# MC1R - Pie charts de haplotipos por localidad en mapa
# S. parasiticus — versión final con nomenclatura aminoacídica
# ============================================================

library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)
library(tidyr)
library(scatterpie)

# 1. Leer FASTA y asignar haplotipos
fasta_file <- "~/Desktop/PCA_norte/mc1r/MC1R_parasiticus_haplotipos.fasta"

seqs <- list()
current <- NULL
con <- file(fasta_file, "r")
while(TRUE) {
  line <- readLines(con, n=1)
  if(length(line) == 0) break
  line <- trimws(line)
  if(startsWith(line, ">")) {
    current <- substring(line, 2)
    seqs[[current]] <- ""
  } else {
    seqs[[current]] <- paste0(seqs[[current]], line)
  }
}
close(con)

# 2. Identificar haplotipos únicos
seq_to_hap <- list()
hap_counter <- 0
hap_assignment <- c()

for(name in names(seqs)) {
  if(name == "SC_chilensis_ref") next
  seq <- seqs[[name]]
  if(is.null(seq_to_hap[[seq]])) {
    hap_counter <- hap_counter + 1
    seq_to_hap[[seq]] <- paste0("H", hap_counter)
  }
  hap_assignment[name] <- seq_to_hap[[seq]]
}

# 3. Asignar localidad
localidad_map <- c(
  "JJW5680_hap1"="ALEU", "JJW5680_hap2"="ALEU",
  "JJW730_hap1"="ALEU",  "JJW730_hap2"="ALEU",
  "JJW4274_hap1"="BERI", "JJW4274_hap2"="BERI",
  "JJW4273_hap1"="BERI", "JJW4273_hap2"="BERI",
  "T1-15_hap1"="SVAL",   "T1-15_hap2"="SVAL",
  "T14-19_hap1"="SVAL",  "T14-19_hap2"="SVAL",
  "T2-15_hap1"="SVAL",   "T2-15_hap2"="SVAL",
  "T3-10_hap1"="SVAL",   "T3-10_hap2"="SVAL",
  "T4-10_hap1"="SVAL",   "T4-10_hap2"="SVAL",
  "T7-11_hap1"="SVAL",   "T7-11_hap2"="SVAL",
  "TS17-16_hap1"="SVAL", "TS17-16_hap2"="SVAL",
  "TB1-15_hap1"="BREN",  "TB1-15_hap2"="BREN",
  "TB1-16_hap1"="BREN",  "TB1-16_hap2"="BREN",
  "TB2-16_hap1"="BREN",  "TB2-16_hap2"="BREN",
  "TB3-11_hap1"="BREN",  "TB3-11_hap2"="BREN",
  "TB4-11_hap1"="BREN",  "TB4-11_hap2"="BREN",
  "TB6-11_hap1"="BREN",  "TB6-11_hap2"="BREN",
  "AM_2019_hap1"="SLET", "AM_2019_hap2"="SLET",
  "AX_2016_hap1"="SLET", "AX_2016_hap2"="SLET",
  "HK_2019_hap1"="SLET", "HK_2019_hap2"="SLET",
  "JX_2019_hap1"="SLET", "JX_2019_hap2"="SLET",
  "ZR_2019_hap1"="SLET", "ZR_2019_hap2"="SLET",
  "SPA9_hap1"="BEAU",    "SPA9_hap2"="BEAU",
  "UAMX602_hap1"="BEAU", "UAMX602_hap2"="BEAU",
  "UAMX623_hap1"="BEAU", "UAMX623_hap2"="BEAU",
  "SPA1_hap1"="CHIR",    "SPA1_hap2"="CHIR",
  "UAMX5074_hap1"="CHIR","UAMX5074_hap2"="CHIR",
  "SRR22267306_hap1"="SVAL", "SRR22267306_hap2"="SVAL",
  "SRR10019934_hap1"="SVAL", "SRR10019934_hap2"="SVAL",
  "SRR10019945_hap1"="SVAL", "SRR10019945_hap2"="SVAL",
  "SRR9946748_hap1"="BEAU",  "SRR9946748_hap2"="BEAU"
)

# 4. Tabla de frecuencias con nomenclatura aminoacídica
df <- data.frame(
  muestra = names(hap_assignment),
  haplotipo = as.character(hap_assignment),
  stringsAsFactors = FALSE
) %>%
  mutate(localidad = localidad_map[muestra]) %>%
  filter(!is.na(localidad))

hap_rename <- c(
  "H3"  = "R8H/C230R",
  "H1"  = "E12K/C230H",
  "H4"  = "R8H/I38V/C230R",
  "H10" = "E12K/C230R"
)

df <- df %>%
  mutate(haplotipo_clean = case_when(
    haplotipo %in% names(hap_rename) ~ hap_rename[haplotipo],
    TRUE ~ "Otros"
  ))

freq_df <- df %>%
  group_by(localidad, haplotipo_clean) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(localidad) %>%
  mutate(freq = n / sum(n)) %>%
  ungroup()

# 5. Coordenadas
coords <- data.frame(
  localidad = c("SVAL", "BREN", "SLET", "ALEU", "BERI", "CHIR", "BEAU"),
  nombre    = c("Svalbard", "Brensholmen", "Slettnes", "Aleutian Is.", "Bering Sea", "Chirikof Is.", "Beaufort Sea"),
  Lat = c(78.9, 69.7, 71.1, 51.4, 60.4, 55.8, 70.5),
  Lon = c(17.0, 15.0, 30.0, -178.0, -172.7, -155.6, -152.0),
  nudge_x = c(0, -4e5, 4e5, 0, 0, 0, 0),
  nudge_y = c(3.5e5, -3.5e5, 3.5e5, 3.5e5, 3.5e5, -3.5e5, 3.5e5)
)

# 6. Tabla wide para scatterpie
all_haps <- sort(unique(freq_df$haplotipo_clean))
pie_data <- freq_df %>%
  pivot_wider(id_cols = localidad, names_from = haplotipo_clean,
              values_from = freq, values_fill = 0) %>%
  left_join(coords, by = "localidad")

# 7. Paleta
hap_colors <- c(
  "R8H/C230R"      = "#C85555",
  "E12K/C230H"     = "#AADCF2",
  "R8H/I38V/C230R" = "#EAA624",
  "E12K/C230R"     = "#767B39",
  "Otros"          = "grey70"
)

# 8. Mapa
world <- ne_countries(scale = "medium", returnclass = "sf")
proj <- "+proj=laea +lat_0=90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
world_proj <- st_transform(world, crs = proj)

coords_sf <- st_as_sf(coords, coords = c("Lon", "Lat"), crs = 4326)
coords_proj <- st_transform(coords_sf, crs = proj)
pie_data_proj <- cbind(pie_data, st_coordinates(coords_proj))
labels_proj <- cbind(coords, st_coordinates(coords_proj))

theta <- seq(0, 2*pi, length.out=200)
radio <- 4.3e6
circ_coords <- rbind(cbind(radio*cos(theta), radio*sin(theta)),
                     c(radio*cos(0), radio*sin(0)))
circulo <- st_sfc(st_polygon(list(circ_coords)), crs = proj)
world_clip <- st_intersection(world_proj, circulo)

mapa <- ggplot() +
  geom_sf(data = circulo, fill = "#ddeeff", color = "grey60", linewidth = 0.5) +
  geom_sf(data = world_clip, fill = "grey82", color = "white", linewidth = 0.15) +
  geom_text(data = labels_proj,
            aes(x = X + nudge_x, y = Y + nudge_y, label = nombre),
            size = 2.8, color = "grey20", fontface = "italic") +
  geom_scatterpie(data = pie_data_proj,
                  aes(x = X, y = Y, r = 2.5e5),
                  cols = all_haps,
                  color = "black", linewidth = 0.3) +
  scale_fill_manual(values = hap_colors, name = "Haplotype") +
  coord_sf(crs = proj, xlim = c(-4.5e6, 4.5e6),
           ylim = c(-4.5e6, 4.5e6), expand = FALSE) +
  labs(title = expression(paste("MC1R haplotype frequencies - ", italic("S. parasiticus")))) +
  theme_void(base_size = 12) +
  theme(
    plot.title = element_text(size = 13, face = "bold",
                              hjust = 0.5, margin = margin(b=10)),
    legend.text = element_text(size = 10),
    legend.title = element_text(face = "bold", size = 11),
    legend.position = "right",
    plot.background = element_rect(fill = "white", color = NA)
  )

mapa

ggsave("~/Desktop/PCA_norte/mc1r/plot_MC1R_pie_mapa_v2.pdf",
       plot = mapa, width = 10, height = 9)

cat("\nListo! plot_MC1R_pie_mapa_v2.pdf guardado.\n")
```