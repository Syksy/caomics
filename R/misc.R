##
#
# Miscellanceous utility functions
#
##

#' Omit character empty ("")
omitempty <- function(x) { if(length(which(x=="")>0)) { x[-which(x=="")] } else { x } }
