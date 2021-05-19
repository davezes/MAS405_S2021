



projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)

library(rjson)


drv <- dbDriver("MySQL")






########################################  YOUR .Renviron file
########################################  SHOULD HAVE THESE ASSIGNED


xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xpw     <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )


#xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
#xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
#xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
#xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
#xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )


xdbuser
xpw
xdbname
xdbhost
xdbport



con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)





########################## info


dbListTables(con)



dbGetInfo(con)




xbool.tableExists <- dbExistsTable(con, "metadata") ; xbool.tableExists



############################## IMPORTANT NOTE -- THE FOLLOWING CODE CHUNK DESTROYS THE TABLE METADATA
############################## IN REAL LIFE, YOU'LL SURELY WANT STRICT LIMITATIONS OVER THIS OPERATION

##### DROP is part of SQL's "Data Definition Language"

if(xbool.tableExists) {
    qstr <- paste("DROP TABLE metadata",  sep="")
    xx <- dbGetQuery(con, qstr)
}



##### CREATE is part of SQL's "Data Definition Language"

## use double or float -- avoid 'numeric'
qstr <- paste0("CREATE TABLE metadata (entryNumber INT NOT NULL  AUTO_INCREMENT , entry JSON, PRIMARY KEY (entryNumber))")


xx <- dbGetQuery(con, qstr)


qstr <- paste0("SELECT * FROM metadata")
xx <- dbGetQuery(con, qstr)
xx


####################### the correspondence between R list() and JSON

xls <- list()


xls[[ "Creator" ]] <- "Dave Zes" ##### EDIT THIS
xls[[ "Creation Date" ]] <- "2021-04-07" ##### EDIT THIS  ### "2021-03-23"

xls[[ "Title" ]] <- "Stats MAS405 Awesomeness"
xls[[ "Purpose" ]] <- "Learn some MySQL, learn about DBs, load and share data with others"

xls[[ "DBresources" ]] <-
list(
"1"="See table dataDictionary for information about a specific table",
"2"="See table notes for information about table relationships"
)


library(rjson)


xjson <- toJSON(xls)


####### writeLines( xjson, con=file.path("~", "Desktop", "md_json.json"))

##### to view this file in Chrome, ad "JSONViewer" extension to Chrome

xjsonEscaped <- dbEscapeStrings(con, xjson) ; xjsonEscaped





####### INSERT is part of SQL's Data Manipulation Language (DML) syntax

ii <- 1

qstr <- paste0(
"INSERT INTO metadata (entryNumber, entry) VALUES ('",
ii, "', '",
xjsonEscaped, "'",
")"
)

qstr

xx <- dbGetQuery(con, qstr)
xx




qstr <- paste0("SELECT * FROM metadata")
xx <- dbGetQuery(con, qstr)
xx


### writeLines(xx[ 1, "entry" ], "~/Desktop/myMD.json")

########################## info

dbListTables(con)

dbGetInfo(con)


qstr <- paste0("SHOW COLUMNS FROM metadata")
dbGetQuery(con, qstr)






qstr <- paste0("SELECT * FROM dataDictionary")
xx <- dbGetQuery(con, qstr)
xx


### writeLines(xx[ 6, "variableDefs" ], "~/Desktop/myDDexample.json")



qstr <- paste0("SELECT * FROM notes")
xx <- dbGetQuery(con, qstr)
xx


### writeLines(xx[ 6, "variableDefs" ], "~/Desktop/myDDexample.json")



########################### retrieve

########################### here in R

########## SELECT is part of SQL's Data Manipulation Language syntax, just like "INSERT" above


###########################  in Terminal mysql:

##  SELECT * FROM metadata ;


###### Also try in MySQL Workbench




dbDisconnect(con)


