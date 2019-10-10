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
  \item{variables}{A character vector or list specifying the variable names, a character string consisting of variable names separated by blanks, or a numeric vector or list of integers specifying the index values of the variables (index values represent position in the dataset, starting with 0 for the first variable in file order). Variable names must match case with the names as they exist in the active dataset's dictionary. If the argument is NULL, all variables in the dataset will 
    be retrieved. 
	
When specifying variable names, you can use TO to indicate a range of variables. For example, variables=c("age TO income") specifies age, income, and all variables between them in the active dataset's dictionary. You can also specify a range of values using index values, as in variables=c(2:4), which specifies the variables with index values 2 through 4.
    }
  \item{variable}{A character string specifying the variable name or an integer specifying the index value of the variable (index values represent position in the dataset, starting with 0 for the first variable in file order). Variable names must match case with the names as they exist in the active dataset's dictionary. 
    }
  \item{attrName}{ A character string specifying the attribute name.
    Variable attribute names can be retrieved with 
    spssdictionary.GetVariableAttributeNames.
    Data file attribute names can be retrieved with 
    spssdictionary.GetDataFileAttributeNames.
    }
  \item{datasetName}{ A character string specifying the name of an IBM SPSS Statistics 
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
  \item{categoryDictionary}{ Specifies the name of a category dictionary created with the GetCategoricalDictionaryFromSPSS function. Category dictionaries are for use when retrieving categorical variables (variables with a measurement level of "nominal" or "ordinal") into labelled R factors, with the intention of writing those factors to a new dataset. 
    }
  \item{hidden}{Specifies whether the Data Editor window 
    associated with the new dataset is hidden. By default, it is displayed. 
    Use hidden=TRUE to hide the associated Data Editor window.    
    }  
  \item{newName}{A vector specifying the names of the variables in the category dictionary. It replaces the existing names, which are defined in the name attribute of the category dictionary, and must be the same length as the name attribute. The first element of newNames replaces the first element in the name attribute of the category dictionary, and so on. A value of NA means the corresponding element in categoryDictionary$name and categoryDictionary$dictionary will be deleted (see the example 15). 
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
    "Categories". If codeAs is "dichotomies", countedValue must be present.
    }
  \item{countedValue}{Specifies the value that indicates the presence of a response for a multiple dichotomy set. This is also referred to as the "counted" value. If the set type is numeric, the value can be an integer or a string representation of an integer. If the set type is string, the value, after trimming trailing blanks, cannot be wider than the narrowest elementary variable. countedValue is required if codeAs has the value "Dichotomies" and is ignored otherwise.
    }
  \item{elementaryVars}{ A character vector specifying the list of elementary variables that define the set (the list must include at least two variables). Variables can be specified by name or index value (index values represent position in the dataset, starting with 0 for the first variable in file order). When specifying variable names, you can use TO to indicate a range of variables--for example, elementaryVars=c("age TO income") specifies age, income, and all variables between them in the active dataset's dictionary. Variable names must match case with the names as they exist in the active dataset's dictionary. All specified variables must be of the same type (numeric or string).
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

spssdictionary.GetMultiResponseSet gets the details of the specified multiple-response set. The result is a list with the following named components: label (the label, if any, for the set), codeAs ("Dichotomies" or "Categories"), countedValue (the counted value--applies only to multiple dichotomy sets), type ("Numeric" or "String"), and vars (a vector of the elementary variables that define the set). 

spssdictionary.IsWeighting indicates whether weighting is in effect for the 
active dataset.  The result is TRUE if weighting is in effect, FALSE 
otherwise.\cr

spssdictionary.GetWeightVariable gets the name of the weight variable 
if weighting is in effect. Otherwise, NULL will be returned.\cr

spssdictionary.CreateSPSSDictionary creates the structure for a new  
dictionary that can be set to IBM SPSS Statistics with SetDictionaryToSPSS. It returns a data 
frame. The generated dictionary is editable until it is set to IBM SPSS Statistics.\cr

spssdictionary.GetCategoricalDictionaryFromSPSS returns a structure containing the values and value labels of the specified categorical variables from the active dataset. This is a utility function for use when retrieving categorical variables (variables with a measurement level of "nominal" or "ordinal") into labeled R factors (factorMode="labels" in GetDataFromSPSS), with the intention of writing those factors to a new dataset. This is necessary because labeled factors in R do not preserve the original values. The structure returned by this function is referred to as a category dictionary.\cr

spssdictionary.CategoryDictionaryValid checks if the specified category dictionary is valid.\cr

spssdictionary.EditCategoricalDictionary changes the names of one or more variables in a category dictionary.\cr

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
dataset. \cr

spssdictionary.SetActive makes the specified dataset the active dataset.\cr

spssdictionary.CloseDataset closes the specified dataset. It can only be used 
to close a dataset during the data step in which it was created.\cr

spssdictionary.EndDataStep ends a data step implicitly started by 
SetDictionaryToSPSS.\cr
}
\references{
}
\seealso{
  \code{\link{extension}},
  \code{\link{external}},
  \code{\link{spssdata}},
  \code{\link{spsspkg}},
  \code{\link{spsspivottable}},
  \code{\link{spssRGraphics}},
  \code{\link{spssxmlworkspace}},
  \code{\link{TextBlock}}
}
\examples{
## These examples are intended to be run from R, with R driving IBM SPSS Statistics.

* Example 1 -- get the dictionary of the active dataset in IBM SPSS Statistics
spsspkg.Submit("get file='/data/Employee data.sav'.")
x <- spssdictionary.GetDictionaryFromSPSS(variables = c(0,1,4,5,8))
print(x)


* Example 2 -- get any user-missing values from the active dataset in IBM SPSS Statistics
spsspkg.Submit("get file='/data/Employee data.sav'.")
varNum <- spssdictionary.GetVariableCount()-1
for( i in 0:varNum )
{
    x <- spssdictionary.GetUserMissingValues(variable = i)
    print(x)
}

* Example 3 -- get any variable value labels from the active dataset in IBM SPSS Statistics
spsspkg.Submit("get file='/data/Employee data.sav'.")
varNum <- spssdictionary.GetVariableCount()-1
for( i in 0:varNum )
{
    x <- spssdictionary.GetValueLabels(variable = i)
    print(x)
}

* Example 4 -- get variable attributes from the active dataset in IBM SPSS Statistics
spsspkg.Submit(c("Data List free /x.",
                 "Begin data",
                 "1",
                 "2",
                 "3",
                 "End data.",
                 "Variable Attributes VARIABLES=x ATTRIBUTE=DemographicVars ('1')."))
spssdictionary.EndDataStep()
x <- spssdictionary.GetVariableAttributeNames(variable = 0)
for( attr in x )
{
y <- spssdictionary.GetVariableAttributes(variable = 0,attrName = attr)
print(y)
}              
spsspkg.Submit("Display attributes.")


* Example 5 -- get the weight variable, if any, from the active dataset in IBM SPSS Statistics
spsspkg.Submit(c("get file='/data/Employee data.sav'.","WEIGHT  BY educ."))

x <- spssdictionary.GetWeightVariable()
print(x)
y <- spssdictionary.IsWeighting()
cat("Is weighting on?", y, "\n")


* Example 6 -- create a dictionary and create a new dataset in IBM SPSS Statistics based on the dictionary
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)
spssdictionary.EndDataStep()


* Example 7 -- create a new dataset in IBM SPSS Statistics and set variable value labels in the dataset
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


* Example 8 -- create a new dataset in IBM SPSS Statistics and set user-missing values in the dataset
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

missing <- c(2,6)
spssdictionary.SetUserMissing("newdataset1",0,format = missingFormat["Range"],missings = missing)

missing <- c("a","b")
spssdictionary.SetUserMissing("newdataset1",1,missings = missing)

spssdictionary.EndDataStep()


* Example 9 -- create a new dataset in IBM SPSS Statistics and set variable attributes in the dataset
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetVariableAttributes(datasetName="newdataset1",variable=0,attr1=c("mm","ff"),attr2=c("mmm","fff"))
spssdictionary.EndDataStep()


* Example 10 -- create a new dataset in IBM SPSS Statistics and set it as the active dataset
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetActive(datasetName = "newdataset1")
spssdictionary.EndDataStep()


* Example 11 -- get any data file attributes for the active dataset from IBM SPSS Statistics
spsspkg.Submit(c("Data List free /x.",
                 "Begin data",
                 "1",
                 "2",
                 "3",
                 "End data.",
                 "DATAFILE ATTRIBUTE ATTRIBUTE=OriginalVersion ('1')."))

x <- spssdictionary.GetDataFileAttributeNames()
for( attr in x )
{
    y <- spssdictionary.GetDataFileAttributes(attrName = attr)
    print(y)
}

spsspkg.Submit("Display attributes.")


* Example 12 -- create a new dataset in IBM SPSS Statistics and set data file attributes for it
var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 5, varFormat = "A5", varMeasurementLevel = "nominal")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetDataFileAttributes(datasetName="newdataset1",version=1)
spssdictionary.SetActive(datasetName = "newdataset1")
spssdictionary.EndDataStep()
spsspkg.Submit("Display attributes.")


* Example 13 -- get any multiple response sets from the active dataset in IBM SPSS Statistics
spsspkg.Submit(c("DATA LIST /Newspaper 1 TV 3 Web 5.",
"Begin data",
"1 1 1",
"1 1 1",
"1 1 1",
"End data.",
"MRSETS /MDGROUP NAME=$mltnews LABEL='News sources' VARIABLES=Newspaper TV Web VALUE=1.",
"MRSETS /MCGROUP NAME=$abc LABEL='abc' VARIABLES=Newspaper TV."))

x <- spssdictionary.GetMultiResponseSetNames()
print(x)
for( mrs in x )
{
    y <- spssdictionary.GetMultiResponseSet(mrsetName = mrs)
    print(y)
}
spsspkg.Submit(c("MRSETS  /DISPLAY NAME=[$mltnews].","MRSETS  /DISPLAY NAME=[$abc]."))


* Example 14 -- create a new dataset in IBM SPSS Statistics and set multiple response sets for the dataset
spsspkg.Submit(c("DATA LIST /Newspaper 1 TV 3 Web 5.",
"Begin data",
"1 1 1",
"1 1 1",
"1 1 1",
"End data."))

var1 <- c(varName = "var1", varLabel = "label of var1", varType = 0, varFormat = "F8.2", varMeasurementLevel = "scale")
var2 <- c(varName = "var2", varLabel = "label of var2", varType = 0, varFormat = "F5", varMeasurementLevel = "scale")
dict <- spssdictionary.CreateSPSSDictionary(var1,var2)
spssdictionary.SetDictionaryToSPSS(datasetName = "newdataset1",dict)

spssdictionary.SetMultiResponseSet(datasetName = "newdataset1",mrsetName="$mrset1",codeAs = "Categories",elementaryVars = c("var1","var2"))
spssdictionary.SetMultiResponseSet(datasetName = "newdataset1",mrsetName="$mrset2",codeAs = "Dichotomies",countedValue = "1",elementaryVars = c("var1","var2"))

spssdictionary.SetActive(datasetName = "newdataset1")
print("try to get mrset names...")
x <- spssdictionary.GetMultiResponseSetNames()
print(x)

spssdictionary.EndDataStep()


* Example 15 -- change the names of some of the variables in a category dictionary
spsspkg.Submit("get file='/data/Employee data.sav'.")
dict <- spssdictionary.GetDictionaryFromSPSS("id TO jobcat")
casedata <- spssdata.GetDataFromSPSS(factorMode="labels")
catdict <- spssdictionary.GetCategoricalDictionaryFromSPSS(variables ="id TO jobcat")
catdict1<-spssdictionary.EditCategoricalDictionary(catdict, newName=c("sex",NA,"occupation"))
print(catdict1)


© Copyright IBM Corp. 1989, 2016
}
\keyword{classes}
\keyword{methods}
