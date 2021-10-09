#' Fetch github traffic info from github
#'
#' This provides a list of tables containing all the info github makes
#' available regarding traffic to a repo. It is limited to the last 14 days. To
#' store the data and update it, use `update_github_traffic_db()`, to automate it
#' (so your DB is updated daily for instance) use `schedule_github_traffic_db_updates()`
#' (Windows only). Then retrieve local DB with `github_traffic_db()`.
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
#' This is only for windows for now. Allows you to setup automatic updates
#' at the chosen frequency into the DB defined in the `"R_GITHUB_TRAFFIC_DB_PATH"`,
#' or `"~/.github_traffic_db.RDS"` if it's undefined.
#' @inheritParams fetch_github_traffic
#' @param schedule When to schedule the update. Either one of 'ONCE', 'MONTHLY', 'WEEKLY', 'DAILY', 'HOURLY', 'MINUTE', 'ONLOGON', 'ONIDLE'
#' @param taskname Name of the task.Should not contain any spaces.
#' @param ... additional parameers forwarded to `taskscheduleR::taskscheduler_create()`
#' @return Returns `NULL` silently, called for side effects.
#' @export
schedule_github_traffic_db_updates <- function(repos, schedule = "DAILY", taskname = "Update-Github-Traffic-DB", ...) {
  # remove task if already exists
  cmd <- sprintf("schtasks /Delete /TN %s /F", shQuote(taskname, type = "cmd"))
  system(cmd, intern = FALSE, show.output.on.console = FALSE)

  msg <- taskscheduleR::taskscheduler_create(
    taskname = taskname,
    rscript = system.file("update_github_traffic_db.R", package = "github.traffic"),
    schedule = schedule,
    rscript_args = repos,
    ...)
  capture.output(msg <- suppressMessages(suppressWarnings(rvest::repair_encoding(msg))))
  message(msg)
}
