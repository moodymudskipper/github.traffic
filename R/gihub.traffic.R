#' Fetch github traffic info from github
#'
#' This provides a list of tables containing all the info github makes
#' available regarding traffic to a repo. It is limited to the last 14 days. To
#' store the data and update it, use `update_github_traffic_db()`, to automate it
#' (so your DB is updated daily for instance) use `schedule_github_traffic_db_updates()`.
#' Then retrieve local DB with `github_traffic_db()`.
#'
#'
#' The output contains tibbles named :
#'
#' * clones_per_day
#' * clones_per_week,
#' * clones_per_14days
#' * page_views_per_day
#' * page_views_per_week,
#' * page_views_per_14days
#' * popular_paths
#' * popular_referrers
#' * repo_info.
#'
#' Weeks start on monday.
#'
#' @param repos A characer vector of repos in he "owner/repo" or "owner" format,
#'   in the latter case the info of all repos is fetched.
#'
#' @return A list of ables
#' @export
fetch_github_traffic <- function(repos) {

  repo_lgl <- grepl("/", repos)
  repos <- c(repos[repo_lgl], unlist(map(repos[!repo_lgl], get_all_repos)))

  pb <- progress::progress_bar$new(total = 7 * length(repos))
  strsplit(repos, "/") %>%
    transpose() %>%
    pmap(fetch_github_traffic_impl, pb) %>%
    transpose() %>%
    map(bind_rows)
}

get_all_repos <- function(owner) {
  repos <- gh::gh("GET /users/{username}/repos", username = owner, per_page = 100)
  nms <- keep(repos, ~ !.$fork && !.$private) %>%
    map_chr("name")
  paste0(owner, "/", nms)
}


#' Update Github Traffic DB
#'
#' This fetches the latest info from github and adds it to your local DB.
#' You can then import your DB with : `github_traffic_db()`.
#' @inheritParams fetch_github_traffic
#' @param append whether to keep existing DB, `append = FALSE` will remove everyhing you've
#' saved so far!
#' @export
update_github_traffic_db <- function(repos, append = TRUE) {
  path <- Sys.getenv("R_GITHUB_TRAFFIC_DB_PATH")
  if (path == "") path <- "~/.github_traffic_db.RDS"

  Sys.getenv(3)
  data_new <-
    fetch_github_traffic(repos)

  if(file.exists(path) && append) {
    data_old <- readRDS(path)
    data_new <-
      list(data_new, data_old) %>%
      transpose() %>%
      map(bind_rows)
  }

  saveRDS(data_new, path)
}

#' Github Traffic DB
#'
#' Returns the database as a list of tibbles.
#'
#' The tibbles are named :
#'
#' * clones_per_day
#' * clones_per_week,
#' * clones_per_14days
#' * page_views_per_day
#' * page_views_per_week,
#' * page_views_per_14days
#' * popular_paths
#' * popular_referrers
#' * repo_info.
#'
#' @export
github_traffic_db <- function() {
  path <- Sys.getenv("R_GITHUB_TRAFFIC_DB_PATH")
  if (path == "") path <- "~/.github_traffic_db.RDS"
  readRDS(path)
}

fetch_github_traffic_impl <- function(owner, repo, pb) {

  fetch_time <- Sys.time()

  clones_per_day <-
    gh::gh("GET /repos/{owner}/{repo}/traffic/clones",
           owner = owner, repo = repo, per = "day") %>%
    pluck("clones")

  if(!is.null(clones_per_day))
    clones_per_day <-
    clones_per_day %>%
    transpose() %>%
    map_dfc(unlist) %>%
    mutate_at("timestamp", as.Date)

  pb$tick()

  clones_per_week <-
    gh::gh("GET /repos/{owner}/{repo}/traffic/clones",
           owner = owner, repo = repo, per = "week")

  clones_per_14days <-
    as_tibble(clones_per_week[c("count", "uniques")])

  clones_per_week <-
    clones_per_week %>%
    pluck("clones")

  if(!is.null(clones_per_week))
  clones_per_week <-
    clones_per_week %>%
    transpose() %>%
    map_dfc(unlist) %>%
    mutate_at("timestamp", as.Date)

  pb$tick()

  popular_paths <-
    gh::gh("GET /repos/{owner}/{repo}/traffic/popular/paths",
           owner = owner, repo = repo) %>%
    transpose() %>%
    map_dfc(unlist)

  pb$tick()

  popular_referrers <-
    gh::gh("GET /repos/{owner}/{repo}/traffic/popular/referrers",
           owner = owner, repo = repo) %>%
    transpose() %>%
    map_dfc(unlist)

  pb$tick()

  page_views_per_day <-
    gh::gh("GET /repos/{owner}/{repo}/traffic/views",
           owner = owner, repo = repo, per = "day") %>%
    pluck("views")

  if(!is.null(page_views_per_day))
  page_views_per_day <-
    page_views_per_day %>%
    transpose() %>%
    map_dfc(unlist) %>%
    mutate_at("timestamp", as.Date)

  pb$tick()

  page_views_per_week <-
    gh::gh("GET /repos/{owner}/{repo}/traffic/views",
           owner = owner, repo = repo, per = "week")

  page_views_per_14days <-
    as_tibble(clones_per_week[c("count", "uniques")])

  page_views_per_week <-
    page_views_per_week %>%
    pluck("views")

  if(!is.null(page_views_per_week))
  page_views_per_week <-
    page_views_per_week%>%
    transpose() %>%
    map_dfc(unlist) %>%
    mutate_at("timestamp", as.Date)

  pb$tick()

  repo_info <-
    gh::gh("GET /repos/{owner}/{repo}",owner = owner, repo = repo)[
      c("name", "created_at", "updated_at", "pushed_at", "size",
        "stargazers_count", "forks_count", "open_issues_count",
        "subscribers_count", "network_count")] %>%
    as_tibble() %>%
    mutate_at(c("created_at", "updated_at","pushed_at"), as.Date)

  pb$tick()

  lst(
    clones_per_day,
    clones_per_week,
    clones_per_14days,
    page_views_per_day,
    page_views_per_week,
    page_views_per_14days,
    popular_paths,
    popular_referrers,
    repo_info
  ) %>%
    map(~bind_cols(owner = owner, repo = repo, fetch_time = fetch_time, .) %>%
          filter(complete.cases(.)))
}

#' Schedule Github Traffic DB Updates
#'
#' Provides a way to setup automatic updates
#' at the chosen frequency into the DB defined in the `"R_GITHUB_TRAFFIC_DB_PATH"`,
#' or `"~/.github_traffic_db.RDS"` if it's undefined.
#' @inheritParams fetch_github_traffic
#' @param schedule When to schedule the update. Either one of
#'    'WEEKLY', 'DAILY', 'HOURLY', 'MINUTE', 'ONLOGON', 'ONIDLE'.
#'    'ONIDLE' works for Windows only.
#' @param taskname Name of the task.Should not contain any spaces.
#' @param ... additional parameers forwarded to `taskscheduleR::taskscheduler_create()`
#'   (Windows) or `cronR::cron_add()` (Other platforms)
#'
#' This is essentially a wrapper around `taskscheduleR::taskscheduler_create()`
#' and `cronR::cron_add()` that schedule tasks respectively on Windows and other
#' platforms.
#'
#' The parameters are named as in `taskscheduleR::taskscheduler_create()`
#' but `schedule` is translated and forwarded to the frequency arg of `cronR::cron_add()`
#' and `taskname` is forwarded to `id`.
#'   ``
#' @return Returns `NULL` silently, called for side effects.
#' @export
schedule_github_traffic_db_updates <- function(repos, schedule = "DAILY", taskname = "Update-Github-Traffic-DB", ...) {

  choices <- c('WEEKLY', 'DAILY', 'HOURLY', 'MINUTE', 'ONLOGON', 'ONIDLE')
  schedule = match.arg(schedule, choices)
  rscript <- system.file("update_github_traffic_db.R", package = "github.traffic")

  if(.Platform$OS.type == "windows") {
    # remove task if already exists
    cmd <- sprintf("schtasks /Delete /TN %s /F", shQuote(taskname, type = "cmd"))
    system(cmd, intern = FALSE, show.output.on.console = FALSE)

    msg <- taskscheduleR::taskscheduler_create(
      taskname = taskname,
      rscript = rscript,
      schedule = schedule,
      rscript_args = repos,
      ...)
    capture.output(msg <- suppressMessages(suppressWarnings(rvest::repair_encoding(msg))))
    message(msg)
  } else {
    if(schedule == "ONIDLE") stop("'ONIDLE' works for Windows only")
    days_of_week <- if(schedule == "WEEKLY") 1
    frequency <- switch(
      schedule,
      'WEEKLY' = 'daily',
      'DAILY' = 'daily',
      'HOURLY' = 'hourly',
      'MINUTE' = 'minutely',
      'ONLOGON' = '@reboot'
    )
    cmd <- cronR::cron_rscript(rscript, rscript_args = repos)
    cronR::cron_add(cmd, frequency = frequency, id = taskname, ask=FALSE)
  }
}

#' Plot github traffic
#'
#' If several repos or an owner is provided in the `repos` argument, `count`
#' and `uniques` will be summed, which might lead to a (probably small) overestimation
#' of `uniques`.
#'
#' @param repos A vector of repos or owners
#' @param what "clones" or "views"
#' @param freq "day" or "week"
#'
#' @export
github_traffic_plot <- function(repos, what = c("clones", "views"), freq = c("day", "week")) {
  what <- match.arg(what)
  freq <- match.arg(freq)
  db <- github_traffic_db()
  if(what == "clones") {
    if(freq == "day") {
      data <- db$clones_per_day
    } else {
      data <- db$clones_per_week
    }
  } else {
    if(freq == "day") {
      data <- db$page_views_per_day
    } else {
      data <- db$page_views_per_week
    }
  }

  data <- mutate(data, repo2 = paste0(owner, "/", repo))

  repo_lgl <- grepl("/", repos)
  if(any(repo_lgl)) {
    data1 <- filter(data, repo2 %in% repos[repo_lgl])
  } else {
    data1 <- data[0,]
  }

  if(any(!repo_lgl)) {
    data2 <- filter(data, repo %in% repos[!repo_lgl] | owner %in% repos[!repo_lgl])
  } else {
    data2 <- data[0,]
  }

  data <-
    bind_rows(data1, data2) %>%
    filter(!is.na(timestamp)) %>%
    group_by(repo2, timestamp) %>%
    # since data takes only into account 14 day some data points might have
    # incomplete weeks or days so we take the max
    summarize(count = max(count), uniques = max(uniques), .groups = "drop") %>%
    group_by(timestamp) %>%
    summarize(count = sum(count), uniques = sum(uniques), .groups = "drop") %>%
    mutate(
      count = count + max(count/200),
      uniques = uniques - max(count/200)
    )

    data %>%
      complete(timestamp = full_seq(timestamp, 1)) %>%
      mutate(count = ifelse(is.na(count), 0, count), uniques = ifelse(is.na(uniques), 0, uniques)) %>%
      pivot_longer(c(count, uniques), names_to = "metric", values_to = "n") %>%
      ggplot() +
      aes(timestamp, n, color = metric) +
      geom_line() +
      theme_minimal() +
      ggtitle(toString(repos))
}
