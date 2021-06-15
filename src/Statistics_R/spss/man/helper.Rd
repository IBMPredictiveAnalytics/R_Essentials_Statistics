\name{spsspkg.helper}
\alias{spsspkg.helper}
\alias{help}
\title{Display extension command help}
\description{
Display html help for an extension command in the default browser.
}
\usage{
spsspkg.helper(folder, helpfile="markdown.html")
}

\arguments{
  \item{folder}{The name of the folder that contains the HTML file. The argument must be enclosed in quotation marks and the specified folder must be at the root of a location on the R library path, as specified by .libPaths().}
  \item{helpfile}{Optional argument that specifies the name of the HTML file. The default is markdown.html. The HTML file must be at the root of the specified folder.}
}
\details{
This function does not work if IBM® SPSS® Statistics is in distributed mode.
}
\value{
None
}

\examples{
spsspkg.helper("STATS_HECKMAN_REGR")


© Copyright IBM Corp. 1989, 2021
}

\keyword{documentation}


