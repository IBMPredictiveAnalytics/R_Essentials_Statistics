\name{spssdata}
\title{Exchange data between IBM SPSS Statistics and R}
\alias{spssdata}
\alias{spssdata.GetDataFromSPSS}
\alias{spssdata.GetSplitDataFromSPSS}
\alias{spssdata.CloseDataConnection}
\alias{spssdata.GetSplitVariableNames}
\alias{spssdata.IsLastSplit}
\alias{spssdata.GetCaseCount}
\alias{spssdata.GetDataSetList}
\alias{spssdata.GetOpenedDataSetList}
\alias{spssdata.SetDataToSPSS}
\alias{spssdata.GetFileHandles}
\description{
  Reads data from IBM® SPSS® Statistics into R, and writes data from R to IBM SPSS Statistics. Data is passed
  as a data frame.
}
\usage{
spssdata.GetDataFromSPSS(variables=NULL, cases=NULL, 
                         row.label=NULL, keepUserMissing = FALSE,
                         missingValueToNA = FALSE, factorMode = "none", 
                         rDate = "none", dateVar= NULL,
                         asList=FALSE, orderedContrast="contr.treatment")
                         
spssdata.GetSplitDataFromSPSS(variables=NULL, row.label=NULL, 
                              keepUserMissing = FALSE, missingValueToNA = FALSE, 
                              factorMode = "none", rDate = "none",
                              dateVar = NULL, orderedContrast="contr.treatment")

spssdata.CloseDataConnection()

spssdata.GetSplitVariableNames()

spssdata.IsLastSplit()

spssdata.GetCaseCount()

spssdata.GetDataSetList()

spssdata.GetOpenedDataSetList()

spssdata.SetDataToSPSS(datasetName,x, categoryDictionary = NULL)

spssdata.GetFileHandles()
}
\arguments{
  \item{variables}{\code{NULL} or a vector of integers specifying indices of 
    variables in the IBM SPSS Statistics active dataset that will be retrieved (index values 
    represent position in the dataset, starting with 0 for the first variable 
    in file order). If the argument is NULL, all variables in the dataset will 
    be retrieved.
    }
  \item{cases}{\code{NULL} or a single integer specifying the number of cases 
    in the IBM SPSS Statistics active dataset that will be retrieved. If the argument is NULL, 
    all cases in the dataset will be retrieved if there are no split groups, 
    or, all cases in the first split group will be retrieved if there are 
    splits. If the argument is greater than the number of cases in the dataset 
    (or the first split group), a warning "No more data." will be issued. 
    }
  \item{row.label}{\code{NULL} or a single integer indicating a variable index. 
    Case values of this variable will be the row labels of the retrieved 
    R data frame. 
    }
  \item{keepUserMissing}{\code{FALSE} or TRUE specifying whether to convert 
    user-missing values to an R system missing value. If keepUserMissing 
    is FALSE, user-missing values for numeric variables will be converted 
    to NaN, and user-missing values for string variables will be converted 
    to NA. The default is FALSE.
    }
  \item{missingValueToNA}{\code{FALSE} or TRUE specifying whether missing values of numeric variables are 
  converted to the R NA value. The default, FALSE, specifies that missing values (system and user) of numeric variables are converted to the R NaN value. 
    }  
  \item{factorMode}{Specifies whether categorical variables from IBM SPSS Statistics(variables with a measurement level of nominal or ordinal) are converted to R factors. The value "none" is the default and specifies that categorical variables are not converted to factors. The value "levels" specifies that categorical variables are converted to factors whose levels are the values that occur in the data. The value "labels" specifies that categorical variables are converted to factors whose levels are the value labels of the variables. Values in the data for which value labels do not exist have a level equal to the value itself. Value labels whose associated value does not occur in the data are included as empty factor levels. Ordinal variables are converted to ordered factors and nominal variables are converted to unordered factors. 
    }
  \item{rDate}{Specifies how variables in dateVar, with date or datetime formats, are converted to R date/time objects. The value "none" is the default and specifies that no conversion will be done. The value "POSIXct" specifies to convert to R POSIXct objects and "POSIXlt" specifies to convert to R POSIXlt objects.
    }
  \item{dateVar}{Specifies a set of IBM SPSS Statistics variables with date or datetime formats to convert to R date/time objects. The argument supports the same options for specifying variables as described for the variables argument. If the argument is omitted and rDate specifies a POSIXt object, then all variables with date or datetime formats are converted.
    }      
  \item{asList}{Specifies whether the result from GetDataFromSPSS
    is a list. The argument is boolean with a default of FALSE, which specifies 
    that the result is returned as a data frame. If asList is TRUE the result is 
    a list with an element for each retrieved variable. Setting asList to TRUE is
    most useful when retrieving large datasets since the list structure requires 
    less memory than the default data frame structure.
    }  
  \item{datasetName}{A character string specifying the name of an IBM SPSS Statistics dataset 
    to which the R data will be written. The dataset must have been created by 
    spssdictionary.SetDictionaryToSPSS. 
    }
  \item{x}{An R object whose contents will be written to IBM SPSS Statistics as case data. 
    The object will be converted to a data frame before passing it to IBM SPSS Statistics. 
    If the argument cannot be converted to a data frame, an error will be 
    thrown. The data in x must match the definition of the associated IBM SPSS Statistics 
    dictionary. For example, if the first variable of the associated IBM SPSS Statistics 
    dictionary is defined as a numeric variable, the first column of x must be
    numeric or something that can be converted to numeric. Otherwise, an error
    will be thrown.
    }
  \item{orderedContrast}{Specifies a contrast function to associate with the ordered factors created from any ordinal variables retrieved from IBM SPSS Statistics. It only applies (to ordinal variables) in the case that factorMode is set to "levels" or "labels". You can specify any valid contrast function, as a quoted string, such as "contr.helmert". The default is "contr.treatment". 
    }
  \item{categoryDictionary}{Specifies the name of a category dictionary created with the spssdictionary.GetCategoricalDictionaryFromSPSS function. Category dictionaries are for use when retrieving categorical variables (variables with a measurement level of "nominal" or "ordinal") into labelled R factors, with the intention of writing those factors to a new dataset.
    }    
}
\value{
spssdata.GetDataFromSPSS returns a data frame.\cr
spssdata.GetSplitDataFromSPSS returns a data frame.\cr
spssdata.GetSplitVariableNames returns a character vector.\cr
spssdata.IsLastSplit returns a logical.\cr
spssdata.GetCaseCount returns an integer.\cr
spssdata.GetDataSetList returns a character vector.\cr
spssdata.GetOpenedDataSetList returns a character vector. \cr
spssdata.GetFileHandles returns a list of currently defined file handles. \cr
}

\details{
spssdata.GetDataFromSPSS gets data from the IBM SPSS Statistics active dataset and returns 
an R data frame. If the active dataset has splits, this function only 
retrieves data in the first split group. To iterate over split groups, use 
spssdata.GetSplitDataFromSPSS. GetDataFromSPSS cannot be called while a  
data connection for reading from split files (implicitly created by 
GetSplitDataFromSPSS) is open.\cr

spssdata.GetSplitDataFromSPSS starts an IBM SPSS Statistics data connection implicitly if 
there is none. This function is used to retrieve split 
data, group by group. Each call returns the case data for the next split group 
from the active dataset. The function spssdata.IsLastSplit indicates whether 
the current split is the last split. When finished retrieving split data, 
CloseDataConnection must be called to close the data connection.\cr

spssdata.GetSplitVariableNames returns a character vector that includes the 
names of any split variables in the IBM SPSS Statistics active dataset.\cr

spssdata.IsLastSplit returns a logical indicating whether the current split is 
the last split.\cr

spssdata.GetCaseCount returns an integer that indicates the number of cases in 
the IBM SPSS Statistics active dataset.\cr

spssdata.GetDataSetList returns a character vector that indicates the names of 
all defined IBM SPSS Statistics datasets in the current session.\cr

spssdata.GetOpenedDataSetList returns a character vector that indicates the 
names of all open IBM SPSS Statistics datasets in the current session. The function returns '*' for the active dataset if it is unnamed. 
Datasets that have been declared (with DATASET DECLARE) but not yet opened are NOT included in the list. 
To obtain the list of all defined datasets, use the GetDataSetList function.\cr

spssdata.CloseDataConnection closes a data connection created by the GetSplitDataFromSPSS function. 
This function only applies to data connections created to handle IBM SPSS Statistics datasets containing split groups. 
CloseDataConnection should be called when done reading from such datasets. \cr

spssdata.SetDataToSPSS sets data to the specified IBM SPSS Statistics dataset.\cr

spssdata.GetFileHandles returns a list of currently defined file handles. Each 
item in the list consists of the following three elements: the name of the file 
handle; the path associated with the file handle; and the encoding, if any, 
specified for the file handle. The string value "None" is returned for the encoding 
if no encoding is specified. File handles are created with the FILE HANDLE command.\cr
}
\references{
}
\seealso{\code{\link{extension}},
  \code{\link{external}},
  \code{\link{spssdictionary}},
  \code{\link{spsspkg}},
  \code{\link{spsspivottable}},
  \code{\link{spssRGraphics}},
  \code{\link{spssxmlworkspace}},
  \code{\link{TextBlock}}
}
\examples{
## These examples are intended to be run from R, with R driving IBM SPSS Statistics.

* Example 1 -- get filtered data from IBM SPSS Statistics.

spsspkg.Submit(c("get file='/data/Employee data.sav'.",
                 "USE ALL.",
                 "COMPUTE filter_$=(jobcat = 3).",
                 "VARIABLE LABEL filter_$ 'jobcat = 3 (FILTER)'.",
                 "VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.",
                 "FORMAT filter_$ (f1.0).",
                 "FILTER BY filter_$.",
                 "EXECUTE."))
x <- spssdata.GetDataFromSPSS(variables = c(1,4,5,8),cases = 4,row.label=0)
print(x)
print(summary(x))

* Example 2 -- get split data from IBM SPSS Statistics.

spsspkg.Submit(c("get file='/data/Employee data.sav'.",
                 "SORT CASES BY gender.",
                 "SPLIT FILE SEPARATE BY gender."))
while(!spssdata.IsLastSplit())
{
    x <- spssdata.GetSplitDataFromSPSS(variables = c(0,1,4,5,8))
    print(summary(x))
}
spssdata.CloseDataConnection()


* Example 3 -- set data to IBM SPSS Statistics

spsspkg.Submit("get file='/data/demo.sav'.")

* Read the dictionary of the active dataset into R.
* Set the modified dictionary to a new IBM SPSS Statistics dataset.
* Set 2 cases to the new dataset.

x <- spssdictionary.GetDictionaryFromSPSS(variables = c(0,4))
spssdictionary.SetDictionaryToSPSS("abc",x)
case1 <- c(3,4)
case2 <- c(5,6)
x <- data.frame(case1,case2)
spssdata.SetDataToSPSS("abc",x)
spssdictionary.EndDataStep()


* Example 4 -- Create a new dataset based on the dictionary of a dataset with categorical variables, preserving the value labels

spsspkg.Submit("get file='/data/Employee data.sav'.")
dict <- spssdictionary.GetDictionaryFromSPSS("id TO jobcat")
casedata <- spssdata.GetDataFromSPSS(variables="id TO jobcat", factorMode="labels")
catdict <- spssdictionary.GetCategoricalDictionaryFromSPSS(variables ="id TO jobcat")
spssdictionary.SetDictionaryToSPSS("results2",dict, categoryDictionary=catdict)
spssdata.SetDataToSPSS("results2",casedata, categoryDictionary=catdict)
spssdictionary.EndDataStep()


© Copyright IBM Corp. 1989, 2015
}
\keyword{classes}
\keyword{methods}
