library(imgw)
synop <- meteo_daily("synop", year=2010)
head(daily)

abbrev <- read.csv("data-raw/parametry_skrot.csv", stringsAsFactors = F)

orig_columns <- trimws(gsub("\\s+", " ", colnames(daily))) # remove double spaces

# fullname:
abbrev$fullname[match(orig_columns, abbrev$fullname)]

abbrev$abbr_ang[match(orig_columns, abbrev$fullname)]

merge(orig_columns, data2,
      by = c("Kod stacji", "Rok", "Miesiac"),
      all.x = TRUE)

nazwy <- data.frame(fullname = as.character(str_squish(colnames(synop))), stringsAsFactors = F) #usuwa podwojne spacje, etc.



colnames(synop) <- dplyr::left_join(nazwy, abbrev)$abbr_ang
head(synop)

#plot(synop$t2m_daily_mean,synop$t2m_daily_mean
colnames(synop)
# zastanowic sie nad usunieciem zduplikowanych kolumn (Np. nazwa stacji)
