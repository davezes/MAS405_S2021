

######################### The directory that encloses this file
######################### is your working directory


######################### this is more memory efficient

options(stringsAsFactors=FALSE, width=200)



projpath <- getwd()


library(png)

library(digest)


#########################
#########################


dfx_pics <- read.table( file.path("__images", "__log.tsv"), header=TRUE, sep="\t", colClasses=rep("character", 2) )
dfx_pics


xfl <- list.files( file.path( "__images" ), pattern="[0-9]\\.png$" )
xfl


######################### example of "serializing" png as evaluated vector

ii <- 21


xpic_png <- readPNG( file.path("__images", xfl[ii]), native = FALSE)

xdim <- dim(xpic_png) ; xdim

xunique <- digest(xpic_png, algo="md5")
xunique



plot(1:2, 1:2, type="n")
rasterImage(xpic_png, 1, 1, 2, 2)
text(1.5, 2.1, xunique, xpd=TRUE)


################# convert to eval string (vector)






############################# now run as loop
#############################
#############################

xdf_pics_use <- dfx_pics

xdf_pics_use[ , "pic_data" ] <- ""

xdf_pics_use[ , "pic_digest_md5" ] <- ""

for(ii in 1:nrow(xdf_pics_use)) {
    
    xthis_picFN <- xdf_pics_use[ ii, "file" ] ; xthis_picFN

    xpic_png <- readPNG( file.path("__images", xthis_picFN), native = FALSE)

    ################# convert to eval string (vector)


    xxx <- writePNG(xpic_png)
    yyy <- as.character(xxx)
    zzz <- paste(yyy, collapse="") ##### no seperator
    
    xpic_png_str <- zzz

      
    xdf_pics_use[ ii, "pic_data" ] <- xpic_png_str
    
    xdf_pics_use[ ii, "pic_digest_md5" ] <- digest(xpic_png, algo="md5")
    
    
    
    #####xdf_pics_use[ ii, "pic_dims" ] <- xdim_png_evstr
    
    cat(ii, xthis_picFN, "\n")

}


colnames(xdf_pics_use)



#################

