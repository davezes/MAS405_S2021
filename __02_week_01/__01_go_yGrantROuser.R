

###############################


projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}



#xpathTables <- file.path(projpath, "_taskCatalogs", xthis.taskName, "__Tables")



library(RMySQL)


drv <- dbDriver("MySQL")






######################################## metadata

################### You must add the appropriate parameters to you .Renviron file

xdbuser <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_USER")
dzpw <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PW")
xdbname <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_MY_DB_ADMIN_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_MY_DB_ADMIN_PORT") )


con <- dbConnect(drv, user=xdbuser, password=dzpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



dbListTables(con)

dbGetInfo(con)


#################################







############# show all users

qstr <- paste0(
"SELECT user FROM mysql.user"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx



########## permissions
qstr <- paste0(
"SHOW GRANTS FOR admin"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx

########## permissions
qstr <- paste0(
"SHOW GRANTS FOR readOnly"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx




########## drop user
qstr <- paste0(
"DROP USER readOnly"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx



qstr <- paste0(
"CREATE USER readOnly IDENTIFIED BY 'MAS405S2020wickedAwesome'"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx

qstr <- paste0(
"GRANT SELECT ON db1.* TO readOnly "
) ; qstr
xx <- dbGetQuery(con, qstr)
xx




########## permissions
qstr <- paste0(
"SHOW GRANTS FOR readOnly"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx






if(FALSE) {
  
    ########### in mysql:
    
    SHOW GRANTS ;
    
    GRANT SELECT ON db1.* TO 'readOnly' IDENTIFIED BY 'MAS405S2020wickedAwesome'
    
    #### you can now see user readOnly on MySQL Workbench
    
    
    ################### stopped here
    
}







