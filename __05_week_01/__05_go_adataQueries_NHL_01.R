


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


qstr <- paste0("SHOW COLUMNS FROM ", "nhl_teamDate_1")
dbGetQuery(con, qstr)





####################################



qstr <- "SELECT a.* FROM (SELECT * FROM nhl_playersDate_1 WHERE goals > 3) a WHERE a.date < 20080000"
xx <- dbGetQuery(con, qstr)
xx



########### player dates where player scored more than 3 goals

qstr <- "SELECT * FROM nhl_playersDate_1 WHERE goals > 3"
xx <- dbGetQuery(con, qstr)
xx

dim(xx)



###################################### Who gets the decision ?????

qstr <-
"
 SELECT a.* FROM nhl_goaliesDate_1 a
 JOIN
  (
    SELECT *, COUNT(TABLE_ID) n FROM nhl_goaliesDate_1
    GROUP BY date, team
    HAVING n > 1
  ) b
 ON a.date = b.date
 AND a.team = b.team
 ORDER BY a.date
"

xx <- dbGetQuery(con, qstr)
xx

dim(xx)



########### all the games played on days in which a players scored more than 3 goals

########## nesting, again

######### by date

qstr <-
paste0(
"SELECT * FROM nhl_gameDate_1  ",
"WHERE nhl_gameDate_1.date IN  ",
"(",
"SELECT date FROM nhl_playersDate_1  WHERE  ",
"nhl_playersDate_1.goals > 3",
")"
)
qstr

xx <- dbGetQuery(con, qstr)
xx





########### all the games in which a players scored more than 3 goals for the home team

qstr <-
paste0(
"SELECT * FROM nhl_gameDate_1  ",
"WHERE CONCAT(nhl_gameDate_1.date, nhl_gameDate_1.HT) IN ",
"(",
"SELECT CONCAT(date, team) FROM nhl_playersDate_1  ",
"WHERE  nhl_playersDate_1.goals > 3",
")"
)
qstr

xx <- dbGetQuery(con, qstr)
xx




########### all the games in which a players scored more than 3 goals for the visiting team

qstr <-
paste0(
"SELECT * FROM nhl_gameDate_1  ",
"WHERE CONCAT(nhl_gameDate_1.date, nhl_gameDate_1.VT) IN ",
"(", ###### VT
"SELECT CONCAT(date, team) FROM nhl_playersDate_1  ",
"WHERE  nhl_playersDate_1.goals > 3",
")"
)
qstr

xx <- dbGetQuery(con, qstr)
xx



############# takes a long time
############# server RAM -- bootstrapping large objects into memory
############# swap ??

############### do not run
if(FALSE) {
    
    qstr <-
    "
    SELECT * FROM nhl_gameDate_1
    WHERE
    CONCAT(nhl_gameDate_1.date, nhl_gameDate_1.VT) IN
    (
    SELECT CONCAT(date, team) FROM nhl_playersDate_1  WHERE  nhl_playersDate_1.goals > 3
    )
    OR
    CONCAT(nhl_gameDate_1.date, nhl_gameDate_1.HT) IN
    (
    SELECT CONCAT(date, team) FROM nhl_playersDate_1  WHERE  nhl_playersDate_1.goals > 3
    )
    "
    
    
    cat(qstr)
    
    qstr
    
    xx <- dbGetQuery(con, qstr)
    xx
    
}






qstr <-
"
SELECT * FROM nhl_gameDate_1
    JOIN nhl_playersDate_1
       ON
          (nhl_gameDate_1.date=nhl_playersDate_1.date AND nhl_gameDate_1.VT=nhl_playersDate_1.team)
           OR
          (nhl_gameDate_1.date=nhl_playersDate_1.date AND nhl_gameDate_1.HT=nhl_playersDate_1.team)
     WHERE nhl_playersDate_1.goals > 3
"

xx <- dbGetQuery(con, qstr)
xx

df_out <- xx

class(df_out)

colnames(df_out) ##### non-unique column names!


colnames(df_out) <- make.names(names=colnames(df_out), unique = TRUE)

df_out



xofficials <- gsub("^\\s*|\\s*$", "", (unlist(strsplit(xx[ , "officials"], ";"))))

table( xofficials )




####################################### very important
####################################### unknown or unexpected character can break LaTeX parsers
############## characters

df_out[ , "VT" ]

gsub("\xe9", "e", df_out[ , "VT" ])




dbDisconnect(con)





