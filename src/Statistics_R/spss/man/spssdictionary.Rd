\name{spssdictionary}
\title{Exchange IBM SPSS Statistics dictionary information between IBM SPSS Statistics and R}
\alias{spssdictionary}
\alias{spssdictionary.GetDictionaryFromSPSS}
\alias{spssdictionary.GetDetailedDictionaryFromSPSS}
\alias{spssdictionary.GetUserMissingValues}
\alias{spssdictionary.GetValueLabels}
\alias{spssdictionary.GetVariableAttributeNames}
\alias{spssdictionary.GetVariableAttributes}
\alias{spssdictionary.GetDataFileAttributeNames}
\alias{spssdictionary.GetDataFileAttributes}
\alias{spssdictionary.GetMultiResponseSetNames}
\alias{spssdictionary.GetMultiResponseSet}
\alias{spssdictionary.IsWeighting}
\alias{spssdictionary.GetWeightVariable}
\alias{spssdictionary.CreateSPSSDictionary}
\alias{spssdictionary.GetCategoricalDictionaryFromSPSS}
\alias{spssdictionary.CategoryDictionaryValid}
\alias{spssdictionary.EditCategoricalDictionary}
\alias{spssdictionary.SetDictionaryToSPSS}
\alias{spssdictionary.SetUserMissing}
\alias{spssdictionary.SetValueLabel}
\alias{spssdictionary.SetVariableAttributes}
\alias{spssdictionary.SetDataFileAttributes}
\alias{spssdictionary.SetMultiResponseSet}
\alias{spssdictionary.SetActive}
\alias{spssdictionary.CloseDataset}
\alias{spssdictionary.EndDataStep}
\description{
  Reads IBM® SPSS® Statistics dictionary information into R. Creates new IBM SPSS Statistics datasets 
  based on a new dictionary or modifications to an existing dictionary. 
  Dictionaries are represented as a data frame.
}
\usage{
spssdictionary.GetDictionaryFromSPSS(variables=NULL)
spssdictionary.GetDetailedDictionaryFromSPSS(variables=NULL)
spssdictionary.GetUserMissingValues(variable)
spssdictionary.GetValueLabels(variable)
spssdictionary.GetVariableAttributeNames(variable)
spssdictionary.GetVariableAttributes(variable, attrName)
spssdictionary.GetDataFileAttributeNames()
spssdictionary.GetDataFileAttributes(attrName)
spssdictionary.GetMultiResponseSetNames()
spssdictionary.GetMultiResponseSet(mrsetName)

spssdictionary.IsWeighting()
spssdictionary.GetWeightVariable()

spssdictionary.CreateSPSSDictionary(...)

spssdictionary.GetCategoricalDictionaryFromSPSS(variables = NULL)
spssdictionary.CategoryDictionaryValid(categoryDictionary)
spssdictionary.EditCategoricalDictionary(categoryDictionary, newName = categoryDictionary$name)

spssdictionary.SetDictionaryToSPSS(datasetName,x, categoryDictionary = NULL, hidden=FALSE)
spssdictionary.SetUserMissing(datasetName,variable,
                              format=missingFormat["Discrete"],missings)
                                
spssdictionary.SetValueLabel(datasetName,variable,values,labels)
spssdictionary.SetVariableAttributes(datasetName,variable,...)
spssdictionary.SetDataFileAttributes(datasetName,...)
spssdictionary.SetMultiResponseSet(datasetName,mrsetName,mrsetLabel="",
                                   codeAs,countedValue=NULL,elementaryVars)

spssdictionary.SetActive(datasetName)
spssdictionary.CloseDataset(datasetName)
spssdictionary.EndDataStep()
}
\arguments{
  \item{variables}{\code{NULL} or a vector of integers specifying indices of 
    variables in the IBM SPSS Statistics active dataset that will be retrieved (index values 
    represent position in the dataset, starting with 0 for the first variable 
    in file order). If the argument is NULL, all variables in the dataset will 
    be retrieved. 
    }
  \item{variable}{ An integer specifying the index of a variable in the   
    active dataset. 
    }
  \item{attrName}{ A character string specifying the attribute name.
    Variable attribute names can be retrieved with 
    spssdictionary.GetVariableAttributeNames.
    Data file attribute names can be retrieved with 
    spssdictionary.GetDataFileAttributeNames.
    }
  \item{datasetName}{ A character string specifying the name of a IBM SPSS Statistics 
    dataset. A new IBM SPSS Statistics dataset can be created with 
    spssdictionary.SetDictionaryToSPSS. The names of all open datasets 
    can be retrieved with spssdata.GetDataSetList. 
    }
  \item{x}{ A data frame specifying the dictionary to be set to IBM SPSS Statistics. It must 
    be the result of calling either spssdictionary.GetDictionaryFromSPSS or
    spssdictionary.CreateSPSSDictionary, but can also be a modified version of 
    those results. 
    }
  \item{format}{One of the following: 
    missingFormat["Discrete"] (discrete values),\cr
    missingFormat["Range"] (a range of numeric values),\cr
    missingFormat["Range Discrete"] (a range of numeric values and a single 
                                     discrete numeric value),\cr
    or an integer specifying a missing value format. Available integer values 
    are:\cr
          -3 -- A range of numeric values and a single discrete numeric value.\cr
          -2 -- A range of numeric values. \cr
           0 -- No missing values.\cr
           1 -- A single discrete missing value.\cr
           2 -- Two discrete missing values.\cr
           3 -- Three discrete missing values.\cr
    }
  \item{missings}{ A numeric or character vector specifying the missing values. 
    Only the first 3 elements are used. If the number of elements in the vector 
    is less than 3, it will be padded with NaN values for a numeric vector and 
    NA values for a character vector. 
    }
  \item{values}{ A numeric or character vector specifying the values for which 
    value labels will be set. Values must match the variable type. For example, 
    there will be an error if a character value is specified for a  
    numeric variable. 
    }
  \item{labels}{ A numeric or character vector specifying the value labels
    corresponding to the elements of "values", one label for each value. 
    }
  \item{...}{ For spssdictionary.CreateSPSSDictionary, these arguments are of 
    either the form value or tag = value. Component names are created based on 
    the tag (if present) or the reparsed argument itself. Each of these 
    arguments must be a vector specifying dictionary information for a 
    single variable. The components of the vector are as follows (component 
    names are optional) and in the presented order:\cr
      varName   -- The variable name as a character string.\cr
      varLabel  -- The variable label as a character string. \cr
      varType   -- The variable type ; 0 for numeric variables, and an 
                  integer equal to the defined length for string 
                  variables. \cr
      varFormat -- A character string specifying the display format 
                  of the variable. The string consists of 3 parts: 
                  the format type, the format width, and optionally the 
                  number of decimal digits. For example, varFormat "A5" 
                  means that the format type is "A", the format width is 
                  5, and there are no decimal digits. varFormat "F8.2" 
                  means that the format type is "F", the format width is 
                  8, and there are two decimal digits. The valid format 
                  types are:\cr
                   A        -- Standard characters.\cr
                   AHEX     -- Hexadecimal characters.\cr
                   COMMA    -- Numbers with commas as grouping symbol and 
                               period as decimal indicator. For example: 
                               1,234,567.89.\cr
                   DOLLAR   -- Numbers with a leading dollar sign($), commas as 
                               grouping symbol, and period as decimal indicator. 
                               For example: $1,234,567.89.\cr
                   F        -- Standard numeric.\cr
                   IB       -- Integer binary.\cr
                   PIBHEX   -- Hexadecimal of PIB (positive integer binary).\cr
                   P        -- Packed decimal.\cr
                   PIB      -- Positive integer binary.\cr
                   PK       -- Unsigned packed decimal.\cr
                   RB       -- Real binary.\cr
                   RBHEX    -- Hexadecimal of RB.\cr
                   Z        -- Zoned decimal.\cr
                   N        -- Restricted numeric.\cr
                   E        -- Scientific notation.\cr
                   DATE     -- International date of the general form 
                               dd-mmm-yyyy\cr
                   TIME     -- Time of the general form hh:mm:ss.ss.\cr
                   DATETIME -- Date and time of the general form dd-mmm-yyyy
                               hh:mm:ss.ss.\cr
                   ADATE    -- American date of the general form mm/dd/yyyy.\cr
                   JDATE    -- Julian date of the general form yyyyddd.\cr
                   DTIME    -- Days and time of the general form dd hh:mm:ss.ss.\cr
                   WKDAY    -- Day of the week.\cr
                   MONTH    -- Month.\cr
                   MOYR     -- Month and year.\cr
                   QYR      -- Quarter and year of the general form qQyyyy.\cr
                   WKYR     -- Week and year.\cr
                   PCT      -- Percentage sign after numbers.\cr
                   DOT      -- Numbers with period as grouping symbol and comma
                              as decimal indicator. For example: 1.234.567,89.\cr
                   CCA      -- custom currency format 1.\cr
                   CCB      -- custom currency format 2.\cr
                   CCC      -- custom currency format 3.\cr
                   CCD      -- custom currency format 4.\cr
                   CCE      -- custom currency format 5.\cr
                   EDATE    -- European date.\cr
                   SDATE    -- Sortable date of the general form yyyy/mm/dd.\cr
      varMeasurementLevel -- A character string specifying the measurement level 
                            of the variable. Valid values are: "nominal", 
                            "ordinal", and "scale".\cr
    
    For spssdictionary.SetVariableAttributes, these arguments are of the form 
    varAttrName = varAttrValue. For example, if ... is (attr1 = 1, attr2 = 2), 
    the specified variable will have a variable attribute named "attr1" with 
    attribute value "1", and a variable attribute named "attr2" with attribute 
    value "2". \cr

    For spssdictionary.SetDataFileAttributes, these arguments are of the form 
    fileAttrName = fileAttrValue. For example, if ... is (attr1 = 1, attr2 = 2), 
    the specified dataset will have a data file attribute named "attr1" with 
    attribute value "1", and a data file attribute named "attr2" with attribute 
    value "2". 
    }
  \item{categoryDictionary}{ A list to record the value label information of the
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
  \item{hidden}{\code{FALSE} or TRUE to specifies whether the Data Editor window 
    associated with the new dataset is hidden. By default, it is displayed. 
    Use hidden=TRUE to hide the associated Data Editor window.    
    }  
  \item{newName}{ A vector or list to assign the new name list of categoryDictionary$name.
     the length of newName must be the same as the length of categoryDictionary$name. 
     each element of name represent the new name replacing the original one, if 
     the corresponding element is assigned as NA, it means the corresponding 
     element in the categoryDictionary$name and categoryDictionary$dictionary 
     will be deleted, see the example 16. 
     }    
  \item{mrsetName}{ A character string specifying the name of the multiple 
    response set. The mrsetName can be up to 63 bytes long. A dollar sign 
    is automatically added to the beginning of the mrsetName if the mrsetName 
    does not start with a dollar sign "$".
    }
  \item{mrsetLabel}{\code{""} or an optional character string specifying the label of the 
    multiple response set. The default value is an empty character string.
    }
  \item{codeAs}{ The variable coding. Must be either "Dichotomies" or 
    "Categories". If the codeAs is "dichotomies", countedValue must be present.
    }
  \item{countedValue}{\code{NULL} or an character string indicating which value 
    you want to have counted if your variables are coded as dichotomies. If your 
    variables are coded as categories, leave the countedValue by default. Numeric 
    input for this argument will be converted to character string with as.character.
    }
  \item{elementaryVars}{ A vector of character specifying two or more variable 
    names that will be included in the response set. Support TO construct. 
    Variable indices will be also accepted instead of variable names. If 
    variables refer to variable names, these names must match case with the 
    IBM SPSS Statistics dictionary. The data type of the multiple response set will be 
    determined with the type of variables in the elementaryVars, so all 
    variables in the elementaryVars must have same data type ¨C all are numeric 
    variables or all are string variables.
    }
}
\value{
spssdictionary.GetDictionaryFromSPSS returns a data frame.\cr
spssdictionary.GetDetailedDictionaryFromSPSS returns a data frame.\cr
spssdictionary.GetUserMissingValues returns a list.\cr
spssdictionary.GetValueLabels returns a character vector.\cr
spssdictionary.GetVariableAttributeNames returns a character vector.\cr
spssdictionary.GetVariableAttributes returns a character vector.\cr
spssdictionary.GetDataFileAttributeNames returns a character vector.\cr
spssdictionary.GetDataFileAttributes returns a character vector.\cr
spssdictionary.GetMultiResponseSetNames returns a character vector.\cr
spssdictionary.GetMultiResponseSet returns a list.\cr

spssdictionary.IsWeighting returns a logical.\cr
spssdictionary.GetWeightVariable returns a character string.\cr

spssdictionary.CreateSPSSDictionary returns a data frame.\cr

spssdictionary.GetCategoricalDictionaryFromSPSS returns a list.\cr
spssdictionary.CategoryDictionaryValid returns a logical.\cr
spssdictionary.EditCategoricalDictionary returns a list.\cr
}
\details{
spssdictionary.GetDictionaryFromSPSS gets basic dictionary information from the 
active dataset and returns it as a data frame. If the argument "variables" 
is provided, only the dictionary information of the specified variables will be 
returned. Each column of the returned data frame contains dictionary 
information for a single variable. The data frame has the following row labels: 
varName, varLabel, varType, varFormat, and varMeasurementLevel.\cr

spssdictionary.GetDetailedDictionaryFromSPSS gets detailed dictionary 
information from the active dataset and returns it as a data frame. If the 
argument "variables" is provided, only the dictionary information of the 
specified variables will be returned. Each column of the returned data frame 
contains dictionary information for a single variable. The data frame has the 
following row labels: varName, varLabel, varType, varFormat, varMeasurementLevel
, varValueLabels, varMissingValues, varAttributes.\cr

spssdictionary.GetUserMissingValues gets the user-missing values of the 
specified variable. It returns a list. The first element in the 
returned list is a character string indicating the format of the missing 
values: "Discrete" for discrete values, "Range Discrete" for a range of values 
and a single discrete value, "Range" for a range of values, or NULL if the 
variable is a string variable. The second element in the list is a 
numeric or character vector indicating the user-missing values for the 
specified variable. Unused elements in this vector have the value NaN or NA. 
For instance, a numeric variable with a single discrete user-missing value 
will have NaN's for the 2nd and 3rd elements of the vector.\cr

spssdictionary.GetValueLabels gets the value labels of the specified variable 
. It returns a list. The first element in the returned list is a 
numeric or character vector that includes the values of the specified variable 
for which labels exist. The second element in the returned list is a character 
vector that includes the value labels of the specified variable, one label for 
each value. If the specified variable has no value labels, both elements in the
returned list are empty vectors.\cr

spssdictionary.GetVariableAttributeNames gets the variable attribute names of 
the specified variable. If the specified variable has no variable 
attributes, an empty vector will be returned.\cr

spssdictionary.GetVariableAttributes gets the variable attribute values of the 
specified variable and attribute.\cr

spssdictionary.GetDataFileAttributeNames gets the data file attribute names  
from the active dataset. If the active dataset has no data file 
attributes, an empty vector will be returned.\cr

spssdictionary.GetDataFileAttributes gets the data file attribute values of the 
specified attribute.\cr

spssdictionary.GetMultiResponseSetNames gets the multiple response set names from 
the active dataset. If the active dataset has no multiple response sets, 
an empty vector will be returned. \cr

spssdictionary.GetMultiResponseSet gets the multiple-response set specifications 
of the specified multiple-response set as a list. The elements in the 
list indicate below specifications of the multiple-response set respectively:\cr
      label \cr
      coded as \cr
      counted value \cr
      data type \cr
      elementary variables \cr 

spssdictionary.IsWeighting indicates whether weighting is in effect for the 
active dataset.  The result is TRUE if weighting is in effect, FALSE 
otherwise.\cr

spssdictionary.GetWeightVariable gets the name of the weight variable 
if weighting is in effect. Otherwise, NULL will be returned.\cr

spssdictionary.CreateSPSSDictionary creates the structure for a new  
dictionary that can be set to IBM SPSS Statistics with SetDictionaryToSPSS. It returns a data 
frame. The generated dictionary is editable until it is set to IBM SPSS Statistics.\cr

spssdictionary.GetCategoricalDictionaryFromSPSS creates the structure categoryDictionary
to record a set of categorical variables (nominal and ordinal). This structure 
is used to write a data.frame containing labeled R factor into IBM SPSS Statistics.\cr

spssdictionary.CategoryDictionaryValid is used to check if the passed categoryDictionary is valid.\cr

spssdictionary.EditCategoricalDictionary is used to change the name of categoryDictionary 
so that the result category dictionary could be used in other task. the reason 
for changing the name is that categoryDictionary$name is used to index the variable 
in the function of spssdictionary.SetDictionaryToSPSS and spssdictionary.SetDataToSPSS.\cr

spssdictionary.SetDictionaryToSPSS sets the dictionary for a new IBM SPSS Statistics dataset 
and creates the dataset with the specified name. The resulting dataset is not 
set to be the active dataset. This function implicitly starts a data 
step, requiring spssdictionary.EndDataStep to be called after finishing all 
data step related jobs. Data step related jobs include calls to the 
following:\cr
      spssdictionary.SetDictionaryToSPSS\cr
      spssdictionary.SetActive\cr
      spssdictionary.CloseDataset\cr 
      spssdictionary.SetUserMissing\cr
      spssdictionary.SetValueLabel\cr
      spssdictionary.SetVariableAttributes\cr
      spssdata.SetDataToSPSS\cr
 
spssdictionary.SetUserMissing sets user-missing values for the specified 
variable. If the specified variable is a string variable, the 
user-missing values must be character strings with length no greater than 
8 bytes.\cr

spssdictionary.SetValueLabel sets value labels for the specified variable.\cr

spssdictionary.SetVariableAttributes sets variable attributes for the specified 
variable.\cr

spssdictionary.SetDataFileAttributes sets data file attributes for the specified 
dataset.\cr

spssdictionary.SetMultiResponseSet sets a multiple response set to the specified 
dataset. Only supports "Variable labels" for "Category Labels Source".\cr

spssdictionary.SetActive makes the specified dataset the active dataset.\cr

spssdictionary.CloseDataset closes the specified dataset. It can only be used 
to close a dataset during the data step in which it was created.\cr

spssdictionary.EndDataStep ends a data step implicitly started by 
SetDictionaryToSPSS.\cr
}
\references{
}
\seealso{
  \code{\link{spssdata}},
  \code{\link{spssxmlworkspace}},
  \code{\link{spsspivottable}}.
}
\examples{
## These examples must be run from IBM SPSS Statistics. They cannot be run from R.

* Example 1 -- get dictionary from IBM SPSS Statistics.
get file="/data/Employee data.sav".
begin program R.
x <- spssdictionary.GetDictionaryFromSPSS(variables = c(0,1,4,5,8))
print(x)
print(summary(x))
end program.

* Example 2 -- get user-missing values from IBM SPSS Statistics.
get file="/data/Employee data.sav".
begin program R.
varNum <- spssdictionary.GetVariableCount()-1
for( i in 0:varNum )
{
    x <- spssdictionary.GetUserMissingValues(variable = i)
    print(x)
}
end program.

* Example 3 -- get variable value labels from IBM SPSS Statistics.
get file="/data/Employee data.sav".
begin program R.
varNum <- spssdictionary.GetVariableCount()-1
for( i in 0:varNum )
{
    x <- spssdictionary.GetValueLabels(variable = i)
    print(x)
}
end program.

* Example 4 -- get variable attributes from IBM SPSS Statistics.
Data List free /x.
Begin data.
1
2
3
End data.

Variable Attributes VARIABLES=x 
  ATTRIBUTE=DemographicVars ('1').

Begin program R.
x <- spssdictionary.GetVariableAttributeNames(variable = 0)
for( attr in x )
{
    y <- spssdictionary.GetVariableAttributes(variable = 0,attrName = attr)
    print(y)
}
End program.

Display attributes.


* Example 5 -- get weight variable from IBM SPSS Statistics.
get file="/data/Employee data.sav".
WEIGHT  BY educ .
begin program R.
x <- spssdictionary.GetWeightVariable()
print(x)
y <- spssdictionary.IsWeighting()
cat("Is weighting on?", y, "\n")
end program.

* Example 6 -- create a dictionary and set it to IBM SPSS Statistics.
get file="/data/Employee data.sav".
begin program R.
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)
spssdictionary.EndDataStep()
end program.

* Example 7 -- set variable value labels.
get file="/data/Employee data.sav".
begin program R.
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

values = c(1,2)
labels = c("mmm","yyy")
spssdictionary.SetValueLabel(datasetName = "newdataset1", 0, values, labels)

values = c("m","f")
labels = c("Male","Female")
spssdictionary.SetValueLabel(datasetName = "newdataset1", 1, values, labels)

spssdictionary.EndDataStep()
end program.

* Example 8 -- set user-missing values.
get file="/data/Employee data.sav".
begin program R.
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

missing <- c(2,6)
spssdictionary.SetUserMissing("newdataset1",0,format = missingFormat["Range"],missings = missing)

missing <- c("a","b")
spssdictionary.SetUserMissing("newdataset1",1,missings = missing)

spssdictionary.EndDataStep()
end program.

* Example 9 -- set variable attributes.
get file="/data/Employee data.sav".
begin program R.
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetVariableAttributes(datasetName="newdataset1",variable=0,attr1=c("mm","ff"),attr2=c("mmm","fff"))
spssdictionary.EndDataStep()
end program.

* Example 10 -- set active dataset.
get file="/data/Employee data.sav".
begin program R.
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetActive(datasetName = "newdataset1")
spssdictionary.EndDataStep()

end program.

* Example 11 -- get data file attributes.
Data List free /x.
Begin data.
1
2
3
End data.

DATAFILE ATTRIBUTE  
  ATTRIBUTE=OriginalVersion ('1').

Begin program R.
x <- spssdictionary.GetDataFileAttributeNames()
for( attr in x )
{
    y <- spssdictionary.GetDataFileAttributes(attrName = attr)
    print(y)
}
End program.
Display attributes.


* Example 12 -- set data file attributes.
Begin program R.
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetDataFileAttributes(datasetName="newdataset1",version=1)
spssdictionary.SetActive(datasetName = "newdataset1")
End program.

* Displays the file attributes.
Display attributes.

Begin program R.
spssdictionary.EndDataStep()
End program.


* Example 13 -- get multiple responses sets.
DATA LIST /Newspaper 1 TV 3 Web 5.

Begin data.
1 1 1
1 1 1
1 1 1
End data.

MRSETS
  /MDGROUP NAME=$mltnews LABEL='News sources' 
   VARIABLES=Newspaper TV Web 
   VALUE=1.

MRSETS
  /MCGROUP NAME=$abc LABEL='abc' VARIABLES=Newspaper TV.

Begin program R.
x <- spssdictionary.GetMultiResponseSetNames()
print(x)
for( mrs in x )
{
    y <- spssdictionary.GetMultiResponseSet(mrsetName = mrs)
    print(y)
}
End program.

MRSETS  /DISPLAY NAME=[$mltnews].
MRSETS  /DISPLAY NAME=[$abc].


* Example 14 -- set multiple responses sets.
DATA LIST /Newspaper 1 TV 3 Web 5.

Begin data.
1 1 1
1 1 1
1 1 1
End data.

Begin program R.
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 0, varFormat = "F5", varMeasurementLevel = "scale")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetMultiResponseSet(datasetName = "newdataset1",mrsetName="$mrset1",codeAs = "Categories",elementaryVars = c("var1","var2"))
spssdictionary.SetMultiResponseSet(datasetName = "newdataset1",mrsetName="$mrset2",codeAs = "Dichotomies",countedValue = "1",elementaryVars = c("var1","var2"))

spssdictionary.SetActive(datasetName = "newdataset1")
print("trying to get mrset names...")
x <- spssdictionary.GetMultiResponseSetNames()
print(x)
End program.

Begin program R.
spssdictionary.EndDataStep()
End program.

* Example 15 -- get detailed dictionary from IBM SPSS Statistics.
get file="/data/Employee data.sav".
begin program R.
x <- spssdictionary.GetDetailedDictionaryFromSPSS(variables = c(0,1,4,5,8))
print(x)
end program.

* Example 16 -- handling categorical dictionary
get file="/data/Employee data.sav".
begin program r.
dict <- spssdictionary.GetDictionaryFromSPSS("id TO jobcat")
casedata <- spssdata.GetDataFromSPSS(factorMode="labels")
catedata <- spssdictionary.GetCategoricalDictionaryFromSPSS(variables ="id TO jobcat")
if(spssdictionary.CategoryDictionaryValid(catedata))
{
				catedata1<-spssdictionary.EditCategoricalDictionary(catedata, newName=c("sex",NA,"occupation"))
        print(catedata1)
}
end program.

* Example 17 -- handling for categorical variables retrieved from IBM SPSS Statistics and factor variables written from R to IBM SPSS Statistics
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

© Copyright IBM Corp. 1989, 2011
}
\keyword{classes}
\keyword{methods}
