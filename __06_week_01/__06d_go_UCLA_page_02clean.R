
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES



options(stringsAsFactors=FALSE)

library(XML)

library(rjson)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "htmlPageExample")


xpath_write_pages <- file.path(xpath_write, "_pages")

xfn <- list.files(xpath_write_pages, pattern="\\.html$")




iid <- 1

xthis_file <- xfn[ iid ]

xxhtml <- readLines( file.path(xpath_write_pages, xthis_file) )

### xxhtml

this_parsed_page <- htmlParse(xxhtml)











class(this_parsed_page)

names(this_parsed_page)

################# any tables ?

htmlTables <- readHTMLTable(this_parsed_page, header=TRUE, as.data.frame=TRUE, optional=TRUE)
htmlTables




xr <- xmlRoot(this_parsed_page) ##### which tag is this
xr

xmlChildren(xr)

names(xmlChildren(xr))

xmlName(xr)

xmlSize(xr)
length(xmlChildren(xr))

xmlAttrs(xr) ##### attributes of top tab -- e.g., class, id, etc.

xmlGetAttr(xr, "class")
xmlValue(xr)




xhead <- xmlChildren(xr)[[ "head" ]]
xhead


getNodeSet(xhead, "meta")

getNodeSet(xhead, "title")[[1]]

############# get title text


######### notice the structure. the literal representation shows <title> tag --
######### but the object class has the value as a list element

getNodeSet(xhead, "title")[[1]][[ "text" ]]


sapply(getNodeSet(xhead, "title"), "[[", "text")



############ body

xbody <- xmlChildren(xr)[[ "body" ]]
xbody


xbdivs <- getNodeSet(xbody, "div")

xxmd <- xbdivs[[2]]

xxx <- getNodeSet(xxmd, "div")

attributes(xxx[[3]])

xx2 <- getNodeSet(getNodeSet(xxx[[3]], "div")[[1]], "div")

xx3 <- getNodeSet(xx2[[1]], "div")
xx3


xx4 <- getNodeSet(xx3[[1]], "div")
xx4



xxls <- sapply(xx4, getNodeSet, "div")
xxls


############# we can flatten
yyls <- unlist(xxls)

yy1 <- yyls[[1]]
yy1

xmlChildren(yy1)

xmlSApply(yy1, getNodeSet, "div")

xmlSApply(yy1, getNodeSet, "img")

xmlSApply(yy1, getNodeSet, "div")[[ 2 ]]


yy2 <- xmlChildren(yy1)

yy2[[1]]

yy2[[1]][[ "a" ]][[ "img" ]]

z_link <- xmlGetAttr(yy2[[1]][[ "a" ]][[ "img" ]], "src")


yy2[[2]][[1]][[ "span" ]]

z_names <- paste0(xmlSApply(yy2[[2]][[1]], xmlValue, "span"), collapse=" ") ; z_names
z_names <- gsub("\\s+", " ", z_names)
z_names <- gsub("^\\s|\\s$", "", z_names)
z_names

z_status <- yy2[[2]][[2]][[ "text" ]]



####################################################### USING Xpath
####################################################### USING Xpath
####################################################### USING Xpath
####################################################### USING Xpath
####################################################### USING Xpath
####################################################### USING Xpath
####################################################### USING Xpath

/html/head/title





getNodeSet(this_parsed_page, "/html/head/title")[[1]][[ "text" ]]




getNodeSet(this_parsed_page, "/html/body/div[2]/div[3]/div/div/div[1]/div[1]/div[3]/div[1]/a/img")


library(dplyr)

################################ let's have some fun with dplyr while we're at it
f_funny <- function(x, i) {
    if(is.list(x)) {
        return(x[[i]])
    } else {
        return(x[i])
    }
}

getNodeSet(this_parsed_page, "/html/body/div[2]/div[3]/div/div/div[1]/div[1]/div[3]/div[1]/a/img") %>%
f_funny(1) %>%
xmlGetAttr("src")

getNodeSet(this_parsed_page, "/html/body/div[2]/div[3]/div/div/div[1]/div[1]/div[4]/div[1]/a/img") %>%
f_funny(1) %>%
xmlGetAttr("src")

getNodeSet(this_parsed_page, "/html/body/div[2]/div[3]/div/div/div[1]/div[1]/div[5]/div[1]/a/img") %>%
f_funny(1) %>%
xmlGetAttr("src")


/html/body/div[2]/div[3]/div/div/div[1]/div[1]/div[3]/div[1]/a/img

/html/body/div[2]/div[3]/div/div/div[1]/div[2]/div[1]/div[1]/a/img

################################################

htmlParse()
xmlTreeParse()
xmlGetAttr()
getNodeSet()
xmlChildren()



#############################

hTP <- xmlTreeParse(xxhtml, asText = TRUE, isHTML = TRUE)

class(hTP)


sapply(hTP, xmlGetAttr, "div")

sapply(hTP, xmlChildren)




xmlGetAttr(x1, "dir")
xmlValue(x1, "dir")










xmlTreeParse()
xmlName()
xmlSize()
xmlAttrs()
xmlGetAttr(, "dir")
xmlValue(, "dir")

xmlNamespace()




