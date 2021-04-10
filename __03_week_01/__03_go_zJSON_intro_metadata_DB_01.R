

######################### JSON type
#########################
#########################

options(stringsAsFactors=FALSE, width=200)

projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)

library(rjson)


drv <- dbDriver("MySQL")






########################################



############# db1
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




######################### META DATA w JSON as text


xtableName <- "metadata_json"

xbool.tableExists <- dbExistsTable(con, xtableName) ; xbool.tableExists


############################## IMPORTANT NOTE -- THE FOLLOWING CODE CHUNK DESTROYS THE TABLE METADATA
############################## IN REAL LIFE, YOU'LL SURELY WANT STRICT LIMITATIONS OVER THIS OPERATION

if(xbool.tableExists) {
    qstr <- paste0("DROP TABLE ", xtableName)
    xx <- dbGetQuery(con, qstr)
}



############ note that table name is primary key -- primary keys MUST BE UNIQUE


##################################################################### info AS TEXT
##################################################################### info AS TEXT
##################################################################### info AS TEXT
##################################################################### info AS TEXT

qstr <- paste0("CREATE TABLE ", xtableName, " (tableName VARCHAR(100) NOT NULL, info TEXT, PRIMARY KEY (tableName))")
xx <- dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM ", xtableName)
dbGetQuery(con, qstr)


####### create meta data for ozone_data as R list class

xls_vars <-
list(
"longitude"="geo longitude",
"latitude"="geo latitude",
"O3"="ground level ozone concentration, ppm"
)


xls_info <-
list(
"about"="ozone levels",
"codebook"=xls_vars
)

xinfoJSON <- toJSON(xls_info)



xinfoEscaped <- dbEscapeStrings(con, xinfoJSON)

#### this is our original ozone_data defs
#xabout <- "ozone levels"
#xvariables <- "longitude: geo longitude; latitude: geo latitude; O3: ground level ozone concentration, ppm"

mdtable <- "ozone_data"




qstr <- paste0(
"INSERT INTO ", xtableName, " (tableName, info) VALUES (",
"'", mdtable, "', ",
"'", xinfoEscaped, "'",
#" JSON_OBJECT('", dbEscapeStrings(con, xinfoJSON), "')",
")"
) ; qstr

xx <- dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM ", xtableName)
dbGetQuery(con, qstr)



#############################

qstr <- paste0(
"SELECT * FROM ", xtableName
) ; qstr
xx <- dbGetQuery(con, qstr)
xx



xx[1, "info"]

xls <- fromJSON(json_str=xx[1, "info"])

print(xls)


as.data.frame(xls)




qstr <- paste0(
"SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = '", xtableName, "'"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx




########################################## update

xinfoEscaped <- dbEscapeStrings(con, xinfoJSON)

qstr <- paste0(
"UPDATE ", xtableName, " SET ",
#"info='", xinfoEscaped, "'  ",
"info='", xinfoEscaped, "'  ",
"WHERE tableName='", xtableName, "'"
) ; qstr

xx <- dbGetQuery(con, qstr)


qstr <- paste0("SHOW COLUMNS FROM ", xtableName)
dbGetQuery(con, qstr)

qstr <- paste0(
"SELECT * FROM ", xtableName
) ; qstr
xx <- dbGetQuery(con, qstr)
xx



xls <- fromJSON(json_str=xx[1, "info"])

print(xls)


as.data.frame(xls)

xxjson_out <- paste0("[", xx[1, "info"], "]")

xxjson_out <- xx[1, "info"]


###################################### write out as file

writeLines( xxjson_out, file.path("~", "Desktop", "simpleJSONtest.json") )



################ this is an example!  Must edit this for your DB and tables!
################ this is an example!  Must edit this for your DB and tables!
################ this is an example!  Must edit this for your DB and tables!
################ this is an example!  Must edit this for your DB and tables!


xtableName <- "myCommunityTable_1"
xabout <- "my first uploaded data set -- table was populated one record at a time"
xvariables <- "x: simulated under standard normal distribution; y: indicator outcome \\(try and figure this out\\)"  ### notice the escapes !!!!!



##########################

dbDisconnect(con)











