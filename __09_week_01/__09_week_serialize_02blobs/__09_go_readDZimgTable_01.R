

######################### The directory that encloses this file
######################### is your working directory



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



############# Zes's
xdbuser <- Sys.getenv("MAS405_AWS_DZES_DB_RO_USER")
xpw     <- Sys.getenv("MAS405_AWS_DZES_DB_RO_PW")
xdbname <- Sys.getenv("MAS405_AWS_DZES_DB_RO_DBNAME")
xdbhost <- Sys.getenv("MAS405_AWS_DZES_DB_RO_HOST")
xdbport <- as.integer( Sys.getenv("MAS405_AWS_DZES_DB_RO_PORT") )






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


##################################################### read images
##################################################### read images
##################################################### read images
##################################################### read images


########################################## read back

xtableNameC <- "MAS405images" ######## do not change this name

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

xUID <- "305428123"

xpic_png_evstr <- df_read_back[ xUID, "pic_data" ]
xpic_dim_evstr <- df_read_back[ xUID, "pic_dims" ]

xback_img <- eval(parse(text=xpic_png_evstr)) / 255

dim(xback_img) <- eval(parse(text=xpic_dim_evstr))

plot(1:2, 1:2, type="n")
rasterImage(xback_img, 1, 1, 2, 2)








################





dbDisconnect(con)











