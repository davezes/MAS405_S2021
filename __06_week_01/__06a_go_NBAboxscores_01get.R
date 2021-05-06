
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES



options(stringsAsFactors=FALSE)

library(rjson)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "NBAjsonData")

if(!dir.exists(xpath_write)) {
    dir.create(xpath_write)
}

xpath_write_games <- file.path(xpath_write, "_games")
xpath_write_day <- file.path(xpath_write, "_days")

if(!dir.exists(xpath_write_games)) {
    dir.create(xpath_write_games)
}
if(!dir.exists(xpath_write_day)) {
    dir.create(xpath_write_day)
}



xstartDate <- strptime("20181016:12", "%Y%m%d:%H") ; xstartDate
xendData <- strptime("20181021:12", "%Y%m%d:%H") ; xendData ### add one day -- end of 1617 season

xdateVec <- seq(xstartDate, xendData, by="hour") ; xdateVec


xdateStr <- sort(unique(format(xdateVec, "%Y%m%d")))


## xdateVec <- strptime(xdateStr, "%Y%m%d")
xdateStr



##### base URL for day data
xbaseday.url <- "http://data.nba.com/data/10s/json/cms/noseason/scoreboard/"

##### base URL for game data
xbasegame.url <- "http://data.nba.com/data/10s/json/cms/noseason/game/"




iid <- 1

for(iid in 1:length(xdateStr)) {
    
    this.date <- xdateStr[iid] ; this.date
    
    ## this.date <- "20170223"
    

    xthis.day.url <- paste0(xbaseday.url, this.date, "/games.json") ; xthis.day.url
    
    xthis.day.ls <- fromJSON(file=xthis.day.url)

    writeLines(toJSON(xthis.day.ls), con=file.path(xpath_write_day, paste0("dayof_", this.date, ".json")))
 

    ### now get game ids
    xthese.gameids <- unlist( lapply( xthis.day.ls[[ "sports_content" ]][[ "games" ]][[ "game" ]], "[[", "id" ) ) ; xthese.gameids
    
    cat(iid, this.date, "::  ")

    if(length(xthese.gameids) > 0) {
        
        ii <- 1
        
        for(ii in 1:length(xthese.gameids)) {
            
            xthis.game.id <- xthese.gameids[ii]
            
            xthis.game.url <- paste0(xbasegame.url, this.date, "/", xthis.game.id, "/boxscore.json") ; xthis.game.url
            
            xthis.game.ls <- fromJSON(file=xthis.game.url)
            
            writeLines(toJSON(xthis.game.ls), con=file.path(xpath_write_games, paste0("game_", this.date, "_", xthis.game.id, ".json")))
            
            cat(iid, xthis.game.id, "; ")
            
        }
        
    }
    
    Sys.sleep( runif(1, 0, 2) )
    
    cat("\n")
    
}


##### take a look at a day json and game json





