

######################### The directory that encloses this file
######################### is your working directory
######################### __09_week_01pdf must be a sibling

######################### this is more memory efficient

options(stringsAsFactors=FALSE, width=200)



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



#########################
#########################


dfx_pics <- read.table( file.path("..", "__09_week_02pdf", "__log.tsv"), header=TRUE, sep="\t", colClasses=rep("character", 2) )
dfx_pics


xfl <- list.files( file.path( "..", "__09_week_02pdf" ), pattern="[0-9]\\.png$" )
xfl


######################### example of "serializing" png as evaluated vector

ii <- 21


xpic_png <- readPNG( file.path("..", "__09_week_02pdf", xfl[ii]), native = FALSE)

xdim <- dim(xpic_png) ; xdim


par(mfrow=c(1,2))

plot(1:2, 1:2, type="n")
rasterImage(xpic_png, 1, 1, 2, 2)


################# convert to eval string (vector)



xxx <- writePNG(xpic_png)

class(xxx)

yyy <- as.character(xxx)

zzz <- paste(yyy, collapse="")

## uuu <- strsplit(zzz, ":")[[1]]
uuu <- substring(zzz, seq(1, nchar(zzz), by=2), seq(2, nchar(zzz), by=2))

vvv <- as.raw(as.hexmode( uuu ))

object.size(zzz)

ypic_png <- readPNG(vvv, native=TRUE)


plot(1:2, 1:2, type="n")
rasterImage(ypic_png, 1, 1, 2, 2)





############################# now run as loop
#############################
#############################

xdf_pics_use <- dfx_pics

xdf_pics_use[ , "pic_data" ] <- ""


for(ii in 1:nrow(xdf_pics_use)) {
    
    xthis_picFN <- xdf_pics_use[ ii, "file" ] ; xthis_picFN

    xpic_png <- readPNG( file.path("..", "__09_week_02pdf", xthis_picFN), native = FALSE)

    ################# convert to eval string (vector)


    xxx <- writePNG(xpic_png)
    yyy <- as.character(xxx)
    zzz <- paste(yyy, collapse="") ##### no seperator
    
    xpic_png_str <- zzz

      
    xdf_pics_use[ ii, "pic_data" ] <- xpic_png_str
    #####xdf_pics_use[ ii, "pic_dims" ] <- xdim_png_evstr
    
    cat(ii, xthis_picFN, "\n")

}


colnames(xdf_pics_use)

###########################################




xtableNameC <- "MAS405images_serial2" ######## do not change this name

xbool.tableExistsC <- dbExistsTable(con, xtableNameC) ; xbool.tableExistsC

if(xbool.tableExistsC) {
    qstr <- paste0("DROP TABLE ", xtableNameC)
    xx <- dbGetQuery(con, qstr)
}


## use double or float -- avoid 'numeric'
qstr <- paste0(
"CREATE TABLE ", xtableNameC, " (",
"ID INT NOT NULL  AUTO_INCREMENT, ",
"UID VARCHAR(12), ",
"file TEXT,  ",
"pic_data LONGTEXT,  ",
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
dbWriteTable(con, xtableNameC, xdf_pics_use, field.types = NULL, append=TRUE, ##### notice appeand is TRUE
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
    table_name AS 'Table',
    round(((data_length + index_length) / 1024 / 1024), 3) 'Size in MB'
FROM
    information_schema.TABLES
"
dbGetQuery(con, qstr)

####################### beautiful








################################################ ADD TO Data Dictionary


xthis_taskName <- "MAS405images_serial2" #####

xabout <- "Example of MySQL image storage using raw-hexdecimal string -- no seperator"

xls_vars <-
list(
"UID"="UCLA University ID",
"file"="original file name",
"pic_data"="string representation of hexdec png image using R (with Rlib png). Use substring(), e.g., substring(x, seq(1, nchar(x), by=2), seq(2, nchar(x), by=2)), to split into vector of 2-char elements -- then as.raw(as.hexmode(x)) can be input into readPNG()"
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

xtableNameC <- "MAS405images_serial2" ######## do not change this name

qstr <- paste0(
"SELECT * FROM ", xtableNameC
)

qstr

xxnow <- Sys.time()
df_read_back <- dbGetQuery(con, qstr)
cat( difftime(Sys.time(), xxnow, unit="secs"), "\n" )

colnames(df_read_back)

rownames(df_read_back) <- df_read_back[ , "UID" ]

####################################

xpic_png_str <- df_read_back[ "404731988", "pic_data" ]

uuu <- substring(xpic_png_str, seq(1, nchar(xpic_png_str), by=2), seq(2, nchar(xpic_png_str), by=2))
vvv <- as.raw(as.hexmode( uuu ))
xback_img <- readPNG(vvv, native=TRUE)


plot(1:2, 1:2, type="n")
rasterImage(xback_img, 1, 1, 2, 2)



##########################

par(mfrow=c(5, 8), mar=c(1, 2, 2, 0))

for(ii in 1:nrow(df_read_back)) {
    
    xUID <- rownames(df_read_back)[ii]
    
    xpic_png_str <- df_read_back[ ii, "pic_data" ]
    
    uuu <- substring(xpic_png_str, seq(1, nchar(xpic_png_str), by=2), seq(2, nchar(xpic_png_str), by=2))
    vvv <- as.raw(as.hexmode( uuu ))
    xback_img <- readPNG(vvv, native=TRUE)
    
    
    plot(1:2, 1:2, type="n", main=xUID)
    rasterImage(xback_img, 1, 1, 2, 2)
    
}









dbDisconnect(con)


#################

