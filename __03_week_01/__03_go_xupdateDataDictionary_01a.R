


projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}



#xpathTables <- file.path(projpath, "_taskCatalogs", xthis.taskName, "__Tables")



library(RMySQL)

library(rjson)


drv <- dbDriver("MySQL")






######################################## dataDictionary

################### You must add the appropriate parameters to you .Renviron file

xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
xpw     <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )


con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



dbListTables(con)

dbGetInfo(con)


#################


qstr <- paste0(
"SELECT * FROM ozone_data"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx


############### let's document, simply, DB

##### dataDictionary is an example of camel-case naming convension

xbool.tableExists <- dbExistsTable(con, "dataDictionary") ; xbool.tableExists


xthis_taskName <- "ozone_data"

############################## IMPORTANT NOTE -- THE FOLLOWING CODE CHUNK DESTROYS THE TABLE dataDictionary
############################## IN REAL LIFE, YOU'LL SURELY WANT STRICT LIMITATIONS OVER THIS OPERATION

if(xbool.tableExists) {
    qstr <- paste("DROP TABLE dataDictionary",  sep="")
    xx <- dbGetQuery(con, qstr)
}



############ note that table name is primary key -- primary keys MUST BE UNIQUE

#qstr <- paste0("CREATE TABLE dataDictionary (tableName VARCHAR(100) NOT NULL, about TEXT, variableDefs TEXT, PRIMARY KEY (tableName))")
#xx <- dbGetQuery(con, qstr)
### xvariables <- "longitude: geo longitude; latitude: geo latitude; O3: ground level ozone concentration, ppm"



qstr <- paste0("CREATE TABLE dataDictionary (tableName VARCHAR(100) NOT NULL, about TEXT, variableDefs JSON, PRIMARY KEY (tableName))")
xx <- dbGetQuery(con, qstr)



qstr <- paste0(
"SELECT * FROM dataDictionary"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx




xabout <- "ozone levels"

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
xinfoEscaped




qstr <- paste0(
"INSERT INTO dataDictionary (tableName, about, variableDefs) VALUES (",
"'", xthis_taskName, "', ",
"'", xabout, "', ",
"'", xinfoEscaped, "'",
")"
) ; qstr

xx <- dbGetQuery(con, qstr)



#############################

qstr <- paste0(
"SELECT * FROM dataDictionary"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx


##### writeLines( xx[4, "variableDefs"], con=file.path("~", "Desktop", "DD_json.json"))



qstr <- paste0("SHOW COLUMNS FROM dataDictionary")
dbGetQuery(con, qstr)






############################## workbench and mysql-client

if(FALSE) {
    
    ################## in workbench
    
    ### note may need to double click db name in schema to set default db for queries
    select * from dataDictionary
    
    
    ################### mysql command line
    
    mysql -h database-1.cpr21gaoimsy.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
    
    \u db1
    
    \G 'select * from dataDictionary'
    
    --or--
    
    select * from dataDictionary ;
    
    
    
    ##################### ADD NEW USER
    
    ################# new user in mysql -- do not do this in AWS RDS Console
    
    ########### in mysql:
    
    SHOW GRANTS FOR 'admin' ;
    
    GRANT SELECT ON db1.* TO 'readOnly' IDENTIFIED BY '2277read**00' ;
    
    #### you can now see user readOnly on MySQL Workbench
    
    
    ################### stopped here
    
}



#################


yy <- dbGetQuery(con, "SELECT * FROM metadata")
writeLines(yy[ 1, "entry"], file.path("~", "Desktop", "DZ_metadata.json"))



dbDisconnect(con)
