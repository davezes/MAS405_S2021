

######################### The directory that encloses this file
######################### is your working directory
######################### __09_week_01pdf must be a sibling

######################### this is more memory efficient

options(stringsAsFactors=FALSE, width=200)

source("__f_funs.R" )

projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)

library(rjson)

library(png)


drv <- dbDriver("MySQL")






########################################



#############
xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xdbpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )





############




con <- dbConnect(drv, user=xdbuser, password=xdbpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



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



#########################
#########################


dfx_pics <- read.table( file.path("..", "__09_week_01pdf", "__log.tsv"), header=TRUE, sep="\t" )
dfx_pics


xfl <- list.files( file.path( "..", "__09_week_01pdf" ), pattern="[0-9]\\.png$" )



#############################

xtableNameC <- "MAS405images_serial3" ######## do not change this name

xbool.tableExistsC <- dbExistsTable(con, xtableNameC) ; xbool.tableExistsC

if(xbool.tableExistsC) {
    qstr <- paste0("DROP TABLE ", xtableNameC)
    xx <- dbGetQuery(con, qstr)
}


## use double or float -- avoid 'numeric'
qstr <- paste0(
"CREATE TABLE ", xtableNameC, " (",
"ID INT NOT NULL  AUTO_INCREMENT, ",
"file TEXT,  ",
"segment INT(14),  ",
"raw_data MEDIUMTEXT,  ",
"PRIMARY KEY (ID))"
)

qstr

xx <- dbGetQuery(con, qstr)
xx

qstr <- paste0("DESCRIBE ", xtableNameC)
dbGetQuery(con, qstr)



dbListTables(con)

dbGetInfo(con)




######################################

ii <- 1

for(ii in 1:length(xfl)) {
    
    xthisFN <- xfl[ii]
    xthis_file <- readPNG( file.path( "..", "__09_week_01pdf", xthisFN ), native=TRUE )
    
    f_dbwrite_raw(
    xobj=xthis_file,
    xtableName="MAS405images_serial3",
    xfile=xthisFN,
    xdrv=drv,
    xdbuser=xdbuser,
    xdbpw=xdbpw,
    xdbname=xdbname,
    xdbhost=xdbhost,
    xdbport=xdbport,
    xoverWrite=TRUE,
    xsegSize=10^4,
    xverbosity=2,
    xcomp="xz"
    )
    
}




par(mfrow=c(3, 5))

ii <- 1

for(ii in 1:length(xfl)) {
    
    xthisFN <- xfl[ii]
    
    zobj <-
    f_dbread_raw(
    xtableName="MAS405images_serial3",
    xfile=xthisFN,
    xdrv=drv,
    xdbuser=xdbuser,
    xdbpw=xdbpw,
    xdbname=xdbname,
    xdbhost=xdbhost,
    xdbport=xdbport,
    xverbosity=2,
    xcomp="xz"
    )
    
    plot(1:2, 1:2, type="n", main=xthisFN)
    rasterImage(zobj, 1, 1, 2, 2)
    
}





dbDisconnect(con)


#################

