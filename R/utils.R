# this function verifies the topic existence. it will return the
# arn indepently if topic is a name or arn.
topic_arn <- function(topic, profile = "default"){

  topic_list <- list_topics(profile = profile)

  # An arn is a string with 6 components separate by : and
  # the first one is always arn.
  arn <- stringr::str_split_fixed(topic,":", 6)[ , 1]

  if (arn == "arn"){
    topic_exist <- topic_list$arn == topic
    if (!any(topic_exist)){
      stop("This topic does not exist.")
    }
  } else {
    topic_exist <- topic_list$topic == topic

    if (any(topic_exist)){
      topic <- topic_list[topic_exist, 2]$arn
    } else {
      stop("This topic does not exist.")
    }
  }

 topic
}

# verifies if topic name or display name is valid
is_valid_name <- function(topic_name, display_name){


  valid_topic_name <- stringr::str_remove_all(topic_name,
                                              pattern = "[0-9a-zA-Z_-]")

  if (valid_topic_name != ""){
    stop(paste0("Topic name contains invalid characters. ",
                "Must contain only alphanumeric characters, ",
                "hyphens (-), or underscores (_)."))
  }

  if (!is.null(display_name) & stringr::str_length(display_name) > 10)
    stop("Display name cannot be greater than 10.")
}

sns_parameter <- function(command, parameter, value){
  if (!is.null(value)){
    command <- paste(command, parameter, value)
  }
  command
}

sns_text_parameter <- function(command, parameter, value){
  if (!is.null(value)){
    value <- paste0("\"", value, "\"")
    command <- paste(command, parameter, value)
  }
  command
}


