install_tutorial_dependencies <- function(file) {
  deps <- unique(packrat:::fileDependencies(file))
  need_install <- deps[!deps %in% utils::installed.packages()]

  if(length(need_install) < 1) {
    return(invisible())
  }

  need_install_formatted <- paste("  -", need_install, collapse = "\n")
  question <- sprintf("Would you like to install the following packages?\n%s",
                      need_install_formatted)

  if(!interactive()) {
    stop("The following packages need to be installed:\n",
         need_install_formatted)
  }

  answer <- utils::menu(choices = c("yes", "no"),
                        title = question)

  if(answer == 1) install.packages(need_install)
}


