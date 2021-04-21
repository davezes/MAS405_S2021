



projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)


drv <- dbDriver("MySQL")






########################################



xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xpw     <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )



con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)




xpathTables <- file.path("___data")


dfx <- read.table( file.path(xpathTables, "ozone.tsv") , sep="\t", header=TRUE )
head(dfx)


### ozone_data is called "pothole" name convention

xbool.tableExists <- dbExistsTable(con, "ozone_data") ; xbool.tableExists



############################## IMPORTANT NOTE -- THE FOLLOWING CODE CHUNK DESTROYS THE TABLE METADATA
############################## IN REAL LIFE, YOU'LL SURELY WANT STRICT LIMITATIONS OVER THIS OPERATION

if(xbool.tableExists) {
    qstr <- paste("DROP TABLE ozone_data",  sep="")
    xx <- dbGetQuery(con, qstr)
}



## use double or float -- avoid 'numeric'
qstr <-
paste0(
"
CREATE TABLE ozone_data
(ID INT NOT NULL AUTO_INCREMENT, longitude DOUBLE, latitude DOUBLE, O3 DOUBLE, PRIMARY KEY (ID))
"
)
xx <- dbGetQuery(con, qstr)



qstr <- "SHOW COLUMNS FROM ozone_data"
dbGetQuery(con, qstr)


qstr <- "DESCRIBE ozone_data"
dbGetQuery(con, qstr)


colnames(dfx)

colnames(dfx) <- c("longitude", "latitude", "O3")

################# upload all at once

xxnow <- Sys.time()
dbWriteTable(con, "ozone_data", dfx)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )
########## ERROR !!




xxnow <- Sys.time()
dbWriteTable(con, "ozone_data", dfx, append=TRUE, row.names=FALSE, overwrite=FALSE)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )



dbListTables(con)

dbGetInfo(con)


qstr <- paste0("SHOW COLUMNS FROM ozone_data")
dbGetQuery(con, qstr)


########################### retrieve

########################### here in R

####### SQL is a declarative language

qstr <- paste0("SELECT * FROM ozone_data WHERE (latitude > 33.0 AND latitude < 34.0)")
xx <- dbGetQuery(con, qstr)
xx






dbDisconnect(con)


