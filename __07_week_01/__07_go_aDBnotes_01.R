


#########################

options(stringsAsFactors=FALSE, width=200)

projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)

library(rjson)


drv <- dbDriver("MySQL")



############# db1
xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xpw    <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
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


qstr <- paste0("SHOW COLUMNS FROM ", "nba_teamDate_1")
dbGetQuery(con, qstr)


qstr <- "SELECT * FROM metadata"
xx <- dbGetQuery(con, qstr)
xx

fromJSON(xx[1, "entry"])



####################################

############################################ IMPORTANT: EACH OF THESE TABLES HAS A DIFFERENT 'UNIT-LEVEL OF OBSERVATION'
############################################ IMPORTANT: EACH OF THESE TABLES HAS A DIFFERENT 'UNIT-LEVEL OF OBSERVATION'
############################################ IMPORTANT: EACH OF THESE TABLES HAS A DIFFERENT 'UNIT-LEVEL OF OBSERVATION'

#nba_playersDate_1

#nba_teamDate_2_lean

#nba_gameDate_2


qstr <- "SELECT * FROM nba_gameDate_1 LIMIT 20"
xx <- dbGetQuery(con, qstr)
xx


qstr <- "SELECT * FROM nba_teamDate_1 LIMIT 20"
xx <- dbGetQuery(con, qstr)
xx



########### player dates where player scored more than 60 points

qstr <- "SELECT * FROM nba_playersDate_1 WHERE pts > 60"
xx <- dbGetQuery(con, qstr)
xx




############################################ IMPORTANT: Create DB notes table
############################################ IMPORTANT: Create DB notes table
############################################ IMPORTANT: Create DB notes table





xtableNameC <- "notes" ######## do not change this name

xbool.tableExistsC <- dbExistsTable(con, xtableNameC) ; xbool.tableExistsC


if(xbool.tableExistsC) {
    qstr <- paste0("DROP TABLE ", xtableNameC)
    xx <- dbGetQuery(con, qstr)
}


## use double or float -- avoid 'numeric'
qstr <- paste0(
"CREATE TABLE ", xtableNameC, " (",
"ID INT NOT NULL  AUTO_INCREMENT, ",
"entryDateTime TIMESTAMP, ",
"notes TEXT,  ", ####### here we'll use text instead of JSON -- why?  We have no a-priori notion of schema
"PRIMARY KEY (ID))"
)

xx <- dbGetQuery(con, qstr)
xx

qstr <- "SHOW TABLES"
xx <- dbGetQuery(con, qstr)
xx



xnotes <-
paste0(
"The three tables, nba_playersDate_1, nba_teamDate_1, nba_gameDate_1, constitute a relationship. ",
"date-name defines a unique record in nba_playersDate_1; ",
"date-team defines a unique record in nba_teamDate_1; ",
"date-VT OR date-HT define a unique record in nba_gameDate_1."
)


#### xnotes <- "Hello"

xtimestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S") ; xtimestamp


dbEscapeStrings(con, xnotes)

dbEscapeStrings(con, xtimestamp)

########### all the games played on days in which a players scored more than 60 points

qstr <-
paste0(
"INSERT INTO ", xtableNameC , "  (entryDateTime, notes) VALUES (",
"'", xtimestamp, "', ",
"'", xnotes, "'",
")"
) ; qstr

xx <- dbGetQuery(con, qstr)
xx





########### all the games in which a players scored more than 60 points for the home team

qstr <-
paste0(
"SELECT * FROM  ", xtableNameC
)

xx <- dbGetQuery(con, qstr)
xx


