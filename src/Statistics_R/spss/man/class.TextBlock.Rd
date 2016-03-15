\name{TextBlock}
\docType{class}
\alias{class:TextBlock}
\alias{TextBlock}
\alias{TextBlock-class}
\alias{initialize,TextBlock-method}

\alias{TextBlock.append,TextBlock-method}

\concept{TextBlock.append}

\title{A Class for TextBlock}

\description{ A class of objects designed to creates and populates a text block 
    item in the Viewer.  }
\section{Creating Objects}{
   \code{spss.TextBlock(name, content, outline)}
}
\section{Slots}{
   \describe{
      \item{\code{name}:}{A string that specifies the name of this item in the 
        outline pane of the Viewer.}
      \item{\code{content}:}{A string that specifies the text, which may include
        the escape sequence to specify line breaks.}
      \item{\code{outline}:}{A string that specifies a title for this item that 
        appears in the outline pane of the Viewer.}
      \item{\code{skip}:}{A numeric number to indicate the number of new lines to skip.}  
   }
}
\section{Methods}{
   \describe{
      \item{\code{TextBlock.append(object,line,skip = 1)}:}{Appends lines to an 
        existing text block. The argument line is a string that specifies the 
        text, which may include the escape sequence to specify line breaks. 
        The optional argument skip specifies the number of new lines to create 
        when appending the specified line. The default is 1 and results in 
        appending the single specified line. Integers greater than 1 will result
        in blank lines preceding the appended line. For example, specifying 
        skip=3 will result in two blank lines before the appended line.}
  }
}
\seealso{
   \code{\link{spsspivottable}}
}
\details{
  An instance of the TextBlock class can only be used within a StartProcedure-EndProcedure
  block.
  }
\examples{
## These examples must be run from IBM® SPSS® Statistics. They cannot be run from R.

*Example -- Using text block.
BEGIN PROGRAM R.
spsspkg.StartProcedure("mycompany.com.demo")
textBlock = spss.TextBlock("Text block name", "A single line of text.")
spsspkg.EndProcedure()
END PROGRAM.

© Copyright IBM Corp. 1989, 2011
}   
\keyword{methods}
\keyword{classes}
