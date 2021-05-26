

######################### The directory that encloses this file
######################### is your working directory



options(stringsAsFactors=FALSE, width=200)

projpath <- getwd()


xls <-
list(
"x"=c(1,2,3),
"TEST"="TESTING",
"mx"=matrix(rnorm(4), 2, 2)
)

xls



is.raw(xls)



xxx <- serialize(object=xls, connection=NULL, ascii=FALSE, xdr = TRUE)
xxx

class(xxx)

##### convert to string
yyy <- as.character(xxx)
zzz <- paste(yyy, collapse=":")
zzz


##### convert back
uuu <- strsplit(zzz, ":")[[1]]
vvv <- as.raw(as.hexmode( uuu ))
vvv

unserialize(vvv)



############# more space efficient

yyy <- as.character(xxx)
zzz <- paste(yyy, collapse="")
zzz



uuu <- substring(zzz, seq(1, nchar(zzz), by=2), seq(2, nchar(zzz), by=2))
vvv <- as.raw(as.hexmode( uuu ))
vvv

unserialize(vvv)












