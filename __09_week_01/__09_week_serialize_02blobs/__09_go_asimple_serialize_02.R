

######################### The directory that encloses this file
######################### is your working directory



options(stringsAsFactors=FALSE, width=200)

projpath <- getwd()


if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)


drv <- dbDriver("MySQL")



xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )



con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



qstr <- "SHOW TABLES"
xx <- dbGetQuery(con, qstr)
xx



qstr <- paste0(
"SELECT * FROM nhl_goaliesDate_1"
)
df_nhl_goaliesDate <- dbGetQuery(con, qstr)
df_nhl_goaliesDate



is.raw(df_nhl_goaliesDate)



xxx <- serialize(object=df_nhl_goaliesDate, connection=NULL, ascii=FALSE, xdr = TRUE)

length(xxx) / 10^6

class(xxx)

##### convert to string
yyy <- as.character(xxx)
zzz <- paste(yyy, collapse=":")
## zzz


##### convert back
uuu <- strsplit(zzz, ":")[[1]]
vvv <- as.raw(as.hexmode( uuu ))
## vvv

unserialize(vvv)



############# more space efficient

yyy <- as.character(xxx)
zzz <- paste(yyy, collapse="")
## zzz

nchar(zzz) / 10^6



uuu <- substring(zzz, seq(1, nchar(zzz), by=2), seq(2, nchar(zzz), by=2))
vvv <- as.raw(as.hexmode( uuu ))
## vvv

unserialize(vvv)












