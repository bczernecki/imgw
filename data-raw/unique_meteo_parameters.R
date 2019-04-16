library(imgw)
library(stringr)
all_meteo_metadata = dplyr::bind_rows(
  m_hs[[1]],
  m_hc[[1]],
  m_ds[[1]],
  m_ds[[2]],
  m_dc[[1]],
  m_dc[[2]],
  m_dp[[1]],
  m_ms[[1]],
  m_ms[[2]],
  m_mc[[1]],
  m_mc[[2]],
  m_mp[[1]]
)

unique_meteo_parameters = str_squish(x$parameters) #usuwa podwojne spacje, etc.
unique_meteo_parameters = unique(unique_meteo_parameters)
unique_meteo_parameters = sort(unique_meteo_parameters)

# Bartek, czym się różni:
# Suma dobowa opadów [mm]
# Suma dobowa opadu [mm]
