\name{CellText.VarValue}
\docType{class}
\alias{class:CellText.VarValue}
\alias{CellText.VarValue}
\alias{CellText.VarValue-class}
\alias{initialize,CellText.VarValue-method}

\alias{CellText.toNumber,CellText.VarValue-method}
\alias{CellText.toString,CellText.VarValue-method}

\concept{CellText.toNumber}
\concept{CellText.toString}

\title{A simple class for variable values used in pivot tables}
\description{ A class of objects designed to store variable values that are used in pivot tables.}
\section{Creating Objects}{
   \code{spss.CellText.VarValue(index, value)}

   \var{index} -- the index of the variable whose value is to be stored. Index values represent position in the active dataset, starting with 0 for the first variable in file order.   
   
   \var{value} -- the value of the variable. The value is numeric for a numeric variable and string for a string variable.
}
\section{Slots}{
   \describe{
      \item{\code{data}:}{contains the variable value and index value (varID) of the associated variable.}
   }
}

\seealso{
   \code{\link{spsspivottable}},
   \code{\link{BasePivotTable}},
   \code{\link{CellText.Number}} 
   \code{\link{CellText.String}},
   \code{\link{CellText.VarName}}

© Copyright IBM Corp. 1989, 2015
}
\details{
  This class is used to store variable values that are then used as cell values, dimension values, category values or
  layer values of a pivot table. CellText.VarValue objects honor display settings 
  for variable values in pivot tables (values, labels, or both).
  }
\keyword{methods}
\keyword{classes}
