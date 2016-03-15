#############################################
# IBM® SPSS® Statistics - Essentials for R
# (c) Copyright IBM Corp. 1989, 2013
#
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License version 2 as published by
#the Free Software Foundation.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License version 2
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA.
#############################################

#############################################
## Class spssdictionary.
#############################################


baseInfo <- c("varName","varLabel","varType","varFormat","varMeasurementLevel")

checkBaseInfo <- function(x)
{
    check <- TRUE
    if(is.data.frame(x))
    {
        info <- row.names(x)
        if( !is.null(info) && 5 == length(info) )
            check <- any(info != baseInfo)
    }
    !check
}

##gets dictionary from SPSS
spssdictionary.GetDictionaryFromSPSS <- function(variables=NULL)
{
    spssError.reset()
    err <- 0
    if(is.logical(variables))
    {
        last.SpssError <<- 1068 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
    }
    variables <- unlist(variables)
    if( is.null(variables) )
    {
        varNum <- spssdictionary.GetVariableCount()
        if( varNum > 0 )
            variables <- 0:(varNum-1)
        else
            return(NULL)
    }
    else if( is.character(variables) )
        variables <- ParseVarNames(variables)

    if( length(variables)==0 )
        return(NULL)
    
    out <- .Call("ext_GetVarNames",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varName <- unicodeConverterOutput(out[1:n-1])
    
    out <- .Call("ext_GetVarLabels",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varLabel <- unicodeConverterOutput(out[1:n-1])
    
    out <- .Call("ext_GetVarTypes",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varType <- out[1:n-1]
    
    out <- .Call("ext_GetVarFormats",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varFormat <- out[1:n-1]
    
    out <- .Call("ext_GetVarMeasurementLevels",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varMeasurementLevel <- out[1:n-1]

    vars <- rbind(varName,varLabel,varType,varFormat,varMeasurementLevel)
    value <- data.frame(vars,stringsAsFactors=FALSE)
    value
}

##gets dictionary from SPSS
spssdictionary.GetDetailedDictionaryFromSPSS <- function(variables=NULL)
{
    spssError.reset()
    err <- 0
    variables <- unlist(variables)
    if( is.null(variables) )
    {
        varNum <- spssdictionary.GetVariableCount()
        if( varNum > 0 )
            variables <- 0:(varNum-1)
        else
            return(NULL)
    }
    else if( is.character(variables) )
        variables <- ParseVarNames(variables)

    if( length(variables)==0 )
        return(NULL)
    
    out <- .Call("ext_GetVarNames",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varName <- unicodeConverterOutput(out[1:n-1])
    
    out <- .Call("ext_GetVarLabels",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varLabel <- unicodeConverterOutput(out[1:n-1])
    
    out <- .Call("ext_GetVarTypes",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varType <- out[1:n-1]
    
    out <- .Call("ext_GetVarFormats",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varFormat <- out[1:n-1]
    
    out <- .Call("ext_GetVarMeasurementLevels",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varMeasurementLevel <- out[1:n-1]

    varValueLabels <- list()
    for(var in variables)
    {
      varValueLabel<- spssdictionary.GetValueLabels(var)
      varValueLabels[[length(varValueLabels)+1]]<- varValueLabel
    }
    varMissingValues <- list()
    for(var in variables)
    {
      varMissingValue<- spssdictionary.GetUserMissingValues(var)
      varMissingValues[[length(varMissingValues)+1]]<- varMissingValue
    }
    varAttributes <- list()
    for(var in variables)
    {
      attrNames<- spssdictionary.GetVariableAttributeNames(var)
      varAttribute<-list()
      for(name in attrNames)
      {
        attributes<-spssdictionary.GetVariableAttributes(var,name)
        varAttribute[[length(varAttribute)+1]] <- list(attrNames = name, attrValues = attributes)
      }  
      varAttributes[[length(varAttributes)+1]]<- varAttribute
    }
    vars <- rbind(varName,varLabel,varType,varFormat,varMeasurementLevel,varValueLabels,varMissingValues, varAttributes)
    value <- data.frame(vars,stringsAsFactors=FALSE)
    value
}

spssdictionary.GetUserMissingValues <- function(variable)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable
    
    missingType <- c("Discrete","Range","Range Discrete")
    err <- 0
    missingFormat <- 0
    value <- NULL
    
    varType <- spssdictionary.GetVariableType(varIndex)
    if(0 == varType)
    {
        out <- .C("ext_GetVarNMissingValues",as.integer(varIndex),
                                             as.integer(missingFormat),
                                             as.double(0),
                                             as.double(0),
                                             as.double(0),
                                             as.integer(err),
                                             PACKAGE=spss_package)
        last.SpssError <<- out[[6]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        
        missingFormat <- out[[2]]
        result <- unlist(out)[3:5]
        
        if( 0 == missingFormat )
            result[1:3] <- c(NaN,NaN,NaN)
        if( 1 == missingFormat )
            result[2:3] <- c(NaN,NaN)
        if( -2 == missingFormat || 2 == missingFormat )
            result[3] <- NaN

        format <- missingType[1]
        if( -2 == missingFormat )
            format <- missingType[2]
        else if( -3 == missingFormat )
            format <- missingType[3]
        
        value <- list(type=format,missing=result)
    }
    else
    {
        out <- .C("ext_GetVarCMissingValues",as.integer(varIndex),
                                             as.integer(missingFormat),
                                             as.character(""),
                                             as.character(""),
                                             as.character(""),
                                             as.integer(err),
                                             PACKAGE=spss_package)
        last.SpssError <<- out[[6]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

        missingFormat <- out[[2]]
        result <- unlist(out)[3:5]
        
        for (i in 1:3)
            result[i] <- unicodeConverterOutput(result[i])

        if( 0 == missingFormat )
            result[1:3] <- c(NA,NA,NA)
        if( 1 == missingFormat )
            result[2:3] <- c(NA,NA)
        if( -2 == missingFormat || 2 == missingFormat )
            result[3] <- NA

        format <- NULL
        value <- list(type=format,missing=result)
    }
}

spssdictionary.GetValueLabels <- function(variable)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    out <- NULL
    varType <- spssdictionary.GetVariableType(varIndex)
    if(0 == varType)
    {
        out <- .Call("ext_GetNValueLabels",as.integer(varIndex),as.integer(err),PACKAGE=spss_package)
    }
    else
    {
        out <- .Call("ext_GetCValueLabels",as.integer(varIndex),as.integer(err),PACKAGE=spss_package)
    }

    last.SpssError <<- out[[3]][1]
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    result <- out[1:2]
    names(result) <- c("values","labels")
    
    
    result$values <- unicodeConverterOutput(result$values)
    result$labels <- unicodeConverterOutput(result$labels)

    result
}

spssdictionary.IsWeighting <- function()
{
    !is.null(spssdictionary.GetWeightVariable())
}

spssdictionary.GetWeightVariable <- function()
{
    spssError.reset()
    err <- 0
    out <- .C("ext_GetWeightVar",as.character(""),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    
    value <- out[[1]]
    if("" == value)
        value <- NULL
    unicodeConverterOutput(value)
}

spssdictionary.GetVariableAttributeNames <- function(variable)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    out <- NULL
    out <- .Call("ext_GetVarAttributeNames",as.integer(varIndex),as.integer(err),PACKAGE=spss_package)

    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
    }
    
    result
}

spssdictionary.GetVariableAttributes <- function(variable, attrName)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    out <- NULL
    attrName <- unicodeConverterInput(attrName)
    out <- .Call("ext_GetVarAttributes",as.integer(varIndex),as.character(attrName),as.integer(err),PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
    }
    result
}

spssdictionary.GetDataFileAttributeNames <- function()
{
    spssError.reset()

    err <- 0
    out <- NULL
    out <- .Call("ext_GetDataFileAttributeNames",as.integer(err),PACKAGE=spss_package)

    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
    }
    result
}

spssdictionary.GetDataFileAttributes <- function(attrName)
{
    spssError.reset()

    err <- 0
    out <- NULL
    attrName <- unicodeConverterInput(attrName)
    out <- .Call("ext_GetDataFileAttributes",as.character(attrName),as.integer(err),PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
    }
    result
}

spssdictionary.GetMultiResponseSetNames <- function()
{
    spssError.reset()
    err <- 0
    out <- .Call("ext_GetMultiResponseSetNames",as.integer(err),PACKAGE=spss_package)
    
    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
    }
    result
}

spssdictionary.GetMultiResponseSet <- function(mrsetName)
{
    spssError.reset()

    err <- 0
    out <- NULL
    mrsetName <- unicodeConverterInput(mrsetName)
    mrsetName <- toupper(mrsetName)
    out <- .Call("ext_GetMultiResponseSet",as.character(mrsetName),as.integer(err),PACKAGE=spss_package)

    n <- length(out)
    last.SpssError <<- out[[n]][1]
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])

        names(result) <- c("label","codeAs","countedValue","type","vars")
        if(n>1)
        {
            if(1 == result[[2]])
                result[[2]] <- "Categories"
            else if(2 == result[[2]])
                result[[2]] <- "Dichotomies"
            if(0 == result[[4]])
                result[[4]] <- "Numeric"
            else if(result[[4]] > 0)
                result[[4]] <- "String"
        }
    }
    result
}

## create a dictionary structure with all values NA.
spssdictionary.CreateSPSSDictionary <- function(...)
{
    value <- data.frame(...,stringsAsFactors = FALSE)
    n <- length(value)
    if(n <1){
        last.SpssError <<- 1002 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    if(length(value[,1]) != 5)
    {
        last.SpssError <<- 1002 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    row.names(value) <- baseInfo
    value
}


spssdictionary.GetVariableFormatType <- function(variable)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    formatType <- 0
    formatWidth <- 0
    formatDecimal <- 0
    
    out <- .C("ext_GetVariableFormatType",as.integer(varIndex),
                                          as.integer(formatType),
                                          as.integer(formatWidth),
                                          as.integer(formatDecimal),
                                          as.integer(err),
                                          PACKAGE=spss_package)
    last.SpssError <<- out[[5]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    format <- out[[2]]
    format
}

spssdictionary.GetVariableCount <- function()
{
    err <- 0
    out <- .C("ext_GetVariableCount",as.integer(0), as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    columns <- out[[1]]
    columns
}

spssdictionary.GetVariableCountInDS <- function(dsName)
{
    err <- 0
    out <- .C("ext_GetVarCountInDS",as.character(dsName),as.integer(0),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[3]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    columns <- out[[2]]
    columns
}

spssdictionary.GetVariableName <- function(variable)
{
    spssError.reset()
    if( !is.numeric(variable) )
        stop("assert is.numeric(variable)")
    varIndex <- variable

    err <- 0
    out <- .C("ext_GetVariableName",as.character(""), as.integer(varIndex),as.integer(err),PACKAGE=spss_package)

    last.SpssError <<- out[[3]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    varName <- out[[1]]
    varName <- unicodeConverterOutput(varName)
    varName
}

spssdictionary.GetVariableNameInDS <- function(dsName,variable)
{
    spssError.reset()
    if( !is.numeric(variable) )
        stop("assert is.numeric(variable)")
    varIndex <- variable

    err <- 0
    out <- .C("ext_GetVarNameInDS",as.character(dsName), as.integer(varIndex),as.character(""), as.integer(err),PACKAGE=spss_package)

    last.SpssError <<- out[[4]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    varName <- out[[3]]
    varName <- unicodeConverterOutput(varName)
    varName
}

spssdictionary.GetVariableLabel <- function(variable)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    out <- .C("ext_GetVariableLabel",as.character(""), as.integer(varIndex),as.integer(err),PACKAGE=spss_package)

    last.SpssError <<- out[[3]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    varLabel <- out[[1]]
    varLabel <- unicodeConverterOutput(varLabel)
    varLabel
}

spssdictionary.GetVariableType <- function(variable)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    out <- .C("ext_GetVariableType",as.integer(0), as.integer(varIndex),as.integer(err),PACKAGE=spss_package)

    last.SpssError <<- out[[3]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    varType <- out[[1]]
    varType
}

spssdictionary.GetVariableFormat <- function(variable)
{
    spssError.reset()
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    out <- .C("ext_GetVariableFormat",as.character(""), as.integer(varIndex),as.integer(err),PACKAGE=spss_package)

    last.SpssError <<- out[[3]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    varFormat <- out[[1]]
    varFormat
}

spssdictionary.GetVariableMeasurementLevel <- function(variable)
{
    spssError.reset()
    variable <- GetVarIndex(variable)
    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    out <- .C("ext_GetVariableMeasurementLevel",as.integer(0), as.integer(varIndex),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[3]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    varMeasurementLevel <- out[[1]]
    result <- switch(varMeasurementLevel,"unknown","nominal","ordinal","scale")
    if(is.null(result))
    {
        last.SpssError <<- 1004
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    result
}

spssdictionary.GetCategoricalDictionaryFromSPSS <- function(variables = NULL)
{
    spssError.reset()
    err <- 0
    if(typeof(variables)=="logical")
    {
      last.SpssError <<- 1073 
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)        
    }    
    variables <- unlist(variables)
    if( is.null(variables) )
    {
        varNum <- spssdictionary.GetVariableCount()
        if( varNum > 0 )
            variables <- 0:(varNum-1)
        else
            return(NULL)
    }
    else if( is.character(variables) )
        variables <- ParseVarNames(variables)

    if( length(variables)==0 )
        return(NULL)
    
    out <- .Call("ext_GetVarNames",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varName <- unicodeConverterOutput(out[1:n-1])    
    
    out <- .Call("ext_GetVarMeasurementLevels",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    varMeasurementLevel <- out[1:n-1]

    idx<-NULL
    dic<-list()  
    j <- 1
    k <- 1
    for(i in variables)
    {
        valuelabels<-spssdictionary.GetValueLabels(i)
        if(length(valuelabels$values)!=0)
        {   
            if(varMeasurementLevel[[k]]=="ordinal"||varMeasurementLevel[[k]]=="nominal")
            {           
                idx<-append(idx,varName[[k]])
                tmp<-list(levels = valuelabels$values, labels = valuelabels$labels)
                dic[[j]]<-tmp
                j<- j+1
            }
        }
        k <- k+1
    }
    
    result <- list(name = idx, dictionary = dic)
    result
}

spssdictionary.CategoryDictionaryValid <- function(categoryDictionary)
{
    len <- length(categoryDictionary$dictionary)
    if(length(categoryDictionary$name) != len)
      return(FALSE)
    else
    {
      for(i in 1:len)
      {
          temp <- categoryDictionary$dictionary[[i]]
          if(length(temp$levels) != length(temp$labels))
              return(FALSE)
      }
    }
    return(TRUE)
}

spssdictionary.EditCategoricalDictionary <- function(categoryDictionary, newName = categoryDictionary$name)
{
    spssError.reset()
    err <- 0
    if(!is.null(categoryDictionary))
    {
        if(!spssdictionary.CategoryDictionaryValid(categoryDictionary))
        {
            last.SpssError <<- 1021
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
    }     
    len <- length(categoryDictionary$name)
    if(len != length(newName))
    {
        last.SpssError <<- 1020
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    result <- categoryDictionary
    offset <- 0
    for(i in 1:len)
    {
      if(is.na(newName[i]))
      {
        result$name <- result$name[-(i-offset)]
        result$dictionary[i-offset] <- NULL
        offset <- offset+1
      }
      else
        result$name[i-offset] <- newName[i]
    }
    result
}

spssdictionary.SetDictionaryToSPSS <- function(datasetName,x, categoryDictionary = NULL, hidden=FALSE)
{
    if(is.null(getOption("is.dataStepRunning"))) options(is.dataStepRunning = FALSE)
    if(is.null(datasetName) || grepl(" ", datasetName))
    {
        last.SpssError <<- 87
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    datasetName <- unicodeConverterInput(datasetName)
    spssError.reset()
    if( getOption("is.splitConnectionOpen") )
    {
        last.SpssError <<- 1001
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    if( !checkBaseInfo(x) )
    {
        last.SpssError <<- 1002
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }   
    
    if(!is.null(categoryDictionary))
    {
        if(!spssdictionary.CategoryDictionaryValid(categoryDictionary))
        {
            last.SpssError <<- 1021
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
    }
    err <- 0
    if( !getOption("is.dataStepRunning") )
    {
        out <- .C("ext_StartDataStep",as.integer(err),PACKAGE=spss_package)
        last.SpssError <<- out[[1]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

        options(is.dataStepRunning = TRUE)
    }

    out <- .C("ext_CreateDataset",as.character(datasetName),as.logical(TRUE),as.logical(hidden), as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[4]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    i <- 0
    for(var in x)
    {
        var <- as.vector(var)
        out <- .C("ext_InsertVariable",as.character(datasetName),
                                       as.integer(i),   
                                       as.character(unicodeConverterInput(var[1])),  #variable name
                                       as.integer(var[3]),    #variable type
                                       as.integer(err),
                                       PACKAGE=spss_package)
        last.SpssError <<- out[[5]]   
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

        out <- .C("ext_SetVarLabelInDS",as.character(datasetName),
                                       as.integer(i),   
                                       as.character(unicodeConverterInput(var[2])),  #variable label
                                       as.integer(err),
                                       PACKAGE=spss_package)
        last.SpssError <<- out[[4]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        
        # separate varFormat to formatType, formatWidth, and formatDecimal.
        format <- var[4]  #variable format
        
        temp <- unlist(strsplit(format,"\\."))
        # find the first numeric digit.
        n <- nchar(temp[1])
        first <- 1
        while(first < n)
        {
            s <- substr(temp[1],first,first)
            if( s < 0 || s > 9 )
                first <- first+1
            else
                break
        }
        formatType <- toSPSSFormat(substr(temp[1],1,first-1))
        formatWidth <- substr(temp[1],first,nchar(temp[1]))
        formatDecimal <- temp[2]

        if(is.na(formatDecimal))
            formatDecimal <- 0

        out <- .C("ext_SetVarFormatInDS",as.character(datasetName),
                                       as.integer(i),
                                       as.integer(formatType),
                                       as.integer(formatWidth),
                                       as.integer(formatDecimal),   
                                       as.integer(err),
                                       PACKAGE=spss_package)
        last.SpssError <<- out[[6]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        
        out <- .C("ext_SetVarMeasurementLevelInDS",as.character(datasetName),
                                       as.integer(i),   
                                       as.character(unicodeConverterInput(toupper(var[5]))), #variable measurement level
                                       as.integer(err),
                                       PACKAGE=spss_package)
        last.SpssError <<- out[[4]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        
        if(!is.null(categoryDictionary))
        {
           idx <- match(var[1],categoryDictionary$name)
           if(!is.na(idx))
           {
               dictionary <- categoryDictionary$dictionary[[idx]]
               spssdictionary.SetValueLabel(datasetName,as.character(var[1]),as.vector(dictionary$levels), as.vector(dictionary$labels))
           }
        }    
              
        i <- i+1
    }
    
}

spssdictionary.SetActive <- function(datasetName)
{
    spssError.reset()
    datasetName <- unicodeConverterInput(datasetName)
    
    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    err <- 0
    out <- .C("ext_SetActive",as.character(datasetName),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
}

spssdictionary.CloseDataset <- function(datasetName)
{
    spssError.reset()
    datasetName <- unicodeConverterInput(datasetName)
    
    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    err <- 0
    out <- .C("ext_CloseDataset",as.character(datasetName),as.integer(err),PACKAGE=spss_package)

    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

    #out <- .C("ext_EndDataStep",as.integer(err),PACKAGE=spss_package)
}

spssdictionary.EndDataStep <- function()
{
    spssError.reset()
    if( getOption("is.dataStepRunning") )
    {
        err <- 0
        out <- .C("ext_EndDataStep",as.integer(err),PACKAGE=spss_package)
        last.SpssError <<- out[[1]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    
        options(is.dataStepRunning = FALSE)
    }
}

missingFormat <- c(0,-2,-3)
names(missingFormat) <- c("Discrete","Range","Range Discrete")

spssdictionary.SetUserMissing <- function(datasetName,variable,format=missingFormat["Discrete"],missings)
{
    spssError.reset()
    datasetName <- unicodeConverterInput(datasetName)
    
    variable <- GetVarIndex(variable,datasetName)
    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    err <- 0
    missings <- unlist(missings)
    
    if(format != missingFormat["Range Discrete"] && format != missingFormat["Range"])
    {
        format <- length(missings)
        if(format > 3)
            format <- 3
    }
    
    varIndex <- variable
    if(is.numeric(missings[1]))
    {
        i <- 3
        while(i>length(missings))
        {
            missings <- cbind(missings,0)
            i <- i-1
        }
    
        out <- .C("ext_SetVarNMissingValuesInDS",as.character(datasetName),
                                                 as.integer(varIndex),
                                                 as.integer(format),
                                                 as.double(missings[1]),
                                                 as.double(missings[2]),
                                                 as.double(missings[3]),
                                                 as.integer(err),
                                                 PACKAGE=spss_package)

        last.SpssError <<- out[[7]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    else
    {
        if(format < 0)
            format <- 0

        i <- 3
        while(i>length(missings))
        {
            missings <- cbind(missings,"")
            i <- i-1
        }
        
        out <- .C("ext_SetVarCMissingValuesInDS",as.character(datasetName),
                                                 as.integer(varIndex),
                                                 as.integer(format),
                                                 as.character(unicodeConverterInput(missings[1])),
                                                 as.character(unicodeConverterInput(missings[2])),
                                                 as.character(unicodeConverterInput(missings[3])),
                                                 as.integer(err),
                                                 PACKAGE=spss_package)
        last.SpssError <<- out[[7]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
}

spssdictionary.SetValueLabel <- function(datasetName,variable,values,labels)
{
    spssError.reset()
    datasetName <- unicodeConverterInput(datasetName)

    variable <- GetVarIndex(variable,datasetName)
    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    
    n <- length(labels)
    if(length(values) > n)
        values <- values[1:n]
        
    if(is.numeric(values[1]))
    {
        i <- 0
        while(i < n)
        {
            i <- i+1
            out <- .C("ext_SetVarNValueLabelInDS",as.character(datasetName),
                                                  as.integer(varIndex),
                                                  as.double(values[i]),
                                                  as.character(unicodeConverterInput(labels[i])),
                                                  as.integer(err),
                                                  PACKAGE=spss_package)
            last.SpssError <<- out[[5]] 
            if( is.SpssError(last.SpssError))
                stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
    }
    else
    {
        i <- 0
        while(i < n)
        {
            i <- i+1
            out <- .C("ext_SetVarCValueLabelInDS",as.character(datasetName),
                                                  as.integer(varIndex),
                                                  as.character(unicodeConverterInput(values[i])),
                                                  as.character(unicodeConverterInput(labels[i])),
                                                  as.integer(err),
                                                  PACKAGE=spss_package)
            last.SpssError <<- out[[5]] 
            if( is.SpssError(last.SpssError))
                stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
    }
}

spssdictionary.SetVariableAttributes <- function(datasetName,variable,...)
{
    spssError.reset()
    datasetName <- unicodeConverterInput(datasetName)

    variable <- GetVarIndex(variable,datasetName)
    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    if( !is.numeric(variable) )
    {
        last.SpssError <<- 1008 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    varIndex <- variable

    err <- 0
    x <- list(...)
    attrNames <- names(x)
    for( aname in attrNames )
    {
        attrs <- unlist(x[aname])
        n <- length(attrs)
        for( i in 1:n )
        {
            attrs[i] <- unicodeConverterInput(attrs[i])
        }
        
        out <- .Call("ext_SetVarAttributesInDS",as.character(datasetName),
                                                as.integer(varIndex),
                                                as.character(unicodeConverterInput(aname)),
                                                as.list(attrs),
                                                as.integer(length(attrs)),
                                                as.integer(err),
                                                PACKAGE=spss_package)
        last.SpssError <<- out[[1]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
}

spssdictionary.SetDataFileAttributes <- function(datasetName,...)
{
    spssError.reset()
    datasetName <- unicodeConverterInput(datasetName)

    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    err <- 0
    x <- list(...)
    attrNames <- names(x)
    for( aname in attrNames )
    {
        attrs <- unlist(x[aname])
        n <- length(attrs)
        for( i in 1:n )
            attrs[i] <- unicodeConverterInput(attrs[i])
        
        out <- .Call("ext_SetDataFileAttributesInDS",as.character(datasetName),
                                                as.character(unicodeConverterInput(aname)),
                                                as.list(attrs),
                                                as.integer(length(attrs)),
                                                as.integer(err),
                                                PACKAGE=spss_package)
        last.SpssError <<- out[[1]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
}

CodeAs.Categories <- 1
CodeAs.Dichotomies <- 2

spssdictionary.SetMultiResponseSet <- function(datasetName,
                                               mrsetName,
                                               mrsetLabel="",
                                               codeAs,
                                               countedValue=NULL,
                                               elementaryVars)
{
    spssError.reset()
    datasetName <- unicodeConverterInput(datasetName)

    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    err <- 0
    #mrsetName <- toupper(mrsetName)
    
    if(tolower(codeAs) == "categories")
        codeAs <- CodeAs.Categories
    else if(tolower(codeAs) == "dichotomies")
        codeAs <- CodeAs.Dichotomies
    
    if(codeAs != CodeAs.Categories && codeAs != CodeAs.Dichotomies)
    {
        last.SpssError <<- 1012 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    if(codeAs == CodeAs.Dichotomies && is.null(countedValue))
    {
        last.SpssError <<- 1013 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    else if(codeAs == CodeAs.Categories && is.null(countedValue))
        countedValue = ""
    
    
    elemVarNames <- unlist(elementaryVars)
    n <- length(elemVarNames)
    for( i in 1:n )
    {
        elemVarNames[i] <- unicodeConverterInput(elemVarNames[i])
    }
    
    elemVarIndics <- ParseVarNames(elemVarNames,dsName=datasetName)
    
    elemVars <- NULL
    for( varIndex in elemVarIndics )
    {
        varName <- spssdictionary.GetVariableNameInDS(datasetName,varIndex)
        elemVars <- c(elemVars,varName)
    }
    
    out <- .Call("ext_SetMultiResponseSetInDS",as.character(datasetName),
                                               as.character(unicodeConverterInput(mrsetName)),
                                               as.character(unicodeConverterInput(mrsetLabel)),
                                               as.integer(codeAs),
                                               as.character(unicodeConverterInput(countedValue)),
                                               as.list(elemVars),
                                               as.integer(err),
                                               PACKAGE=spss_package)
    last.SpssError <<- out[[1]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
}
