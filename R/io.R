###
#
# Input/output and relevant parsers
#
###

#' Read CNA data with probe and segmentation files
#'
#' @export
readCNAprobesegments <- function(
	wd, # Working directory to start iterating filenames in
	probefilename = "probes.txt",
	segmentfilename = "segments.txt",
	sub = ".final", # Character strings to replace, often left-overs from a processing pipeline etc; sanitizing names
	...
){
	# List all subdirectories, presumably containing probe and segmentation files with predefined names
	f <- list.files()

	raw <- lapply(f, FUN=function(x){
		# Go to sample folder, first go to root
		setwd(x)

		list(
			# stringsAsFactors=FALSE just in case somebody's using R < 4.0
			probes = read.table(probefilename, sep="\t", header=TRUE, stringsAsFactors=FALSE),
			segments = read.table(segmentfilename, sep="\t", header=TRUE, stringsAsFactors=FALSE)
		)
	})
	names(raw) <- gsub(sub, "", f)
	
}

#' Read multianno annotated files with nested folder structure	
#'
#' @export
readMultianno <- function(
	wd, # Working directory to start iterating filenames in
	folderprefix = "^R", # grepping pattern to recognize folder sto iterate over
	filesuffix = "_multianno.txt", # grepping pattern to recognize multianno-annotated files by	
	sep = "\t",
	header= TRUE,
	na.strings = ".",
	...
){
	# Iterate through folders and read all calls there-in with possibly multiple files, creating a nested list
	raw <- lapply(grep(folderprefix, list.files(), value=TRUE), FUN=function(x){
		setwd(x)
		# Read in the file(s) inside the folder
		tmp <- lapply(grep(filesuffix, list.files(), value=TRUE), FUN=function(f){
			read.table(f, sep=sep, header=header, na.strings=na.strings)
		})
		# Inner loop names
		names(tmp) <- grep(filesuffix, list.files(), value=TRUE)
		setwd("..")
		tmp
	})
	# Outer loop names
	names(raw) <- grep(folderprefix, list.files(), value=TRUE)
	raw
}
