

#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES


######## HERE IS 'CLEANING' (OF WHAT YOU ALREADY RETRIEVED)

options(stringsAsFactors=FALSE)

library(rjson)


xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")


xpath_read <- file.path(xpath_web_data, "NBAjsonData", "_games")






xfn <- list.files(xpath_read, pattern="^game_")


ii <- 1

for(ii in 1:length(xfn)) {
    
    xthis_fn <- xfn[ii]
    
    xbname <- tools::file_path_sans_ext(xthis_fn) ; xbname
    
    xthis_date <- strsplit(xbname, "_")[[1]][2] ; xthis_date
    
    xthis_gameID <- strsplit(xbname, "_")[[1]][3] ; xthis_gameID
    
    xls_xxGM <- fromJSON(file=file.path(xpath_read, xthis_fn))
    
    
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    
    cat(xthis_date, " :: ", xthis_gameID, "\n" )
    
}



