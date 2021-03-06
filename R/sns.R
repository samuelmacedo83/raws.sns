#' @importFrom magrittr %>%
sns <- function(sns_function,
                topic_name = NULL,
                display_name = NULL,
                rename_display = NULL,
                arn = NULL,
                subscription_arn = NULL,
                protocol = NULL,
                endpoint = NULL,
                phone_number = NULL,
                message = NULL,
                subject = NULL,
                profile = "default"){

  command <- paste("aws sns", sns_function) %>%
    topic_name_(topic_name) %>%
    attributes_(display_name) %>%
    arn_(arn) %>%
    subscription_arn_(subscription_arn) %>%
    protocol_(protocol) %>%
    endpoint_(endpoint) %>%
    phone_number_(phone_number) %>%
    message_(message) %>%
    subject_(subject) %>%
    rename_display_name_(rename_display) %>%
    profile_(profile)

  sns <- suppressWarnings(system(command,
                                 intern = TRUE,
                                 ignore.stderr = TRUE))

  # verifing if there are errors or warnings
  sns_error(sns)
  sns_warning(sns, phone_number, subscription_arn)

  if (length(sns) != 0) jsonlite::fromJSON(sns)
}

profile_ <- function(command, profile){
  if (profile != "default"){
    command <- paste(command, "--profile", profile)
  }
 command
}

attributes_ <- function(command, display_name = NULL){
  # there are other attributes but display name
  if (!is.null(display_name)){
    command <- paste0(command,
                      " --attributes DisplayName=\"",
                      display_name,
                      "\"")
  }
  command
}

topic_name_ <- function(command, topic_name){
  sns_parameter(command, "--name", topic_name)
}

arn_ <- function(command, arn){
  sns_parameter(command, "--topic-arn", arn)
}

subscription_arn_ <- function(command, arn){
  sns_parameter(command, "--subscription-arn", arn)
}

phone_number_ <- function(command, phone_number){
  sns_parameter(command, "--phone-number", phone_number)
}

protocol_ <- function(command, protocol){
  sns_parameter(command, "--protocol", protocol)
}

endpoint_ <- function(command, endpoint){
  sns_parameter(command, "--notification-endpoint", endpoint)
}

subject_ <- function(command, subject){
  sns_text_parameter(command, "--subject", subject)
}

message_ <- function(command, message){
  sns_text_parameter(command, "--message", message)
}

rename_display_name_ <- function(command, display_name){
  # there are other attributes but display name
  if (!is.null(display_name)){
    command <- paste0(command,
                      " --attribute-name DisplayName",
                      " --attribute-value=\"",
                      display_name,
                      "\"")
  }
  command
}

# error verification
sns_error <- function(status){
  if (is.integer(status)) {
    if (status == 255){
      stop("This topic does not exist.", call. = FALSE)
    }
  }
}

# warning verification
sns_warning <- function(status, phone_number, subscription_arn){
  if (!is.null(attributes(status)$status)){
    if (!is.null(phone_number)){
      stop("SMS is only available for us-east-1 region", call. = FALSE)
    } else if (!is.null(subscription_arn)){
      warning(paste("The subscription arn", subscription_arn, "does not exist."))
    } else {
      stop("This topic does not exist.", call. = FALSE)
    }
  }
}


