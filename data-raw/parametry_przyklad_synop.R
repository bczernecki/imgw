synop <- meteo_daily("synop", year=2010)
head(synop)

nazwy <- data.frame(fullname = as.character(str_squish(colnames(synop))), stringsAsFactors = F) #usuwa podwojne spacje, etc.
abbrev <- read.csv("data-raw/parametry_skrot.csv", stringsAsFactors = F)


colnames(synop) <- dplyr::left_join(nazwy, abbrev)$abbr_ang
head(synop)

#plot(synop$t2m_daily_mean,synop$t2m_daily_mean
colnames(synop)
# zastanowic sie nad usunieciem zduplikowanych kolumn (Np. nazwa stacji)
