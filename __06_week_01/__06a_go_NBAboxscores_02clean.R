

#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES


######## HERE IS 'CLEANING' (OF WHAT YOU ALREADY RETRIEVED)

options(stringsAsFactors=FALSE)

library(rjson)


xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")


xpath_read <- file.path(xpath_web_data, "NBAjsonData", "_games")






xfn <- list.files(xpath_read, pattern="^game_") ; xfn


xmx_out <- matrix(NA, length(xfn), 3)
colnames(xmx_out) <- c("date", "VT", "HT")
xmx_out


ii <- 1

for(ii in 1:length(xfn)) {
    
    xthis_fn <- xfn[ii]
    
    xbname <- tools::file_path_sans_ext(xthis_fn) ; xbname
    
    xthis_date <- strsplit(xbname, "_")[[1]][2] ; xthis_date
    
    xthis_gameID <- strsplit(xbname, "_")[[1]][3] ; xthis_gameID
    
    xls_xxGM <- fromJSON(file=file.path(xpath_read, xthis_fn))
    
    xls_xxGM$sports_content$game$officials
    
    paste( unlist( lapply( xls_xxGM$sports_content$game$officials, "[[", "last_name" ) ), collapse="; " )
    
    
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    ######################  DO STUFF HERE
    
    xls_xxGM$sports_content$game
    
    
    xVT <- xls_xxGM[[ c("sports_content" , "game" , "visitor" , "city") ]]
    xHT <- xls_xxGM[[ c("sports_content" , "game" , "home" , "city") ]]
    
    xmx_out[ ii, "date" ] <- xthis_date
    xmx_out[ ii, "VT" ] <- xVT
    xmx_out[ ii, "HT" ] <- xHT
    
    #xls_xxGM[[ "sports_content" ]][[ "game" ]][[ "visitor" ]][[ "city" ]]
    
    #lapply( xls_xxGM[[ "sports_content" ]][[ "game" ]][ c("visitor", "home") ], "[[", "city" )
    
    cat(xthis_date, " :: ", xthis_gameID, "\n" )
    
}

xmx_out

