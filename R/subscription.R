#' @export
subscribe <- function(topic,
                      protocol,
                      endpoint,
                      profile = "default"){

 if (missing(topic)) stop("Topic is required.")
 if (missing(protocol)) stop("Protocol is required.")
 if (missing(endpoint)) stop("Endpoint is required.")

 if (length(endpoint) > 1 & length(protocol) == 1){
   protocol <- rep(protocol, length(endpoint))
 }

 for (i in 1:length(endpoint)){
   sns("subscribe",
     arn = topic_arn(topic, profile),
     protocol = protocol[i],
     endpoint = endpoint[i],
     profile = profile)
 }
}


#' @export
unsubscribe <- function(topic,
                        endpoint,
                        endpoint_arn,
                        profile = "default"){

  if (!missing(endpoint_arn)){
    status <- sns("unsubscribe",
                  subscription_arn = endpoint_arn,
                  profile = profile,
                  ignore_error = TRUE)

    if(status == 255) {
      stop("Your endpoint_arn does not exist.")
    }
  } else {
    if (missing(topic)) stop("Topic is required.")
    if (missing(endpoint)) stop("Endpoint is required.")

    subscriptions <- list_subscriptions(topic = topic, profile = profile)
    endpoint_exist <- subscriptions$subscriber == endpoint

    if (any(endpoint_exist)){
      arn <- subscriptions$arn[endpoint_exist]
      if (arn == "pending") {
        stop(paste("The endpoint", endpoint, "is in pending yet."))
      } else {
        sns("unsubscribe",
            subscription_arn = arn,
            profile = profile)
      }
    } else {
      stop(paste("The endpoint", endpoint, "does not exist."))
    }
  }
}

