#' List your topics and subscriptions
#'
#' The \code{list_topics()} shows the topics created in your SNS
#' account. You can see your subscriptions using
#'  \code{list_subscriptions("your topic")}.
#'
#' @template roxlate-topic
#' @template roxlate-profile
#'
#' @examples
#' \dontrun{
#' # list the topics in your account
#' list_topics()
#'
#' # list the subscriptions in a topic using a profile
#' list_subscriptions(topic = "your topic",
#'                    profile = "your profile")
#'
#' }
#' @name sns_lists
NULL

#' @rdname sns_lists
#' @export
list_topics <- function(profile = "default"){

  topics <- sns("list-topics",
                profile = profile)

  arn <- topics$Topics$TopicArn

  # The topic name is in 6th position
  topics_name <- stringr::str_split_fixed(arn,":", 6)[,6]

  tibble::data_frame(topic = topics_name,
                     arn = arn)
}

#' @rdname sns_lists
#' @export
list_subscriptions <- function(topic,
                               profile = "default"){

  subscriptions <- sns("list-subscriptions-by-topic",
                       arn = topic_arn(topic, profile),
                       profile = profile)

  subscriptions <- subscriptions$Subscriptions

  if (length(subscriptions) == 0){
    message("There aren't subscriptions in this topic." )
  } else {
    arn <- purrr::map_chr(subscriptions$SubscriptionArn, function(e){
      ifelse(e == "PendingConfirmation", "pending", e)
    })

    tibble::data_frame(endpoint = subscriptions$Endpoint,
                       protocol = subscriptions$Protocol,
                       arn = arn)
  }
}
