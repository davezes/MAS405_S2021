

options(stringsAsFactors=FALSE, width=400, max.print=10^6)


projpath <- getwd()

library(XML)
library(rjson)

library(rlist)

library(dynamicDensity)


xpath_mainData <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_scrapedData <- file.path(xpath_mainData, "MLBjsons")

if(!dir.exists(xpath_scrapedData)) {
    dir.create(xpath_scrapedData)
}

xpath_scrapedDataDays <- file.path(xpath_scrapedData, "MLBdays")

if(!dir.exists(xpath_scrapedDataDays)) {
    dir.create(xpath_scrapedDataDays)
}

xpath_scrapedDataGames <- file.path(xpath_scrapedData, "MLBgames")

if(!dir.exists(xpath_scrapedDataGames)) {
    dir.create(xpath_scrapedDataGames)
}


from.date <- "20190403:12" ; to.date <- "20190405:12" #### A's Seattle in Japan during spring training  preseason


#######################



xDayBaseURL <- "http://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date="

xGameBaseURL <- "http://statsapi.mlb.com"

date_rng <- seq( from=strptime( from.date, "%Y%m%d:%H" ), to=strptime( to.date, "%Y%m%d:%H" ), by="hour" )

xdays_rng <- sort( unique(format( date_rng, "%Y%m%d")) ) ; xdays_rng

i <- 2

for( i in 1:length(xdays_rng) ) {
    
    xdate <- xdays_rng[i] ; xdate
    #    xdate <- "20100424"
    xx <- format( strptime(xdate, "%Y%m%d"), "%m/%d/%Y" )
    
    xthis_dayURL <- paste0(xDayBaseURL, xx) ; xthis_dayURL
    
    xDL <- readLines(xthis_dayURL)
    
    writeLines(xDL, file.path(xpath_scrapedDataDays, paste0("day__", xdate, ".json")))
    
    xxxx <- readLines(file.path(xpath_scrapedDataDays, paste0("day__", xdate, ".json")))
    
    xDayJSON <- fromJSON(json_str=paste(xxxx, collapse=" "))
    
    ############
    
    if( length(xDayJSON[[ "dates" ]]) == 1 ) {
        
        xls_games <- xDayJSON[[ "dates" ]][[ 1 ]][[ "games" ]] ; #xls_games
        
        if( length(xls_games) > 0 ) {
            
            jj <- 1
            for(jj in 1:length(xls_games)) {
                xthis_game <- xls_games[[ jj ]]
                xthis_live_link <- xthis_game[[ "link" ]]
                xthis_live_link
                ##### get game jsons
                
                Sys.sleep(3)
                
                if(!is.null(xthis_live_link)) {
                    
                    kk <- 0
                    xbool_keep_going <- TRUE
                    while( xbool_keep_going & kk < 5 ) {
                        
                        xthis_game_data <- readLines( paste0(xGameBaseURL, xthis_live_link) )
                        
                        xpk <- strsplit(xthis_live_link, "/")[[1]][5] ; xpk
                        
                        if( class(xthis_game_data) %in% "try-error" ) {
                            Sys.sleep(3)
                            kk <- kk + 1
                            
                            cat("** Retrying ", xdate, " game ID ", xpk, "\n")
                            
                        } else {
                            
                            ########### look here!
                            save(xthis_game_data, file=file.path(xpath_scrapedDataGames, paste0("game__", xdate, "__", xpk, ".RData")))
                            
                            ######## raw json, uncompressed
                            #writeLines(xthis_game_data, file.path(xpath_scrapedDataGames, paste0("game__", xdate, "__", xpk, ".json")))
                            
                            xbool_keep_going <- FALSE
                            
                            cat("Got ", xdate, " game ID ", xpk, "\n")
                            
                        }
                    }
                }
            }
        }
    }
}


##### xxx <- fromJSON(json_str=paste(xthis_game_data, collapse="  "))



##### liveData -> plays -> allPlays (each at bat) Array -> [i] -> matchup -> pitcher

##### liveData -> plays -> allPlays (each at bat) Array -> [i] -> playEvents (each pitch) Array [j] -> pitchData

##### liveData -> plays -> allPlays (each at bat) Array -> [i] -> playEvents (each pitch) Array [j] -> pitchNumber




