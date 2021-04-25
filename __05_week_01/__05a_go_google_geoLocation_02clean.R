

#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES


options(stringsAsFactors=FALSE)

library(rjson)


xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_read <- file.path(xpath_web_data, "GeoExample")




xfn <- list.files(xpath_read, pattern="^GM_")


ii <- 1

for(ii in 1:length(xfn)) {
    
    xthis_fn <- xfn[ii] ; xthis_fn
    
    xbname <- tools::file_path_sans_ext(xthis_fn) ; xbname
    
    xID <- strsplit(xbname, "_")[[1]][2] ; xID
    
    xls_xxGM <- fromJSON(file=file.path(xpath_read, xthis_fn))

    
    ############## do something here
    
    if( length(xls_xxGM[[ "results" ]]) != 1 ) {
        cat("This JSON has either none, or more than one, geometry location.", "\n")
    }
    
    xthisGeo <- xls_xxGM[[ "results" ]][[1]][[ "geometry" ]]
    
    print(xthisGeo[[ "location" ]])
    
}

