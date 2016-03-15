\name{CellText.Number}
\docType{class}
\alias{class:CellText.Number}
\alias{CellText.Number}
\alias{CellText.Number-class}
\alias{initialize,CellText.Number-method}

\alias{CellText.toNumber,CellText.Number-method}
\alias{CellText.toString,CellText.Number-method}

\concept{CellText.toNumber}
\concept{CellText.toString}

\title{A Simple Class for Number }
\description{ A class of objects designed to store the numeric variable.
   It could be used in the cell values, dimension values, category values or
   layer values of Pivot table. The CellText.Number consists of 2 objects. A
   data slot containing type, value and format if any. The other slot is index
   for indexing the object. }
\section{Creating Objects}{
   \code{spss.CellText.Number(value, formatSpec=NULL, VarIndex=NULL)}
}
\section{Slots}{
   \describe{
      \item{\code{data}:}{a list containing type, value and format of the stored numeric variable.}
      \item{\code{index}:}{a numeric variable to record the index of the CellText.Number object.}
   }
}
\section{Methods}{
   \describe{
      \item{\code{CellText.toNumber(CellText.Number)}:}{Used to access numeric value of the Object.}
      \item{\code{CellText.toString(CellText.Number)}:}{Convert the numeric value to character variable, and returned the character.}
  }
}
\seealso{
   \code{\link{spsspivottable}}
   
© Copyright IBM Corp. 1989, 2011
}
\details{
  This class is used to store the numeric variable to represent in the
  pivot table. It could be used in the cell values, dimension values,
  category values, and layer values.
  }
\keyword{methods}
\keyword{classes}
