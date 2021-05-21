
##### to use these, table must have fields

## "file TEXT,  ",
## "segment INT(14),  ",
## "raw_data MEDIUMTEXT,  ",


### xobj <- xwav ; xfile <- xthisFN ; xdrv <- drv; xtableName <- "MAS405audio_serialSegs" ; xsegSize <- 10^6 ; xcomp <- "xz" ; xoverWrite <- TRUE ; xverbosity <- 2

f_dbwrite_raw <- function(
xobj,
xtableName,
xfile,
xdrv,
xdbuser,
xdbpw,
xdbname,
xdbhost,
xdbport,
xoverWrite=FALSE,
xsegSize=10^6,
xverbosity=1,
xcomp="xz"
) {
    

    xxx <- serialize(xobj, con=NULL)
    
    if( xverbosity > 0 ) {
        cat("object class:", class(xobj), "\n")
        cat("serialized object size MB:", format(object.size(xxx), "MB"), "\n")
        cat("serialized vector length in millions:", length(xxx) / 10^6, "\n")
    }
    
    xxnow <- Sys.time()
    yyy <- memCompress(from=xxx, type=xcomp)
    xxdiffTime <- difftime(Sys.time(), xxnow, units="secs")

    if( xverbosity > 0 ) {
        cat("compressed serialized object size MB:", format(object.size(yyy), "MB"), "\n")
        cat("compressed serialized vector length in millions:", length(yyy) / 10^6, "\n")
        cat("time taken for compression:", xxdiffTime, "seconds", "\n")
    }



    ##################################### segment
    
    xbrks <- sort(unique(c(seq(1, length(yyy), by=xsegSize), length(yyy)+1))) ; xbrks
    
    Ns <- length(xbrks) - 1
    
    xout <- character( Ns ) ; xout
    
    for(jj in 2:(Ns+1)) {
        this_seg <- paste(yyy[ (xbrks[jj-1]):(xbrks[jj]-1) ], collapse="")
        xout[ jj-1 ] <- this_seg
        
        if( xverbosity > 1 ) {
            cat("processing segment", jj-1, "of" , Ns, "\n")
        }
    }


    xdf_data <-
    data.frame(
    "file"=rep(xfile, Ns),
    "segment"=(1:Ns),
    "raw_data"=xout
    )

    con <- dbConnect(xdrv, user=xdbuser, password=xdbpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)
    
    if(xoverWrite) {
      
        qstr <- paste0(
        "DELETE FROM ", xtableName,
        "  WHERE file='", xfile, "'"
        )
        qstr
        xx <- try( dbGetQuery(con, qstr), silent=TRUE )
        xx
        
    }

    xxnow <- Sys.time()
    dbWriteTable(con, xtableName, xdf_data, field.types = NULL, append=TRUE, ##### notice appeand is TRUE
    row.names=FALSE, overwrite=FALSE)
    yydiffTime <- difftime(Sys.time(), xxnow, unit="secs")

    if( xverbosity > 0 ) {
        cat("time taken to write to table, ", xtableName, ":", yydiffTime, "seconds", "\n")
    }
    
    dbDisconnect(con)
    
}








f_dbread_raw <- function(
xtableName,
xfile,
xdrv,
xdbuser,
xdbpw,
xdbname,
xdbhost,
xdbport,
xverbosity=1,
xcomp="xz"
) {
    
    con <- dbConnect(xdrv, user=xdbuser, password=xdbpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)
    
    qstr <- paste0(
    "SELECT * FROM ", xtableName,
    "  WHERE file='", xfile, "'"
    )

    xxnow <- Sys.time()
    df_read_back <- dbGetQuery(con, qstr)
    xxdiffTime <- difftime(Sys.time(), xxnow, units="secs")
    
    dbDisconnect(con)
    
    if( xverbosity > 0 ) {
        cat("time taken to read from DB:", xxdiffTime, "seconds", "\n")
        cat("dim of df:", dim(df_read_back), "\n")
    }

    xperm <- order(df_read_back[ , "segment" ])
    xla <- lapply( df_read_back[ xperm, "raw_data"], function(x) { return(substring(x, seq(1, nchar(x), by=2), seq(2, nchar(x), by=2))) } )

    uuu <- unlist(xla)
    vvv <- as.raw(as.hexmode( uuu ))
    www <- memDecompress(from=vvv, type=xcomp)

    zobj <- unserialize(www)
    


    
    return(zobj)
    
}






