

######################### The directory that encloses this file
######################### is your working directory
######################### __09_audioFiles_01 must be a sibling

######################### efficient

options(stringsAsFactors=FALSE, width=200)



projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)

library(rjson)

#library(png)

library(audio)


drv <- dbDriver("MySQL")






########################################



#########################
#########################




###tools::file_path_sans_ext(xfl)


######################### example of "serializing" to raw then segmenting


xfl <- list.files( file.path( "..", "__09_week_audioFiles_01" ), pattern="*.wav$" )


ii <- 1

xthisFN <- xfl[ii] ; xthisFN

xwav <- load.wave( file.path("..", "__09_week_audioFiles_01", xfl[ii]))

xdim <- dim(xwav) ; xdim

class(xwav)


aobj <- play(x=xwav)

pause(x=aobj)


rewind(x=aobj)
resume(x=aobj)




############################# convert to string -- use compression
############################# convert to string -- use compression


xxx <- serialize(xwav, con=NULL)

class(xxx)

object.size(xxx)

length(xxx) / 10^6

yyy <- memCompress(from=xxx, type="xz")

length(yyy) / 10^6

object.size(yyy)


##################################### segment

xbrksize <- 10^6


xbrks <- sort(unique(c(seq(1, length(yyy), by=xbrksize), length(yyy)+1))) ; xbrks

Ns <- length(xbrks) - 1

xout <- character( Ns ) ; xout

for(jj in 2:length(xbrks)) {
    
    this_seg <- paste(yyy[ (xbrks[jj-1]):(xbrks[jj]-1) ], collapse="")
    xout[ jj-1 ] <- this_seg
    cat(jj, "\n")
}


xdf_audioOne <-
data.frame(
"file"=rep(xfl[ii], Ns),
"segment"=(1:Ns),
"raw_data"=xout
)



##################################

#############
xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xdbpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )



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



##################################



xtableNameC <- "MAS405audio_serialSegs" ######## do not change this name

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



xxnow <- Sys.time()
dbWriteTable(con, xtableNameC, xdf_audioOne, field.types = NULL, append=TRUE, ##### notice appeand is TRUE
row.names=FALSE, overwrite=FALSE)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


qstr <- paste0("SELECT COUNT(*) FROM ", xtableNameC)
dbGetQuery(con, qstr)

qstr <- paste0("DESCRIBE ", xtableNameC)
dbGetQuery(con, qstr)

qstr <- paste0("SHOW COLUMNS FROM ", xtableNameC)
dbGetQuery(con, qstr)




qstr <-
"
SELECT
    table_name AS 'Table_Name',
    round(((data_length + index_length) / 1024 / 1024), 3) 'Size_in_MB'
FROM
    information_schema.TABLES
"
dbGetQuery(con, qstr)

####################### beautiful



################################################## READ



xtableNameC <- "MAS405audio_serialSegs" ######## do not change this name

qstr <- paste0(
"SELECT * FROM ", xtableNameC,
"  WHERE file='", xthisFN, "'"
)

qstr

xxnow <- Sys.time()
df_read_back <- dbGetQuery(con, qstr)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )

colnames(df_read_back)

dim(df_read_back)


###################################

df_read_back[ , "segment" ]

xperm <- order(df_read_back[ , "segment" ])

xla <- lapply( df_read_back[ xperm, "raw_data"], function(x) { return(substring(x, seq(1, nchar(x), by=2), seq(2, nchar(x), by=2))) } )

length(xla)

uuu <- unlist(xla)


vvv <- as.raw(as.hexmode( uuu ))

www <- memDecompress(from=vvv, type="xz")

object.size(www)

zwav <- unserialize(www)

class(zwav)

cobj <- play(x=zwav)

pause(x=cobj)

rewind(x=cobj)

resume(x=cobj)


####################################

xthis_file <- "thisTrackOut.wav"
xthis_file <- "Wheelfull4B.wav"
xthis_file <- "MassAttackIamHome.wav"



##########################





dbDisconnect(con)


#################






