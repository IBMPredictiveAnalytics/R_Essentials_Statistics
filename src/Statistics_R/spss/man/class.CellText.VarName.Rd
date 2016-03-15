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

\title{A Simple Class for Variable Name}
\description{ A class of objects designed to store the variable name.
   It could be used in the cell values, dimension values, category values or
   layer values of Pivot table. The CellText.VarName consists of 2 objects. A
   data slot containing type and VarID which records the variable index in 
   Statistics' data set. The other slot is index for indexing the object. }
\section{Creating Objects}{
   \code{spss.CellText.VarName(index)}
}
\section{Slots}{
   \describe{
      \item{\code{data}:}{a list containing type and VarID, which is the index 
      value of the variable. Index values represent position in the active 
      dataset, starting with 0 for the first variable in file order. }
      \item{\code{index}:}{a numeric variable to record the index of the CellText.VarName object.}
   }
}
\section{Methods}{
   \describe{
      \item{\code{CellText.toNumber(CellText.VarName)}:}{It's not implemented.}
      \item{\code{CellText.toString(CellText.VarName)}:}{It's not implemented.}
  }
}
\seealso{
   \code{\link{spsspivottable}}

© Copyright IBM Corp. 1989, 2011
}
\details{
  This class is used to specify that a category or cell in a pivot table is to be treated
  as a variable name. CellText.VarName objects honor display settings for variable names in
  pivot tables (names, labels, or both). The argument is the index value of the variable. Index values
  represent position in the active dataset, starting with 0 for the first variable in file order.
  }
\keyword{methods}
\keyword{classes}
