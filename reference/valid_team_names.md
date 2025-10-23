# Output Valid NFL Team Abbreviations

Output Valid NFL Team Abbreviations

## Usage

``` r
valid_team_names(exclude_duplicates = TRUE)
```

## Arguments

- exclude_duplicates:

  If `TRUE` (the default) the list of valid team abbreviations will
  exclude duplicates related to franchises that have been moved

## Value

A vector of type `"character"`.

## Examples

``` r
# List valid team abbreviations excluding duplicates
valid_team_names()
#>  [1] "AFC" "ARI" "ATL" "BAL" "BUF" "CAR" "CHI" "CIN" "CLE" "DAL" "DEN" "DET"
#> [13] "GB"  "HOU" "IND" "JAX" "KC"  "LA"  "LAC" "LV"  "MIA" "MIN" "NE"  "NFC"
#> [25] "NFL" "NO"  "NYG" "NYJ" "PHI" "PIT" "SEA" "SF"  "TB"  "TEN" "WAS"

# List valid team abbreviations excluding duplicates
valid_team_names(exclude_duplicates = FALSE)
#>  [1] "AFC" "ARI" "ATL" "BAL" "BUF" "CAR" "CHI" "CIN" "CLE" "DAL" "DEN" "DET"
#> [13] "GB"  "HOU" "IND" "JAX" "KC"  "LA"  "LAC" "LAR" "LV"  "MIA" "MIN" "NE" 
#> [25] "NFC" "NFL" "NO"  "NYG" "NYJ" "OAK" "PHI" "PIT" "SD"  "SEA" "SF"  "STL"
#> [37] "TB"  "TEN" "WAS"
```
