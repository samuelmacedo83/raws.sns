#' @export
send_message <- function(topic = NULL,
                         phone_number = NULL,
                         message,
                         subject = NULL,
                         profile = "default"){

  topic_exist <- !is.null(topic)
  phone_number_exist <- !is.null(phone_number)

  if (!topic_exist & !phone_number_exist)
    stop("A topic or a phone number is required.")
  if (topic_exist & phone_number_exist)
    stop(paste("You cannot send a message to a topic and a phone",
               "number at the same time."))
  if (missing(message))
    stop("Message is required.")

  sns("publish",
      arn = ifelse(topic_exist, topic_arn(topic, profile), topic),
      phone_number = phone_number,
      message = message,
      subject = subject,
      profile = profile)
}
