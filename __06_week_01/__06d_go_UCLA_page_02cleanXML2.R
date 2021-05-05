
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES



options(stringsAsFactors=FALSE)

library(xml2)

library(dplyr)

library(stringr)

#### library(rjson)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "htmlPageExample")


xpath_write_pages <- file.path(xpath_write, "_pages")

xfn <- list.files(xpath_write_pages, pattern="\\.html$")




iid <- 1

xthis_file <- xfn[ iid ]

xxhtml <- readLines( file.path(xpath_write_pages, xthis_file) )

### xxhtml

this_parsed_page <- read_xml( paste(xxhtml, collapse="  "), as_html=TRUE)

class(this_parsed_page)

names(this_parsed_page)



################# attributes


xml_attrs(this_parsed_page)


###### two main nodes within html root
xml_children(this_parsed_page)

length(xml_children(this_parsed_page))

names(xml_children(this_parsed_page))



################ welcome to XPath

xml_path(x=this_parsed_page)


xr <- xml_children(this_parsed_page)

xml_path(x=xr)


xml_children(xr[1])

xml_name(xr[1])



############# get title text


xml_find_all(xr[1], "title") %>% xml_text() %>% str_trim()




###################################

############ body


xbody <- xml_find_all(this_parsed_page, "body")


xbdivs <- xml_find_all(xbody, "div")
xbdivs


#################### REMAINDER COMPLETED IN CLASS

################### use Chrome inspector to grab XPath







