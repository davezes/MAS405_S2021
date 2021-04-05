



projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)


drv <- dbDriver("MySQL")






########################################


############# DAVE's DB
xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )





############### establish connection to my RDS MySQL DB instance (read only):

con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)


##################### what tables do I have?
dbListTables(con)



##################### get some info about my DB
dbGetInfo(con)


qstr <- paste0("SELECT VERSION()")
xx <- dbGetQuery(con, qstr)
xx



############## let's find out about the table 'nba_playersDate_1'
############## from my table 'dataDictionary' -- Don't worry about Warning

qstr <- paste0("SELECT * FROM dataDictionary")
xx <- dbGetQuery(con, qstr)
xx




##### a)

qstr <- paste0("SELECT * FROM nba_playersDate_1 WHERE pts > 59 AND min < 30")
xx <- dbGetQuery(con, qstr)
xx


##### b)

qstr <- paste0("SELECT * FROM nba_playersDate_1 WHERE pts > 80")
xx <- dbGetQuery(con, qstr)
xx




##### c)

qstr <- paste0("SELECT * FROM nhl_playersDate_1 WHERE (goals > 4 AND assists > 0)")
xx <- dbGetQuery(con, qstr)
xx



##### d)

qstr <- paste0("SELECT * FROM nhl_goaliesDate_1 WHERE (goals > 0 AND saves > 30)")
xx <- dbGetQuery(con, qstr)
xx




dbDisconnect(con)


