\name{CellText.String}
\docType{class}
\alias{class:CellText.String}
\alias{CellText.String}
\alias{CellText.String-class}
\alias{initialize,CellText.String-method}

\alias{CellText.toNumber,CellText.String-method}
\alias{CellText.toString,CellText.String-method}

\concept{CellText.toNumber}
\concept{CellText.toString}

\title{A simple class for string values in pivot tables }
\description{ A class of objects designed to store string values that are used in pivot tables. }
\section{Creating Objects}{
   \code{spss.CellText.String(value)}

   \var{value} -- The string value.
}

\section{Methods}{
   \describe{
      \item{\code{CellText.toString(CellText.String)}:}{Returns the value of the string stored in the object.}
      \item{\code{CellText.toNumber(CellText.String)}:}{Returns a numeric representation of the stored string value if the string value is a character representation of a numeric value.}
  }
}
\seealso{
   \code{\link{spsspivottable}},
   \code{\link{BasePivotTable}},
   \code{\link{CellText.Number}},
   \code{\link{CellText.VarName}},
   \code{\link{CellText.VarValue}}  

© Copyright IBM Corp. 1989, 2015
}
\details{
   This class is used to define string values for cells, dimension values, category values or
   layer values of a pivot table.
  }
\keyword{methods}
\keyword{classes}
