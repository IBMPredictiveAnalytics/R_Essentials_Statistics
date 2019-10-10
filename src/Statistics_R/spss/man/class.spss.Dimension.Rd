\name{spss.Dimension}
\docType{class}
\alias{class:spss.Dimension}
\alias{spss.Dimension}
\alias{spss.Dimension-class}
\alias{initialize,spss.Dimension-method}

\title{Class for storing a dimension of a pivot table}
\description{The spss.Dimension class stores information for a dimension in a pivot
    table. 
    }
\section{Creating Objects}{
   \code{new("spss.Dimension",dimName,place,i,hideName, hideLabels)}
}
\section{Slots}{
   \describe{
      \item{\code{dimName}:}{a string that specifies the name used to label this
        dimension in the displayed table. Each dimension must have a unique name.}
      \item{\code{place}:}{A numeric value that specifies the type of dimension:
        Dimension.Place.row for a row dimension, Dimension.Place.column for a column
        dimension, and Dimension.Place.layer for a layer dimension. }
      \item{\code{i}:}{A numeric value that specifies the position within the 
        dimensions of that type (row, column, or layer). The first position has 
        index 1 and defines the innermost dimension of that type in the displayed
        table.}
      \item{\code{hideName}:}{A boolean value that specifies whether the dimension
       name is hidden--by default, it is displayed.}
      \item{\code{hideLabels}:}{A boolean value that specifies whether category labels
       for this dimension are hidden--by default, they are displayed. }
      \item{\code{tableAttr}:}{A list containing the basic pivot table information
       to which the pivot table belongs. It includes outline, title, templateName and 
       isSplit.}
      \item{\code{categories}:}{A list containing the categories that this dimension contains. }
      \item{\code{current}:}{The category object associated with this dimension.}  
      \item{\code{index}:}{The index of the BasePivotTable object.} 
   }
}
\seealso{
   \code{\link{spsspivottable}}
   \code{\link{BasePivotTable}}
   \code{\link{CellText.VarName}}
   \code{\link{CellText.VarValue}}
   \code{\link{CellText.String}}
   \code{\link{CellText.Number}}
}
\details{spss.Dimension objects are generated from BasePivotTable.Append and BasePivotTable.Insert. 
   You can set categories for a dimension with BasePivotTable.SetCategories. 
  }
\examples{
spsspkg.StartProcedure()
table = spss.BasePivotTable("Table Title","OMS table subtype")
rowdim=BasePivotTable.Append(table,Dimension.Place.row,"row dimension")
coldim=BasePivotTable.Append(table,Dimension.Place.column,"column dimension")
row_cat1 = spss.CellText.String("first row")
row_cat2 = spss.CellText.String("second row")
col_cat1 = spss.CellText.String("first column")
col_cat2 = spss.CellText.String("second column")
BasePivotTable.SetCategories(table,rowdim,list(row_cat1,row_cat2))
BasePivotTable.SetCategories(table,coldim,list(col_cat1,col_cat2))
BasePivotTable.SetCellValue(table,list(row_cat1,col_cat1),spss.CellText.Number(11))
cellValue = CellText.toNumber(BasePivotTable.GetCellValue(table,list(row_cat1,col_cat1)))
BasePivotTable.SetCellValue(table,list(row_cat2,col_cat2),spss.CellText.Number(2*cellValue))
spsspkg.EndProcedure()


© Copyright IBM Corp. 1989, 2015
}
\keyword{methods}
\keyword{classes}
