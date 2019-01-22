#' @importFrom magrittr %>%
#' @export
create_topic <- function(topic_name,
                         display_name = NULL,
                         profile = "default"){

  if (missing(topic_name)){
    stop("Topic name is required")
  }

  is_valid_name(topic_name, display_name)

  topic_list <- list_topics()

  if (any(topic_list$topic == topic_name)){
    stop("This topic already exists.")
  }

  sns("create-topic",
      topic_name = topic_name,
      display_name = display_name,
      profile = profile)
}

#' @export
delete_topic <- function(topic,
                         profile = "default"){

  if (missing(topic)) stop("Topic name or arn is required.")

  sns("delete-topic", arn = topic_arn(topic, profile), profile = profile)
}

#' @export
rename_display_name <- function(topic,
                                display_name,
                                profile = "default"){

  if (missing(topic)) stop("Topic name or arn is required.")
  if (missing(display_name)) stop("Display name is required.")

  sns("set-topic-attributes",
      arn = topic_arn(topic, profile),
      rename_display = display_name,
      profile = profile)
}
