# this test uses sms and email
subscribe_complete_test <- function(subscriptions){
  subscribe(topic = "raws_sns_test",
            protocol = "sms",
            endpoint = "+55819901")

  subscribe(topic = "raws_sns_test",
            protocol = "email",
            endpoint = c("asdf1@gmail.com", "asdf2@gmail.com"))

  subscribe(topic = "raws_sns_test",
            protocol = c("sms", "email", "sms"),
            endpoint = c("+55819902", "asdf3@gmail.com", "+55819903"))

  endpoint <-  c("+55819901", "asdf1@gmail.com", "asdf2@gmail.com",
                 "+55819902", "asdf3@gmail.com", "+55819903")

  protocol <- c("sms", "email", "email", "sms", "email", "sms")

  subscriptions <- list_subscriptions("raws_sns_test")
  subscriptions_test <- tibble::data_frame(endpoint = endpoint,
                                           protocol = protocol)

  testthat::expect_equal(subscriptions[order(subscriptions$endpoint), 1:2],
                         subscriptions_test[order(subscriptions_test$endpoint), ])
}

# this test uses just email
subscribe_test <- function(){
  endpoints <- c("asdf1@gmail.com", "asdf2@gmail.com", "asdf3@gmail.com")

  subscribe(topic = "raws_sns_test",
            protocol = "email",
            endpoint = endpoints)

  protocol <- c("email", "email","email")
  arn <- rep("pending", 3)

  subscriptions <- list_subscriptions("raws_sns_test")
  subscriptions_test <- tibble::data_frame(endpoint = endpoints,
                                           protocol = protocol,
                                           arn = arn)

  testthat::expect_equal(subscriptions[order(subscriptions$endpoint), ],
                         subscriptions_test[order(subscriptions_test$endpoint), ])
}

# this function uses sms and amail
unsubscribe_complete_test <- function(){
  unsubscribe(topic = "raws_sns_test",
              endpoint = c("+55819902", "asdf3@gmail.com", "+55819903"))

  protocol <- c("sms", "email", "email", "email")
  endpoint <- c("+55819901", "asdf1@gmail.com",
                "asdf2@gmail.com", "asdf3@gmail.com")

  subscriptions <- list_subscriptions("raws_sns_test")
  subscriptions_test <- tibble::data_frame(endpoint = endpoint,
                                           protocol = protocol)

  testthat::expect_equal(subscriptions[order(subscriptions$endpoint), 1:2],
                         subscriptions_test[order(subscriptions_test$endpoint), ])
}

# this function uses only email
unsubscribe_test <- function(){
  unsubscribe(topic = "raws_sns_test",
              endpoint = c("+55819902", "asdf3@gmail.com", "+55819903"))

  endpoint <-  c("asdf1@gmail.com", "asdf2@gmail.com", "asdf3@gmail.com")
  protocol <- c("email", "email", "email")

  subscriptions <- list_subscriptions("raws_sns_test")
  subscriptions_test <- tibble::data_frame(endpoint = endpoint,
                                           protocol = protocol)

  testthat::expect_equal(subscriptions[order(subscriptions$endpoint), 1:2],
                         subscriptions_test[order(subscriptions_test$endpoint), ])
}

