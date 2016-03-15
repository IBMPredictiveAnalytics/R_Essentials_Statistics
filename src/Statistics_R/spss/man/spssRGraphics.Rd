\name{spssRGraphics}
\title{Display R graphics in the IBM SPSS Statistics Viewer}
\alias{spssRGraphics}
\alias{spssRGraphics.Submit}
\alias{spssRGraphics.SetOutput}
\description{
  Supplies a set of methods to display R graphics in the IBM® SPSS® Statistics 
  Viewer.
}
\usage{
spssRGraphics.Submit(filename)
spssRGraphics.SetOutput(switch)
}
\arguments{
  \item{filename}{A character string specifying the path to a graphic 
    file. It cannot be NULL, an empty string, or contain only blank characters. 
	The supported formats for the graphic file are: png, jpg and bmp.
    }
  \item{switch}{A character string that controls whether graphical output from R is 
	displayed in the IBM SPSS Statistics Viewer. Can only be "ON" or "OFF". If "ON" is specified, 
	graphical output from R will be displayed in the Viewer. Otherwise, graphical 
	output from R will be not displayed. The default is "ON".
    }
}
\value{
}
\details{
spssRGraphics.Submit displays a specified R graphic in the Viewer.\cr

spssRGraphics.SetOutput controls whether graphical output from R is displayed 
in the Viewer.\cr
}
\references{
}
\seealso{
  \code{\link{spssdictionary}},
  \code{\link{spssdata}},
  \code{\link{spsspivottable}},
  \code{\link{spssxmlworkspace}}.
}
\examples{
## These examples must be run from IBM SPSS Statistics. They cannot be run from R.
*Example 1.
get file="/data/demo.sav".
begin program R.
example(rect)
end program.

*Example 2.
get file="/data/demo.sav".
begin program R.
filename <- "/images/image.png"
spssRGraphics.Submit(filename)
end program.

© Copyright IBM Corp. 1989, 2011
}
\keyword{classes}
\keyword{methods}
