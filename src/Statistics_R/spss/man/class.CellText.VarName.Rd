\name{CellText.VarName}
\docType{class}
\alias{class:CellText.VarName}
\alias{CellText.VarName}
\alias{CellText.VarName-class}
\alias{initialize,CellText.VarName-method}

\alias{CellText.toNumber,CellText.VarName-method}
\alias{CellText.toString,CellText.VarName-method}

\concept{CellText.toNumber}
\concept{CellText.toString}

\title{A simple class for variable names used in pivot tables}
\description{ A class of objects designed to store variable names that are used in pivot tables.  }
\section{Creating Objects}{
    \code{spss.CellText.VarName(index)}
	
    \var{index} -- The index of the variable whose name is to be stored. Index values represent position in the active dataset, starting with 0 for the first variable in file order.  
}
\section{Slots}{
   \describe{
      \item{\code{data}:}{contains the index value (varID) of the associated variable.}
   }
}
\seealso{
   \code{\link{spsspivottable}},
   \code{\link{BasePivotTable}},
   \code{\link{CellText.Number}} 
   \code{\link{CellText.String}},
   \code{\link{CellText.VarValue}}

© Copyright IBM Corp. 1989, 2021
}
\details{
  This class is used to store variable names that are then used as cell values, dimension values, category values or
  layer values of a pivot table. CellText.VarName objects honor display settings for variable names in
  pivot tables (names, labels, or both).
  }
\keyword{methods}
\keyword{classes}
