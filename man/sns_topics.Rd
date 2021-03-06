% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/topic_.R
\name{sns_topics}
\alias{sns_topics}
\alias{create_topic}
\alias{delete_topic}
\alias{rename_display_name}
\title{Create, delete and manage your topic}
\usage{
create_topic(topic_name, display_name = NULL, suppress_output = FALSE,
  profile = "default")

delete_topic(topic, profile = "default")

rename_display_name(topic, display_name, profile = "default")
}
\arguments{
\item{topic_name}{Your topic name. Must contain only alphanumeric characters
hyphens (-), or underscores (_).}

\item{display_name}{(optional) The name that will display when you send an email.
The display name won't appear in SMS. Display name cannot be greater than 10.}

\item{suppress_output}{Use TRUE if you don't want the output.}

\item{profile}{Your profile name in AWS. If profile was not supplied
this function will use the default profile.}

\item{topic}{A topic name or topic ARN.}
}
\description{
Create and delete a topic in your SNS account. Display name is optional and
only appears when you send emails. If you want to modify or insert a display
name in a topic that already exist, use \code{rename_display_name()}.
}
\examples{
\dontrun{
 # create a topic
 create_topic(topic_name = "your_topic_name",
              display_name = "testing")

 # rename display name
 rename_display_name(topic = "your_topic_name",
                     display_name = "testing_2")

 # delete your topic
 delete_topic(topic = "your_topic_name")
}

}
