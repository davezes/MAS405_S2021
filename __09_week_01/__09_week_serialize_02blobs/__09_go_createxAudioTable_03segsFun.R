

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


source("__f_funs.R" )

library(RMySQL)

library(rjson)

#library(png)

library(audio)


drv <- dbDriver("MySQL")

#############
xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xdbpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )





########################################



#########################
#########################




###tools::file_path_sans_ext(xfl)


######################### example of "serializing" to raw then segmenting


xfl <- list.files( file.path( "..", "__09_week_audioFiles_01" ), pattern="*.wav$" )


ii <- 1

xthisFN <- xfl[ii]

xwav <- load.wave( file.path("..", "__09_week_audioFiles_01", xfl[ii]))


xdim <- dim(xwav) ; xdim

class(xwav)


aobj <- play(x=xwav)

pause(x=aobj)

rewind(x=aobj)
resume(x=aobj)


########################### use function to write

yynow <- Sys.time()
for(ii in 1:length(xfl)) {
    
    xthisFN <- xfl[ii]
    
    xwav <- load.wave( file.path("..", "__09_week_audioFiles_01", xfl[ii]))
    
    
    f_dbwrite_raw(
    xobj=xwav,
    xtableName="MAS405audio_serialSegs",
    xfile=xthisFN,
    xdrv=drv,
    xdbuser=xdbuser,
    xdbpw=xdbpw,
    xdbname=xdbname,
    xdbhost=xdbhost,
    xdbport=xdbport,
    xoverWrite=TRUE,
    xsegSize=10^6,
    xverbosity=2,
    xcomp="xz"
    )
    
    cat("\n\n\n\n", ii, "\n\n\n\n\n")
    
}
cat(difftime(yynow, Sys.time(), units="mins"))

########################### use function to write

ii <- 2

xthisFN <- xfl[ii] ; xthisFN

zobj <-
f_dbread_raw(
xtableName="MAS405audio_serialSegs",
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


zwav <- zobj

############################# convert to string -- use compression
############################# convert to string -- use compression

class(zwav)

cobj <- play(x=zwav)

pause(x=cobj)

rewind(x=cobj)

resume(x=cobj)


##### remember what I said earlier about full paths ?
### save.wave(zwav, file.path("~", "Desktop", "audio_file_out.wav"))

### save.wave(zwav, file.path("", "Users", "davezes", "Desktop", "audio_file_out.wav"))

####################################

xthis_file <- "thisTrackOut.wav"
xthis_file <- "Wheelfull4B.wav"
xthis_file <- "MassAttackIamHome.wav"



##########################

con <- dbConnect(drv, user=xdbuser, password=xdbpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)


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





dbDisconnect(con)


#################






