

######################### show some of DZ tables

projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)

library(rjson)


drv <- dbDriver("MySQL")






########################################


xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )





con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



################## get info

dbListTables(con)

dbGetInfo(con)


qstr <- paste0("DESCRIBE nba_playersDate_1")
dbGetQuery(con, qstr)




qstr <- paste0("DESC nba_teamDate_1")
dbGetQuery(con, qstr)


qstr <- paste0("DESC nba_gameDate_1")
dbGetQuery(con, qstr)



###################### show columns

##### longtext 4 billion

qstr <- paste0("SHOW COLUMNS FROM nba_playersDate_1")
dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM nba_teamDate_1")
dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM nba_gameDate_1")
dbGetQuery(con, qstr)



###################### data dictionary

qstr <- paste0("SELECT * FROM dataDictionary")
xx <- dbGetQuery(con, qstr)
xx


######## view as list

aDD <- fromJSON(xx[ 1, "variableDefs" ])
aDD

as.data.frame(aDD[[ "codebook" ]])


as.data.frame(fromJSON(xx[ 2, "variableDefs" ])[[ "codebook" ]])

as.data.frame(fromJSON(xx[ 3, "variableDefs" ])[[ "codebook" ]])


########################## what is the unit level of observation?
########################## what is the unit level of observation?
########################## what is the unit level of observation?
########################## what is the unit level of observation?


qstr <- paste0("SELECT * FROM nba_playersDate_1  LIMIT 20")
xx <- dbGetQuery(con, qstr)
xx


qstr <- paste0("SELECT * FROM nba_gameDate_1  LIMIT 20")
xx <- dbGetQuery(con, qstr)
xx




qstr <- paste0("SELECT * FROM nba_teamDate_1  LIMIT 20")
xx <- dbGetQuery(con, qstr)
xx


qstr <- "SELECT MIN(date), MAX(date) FROM nba_playersDate_1"
xx <- dbGetQuery(con, qstr)
xx


qstr <- "SELECT COUNT(*) FROM nba_playersDate_1"
xx <- dbGetQuery(con, qstr)
xx

qstr <- "SELECT COUNT(*) FROM nba_gameDate_1"
xx <- dbGetQuery(con, qstr)
xx

qstr <- "SELECT COUNT(*) FROM nba_teamDate_1"
xx <- dbGetQuery(con, qstr)
xx


##########################

#SELECT c1, c2
#FROM t1 A
#INNER JOIN t2 B ON condition

#qstr <-
#"
# SELECT A.date, B.date
# FROM nba_gameDate_1 A
# INNER JOIN nba_teamDate_1 B
# ON A.VT = B.team
#"
#xx <- dbGetQuery(con, qstr)

#dim(xx)
#tail(xx)



qstr <-
"
 SELECT *
 FROM nba_gameDate_1 A
 WHERE A.date = '20190401'
"
xx <- dbGetQuery(con, qstr)
xx

dim(xx)
tail(xx)




qstr <-
"
 SELECT A.date, B.date, A.VT, B.team
 FROM nba_gameDate_1 A
 INNER JOIN nba_teamDate_1 B
 ON (A.VT = B.team) AND (A.date = '20190401')
"
xx <- dbGetQuery(con, qstr)
xx

dim(xx)
tail(xx)


qstr <-
"
 SELECT A.date, VT, HT
 FROM nba_gameDate_1 A
 INNER JOIN nba_teamDate_1 B
 ON (A.VT = B.team) AND (A.date = '20190401')
"
xx <- dbGetQuery(con, qstr)
xx

dim(xx)
tail(xx)




##  xx


dbDisconnect(con)





