#' @title Plot covid-19 time series
#'
#' @description Takes the data from updateCovid function and passes it on to plot a time series plot for
#' every type of data available.
#'
#' @param country name of the country
#' @param min.date a value from 2020-1-22 to today's date
#' @param max.date a value from 2020-1-22 to today's date
#' @author Ali Malek
#' @return a time series plot
#' @export
#' @import tidyverse
#'
#' @examples
#' covidTimeSeries(country = "egypt",min.date = "2020-02-22",max.date = as.Date(today()))
covidTimeSeries <- function(country = "egypt",min.date = "2020-01-22",max.date = as.Date(today())){
  require(tidyverse)
  min.date <- as.Date(min.date)
  max.date <- as.Date(max.date)
  country <- tolower(country)
  if (min.date < "2020-01-22" | max.date > as.Date(today())) {
    return(warning("Not a valid date"))
  }
  sap <- updateCovid()
  sap$`Country/Region` <- tolower(sap$`Country/Region`)
  if (country %in% sap$`Country/Region` != TRUE) {
    return(warning("Not a valid country"))
  }
  sap %>% filter(`Country/Region` == country & date >= min.date & date <= max.date) -> sap
  sap1 <- sap %>% filter(type == "Total Cases")
  sap2 <- sap %>% filter(type == "Total Deaths")
  sap3 <- sap %>% filter(type == "Total Recovered")
  sap1$new <- c(sap1$count[1],diff(sap1$count))
  sap2$new <- c(sap2$count[1],diff(sap2$count))
  sap3$new <- c(sap3$count[1],diff(sap3$count))
  sap <- rbind(sap1,sap2,sap3)
  sap$new[sap$new <= 0] <- 0
  title <- paste("Time Series Of",str_to_title(country),"From",min.date,"To",max.date)
  sap %>% ggplot(aes(x=date,y=new)) +
    geom_line(aes(group = type,color = type)) +
    ggtitle(title) +
    ylab("New Daily Cases") +
    xlab("Time")
}

