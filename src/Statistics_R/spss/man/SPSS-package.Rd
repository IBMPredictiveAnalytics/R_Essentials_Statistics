\name{spss-package}
\alias{spss-package}
\alias{spss}
\alias{spsspkg}
\alias{spsspkg.GetOutputLanguage}
\alias{spsspkg.GetSPSSLocale}
\alias{spsspkg.GetSPSSPlugInVersion}
\alias{spsspkg.GetSPSSVersion}
\alias{spsspkg.GetStatisticsPath}
\alias{spsspkg.SetOutput}
\alias{spsspkg.SetOutputLanguage}
\alias{spsspkg.Version}
\alias{IsDistributedMode}
\docType{package}
\title{
An interface to use R with IBM SPSS Statistics
}
\description{
This package provides an interface to use R with IBM® SPSS® Statistics. You can run IBM SPSS Statistics from an external R process, such as an R IDE or the R interpreter. In this mode, the R program starts up a new instance of the IBM SPSS Statistics processor without an associated instance of the IBM SPSS Statistics client. You can also run R code from within IBM SPSS Statistics by wrapping the code in BEGIN PROGRAM R - END PROGRAM blocks of command syntax.  

The help for the spss package is organized into the following topics, in addition to the functions described in this help file:\cr

\code{\link{spssdata}} - functions for exchanging data between IBM SPSS Statistics and R\cr
\code{\link{spssdictionary}} - functions for retrieving dictionary information from the active dataset and for creating new datasets in IBM SPSS Statistics\cr
\code{\link{spsspivottable}} - functions for creating IBM SPSS Statistics pivot tables\cr
\code{\link{spssRGraphics}} - functions for displaying R graphics in the IBM SPSS Statistics Viewer (does not apply when driving IBM SPSS Statistics from R)\cr
\code{\link{spssxmlworkspace}} - functions for retrieving output from IBM SPSS Statistics commands, and dictionary information from the active dataset\cr
\code{\link{TextBlock}} - function to create and populate a text block item in IBM SPSS Statistics output\cr
\code{\link{external}} - functions for running IBM SPSS Statistics from R\cr
\code{\link{extension}} - functions for creating R extension commands in IBM SPSS Statistics\cr

Detailed help is available in the IBM SPSS Statistics help system under "Integration Plug-in for R Help", in addition to the R-style help that is installed with this package.
}
\details{
\tabular{ll}{
Package: \tab spss\cr
Type: \tab Package\cr
Version: \tab 28.0\cr
Date: \tab 2021-04-25\cr
}
spsspkg.GetOutputLanguage retrieves the output language of the IBM SPSS Statistics processor.\cr

spsspkg.GetSPSSLocale retrieves the locale of the IBM SPSS Statistics processor.\cr

spsspkg.GetSPSSPlugInVersion gets the IBM SPSS Statistics-R Integration Plug-in version. It replaces the function GetSPSSPlugInVersion, which is deprecated.\cr

spsspkg.GetSPSSVersion gets the IBM SPSS Statistics version. It replaces the function GetSPSSVersion, which is deprecated.\cr

spsspkg.GetStatisticsPath retrieves the installation path of the IBM SPSS Statistics processor.\cr

spsspkg.SetOutput specifies whether output from R is displayed in the IBM SPSS Statistics Viewer. This function has no effect when running IBM SPSS Statistics from R.\cr

spsspkg.SetOutputLanguage sets the output language of the IBM SPSS Statistics processor.\cr

spsspkg.Version gets detailed version information. It retrieves the major version, patch version and the bugfix version of the package.\cr

spsspkg.IsDistributedMode is used to determine if IBM SPSS Statistics is in distributed mode. The function returns TRUE if SPSS Statistics is in distributed mode, FALSE otherwise. spsspkg.IsDistributedMode always returns FALSE when SPSS Statistics is run from R.\cr
}

\value{
spsspkg.GetOutputLanguage returns a character string.\cr
spsspkg.GetStatisticsPath returns a character string.\cr
spsspkg.GetSPSSLocale returns a character string.\cr
spsspkg.Version returns a list.\cr
}

\references{
}
\keyword{package}
\seealso{\code{\link{spssstatistics}},
  \code{\link{extension}},
  \code{\link{external}},
  \code{\link{spssdata}},
  \code{\link{spssdictionary}},
  \code{\link{spsspivottable}},
  \code{\link{spssRGraphics}},
  \code{\link{spssxmlworkspace}},
  \code{\link{TextBlock}}
}

\usage{
spsspkg.Version()
spsspkg.GetSPSSLocale()
spsspkg.SetOutputLanguage(lang)
spsspkg.GetOutputLanguage()
spsspkg.GetStatisticsPath()
spsspkg.SetOutput(output)
}
\arguments{
    \item{lang}{ A character string specifying the output language.  Available languages:
        English
        French
        German
        Italian
        Japanese
        Korean
        Polish
        Russian
        SChinese (Simplified Chinese)
        Spanish
        TChinese (Traditional Chinese)
	BPortugu (Brazilian Portuguese)
    }
    \item{output}{The value of the argument is a quoted string: "ON" to display output from R, 
    "OFF" to suppress the display of output from R. The default is "ON".
    }
}
\examples{
* Example 1 -- get the version information for the IBM SPSS Statistics package
ver <- spsspkg.Version()
print(ver)


* Example 2 -- get the locale of the IBM SPSS Statistics processor
loc <- spsspkg.GetSPSSLocale()
print(loc)


* Example 3 -- set the output language of the IBM SPSS Statistics processor
spsspkg.SetOutputLanguage("German")


* Example 4 -- get the IBM SPSS Statistics and Plug-in version information
verspss <- spsspkg.GetSPSSVersion()
print(verspss)
verplugin <- spsspkg.GetSPSSPlugInVersion()
print(verplugin)

* Example 5 -- determine if SPSS Statistics is in distributed mode.
isDistributed <- spsspkg.IsDistributedMode()
print(isDistributed)


© Copyright IBM Corp. 1989, 2021
}
\note{
To drive IBM SPSS Statistics from an external R process, call the spsspkg.StartStatistics function after loading the spssstatistics package. 
You execute IBM SPSS Statistics command syntax with the spsspkg.Submit function (described in \code{\link{external}}). Tabular output from IBM SPSS Statistics is displayed as plain text in R. Graphical output from IBM SPSS Statistics is not displayed in R. Note that the spsspkg.Submit function starts up IBM SPSS Statistics if it is not already running.
}
