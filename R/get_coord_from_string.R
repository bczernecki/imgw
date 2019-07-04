get_coord_from_string <- function(x , pattern = "Longitude") {
  tt <- gregexpr(pattern, txt)
  start <- tt[[1]][1] + attributes(tt[[1]])$match.length + 1
  substr(txt, start = start, stop = start + 8)
}
