

######################### Update your data dictionary to describe your recent community data set
######################### Edit this file as needed
#########################

projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)


drv <- dbDriver("MySQL")






########################################



############# db1
xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xpw     <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )



con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



################## get info

dbListTables(con)

dbGetInfo(con)




qstr <- "SHOW TABLES"
xx <- dbGetQuery(con, qstr)
xx

xdf_myTables <- xx



################ what's in your metadata file?

qstr <- paste0(
"SELECT * FROM metadata"
)
xx <- dbGetQuery(con, qstr)
xx


qstr <- paste0(
"SELECT * FROM dataDictionary"
)
xx <- dbGetQuery(con, qstr)
xx




#########################

qstr <- paste0(
"SELECT tableName, variableDefs->'$.about', LENGTH(JSON_EXTRACT(variableDefs, '$.about')) ",
"FROM dataDictionary  ",
"WHERE LENGTH(JSON_EXTRACT(variableDefs, '$.about')) > 50  ",
"ORDER BY variableDefs->'$.about' "
)
qstr

xx <- dbGetQuery(con, qstr)
xx






#qstr <- paste0(
#"SELECT tableName, JSON_TYPE(variableDefs)  ", ###### notice the dots for the json hierarchy
#"FROM dataDictionary  "
#)
#qstr

#xx <- dbGetQuery(con, qstr)
#xx








##########################

dbDisconnect(con)





