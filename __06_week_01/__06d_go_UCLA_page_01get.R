
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES



options(stringsAsFactors=FALSE)

library(rjson)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "htmlPageExample")

if(!dir.exists(xpath_write)) {
    dir.create(xpath_write)
}

xpath_write_pages <- file.path(xpath_write, "_pages")

if(!dir.exists(xpath_write_pages)) {
    dir.create(xpath_write_pages)
}




pages2get <-
c(
"UCLAstatsGradStudents"     ="http://directory.stat.ucla.edu/active_students/all-active-students/"
)




iid <- 1

for(iid in 1:length(pages2get)) {
    
    this_page_url <- pages2get[iid]
    this_page_name <- names(pages2get)[iid] ; this_page_name
    
    xxhtml <- readLines( this_page_url )

    writeLines(xxhtml, con=file.path(xpath_write_pages, paste0(this_page_name, ".html")))
    
    cat(iid, "\n")
    
}







