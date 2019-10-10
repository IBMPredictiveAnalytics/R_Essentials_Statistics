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

\title{A simple class for numeric values in pivot tables }
\description{ A class of objects designed to store numeric values that are used in pivot tables. 
   }
\section{Creating Objects}{
   \code{spss.CellText.Number(value, formatSpec=NULL, VarIndex=NULL)}
   
   \var{value} -- The numeric value. You can pass an R POSIXt date/time object to this argument.
   
   \var{formatSpec} -- \code{NULL} or a value of the form formatSpec.format that specifies the numeric format. See the help for  \code{\link{spsspivottable}} for a list of supported formats.
   
   \var{VarIndex} -- \code{NULL} or the index of a variable in the active dataset whose format is used to determine details of the resulting format. varIndex is only used in conjunction with formatSpec and is required when specifying one of the following formats: Mean, Variable, StdDev, Difference, and Sum. Index values represent position in the active dataset, starting with 0 for the first variable in file order.  
}
\section{Slots}{
   \describe{
      \item{\code{data}:}{contains the value and format of the stored numeric value.}
   }
}
\section{Methods}{
   \describe{
      \item{\code{CellText.toNumber(CellText.Number)}:}{Used to access the numeric value of the object.}
      \item{\code{CellText.toString(CellText.Number)}:}{Converts the numeric value of the object to a string.}
  }
}
\seealso{
   \code{\link{spsspivottable}},
   \code{\link{BasePivotTable}},
   \code{\link{CellText.String}},
   \code{\link{CellText.VarName}},
   \code{\link{CellText.VarValue}}    
   
© Copyright IBM Corp. 1989, 2015
}

\details{
   This class is used to define numeric values for cells, dimension values, category values or
   layer values of a pivot table. 
  }
\keyword{methods}
\keyword{classes}
