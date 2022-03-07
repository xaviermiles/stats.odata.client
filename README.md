<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/xaviermiles/statsnz.odata.client/workflows/R-CMD-check/badge.svg)](https://github.com/xaviermiles/statsnz.odata.client/actions)
<!-- badges: end -->

# statsnz.odata.client

The aim of the statsnz.odata.client pacakge is to provide some helpful functions to retrieve data from the Stats NZ OData API.

Install by:
```
remote::install_github("xaviermiles/statsnz.odata.client")
```
Some examples of use:
```
library(statsnz.odata.client)
set_secrets("subscription_key" = "<your key goes here>")

df_to_browse_data <- get_catalogue()

covid_indicators_metadata <- basic_get("Covid-19Indicators", "Resources")
nzac_data <- basic_get(
  "Covid-19Indicators", "Observations",
  query = paste0(
    "$filter=ResourceID eq 'CPACT12' and Label1 eq 'New Zealand Activity Index (NZAC)'",
    "&$orderby=Period"
  )
)

employ_metadata <- basic_get("EmploymentIndicators", "Resources")
employ_row_counts <- basic_get(
  "EmploymentIndicators", "Observations",
  query = "$apply=groupby((ResourceID),aggregate($count as count))"
)
```

This package also powers a simple shiny app that shows what datasets are in the API and (TODO->) allows for some basic filtering etc.

## Code of Conduct

Please note that the statsnz.odata.client project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
