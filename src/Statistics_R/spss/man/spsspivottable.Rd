\name{spsspivottable}
\title{Displays R data as a IBM SPSS Statistics pivot table}
\alias{spsspivottable}
\alias{spsspivottable.Display}
\alias{spsspkg.StartProcedure}
\alias{spsspkg.EndProcedure}
\description{
  Displays R data such as a data frame, matrix, or table as an IBM® SPSS® Statistics pivot table.
}
\usage{
spsspivottable.Display(x,
                       title=default.title,templateName=default.templateName, 
                       outline=default.outline,caption=default.caption, 
                       isSplit=TRUE,
                       rowdim=default.rowdim,coldim=default.coldim,
                       hiderowdimtitle = TRUE,hiderowdimlabel = FALSE,
                       hidecoldimtitle = TRUE,hidecoldimlabel = FALSE,
                       rowlabels = NULL,collabels = NULL,
                       format = default.format)
spsspkg.StartProcedure(pName)
spsspkg.EndProcedure()
}
\arguments{
  \item{x}{The data to be displayed as a IBM SPSS Statistics pivot table. It may be a data 
    frame, matrix, table, or any R object that can be converted to a data frame. 
    }
  \item{title}{\code{default.title} or a non-empty character title for the pivot
          table. The default title is "Rtable". 
    }
  \item{templateName}{\code{default.title} or a non-empty character string 
    specifying an OMS table subtype for the table. Must start with a letter 
    and be shorter than 64  bytes. The default is "Rtable". Unless you are 
    routing this pivot table with OMS or need to write an autoscript for this 
    table, you do not need to specify a value. 
    }
  \item{outline}{\code{default.outline} or a character string that specifies a
    title for the table that appears in the outline pane of the Viewer. NULL 
    will be regarded as an empty character string.  If the outline argument is 
    NULL or an empty character string, the Viewer item for the table will be 
    placed one level deeper than the root item for the output containing the 
    table. The default outline is "". 
    }
  \item{caption}{\code{default.caption} or a character string that specifies a 
    caption for the table. A NULL or empty caption will be ignored. The default 
    caption is NULL. 
    }
  \item{isSplit}{\code{FALSE} or a logical to indicate whether or not to enable 
    split file processing for the table. TRUE for split file processing. If 
    omitted, TRUE is used. 
    }
  \item{rowdim}{\code{default.rowdim} or a character string that specifies the 
    row dimension label. The default is "row". 
    }
  \item{coldim}{\code{default.coldim} or a character string that specifies the 
    column dimension label. The default is "column". 
    }
  \item{hiderowdimtitle}{\code{TRUE} or a logical to indicate whether or not 
    to hide the row dimension title.  
    }
  \item{hiderowdimlabel}{\code{FALSE} or a logical to indicate whether or not to hide
    the row dimension label. 
    }
  \item{hidecoldimtitle}{\code{TRUE} or a logical to indicate whether or not to hide
    the column dimension title. 
    }
  \item{hidecoldimlabel}{\code{FALSE} or a logical to indicate whether or not to hide
    the column dimension label. 
    }
  \item{rowlabels}{\code{NULL} or a numeric or character vector that specifies
    the row category labels. If the argument is given, it must match the 
    structure of x.  For example, suppose that x is a data frame with 3 rows. 
    The length of rowlabels must be 3. If the argument is omitted, the row 
    names of x will be used. If x does not have row names, default row labels 
    will be used. The default row label is "row" followed by the row 
    index--for example, "row1", "row2" and so on. If a numeric vector is 
    provided, the row labels will have the format specified by the argument 
    "format". 
    }
  \item{collabels}{\code{NULL} or a numeric or character vector that specifies
    the column category labels. If the argument is given, it must match the 
    structure of x.  For example, suppose that x is a data frame with 3 
    columns. The length of collabels must be 3. If the argument is omitted, 
    the column names of x will be used. If x does not have column names, 
    default column labels will be used. The default column label is "col" 
    followed by the column index--for example, "col1", "col2" and so on. If a 
    numeric vector is provided, the column labels will have the format 
    specified by the argument "format". 
    }
  \item{format}{A character string or integer that specifies the numeric
    format. The value can be one of the formats provided below (as a string) 
    or the corresponding integer code. The valid values are:\cr
           formatSpec.Coefficient          0 \cr
           formatSpec.CoefficientSE        1 \cr
           formatSpec.CoefficientVar       2 \cr
           formatSpec.Correlation          3 \cr
           formatSpec.GeneralStat          4 \cr
           formatSpec.Count                6 \cr
           formatSpec.Percent              7 \cr
           formatSpec.PercentNoSign        8 \cr
           formatSpec.Proportion           9 \cr
           formatSpec.Significance         10 \cr
           formatSpec.Residual             11 \cr
 
    The default format is formatSpec.GeneralStat. 
    }
  \item{pName}{\code{procName} or a non-empty character procedure name for the pivot
          table. The default pName is "R". 
    }
}
\value{
}
\details{
spsspivottable.Display displays an R data structure (data frame,
matrix, table, or any R object that can be converted to a 
data frame) as a pivot table. The R data structure will be
converted to a data frame before sending it to IBM SPSS Statistics.
spsspkg.StartProcedure starts a procedure. spsspkg.EndProcedure
should be called after calling spsspkg.StartProcedure.
spsspkg.EndProcedure ends a procedure. spsspkg.StartProcedure
should be called before calling spsspkg.EndProcedure.
}
\references{
}
\seealso{
  \code{\link{spssdictionary}},
  \code{\link{spssxmlworkspace}},
  \code{\link{spssdata}},
  \code{\link{BasePivotTable}},
  \code{\link{CellText.VarName}},
  \code{\link{CellText.VarValue}},
  \code{\link{CellText.String}},
  \code{\link{CellText.Number}},
  \code{\link{spss.Dimension}}.
}
\examples{
## These examples must be run from IBM SPSS Statistics. They cannot be run from R.

*Example 1 -- display a data frame as a pivot table.
get file="/data/demo.sav".
begin program R.
var1 <- c(1,2,3)
var2 <- c(1,2,3)
var3 <- c(1,2,3)
x <- data.frame(var1,var2,var3)
row.names(x) <- letters[1:3]
names(x) <- LETTERS[1:3]
spsspivottable.Display(x,title="dataframeTable",rowdim="row", coldim="column")
end program.

*Example 2 -- display a matrix as a pivot table.
get file="/data/demo.sav".
begin program R.
x <- as.matrix(1:10)
spsspivottable.Display(x,,rowdim="row", coldim="column", caption = "my caption", format=formatSpec.Percent)
end program.

*Example 3 -- display an R table as a pivot table.
get file="/data/demo.sav".
begin program R.
t <- table(rpois(5,5))
spsspivottable.Display(t)
end program.

*Example 4 -- generate multiple pivot tables under the same outline.
get file="/data/demo.sav".
begin program R.
var1 <- c(1,2,3)
var2 <- c(1,2,3)
var3 <- c(1,2,3)
x <- data.frame(var1,var2,var3)
row.names(x) <- letters[1:3]
names(x) <- LETTERS[1:3]
spsspkg.StartProcedure()
spsspivottable.Display(x,title="dataframeTable1",outline = "outline1", rowdim="row", coldim="column")
spsspivottable.Display(x,title="dataframeTable2",outline = "outline2", rowdim="row", coldim="column")
spsspivottable.Display(x,title="dataframeTable3",outline = "outline1", rowdim="row", coldim="column")
spsspkg.EndProcedure()
end program.

© Copyright IBM Corp. 1989, 2011
}
\keyword{classes}
\keyword{methods}
