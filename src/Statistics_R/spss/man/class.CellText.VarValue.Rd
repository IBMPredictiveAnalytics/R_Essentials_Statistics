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

\title{A Simple Class for Variable Value}
\description{ A class of objects designed to specify that a category or cell in 
    a pivot table is to be treated as a variable value. The CellText.VarValue 
    consists of 2 objects. A data slot containing type ,VarID which records the 
    variable index in Statistics data set and value which is a number (for a 
    numeric variable) or string (for a string variable) representing the value 
    of the CellText object. The other slot is index for indexing the object. }
\section{Creating Objects}{
   \code{spss.CellText.VarValue(index, value)}
}
\section{Slots}{
   \describe{
      \item{\code{data}:}{a list containing type, VarID which records the variable
       index in Statistics data set and "value" which is a number (for a numeric
        variable) or string (for a string variable) representing the value of 
        the CellText object. The VarID values represent position in the active 
        dataset, starting with 0 for the first variable in file order. }
      \item{\code{index}:}{a numeric variable to record the index of the 
      CellText.VarValue object.}
   }
}
\section{Methods}{
   \describe{
      \item{\code{CellText.toNumber(CellText.VarValue)}:}{It's not been implemented.}
      \item{\code{CellText.toString(CellText.VarValue)}:}{It's not been implemented.}
  }
}
\seealso{
   \code{\link{spsspivottable}}

© Copyright IBM Corp. 1989, 2011
}
\details{
  This class is used to specify that a category or cell in a pivot table is to be
  treated as a variable value. CellText.VarValue objects honor display settings 
  for variable values in pivot tables (values, labels, or both). The argument 
  index is the index value of the variable. Index values represent position in 
  the active dataset, starting with 0 for the first variable in file order. The 
  argument value is a number (for a numeric variable) or string (for a string variable)
  representing the value of the CellText object.
  }
\keyword{methods}
\keyword{classes}
