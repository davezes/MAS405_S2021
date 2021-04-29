
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES


#### https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY

options(stringsAsFactors=FALSE)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "ReverseGeoOzone")

if(!dir.exists(xpath_write)) {
    dir.create(xpath_write)
}


##########  please get your own API key  8-)
APIkey <- "AIzaSyCJrtmNblTajm-43hJTY4wmGHCU8vr8y7s"





if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}
library(RMySQL)
drv <- dbDriver("MySQL")




xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )

con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)

dbListTables(con)

dbGetInfo(con)


qstr <- paste0("SELECT * FROM ozone_data")
xx <- dbGetQuery(con, qstr)
xdfO3 <- xx

head(xdfO3)

dim(xdfO3)


n <- nrow(xdfO3) ; n

ii <- 1

for(ii in 1:n) {
    
    xthis_record <- xdfO3[ ii, ] ; xthis_record
    
    R_ID <- xthis_record[ 1, "ID" ] ; R_ID ###### should be unique
    R_lat <- xthis_record[ 1, "latitude" ] ; R_lat
    R_lon <- xthis_record[ 1, "longitude" ] ; R_lon
    
    xurl_str <- paste0(R_lat, ",", R_lon) ; xurl_str
    xurl_str


    xurl_str <- paste0("https://maps.googleapis.com/maps/api/geocode/json?latlng=", xurl_str, "&key=", APIkey) ; xurl_str

    ##### readLines(con=xurl_str)
    
    xRGAPIinfo <- try( readLines(con=xurl_str), silent=TRUE )
    kk <- 0
    while( class(xRGAPIinfo) %in% "try-error" & kk < 5 ) {
        kk <- kk + 1
        xRGAPIinfo <- try( readLines(con=xurl_str), silent=TRUE )
        cat("retried ID: ", R_ID, "\n")
        Sys.sleep(2)
    }

    writeLines(xRGAPIinfo, file.path(xpath_write, paste0("RGMozone__", R_ID, ".json")))
    
    cat("retrieved and saved ID: ", R_ID, "\n")

}


