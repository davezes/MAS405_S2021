


options(stringsAsFactors=FALSE)






projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)


drv <- dbDriver("MySQL")





############# db3
#xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
#dzpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
#xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
#xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
#xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )



############# db3
xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )




con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)


dbListTables(con)

dbGetInfo(con)


qstr <- paste0("SELECT VERSION()")
xx <- dbGetQuery(con, qstr)
xx




########################## aggregate close by date

qstr <-
paste0(
"SELECT date, AVG(close) ",
"FROM forex_byMinute_CHFJPY ",
"GROUP BY date"
)
qstr

xxnow <- Sys.time()
xx <- dbGetQuery(con, qstr)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


df_avgForexClose <- xx

head(df_avgForexClose)






qstr <-
paste0(
"SELECT date, AVG(tpa) ",
"FROM nba_teamDate_1 ",
"GROUP BY date"
)
qstr

xxnow <- Sys.time()
xx <- dbGetQuery(con, qstr)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


df_avgNBAtpa <- xx

head(df_avgNBAtpa)





qstr <-
paste0(
"SELECT * ",
"FROM ( SELECT date, AVG(tpa) ",
"      FROM nba_teamDate_1 ",
"      GROUP BY date ) AS A ",
"JOIN ( SELECT date, AVG(close) ",
"      FROM forex_byMinute_CHFJPY ",
"      GROUP BY date ) AS B  ",
"ON A.date=B.date"
)
qstr


xxnow <- Sys.time()
xx <- dbGetQuery(con, qstr)
cat( "Seconds to execute DB inner join: ", difftime(Sys.time(), xxnow, unit="secs"), "\n" )


dfJoined <- xx

dim(dfJoined)

head(dfJoined)


####################### compare this with using the "USING" operator


qstr <-
paste0(
"SELECT * ",
"FROM ( SELECT date, AVG(tpa) ",
"      FROM nba_teamDate_1 ",
"      GROUP BY date ) AS A ",
"JOIN ( SELECT date, AVG(close) ",
"      FROM forex_byMinute_CHFJPY ",
"      GROUP BY date ) AS B  ",
"USING (date)"
)
qstr


xxnow <- Sys.time()
xx <- dbGetQuery(con, qstr)
cat( "Seconds to execute DB 'using' join: ", difftime(Sys.time(), xxnow, unit="secs"), "\n" )


dfJoined <- xx

dim(dfJoined)

head(dfJoined)



######################



x1 <- dfJoined[ , "AVG(tpa)" ]

y1 <- dfJoined[ , "AVG(close)" ]

cor(x1, y1)

plot(x1, y1, xlab="Avg Daily NBA Attempted 3-Point Shots by Teams", ylab="Avg ticker Daily Close CHFJPY", main="Daily CHFJPY ~vs~ Daily 3-Point Attempts"  )

xlm <- lm(y1 ~ x1)

summary(xlm)

abline(xlm)







############################################################
############################################################
############################################################
############################################################
############################################################

############################################################ copy both tables locally, use data.table to merge

xxbignow <- Sys.time()

qstr <-
paste0(
"SELECT * FROM forex_byMinute_CHFJPY "
)
qstr

xxnow <- Sys.time()
xx <- dbGetQuery(con, qstr)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


df_allForexClose <- xx

head(df_allForexClose)





qstr <-
paste0(
"SELECT * FROM nba_teamDate_1 "
)
qstr

xxnow <- Sys.time()
xx <- dbGetQuery(con, qstr)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


df_allNBAteamGame <- xx

head(df_allNBAteamGame)




dbDisconnect(con)


#################################
#################################


library(data.table)

dt_allForexClose <- as.data.table(df_allForexClose)

dt_allNBAteamGame <- as.data.table(df_allNBAteamGame)


###################### added DZ

xxnow <- Sys.time()
sapply( df_allForexClose, function(x) { return(length(unique(x))) } )
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


xxnow <- Sys.time()
sapply( dt_allForexClose, function(x) { return(length(unique(x))) } )
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )



xxnow <- Sys.time()
dt_allForexClose[ , lapply( .SD, function(x) { return(length(unique(x))) } ),  ]
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


######################




xxxAvgPts <- dt_allNBAteamGame[ , .(avgPts=mean(tpa)), by=date ] ######## awesome!!!

xxxAvgPts <- as.data.frame(xxxAvgPts)

head(xxxAvgPts)

rownames(xxxAvgPts) <- (xxxAvgPts[ , "date" ])

class(xxxAvgPts)



xxx_fin_avgClose <- dt_allForexClose[ , .(avgClose=mean(close)), by=date ] ######## awesome!!!

xxx_fin_avgClose <- as.data.frame(xxx_fin_avgClose)

head(xxx_fin_avgClose)

rownames(xxx_fin_avgClose) <- xxx_fin_avgClose[ , "date" ]







xcommon_dates <- sort( intersect( rownames(xxxAvgPts), rownames(xxx_fin_avgClose) ) )

x1 <- xxxAvgPts[ xcommon_dates, "avgPts" ]



y1 <- xxx_fin_avgClose[ xcommon_dates, "avgClose" ]

cor(x1, y1)

plot(x1, y1, xlab="Avg Daily NBA Attempted 3-Point Shots by Teams", ylab="Avg ticker Daily Close CHFJPY", main="Daily CHFJPY ~vs~ Daily 3-Point Attempts"  )

xlm <- lm(y1 ~ x1)

summary(xlm)

abline(xlm)









################################################ stnd normal ogive x and y
################################################ stnd normal ogive x and y
################################################ stnd normal ogive x and y

x2 <- qnorm( (rank(x1) - 0.5) / length(x1) )

y2 <- qnorm( (rank(y1) - 0.5) / length(y1) )

cor(x2, y2)

plot(x2, y2, xlab="Avg Daily NBA Attempted 3-Point Shots by Teams (Gauss Ogived)", ylab="Avg ticker Daily Close CHFJPY (Gauss Ogived)", main="Daily CHFJPY ~vs~ Daily 3-Point Attempts"  )

xlm <- lm(y2 ~ x2)

summary(xlm)

abline(xlm)






png(file.path("~", "Desktop", "mas405funnyPlot_01.png"), width=1200, height=860)
par(bg="#000000")
plot(x2, y2 , col="#FFFFFF", cex=2.0)
dev.off()




##########################
















