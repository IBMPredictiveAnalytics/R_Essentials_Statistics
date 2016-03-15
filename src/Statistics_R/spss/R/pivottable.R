#############################################
# IBM?SPSS?Statistics - Essentials for R
# (c) Copyright IBM Corp. 1989, 2014
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
## Class spss.pivottable.
#############################################

formatSpec.Coefficient  <- 0
formatSpec.CoefficientSE  <- 1
formatSpec.CoefficientVar  <- 2
formatSpec.Correlation  <- 3
formatSpec.GeneralStat  <- 4
formatSpec.Mean <- 5
formatSpec.Count  <- 6
formatSpec.Percent  <- 7
formatSpec.PercentNoSign  <- 8
formatSpec.Proportion  <- 9
formatSpec.Significance  <- 10
formatSpec.Residual  <- 11
formatSpec.Variable  <- 12
formatSpec.StdDev  <- 13
formatSpec.Difference  <- 14
formatSpec.Sum  <- 15

default.title <- "Rtable"
default.templateName <- "Rtable"
default.outline <- ""
default.content <- ""
default.caption <- NULL
default.rowdim <- "row"
default.coldim <- "column"
default.format <- formatSpec.GeneralStat

defaultMinDataColumnWidth <- 60

spss.PivotTableMap <- list()
spss.DimensionMap <- list()
spss.CellTextMap <- list()

isInstanceofCellText <- function(aCellText)
{
    aCellText<- spss.GetMapObject(aCellText)
    types<- c("CellText.Number","CellText.String","CellText.VarName","CellText.VarValue")
    return (class(aCellText)[1]%in% types)
}

spss.GetMapObject<- function(object)
{
    if(class(object)[1]%in%c("CellText.Number","CellText.String","CellText.VarName","CellText.VarValue"))
      return (spss.CellTextMap[[object@index]])
    else if(class(object)[1]=="spss.Dimension")
      return (spss.DimensionMap[[object@index]])
    else if(class(object)[1]=="BasePivotTable")
      return (spss.PivotTableMap[[object@index]])
    else
    {
        last.SpssError <<- 1072
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)     
    }
}
spss.SetMapObject <- function(object)
{
    if(class(object)[1]%in%c("CellText.Number","CellText.String","CellText.VarName","CellText.VarValue"))
      spss.CellTextMap[[object@index]] <<- object
    else if(class(object)[1]=="spss.Dimension")
      spss.DimensionMap[[object@index]] <<- object
    else if(class(object)[1]=="BasePivotTable")
      spss.PivotTableMap[[object@index]] <<- object
    else
    {
        last.SpssError <<- 1072
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)     
    }
}
spss.AppendObjectMap <- function (object)
{
    if(class(object)[1]%in%c("CellText.Number","CellText.String","CellText.VarName","CellText.VarValue"))
    {
        spss.CellTextMap[[length(spss.CellTextMap)+1]] <<- object
        return(length(spss.CellTextMap))    
    }
    else if("spss.Dimension"==class(object)[1])
    {
        spss.DimensionMap[[length(spss.DimensionMap)+1]] <<- object
        return(length(spss.DimensionMap))    
    }    
    else if("BasePivotTable"==class(object)[1])
    {
        spss.PivotTableMap[[length(spss.PivotTableMap)+1]] <<- object
        return(length(spss.PivotTableMap))    
    }    
    else
    {
        last.SpssError <<- 1072
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)     
    }    
}




SetFormatSpec <- function(fmt,fmt2 = -1)
{
    err <- 0
    if ( formatSpec.Coefficient == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecCoefficient",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.CoefficientSE == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecCoefficientSE",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.CoefficientVar == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecCoefficientVar",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.Correlation == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecCorrelation",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.GeneralStat == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecGeneralStat",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.Mean == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecMean",as.integer(fmt2),as.integer(err),PACKAGE=spss_package)[[2]]
    else if ( formatSpec.Count == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecCount",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.Percent == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecPercent",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.PercentNoSign == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecPercentNoSign",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.Proportion == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecProportion",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.Significance == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecSignificance",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.Residual == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecResidual",as.integer(err),PACKAGE=spss_package)[[1]]
    else if ( formatSpec.Variable == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecVariable",as.integer(fmt2),as.integer(err),PACKAGE=spss_package)[[2]]
    else if ( formatSpec.StdDev == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecStdDev",as.integer(fmt2),as.integer(err),PACKAGE=spss_package)[[2]]
    else if ( formatSpec.Difference == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecDifference",as.integer(fmt2),as.integer(err),PACKAGE=spss_package)[[2]]
    else if ( formatSpec.Sum == fmt)
        last.SpssError <<- .C("ext_SetFormatSpecSum",as.integer(fmt2),as.integer(err),PACKAGE=spss_package)[[2]]
    else
        last.SpssError <<- 1006

    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
}

CellText._CellText__CheckType <- function(aCellText)
{
    aCellText <- spss.GetMapObject(aCellText)
    spssError.reset()
    if(!isInstanceofCellText(aCellText))
    {
      last.SpssError <<- 1039
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
}
CellText._CellText__CheckFormatSpec <- function(format)
{
    spssError.reset()

    tryCatch({formatSpec <- format[1]},
            error = function(ex) {
                    last.SpssError <<- 1049
                    stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
                }
        )
    tryCatch({varIndex <- format[2]},
            warning = function(ex) {
                    varIndex = NULL
                }
        )
    if(!(typeof(formatSpec)%in%c("numeric","double")) || formatSpec<0 || formatSpec > 15)
    {
      last.SpssError <<- 1049
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    if (formatSpec %in% c(formatSpec.Mean,
                          formatSpec.Variable,
                          formatSpec.StdDev,
                          formatSpec.Difference,
                          formatSpec.Sum))
    {
        if(is.null(varIndex))
        {
            last.SpssError <<- 1050
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
    }
}

CellText._CellText__SetFormatSpec <- function(format)
{
    CellText._CellText__CheckFormatSpec(format)    
    if (format[1] %in% c(formatSpec.Mean,                      
                      formatSpec.Variable,                     
                      formatSpec.StdDev,                       
                      formatSpec.Difference,                   
                      formatSpec.Sum))                         
        SetFormatSpec(format[1],format[2])       
                                                               
    else                                                       
        SetFormatSpec(format[1])            
}

CellText._CellText__SetDefaultFormatSpec <- function(format)
{
    spssError.reset()
    CellText._CellText__CheckFormatSpec(format)
    options(CellText._CellText__defaultFormatSpec = format)
}

CellText._CellText__GetDefaultFormatSpec <- function()
{
    return(getOption("CellText._CellText__defaultFormatSpec"))
}
CellText._CellText__ToCellText <- function(obj)
{
    spssError.reset()
    err <- 0
    obj <- spss.GetMapObject(obj)
    if(is.null(obj))
    {
        missingV <- 0.0
        obj <- .C("ext_GetSystemMissingValue",as.double(missingV),as.integer(err),PACKAGE=spss_package)[[1]]
    }
    if(isInstanceofCellText(obj))
        return (obj)
    else if(class(obj)=="character")
        return( spss.CellText.String(obj))
    else if (class(obj)%in%c("numeric","integer")||"POSIXt"==class(obj)[1])
        return (spss.CellText.Number(obj))
    else
    {
        last.SpssError <<- 1068
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
}

spss.CellText__Identical<- function(object1, object2)
{
  if(!class(object1)[1]%in%c("CellText.Number","CellText.String","CellText.VarName","CellText.VarValue"))
  {
      last.SpssError <<- 1039
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)  
  }
  if(!class(object2)[1]%in%c("CellText.Number","CellText.String","CellText.VarName","CellText.VarValue"))
  {
      last.SpssError <<- 1039
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)  
  }
  
  if(identical(object1@data, object2@data))
    return (TRUE)
  else
    return (FALSE)
}

setGeneric("CellText.toNumber", function(object) standardGeneric("CellText.toNumber"))
setGeneric("CellText.toString", function(object) standardGeneric("CellText.toString"))

setClass("CellText.Number",representation(data="list",index = "numeric"))

setMethod("initialize","CellText.Number",function(.Object, value,formatSpec=NULL,varIndex=NULL) {

    spssError.reset()
    if(is.na(value))
        value <- NaN
    if(class(value)[1]=="POSIXt")
        value <- as.double(difftime(as.POSIXct(value),as.POSIXct(0,origin="1582-10-14 00:00:00",tz="GMT"),units = "secs"))
    if(!class(value)%in%c("numeric","integer"))
    {
        last.SpssError <<- 1004
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    if(!is.null(varIndex)&&!class(varIndex)%in%c("numeric","integer"))
    {
        last.SpssError <<- 1004
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    .Object@data = list()
    .Object@data$"type" = 0
    .Object@data$"value" = as.double(value)
    if(is.null(formatSpec))
        .Object@data$"format" =  getOption("CellText._CellText__defaultFormatSpec")
    else
        .Object@data$"format" = c(formatSpec,varIndex)
    .Object@index<-length(spss.CellTextMap)+1
    .Object
})
spss.CellText.Number<- function(value, formatSpec=NULL, VarIndex=NULL)
{
    obj <- new("CellText.Number",value,formatSpec, VarIndex)
    spss.AppendObjectMap(obj)
    obj
}
setMethod("CellText.toNumber","CellText.Number",function(object) {
    object<-spss.GetMapObject(object)
    return (object@data$"value")
})

setMethod("CellText.toString","CellText.Number",function(object) {
    object <- spss.GetMapObject(object)
    return (as.character(object@data$"value"))
})

setClass("CellText.String",representation(data="list", index = "numeric"))

setMethod("initialize","CellText.String",function(.Object, value) {

    spssError.reset()

    .Object@data = list()
    .Object@data$"type" = 1
    .Object@data$"value" = value
    .Object@index<-length(spss.CellTextMap)+1
    spss.AppendObjectMap(.Object)
    .Object    
})
spss.CellText.String<- function(value)
{
    obj <- new("CellText.String", value)
    spss.AppendObjectMap(obj)
    obj
}

setMethod("CellText.toNumber","CellText.String",function(object) {
    object <- spss.GetMapObject(object)
    tryCatch({return (as.double(object@data$"value"))},
            error = function(ex) {
                    return (NULL)
                }
        )

})

setMethod("CellText.toString","CellText.String",function(object) {
    object <- spss.GetMapObject(object)
    return (object@data$"value")
})

setClass("CellText.VarName",representation(data="list", index = "numeric"))

setMethod("initialize","CellText.VarName",function(.Object, index) {

    spssError.reset()
    if(!class(index)%in%c("numeric","integer"))
    {
        last.SpssError <<- 1004
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    .Object@data = list()
    .Object@data$"type" = 2
    .Object@data$"varID" = index
    .Object@index<-length(spss.CellTextMap)+1
    .Object    
})
spss.CellText.VarName<- function(index)
{
    obj <- new("CellText.VarName",index)
    spss.AppendObjectMap(obj)
    obj
}
setMethod("CellText.toNumber","CellText.VarName",function(object) {return (NULL)})
setMethod("CellText.toString","CellText.VarName",function(object) {return (NULL)})

setClass("CellText.VarValue",representation(data="list", index = "numeric"))

setMethod("initialize","CellText.VarValue",function(.Object,index, value) {

    spssError.reset()
    if(!class(index)%in%c("numeric","integer"))
    {
        last.SpssError <<- 1004
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    .Object@data = list()
    .Object@data$"type" = 3
    .Object@data$"varID" = index
    
    varType = spssdictionary.GetVariableType(index)
    if(varType>0)
        value <- as.character(value)
    if(class(value)=="character")
        .Object@data$"value" <- value
    else if(class(value)%in%c("numeric","integer"))
        .Object@data$"value" <- as.double(value)
    else
    {
        last.SpssError <<- 1051
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    .Object@index<-length(spss.CellTextMap)+1
    .Object
})
spss.CellText.VarValue<- function(index, value)
{
    obj <- new("CellText.VarValue",index, value)
    spss.AppendObjectMap(obj)
    obj
}

setMethod("CellText.toNumber","CellText.VarValue",function(object) {return (NULL)})

setMethod("CellText.toString","CellText.VarValue",function(object) {return (NULL)})

# Defines Place constants.
Dimension.Place.row <- 0
Dimension.Place.column <- 1
Dimension.Place.layer <- 2

Dimension._Dimension__CheckPlace <- function(place)
{
  if(!place%in%c(Dimension.Place.row,Dimension.Place.column,Dimension.Place.layer))
  {
        last.SpssError <<- 1042
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)  
  }
}

Dimension._Dimension__contains__<- function(obj, objSet)
{ 
    ## only compare index, no need to update the object    
    find <- 0
    if(length(objSet)<1)
      return (find)
    for(d in 1:length(objSet))
    {
        
        if(objSet[[d]]@index==obj@index)
        {
          find <- d
          break;
        }     
    }
    return (find)    
}


##
#    Dimension class. Don't use it directly except for its constants below:
#        Place.row
#        Place.column
#        Place.layer
##
setClass("spss.Dimension",representation(name="character",
                                    place = "numeric",
                                    position = "numeric", 
                                    hideName = "logical", 
                                    hideLabels="logical",
                                    tableAttr = "list",
                                    categories = "list",
                                    current = "ANY",
                                    index = "numeric"
                                      ))
setMethod("initialize","spss.Dimension",function(.Object,name,place,position,hideName=FALSE,hideLabels=FALSE) {

    spssError.reset()
    Dimension._Dimension__CheckPlace(place)
    if(!class(position)=="numeric"|| (position-as.integer(position))!= 0)
    {
        last.SpssError <<- 1069
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
    }
    if(!class(hideName)=="logical")
    {
        last.SpssError <<- 1070
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
    }
    if(!class(hideLabels)=="logical")
    {
        last.SpssError <<- 1070
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
    }
    .Object@name = name
    .Object@place = place
    .Object@position = position
    .Object@hideName = hideName
    .Object@hideLabels = hideLabels
    .Object@tableAttr = list()
    .Object@categories = list()
    .Object@current = NULL
    .Object@index = length(spss.DimensionMap)+1
    .Object
})

    
setGeneric("spss._Dimension__append", function(object,outline,title,templateName, isSplit = FALSE) standardGeneric("spss._Dimension__append"))
setMethod("spss._Dimension__append","spss.Dimension",function(object,outline,title,templateName, isSplit = FALSE) {
    object <- spss.GetMapObject(object)
    spssError.reset()

    if (nchar(templateName)<1||nchar(templateName)>64)
    {
        last.SpssError <<- 1036
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)       
    } 
    if(!(tolower(substr(templateName,1,1))%in%letters))
    {
        last.SpssError <<- 1036
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)       
    }
    if(!(class(isSplit)=="logical"))
    {
        last.SpssError <<- 1070
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)     
    } 
    object@tableAttr$"outline" = outline
    object@tableAttr$"title" = title
    object@tableAttr$"templateName" = templateName
    object@tableAttr$"isSplit" = isSplit
    err <- 0          
    out <- .C("ext_AddDimension",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                 as.character(unicodeConverterInput(object@tableAttr$"title")),
                                 as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                 as.integer(object@tableAttr$"isSplit"),
                                 as.character(unicodeConverterInput(object@name)),
                                 as.integer(object@place),
                                 as.integer(object@position),
                                 as.logical(object@hideName),
                                 as.logical(object@hideLabels),
                                 as.integer(err),
                                 PACKAGE=spss_package)
    last.SpssError <<- out[[10]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    spss.SetMapObject(object)        
})

setGeneric("spss._Dimension__update", function(object) standardGeneric("spss._Dimension__update"))
setMethod("spss._Dimension__update","spss.Dimension",function(object) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    err<-0
    out <- .C("ext_AddDimension",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                 as.character(unicodeConverterInput(object@tableAttr$"title")),
                                 as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                 as.integer(object@tableAttr$"isSplit"),
                                 as.character(unicodeConverterInput(object@name)),
                                 as.integer(object@place),
                                 as.integer(object@position),
                                 as.logical(object@hideName),
                                 as.logical(object@hideLabels),
                                 as.integer(err),
                                 PACKAGE=spss_package)
    last.SpssError <<- out[[10]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    spss.SetMapObject(object)    
})

setGeneric("spss._Dimension__AddFootnotes", function(object, footnotes) standardGeneric("spss._Dimension__AddFootnotes"))
setMethod("spss._Dimension__AddFootnotes","spss.Dimension",function(object, footnotes) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    err<-0
    out <- .C("ext_AddCellFootnotes",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                 as.character(unicodeConverterInput(object@tableAttr$"title")),
                                 as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                 as.integer(object@tableAttr$"isSplit"),
                                 as.character(unicodeConverterInput(object@name)),
                                 as.integer(object@place),
                                 as.integer(object@position),
                                 as.logical(object@hideName),
                                 as.logical(object@hideLabels),
                                 as.character(unicodeConverterInput(footnotes)),
                                 as.integer(err),
                                 PACKAGE=spss_package)
    last.SpssError <<- out[[11]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    spss.SetMapObject(object)    
})

setGeneric("spss._Dimension__AddDimFootnotes", function(object, footnotes) standardGeneric("spss._Dimension__AddDimFootnotes"))
setMethod("spss._Dimension__AddDimFootnotes","spss.Dimension",function(object, footnotes) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    err<-0
    out <- .C("ext_AddDimFootnotes",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                 as.character(unicodeConverterInput(object@tableAttr$"title")),
                                 as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                 as.integer(object@tableAttr$"isSplit"),
                                 as.character(unicodeConverterInput(object@name)),
                                 as.integer(object@place),
                                 as.integer(object@position),
                                 as.logical(object@hideName),
                                 as.logical(object@hideLabels),
                                 as.character(unicodeConverterInput(footnotes)),
                                 as.integer(err),
                                 PACKAGE=spss_package)
    last.SpssError <<- out[[11]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    spss.SetMapObject(object)    
})

setGeneric("spss._Dimension__AddCategoryFootnotes", function(object, footnotes) standardGeneric("spss._Dimension__AddCategoryFootnotes"))
setMethod("spss._Dimension__AddCategoryFootnotes","spss.Dimension",function(object, footnotes) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    err<-0
    out <- .C("ext_AddCategoryFootnotes",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                 as.character(unicodeConverterInput(object@tableAttr$"title")),
                                 as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                 as.integer(object@tableAttr$"isSplit"),
                                 as.character(unicodeConverterInput(object@name)),
                                 as.integer(object@place),
                                 as.integer(object@position),
                                 as.logical(object@hideName),
                                 as.logical(object@hideLabels),
                                 as.character(unicodeConverterInput(footnotes)),
                                 as.integer(err),
                                 PACKAGE=spss_package)
    last.SpssError <<- out[[11]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    spss.SetMapObject(object)    
})
 
setGeneric("spss._Dimension__SetCategory", function(object,cate) standardGeneric("spss._Dimension__SetCategory"))
setMethod("spss._Dimension__SetCategory","spss.Dimension",function(object,cate) {
    object <- spss.GetMapObject(object)
    cate <- spss.GetMapObject(cate)
    spssError.reset()
    CellText._CellText__CheckType(cate)
    cateIndex <- Dimension._Dimension__contains__(cate,object@categories)
    if(cateIndex==0)
         object@categories[[length(object@categories)+1]]<- cate
    object@current <- cate
    err<-0
    if(cate@data$"type"==0) #Number
    {
        format<- cate@data$"format"
        CellText._CellText__SetFormatSpec(format)
        out <- .C("ext_AddNumberCategory",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                  as.character(unicodeConverterInput(object@tableAttr$"title")),
                                  as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                  as.integer(object@tableAttr$"isSplit"), 
                                  as.character(unicodeConverterInput(object@name)),
                                  as.integer(object@place),
                                  as.integer(object@position),
                                  as.logical(object@hideName),
                                  as.logical(object@hideLabels),
                                  as.double(cate@data$"value"),
                                  as.integer(err),
                                  PACKAGE=spss_package)
        last.SpssError <<- out[[11]]    
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
        
    } else if(cate@data$"type"==1)
    {     
        out <- .C("ext_AddStringCategory",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                  as.character(unicodeConverterInput(object@tableAttr$"title")),
                                  as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                  as.integer(object@tableAttr$"isSplit"), 
                                  as.character(unicodeConverterInput(object@name)),
                                  as.integer(object@place),
                                  as.integer(object@position),
                                  as.logical(object@hideName),
                                  as.logical(object@hideLabels),
                                  as.character(unicodeConverterInput(cate@data$"value")),
                                  as.integer(err),
                                  PACKAGE=spss_package)
        last.SpssError <<- out[[11]]    
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }    
    } else if(cate@data$"type"==2)
    {
        out <- .C("ext_AddVarNameCategory",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                  as.character(unicodeConverterInput(object@tableAttr$"title")),
                                  as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                  as.integer(object@tableAttr$"isSplit"), 
                                  as.character(unicodeConverterInput(object@name)),
                                  as.integer(object@place),
                                  as.integer(object@position),
                                  as.logical(object@hideName),
                                  as.logical(object@hideLabels),
                                  as.integer(cate@data$"varID"),
                                  as.integer(err),
                                  PACKAGE=spss_package)
        last.SpssError <<- out[[11]]    
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }        
    } else if(cate@data$"type"==3)
    {
      if(class(cate@data$"value")=="character")
      {
          out <- .C("ext_AddVarValueStringCategory",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                    as.character(unicodeConverterInput(object@tableAttr$"title")),
                                    as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                    as.integer(object@tableAttr$"isSplit"), 
                                    as.character(unicodeConverterInput(object@name)),
                                    as.integer(object@place),
                                    as.integer(object@position),
                                    as.logical(object@hideName),
                                    as.logical(object@hideLabels),
                                    as.integer(cate@data$"varID"),
                                    as.character(unicodeConverterInput(cate@data$"value")),
                                    as.integer(err),
                                    PACKAGE=spss_package)
          last.SpssError <<- out[[12]]    
          if( is.SpssError(last.SpssError))
          {
              if( !getOption("is.splitConnectionOpen") )
                  .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
              stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
          }                
       } else
       {
           out <- .C("ext_AddVarValueDoubleCategory",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                      as.character(unicodeConverterInput(object@tableAttr$"title")),
                                      as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                      as.integer(object@tableAttr$"isSplit"), 
                                      as.character(unicodeConverterInput(object@name)),
                                      as.integer(object@place),
                                      as.integer(object@position),
                                      as.logical(object@hideName),
                                      as.logical(object@hideLabels),
                                      as.integer(cate@data$"varID"),
                                      as.double(cate@data$"value"),
                                      as.integer(err),
                                      PACKAGE=spss_package)
            last.SpssError <<- out[[12]]    
            if( is.SpssError(last.SpssError))
            {
                if( !getOption("is.splitConnectionOpen") )
                    .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
            }                
       }    
    }
    spss.SetMapObject(cate)
    spss.SetMapObject(object)
}) 
setGeneric("spss._Dimension__SetCell", function(object,cell) standardGeneric("spss._Dimension__SetCell"))
setMethod("spss._Dimension__SetCell","spss.Dimension",function(object,cell) {
    object <- spss.GetMapObject(object)
    cell <- spss.GetMapObject(cell)
    spssError.reset()
    err<-0
    CellText._CellText__CheckType(cell)
    if(0== cell@data$"type")
    {
        format <- cell@data$"format"
        CellText._CellText__SetFormatSpec(format)
        out <- .C("ext_SetNumberCell",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                      as.character(unicodeConverterInput(object@tableAttr$"title")),
                                      as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                      as.integer(object@tableAttr$"isSplit"), 
                                      as.character(unicodeConverterInput(object@name)),
                                      as.integer(object@place),
                                      as.integer(object@position),
                                      as.logical(object@hideName),
                                      as.logical(object@hideLabels),
                                      as.double(cell@data$"value"),
                                      as.integer(err),
                                      PACKAGE=spss_package)
        last.SpssError <<- out[[11]]    
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }   
    } else if(1== cell@data$"type")
    {
        out <- .C("ext_SetStringCell",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                      as.character(unicodeConverterInput(object@tableAttr$"title")),
                                      as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                      as.integer(object@tableAttr$"isSplit"), 
                                      as.character(unicodeConverterInput(object@name)),
                                      as.integer(object@place),
                                      as.integer(object@position),
                                      as.logical(object@hideName),
                                      as.logical(object@hideLabels),
                                      as.character(unicodeConverterInput(cell@data$"value")),
                                      as.integer(err),
                                      PACKAGE=spss_package)
        last.SpssError <<- out[[11]]    
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }    
    } else if(2 == cell@data$"type")
    {
        out <- .C("ext_SetVarNameCell",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                      as.character(unicodeConverterInput(object@tableAttr$"title")),
                                      as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                      as.integer(object@tableAttr$"isSplit"), 
                                      as.character(unicodeConverterInput(object@name)),
                                      as.integer(object@place),
                                      as.integer(object@position),
                                      as.logical(object@hideName),
                                      as.logical(object@hideLabels),
                                      as.integer(cell@data$"varID"),
                                      as.integer(err),
                                      PACKAGE=spss_package)
        last.SpssError <<- out[[11]]    
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }        
    } else if(3 == cell@data$"type")
    {
        if(class(cell@data$"value")== "character")
        {
          out <- .C("ext_SetVarValueStringCell",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                                as.character(unicodeConverterInput(object@tableAttr$"title")),
                                                as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                                as.integer(object@tableAttr$"isSplit"), 
                                                as.character(unicodeConverterInput(object@name)),
                                                as.integer(object@place),
                                                as.integer(object@position),
                                                as.logical(object@hideName),
                                                as.logical(object@hideLabels),
                                                as.integer(cell@data$"varID"),
                                                as.character(unicodeConverterInput(cell@data$"value")),
                                                as.integer(err),
                                                PACKAGE=spss_package)
          last.SpssError <<- out[[12]]    
          if( is.SpssError(last.SpssError))
          {
              if( !getOption("is.splitConnectionOpen") )
                  .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
              stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
          }       
        }else
        {
          out <- .C("ext_SetVarValueDoubleCell",as.character(unicodeConverterInput(object@tableAttr$"outline")),
                                                as.character(unicodeConverterInput(object@tableAttr$"title")),
                                                as.character(unicodeConverterInput(object@tableAttr$"templateName")),
                                                as.integer(object@tableAttr$"isSplit"), 
                                                as.character(unicodeConverterInput(object@name)),
                                                as.integer(object@place),
                                                as.integer(object@position),
                                                as.logical(object@hideName),
                                                as.logical(object@hideLabels),
                                                as.integer(cell@data$"varID"),
                                                as.double(cell@data$"value"),
                                                as.integer(err),
                                                PACKAGE=spss_package)
          last.SpssError <<- out[[12]]    
          if( is.SpssError(last.SpssError))
          {
              if( !getOption("is.splitConnectionOpen") )
                  .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
              stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
          }               
        }
         
    }
    spss.SetMapObject(cell)
    spss.SetMapObject(object)    
}) 




setClass("BasePivotTable",representation(outline = "character", 
                                         title  = "character", 
                                         templateName = "character",
                                         isSplit = "logical",
                                         dims = "list",
                                         cells = "list",
                                         caption = "character",
                                         index = "numeric"))
setMethod("initialize", "BasePivotTable", function(.Object,title,templateName,outline="",isSplit=TRUE,caption="" ){
    spssError.reset()
    err <- 0
    
    if(is.null(getOption("CellText._CellText__defaultFormatSpec"))) options(CellText._CellText__defaultFormatSpec = formatSpec.GeneralStat)
    
    if(nchar(templateName)<1 || nchar(templateName)>64)
    {
      last.SpssError <<- 1036
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA) 
    }
    if(!(tolower(substr(templateName,1,1))%in% letters))
    {
      last.SpssError <<- 1036
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)       
    }
    
    .Object@outline <- outline
    .Object@title <- title
    .Object@templateName <- templateName
    .Object@isSplit <- isSplit
    .Object@dims <- list()
    .Object@cells <- list()
    .Object@caption <- caption
    
    out <- .C("ext_StartPivotTable",as.character(unicodeConverterInput(.Object@outline)),
                                          as.character(unicodeConverterInput(.Object@title)),
                                          as.character(unicodeConverterInput(.Object@templateName)),
                                          as.integer(.Object@isSplit),
                                          as.integer(err),
                                          PACKAGE=spss_package)
    last.SpssError <<- out[[5]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    if(.Object@caption!="")
    {
        out <- .C("ext_PivotTableCaption",as.character(unicodeConverterInput(.Object@outline)),
                                              as.character(unicodeConverterInput(.Object@title)),
                                              as.character(unicodeConverterInput(.Object@templateName)),
                                              as.integer(.Object@isSplit),
                                              as.character(unicodeConverterInput(.Object@caption)),
                                              as.integer(err),
                                              PACKAGE=spss_package)
        last.SpssError <<- out[[6]]    
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }    
    }
    #BasePivotTable.Caption(.Object, caption)                 
    BasePivotTable.SetDefaultFormatSpec(.Object, formatSpec.GeneralStat)
    .Object@index <- length(spss.PivotTableMap)+1    
    .Object
})

spss.BasePivotTable<-function(title,templateName,outline="",isSplit=TRUE,caption="")
{
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    obj<- new("BasePivotTable",title,templateName,outline,isSplit,caption)

    spss.AppendObjectMap(obj)
    obj
}

setGeneric("BasePivotTable.Caption", function(object, caption) standardGeneric("BasePivotTable.Caption"))
setMethod("BasePivotTable.Caption","BasePivotTable", function(object, caption) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    object@caption <- caption
    err<- 0
    out <- .C("ext_PivotTableCaption",as.character(unicodeConverterInput(object@outline)),
                                          as.character(unicodeConverterInput(object@title)),
                                          as.character(unicodeConverterInput(object@templateName)),
                                          as.integer(object@isSplit),
                                          as.character(unicodeConverterInput(caption)),
                                          as.integer(err),
                                          PACKAGE=spss_package)
    last.SpssError <<- out[[6]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    spss.SetMapObject(object)
})    

setGeneric("BasePivotTable.SetDefaultFormatSpec", function(object,formatSpec,varIndex=NULL) standardGeneric("BasePivotTable.SetDefaultFormatSpec"))
setMethod("BasePivotTable.SetDefaultFormatSpec","BasePivotTable", function(object,formatSpec,varIndex=NULL) {
    spssError.reset()  
    CellText._CellText__SetDefaultFormatSpec(c(formatSpec,varIndex))
})  

setGeneric("BasePivotTable.GetDefaultFormatSpec", function(object) standardGeneric("BasePivotTable.GetDefaultFormatSpec"))
setMethod("BasePivotTable.GetDefaultFormatSpec","BasePivotTable", function(object) {
    spssError.reset()  
    return (CellText._CellText__GetDefaultFormatSpec())
})


        
setGeneric("BasePivotTable.GetCellValue", function(object,categories) standardGeneric("BasePivotTable.GetCellValue"))
setMethod("BasePivotTable.GetCellValue","BasePivotTable", function(object,categories) {
    spssError.reset()
    object <- spss.GetMapObject(object)
    categories<- spss.Objectsapply(categories,spss.GetMapObject) 
    err <- 0 
    if(!(class(categories)%in%c("list")))
    {
      last.SpssError <<- 1071    
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)   
    }
    #The categories must match with the structure of the dimensions. One for each Dimension.
    if(length(categories)!= length(object@dims))
    {
      last.SpssError <<- 1038    
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    spss.Objectsapply(categories,CellText._CellText__CheckType)
    
    for(tempcell in object@cells)
    {
      if(length(tempcell)>2)
      {
        find <- TRUE
        len <- length(categories)
        for(j in 1:len)
        {
          for(k in 1: len)
          {
            if(spss.CellText__Identical(tempcell[[k]],categories[[j]]))
                break
            else 
            {
              if(k==len)
                 find <- FALSE
            } 
          }      
        }
        if(find==TRUE)
        return (tempcell[[length(tempcell)]])
      }       
    }
    return (NULL)      
}) 

setGeneric("BasePivotTable.SetCellValue", function(object,categories, cell) standardGeneric("BasePivotTable.SetCellValue"))
setMethod("BasePivotTable.SetCellValue","BasePivotTable", function(object, categories, cell) {
    object <- spss.GetMapObject(object)
    categories<- spss.Objectsapply(categories,spss.GetMapObject)
    cell <- spss.GetMapObject(cell)
    spssError.reset()
    err <- 0       
    if(!class(categories)%in%c("list"))
    {
      last.SpssError <<- 1071    
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)   
    }
    #The categories must match with the structure of the dimensions. One for each Dimension.
    if(length(categories)!= length(object@dims))
    {
      last.SpssError <<- 1038    
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    spss.Objectsapply(categories,CellText._CellText__CheckType)
    for(i in 1: length(object@dims))
    {
        spss._Dimension__SetCategory(object@dims[[i]],categories[[i]])
        object@dims[[i]] <- spss.GetMapObject(object@dims[[i]])
        categories[[i]] <- spss.GetMapObject(categories[[i]])
    }
    
    if(!is.null(cell))
    {
        #The given cell must be a object of CellText.
        CellText._CellText__CheckType(cell)
        #Adds the cell to the pivot table.
        spss._Dimension__SetCell(object@dims[[length(object@dims)]],cell)
        object@dims[[length(object@dims)]] <- spss.GetMapObject(object@dims[[length(object@dims)]])
    }
    #Saves the cell for retrieve.
    categories[[length(categories)+1]]<- cell
    object@cells[[length(object@cells)+1]] <- categories
    spss.Objectsapply(categories,spss.SetMapObject)
    spss.SetMapObject(cell)
    spss.SetMapObject(object)  
})

setGeneric("BasePivotTable.Insert", function(object,i,place,dimName,hideName=FALSE, hideLabels=FALSE) standardGeneric("BasePivotTable.Insert"))
setMethod("BasePivotTable.Insert","BasePivotTable", function(object,i,place,dimName,hideName=FALSE, hideLabels=FALSE) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    err<- 0
    pos <- vector()
    for(x in object@dims)
    {
      if (x@place == place)
        pos <- c(pos,x@position)
    }
    tryCatch({
      if((i > max(pos)+1) || (i<min(pos)-1))
      {
        last.SpssError <<- 1031    
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
      }
    },
     error = function(ex) {
      if(i != 1)
      {
        last.SpssError <<- 1031    
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)             
      }
    })
    
    moves<- vector()
    if(length(object@dims)>0)
    {
        for(index in 1: length(object@dims))
        {
            dim <- object@dims[[index]]
            if(dim@place == place && dim@position >= i)
              moves<- c(moves,index)
        }
        for(index in moves)
        {
            object@dims[[index]]@position <- object@dims[[index]]@position + 1
            spss._Dimension__update(object@dims[[index]])
            spss.SetMapObject(object@dims[[index]])
        }
    }      
    dim <- new("spss.Dimension",dimName,place,i,hideName, hideLabels)
    #maintain the ObjectMap
    spss.AppendObjectMap(dim)
    outline <- object@outline
    title <- object@title
    templateName <- object@templateName
    spss._Dimension__append(dim,outline,title,templateName,object@isSplit)
    dim <- spss.GetMapObject(dim)
    if(Dimension._Dimension__contains__(dim, object@dims)==0)
       object@dims[[length(object@dims)+1]] <- dim
    spss.SetMapObject(dim)
    spss.SetMapObject(object)   
    return (dim)
})
        
setGeneric("BasePivotTable.Append", function(object,place,dimName,hideName=FALSE, hideLabels=FALSE) standardGeneric("BasePivotTable.Append"))
setMethod("BasePivotTable.Append","BasePivotTable", function(object,place,dimName,hideName=FALSE, hideLabels=FALSE) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    if(length(object@dims)>0)
    {
      for(i in 1:length(object@dims))
      {     
          if(object@dims[[i]]@place == place)
          {
              object@dims[[i]]@position <- object@dims[[i]]@position +1
              spss._Dimension__update(object@dims[[i]])
              spss.SetMapObject(object@dims[[i]])
          }
      }
    }
    dim <- new ("spss.Dimension",dimName,place,1,hideName, hideLabels)
    spss.AppendObjectMap(dim)
    outline <- object@outline
    title <- object@title
    templateName <- object@templateName
    spss._Dimension__append(dim,outline,title,templateName,object@isSplit)
    dim<-spss.GetMapObject(dim)
    dimIndex<- Dimension._Dimension__contains__(dim, object@dims)
    if(dimIndex==0)
    {
        object@dims[[length(object@dims)+1]] <- dim
    }

    spss.SetMapObject(object)
    return (dim)  
})


## support object and list only.
spss.Objectsapply<- function(objects, FUN)
{
    retVal<- list()
    if(class(objects)!= "list")
    {
      retVal[[1]]<-FUN(objects)      
    }
    else
    {      
      for(obj in objects)
        retVal[[length(retVal)+1]]<-FUN(obj)      
    } 
    return (retVal)     
}

setGeneric("BasePivotTable.SetCategories", function(object,dim,categories) standardGeneric("BasePivotTable.SetCategories"))
setMethod("BasePivotTable.SetCategories","BasePivotTable", function(object,dim,categories) {
    object <- spss.GetMapObject(object)
    dim <- spss.GetMapObject(dim)
    categories <- spss.Objectsapply(categories,spss.GetMapObject)
    spssError.reset()
    err <- 0
    if(class(dim)[1]!= "spss.Dimension")
    {
        last.SpssError <<- 1037    
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    dimIndex<- Dimension._Dimension__contains__(dim, object@dims)
    if(dimIndex==0)
    {
        last.SpssError <<- 1046    
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    if(class(categories)!="list")
    {
        spss._Dimension__SetCategory(dim,categories)
        dim <- spss.GetMapObject(dim)
    }
    else
    {
        for(cat in categories)
        {
           spss._Dimension__SetCategory(dim,cat)
           dim <- spss.GetMapObject(dim)
        }
    }
    
    object@dims[[dimIndex]] <- dim

    spss.Objectsapply(categories,spss.SetMapObject)  
    spss.SetMapObject(object)
    spss.SetMapObject(dim)   
})

#setGeneric("BasePivotTable.SetCell", function(object,cell) standardGeneric("BasePivotTable.SetCell"))
#setMethod("BasePivotTable.SetCell","BasePivotTable", function(object,cell) {
#    object <- spss.GetMapObject(object)  
#    cell <- spss.GetMapObject(cell)  
#    spssError.reset()
#    dim <- object@dims[[length(object@dims)]]
#    spss._Dimension__SetCategory(dim,dim@current)
#    dim <- spss.GetMapObject(dim)
#    spss._Dimension__SetCell(dim,cell)
#    dim <- spss.GetMapObject(dim)
#    categories <- list()
#    for(dim in object@dims)
#    {
#        categories[length(categories)+1] <- dim@current
#    }
#    object <- BasePivotTable.SetCellValue(object, categories,cell)
#    spss.SetMapObject(cell)
#    spss.SetMapObject(object)
#}) 

setGeneric("BasePivotTable.SetCellsByRow", function(object,rowlabels,cells) standardGeneric("BasePivotTable.SetCellsByRow"))
setMethod("BasePivotTable.SetCellsByRow","BasePivotTable", function(object,rowlabels,cells) {
    object <- spss.GetMapObject(object)  
    cells <- spss.Objectsapply(cells,spss.GetMapObject)
    rowlabels<- spss.Objectsapply(rowlabels,spss.GetMapObject)
    rows<- list()
    err<-0
    for(x in object@dims)
    {
        if(x@place == Dimension.Place.row)
          rows[[length(rows)+1]] <- x
    }      
    cols <- list()    
    for(x in object@dims)
    {
        if(x@place == Dimension.Place.column)
          cols[[length(cols)+1]] <- x
    }
    
    if(length(cols)>1)
    {
        last.SpssError <<- 1045
        if( getOption("is.pvTableConnectionOpen") )
        {
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            options(is.pvTableConnectionOpen = FALSE)
        }
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)      
    } 
    col <- cols[[1]]
    if(length(rows)!= length(rowlabels))
    {
        last.SpssError <<- 1038
        if( getOption("is.pvTableConnectionOpen") )
        {
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            options(is.pvTableConnectionOpen = FALSE)
        }
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)       
    }
    
    for(i in 1:length(rows))
    {
        spss._Dimension__SetCategory(rows[[i]], rowlabels[[i]])
        rows[[i]] <- spss.GetMapObject(rows[[i]])
    }

    if(length(col@categories)!= length(cells))
    {
        last.SpssError <<- 1032    
        if( getOption("is.pvTableConnectionOpen") )
        {
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            options(is.pvTableConnectionOpen = FALSE)
        }
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)      
    }
    for(i in 1:length(col@categories))
    {
        spss._Dimension__SetCategory(col,col@categories[[i]])
        col <- spss.GetMapObject(col)
        spss._Dimension__SetCell(col, cells[[i]])
        ## ( col <- spss.GetMapObject(col) no needed for the function defination)
        tempCate<- list()
        for(dim in object@dims)
        {
            if(dim@place== Dimension.Place.column)
               tempCate[[length(tempCate)+1]] <- col@categories[[i]]  
            else
              for(rowlabel in rowlabels)
                  for(cate in dim@categories)
                     if(rowlabel@index == cate@index)
                        tempCate[[length(tempCate)+1]] <- rowlabel   
        }      
        BasePivotTable.SetCellValue(object, tempCate, cells[[i]])
        object <- spss.GetMapObject(object)
        rowlabels <- spss.Objectsapply(rowlabels, spss.GetMapObject)
        cells[[i]] <- spss.GetMapObject(cells[[i]])
        
    }
    
    spss.Objectsapply(rowlabels, spss.SetMapObject)
    spss.Objectsapply(cells,spss.SetMapObject)
    spss.SetMapObject(object)
})   

setGeneric("BasePivotTable.SetCellsByColumn", function(object,collabels,cells) standardGeneric("BasePivotTable.SetCellsByColumn"))
setMethod("BasePivotTable.SetCellsByColumn","BasePivotTable", function(object,collabels,cells) {
    object <- spss.GetMapObject(object)  
    cells <- spss.Objectsapply(cells,spss.GetMapObject)
    collabels<- spss.Objectsapply(collabels,spss.GetMapObject)
    cols<- list()
    err<-0
    for(x in object@dims)
    {
        if(x@place == Dimension.Place.column)
          cols[[length(cols)+1]] <- x
    }      
    rows <- list()    
    for(x in object@dims)
    {
        if(x@place == Dimension.Place.row)
          rows[[length(rows)+1]] <- x
    }
    
    if(length(rows)>1)
    {
        last.SpssError <<- 1044
        if(getOption("is.pvTableConnectionOpen"))
        {
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            options(is.pvTableConnectionOpen = FALSE)
        }
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)      
    } 
    row <- rows[[1]]
    if(length(cols)!= length(collabels))
    {
        last.SpssError <<- 1038   
        if(getOption("is.pvTableConnectionOpen"))
        {
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            options(is.pvTableConnectionOpen = FALSE)
        }
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)       
    }
    
    for(i in 1:length(cols))
    {
        spss._Dimension__SetCategory(cols[[i]], collabels[[i]])
        cols[[i]] <- spss.GetMapObject(cols[[i]])
    }
    if(length(row@categories)!= length(cells))
    {
        last.SpssError <<- 1032    
        if(getOption("is.pvTableConnectionOpen"))
        {
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            options(is.pvTableConnectionOpen = FALSE)
        }
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)      
    }
    for(i in 1:length(row@categories))
    {
        spss._Dimension__SetCategory(row,row@categories[[i]])
        row <- spss.GetMapObject(row)
        spss._Dimension__SetCell(row, cells[[i]])
        
        tempCate<- list()
        for(dim in object@dims)
        {
            if(dim@place== Dimension.Place.row)
               tempCate[[length(tempCate)+1]] <- row@categories[[i]]  
            else
              for(collabel in collabels)
                  for(cate in dim@categories)
                     if(collabel@index == cate@index)
                        tempCate[[length(tempCate)+1]] <- collabel   
        }        
        
        BasePivotTable.SetCellValue(object, tempCate, cells[[i]])
        object <- spss.GetMapObject(object)
        collabels <- spss.Objectsapply(collabels, spss.GetMapObject)
        cells[[i]] <- spss.GetMapObject(cells[[i]])
    }
    
    spss.Objectsapply(collabels, spss.SetMapObject)
    spss.Objectsapply(cells,spss.SetMapObject)
    spss.SetMapObject(object)
})   
                
setGeneric("BasePivotTable.HideTitle", function(object) standardGeneric("BasePivotTable.HideTitle"))
setMethod("BasePivotTable.HideTitle","BasePivotTable", function(object) {
    object <- spss.GetMapObject(object)  
    spssError.reset()
    err<- 0
    out <- .C("ext_HidePivotTableTitle",as.character(unicodeConverterInput(object@outline)),
                                          as.character(unicodeConverterInput(object@title)),
                                          as.character(unicodeConverterInput(object@templateName)),
                                          as.integer(object@isSplit),
                                          as.integer(err),
                                          PACKAGE=spss_package)
    last.SpssError <<- out[[5]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }  
    spss.SetMapObject(object)
})

setGeneric("BasePivotTable.Footnotes", function(object, categories, footnotes) standardGeneric("BasePivotTable.Footnotes"))
setMethod("BasePivotTable.Footnotes","BasePivotTable", function(object, categories, footnotes) {
    object <- spss.GetMapObject(object)
    categories <- spss.Objectsapply(categories, spss.GetMapObject) 
    spssError.reset()
    if(class(categories)!= "list")
    {
        last.SpssError <<- 1027
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    if(is.null(footnotes))
    {
        last.SpssError <<- 1075
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)   
    }
    if(length(categories)!= length(object@dims))
    {
        last.SpssError <<- 1038
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    spss.Objectsapply(categories, CellText._CellText__CheckType)   
    cell <- BasePivotTable.GetCellValue(object, categories)
    if(is.null(cell))
    {
        last.SpssError <<- 1041
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
    }
    ## Below loop will guarantee that the disordered categories will be 
    ## mapped into corresponding dimension.
    for(i in 1:length(categories))
    {
        tempdim <- object@dims[[i]]
        for(k in 1:length(tempdim@categories))
        {
          if(spss.CellText__Identical(tempdim@categories[[k]],categories[[i]]))
          {
            spss._Dimension__SetCategory(object@dims[[i]], categories[[i]])
            object@dims[[i]]<- spss.GetMapObject(object@dims[[i]])
            categories[[i]] <- spss.GetMapObject(categories[[i]])
            break 
          }
          else if(k == length(tempdim@categories))
          {
            # invalide dimension category
            last.SpssError <<- 1076
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)               
          }
        }
    }
    spss._Dimension__SetCell(object@dims[[length(object@dims)]], cell)
    spss._Dimension__AddFootnotes(object@dims[[length(object@dims)]], footnotes)
    spss.Objectsapply(categories, spss.SetMapObject)
    spss.SetMapObject(object)
})

setGeneric("BasePivotTable.TitleFootnotes", function(object, footnotes) standardGeneric("BasePivotTable.TitleFootnotes"))
setMethod("BasePivotTable.TitleFootnotes","BasePivotTable", function(object, footnotes) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    err<- 0
    out <- .C("ext_AddTitleFootnotes",as.character(unicodeConverterInput(object@outline)),
                                          as.character(unicodeConverterInput(object@title)),
                                          as.character(unicodeConverterInput(object@templateName)),
                                          as.integer(object@isSplit),
                                          as.character(unicodeConverterInput(footnotes)),
                                          as.integer(err),
                                          PACKAGE=spss_package)
    last.SpssError <<- out[[6]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }  
    spss.SetMapObject(object)
})

setGeneric("BasePivotTable.OutlineFootnotes", function(object, footnotes) standardGeneric("BasePivotTable.OutlineFootnotes"))
setMethod("BasePivotTable.OutlineFootnotes","BasePivotTable", function(object, footnotes) {
    object <- spss.GetMapObject(object)
    spssError.reset()
    err<- 0
    out <- .C("ext_AddOutlineFootnotes",as.character(unicodeConverterInput(object@outline)),
                                          as.character(unicodeConverterInput(object@title)),
                                          as.character(unicodeConverterInput(object@templateName)),
                                          as.integer(object@isSplit),
                                          as.character(unicodeConverterInput(footnotes)),
                                          as.integer(err),
                                          PACKAGE=spss_package)
    last.SpssError <<- out[[6]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }  
    spss.SetMapObject(object)
})

setGeneric("BasePivotTable.DimensionFootnotes", function(object, dimPlace, dimName, footnotes) standardGeneric("BasePivotTable.DimensionFootnotes"))
setMethod("BasePivotTable.DimensionFootnotes","BasePivotTable", function(object, dimPlace, dimName, footnotes) {
    object <- spss.GetMapObject(object)
    
    invalidDim <- TRUE
    for(dim in object@dims)
    {
        if(dimName == dim@name && dimPlace == dim@place)
        {
            spss._Dimension__AddDimFootnotes(dim, footnotes)
            invalidDim <- FALSE
            break
        }
    }
    
    if(invalidDim == TRUE)
    {
        spss._Dimension__CheckPlace(dimPlace)
        last.SpssError <<- 1043        
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)       
    }
    spss.SetMapObject(object)
})

setGeneric("BasePivotTable.CategoryFootnotes", function(object, dimPlace, dimName, category, footnotes) standardGeneric("BasePivotTable.CategoryFootnotes"))
setMethod("BasePivotTable.CategoryFootnotes","BasePivotTable", function(object, dimPlace, dimName, category, footnotes) {
    object <- spss.GetMapObject(object)
    invalidDim <- TRUE
    if(length(object@dims)>0)
    {
      for(i in 1: length(object@dims))
      {
          if(dimName == object@dims[[i]]@name && dimPlace == object@dims[[i]]@place)
          {
              spss._Dimension__SetCategory(object@dims[[i]], category)
              object@dims[[i]] <- spss.GetMapObject(object@dims[[i]])
              spss._Dimension__AddCategoryFootnotes(object@dims[[i]], footnotes)
              invalidDim <- FALSE
              break
          }
      }
    }
    
    if(invalidDim == TRUE)
    {
        spss._Dimension__CheckPlace(dimPlace)
        last.SpssError <<- 1043        
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)       
    }
    spss.SetMapObject(object)
    spss.SetMapObject(category)
})
 
spsspivottable.Display <- function(x, 
                                   title=default.title, 
                                   templateName=default.templateName, 
                                   outline=default.outline, 
                                   caption=default.caption, 
                                   isSplit=TRUE, 
                                   rowdim=default.rowdim, 
                                   coldim=default.coldim,
                                   hiderowdimtitle = TRUE,
                                   hiderowdimlabel = FALSE,
                                   hidecoldimtitle = TRUE,
                                   hidecoldimlabel = FALSE,
                                   rowlabels = NULL,
                                   collabels = NULL,
                                   format = default.format)
{
    spssError.reset()
    
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }

    title <- unicodeConverterInput(title)
    templateName <- unicodeConverterInput(templateName)
    outline <- unicodeConverterInput(outline)
    caption <- unicodeConverterInput(caption)
    rowdim <- unicodeConverterInput(rowdim)
    coldim <- unicodeConverterInput(coldim)

    if( is.null(title))
        title <- default.title
    if( is.null(templateName))
        templateName <- default.templateName
    
    check <- substr(templateName, 1,1)
    if( !any(letters == tolower(check)) || nchar(templateName) > 64 )
    {
        last.SpssError <<- 1005
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    
    if( is.null(outline))
        outline <- default.outline
    if( is.null(rowdim) || "" == rowdim )
        rowdim <- default.rowdim
    if( is.null(coldim) || "" == coldim )
        coldim <- default.coldim
    
    rowdimplace <- 0         
    coldimplace <- 1

    # we only support single row dimension and column dimension.
    rowdimposition <- 1
    coldimposition <- 1

    err <- 0
    is.pvDisplayCreatedProc <- FALSE
    if( !getOption("is.splitConnectionOpen"))
    {
        if(!getOption("is.pvTableConnectionOpen"))
        {
          if(is.null(getOption("procName"))) options(procName = "R")
          if(is.null(getOption("omsIdentifier"))) options(omsIdentifier = "R")

          pName <- getOption("procName")
          omsId <- getOption("omsIdentifier")
          out <- .C("ext_StartProcedure",as.character(pName),as.character(omsId),as.integer(err),PACKAGE=spss_package)
          last.SpssError <<- out[[3]] 
          if( is.SpssError(last.SpssError))
              stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
          is.pvDisplayCreatedProc <- TRUE
        }
    }

    #Sets min and max data column width.
    out <- .C("ext_MinDataColumnWidth",as.character(outline),
                                       as.character(title),
                                       as.character(templateName),
                                       as.integer(isSplit),
                                       as.integer(defaultMinDataColumnWidth),
                                       as.integer(err),
                                       PACKAGE=spss_package
                                       )
    last.SpssError <<- out[[6]] 
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    if(!is.null(caption))
    {
        out <- .C("ext_PivotTableCaption",as.character(outline),
                                          as.character(title),
                                          as.character(templateName),
                                          as.integer(isSplit),
                                          as.character(caption),
                                          as.integer(err),
                                          PACKAGE=spss_package
                                          )
        last.SpssError <<- out[[6]] 
        if( is.SpssError(last.SpssError))
        {
            if( !getOption("is.splitConnectionOpen") )
                .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
    }
    
    out <- .C("ext_AddDimension",as.character(outline),
                                 as.character(title),
                                 as.character(templateName),
                                 as.integer(isSplit),
                                 as.character(rowdim),
                                 as.integer(rowdimplace),
                                 as.integer(rowdimposition),
                                 as.logical(hiderowdimtitle),
                                 as.logical(hiderowdimlabel),
                                 as.integer(err),
                                 PACKAGE=spss_package)
    last.SpssError <<- out[[10]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
                                 
    out <- .C("ext_AddDimension",as.character(outline),
                                 as.character(title),
                                 as.character(templateName),
                                 as.integer(isSplit),
                                 as.character(coldim),
                                 as.integer(coldimplace),
                                 as.integer(coldimposition),
                                 as.logical(hidecoldimtitle),
                                 as.logical(hidecoldimlabel),
                                 as.integer(err),
                                 PACKAGE=spss_package)
    last.SpssError <<- out[[10]]    
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }

    x<-tryCatch(as.data.frame(x),error=function(ex) {
            print(ex)
            if( !getOption("is.splitConnectionOpen") &&!getOption("is.pvTableConnectionOpen"))
            {
                if ( is.pvDisplayCreatedProc ) 
                {
                      out <- .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                      last.SpssError <<- out[[1]] 
                      if( is.SpssError(last.SpssError))
                          stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)              
                      is.pvDisplayCreatedProc <- FALSE
                }
            } 
            return(NULL)
        }
    )    
    
    if(!is.null(rowlabels))
        rowcategories <- unlist(rowlabels)
    else
        rowcategories <- row.names(x)
    if(!is.null(collabels))
        colcategories <- unlist(collabels)
    else
        colcategories <- names(x)
    
    if( is.null(rowcategories))
    {
        nrows <- length(x[,1])
        i <- 0
        while( i < nrows )
        {
            i <- i+1
            rowcategories <- c(rowcategories, "row" + as.character(i))
        }
    }

    if( is.null(colcategories))
    {
        ncols <- length(x)
        i <- 0
        while( i < ncols )
        {
            i <- i+1
            colcategories <- c(colcategories, "column" + as.character(i))
        }
    }
    
    
    SetFormatSpec(format)
    
    i <- 1
    for( rowcat in rowcategories )
    {
        if( is.numeric(rowcat))
        {
            out <- .C("ext_AddNumberCategory",as.character(outline),
                                              as.character(title),
                                              as.character(templateName),
                                              as.integer(isSplit), 
                                              as.character(rowdim),
                                              as.integer(rowdimplace),
                                              as.integer(rowdimposition),
                                              as.logical(hiderowdimtitle),
                                              as.logical(hiderowdimlabel),
                                              as.double(rowcat),
                                              as.integer(err),
                                              PACKAGE=spss_package)
            last.SpssError <<- out[[11]]    
            if( is.SpssError(last.SpssError))
            {
                if( !getOption("is.splitConnectionOpen") )
                    .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
            }
        }
        else
        {
            rowcat <- unicodeConverterInput(rowcat)
            out <- .C("ext_AddStringCategory",as.character(outline),
                                              as.character(title),
                                              as.character(templateName),
                                              as.integer(isSplit), 
                                              as.character(rowdim),
                                              as.integer(rowdimplace),
                                              as.integer(rowdimposition),
                                              as.logical(hiderowdimtitle),
                                              as.logical(hiderowdimlabel),
                                              as.character(rowcat),
                                              as.integer(err),
                                              PACKAGE=spss_package)
            last.SpssError <<- out[[11]]    
            if( is.SpssError(last.SpssError))
            {
                if( !getOption("is.splitConnectionOpen") )
                    .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
            }
        }
        
        j <- 1
        for( colcat in colcategories )
        {
            if( is.numeric(colcat))
            {
                out <- .C("ext_AddNumberCategory",as.character(outline),
                                                  as.character(title),
                                                  as.character(templateName),
                                                  as.integer(isSplit), 
                                                  as.character(coldim),
                                                  as.integer(coldimplace),
                                                  as.integer(coldimposition),
                                                  as.logical(hidecoldimtitle),
                                                  as.logical(hidecoldimlabel),
                                                  as.double(colcat),
                                                  as.integer(err),
                                                  PACKAGE=spss_package)
                last.SpssError <<- out[[11]]    
                if( is.SpssError(last.SpssError))
                {
                    if( !getOption("is.splitConnectionOpen") )
                        .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                    stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
                }
            }
            else
            {
                colcat <- unicodeConverterInput(colcat)
                out <- .C("ext_AddStringCategory",as.character(outline),
                                                  as.character(title),
                                                  as.character(templateName),
                                                  as.integer(isSplit), 
                                                  as.character(coldim),
                                                  as.integer(coldimplace),
                                                  as.integer(coldimposition),
                                                  as.logical(hidecoldimtitle),
                                                  as.logical(hidecoldimlabel),
                                                  as.character(colcat),
                                                  as.integer(err),
                                                  PACKAGE=spss_package)
                last.SpssError <<- out[[11]]    
                if( is.SpssError(last.SpssError))
                {
                    if( !getOption("is.splitConnectionOpen") )
                        .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                    stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
                }
            }
            
            cell <- x[i,j]
            if(!is.null(cell))
            {
                if ("POSIXt"==class(cell)[1]&&"POSIXct"==class(cell)[2])
                {
                    cell <- as.double(difftime(as.POSIXct(cell),as.POSIXct(0,origin="1582-10-14 00:00:00", tz="GMT"),units = "secs"))
                }
                
                if(is.numeric(cell)&&(!is.na(cell))&&(!is.infinite(cell)))
                {
                    out <- .C("ext_SetNumberCell",as.character(outline),
                                                  as.character(title),
                                                  as.character(templateName),
                                                  as.integer(isSplit), 
                                                  as.character(coldim),
                                                  as.integer(coldimplace),
                                                  as.integer(coldimposition),
                                                  as.logical(hidecoldimtitle),
                                                  as.logical(hidecoldimlabel),
                                                  as.double(cell),
                                                  as.integer(err),
                                                  PACKAGE=spss_package)
                    last.SpssError <<- out[[11]]    
                    if( is.SpssError(last.SpssError))
                    {
                        if( !getOption("is.splitConnectionOpen") )
                            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
                    }
                }
                else
                {
                    cell <- unicodeConverterInput(as.character(cell))
                    out <- .C("ext_SetStringCell",as.character(outline),
                                                  as.character(title),
                                                  as.character(templateName),
                                                  as.integer(isSplit), 
                                                  as.character(coldim),
                                                  as.integer(coldimplace),
                                                  as.integer(coldimposition),
                                                  as.logical(hidecoldimtitle),
                                                  as.logical(hidecoldimlabel),
                                                  as.character(cell),
                                                  as.integer(err),
                                                  PACKAGE=spss_package)
                    last.SpssError <<- out[[11]]    
                    if( is.SpssError(last.SpssError))
                    {
                        if( !getOption("is.splitConnectionOpen") )
                            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
                        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
                    }
                }
            }
            j <- j+1
        }
        i <- i+1
    }               

    if( !getOption("is.splitConnectionOpen") &&!getOption("is.pvTableConnectionOpen"))
    {
        if ( is.pvDisplayCreatedProc ) 
        {
            out <- .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            if(getOption("runStartStatistics") && getOption("statsOutputInR"))
            {
                postOutputToR()
            }
            last.SpssError <<- out[[1]] 
            if( is.SpssError(last.SpssError))
              stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)              
            is.pvDisplayCreatedProc <- FALSE
        }
    }
}


spsspkg.StartProcedure <- function(pName=NULL, omsId=pName)
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    if(is.null(getOption("procName"))) options(procName = "R")
    if(is.null(getOption("oldProcName"))) options(oldProcName = "R")
    if(is.null(getOption("oldOmsIdentifier"))) options(oldOmsIdentifier = "R")
    if(is.null(getOption("omsIdentifier"))) options(omsIdentifier = "R")
    status <- FALSE
    if ( !getOption("is.pvTableConnectionOpen") ){
        err <- 0
        if (!is.null(pName))
        {
            options(oldProcName = getOption("procName"))
            options(procName = pName)
            options(oldOmsIdentifier = getOption("omsIdentifier"))
            options(omsIdentifier = omsId)
        }
        
        out <- .C("ext_StartProcedure",as.character(unicodeConverterInput(getOption("procName"))),as.character(unicodeConverterInput(getOption("omsIdentifier"))),as.integer(err),PACKAGE=spss_package)
        last.SpssError <<- out[[3]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        
        options(is.pvTableConnectionOpen = TRUE)
        status <- TRUE
    }
}

spsspkg.EndProcedure <- function()
{
    if( spsspkg.IsBackendReady())
    {
        if(!getOption("runStartStatistics") && getOption("toStatOutputView"))
        {
            postOutputToSpss()
        }
        status <- FALSE
        if ( getOption("is.pvTableConnectionOpen") )
        {
            err <- 0
            out <- .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
            if(getOption("runStartStatistics") && getOption("statsOutputInR"))
            {
                postOutputToR()
            }
            last.SpssError <<- out[[1]] 
            if( is.SpssError(last.SpssError))
                stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        
            options(is.pvTableConnectionOpen = FALSE)
            options(procName = getOption("oldProcName"))
            options(omsIdentifier = getOption("oldOmsIdentifier"))
            status <- TRUE
        }
    }
}

spss.TextBlock<- function(name, content, outline="")
{
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    obj <- new("TextBlock", name, content, outline)
    obj
}

setClass("TextBlock", representation(name="character",content="character", outline="character", skip="numeric"))

##define the contructor function, when call new(...), the initialize will be called.
setMethod("initialize","TextBlock",function(.Object, name, content, outline) {
    
    spssError.reset()

    if( is.null(name))
        name <- default.name
    if( is.null(content))
        content <- default.content
    if( is.null(outline))
        outline <- default.outline  
        
    .Object@name = name
    .Object@content = content
    .Object@outline = outline
    .Object@skip = 1    
    
    err <- 0      
    out <- .C("ext_AddTextBlock",as.character(unicodeConverterInput(.Object@name)),as.character(unicodeConverterInput(.Object@content)),as.character(unicodeConverterInput(.Object@outline)),as.integer(.Object@skip), as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[5]] 
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
    }
    .Object
})


    
##set the append to be generic function. so it will be added to be member method for TextBlock. 
setGeneric("TextBlock.append",function(object,line,skip = 1) standardGeneric("TextBlock.append"))

##define the append method
setMethod("TextBlock.append","TextBlock", function(object,line,skip = 1) {

    spssError.reset()
    if (!is.numeric(skip))
    {
      last.SpssError <<- 1022 
      stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)  
    }
     
    object@content <-  paste(object@content,"\n", line)
    object@skip = skip

    err <- 0      
    out <- .C("ext_AddTextBlock",as.character(unicodeConverterInput(object@name)),as.character(unicodeConverterInput(line)),as.character(unicodeConverterInput(object@outline)),as.integer(object@skip), as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[5]] 
    if( is.SpssError(last.SpssError))
    {
        if( !getOption("is.splitConnectionOpen") )
            .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)         
    }
})

