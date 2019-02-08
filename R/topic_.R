#' Create, delete and manage your topic
#'
#' Create and delete a topic in your SNS acccout. Display name is optional and
#' only appears when you send emails. If you want to modify or insert a display
#' name in a topic that already exist, use \code{rename_display_name()}.
#'
#' @param topic_name Your topic name. Must contain only alphanumeric characters
#' hyphens (-), or underscores (_).
#' @template roxlate-topic
#' @param display_name (optional) The name that will display when you send an email.
#' The display name won't appear in SMS. Display name cannot be greater than 10.
#' @template roxlate-suppress_output
#' @template roxlate-profile
#'
#' @examples
#' \dontrun{
#'  # create a topic
#'  create_topic(topic_name = "your_topic_name",
#'               display_name = "testing")
#'
#'  # rename display name
#'  rename_display_name(topic = "your_topic_name",
#'                      display_name = "testing_2")
#'
#'  # delete your topic
#'  delete_topic(topic = "your_topic_name")
#' }
#'
#' @name sns_topics
NULL

#' @rdname sns_topics
#' @export
create_topic <- function(topic_name,
                         display_name = NULL,
                         suppress_output = FALSE,
                         profile = "default"){

  if (missing(topic_name)){
    stop("Topic name is required")
  }

  is_valid_name(topic_name, display_name)

  topic_list <- list_topics()

  if (any(topic_list$topic == topic_name)){
    stop("This topic already exists.")
  }

  topic_created <- sns("create-topic",
                   topic_name = topic_name,
                   display_name = display_name,
                   profile = profile)

  if (suppress_output == FALSE){
     tibble::data_frame(topic_arn = topic_created$TopicArn)
  }
}

#' @rdname sns_topics
#' @export
delete_topic <- function(topic,
                         profile = "default"){

  if (missing(topic)) stop("Topic name or arn is required.")

  sns("delete-topic",
      arn = topic_arn(topic, profile),
      profile = profile)
}

#' @rdname sns_topics
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
