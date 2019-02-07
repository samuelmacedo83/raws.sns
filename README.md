# raws.sns

This is an R wrapper from the AWS Command Line Interface that 
provides methods to send messages using Amazon Simple Notification Service. 
You can create as many topics as you want, subscribe users to a topic and
send notifications to them via SMS or e-mail. It also provides a function to
automatically install AWS CLI, but you can download it and install it 
manually if you prefer. 

To use raws.sns package, you will need an AWS account and create a profile.
To do this, go to your AWS account and generate your credentials on [IAM Management Console](https://aws.amazon.com/). This process will generate an
access key and a secret key, use them to create a profile. Your profile can be easily created using [raws.profile](https://github.com/samuelmacedo83/raws.profile) package.

## Installation

You can install the released version of raws.sns from [CRAN](https://CRAN.R-project.org) with:

  ``` r
install.packages("raws.sns")
```

To upgrade to the latest version of raws.sns, run the following
command and restart your r session:

  ``` r
devtools::install_github("samuelmacedo83/raws.sns")

```

## Installing the AWS CLI

The AWS CLI is required for raws.sns work. You can install using
the function below:

  ``` r
aws_cli_install()
```

## Create topic

This is a basic example which shows you how to create your topics:

``` r
 # create a topic
 create_topic(topic_name = "your_topic_name",
              display_name = "testing")
  
 # verifying the topics in your profile             
 list_topics()
```

## Subscriptions

You can menage your subscriptions using `subscribe()` and `unsubscribe()`

``` r
subscribe(topic = "raws_sns_test",
          protocol = c("sms", "email", "sms"),
          endpoint = c("+55819902", "asdf3@gmail.com", "+55819903"))

unsubscribe(topic = "raws_sns_test",
            endpoint = "+55819902")

# verifying your subscriptions             
list_subscriptions("raws_sns_test")
```

## Sending notifications

A message sent to a topic will be delivered to each registered user
in this topic. Note that SMS is only available in us-east-1 region.

``` r
send_message("raws_sns_test", subject = "test", message = "12345")
```

## Delete your topic

You can delete using `delete_topic()`.

``` r
 # delete your topic
 delete_topic(topic = "your_topic_name")
```


