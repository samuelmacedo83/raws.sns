#' Topic description
#'
#' This function returns a tibble with some informations about the topic.
#'
#' @template roxlate-topic
#' @template roxlate-profile
#'
#' @examples
#' \dontrun{
#' describe_topic("raws_sns_test", profile = "your profile")
#' }
#'
#' @export
describe_topic <- function(topic,
                           profile = "default"){

  topic <- sns("get-topic-attributes",
               arn = topic_arn(topic, profile),
               profile = profile)

  subscription_confirmed = as.integer(topic$Attributes$SubscriptionsConfirmed)
  subscription_pending = as.integer(topic$Attributes$SubscriptionsPending)
  subscription_deleted = as.integer(topic$Attributes$SubscriptionsDeleted)

  tibble::data_frame(arn = topic$Attributes$TopicArn,
                     display_name = topic$Attributes$DisplayName,
                     owner = topic$Attributes$Owner,
                     subscription_confirmed = subscription_confirmed,
                     subscription_pending = subscription_pending,
                     subscription_deleted = subscription_deleted)
}
