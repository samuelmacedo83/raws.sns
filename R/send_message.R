#' Send message to endpoints
#'
#' You can send messages for every endpoint in a topic or directly to a phone
#' number. SMS is only available for profiles in us-east-1 region, you can verify
#' your region profile using \code{raws.profile::profile_settings("your profile")}.
#'
#' @template roxlate-topic
#' @param phone_number Send a message directly to this phone number. This number
#' doesn't need to be in a topic.
#' @param message The massage you want to send.
#' @param subject (optional) The message subject. Only available to "email"
#' protocol.
#' @template roxlate-profile
#' @examples
#' \dontrun{
#' # send a message to a topic
#' send_message(topic = "your_topic",
#'              subject = "testing",
#'              message = "This is a test message.")
#'
#' # send a message directly to a phone number
#' send_message(phone_number = "+0081345678",
#'              message = "This is a test message.")
#'}
#'
#' @export
send_message <- function(topic = NULL,
                         phone_number = NULL,
                         message,
                         subject = NULL,
                         suppress_output = FALSE,
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

  if (phone_number_exist){
    region <- profile_region(profile)

    if (region != "us-east-1"){
      stop("Only the region us-east-1 supports sms message.")
    }

    message_id <- sns("publish",
                      phone_number = phone_number,
                      message = message,
                      profile = profile)
  } else{
    message_id <- sns("publish",
                      arn = topic_arn(topic, profile),
                      message = message,
                      subject = subject,
                      profile = profile)
  }

  if (suppress_output == FALSE){
    tibble::data_frame(message_id = message_id$MessageId)
  }
}
