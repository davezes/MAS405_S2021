
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES
#################### DATA PROVERB IV -- WHEN WEB SCRAPING, ALWAYS KEEP RETRIEVAL AND CLEANING AS TWO ISOLATED PROCESSES


############### https://console.cloud.google.com/apis


########## ADD TO YOU .Renviron File
########## PATH_MY_MAIN_DATA_WEBSCRAPER=<pathToYourWebscraperData>

options(stringsAsFactors=FALSE)

xpath_web_data <- Sys.getenv("PATH_MY_MAIN_DATA_WEBSCRAPER")

xpath_write <- file.path(xpath_web_data, "GeoExample")

if(!dir.exists(xpath_write)) {
    dir.create(xpath_write)
}

mxX <-
cbind(
"ID"=1,
"countryAddress"="United States",
"stateAddress"="California",
"cityAddress"="Signal Hill",
"streetAddress"="2351 Dawson Ave",
"zipCode"=""
)


ii <- 1

############# this is my API key.  For heavy use you should get your own key --

APIkey <- "AIzaSyCJrtmNblTajm-43hJTY4wmGHCU8vr8y7s"

R_ID <- mxX[ ii, "ID" ] ; R_ID ###### should be unique
R_cntry <- mxX[ ii, "countryAddress" ] ; R_cntry
R_state <- mxX[ ii, "stateAddress" ] ; R_state
R.city <- mxX[ ii, "cityAddress" ] ; R.city
R_street <- mxX[ ii, "streetAddress" ] ; R_street
R_street <- gsub("NULL", "", R_street)
R_zip <- mxX[ ii, "zipCode" ] ; R_zip

xurl_str <- paste0("+", R_street, ",", R.city, ",", R_zip, ",", R_state, ",", R_cntry) ; xurl_str
xurl_str <- gsub("[ ]+", "+", xurl_str)
xurl_str <- gsub(",", ",+", xurl_str)
xurl_str

xurl_str <- paste0("https://maps.googleapis.com/maps/api/geocode/json?address=", xurl_str, "&key=", APIkey) ; xurl_str


xGAPIinfo <- readLines(con=xurl_str)


writeLines(xGAPIinfo, file.path(xpath_write, paste0("GM_", R_ID, ".json")))

