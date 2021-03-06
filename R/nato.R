#' NATO Member Defense Expenditures
#'
#' A sample dataset of NATO/OTAN member defense expenditures.
#'
#' @source <https://www.nato.int/cps/en/natohq/news_167080.htm>
#'
#' @format A data.frame of 232 rows and 14 variables.
#'
#' Variables:
#'
#' \describe{
#'     \item{`country_stanag`}{Country code in NATO STANAG format}
#'     \item{`year`}{Year, from 2012 to 2019. 2018-2019 numbers may be estimates.}
#'     \item{`Defense expenditure (USD, current prices)`}{
#'         Defense expenditures in US dollars, using current prices and exchange rates.
#'     }
#'     \item{`Defense expenditure (USD, 2015 prices)`}{
#'         Defense expenditures in US dollars, using 2015 prices and exchange rates.
#'     }
#'     \item{`Defense expenditure (% real GDP)`}{
#'         Defense expenditure as a percentage of real gross domestic product.
#'         Based on 2015 prices.
#'     }
#'     \item{`Defense expenditure annual real change (% GDP)`}{
#'         Annual change in defense expenditure as a percentage of real gross
#'         domestic product. Based on 2015 prices.
#'     }
#'     \item{`Real GDP (2015 prices)`}{
#'         Real gross domestic product in 2015 US dollars and at 2015 exchange
#'         rates.
#'     }
#'     \item{`GDP per capita (USD)`}{
#'         Gross domestic product per capita in 2015 US dollars and at 2015
#'         exchange rates.
#'     }
#'     \item{`Defense expenditure per capita (USD)`}{
#'         Defense expenditure per capita in 2015 US dollars.
#'     }
#'     \item{`Military personnel`}{Number of military personnel}
#'     \item{`Equipment expenditure (%)`}{
#'         Percent of defense expenditure spent on equipment. Includes major
#'         equipment expenditure and R&D devoted to major equipment.
#'     }
#'     \item{`Personnel expenditure (%)`}{
#'         Percentage of defense expenditure spent on personnel. Includes both
#'         military and civilian expenditure and pensions.
#'     }
#'     \item{`Infrastructure expenditure (%)`}{
#'         Percentage of defense expenditure spent on infrastructure. Includes
#'         NATO common infrastructure and national military construction.
#'     }
#'     \item{`Other expenditure (%)`}{
#'         Percentage of defense expenditure spent on other categories besides
#'         equipment, personnel, and infrastructure. Includes operations and
#'         maintenance expenditure, other R&D expenditure, and other expenditure
#'         not otherwise captured.
#'     }
#' }
#'
#' @examples
#' as_country_name(nato$country_stanag, from = 'stanag')
"nato"
