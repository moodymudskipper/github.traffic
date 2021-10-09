
<!-- README.md is generated from README.Rmd. Please edit that file -->

# github.traffic

{github.traffic} lets you retrieve github traffic information + some
related info such as stars and watchers.

github only provides data for the last 14 days but this package helps
you build and update a local database wih this info. You can also
schedule he update to run at a chosen frequency (Windows only at the
moment)

## Installation

Install with:

``` r
remotes::install_github("moodymudskipper/github.traffic")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(github.traffic)
```

Fetch last 14 days of data for a given repo (or a vecor of repos) :

``` r
fetch_github_traffic("moodymudskipper/flow")
#> $clones_per_day
#> # A tibble: 4 x 6
#>   owner           repo  fetch_time          timestamp  count uniques
#>   <chr>           <chr> <dttm>              <date>     <int>   <int>
#> 1 moodymudskipper flow  2021-10-09 17:30:53 2021-10-04     2       2
#> 2 moodymudskipper flow  2021-10-09 17:30:53 2021-10-05    14      10
#> 3 moodymudskipper flow  2021-10-09 17:30:53 2021-10-06     4       3
#> 4 moodymudskipper flow  2021-10-09 17:30:53 2021-10-07     3       3
#> 
#> $clones_per_week
#> # A tibble: 1 x 6
#>   owner           repo  fetch_time          timestamp  count uniques
#>   <chr>           <chr> <dttm>              <date>     <int>   <int>
#> 1 moodymudskipper flow  2021-10-09 17:30:53 2021-10-04    23      15
#> 
#> $clones_per_14days
#> # A tibble: 1 x 5
#>   owner           repo  fetch_time          count uniques
#>   <chr>           <chr> <dttm>              <int>   <int>
#> 1 moodymudskipper flow  2021-10-09 17:30:53    23      15
#> 
#> $page_views_per_day
#> # A tibble: 14 x 6
#>    owner           repo  fetch_time          timestamp  count uniques
#>    <chr>           <chr> <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper flow  2021-10-09 17:30:53 2021-09-26    10       6
#>  2 moodymudskipper flow  2021-10-09 17:30:53 2021-09-27    13       4
#>  3 moodymudskipper flow  2021-10-09 17:30:53 2021-09-28    36       7
#>  4 moodymudskipper flow  2021-10-09 17:30:53 2021-09-29     6       6
#>  5 moodymudskipper flow  2021-10-09 17:30:53 2021-09-30     7       5
#>  6 moodymudskipper flow  2021-10-09 17:30:53 2021-10-01    14       1
#>  7 moodymudskipper flow  2021-10-09 17:30:53 2021-10-02    22       3
#>  8 moodymudskipper flow  2021-10-09 17:30:53 2021-10-03     3       2
#>  9 moodymudskipper flow  2021-10-09 17:30:53 2021-10-04    17      12
#> 10 moodymudskipper flow  2021-10-09 17:30:53 2021-10-05    62       6
#> 11 moodymudskipper flow  2021-10-09 17:30:53 2021-10-06    10       6
#> 12 moodymudskipper flow  2021-10-09 17:30:53 2021-10-07    89      13
#> 13 moodymudskipper flow  2021-10-09 17:30:53 2021-10-08    17       8
#> 14 moodymudskipper flow  2021-10-09 17:30:53 2021-10-09     1       1
#> 
#> $page_views_per_week
#> # A tibble: 3 x 6
#>   owner           repo  fetch_time          timestamp  count uniques
#>   <chr>           <chr> <dttm>              <date>     <int>   <int>
#> 1 moodymudskipper flow  2021-10-09 17:30:53 2021-09-20    10       6
#> 2 moodymudskipper flow  2021-10-09 17:30:53 2021-09-27   101      24
#> 3 moodymudskipper flow  2021-10-09 17:30:53 2021-10-04   196      43
#> 
#> $page_views_per_14days
#> # A tibble: 1 x 5
#>   owner           repo  fetch_time          count uniques
#>   <chr>           <chr> <dttm>              <int>   <int>
#> 1 moodymudskipper flow  2021-10-09 17:30:53    23      15
#> 
#> $popular_paths
#> # A tibble: 10 x 7
#>    owner           repo  fetch_time          path        title     count uniques
#>    <chr>           <chr> <dttm>              <chr>       <chr>     <int>   <int>
#>  1 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ moodymud~   113      61
#>  2 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ Issues ·~    36       4
#>  3 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ Focus on~    29       6
#>  4 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ Pull req~    11       1
#>  5 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ Fix cond~     7       2
#>  6 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ flow_vie~     6       2
#>  7 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ Traffic ~     5       1
#>  8 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ Forks · ~     5       1
#>  9 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ fix typo~     5       1
#> 10 moodymudskipper flow  2021-10-09 17:30:53 /moodymuds~ Fix cond~     5       1
#> 
#> $popular_referrers
#> # A tibble: 9 x 6
#>   owner           repo  fetch_time          referrer               count uniques
#>   <chr>           <chr> <dttm>              <chr>                  <int>   <int>
#> 1 moodymudskipper flow  2021-10-09 17:30:53 github.com                33      17
#> 2 moodymudskipper flow  2021-10-09 17:30:53 Google                    23      19
#> 3 moodymudskipper flow  2021-10-09 17:30:53 t.co                      17      17
#> 4 moodymudskipper flow  2021-10-09 17:30:53 towardsdatascience.com     5       4
#> 5 moodymudskipper flow  2021-10-09 17:30:53 away.vk.com                3       1
#> 6 moodymudskipper flow  2021-10-09 17:30:53 mail.yahoo.com             2       2
#> 7 moodymudskipper flow  2021-10-09 17:30:53 amp.reddit.com             1       1
#> 8 moodymudskipper flow  2021-10-09 17:30:53 getpocket.com              1       1
#> 9 moodymudskipper flow  2021-10-09 17:30:53 DuckDuckGo                 1       1
#> 
#> $repo_info
#> # A tibble: 1 x 13
#>   owner   repo  fetch_time          name  created_at updated_at pushed_at   size
#>   <chr>   <chr> <dttm>              <chr> <date>     <date>     <date>     <int>
#> 1 moodym~ flow  2021-10-09 17:30:53 flow  2019-10-15 2021-10-08 2021-10-07 30809
#> # ... with 5 more variables: stargazers_count <int>, forks_count <int>,
#> #   open_issues_count <int>, subscribers_count <int>, network_count <int>
```

Or all repos from a given owner (excluding forks and private repos),
this might take a bit of time if you have many repos. You can also
provide a character vector containing a mix of repos and owners.

``` r
fetch_github_traffic("moodymudskipper")
#> $clones_per_day
#> # A tibble: 79 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:31:03 NA            NA      NA
#>  2 moodymudskipper bigbrothr         2021-10-09 17:31:09 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:31:13 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:31:16 2021-10-03     1       1
#>  5 moodymudskipper boomer            2021-10-09 17:31:19 2021-09-30     1       1
#>  6 moodymudskipper boomer            2021-10-09 17:31:19 2021-10-07     1       1
#>  7 moodymudskipper burglr            2021-10-09 17:31:23 2021-09-25     1       1
#>  8 moodymudskipper burglr            2021-10-09 17:31:23 2021-09-30     1       1
#>  9 moodymudskipper check             2021-10-09 17:31:27 NA            NA      NA
#> 10 moodymudskipper cutr              2021-10-09 17:31:33 2021-10-02     1       1
#> # ... with 69 more rows
#> 
#> $clones_per_week
#> # A tibble: 61 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:31:03 NA            NA      NA
#>  2 moodymudskipper bigbrothr         2021-10-09 17:31:09 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:31:13 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:31:16 2021-09-27     1       1
#>  5 moodymudskipper boomer            2021-10-09 17:31:19 2021-09-27     1       1
#>  6 moodymudskipper boomer            2021-10-09 17:31:19 2021-10-04     1       1
#>  7 moodymudskipper burglr            2021-10-09 17:31:23 2021-09-20     1       1
#>  8 moodymudskipper burglr            2021-10-09 17:31:23 2021-09-27     1       1
#>  9 moodymudskipper check             2021-10-09 17:31:27 NA            NA      NA
#> 10 moodymudskipper cutr              2021-10-09 17:31:33 2021-09-27     1       1
#> # ... with 51 more rows
#> 
#> $clones_per_14days
#> # A tibble: 53 x 5
#>    owner           repo              fetch_time          count uniques
#>    <chr>           <chr>             <dttm>              <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:31:03     0       0
#>  2 moodymudskipper bigbrothr         2021-10-09 17:31:09     0       0
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:31:13     0       0
#>  4 moodymudskipper boom              2021-10-09 17:31:16     1       1
#>  5 moodymudskipper boomer            2021-10-09 17:31:19     2       2
#>  6 moodymudskipper burglr            2021-10-09 17:31:23     2       2
#>  7 moodymudskipper check             2021-10-09 17:31:27     0       0
#>  8 moodymudskipper cutr              2021-10-09 17:31:33     1       1
#>  9 moodymudskipper datasearch        2021-10-09 17:31:35     0       0
#> 10 moodymudskipper debugonce         2021-10-09 17:31:39     1       1
#> # ... with 43 more rows
#> 
#> $page_views_per_day
#> # A tibble: 161 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:31:03 2021-10-02     1       1
#>  2 moodymudskipper bigbrothr         2021-10-09 17:31:09 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:31:13 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:31:16 2021-09-28     4       3
#>  5 moodymudskipper boom              2021-10-09 17:31:16 2021-09-30     1       1
#>  6 moodymudskipper boom              2021-10-09 17:31:16 2021-10-06     2       2
#>  7 moodymudskipper boom              2021-10-09 17:31:16 2021-10-08     1       1
#>  8 moodymudskipper boom              2021-10-09 17:31:16 2021-10-09     7       2
#>  9 moodymudskipper boomer            2021-10-09 17:31:19 2021-09-25     1       1
#> 10 moodymudskipper boomer            2021-10-09 17:31:19 2021-09-26     1       1
#> # ... with 151 more rows
#> 
#> $page_views_per_week
#> # A tibble: 83 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:31:03 2021-09-27     1       1
#>  2 moodymudskipper bigbrothr         2021-10-09 17:31:09 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:31:13 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:31:16 2021-09-27     5       4
#>  5 moodymudskipper boom              2021-10-09 17:31:16 2021-10-04    10       5
#>  6 moodymudskipper boomer            2021-10-09 17:31:19 2021-09-20     2       2
#>  7 moodymudskipper boomer            2021-10-09 17:31:19 2021-09-27    27       9
#>  8 moodymudskipper boomer            2021-10-09 17:31:19 2021-10-04    17      10
#>  9 moodymudskipper burglr            2021-10-09 17:31:23 2021-09-27     4       2
#> 10 moodymudskipper burglr            2021-10-09 17:31:23 2021-10-04     1       1
#> # ... with 73 more rows
#> 
#> $page_views_per_14days
#> # A tibble: 36 x 5
#>    owner           repo         fetch_time          count uniques
#>    <chr>           <chr>        <dttm>              <int>   <int>
#>  1 moodymudskipper boom         2021-10-09 17:31:16     1       1
#>  2 moodymudskipper boomer       2021-10-09 17:31:19     1       1
#>  3 moodymudskipper boomer       2021-10-09 17:31:19     1       1
#>  4 moodymudskipper burglr       2021-10-09 17:31:23     1       1
#>  5 moodymudskipper burglr       2021-10-09 17:31:23     1       1
#>  6 moodymudskipper cutr         2021-10-09 17:31:33     1       1
#>  7 moodymudskipper debugonce    2021-10-09 17:31:39     1       1
#>  8 moodymudskipper dotdot       2021-10-09 17:31:42     1       1
#>  9 moodymudskipper dubioustests 2021-10-09 17:31:52     1       1
#> 10 moodymudskipper easydb       2021-10-09 17:31:56     1       1
#> # ... with 26 more rows
#> 
#> $popular_paths
#> # A tibble: 119 x 7
#>    owner           repo             fetch_time          path  title count uniques
#>    <chr>           <chr>            <dttm>              <chr> <chr> <int>   <int>
#>  1 moodymudskipper adventofcode2020 2021-10-09 17:31:03 /moo~ mood~     1       1
#>  2 moodymudskipper boom             2021-10-09 17:31:16 /moo~ mood~     8       7
#>  3 moodymudskipper boomer           2021-10-09 17:31:19 /moo~ mood~    32      19
#>  4 moodymudskipper boomer           2021-10-09 17:31:19 /moo~ Issu~     6       2
#>  5 moodymudskipper boomer           2021-10-09 17:31:19 /moo~ Traf~     2       1
#>  6 moodymudskipper boomer           2021-10-09 17:31:19 /moo~ Rele~     2       1
#>  7 moodymudskipper boomer           2021-10-09 17:31:19 /moo~ Debu~     1       1
#>  8 moodymudskipper boomer           2021-10-09 17:31:19 /moo~ use ~     1       1
#>  9 moodymudskipper boomer           2021-10-09 17:31:19 /moo~ Puls~     1       1
#> 10 moodymudskipper burglr           2021-10-09 17:31:23 /moo~ mood~     3       3
#> # ... with 109 more rows
#> 
#> $popular_referrers
#> # A tibble: 70 x 6
#>    owner           repo             fetch_time          referrer   count uniques
#>    <chr>           <chr>            <dttm>              <chr>      <int>   <int>
#>  1 moodymudskipper adventofcode2020 2021-10-09 17:31:03 github.com     1       1
#>  2 moodymudskipper boom             2021-10-09 17:31:16 github.com     3       3
#>  3 moodymudskipper boom             2021-10-09 17:31:16 community~     2       2
#>  4 moodymudskipper boom             2021-10-09 17:31:16 Google         1       1
#>  5 moodymudskipper boomer           2021-10-09 17:31:19 github.com    10       5
#>  6 moodymudskipper boomer           2021-10-09 17:31:19 roamresea~     4       1
#>  7 moodymudskipper boomer           2021-10-09 17:31:19 Google         3       3
#>  8 moodymudskipper boomer           2021-10-09 17:31:19 cran.r-pr~     2       2
#>  9 moodymudskipper boomer           2021-10-09 17:31:19 reddit.com     1       1
#> 10 moodymudskipper burglr           2021-10-09 17:31:23 jimbrig.g~     1       1
#> # ... with 60 more rows
#> 
#> $repo_info
#> # A tibble: 53 x 13
#>    owner  repo  fetch_time          name  created_at updated_at pushed_at   size
#>    <chr>  <chr> <dttm>              <chr> <date>     <date>     <date>     <int>
#>  1 moody~ adve~ 2021-10-09 17:31:03 adve~ 2020-12-10 2020-12-21 2020-12-21   122
#>  2 moody~ bigb~ 2021-10-09 17:31:09 bigb~ 2020-11-25 2020-12-07 2020-11-25    81
#>  3 moody~ bigb~ 2021-10-09 17:31:13 bigb~ 2020-11-25 2020-11-25 2020-11-25     2
#>  4 moody~ boom  2021-10-09 17:31:16 boom  2021-02-02 2021-09-28 2021-02-05    33
#>  5 moody~ boom~ 2021-10-09 17:31:19 boom~ 2021-02-05 2021-09-28 2021-09-05   780
#>  6 moody~ burg~ 2021-10-09 17:31:23 burg~ 2021-04-29 2021-09-28 2021-05-01    41
#>  7 moody~ check 2021-10-09 17:31:27 check 2020-09-29 2020-10-14 2020-09-29     7
#>  8 moody~ cutr  2021-10-09 17:31:33 cutr  2018-09-16 2021-02-18 2019-08-22    72
#>  9 moody~ data~ 2021-10-09 17:31:35 data~ 2020-11-05 2021-04-12 2020-11-05  4549
#> 10 moody~ debu~ 2021-10-09 17:31:39 debu~ 2019-09-16 2019-09-17 2019-09-17     3
#> # ... with 43 more rows, and 5 more variables: stargazers_count <int>,
#> #   forks_count <int>, open_issues_count <int>, subscribers_count <int>,
#> #   network_count <int>
```

Create or update a local DB manually with this info

``` r
update_github_traffic_db("moodymudskipper") 
```

Or automate this process so it’s updated at the chosen frequency (daily
by default)

``` r
schedule_github_traffic_db_updates("moodymudskipper")
#> Opération réussie : la tâche planifiée "Update-Github-Traffic-DB" a été créée.
```

Then retrieve your data by running:

``` r
github_traffic_db()
#> $clones_per_day
#> # A tibble: 346 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:34:08 NA            NA      NA
#>  2 moodymudskipper bigbrothr         2021-10-09 17:34:11 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:34:15 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:34:18 2021-10-03     1       1
#>  5 moodymudskipper boomer            2021-10-09 17:34:21 2021-09-30     1       1
#>  6 moodymudskipper boomer            2021-10-09 17:34:21 2021-10-07     1       1
#>  7 moodymudskipper burglr            2021-10-09 17:34:24 2021-09-25     1       1
#>  8 moodymudskipper burglr            2021-10-09 17:34:24 2021-09-30     1       1
#>  9 moodymudskipper check             2021-10-09 17:34:28 NA            NA      NA
#> 10 moodymudskipper cutr              2021-10-09 17:34:32 2021-10-02     1       1
#> # ... with 336 more rows
#> 
#> $clones_per_week
#> # A tibble: 275 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:34:08 NA            NA      NA
#>  2 moodymudskipper bigbrothr         2021-10-09 17:34:11 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:34:15 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:34:18 2021-09-27     1       1
#>  5 moodymudskipper boomer            2021-10-09 17:34:21 2021-09-27     1       1
#>  6 moodymudskipper boomer            2021-10-09 17:34:21 2021-10-04     1       1
#>  7 moodymudskipper burglr            2021-10-09 17:34:24 2021-09-20     1       1
#>  8 moodymudskipper burglr            2021-10-09 17:34:24 2021-09-27     1       1
#>  9 moodymudskipper check             2021-10-09 17:34:28 NA            NA      NA
#> 10 moodymudskipper cutr              2021-10-09 17:34:32 2021-09-27     1       1
#> # ... with 265 more rows
#> 
#> $clones_per_14days
#> # A tibble: 238 x 5
#>    owner           repo              fetch_time          count uniques
#>    <chr>           <chr>             <dttm>              <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:34:08     0       0
#>  2 moodymudskipper bigbrothr         2021-10-09 17:34:11     0       0
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:34:15     0       0
#>  4 moodymudskipper boom              2021-10-09 17:34:18     1       1
#>  5 moodymudskipper boomer            2021-10-09 17:34:21     2       2
#>  6 moodymudskipper burglr            2021-10-09 17:34:24     2       2
#>  7 moodymudskipper check             2021-10-09 17:34:28     0       0
#>  8 moodymudskipper cutr              2021-10-09 17:34:32     1       1
#>  9 moodymudskipper datasearch        2021-10-09 17:34:37     0       0
#> 10 moodymudskipper debugonce         2021-10-09 17:34:44     1       1
#> # ... with 228 more rows
#> 
#> $page_views_per_day
#> # A tibble: 709 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:34:08 2021-10-02     1       1
#>  2 moodymudskipper bigbrothr         2021-10-09 17:34:11 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:34:15 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:34:18 2021-09-28     4       3
#>  5 moodymudskipper boom              2021-10-09 17:34:18 2021-09-30     1       1
#>  6 moodymudskipper boom              2021-10-09 17:34:18 2021-10-06     2       2
#>  7 moodymudskipper boom              2021-10-09 17:34:18 2021-10-08     1       1
#>  8 moodymudskipper boom              2021-10-09 17:34:18 2021-10-09     7       2
#>  9 moodymudskipper boomer            2021-10-09 17:34:21 2021-09-25     1       1
#> 10 moodymudskipper boomer            2021-10-09 17:34:21 2021-09-26     1       1
#> # ... with 699 more rows
#> 
#> $page_views_per_week
#> # A tibble: 369 x 6
#>    owner           repo              fetch_time          timestamp  count uniques
#>    <chr>           <chr>             <dttm>              <date>     <int>   <int>
#>  1 moodymudskipper adventofcode2020  2021-10-09 17:34:08 2021-09-27     1       1
#>  2 moodymudskipper bigbrothr         2021-10-09 17:34:11 NA            NA      NA
#>  3 moodymudskipper bigbrothr.example 2021-10-09 17:34:15 NA            NA      NA
#>  4 moodymudskipper boom              2021-10-09 17:34:18 2021-09-27     5       4
#>  5 moodymudskipper boom              2021-10-09 17:34:18 2021-10-04    10       5
#>  6 moodymudskipper boomer            2021-10-09 17:34:21 2021-09-20     2       2
#>  7 moodymudskipper boomer            2021-10-09 17:34:21 2021-09-27    27       9
#>  8 moodymudskipper boomer            2021-10-09 17:34:21 2021-10-04    17      10
#>  9 moodymudskipper burglr            2021-10-09 17:34:24 2021-09-27     4       2
#> 10 moodymudskipper burglr            2021-10-09 17:34:24 2021-10-04     1       1
#> # ... with 359 more rows
#> 
#> $page_views_per_14days
#> # A tibble: 160 x 5
#>    owner           repo         fetch_time          count uniques
#>    <chr>           <chr>        <dttm>              <int>   <int>
#>  1 moodymudskipper boom         2021-10-09 17:34:18     1       1
#>  2 moodymudskipper boomer       2021-10-09 17:34:21     1       1
#>  3 moodymudskipper boomer       2021-10-09 17:34:21     1       1
#>  4 moodymudskipper burglr       2021-10-09 17:34:24     1       1
#>  5 moodymudskipper burglr       2021-10-09 17:34:24     1       1
#>  6 moodymudskipper cutr         2021-10-09 17:34:32     1       1
#>  7 moodymudskipper debugonce    2021-10-09 17:34:44     1       1
#>  8 moodymudskipper dotdot       2021-10-09 17:34:50     1       1
#>  9 moodymudskipper dubioustests 2021-10-09 17:35:03     1       1
#> 10 moodymudskipper easydb       2021-10-09 17:35:09     1       1
#> # ... with 150 more rows
#> 
#> $popular_paths
#> # A tibble: 509 x 7
#>    owner           repo             fetch_time          path  title count uniques
#>    <chr>           <chr>            <dttm>              <chr> <chr> <int>   <int>
#>  1 moodymudskipper adventofcode2020 2021-10-09 17:34:08 /moo~ mood~     1       1
#>  2 moodymudskipper boom             2021-10-09 17:34:18 /moo~ mood~     8       7
#>  3 moodymudskipper boomer           2021-10-09 17:34:21 /moo~ mood~    32      19
#>  4 moodymudskipper boomer           2021-10-09 17:34:21 /moo~ Issu~     6       2
#>  5 moodymudskipper boomer           2021-10-09 17:34:21 /moo~ Traf~     2       1
#>  6 moodymudskipper boomer           2021-10-09 17:34:21 /moo~ Rele~     2       1
#>  7 moodymudskipper boomer           2021-10-09 17:34:21 /moo~ Debu~     1       1
#>  8 moodymudskipper boomer           2021-10-09 17:34:21 /moo~ use ~     1       1
#>  9 moodymudskipper boomer           2021-10-09 17:34:21 /moo~ Puls~     1       1
#> 10 moodymudskipper burglr           2021-10-09 17:34:24 /moo~ mood~     3       3
#> # ... with 499 more rows
#> 
#> $popular_referrers
#> # A tibble: 305 x 6
#>    owner           repo             fetch_time          referrer   count uniques
#>    <chr>           <chr>            <dttm>              <chr>      <int>   <int>
#>  1 moodymudskipper adventofcode2020 2021-10-09 17:34:08 github.com     1       1
#>  2 moodymudskipper boom             2021-10-09 17:34:18 github.com     3       3
#>  3 moodymudskipper boom             2021-10-09 17:34:18 community~     2       2
#>  4 moodymudskipper boom             2021-10-09 17:34:18 Google         1       1
#>  5 moodymudskipper boomer           2021-10-09 17:34:21 github.com    10       5
#>  6 moodymudskipper boomer           2021-10-09 17:34:21 roamresea~     4       1
#>  7 moodymudskipper boomer           2021-10-09 17:34:21 Google         3       3
#>  8 moodymudskipper boomer           2021-10-09 17:34:21 cran.r-pr~     2       2
#>  9 moodymudskipper boomer           2021-10-09 17:34:21 reddit.com     1       1
#> 10 moodymudskipper burglr           2021-10-09 17:34:24 jimbrig.g~     1       1
#> # ... with 295 more rows
#> 
#> $repo_info
#> # A tibble: 238 x 13
#>    owner  repo  fetch_time          name  created_at updated_at pushed_at   size
#>    <chr>  <chr> <dttm>              <chr> <date>     <date>     <date>     <int>
#>  1 moody~ adve~ 2021-10-09 17:34:08 adve~ 2020-12-10 2020-12-21 2020-12-21   122
#>  2 moody~ bigb~ 2021-10-09 17:34:11 bigb~ 2020-11-25 2020-12-07 2020-11-25    81
#>  3 moody~ bigb~ 2021-10-09 17:34:15 bigb~ 2020-11-25 2020-11-25 2020-11-25     2
#>  4 moody~ boom  2021-10-09 17:34:18 boom  2021-02-02 2021-09-28 2021-02-05    33
#>  5 moody~ boom~ 2021-10-09 17:34:21 boom~ 2021-02-05 2021-09-28 2021-09-05   780
#>  6 moody~ burg~ 2021-10-09 17:34:24 burg~ 2021-04-29 2021-09-28 2021-05-01    41
#>  7 moody~ check 2021-10-09 17:34:28 check 2020-09-29 2020-10-14 2020-09-29     7
#>  8 moody~ cutr  2021-10-09 17:34:32 cutr  2018-09-16 2021-02-18 2019-08-22    72
#>  9 moody~ data~ 2021-10-09 17:34:37 data~ 2020-11-05 2021-04-12 2020-11-05  4549
#> 10 moody~ debu~ 2021-10-09 17:34:44 debu~ 2019-09-16 2019-09-17 2019-09-17     3
#> # ... with 228 more rows, and 5 more variables: stargazers_count <int>,
#> #   forks_count <int>, open_issues_count <int>, subscribers_count <int>,
#> #   network_count <int>
```
