#' @export
list_topics <- function(profile = "default"){

  topics <- sns("list-topics",
                profile = profile,
                system_return = TRUE)

  arn <- jsonlite::fromJSON(topics)$Topics$TopicArn

  # The topic name is in 6th position
  topics_name <- stringr::str_split_fixed(arn,":", 6)[,6]

  tibble::data_frame(topic = topics_name,
                     arn = arn)
}


# list-subscriptions
#' @export
list_subscriptions <- function(topic,
                               profile = "default"){

  subscriptions <- sns("list-subscriptions-by-topic",
                       arn = topic_arn(topic, profile),
                       profile = profile,
                       system_return = TRUE)

  subscriptions <- jsonlite::fromJSON(subscriptions)$Subscriptions

  arn <- purrr::map_chr(subscriptions$SubscriptionArn, function(e){
    ifelse(e == "PendingConfirmation", "pending", e)
  })

  tibble::data_frame(subscriber = subscriptions$Endpoint,
                     protocol = subscriptions$Protocol,
                     arn = arn)

}
# list-subscriptions-by-topic
