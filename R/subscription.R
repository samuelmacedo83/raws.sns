#' Subscribe and unsubscribe endpoints
#'
#' Subscribe one or more users to a topic and unsubscribe them
#' using their endpoints. For better performance, use the endpoint ARN on
#' \code{unsubscribe()}. You can retrieve these ARN's in your SNS account on
#' Amazon or using \code{list_subscriptions()}.
#'
#' @template roxlate-topic
#' @param protocol A string or a vector of strings with the protocol.
#' "sms" and "email" are supported. If you have a vector of endpoints with the
#' same protocol you just need to specify the procotol, not a vector of
#' protocols.
#' @param endpoint A string or a vector of strings with users that you want
#' to subscribe. Use a valid email and for SMS use a complete cell phone number,
#' for example: "+558112345678".
#' @param subscription_arn A string with the user's ARN. Use this for better
#' performance in \code{unsubscribe()}. You can check the endpoint ARN in SNS
#' account or usind the \code{list_subscription()}
#' @template roxlate-profile
#'
#' @examples
#' \dontrun{
#' # subscribe a user
#' # subscribe(topic = "your topic",
#'              protocol = "sms",
#'              endpoint = "+0012345")
#'
#' # subscribe more than one user with a singe protocol
#' endpoint <- c("user1@@email.com", "user2@@email.com", "user3@@email.com" )
#' subscribe(topic = "your topic",
#'           protocol = "email",
#'           endpoint = endpoint)
#'
#' # subscribe more than one user with differents protocols
#' endpoint <- c("user4@@email.com", "+0054321", "user5@@email.com" )
#' protocol <- c("email", "sms", "email")
#' subscribe(topic = "your topic",
#'          protocol = protocol,
#'          endpoint = endpoint)
#'
#' # unsubscribe a user
#' unsubscribe(topic = "your topic",
#'             endpoint = "+0012345")
#'
#' # unsubscribe more than one user
#' unsubscribe(topic = "your topic",
#'             endpoint = c("user4@@email.com", "+0054321"))
#'
#' # use the endpoint ARN for better performance
#' unsubscribe(topic = "your topic",
#'             endpoint_arn = "arn:aws:sns:your_topic:12345")
#' }
#' @name subscription
NULL

#' @rdname subscription
#' @export
subscribe <- function(topic,
                      protocol,
                      endpoint,
                      profile = "default"){

 if (missing(topic)) stop("Topic is required.")
 if (missing(protocol)) stop("Protocol is required.")
 if (missing(endpoint)) stop("Endpoint is required.")

 #verifying region
 region <- profile_region(profile)

 if (any(protocol == "sms")){
   if (region != "us-east-1"){
     stop("sms protocol is only available on us-east-1 region.")
   }
 }

 # verifyng typos on protocols
 typos <- stringr::str_remove(protocol, "sms") %>%
   stringr::str_remove("email")

 if (any(typos != "" )){
   stop("There is at least one typo in your protocols.")
 }

 if (length(endpoint) > 1 & length(protocol) == 1){
   protocol <- rep(protocol, length(endpoint))
 }

 arn <- topic_arn(topic, profile)

 purrr::walk2(protocol, endpoint,
              function(p, e, arn, profile){
                sns("subscribe",
                    arn = arn,
                    protocol = p,
                    endpoint = e,
                    profile = profile)},
              arn = arn,
              profile = profile
   )
}

#' @rdname subscription
#' @export
unsubscribe <- function(topic,
                        endpoint,
                        subscription_arn,
                        profile = "default"){

  if (!missing(subscription_arn)){
    unsubscribe_arns(subscription_arn, profile)
  } else {
    if (missing(topic)) stop("Topic is required.")
    if (missing(endpoint)) stop("Endpoint is required.")

    subscriptions <- list_subscriptions(topic = topic, profile = profile)
    subscriptions <- subscriptions[subscriptions$arn != "pending", ]

    if (nrow(subscriptions) != 0){
      endpoint_exist <- subscriptions$endpoint %in% endpoint
      if (any(endpoint_exist)){
        arns <- subscriptions$arn[endpoint_exist]
        unsubscribe_arns(arns, profile)
     }
   }
  }
}

unsubscribe_arns <- function(arns, profile){
  purrr::walk(arns,
              function(e, profile){
                sns("unsubscribe",
                    subscription_arn = e,
                    profile = profile)},
              profile = profile)
}
