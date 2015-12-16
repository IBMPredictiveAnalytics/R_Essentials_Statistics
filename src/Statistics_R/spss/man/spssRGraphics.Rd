\name{spssRGraphics}
\title{Display R graphics in the IBM SPSS Statistics Viewer}
\alias{spssRGraphics}
\alias{spssRGraphics.Submit}
\alias{spssRGraphics.SetOutput}
\alias{spssRGraphics.SetGraphicsLabel}
\description{
  Functions to display R graphics in the IBM® SPSS® Statistics Viewer. 
  These functions have no effect when running IBM SPSS Statistics from R.
}
\usage{
spssRGraphics.Submit(filename)
spssRGraphics.SetOutput(switch)
spssRGraphics.SetGraphicsLabel(displaylabel)
}
\arguments{
  \item{filename}{A character string specifying the path to a graphics 
    file. It cannot be NULL, an empty string, or contain only blank characters. 
	The supported formats for the graphic file are: png, jpg and bmp.
    }
  \item{switch}{A character string that controls whether graphical output from R is 
	displayed in the IBM SPSS Statistics Viewer. Can only be "ON" or "OFF". If "ON" is specified, 
	graphical output from R will be displayed in the Viewer. Otherwise, graphical 
	output from R will be not displayed. The default is "ON".
    }
  \item{displaylabel}{A character string specifying the outline title. This setting applies to all displayed R graphics. Omitting the argument displaylabel will reset the label to the default value of "RGraphic".
    }
}
\value{
}
\details{
spssRGraphics.Submit displays a specified R graphic in the Viewer.\cr

spssRGraphics.SetOutput controls whether graphical output from R is displayed 
in the Viewer.\cr

spssRGraphics.SetGraphicsLabel sets the outline title for graphical output from R.
}
\references{
}
\seealso{
  \code{\link{extension}},
  \code{\link{external}},
  \code{\link{spssdata}},
  \code{\link{spssdictionary}},
  \code{\link{spsspkg}},
  \code{\link{spsspivottable}},
  \code{\link{spssxmlworkspace}},
  \code{\link{TextBlock}}
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

© Copyright IBM Corp. 1989, 2015
}
\keyword{classes}
\keyword{methods}
