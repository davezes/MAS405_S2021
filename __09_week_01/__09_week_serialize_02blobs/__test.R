

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

as.raw(xls)

raw(xls)

xxx <- serialize(object=xls, connection=NULL, ascii=FALSE, xdr = TRUE)
xxx

class(xxx)

yyy <- as.character(xxx)
zzz <- paste(yyy, collapse=":")
uuu <- strsplit(zzz, ":")[[1]]
vvv <- as.raw(as.hexmode( uuu ))


unserialize(vvv)



############# more space efficient

yyy <- as.character(xxx)
zzz <- paste(yyy, collapse="")

uuu <- substring(zzz, seq(1, nchar(zzz), by=2), seq(2, nchar(zzz), by=2))

vvv <- as.raw(as.hexmode( uuu ))


unserialize(vvv)












