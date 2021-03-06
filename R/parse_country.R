parse_by_regex <- function(location, to, language) {
    countries <- countries[is.na(countries$alt) & !is.na(countries[[language]]),
                           c(language, to)]

    x_mat <- do.call(rbind, lapply(countries[[language]], grepl, location,
                                   ignore.case = TRUE, perl = TRUE))
    if (sum(x_mat) == 0) {
        rep(NA_character_, length(location))
    } else {
        vapply(
            apply(x_mat, 2, which),
            function(i) {
                country <- countries[i, ][[to]]
                ifelse(length(country) == 0, NA_character_, country)
            },
            character(1)
        )
    }
}

fromJSON <- function(...) {
    # R CMD check doesn't like jsonlite in Imports, so load dynamically
    if (!requireNamespace("jsonlite", quietly = TRUE)) {
        stop('Package "jsonlite" is required to make API calls.
             Please run: install.packages("jsonlite")')
    }
    # for testthat::with_mock
    jsonlite::fromJSON(...)
}

parse_by_geocoding <- function(location, source = c("google")) {
    query <- vapply(location, utils::URLencode, character(1), reserved = TRUE)
    source <- match.arg(source)

    base_url <- c("google" = "https://maps.googleapis.com")[source]
    urls <- paste0(base_url, "/maps/api/geocode/json?&address=", query)
    vapply(
        urls,
        function(url) {
            response <- fromJSON(url)
            if (response$status != "OK") {
                message <- c("google" = "Google Maps geocoding API call failed; status = %s. Free usage tier is limited to 2500 queries per day.")[source]
                stop(sprintf(message, response$status))
            }
            components <- response$results$address_components[[1]]
            if (source == "google") {    # 50 query/s limit
                Sys.sleep(0.02)
            }
            components$short_name[vapply(components$types,
                                         function(t) { "country" %in% t },
                                         logical(1))][1]
        },
        character(1),
        USE.NAMES = FALSE
    )
}


#' Parse country names to standardized form
#'
#' `parse_country` parses irregular country names to the ISO 3166-1 Alpha-2 code
#' or other standardized code or name format.
#'
#' `parse_country` tries to parse a character or factor vector of country names
#' to a standardized form: by default, ISO 3166-1 Alpha-2 codes.
#'
#' When `how = "regex"` (default), `parse_country` uses regular expressions to
#' match irregular forms.
#'
#' If regular expressions are insufficient, `how = "google"` will use the
#' Google Maps geocoding API instead, which permits a much broader range of
#' input formats and languages. The API allows 2500 calls per day, and should
#' thus be called judiciously. `parse_country` will make one call per unique
#' input. For more calls, see options that allow passing an API key like
#' `ggmap::geocode()` with `output = "all"` or `googleway::google_geocode()`.
#'
#' Note that due to their flexibility, the APIs may fail unpredictably, e.g.
#' `parse_country("foo", how = "google")` returns `"CH"` whereas `how = "regex"`
#' fails with a graceful `NA` and warning.
#'
#'
#' @inheritParams as_country_name
#' @param x A character or factor vector of country names to standardize
#' @param to Format to which to convert. Defaults to `"iso2c"`; see [`codes`]
#'     for more options.
#' @param  how How to parse; defaults to `"regex"`. `"google"`` uses the Google
#'     Maps geocoding API. See "Details" for more information.
#' @param language If `how = "regex"`, the language from which to parse country
#'     names. Currently accepts `"en"` (default) and `"de"`. Ignored if
#'     `how = "google"`.
#'
#' @return A character vector or factor of ISO 2-character country codes or
#' other specified codes or names. Warns of any parsing failure.
#'
#' @examples
#' parse_country(c("United States", "USA", "U.S.", "us", "United States of America"))
#'
#' \dontrun{
#' # Unicode support for parsing accented or non-Latin scripts
#' parse_country(c("\u65e5\u672c", "Japon", "\u0698\u0627\u067e\u0646"), how = "google")
#' #> [1] "JP" "JP" "JP" "JP"
#'
#' # Parse distinct place names via geocoding APIs
#' parse_country(c("1600 Pennsylvania Ave, DC", "Eiffel Tower"), how = "google")
#' #> [1] "US" "FR"
#' }
#'
#' @export
parse_country <- function(x,
                          to = "iso2c",
                          how = c("regex", "google"),
                          language = c("en", "de"),
                          factor = is.factor(x)) {
    # parameter checking
    to <- gsub("-|\\.", "_", to)
    how <- match.arg(how)
    if (!to %in% countries_colnames) {
        stop(paste(to, "not in available code formats."))
    }
    language <- paste0(match.arg(language), "_regex")

    if (!is.factor(x)) {
        x <- factor(x)
    }

    x_levels <- levels(x)

    if (how == "regex") {
        new_levels <- parse_by_regex(x_levels, to, language)
    } else {
        new_levels <- parse_by_geocoding(x_levels, how)
        if (to != "iso2c") {
            new_levels <- as_country_code(new_levels, from = "iso2c", to = to)
        }
    }

    levels(x) <- new_levels

    new_na <- is.na(new_levels) & !is.na(x_levels)
    if (any(new_na)) {
        warning(paste("NAs created:", toString(x_levels[new_na])))
    }

    if (factor) {
        return(droplevels(x))
    }
    as.character(x)
}
