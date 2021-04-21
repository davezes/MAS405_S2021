

#########################
#########################
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






########################################



#############
#xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
#dzpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
#xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
#xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
#xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )


xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )





con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



################## get info

dbListTables(con)

dbGetInfo(con)




qstr <- "SHOW TABLES"
xx <- dbGetQuery(con, qstr)
xx

xdf_myTables <- xx



################ what's in your existing metadata file?

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

xdf_DD <- xx

rownames(xdf_DD) <- xdf_DD[ , "tableName" ]


######### take a look using R list


fromJSON(xdf_DD[ "nhl_gameDate_1", "variableDefs" ])

fromJSON(xdf_DD[ "nhl_teamDate_1", "variableDefs" ])

fromJSON(xdf_DD[ "nhl_playersDate_1", "variableDefs" ])

fromJSON(xdf_DD[ "nhl_goaliesDate_1", "variableDefs" ])




######################### VIEW PLAYER DATA

qstr <- paste0(
"SELECT * FROM nhl_playersDate_1 LIMIT 20"
)
xx <- dbGetQuery(con, qstr)
xx




######################### VIEW TEAM DATA

qstr <- paste0(
"SELECT * FROM nhl_teamDate_1 LIMIT 20"
)
xx <- dbGetQuery(con, qstr)
xx



######################### VIEW GAME DATA

qstr <- paste0(
"SELECT * FROM nhl_gameDate_1 LIMIT 20"
)
xx <- dbGetQuery(con, qstr)
xx


######################### VIEW GOALIE DATA

qstr <- paste0(
"SELECT * FROM nhl_goaliesDate_1 LIMIT 20"
)
xx <- dbGetQuery(con, qstr)
xx



######## What are some of the shortcomings with this data structure?





##################################

####### Assignment

#### BTW, the HAVING keyword filters on aggregating functions, whereas WHERE filters on records

########## non-uniqueness of player-date by name

#### note alias for value returned by count function

qstr <- paste0(
"SELECT *, COUNT(*) n FROM nhl_playersDate_1 GROUP BY CONCAT(date, team, firstName, lastName) HAVING n > 1  LIMIT 100"
)
xx <- dbGetQuery(con, qstr)
xx



########## non-uniqueness of player-date by id

qstr <- paste0(
"SELECT *, COUNT(*) n FROM nhl_playersDate_1 GROUP BY CONCAT(date, team, id) HAVING n > 1  LIMIT 100"
)
xx <- dbGetQuery(con, qstr)
xx


########## non-uniqueness of player-date by lastName

qstr <- paste0(
"SELECT *, COUNT(*) n FROM nhl_playersDate_1 GROUP BY CONCAT(date, team, lastName) HAVING n > 1  LIMIT 100"
)
xx <- dbGetQuery(con, qstr)
xx

dim(xx)



################# group by summarizes -- e.g. count -- all unique groupings



qstr <-
"
SELECT a.*
 FROM nhl_playersDate_1 a
 JOIN
 (
      SELECT *, COUNT(*)
      FROM nhl_playersDate_1
      GROUP BY date, team, lastName
      HAVING count(*) > 1
 ) b
 ON a.date = b.date
 AND a.team = b.team
 AND a.lastName = b.lastName
 ORDER BY a.date
"

xx <- dbGetQuery(con, qstr)
xx

dim(xx)



##########################

######## nesting !!!

######### simple example of Nesting

qstr <- paste0(
"SELECT a.* FROM (SELECT * FROM nhl_playersDate_1 WHERE lastName='Sedin') a  WHERE date > 20180000"
)
xx <- dbGetQuery(con, qstr)

xx



dbDisconnect(con)











