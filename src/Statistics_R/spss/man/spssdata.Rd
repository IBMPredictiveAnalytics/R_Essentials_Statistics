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
                         asList=FALSE )
                         
spssdata.GetSplitDataFromSPSS(variables=NULL, row.label=NULL, 
                              keepUserMissing = FALSE, missingValueToNA = FALSE, 
                              factorMode = "none", rDate = "none",
                              dateVar = NULL)

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
  \item{missingValueToNA}{\code{FALSE} or TRUE specifying whether to return NA 
    or NaN regarding missing value returned from IBM SPSS Statistics.
    }  
  \item{factorMode}{If returned variable 
    is nonimal or ordidal category dictionary, user could specify the form of 
    factor they want to get. If specifying "none", the category variable will not
    return as factor(except for string value). if specifying "levels", 
    it will return data values as factor, if specifying "labels" it will return
    data labels as factor. default is "none".
    }
  \item{rDate}{ User could specify how 
    to return the data time value by choosing different rDate. for "none", the 
    date will be returned as the second count from 1582-10-14:00:00:00 till now;
    for "POSIXct" the date will be returned as POSIXct object;
    for "POSIXlt", the date will be returned as POSIXlt object.
    Default value is "none"
    }
  \item{dateVar}{\code{NULL} to specify which variables will be chosen return 
    the rDate format if those are date time variable. It could be Null or a 
    vector of integers specifying indices of variables in the IBM SPSS Statistics 
    active dataset that will be retrieved (index values represent position in 
    the dataset, starting with 0 for the first variable in file order). If the 
    argument is NULL, all variables in the dataset will be retrieved.
    }      
  \item{asList}{\code{FALSE} to specifies whether the result from GetDataFromSPSS
    is a list. The argument is boolean with a default of FALSE, which specifies 
    that the result is returned as a data frame. If asList is TRUE the result is 
    a list with an element for each retrieved variable. Setting asList to TRUE is
    most useful when retrieving large datasets since the list structure requires 
    less memory than the default data frame structure.
    }  
  \item{datasetName}{A character string specifying the name of a IBM SPSS Statistics dataset 
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
  \item{categoryDictionary}{\code{NULL} A list to record the value label information of the
     categorical variable. It is used to support handling for categorical 
     variables retrieved from IBM SPSS Statistics and factor variables written from R to IBM SPSS 
     Statistics. A categoryDictionary could be constructed in the following way:
          catedic0 <- list(levels=c("m","f"),labels=c("Male","Female"))
          catedic1 <- list(levels=c(0,1,2,3),labels=c("missing","clergial","custodian","manager"))
          catedic  <- list(name = c("gender","jobcat"), dictionary = list(catedic0, catedic1))
     However, if users want to get categorial variables from IBM SPSS Statistics, it
      is strongly recommended to get the information using function: 
          spssdictionary.GetCategoricalDictionaryFromSPSS(variables = NULL) 
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
spssdata.GetDataFromSPSS gets data from the IBM SPSS Statistics active dataset, and returns 
an R data frame. If the active dataset has splits, this function only 
retrieves data in the first split group. To iterate over split groups, use 
spssdata.GetSplitDataFromSPSS. GetDataFromSPSS cannot be called while a  
data connection for reading from split files (implicitly created by 
GetSplitDataFromSPSS) is open.\cr

spssdata.GetSplitDataFromSPSS starts a IBM SPSS Statistics data connection implicitly if 
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
names of all open IBM SPSS Statistics datasets in the current session. Excluding the
 those not opened but defined datasets declared by DATASET DECLARE \cr

spssdata.CloseDataConnection closes the IBM SPSS Statistics data connection if any.\cr

spssdata.SetDataToSPSS sets data to the specified IBM SPSS Statistics dataset.\cr

spssdata.GetFileHandles returns a list of currently defined file handles. Each 
item in the list consists of the following three elements: the name of the file 
handle; the path associated with the file handle; and the encoding, if any, 
specified for the file handle. The string value "None" is returned for the encoding 
if no encoding is specified. File handles are created with the FILE HANDLE command.\cr
}
\references{
}
\seealso{
  \code{\link{spssdictionary}},
  \code{\link{spssxmlworkspace}},
  \code{\link{spsspivottable}}.
}
\examples{
## These examples must be run from IBM SPSS Statistics. They cannot be run from R.

*example 1 -- get filtered data from IBM SPSS Statistics.
get file="/data/Employee data.sav".

USE ALL.
COMPUTE filter_$=(jobcat = 3).
VARIABLE LABEL filter_$ 'jobcat = 3 (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

begin program R.
x <- spssdata.GetDataFromSPSS(variables = c(1,4,5,8),cases = 4,row.label=0)
print(x)
print(summary(x))
end program.

*example 2 -- get split data from IBM SPSS Statistics.
get file="/data/Employee data.sav".

SORT CASES BY gender .
SPLIT FILE
  SEPARATE BY gender .

begin program R.

while(!spssdata.IsLastSplit())
{
    x <- spssdata.GetSplitDataFromSPSS(variables = c(0,1,4,5,8))
    print(summary(x))
}
spssdata.CloseDataConnection()
end program.

*example 3 -- set data to IBM SPSS Statistics

get file="/data/demo.sav".

* Read the dictionary of the active dataset into R.
* Set the modified dictionary to a new IBM SPSS Statistics dataset.
* Set 2 cases to the new dataset.

begin program R.
x <- spssdictionary.GetDictionaryFromSPSS(variables = c(0,4))
spssdictionary.SetDictionaryToSPSS("abc",x)

case1 <- c(3,4)
case2 <- c(5,6)
x <- data.frame(case1,case2)
spssdata.SetDataToSPSS("abc",x)
end program.

* Perform any operations on the new dataset in IBM SPSS Statistics.
* ...

* End the DataStep.
begin program R.
spssdictionary.EndDataStep()
end program.

* example 4 -- Deal with categorical variable with factor.
get file="/data/Employee data.sav".
begin program r.
dict <- spssdictionary.GetDictionaryFromSPSS("id TO jobcat")
casedata <- spssdata.GetDataFromSPSS(variables="id TO jobcat", factorMode="labels")
catedata <- spssdictionary.GetCategoricalDictionaryFromSPSS(variables ="id TO jobcat")
if(spssdictionary.CategoryDictionaryValid(catedata))
{
    spssdictionary.SetDictionaryToSPSS("results2",dict, categoryDictionary=catedata)
    spssdata.SetDataToSPSS("results2",casedata, categoryDictionary=catedata)
}
spssdictionary.EndDataStep()
end program.

* example 5 -- Get the currently defined file handles
get file="/data/Employee data.sav".
begin program r.
handles <- spssdata.GetFileHandles()
end program.

© Copyright IBM Corp. 1989, 2011
}
\keyword{classes}
\keyword{methods}
