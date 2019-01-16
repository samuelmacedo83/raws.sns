#' @importFrom magrittr %>%
#' @export
sns <- function(sns_function,
                topic_name = NULL,
                display_name = NULL,
                arn = NULL,
                profile = "default",
                system_return = FALSE){

  command <- paste("aws sns", sns_function) %>%
    topic_name_(topic_name) %>%
    attributes_(display_name) %>%
    arn_(arn) %>%
    profile_(profile)

  system(command, intern = system_return)
}

profile_ <- function(command, profile){
  if (profile != "default"){
    command <- paste(command, "--profile", profile)
  }
 command
}

topic_name_ <- function(command, topic_name){
  if (!is.null(topic_name)){
    command <- paste(command, "--name", topic_name)
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

arn_ <- function(command, arn){
  if (!is.null(arn)){
    command <- paste(command, "--topic-arn", arn)
  }
  command
}

