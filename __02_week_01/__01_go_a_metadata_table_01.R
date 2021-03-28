



projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)

library(rjson)


drv <- dbDriver("MySQL")






######################################## EDIT YOUR .Renviron file
######################################## EDIT YOUR .Renviron file
######################################## EDIT YOUR .Renviron file


xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
dzpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )



con <- dbConnect(drv, user=xdbuser, password=dzpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)





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
qstr <- paste0("CREATE TABLE metadata (entryNumber INT NOT NULL, entry JSON, PRIMARY KEY (entryNumber))")


xx <- dbGetQuery(con, qstr)



####################### the correspondence between R list() and JSON

xls <- list()


xls[[ "Creator" ]] <- "Dave Zes"
xls[[ "Creation Date" ]] <- "2021-03-23"
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




########################## info

dbListTables(con)

dbGetInfo(con)


qstr <- paste0("SHOW COLUMNS FROM metadata")
dbGetQuery(con, qstr)


########################### retrieve

########################### here in R

########## SELECT is part of SQL's Data Manipulation Language syntax, just like "INSERT" above

qstr <- paste0("SELECT * FROM metadata")
xx <- dbGetQuery(con, qstr)
xx


###########################  in Terminal mysql:

##  SELECT * FROM metadata ;


###### Also try in MySQL Workbench




dbDisconnect(con)


