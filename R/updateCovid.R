#' @title A comprehensive covid-19 dataframe
#'
#' @description This function gives back a dataframe of total cases, total deaths, and total recoveres from covid-19 in the world.
#'
#' @author Ali Malek
#' @return A dataframe containing the cumulative daily cases, deaths, and recovers of covid-19 of all countries.
#' @export
#' @import tidyverse
#' @import lubridate
#'
#' @examples
#' updateCovid()
updateCovid <- function(){
  require(tidyverse)
  require(lubridate)
  urlcases="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
  urldeaths="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
  urlrecovered="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
  coltypes <- cols(
    .default = col_double(),
    `Province/State` = col_character(),
    `Country/Region` = col_character()
  )
  cases<-read_csv(url(urlcases),progress = show_progress(),col_types = coltypes)
  deaths <- read_csv(url(urldeaths),col_types = coltypes)
  recovered <- read_csv(url(urlrecovered),col_types = coltypes)
  cases <- cases[,-c(1,3,4)]
  deaths <- deaths[,-c(1,3,4)]
  recovered <- recovered[,-c(1,3,4)]
  cases <- aggregate(. ~ `Country/Region`, cases, sum)
  deaths <-  aggregate(. ~ `Country/Region`, deaths, sum)
  recovered <-  aggregate(. ~ `Country/Region`, recovered, sum)
  cases$type <- "Total Cases"
  deaths$type <- "Total Deaths"
  recovered$type <- "Total Recovered"
  total <- rbind(cases,deaths,recovered)
  total[total$`Country/Region`=='US',1] <- "United States of America"
  total <- total %>% arrange(`Country/Region`,type)
  co <- ncol(total)
  total <- total[,c(1,co,2:(co-1))]
  namescol <-colnames(total[,3:co])
  total <- total %>% gather(all_of(namescol),key = 'date',value = 'count')
  total$date <- as.Date(fast_strptime(total$date, '%m/%d/%y'))
  return(total)
}


