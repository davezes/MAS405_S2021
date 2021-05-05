

options(stringsAsFactors=FALSE, width=400, max.print=10^6)


projpath <- getwd()

library(XML)
library(rjson)

library(rlist)
library(dynamicDensity)


xpath_mainData <- Sys.getenv("PATH_DZ_MAIN_DATA")


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



#######################

if(FALSE) {
    xpatternFN <- "^game__2019"
    xbigDFname <- "2019"
    source( file.path(projpath, "_s_readData.R") )
}






xfn <- list.files(xpath_scrapedDataGames, pattern=xpatternFN)
length(xfn)


df_list <- list()

ii <- 1

for(ii in 1:length(xfn)) {
    
    load( file.path(xpath_scrapedDataGames, xfn[ii]) )
    
    xxx <- fromJSON( paste(xthis_game_data, collapse="  ") )
    
    xgameDateInfo <- xxx[[ "gameData" ]][[ "datetime" ]]
    
    xVT <- xxx[[ "gameData" ]][[ "teams" ]][[ "away" ]][[ "abbreviation" ]] ; xVT
    xHT <- xxx[[ "gameData" ]][[ "teams" ]][[ "home" ]][[ "abbreviation" ]] ; xHT
    
    xall_plays <- xxx[[ "liveData" ]][[ "plays" ]][[ "allPlays" ]]
    
    length(xall_plays)
    
    
    iiplay <- 1
    
    if( length(xall_plays) > 0 ) {
        
        for(iiplay in 1:length(xall_plays)) {
            
            xthis_play <- xall_plays[[ iiplay ]]
            
            xthis_pitcher <- xthis_play[[ "matchup" ]][[ "pitcher" ]]
            
            xthis_play_events <- xthis_play[[ "playEvents" ]]
             
        }
    }
    
    cat(ii, xfn[ii], "\n")
}


object.size(df_list)
