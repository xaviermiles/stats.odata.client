# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

## Fill the DESCRIPTION ----
## Add meta data about your application
##
## /!\ Note: if you want to change the name of your app during development,
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
##
golem::fill_desc(
  pkg_name = "statsnz.odata",
  pkg_title = "Simple app to browse Stats OData API",
  pkg_description = paste0(
    "Graphical interface to browse the datasets in the Stats Odata API and ",
    "get help with building queries."
  ),
  author_first_name = "Xavier",
  author_last_name = "Miles",
  author_email = "xaviermiles377@gmail.com",
  repo_url = "https://github.com/xaviermiles/statsnz.odata"
)

## Set {golem} options ----
golem::set_golem_options()

## Create Common Files ----
## See ?usethis for more information
usethis::use_mit_license("Xavier Miles")
# usethis::use_readme_rmd(open = FALSE)
usethis::use_code_of_conduct("xaviermiles377@gmail.com")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)

## Use git ----
usethis::use_git()

## Init Testing Infrastructure ----
## Create a template for tests
golem::use_recommended_tests()

## Use Recommended Packages ----
golem::use_recommended_deps()

## Favicon ----
# If you want to change the favicon (default is golem's one)
# golem::use_favicon()
# golem::remove_favicon()

## Add helper functions ----
# golem::use_utils_ui()
# golem::use_utils_server()

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile("dev/02_dev.R")
