\name{spssxmlworkspace}
\title{Access the IBM SPSS Statistics XML workspace}
\alias{spssxmlworkspace}
\alias{spssxmlworkspace.CreateXPathDictionary}
\alias{spssxmlworkspace.GetHandleList}
\alias{spssxmlworkspace.EvaluateXPath}
\alias{spssxmlworkspace.DeleteXmlWorkspaceObject}
\description{
  Supplies a set of methods to enable R programs to access the IBM® SPSS® Statistics XML 
  workspace.
}
\usage{
spssxmlworkspace.CreateXPathDictionary(handle)
spssxmlworkspace.GetHandleList()
spssxmlworkspace.EvaluateXPath(handle, context, expression)
spssxmlworkspace.DeleteXmlWorkspaceObject(handle)
}
\arguments{
  \item{handle}{A character string specifying a handle used to identify a DOM 
    in the XML workspace. It cannot be NULL, an empty string, or contain 
    only blank characters. 
    }
  \item{context}{A character string defining the XPath context for the 
    expression. Set context to /dictionary for a dictionary DOM and /outputTree 
    for an output DOM. See the XPath standard for more information about 
    context. 
    }
  \item{expression}{A character string specifying the remainder of the XPath
    expression. 
    }
}
\value{
spssxmlworkspace.GetHandleList returns a character vector.\cr
spssxmlworkspace.EvaluateXPath returns a character vector.\cr
}
\details{
spssxmlworkspace.CreateXPathDictionary creates an XPath dictionary DOM for the 
IBM SPSS Statistics active dataset. It represents a static copy of the active dataset's 
dictionary and will not be updated if the active dataset changes. The contents 
of the dictionary DOM can be accessed with the EvaluateXPath method using XPath 
expressions. Repeated calls will create a new XML workspace handle. If the 
handle already exists, it will be replaced and a warning will be issued 
indicating the reuse of an existing XML workspace handle. Documentation for the 
output schema and the dictionary schema is available from the IBM SPSS Statistics Help system.\cr

spssxmlworkspace.GetHandleList gets a list of current handles in the XML 
workspace. These are available for use with EvaluateXpath.\cr

spssxmlworkspace.EvaluateXPath evaluates an XPath expression against a 
specified XPath DOM and returns the result as a character vector. Two kinds of 
DOM's can exist in the XML workspace; dictionary DOM's created by the 
CreateXPathDictionary function and output DOM's created by OMS (the Output 
Management System). If the result is a numeric, character, or logical value, 
the vector will contain the character form of that value. If the result is a 
set of nodes, the vector will contain the character form of those nodes. 
The character form of these outputs is defined in the XPath standard. An 
exception indicating an invalid XPath expression will be thrown if the context 
or expression specify an invalid search condition. Documentation for the output 
schema and the dictionary schema is available from the IBM SPSS Statistics Help system.\cr

spssxmlworkspace.DeleteXmlWorkspaceObject deletes the XML workspace object 
(XPath dictionary DOM or OMS output DOM) with the specified handle.\cr
}
\references{
}
\seealso{
  \code{\link{spssdictionary}},
  \code{\link{spssdata}},
  \code{\link{spsspivottable}}.
}
\examples{
## This example must be run from IBM SPSS Statistics. It cannot be run from R.

get file="/data/demo.sav".
begin program R.
handle <- "cars"
spssxmlworkspace.CreateXPathDictionary(handle)
context <- "/dictionary"
xpath <- "variable/@name"
result <- spssxmlworkspace.EvaluateXPath(handle,context,xpath)
cat("test R\n")
cat("result => ", result)

spssxmlworkspace.CreateXPathDictionary("abc")
spssxmlworkspace.CreateXPathDictionary("abcd")

out <- spssxmlworkspace.GetHandleList()
cat("\nhandle list => ", out)

spssxmlworkspace.DeleteXmlWorkspaceObject("abcd")
out <- spssxmlworkspace.GetHandleList()
cat("\nhandle list => ", out)

spssxmlworkspace.DeleteXmlWorkspaceObject("abc")
out <- spssxmlworkspace.GetHandleList()
cat("\nhandle list => ", out)
end program.

© Copyright IBM Corp. 1989, 2011
}
\keyword{classes}
\keyword{methods}
