

######################### LOAD a unique data set for others to access
######################### Each student should obtain/simulate then create a table for others to use
######################### No private information

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



################## get info

dbListTables(con)

dbGetInfo(con)




############################## THIS IS AN EXAMPLE, PLEASE FIND/SIMULATE YOUR OWN DATA

set.seed(777)

n <- 1000

x1 <- rnorm(n)

y1 <- rbinom(n, size=1, prob=cos(x1)^2)




dfx <- data.frame("x"=x1, "y"=y1)


head(dfx)



class(dfx[ , "x"])

class(dfx[ , "y"])

############ RECALL THAT VARIABLE TYPES ARE THE 'CLASS' OF OUR VARIABLES

###########



############################

xtableName <- "myCommunityTable_1" ######## do not change this name

xbool.tableExists <- dbExistsTable(con, xtableName) ; xbool.tableExists


if(xbool.tableExists) {
    qstr <- paste0("DROP TABLE ", xtableName)
    xx <- dbGetQuery(con, qstr)
}



## use double or float -- avoid 'numeric'
qstr <- paste0(
"CREATE TABLE ", xtableName, " (",
"ID INT NOT NULL  AUTO_INCREMENT, ",
"x FLOAT, ",
"y TINYINT,  ",
"PRIMARY KEY (ID))"
)

qstr



xx <- dbGetQuery(con, qstr)
xx

qstr <- "SHOW TABLES"
xx <- dbGetQuery(con, qstr)
xx




############################# populate table one row at a time -- this is slow
for(ii in 1:nrow(dfx)) {
    
    thisRow <- dfx[ii, ]
    
    qstr <- paste0(
    "INSERT INTO ",  xtableName, " (x, y) VALUES ('",
    thisRow$x, "', '",
    thisRow$y, "')"
    ) ; qstr
    
    xx <- dbGetQuery(con, qstr)
    
    cat(ii, " ")
    
}


qstr <- paste0("DESCRIBE ", xtableName)
dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM ", xtableName)
dbGetQuery(con, qstr)


########### make note of our var defs


######################################### try doing this all at once
######################################### try doing this all at once

################################ 1


xtableNameB <- "myCommunityTable_1" ######## do not change this name

xbool.tableExistsB <- dbExistsTable(con, xtableNameB) ; xbool.tableExistsB

if(xbool.tableExistsB) {
    qstr <- paste0("DROP TABLE ", xtableNameB)
    xx <- dbGetQuery(con, qstr)
}


################ write table all at once

xxnow <- Sys.time()
dbWriteTable(con, xtableNameB, dfx)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )

############### much faster


qstr <- paste0("SELECT COUNT(*) FROM ", xtableNameB)
dbGetQuery(con, qstr)


qstr <- paste0("DESCRIBE ", xtableNameB)
dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM ", xtableNameB)
dbGetQuery(con, qstr)


################## notice no primary key and using bigint + rownames


########################## try different arguments -- including field.type

################################ 1


xFT <- c("x"="FLOAT", "y"="TINYINT")

xxnow <- Sys.time()
dbWriteTable(con, xtableNameB, dfx, field.types = xFT, row.names=FALSE, overwrite=TRUE) #### overwrite=TRUE -- use with great caution
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )

qstr <- paste0("SELECT COUNT(*) FROM ", xtableNameB)
dbGetQuery(con, qstr)

qstr <- paste0("DESCRIBE ", xtableNameB)
dbGetQuery(con, qstr)

qstr <- paste0("SHOW COLUMNS FROM ", xtableNameB)
dbGetQuery(con, qstr)

####################### does not give us what we want



########################################### what follows is probably best




####################################### try appending -- works
####################################### here we pre-define our table structure
####################################### then use dbWriteTable() to APPEND -- this works


xtableNameC <- "myCommunityTable_1" ######## do not change this name

xbool.tableExistsC <- dbExistsTable(con, xtableNameC) ; xbool.tableExistsC


if(xbool.tableExistsC) {
    qstr <- paste0("DROP TABLE ", xtableNameC)
    xx <- dbGetQuery(con, qstr)
}


## use double or float -- avoid 'numeric'
qstr <- paste0(
"CREATE TABLE ", xtableNameC, " (",
"ID INT NOT NULL  AUTO_INCREMENT, ",
"x FLOAT, ",
"y TINYINT,  ",
"PRIMARY KEY (ID))"
)

qstr

xx <- dbGetQuery(con, qstr)
xx

qstr <- paste0("DESCRIBE ", xtableNameC)
dbGetQuery(con, qstr)



dbListTables(con)

dbGetInfo(con)



xxnow <- Sys.time()
dbWriteTable(con, xtableNameC, dfx, field.types = NULL, append=TRUE, ##### notice appeand is TRUE
row.names=FALSE, overwrite=FALSE)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


qstr <- paste0("SELECT COUNT(*) FROM ", xtableNameC)
dbGetQuery(con, qstr)


qstr <- paste0("DESCRIBE ", xtableNameC)
dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM ", xtableNameC)
dbGetQuery(con, qstr)

############################## PERFECT !!!


########################## info

dbListTables(con)

dbGetInfo(con)









######################### ADD TO META DATA





##########################

dbDisconnect(con)





