



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




#xpathTables <- file.path("___data")


#dfx <- read.table( file.path(xpathTables, "ozone.tsv") , sep="\t", header=TRUE )
#head(dfx)

#dfx <- data.frame("ID"=I(1:nrow(dfx)), dfx)


### ozone_data is called "pothole" name convention

xtableName <- "ozone_data_test"

xbool.tableExists <- dbExistsTable(con, xtableName) ; xbool.tableExists



############################## IMPORTANT NOTE -- THE FOLLOWING CODE CHUNK DESTROYS THE TABLE METADATA
############################## IN REAL LIFE, YOU'LL SURELY WANT STRICT LIMITATIONS OVER THIS OPERATION

if(xbool.tableExists) {
    qstr <- paste0("DROP TABLE ", xtableName)
    xx <- dbGetQuery(con, qstr)
}



#qstr <-
#paste0(
#"
#CREATE TABLE "
#,  xtableName  ,
#"
#(ID INT NOT NULL AUTO_INCREMENT, x DOUBLE, y DOUBLE, o3 DOUBLE, PRIMARY KEY (ID))
#"
#)
#xx <- dbGetQuery(con, qstr)




qstr <-
paste0(
"
CREATE TABLE "
,  xtableName  ,
"
(x DOUBLE, y DOUBLE, o3 DOUBLE)
"
)
xx <- dbGetQuery(con, qstr)




qstr <- paste0("SHOW COLUMNS FROM ", xtableName)
dbGetQuery(con, qstr)


qstr <- paste0("DESCRIBE ", xtableName)
dbGetQuery(con, qstr)






qstr <-
paste0(
"LOAD DATA LOCAL INFILE '___data/ozone.tsv' ",
" INTO TABLE ozone_data_test ",
" FIELDS TERMINATED BY '\t' ",
" LINES TERMINATED BY '\n' ",
" IGNORE 1 ROWS"
)

dbGetQuery(con, qstr)




dbGetQuery(con, "SELECT * FROM ozone_data_test")



















dbDisconnect(con)


