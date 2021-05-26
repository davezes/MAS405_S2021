

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



xfl <- list.files( file.path( "..", "__09_week_audioFiles_01" ), pattern="*.wav$" )


tools::file_path_sans_ext(xfl)


dfx_audio <-
data.frame(
"name"=tools::file_path_sans_ext(xfl),
"file"=xfl
)

dfx_audio

######################### example of "serializing" png as evaluated vector

ii <- 1

xwav <- load.wave( file.path("..", "__09_week_audioFiles_01", xfl[ii]))

xdim <- dim(xwav) ; xdim

class(xwav)


aobj <- play(x=xwav)

pause(x=aobj)
rewind(x=aobj)
resume(x=aobj)



############################# convert to string
############################# convert to string


xxx <- serialize(xwav, con=NULL)

class(xxx)

#yyy <- as.character(xxx)
#zzz <- paste(yyy, collapse="")
#nchar(zzz)
#substring(zzz, 1, 100)

zzz <- paste(xxx, collapse="")
nchar(zzz)
substring(zzz, 1, 100)

format(object.size(zzz), "MB")


uuu <- substring(zzz, seq(1, nchar(zzz), by=2), seq(2, nchar(zzz), by=2))

vvv <- as.raw(as.hexmode( uuu ))

object.size(vvv)

ywav <- unserialize(vvv)

class(ywav)

bobj <- play(x=ywav)

pause(x=bobj)
rewind(x=bobj)
resume(x=bobj)



############################# convert to string -- use compression
############################# convert to string -- use compression


xxx <- serialize(xwav, con=NULL)

class(xxx)

format(object.size(xxx), "MB")

yyy <- memCompress(from=xxx, type="gzip")

## www <- memDecompress(from=yyy, type="gzip")
## yyy <- memCompress(from=xxx, asChar=TRUE)

format(object.size(yyy), "MB")


object.size(yyy) / object.size(xxx)


zzz <- paste(yyy, collapse="")
nchar(zzz)
substring(zzz, 1, 100)



########## undo


uuu <- substring(zzz, seq(1, nchar(zzz), by=2), seq(2, nchar(zzz), by=2))

vvv <- as.raw(as.hexmode( uuu ))

format(object.size(vvv), "MB")

www <- memDecompress(from=vvv, type="gzip")

format(object.size(www), "MB")

zwav <- unserialize(www)

class(zwav)

cobj <- play(x=zwav)

pause(x=cobj)
rewind(x=cobj)
resume(x=cobj)




############################# now run as loop
#############################
#############################

dfx_audio_use <- dfx_audio

dfx_audio_use[ , "audio_data" ] <- ""


for(ii in 1:nrow(dfx_audio_use)) {
    
    xthis_audFN <- dfx_audio_use[ ii, "file" ] ; xthis_audFN

    xwav <- load.wave( file.path("..", "__09_week_audioFiles_01", xthis_audFN) )

    ################# convert to eval string (vector)
    xxx <- serialize(xwav, con=NULL)
    
    yyy <- memCompress(from=xxx, type="xz")
    
    ### yyy <- xxx
    
    zzz <- paste(yyy, collapse="")
    
    xwav_str <- zzz
      
    dfx_audio_use[ ii, "audio_data" ] <- xwav_str
    
    cat(ii, xthis_audFN, "\n")

}


colnames(dfx_audio_use)

format(object.size(dfx_audio_use), units="MB")

###########################################





#############
xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xpw     <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
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



xtableNameC <- "MAS405audio_serial" ######## do not change this name

xbool.tableExistsC <- dbExistsTable(con, xtableNameC) ; xbool.tableExistsC

if(xbool.tableExistsC) {
    qstr <- paste0("DROP TABLE ", xtableNameC)
    xx <- dbGetQuery(con, qstr)
}


## use double or float -- avoid 'numeric'
qstr <- paste0(
"CREATE TABLE ", xtableNameC, " (",
"ID INT NOT NULL  AUTO_INCREMENT, ",
"name TEXT, ",
"file TEXT,  ",
"audio_data LONGTEXT,  ",
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
dbWriteTable(con, xtableNameC, dfx_audio_use, field.types = NULL, append=TRUE, ##### notice appeand is TRUE
row.names=FALSE, overwrite=FALSE)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )


qstr <- paste0("SELECT COUNT(*) FROM ", xtableNameC)
dbGetQuery(con, qstr)

qstr <- paste0("DESCRIBE ", xtableNameC)
dbGetQuery(con, qstr)

qstr <- paste0("SHOW COLUMNS FROM ", xtableNameC)
dbGetQuery(con, qstr)



####################### beautiful

qstr <-
"
SELECT
    table_name,
    round(((data_length + index_length) / 1024 / 1024), 3) 'Size in MB'
FROM
    information_schema.TABLES
"
dbGetQuery(con, qstr)







################################################ ADD TO dataDictionary


xthis_taskName <- "MAS405audio_serial" #####

xabout <- "Example of MySQL audio storage using raw-hexdecimal string -- no seperator -- and in-memory compression"

xls_vars <-
list(
"name"="name of audio file",
"file"="original file name",
"audio_data"="string representation of compressed hexdec audio wav file of class audioSample from Rlib audio. Use substring(), e.g., substring(x, seq(1, nchar(x), by=2), seq(2, nchar(x), by=2)), to split into vector of 2-char elements -- then as.raw(as.hexmode(x)) -- then memDecompress with type='xz'. Result can be played or saved.  See Rlib audio."
)

xls_info <-
list(
"about"=xabout,
"codebook"=xls_vars
)

xinfoJSON <- toJSON(xls_info)

xinfoEscaped <- dbEscapeStrings(con, xinfoJSON)
xinfoEscaped


qstr <- paste0(
"INSERT INTO dataDictionary (tableName, about, variableDefs) VALUES (",
"'", xthis_taskName, "', ",
"'", xabout, "', ",
"'", xinfoEscaped, "'",
")"
) ; qstr

xx <- dbGetQuery(con, qstr)



########################### update

qstr <- paste0(
"UPDATE ", "dataDictionary", " SET ",
"about='", xabout, "',  ",
"variableDefs='", xinfoEscaped, "'  ",
"WHERE tableName='", xthis_taskName, "'"
) ; qstr

xx <- dbGetQuery(con, qstr)






########################################## read back

xtableNameC <- "MAS405audio_serial" ######## do not change this name

qstr <- paste0(
"SELECT * FROM ", xtableNameC
)

qstr

xxnow <- Sys.time()
df_read_back <- dbGetQuery(con, qstr)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )

colnames(df_read_back)

rownames(df_read_back) <- df_read_back[ , "name" ]

####################################

xthis_file <- "thisTrackOut"
xthis_file <- "Wheelfull4B"
xthis_file <- "MassAttackIamHome"

xaudio_str <- df_read_back[ xthis_file, "audio_data" ]

uuu <- substring(xaudio_str, seq(1, nchar(xaudio_str), by=2), seq(2, nchar(xaudio_str), by=2))

vvv <- as.raw(as.hexmode( uuu ))

www <- memDecompress(from=vvv, type="xz")

format(object.size(www), "MB")

zwav <- unserialize(www)

class(zwav)

cobj <- play(x=zwav)

pause(x=cobj)

rewind(x=cobj)

resume(x=cobj)


##########################





dbDisconnect(con)


#################

