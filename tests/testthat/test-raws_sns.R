context("raws.sns")

test_that("create topic works", {
  skip_on_cran()
  skip_on_travis()

  tryCatch(delete_topic("raws_sns_test"), error = function(e) 1)

  create_topic("raws_sns_test")
  topics <- list_topics()
  expect_true(any(topics$topic == "raws_sns_test"))
})

test_that("subscribe works", {

  skip_on_cran()
  skip_on_travis()
  region <- profile_region()

  if (region == "us-east-1"){
    subscribe_complete_test()
  } else {
    subscribe_test()
  }
})

test_that("unsubscribe works", {
  skip_on_cran()
  skip_on_travis()

  region <- profile_region()

  if (region == "us-east-1"){
    unsubscribe_complete_test()
  } else {
    unsubscribe_test()
  }
})

test_that("rename_display_name works", {
  skip_on_cran()
  skip_on_travis()

  rename_display_name(topic = "raws_sns_test",
                      display_name = "topic_name")

  topic <- describe_topic("raws_sns_test")

  expect_equal(topic$display_name,
               "topic_name")
})

test_that("send_message works", {
  skip_on_cran()
  skip_on_travis()

  message_id <- send_message("raws_sns_test", subject = "test", message = "12345")

  expect_type(message_id$message_id, "character")
})

test_that("describe_topic works",{
  skip_on_cran()
  skip_on_travis()

  region <- profile_region()

  if (region == "us-east-1"){
    Sys.sleep(30) # it is take a while to update the topic on aws
    topic <- describe_topic("raws_sns_test")

    expect_equal(topic$subscription_confirmed, 1)
    expect_equal(topic$subscription_pending, 3)
    expect_equal(topic$subscription_deleted, 3)
  } else {
    Sys.sleep(40) # it is take more time here :(
    topic <- describe_topic("raws_sns_test")

    expect_equal(topic$subscription_confirmed, 0)
    expect_equal(topic$subscription_pending, 3)
    expect_equal(topic$subscription_deleted, 3)
  }
})

test_that("delete topic works", {
  skip_on_cran()
  skip_on_travis()

  delete_topic("raws_sns_test")
  topics <- list_topics()
  expect_false(any(topics$topic == "raws_sns_test"))
})
