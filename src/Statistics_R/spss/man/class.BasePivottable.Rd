\name{BasePivotTable}
\docType{class}
\alias{class:BasePivotTable}
\alias{BasePivotTable}
\alias{BasePivotTable-class}
\alias{initialize,BasePivotTable-method}

\alias{BasePivotTable.SetDefaultFormatSpec,BasePivotTable-method}
\alias{BasePivotTable.GetDefaultFormatSpec,BasePivotTable-method}
\alias{BasePivotTable.GetCellValue,BasePivotTable-method}
\alias{BasePivotTable.SetCellValue,BasePivotTable-method}
\alias{BasePivotTable.Insert,BasePivotTable-method}
\alias{BasePivotTable.Append,BasePivotTable-method}
\alias{BasePivotTable.SetCategories,BasePivotTable-method}
\alias{BasePivotTable.SetCellsByRow,BasePivotTable-method}
\alias{BasePivotTable.SetCellsByColumn,BasePivotTable-method}
\alias{BasePivotTable.HideTitle,BasePivotTable-method}
\alias{BasePivotTable.Footnotes,BasePivotTable-method}
\alias{BasePivotTable.TitleFootnotes,BasePivotTable-method}
\alias{BasePivotTable.OutlineFootnotes,BasePivotTable-method}
\alias{BasePivotTable.DimensionFootnotes,BasePivotTable-method}
\alias{BasePivotTable.CategoryFootnotes,BasePivotTable-method}

\concept{BasePivotTable.SetDefaultFormatSpec}
\concept{BasePivotTable.GetDefaultFormatSpec}
\concept{BasePivotTable.GetCellValue}
\concept{BasePivotTable.SetCellValue}
\concept{BasePivotTable.Insert}
\concept{BasePivotTable.Append}
\concept{BasePivotTable.SetCategories}
\concept{BasePivotTable.SetCellsByRow}
\concept{BasePivotTable.SetCellsByColumn}
\concept{BasePivotTable.HideTitle}
\concept{BasePivotTable.Footnotes}
\concept{BasePivotTable.TitleFootnotes}
\concept{BasePivotTable.OutlineFootnotes}
\concept{BasePivotTable.DimensionFootnotes}
\concept{BasePivotTable.CategoryFootnotes}

\title{Class for IBM SPSS Statistics Pivot Table}
\description{ The class BasePivotTable Provides the ability to create custom 
    pivot tables that can be displayed in the IBM® SPSS® Statistics Viewer or written 
    to an external file using the IBM SPSS Statistics Output Management System. }
\section{Creating Objects}{
   \code{spss.BasePivotTable(title,templateName,outline="",isSplit=TRUE,caption="")}
}
\section{Slots}{
   \describe{
      \item{\code{title}:}{A string that specifies the title that appears with 
        the table. Each table associated with a set of output (as specified in a
         StartProcedure-EndProcedure block) should have a unique title. Multiple
          tables within a given procedure can, however, have the same value of 
          the title argument as long as they have different values of the 
          outline argument. }
      \item{\code{templateName}:}{A string that specifies the OMS (Output 
        Management System) table subtype for this table. It must begin with a 
        letter and have a maximum of 64 characters. Unless you are routing this 
        pivot table with OMS, you will not need to keep track of this value, 
        although you do have to provide a value that meets the stated 
        requirements. }
      \item{\code{isSplit}:}{A logical value specifies whether to enable split 
        processing when creating pivot tables from data that have splits. Split 
        file processing refers to whether results from different split groups 
        are displayed in separate tables or in the same table but grouped by 
        split, and is controlled by the SPLIT FILE command. }
      \item{\code{dims}:}{A list of spss.Dimension objects that stores all the 
        dimension categories objects, which are the row dimension and column 
        dimension of pivot table.}
      \item{\code{cells}:}{A list of CellText objects, which are the cell value 
        of Pivot table. }                                                                         
      \item{\code{caption}:}{A string that specifies a table caption.}
      \item{\code{index}:}{A numeric variable to record the index of the 
        BasePivotTable object.}
   }
}
\section{Methods}{
   \describe{
      \item{\code{BasePivotTable.SetDefaultFormatSpec(object,formatSpec,varIndex=NULL)}:}{
      Sets the default format for CellText.Number objects. The argument object 
      is a reference to the associated BasePivotTable object. The argument 
      formatSpec is of the form formatSpec. The argument varIndex is the index 
      of a variable in the active dataset whose format is used to determine 
      details of the resulting format. varIndex is only used for, and required 
      by, the following subset of formats: Mean, Variable, StdDev, Difference, 
      and Sum. Index values represent position in the active dataset, starting 
      with 0 for the first variable in file order.}
      \item{\code{BasePivotTable.GetDefaultFormatSpec(object)}:}{Returns the 
      default format for CellText.Number objects. The argument object is a 
      reference to the associated BasePivotTable object. The function returns a
      single value or a vector with two elements depending on the type of format. 
      When a single value is returned, it is the integer code associated with 
      the format. For formats with codes 5 (Mean), 12 (Variable), 13 (StdDev), 
      14 (Difference), and 15 (Sum), the result is a 2-element vector whose 
      first element is the integer code and whose second element is the index of
       the variable in the active dataset used to determine details of the 
       resulting format.}
      \item{\code{BasePivotTable.GetCellValue(object,categories)}:}{Gets the 
      value of the specified cell. The argument object is a reference to the 
      associated BasePivotTable object. The argument categories is the list of
      the category values that specifies the cell¡ªone value for each of the 
      dimensions in the pivot table. Category values must be specified as 
      CellText objects (one of CellText.Number, CellText.String, CellText.VarName,
       or CellText.VarValue).}  
      \item{\code{BasePivotTable.SetCellValue(object,categories, cell)}:}{Sets 
      the value of the specified cell. The argument object is a reference to the
      associated BasePivotTable object. The argument categories is the list of
      the category values that specifies the cell¡ªone value for each of the 
      dimensions in the pivot table. The argument cell is the cell value. 
      Category values and the cell value must be specified as CellText objects 
      (one of CellText.Number, CellText.String, CellText.VarName, or 
      CellText.VarValue).}     
      \item{\code{BasePivotTable.Insert(object,i,place,dimName,hideName=FALSE, hideLabels=FALSE)}:}{
      Inserts row, column, and layer dimensions into a pivot table. You use this
      method, or the Append method, to create the dimensions associated with a 
      custom pivot table. The argument object is a reference to the associated 
      BasePivotTable object. The argument i specifies the position within the 
      dimensions of that type (row, column, or layer). The first position has 
      index 1 and defines the innermost dimension of that type in the displayed
      table. Successive integers specify the next innermost dimension and so 
      on. The argument place specifies the type of dimension: 
      Dimension.Place.row for a row dimension, Dimension.Place.column for a column
      dimension, and Dimension.Place.layer for a layer dimension. The argument
      dimName is a string that specifies the name used to label this dimension 
      in the displayed table. Each dimension must have a unique name. The argument
      hideName specifies whether the dimension name is hidden¡ªby default, it 
      is displayed. Use hideName=TRUE to hide the name. The argument hideLabels 
      specifies whether category labels for this dimension are hidden¡ªby 
      default, they are displayed. Use hideLabels=TRUE to hide category labels.}   
      \item{\code{BasePivotTable.Append(object,place,dimName,hideName=FALSE, hideLabels=FALSE)}:}{
      Appends row, column, and layer dimensions to a pivot table. You use this 
      method, or the Insert method, to create the dimensions associated with a 
      custom pivot table. The argument object is a reference to the associated 
      BasePivotTable object. The argument place specifies the type of dimension:
      Dimension.Place.row for a row dimension, Dimension.Place.column for a column
      dimension, and Dimension.Place.layer for a layer dimension. The argument 
      dimName is a string that specifies the name used to label this dimension 
      in the displayed table. Each dimension must have a unique name. The argument 
      hideName specifies whether the dimension name is hidden¡ªby default, it is
      displayed. Use hideName=TRUE to hide the name. The argument hideLabels 
      specifies whether category labels for this dimension are hidden¡ªby default,
      they are displayed. Use hideLabels=TRUE to hide category labels.
      }
      \item{\code{BasePivotTable.SetCategories(object,dim,categories)}:}{
      Sets categories for the specified dimension. The argument object is a 
      reference to the associated BasePivotTable object. The argument dim is a
      reference to the dimension object for which categories are to be set. 
      Dimensions are created with the Append or Insert method. The argument 
      categories is a single value or a list of unique values, each of which is 
      a CellText object (one of CellText.Number, CellText.String, CellText.VarName,
      or CellText.VarValue).
      } 
      \item{\code{BasePivotTable.SetCellsByRow(object,rowlabels,cells)}:}{
      Sets cell values for the row specified by a set of categories, one for each
      row dimension. The argument object is a reference to the associated 
      BasePivotTable object. The argument rowlabels specifies the set of categories
      that defines the row¡ªa single value or a list. The argument cells is a list
      of cell values. Row categories and cell values must be specified as CellText
      objects (one of CellText.Number, CellText.String, CellText.VarName, or 
      CellText.VarValue).
      } 
      \item{\code{BasePivotTable.SetCellsByColumn(object,collabels,cells)}:}{
      Sets cell values for the column specified by a set of categories, one for 
      each column dimension. The argument object is a reference to the associated
      BasePivotTable object. The argument collabels specifies the set of categories
      that defines the column¡ªa single value or a list. The argument cells is a
      list of cell values. Column categories and cell values must be specified as
      CellText objects (one of CellText.Number, CellText.String, CellText.VarName,
      or CellText.VarValue).
      } 
      \item{\code{BasePivotTable.HideTitle(object)}:}{
      Used to hide the title of a pivot table. By default, the title is shown. The
      argument object is a reference to the associated BasePivotTable object.
      } 
      \item{\code{BasePivotTable.Footnotes(object, categories, footnotes)}:}{
      Used to add a footnote to a table cell. The argument object is a reference
      to the associated BasePivotTable object. The argument categories is a list
      of categories specifying the cell for which a footnote is to be added. Each
      element in the listmust be a CellText object (one of CellText.Number, 
      CellText.String, CellText.VarName, or CellText.VarValue). The argument 
      footnotes is a string specifying the footnote.
      }     
      \item{\code{BasePivotTable.TitleFootnotes(object, footnotes)}:}{
      Used to add a footnote to the table title. The argument object is a reference
      to the associated BasePivotTable object. The argument footnotes is a string
      specifying the footnote.
      }    
      \item{\code{BasePivotTable.DimensionFootnotes(object, dimPlace, dimName, footnotes)}:}{
      Used to add a footnote to a dimension. The argument object is a reference 
      to the associated BasePivotTable object. The argument dimPlace specifies 
      the type of dimension, using one member from a set of built-in object 
      properties: Dimension.Place.row for a row dimension, Dimension.Place.column
      for a column dimension, and Dimension.Place.layer for a layer dimension.
      The argument dimName is the string that specifies the name given to this 
      dimension when it was created by the Append or Insert method. The argument
      footnotes is a string specifying the footnote.
      }   
      \item{\code{BasePivotTable.CategoryFootnotes(object, dimPlace, dimName, category, footnotes)}:}{
      Used to add a footnote to a specified category. The argument object is a 
      reference to the associated BasePivotTable object. The argument dimPlace 
      specifies the dimension type associated with the category, using one member
      from a set of built-in object properties: Dimension.Place.row for a row 
      dimension, Dimension.Place.column for a column dimension, and Dimension.Place.layer
      for a layer dimension. The argument dimName is the string that specifies 
      the dimension name associated with the category. This is the name specified
      when the dimension was created by the Append or Insert method. The argument
      category specifies the category and must be a CellText object (one of 
      CellText.Number, CellText.String, CellText.VarName, or CellText.VarValue).
      The argument footnotes is a string specifying the footnote.
      }                                                           
  }
}
\seealso{
   \code{\link{spsspivottable}}
   \code{\link{CellText.VarName}}
   \code{\link{CellText.VarValue}}
   \code{\link{CellText.String}}
   \code{\link{CellText.Number}}
   \code{\link{spss.Dimension}}
}
\details{
    If you only need a pivot table with a single column dimension and a single 
    row dimension, you may want to use the much simpler spsspivottable.Display 
    function.
  }
\examples{
## These examples must be run from IBM SPSS Statistics. They cannot be run from R.

*Example 1 -- Using cell values in expressions.
begin program R.
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
end program.

*Example 2 -- Setting cell values by row.
begin program R.
spsspkg.StartProcedure("MyProcedure")
table = spss.BasePivotTable("Table Title","OMS table subtype")
rowdim=BasePivotTable.Append(table,Dimension.Place.row,"row dimension")
coldim=BasePivotTable.Append(table,Dimension.Place.column,"column dimension")
row_cat1=spss.CellText.String("first row")
row_cat2=spss.CellText.String("second row")
col_cat1=spss.CellText.String("first column")
col_cat2=spss.CellText.String("second column")
BasePivotTable.SetCategories(table,rowdim,list(row_cat1,row_cat2))
BasePivotTable.SetCategories(table,coldim,list(col_cat1,col_cat2))
BasePivotTable.SetCellsByRow(table,row_cat1,list(spss.CellText.Number(11),
spss.CellText.Number(12)))
BasePivotTable.SetCellsByRow(table,row_cat2,list(spss.CellText.Number(21),
spss.CellText.Number(22)))
spsspkg.EndProcedure()
end program.

*Example 3 -- Setting row dimension category footnotes.
begin program R.
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
BasePivotTable.CategoryFootnotes(table,Dimension.Place.row,"row dimension",
row_cat1,"A category footnote")
spsspkg.EndProcedure()
end program.

© Copyright IBM Corp. 1989, 2011
}  
\keyword{methods}
\keyword{classes}
