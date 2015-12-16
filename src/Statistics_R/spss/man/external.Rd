\name{external}
\title{Functions for running IBM SPSS Statistics from R}
\alias{external}
\alias{spsspkg.StartStatistics}
\alias{spsspkg.StopStatistics}
\alias{spsspkg.Submit}
\alias{spsspkg.IsUTF8mode}
\alias{spsspkg.SetStatisticsOutput}
\alias{spsspkg.IsXDriven}
\alias{spsspkg.IsBackendReady}
\description{
Functions to run IBM® SPSS® Statistics from R. When SPSS Statistics is run from R, a new instance of the SPSS Statistics processor is started without an associated instance of the SPSS Statistics client. 
}
\usage{
spsspkg.StartStatistics()
spsspkg.StopStatistics()
spsspkg.Submit(commands)
spsspkg.SetStatisticsOutput(output)
spsspkg.IsXDriven()
spsspkg.IsUTF8mode()
spsspkg.IsBackendReady()
}
\arguments{
  \item{commands}{A character string or a vector of character strings that resolves
    to one or more complete SPSS Statistics commands. If the argument is a string,
    it may contain new-line characters. String arguments are split at the new-line
    characters and the resulting list of lines is submitted. 
    }
  \item{output}{The value of the argument is a quoted string: "ON" to display output 
    from SPSS Statistics in the R console, "OFF" to suppress the display of output from SPSS Statistics. 
    The default is "ON".
    }
}
\details{
Use library(spssstatistics) to load the spss Statistics package for R.

spsspkg.StartStatistics starts SPSS Statistics from R. The function has no effect if a session is already running. spsspkg.StartStatistics has no effect when running R from SPSS Statistics (within BEGIN PROGRAM R-END PROGRAM blocks). Note that the spsspkg.Submit function automatically starts SPSS Statistics.

spsspkg.StopStatistics stops SPSS Statistics so that it cannot process commands 
from R. Any subsequent spsspkg.Submit functions that restart SPSS Statistics will not have access to the active dataset or to any other session-specific settings (for example, OMS output routing commands) from the previous session. spsspkg.StopStatistics has no effect when running R from SPSS Statistics (within BEGIN PROGRAM R-END PROGRAM blocks).

spsspkg.Submit submits the specified command text to SPSS Statistics for processing. This function 
automatically starts SPSS Statistics if it is not already running. The following commands are not supported by spsspkg.Submit when running SPSS Statistics from R: OUTPUT EXPORT, OUTPUT OPEN and OUTPUT SAVE.

spsspkg.SetStatisticsOutput controls the display of SPSS Statistics output in R. Output from SPSS Statistics is displayed as standard output in the R console. Charts and classification trees are not included in the output. This function has no effect when running R from SPSS Statistics (within BEGIN PROGRAM R-END PROGRAM blocks). 

spsspkg.IsXDriven determines how the SPSS Statistics backend is being run. The function returns TRUE if R is controlling the SPSS Statistics backend, FALSE if SPSS Statistics is controlling the backend.

spsspkg.IsUTF8mode determines whether SPSS Statistics is running in Unicode mode or code page mode. The function returns TRUE if SPSS Statistics is in Unicode mode, FALSE if SPSS Statistics is in code page mode.

spsspkg.IsBackendReady determines whether SPSS Statistics is ready to process commands.
The function returns TRUE when the SPSS Statistics backend is ready, FALSE otherwise. This function is of use only when R is controlling the SPSS Statistics backend. 
}
\value{
None
}
\examples{
spsspkg.StartStatistics()
spsspkg.StopStatistics()
spsspkg.Submit("SHOW VER.")
spsspkg.SetStatisticsOutput("OFF")
spsspkg.IsXDriven()
spsspkg.IsUTF8mode()
spsspkg.IsBackendReady()

© Copyright IBM Corp. 1989, 2015
}
\seealso{\code{\link{spssstatistics}},
  \code{\link{extension}},
  \code{\link{spssdata}},
  \code{\link{spssdictionary}},
  \code{\link{spsspkg}},
  \code{\link{spsspivottable}},
  \code{\link{spssRGraphics}},
  \code{\link{spssxmlworkspace}},
  \code{\link{TextBlock}}
}