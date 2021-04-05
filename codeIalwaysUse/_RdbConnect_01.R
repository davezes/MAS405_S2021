
########### use RMySQL to connect to DB

projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}

library(RMySQL)

drv <- dbDriver("MySQL")

########################################
xdbuser <- ""
dzpw <- ""
xdbname <- ""
xdbhost <- ""
xdbport <- 3306 #### must be numeric or integer


con <- dbConnect(drv, user=xdbuser, password=dzpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)

dbListTables(con)

dbGetInfo(con)

#################

dbDisconnect(con)

