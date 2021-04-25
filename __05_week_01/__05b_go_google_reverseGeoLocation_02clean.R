

#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES


######## HERE IS 'CLEANING' (OF WHAT YOU ALREADY RETRIEVED)

options(stringsAsFactors=FALSE)

library(rjson)


xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")


xpath_read <- file.path(xpath_web_data, "ReverseGeoOzone")




if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}
library(RMySQL)
drv <- dbDriver("MySQL")

xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
dzpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )

con <- dbConnect(drv, user=xdbuser, password=dzpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)

dbListTables(con)

dbGetInfo(con)



qstr <-
paste0(
"CREATE TABLE ",
"ozone_data_plus",
" LIKE ozone_data"
)
qstr
xx <- dbGetQuery(con, qstr)

qstr <-
paste0(
"INSERT ", "ozone_data_plus",
" SELECT * FROM ", "ozone_data"
)
qstr

xx <- dbGetQuery(con, qstr)

dbListTables(con)



dbGetQuery(con, "SELECT * FROM ozone_data_plus")

####################### rare instance of using ALTER to add column

qstr <-
paste0(
"ALTER TABLE ", "ozone_data_plus",
"  ADD reverseGeoInfo JSON "
)
qstr

xx <- dbGetQuery(con, qstr)


dbGetQuery(con, "SHOW COLUMNS FROM ozone_data_plus")



xfn <- list.files(xpath_read, pattern="^RGMozone__")


ii <- 1

for(ii in 1:length(xfn)) {
    
    xthis_fn <- xfn[ii] ; xthis_fn
    
    xbname <- tools::file_path_sans_ext(xthis_fn)
    
    xID <- strsplit(xbname, "__")[[1]][2] ; xID
    
    ### xls_xxGM <- fromJSON(file=file.path(xpath_read, xthis_fn))
    
    xjson_xxGM <- readLines(con=file.path(xpath_read, xthis_fn))
    
    xjson_xxGM <- paste( xjson_xxGM, collapse="\n" )
    
    xjson_xxGMclean <- dbEscapeStrings(con, xjson_xxGM)
    
    ############## do something here
    
    
    qstr <-
    paste0(
    "UPDATE ozone_data_plus ",
    "  SET reverseGeoInfo='", xjson_xxGMclean, "' ",
    "  WHERE ID='", xID, "'"
    )
    qstr
    
    xx <- dbGetQuery(con, qstr)
    
    cat("Updated ID: ", xID, "\n")
    
}


qstr <-
paste0(
" SELECT * FROM  ozone_data_plus  LIMIT 10"
)
qstr

xx <- dbGetQuery(con, qstr)




############################

qstr <-
paste0(
" SELECT ID, longitude, latitude, O3, reverseGeoInfo->>'$.status' FROM  ozone_data_plus "
)
qstr

xx <- dbGetQuery(con, qstr)
xx



qstr <-
paste0(
" SELECT ID, longitude, latitude, O3, reverseGeoInfo->>'$.plus_code.compound_code' FROM  ozone_data_plus "
)
qstr

xx <- dbGetQuery(con, qstr)
xx



qstr <-
paste0(
" SELECT ID, longitude, latitude, O3, reverseGeoInfo->>'$.results[0].formatted_address' FROM  ozone_data_plus "
)
qstr

xx <- dbGetQuery(con, qstr)
xx








######################

yy <- dbGetQuery(con, "SHOW COLUMNS FROM ozone_data_plus")
xcols <- setdiff(yy[ , "Field" ], "reverseGeoInfo")

qstr <-
paste0(
"SELECT ",
paste(xcols, collapse=", "),
", reverseGeoInfo->'$.status' FROM  ozone_data_plus "
)
qstr

xx <- dbGetQuery(con, qstr)
xx
