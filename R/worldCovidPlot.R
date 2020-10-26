#' @title Plot world map colored with covid-19
#'
#' @description Takes the data from updateCovid function and passes it on to plot a world map colored by the
#' count of cases of each country.
#'
#' @param day A date value. Default is "2020-09-19"
#' @param type type of the data to plot. One of the three values: "cases","deaths", and "recovered".
#' @author Ali Malek
#' @return a plot
#' @export
#' @import tidyverse
#' @import sf
#' @import rnaturalearth
#' @import rnaturalearthdata
#'
#' @examples
#' worldCovidPlot(day = "2020-09-19", type = "cases")
worldCovidPlot <- function(day = "2020-09-19", type = "cases"){
if (type %in% c("cases","deaths","recovered") != TRUE) {
  return(  warning("Not a valid type"))
}
day <- as.Date(day)
if (day < "2020-01-22" | day >as.Date(today())) {
  return(  warning("Not a valid date"))
}
require(tidyverse)
theme_set(theme_bw())
require(sf)
require(rnaturalearth)
require(rnaturalearthdata)
typ <- switch(type,
                "cases" 	= 	"Total Cases",
                "deaths" =	"Total Deaths",
                "recovered" 	=	"Total Recovered")
shame <- updateCovid()
shame %>% filter(type == typ & date == day) -> right
world <- ne_countries(scale = "medium", returnclass = "sf")
tttt <- left_join(world,right,by = c("admin"="Country/Region"))
titl <- paste(typ,'Till',day)
ggplot(data = tttt) +
  geom_sf(aes(fill = count)) +
  scale_fill_viridis_c(option = "plasma") +
  ggtitle(titl)
}

