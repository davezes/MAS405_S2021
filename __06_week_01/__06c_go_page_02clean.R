
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES

library(stringr)


options(stringsAsFactors=FALSE)

library(XML)

library(rjson)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "wikiPageExample")


xpath_write_pages <- file.path(xpath_write, "_pages")

xfn <- list.files(xpath_write_pages, pattern="\\.html$")




iid <- 1

xthis_file <- xfn[ iid ]

xxhtml <- readLines( file.path(xpath_write_pages, xthis_file) )

### xxhtml

this_parsed_page <- htmlParse(xxhtml)

class(this_parsed_page)

attributes(this_parsed_page)

str(this_parsed_page)



xmlRoot(this_parsed_page)

xmlChildren(this_parsed_page)

length(xmlChildren(this_parsed_page))

names(xmlChildren(this_parsed_page))

x1 <- xmlChildren(this_parsed_page)[[2]]

names( xmlChildren(x1) )

x2 <- xmlChildren(x1)[[ "head" ]]

xt <- xmlChildren(x2)[[ "title" ]]

xmlChildren(xt)[[ "text" ]]


############## get all links in
xlinkNS <- getNodeSet(x2, "link")
xlinkNS

########### get link attributes
sapply(xlinkNS, xmlAttrs)









htmlTables <- readHTMLTable(this_parsed_page, header=TRUE, as.data.frame=TRUE, optional=TRUE)

htmlTables[[5]]



#### xregex <- "Henry IV" ; x <- htmlTables[[ 19 ]]


f_fun <- function(x, xregex, fixed) {
    #y <- paste(as.vector(as.matrix(x)), collapse=" ")
    y <- paste(unlist(x), collapse=" ")
    y <- gsub("\\s+", " ", y)
    y <- gsub("\t|\n", " ", y)
    return(grepl(xregex, y, fixed=fixed))
}

xmask <- unlist(lapply(htmlTables, f_fun, xregex="Henry IV", fixed=TRUE) )


xmask <- unlist(lapply(htmlTables, f_fun, xregex="[hH]enry\\s*IV", fixed=FALSE) )
xmask



htmlTables[ xmask ]



xmask <- unlist(lapply(htmlTables, function(x) { y <- paste(as.vector(as.matrix(x)), collapse=" ") ; return(grepl("Henry IV", y)) } ) )

htmlTables[ xmask ]



htmlTables

htmlTables[[1]]



class(htmlTables[[1]])

