


options(stringsAsFactors=FALSE, width=200)

###### no problemo
x <- 2L
y <- x^10
y <- as.integer(y)
class(y)
y


###### muy problemo
x <- 2L
y <- x^50
y <- as.integer(y)
class(y)
y



z <- rep(0, 10^9)
length(z)

zz <- rep(0, 10^12)
length(zz)










