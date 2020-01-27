.onAttach <- function(...) {
  if (!interactive()) return()

    tip <- c(
      "The imgw package is deprecated and will be retiring soon. Please use the climate package instead. Learn more at https://github.com/bczernecki/climate."
    )

    packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
}
