


########################### this file automatically reads PDF roster and builds and writes script for extracting photos

################### Does not use _pics dir for usage on Windows machine


options(stringsAsFactors=FALSE)

###############################

library(pdftools)

#library(tidyverse)


xrosterFile <- "PhotoRoster-663610200-21S.pdf"
xoutputFile <- "script_uids_out.sh"
xbool_isLast <- TRUE



xpathWork <- "image.png"



## unlink( file.path("*.png") )


xrightChar <- 80

xpdftxt <- pdf_text(xrosterFile)

xx <- readr::read_lines(xpdftxt)



xndxs <- which(grepl("\\bPage [0-9]* of", xx)) ; xndxs
xndxs <- c(1, xndxs)
xndxs





bigOUT <-
c(
"",
"xwdth=470",
"xhght=540",
"xca=100",
"xcb=840",
"xra=170",
"xrb=770",
"xrc=1370",
""
)


xrowKeys <- c("$xra", "$xrb", "$xrc")
xcolKeys <- c("$xca", "$xcb")

ii <- 3




for(ii in 2:length(xndxs)) {
    
    
    xxsub <- xx[ xndxs[ii-1]:xndxs[ii] ] ; xxsub
    
    xndx_row <- 0
    lastFound_jj <- -100
    
    bigOUT <-
    c(
    bigOUT,
    paste0("xpage=", ii-2),
    "",
    paste0("convert -density 200 ", xrosterFile, "[$xpage]  ", xpathWork),
    ""
    )
    
    
    jj <- 1
    for(jj in 1:length(xxsub)) {
        

        
        xthis_line <- xxsub[jj] ; xthis_line
      
        xxro <- gregexpr( "[0-9][0-9][0-9]\\-[0-9][0-9][0-9]\\-[0-9][0-9][0-9]", xthis_line, perl=TRUE)[[1]] ; xxro
        xmlen <- attr(xxro, "match.length") ; xmlen
        ##xmchars <- attr(xxro, "index.type") ; xmchars
        
        if( xxro[1] > 0 ) {
            
            for(ie in 1:length(xxro) ) {
                xthis_xxro <- xxro[ie]
                xthis_len <- xmlen[ie]
                
                thisUID <- gsub("\\-", "", substr(xthis_line, xthis_xxro, xthis_xxro+xthis_len-1)) ; thisUID
                
                if( xthis_xxro > xrightChar ) {
                    xkeyColumn <- xcolKeys[2]
                } else {
                    xkeyColumn <- xcolKeys[1]
                }
                
                if( jj > lastFound_jj + 4 ) {
                    xndx_row <- xndx_row + 1
                }
                
                xkeyRow <- xrowKeys[ xndx_row ]
                
                xstr <-
                paste0(
                "convert -crop $xwdth'x'$xhght'+'",
                xkeyColumn, "'+'", xkeyRow, "  ",  xpathWork, "  ",  thisUID, ".png"
                )
                
                bigOUT <-
                c(
                bigOUT,
                xstr
                )
                
                lastFound_jj <- jj
            }
            
            
        }
        
        
    }
    
}




xxxbuildLogFile <-
c(

"echo -n > __log.tsv",

## "echo '0000'$'\\t''0000.png' >> ~/Desktop/__log.tsv",

"echo 'UID'$'\\t''file' >> __log.tsv",

"for f in *[0-9].png",
"do",
    "g=${f//[.png]/}",
    "echo $g",
    "echo ${g}$'\\t'${f} >> __log.tsv",
"done"

)


if(xbool_isLast) {
    
} else {
    xxxbuildLogFile <- ""
}


bigOUT <- c(bigOUT, "", "", xxxbuildLogFile)

writeLines(bigOUT, xoutputFile)







