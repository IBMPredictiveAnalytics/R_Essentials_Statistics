\name{spss-package}
\alias{spss-package}
\alias{spss}
\docType{package}
\title{
An interface to embed R in IBM SPSS Statistics
}
\description{
An interface to embed R in IBM® SPSS® Statistics
}
\details{
\tabular{ll}{
Package: \tab SPSS\cr
Type: \tab Package\cr
Version: \tab 22.0\cr
Date: \tab 2009-01-12\cr
}

The function spsspkg.Version is used to get the detailed version infomation.
It retrieves the major version, patch version and the bugfix version of the package.\cr

The function spsspkg.GetSPSSLocale is used to retrieve the locale of
the IBM SPSS Statistics processor.\cr
The function spsspkg.SetOutputLanguage is used to set the output language
of the IBM SPSS Statistics processor.\cr
The function spsspkg.GetOutputLanguage is used to retrieve the output language of
the IBM SPSS Statistiscs processor.\cr
The function spsspkg.GetStatisticsPath is used to retrieve the installation path
of the IBM SPSS Statistics processor.\cr

The function spsspkg.GetSPSSVersion and GetSPSSVersion are used to get the IBM SPSS Statistics version. 
However, the function GetSPSSVersion is deprecated.\cr
The function spsspkg.GetSPSSPlugInVersion and GetSPSSPlugInVersion are used to get 
the IBM SPSS Statistics-R Integration Plug-in version.
However, the function GetSPSSPlugInVersion is deprecated.\cr
}

\value{
spsspkg.Version returns a list.\cr
spsspkg.GetSPSSLocale returns a character string.\cr
spsspkg.GetOutputLanguage returns a character string.\cr
spsspkg.GetStatisticsPath returns a character string.\cr
}

\references{
}
\keyword{ package }
\seealso{
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
    \item{lang}{ A character string specifying the output language. The list of 
    available languages:
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
## These examples need to be run from IBM SPSS Statistics. They cannot be run from R.
* Example 1 -- Get the version information for the IBM SPSS Statistics package.
begin program R.
ver <- spsspkg.Version()
print(ver)
end program.

* Example 2 -- Get the locale of the IBM SPSS Statistics processor.
begin program R.
loc <- spsspkg.GetSPSSLocale()
print(loc)
end program.

* Example 3 -- Set the output language of the IBM SPSS Statistics processor.
show olang.
begin program R.
spsspkg.SetOutputLanguage("German")
end program.
show olang.

* Example 4 -- Get the IBM SPSS Statistics and Plug-in version information.
begin program R.
verspss <- spsspkg.GetSPSSVersion()
print(verspss)
verplugin <- spsspkg.GetSPSSPlugInVersion()
print(verplugin)
end program.

© Copyright IBM Corp. 1989, 2012
}
