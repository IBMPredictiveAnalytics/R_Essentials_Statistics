\name{TextBlock}
\docType{class}
\alias{class:TextBlock}
\alias{TextBlock}
\alias{TextBlock-class}
\alias{initialize,TextBlock-method}

\alias{TextBlock.append,TextBlock-method}

\concept{TextBlock.append}

\title{Create text blocks in output}

\description{ A class of objects designed to create and populate a text block 
    item in output.}
\section{Creating Objects}{
   \code{spss.TextBlock(name, content, outline)}
   
   \var{name} -- a string that specifies the name of the text block. 
 
   \var{content} -- a string that specifies the content of the text block, which may include the escape sequence \n to specify line breaks.
   
   \var{outline} -- an optional string that specifies a title for this item. The item for the text block itself will be placed one level deeper than the item for this title. If outline is omitted, the item for the text block will be placed one level deeper than the root item for the output containing the text block.
   }
}
\section{Slots}{
   \describe{
      \item{\code{name}:}{The name of the text block.}
      \item{\code{content}:}{The content of the text block.}
      \item{\code{outline}:}{The outline title, if any, for the text block.}
   }
}
\section{Methods}{
   \describe{
      \item{\code{TextBlock.append(object,line,skip = 1)}:}{Appends lines to an 
        existing text block. The argument line is a string that specifies the 
        text, which may include the escape sequence \n to specify line breaks. 
        The optional argument skip specifies the number of new lines to create 
        when appending the specified line. The default is 1 and results in 
        appending the single specified line. Integers greater than 1 will result
        in blank lines preceding the appended line. For example, specifying 
        skip=3 will result in two blank lines before the appended line.}
  }
}
\seealso{
  \code{\link{extension}},
  \code{\link{external}},
  \code{\link{spssdata}},
  \code{\link{spssdictionary}},
  \code{\link{spsspkg}},
  \code{\link{spsspivottable}},
  \code{\link{spssRGraphics}},
  \code{\link{spssxmlworkspace}}
}
\details{
  An instance of the TextBlock class can only be used within a StartProcedure-EndProcedure
  block.
  }
\examples{
spsspkg.StartProcedure("mycompany.com.demo")
textBlock = spss.TextBlock("Text block name", "A single line of text.")
spsspkg.EndProcedure()

© Copyright IBM Corp. 1989, 2015
}   
\keyword{methods}
\keyword{classes}
