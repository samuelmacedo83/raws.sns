#' @export
list_topics <- function(){
  topics <- sns("list-topics",
                system_return = TRUE)

  arn <- jsonlite::fromJSON(topics)$Topics$TopicArn

  # The topic name is in 6th position
  topics_name <- stringr::str_split_fixed(arn,":", 6)[,6]

  tibble::data_frame(topic = topics_name,
                     arn = arn)
}
