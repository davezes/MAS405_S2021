
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES



options(stringsAsFactors=FALSE)

library(rjson)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "wikiPageExample")

if(!dir.exists(xpath_write)) {
    dir.create(xpath_write)
}

xpath_write_pages <- file.path(xpath_write, "_pages")

if(!dir.exists(xpath_write_pages)) {
    dir.create(xpath_write_pages)
}



wikipedia_url <- "https://en.wikipedia.org/wiki/"

pages2get <-
c(
"List_of_monarchs_of_Vietnam",
"List_of_French_monarchs"
)




iid <- 1

for(iid in 1:length(pages2get)) {
    
    this_page <- pages2get[iid] ; this_page
    
    xxhtml <- readLines( paste0(wikipedia_url, this_page) )

    writeLines(xxhtml, con=file.path(xpath_write_pages, paste0(this_page, ".html")))
    
    cat(iid, "\n")
    
}







