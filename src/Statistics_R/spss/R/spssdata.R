#############################################
# IBM?SPSS?Statistics - Essentials for R
# (c) Copyright IBM Corp. 1989, 2015
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
## Class spssdata for exchange data between R
## and SPSS.
#############################################


## These constants represent the display formats that are supported
## for SPSS variables. Internal use only.

FIELD_Type.fmt_A        <- 1
FIELD_Type.fmt_AHEX     <- 2
FIELD_Type.fmt_COMMA    <- 3
FIELD_Type.fmt_DOLLAR   <- 4
FIELD_Type.fmt_F        <- 5
FIELD_Type.fmt_IB       <- 6
FIELD_Type.fmt_IBHEX    <- 7
FIELD_Type.fmt_P        <- 8
FIELD_Type.fmt_PIB      <- 9
FIELD_Type.fmt_PK       <- 10
FIELD_Type.fmt_RB       <- 11
FIELD_Type.fmt_RBHEX    <- 12

FIELD_Type.fmt_Z        <- 15
FIELD_Type.fmt_N        <- 16
FIELD_Type.fmt_E        <- 17

FIELD_Type.fmt_DATE     <- 20
FIELD_Type.fmt_TIME     <- 21
FIELD_Type.fmt_DATETIME <- 22
FIELD_Type.fmt_ADATE    <- 23
FIELD_Type.fmt_JDATE    <- 24
FIELD_Type.fmt_DTIME    <- 25
FIELD_Type.fmt_WKDAY    <- 26
FIELD_Type.fmt_MONTH    <- 27
FIELD_Type.fmt_MOYR     <- 28
FIELD_Type.fmt_QYR      <- 29
FIELD_Type.fmt_WKYR     <- 30
FIELD_Type.fmt_PERCENT  <- 31
FIELD_Type.fmt_DOT      <- 32
FIELD_Type.fmt_CCA      <- 33
FIELD_Type.fmt_CCB      <- 34
FIELD_Type.fmt_CCC      <- 35
FIELD_Type.fmt_CCD      <- 36
FIELD_Type.fmt_CCE      <- 37
FIELD_Type.fmt_EDATE    <- 38
FIELD_Type.fmt_SDATE    <- 39

## format set which could be transformed into POSIXt 
dateFormatSet <- c(FIELD_Type.fmt_DATE, FIELD_Type.fmt_ADATE, 
                        FIELD_Type.fmt_JDATE, FIELD_Type.fmt_QYR,
                        FIELD_Type.fmt_MOYR, FIELD_Type.fmt_WKYR,
                        FIELD_Type.fmt_DATETIME, FIELD_Type.fmt_EDATE,
                        FIELD_Type.fmt_SDATE)
                        
## Convert an SPSS variable into a R data type based on the display format
## for the SPSS variable. Internal use only.

spssdata.convert <- function(x, fmt)
{
    switch(fmt,
           FIELD_Type.fmt_A         = as.character(x),
           FIELD_Type.fmt_AHEX      = as.character(x),
           FIELD_Type.fmt_COMMA     = as.double(x),
           FIELD_Type.fmt_DOLLAR    = as.double(x),
           FIELD_Type.fmt_F         = as.double(x),
           FIELD_Type.fmt_IB        = as.double(x),
           FIELD_Type.fmt_IBHEX     = as.double(x),
           FIELD_Type.fmt_P         = as.double(x),
           FIELD_Type.fmt_PIB       = as.double(x),
           FIELD_Type.fmt_PK        = as.double(x),
           FIELD_Type.fmt_RB        = as.double(x),
           FIELD_Type.fmt_RBHEX     = as.double(x),
           FIELD_Type.fmt_Z         = as.double(x),
           FIELD_Type.fmt_N         = as.double(x),
           FIELD_Type.fmt_E         = as.double(x),
           FIELD_Type.fmt_DATE      = as.double(x),
           FIELD_Type.fmt_TIME      = as.double(x),
           FIELD_Type.fmt_DATETIME  = as.double(x),
           FIELD_Type.fmt_ADATE     = as.double(x),
           FIELD_Type.fmt_JDATE     = as.double(x),
           FIELD_Type.fmt_DTIME     = as.double(x),
           FIELD_Type.fmt_WKDAY     = as.double(x),
           FIELD_Type.fmt_MONTH     = as.double(x),
           FIELD_Type.fmt_MOYR      = as.double(x),
           FIELD_Type.fmt_QYR       = as.double(x),
           FIELD_Type.fmt_WKYR      = as.double(x),
           FIELD_Type.fmt_PERCENT   = as.double(x),
           FIELD_Type.fmt_DOT       = as.double(x),
           FIELD_Type.fmt_CCA       = as.double(x),
           FIELD_Type.fmt_CCB       = as.double(x),
           FIELD_Type.fmt_CCC       = as.double(x),
           FIELD_Type.fmt_CCD       = as.double(x),
           FIELD_Type.fmt_CCE       = as.double(x),
           FIELD_Type.fmt_EDATE     = as.double(x),
           FIELD_Type.fmt_SDATE     = as.double(x),
           FIELD_Type.fmt_G         = as.double(x),
           FIELD_Type.fmt_LNUMBER   = as.double(x),
           FIELD_Type.fmt_LDATE     = as.double(x),
           FIELD_Type.fmt_LTIME     = as.double(x),
           FIELD_Type.fmt_LCA       = as.double(x),
           FIELD_Type.fmt_LCB       = as.double(x),
           FIELD_Type.fmt_LCC       = as.double(x),
           FIELD_Type.fmt_LCD       = as.double(x),
           FIELD_Type.fmt_LCE       = as.double(x),
           FIELD_Type.fmt_LCF       = as.double(x),
           FIELD_Type.fmt_LCG       = as.double(x),
           FIELD_Type.fmt_LCH       = as.double(x),
           FIELD_Type.fmt_LCI       = as.double(x),
           FIELD_Type.fmt_LCJ       = as.double(x)
           )
}

spssdata.GetDataFromSPSS <- function(variables=NULL, 
                                      cases=NULL, 
                                      row.label=NULL, 
                                      keepUserMissing = FALSE, 
                                      missingValueToNA = FALSE, 
                                      factorMode = "none", 
                                      rDate = "none", 
                                      dateVar= NULL,
                                      asList=FALSE,
                                      orderedContrast="contr.treatment")
{
    spssError.reset()
    
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    err <- 0
    
    if( getOption("is.splitConnectionOpen") )
    {
        last.SpssError <<- 1001
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
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
    else if(is.character(variables)){
        variables <- ParseVarNames(variables)
    }

    if( length(variables)==0 )
        return(NULL)

    if( rDate != "none" && rDate != "POSIXct" && rDate != "POSIXlt")
    {
        last.SpssError <<- 1019 
        if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)        
    }
     
    if( factorMode != "none" && factorMode != "labels" && factorMode != "levels")
    {
        last.SpssError <<- 1018 
        if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)        
    }
    
    if( !is.null(row.label))
    {
        row.label <- ParseVarName(row.label)
        variables <- c(variables,row.label)
    }
    if( is.null(cases) )
        cases <- spssdata.GetCaseCount()
    
    out <- .Call("ext_GetVarFormatTypes",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    varFormatTypes <- out[1:n-1]

    out <- .Call("ext_GetDataFromSPSS",as.list(variables),as.integer(cases),
                                       as.logical(keepUserMissing),
                                       as.logical(missingValueToNA),
                                       as.integer(err),
                                       PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)

    result <- out[1:(n-1)]
    rm(out)
    
    n <- length(result)
    for(i in 1:n)
      result[[i]] <- spssdata.convert(result[[i]],varFormatTypes[i])
      
    ## transform spss datetime into POSIXct which is supported by R
    if(rDate != "none")
    {
      dateVar <- unlist(dateVar)
      if(!is.null(dateVar))
      {
        if(typeof(dateVar)=="logical")
        {
          dateVar <- NULL
          last.SpssError <<- 1073 
          stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)        
        }
        if(is.character(dateVar))
          dateVar <- ParseVarNames(dateVar)
        dateVar <- match(dateVar, variables)
      } 
      else
      {
        dateVar <- 1:length(variables)
      }      
        
      for(i in dateVar)
      {
          if(varFormatTypes[i]%in%dateFormatSet)
          {
            if(rDate == "POSIXct")
            {
              result[[i]] <- as.POSIXct(result[[i]],origin="1582-10-14 00:00:00", tz="GMT")
            }
            else if(rDate == "POSIXlt")
            { 
              result[[i]] <- as.POSIXlt(result[[i]],origin="1582-10-14 00:00:00", tz="GMT") 
            }
          }  
      }
    }
    result <- unicodeConverterOutput(result)   

    
    if(factorMode != "none"){
      out <- .Call("ext_GetVarMeasurementLevels",as.list(variables),as.integer(err),
                                           PACKAGE=spss_package)
      n <- length(out)
      last.SpssError <<- out[n] 
      if( is.SpssError(last.SpssError))
          stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
      varMeasurementLevel <- out[1:n-1] 
      j<-1
      for(i in variables){
        emptyset <- c()
        if(is.character(result[[j]]))
        {
            result[[j]] <- sub("\\s+$", "", result[[j]])
        }
        
        if("nominal" == varMeasurementLevel[[j]] || "ordinal" == varMeasurementLevel[[j]]){
            valuelabel <- spssdictionary.GetValueLabels(i)
            uniqueset<- sort(unique(result[[j]]))
            if(factorMode == "levels")
            {
                for (i in valuelabel$values)
                {
                    if (!(i%in%uniqueset))
                    {
                        emptyset<-append(emptyset, which(valuelabel$values == i))
                    }
                }
                emptyset <- rev(emptyset)
                for (i in emptyset)
                {
                    valuelabel$values <- valuelabel$values[-i]
                    valuelabel$labels <- valuelabel$labels[-i]
                }
            }
            for(i in uniqueset)
            {                       
                if(!(i%in%valuelabel$values)&&!(is.na(i)&&!is.nan(i)))
                {
                    valuelabel$values <- append(valuelabel$values,i)
                    valuelabel$labels <- append(valuelabel$labels,i)  
                }              
            }
            orderedResult <- FALSE
            if("nominal" == varMeasurementLevel[[j]]){
                orderedResult <- FALSE
            }
            if("ordinal" == varMeasurementLevel[[j]]){       
                options(contrasts=c(orderedContrast,orderedContrast))
                orderedResult <- TRUE
            }
            if(factorMode == "labels")
                result[[j]] <- factor(result[[j]],levels = valuelabel$values, labels = valuelabel$labels, ordered = orderedResult)
            else if(factorMode == "levels")
                result[[j]] <- factor(result[[j]],levels = valuelabel$values, ordered = orderedResult)
        }
        
        j<-j+1
      }
    }   
    ## add variable names as the column names of the data frame.
    out <- .Call("ext_GetVarNames",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    last.SpssError <<- out[length(out)] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    varNames <- unicodeConverterOutput(out[1:length(out)-1])
    rm(out)

    #force to do a garbage collection
    gc(verbose = FALSE)

    if ( asList ){
        value <- result
        rm(result)
        gc(verbose = FALSE)
    }
    else{
        stringsAsFactors <- unlist(options("stringsAsFactors"))[[1]]
        options("stringsAsFactors" = TRUE )
        warn <- unlist(options("warn"))[[1]]
        options("warn" = 2 )
    
        if( is.null(row.label) )
        {
            value <- data.frame(result)
            rm(result)
            gc(verbose = FALSE)
            names(value) <- varNames
            rm(varNames)
            gc(verbose = FALSE)
        }
        else
        {
            value <- data.frame(result[1:length(result)-1])
            gc(verbose = FALSE)
            row.names(value) <- result[[length(result)]]
            rm(result)
            gc(verbose = FALSE)
            names(value) <- varNames[1:length(varNames)-1]
            rm(varNames)
            gc(verbose = FALSE)
        }
        options("stringsAsFactors" = stringsAsFactors)
        options("warn" = warn )
    }
    
    value
}

spssdata.GetCaseCount <- 
    function()
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    err <- 0
    out <- .C("ext_GetCaseCount",as.integer(0), as.integer(err),PACKAGE=spss_package)

    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        
    rows <- out[[1]]
    rows
}


## This function creats a split data connection implicitly. 
## spssdata.CloseDataConnection must be called to close the
## split data connection.
spssdata.GetSplitDataFromSPSS <- function(variables=NULL, 
                                          row.label=NULL, 
                                          keepUserMissing = FALSE, 
                                          missingValueToNA = FALSE, 
                                          factorMode = "none", 
                                          rDate = "none",
                                          dateVar = NULL,
                                          orderedContrast="contr.treatment")
{
    spssError.reset()
    
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    err <- 0
    
    if(is.null(getOption("is.lastSplit"))) options(is.lastSplit = FALSE)
    if(is.null(getOption("is.skipover"))) options(is.skipover = FALSE)
    if(is.null(getOption("procName"))) options(procName = "R")
    if(is.null(getOption("omsIdentifier"))) options(omsIdentifier = "R")
    
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
    
    if( factorMode != "none" && factorMode != "labels" && factorMode != "levels")
    {
        last.SpssError <<- 1018 
        if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)        
    }
    
    if( rDate != "none" && rDate != "POSIXct" && rDate != "POSIXlt")
    {
        last.SpssError <<- 1019 
        if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)        
    }
        
    if( !is.null(row.label))
    {
        row.label <- ParseVarName(row.label)
        variables <- c(variables,row.label)
    }
    
    if(rDate!="none")
    {     
      dateVar <- unlist(dateVar)
      if(typeof(dateVar)=="logical")
      {
        last.SpssError <<- 1073 
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)        
      }      
      if(!is.null(dateVar))
      {
        if(is.character(dateVar))
          dateVar <- ParseVarNames(dateVar)
        dateVar <- match(dateVar, variables)
      } else
      {
        dateVar <- 1:length(variables)
      }
    }    
    
    out <- .Call("ext_GetVarFormatTypes",as.list(variables),as.integer(err),
                                         PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[n] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    varFormatTypes <- out[1:n-1]

    if( getOption("is.lastSplit") )
    {
        value <- NULL
        last.SpssError <<- 1000
        warning(printSpssWarning(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    else
    {   
        if(!getOption("is.splitConnectionOpen"))
        {
            if(!getOption("is.pvTableConnectionOpen"))
            {
            out <- .C("ext_StartProcedure",as.character(unicodeConverterInput(getOption("procName"))),as.character(unicodeConverterInput(getOption("omsIdentifier"))),as.integer(err),PACKAGE=spss_package)
            last.SpssError <<- out[[3]] 
            if( is.SpssError(last.SpssError))
                stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
            }
            options(is.splitConnectionOpen = TRUE)
    
            accessType <- "r"
            out <- .C("ext_MakeCaseCursor",as.character(accessType),as.integer(err),PACKAGE=spss_package)
            last.SpssError <<- out[[2]] 
            if( is.SpssError(last.SpssError))
                stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        }
        
        out <- .Call("ext_GetSplitDataFromSPSS",as.character(unicodeConverterInput(getOption("omsIdentifier"))),
                                                as.list(variables),
                                                as.logical(keepUserMissing),
                                                as.logical(missingValueToNA),
                                                as.logical(getOption("is.skipover")),
                                                as.integer(err),
                                                PACKAGE=spss_package)
        n <- length(out)
        last.SpssError <<- out[[n]]
        if( 23 == last.SpssError )
        {
            options(is.lastSplit = TRUE)
            return(NULL) 
        }
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        
        result <- out[1:(n-1)]
        n <- length(result)
        isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
        for(i in 1:n)
        {
            result[[i]] <- spssdata.convert(result[[i]],varFormatTypes[i])
            if( is.character(result[[i]])&& isUnicodeOn)
                result[[i]] <- unicodeConverterOutput(result[[i]])
        }
        if(rDate!="none")
        {     
          for(i in dateVar)
          { 
              if(varFormatTypes[i]%in%dateFormatSet)
              {
                if(rDate == "POSIXct")
                  result[[i]] <- as.POSIXct(result[[i]],origin="1582-10-14 00:00:00",tz="GMT")
                else if(rDate == "POSIXlt")
                  result[[i]] <- as.POSIXlt(result[[i]],origin="1582-10-14 00:00:00",tz="GMT")
              }
          }               
        }
        if(factorMode!="none")
        {
          out <- .Call("ext_GetVarMeasurementLevels",as.list(variables),as.integer(err),
                                               PACKAGE=spss_package)
          n <- length(out)
          last.SpssError <<- out[n] 
          if( is.SpssError(last.SpssError))
              stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
          varMeasurementLevel <- out[1:n-1] 
          
          
          j<-1
          for(i in variables){
            if(is.character(result[[j]]))
            {
                result[[j]] <- sub("\\s+$", "", result[[j]])
            }
            
            if("nominal" == varMeasurementLevel[[j]] || "ordinal" == varMeasurementLevel[[j]]){
                valuelabel <- spssdictionary.GetValueLabels(i)
                if(length(valuelabel$values)==0)
                {
                    valuelabel$values <- result[[j]]
                    valuelabel$labels <- result[[j]]
                }    
                uniqueset<- sort(unique(result[[j]]))
                for(i in uniqueset)
                {
                    if(!(i%in%valuelabel$values)&&!(is.na(i)&&!is.nan(i)))
                    {
                        valuelabel$values <- append(valuelabel$values,i)
                        valuelabel$labels <- append(valuelabel$labels,i)  
                    }
                }
                orderedResult <- FALSE
                if("nominal" == varMeasurementLevel[[j]]){
                    orderedResult <- FALSE
                }
                if("ordinal" == varMeasurementLevel[[j]]){          
                    options(contrasts=c(orderedContrast,orderedContrast))
                    orderedResult <- TRUE
                }
                if(factorMode == "labels")              
                    result[[j]] <- factor(result[[j]],levels = valuelabel$values, labels = valuelabel$labels, ordered = orderedResult)
                else if(factorMode == "levels")
                    result[[j]] <- factor(result[[j]],levels = valuelabel$values, ordered = orderedResult)
            }
            j<-j+1
          }
        }            
        
        ## add variable names as the column names of the data frame.
        out <- .Call("ext_GetVarNames",as.list(variables),as.integer(err),
                                             PACKAGE=spss_package)
        last.SpssError <<- out[length(out)] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        varNames <- unicodeConverterOutput(out[1:length(out)-1])
    
        if( is.null(row.label) )
        {
            value <- data.frame(result, stringsAsFactors=TRUE)
            names(value) <- varNames
        }
        else
        {
            value <- data.frame(result[1:length(result)-1],stringsAsFactors=TRUE)
            row.names(value) <- result[[length(result)]]
            names(value) <- varNames[1:length(varNames)-1]
        }
        
        ## We want to predict whether the currect split is the last split.
        out <- .C("ext_NextCase",as.integer(err),PACKAGE=spss_package)
        last.SpssError <<- out[[1]]
        options(is.skipover = TRUE)
        if( 23 == out[[1]] )
            options(is.lastSplit = TRUE)
    }
    value
}

spssdata.CloseDataConnection <- function()
{
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    
    if(getOption("is.splitConnectionOpen"))
    {
        err <- 0
        out <- .C("ext_RemoveCaseCursor",as.integer(err),PACKAGE=spss_package)
        last.SpssError <<- out[[1]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        if(!getOption("is.pvTableConnectionOpen"))
        {
          out <- .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
          last.SpssError <<- out[[1]] 
          if( is.SpssError(last.SpssError))
              stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        }
        options(is.splitConnectionOpen = FALSE)
        options(is.lastSplit = FALSE)
        options(is.skipover = FALSE)
    }
}

## Internal function.
spssdata.IsSplitEnd <- function()
{
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    err <- 0
    splitEnd <- TRUE
    out <- .C("ext_IsEndSplit",as.logical(splitEnd),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)

    splitEnd <- out[[1]]
    splitEnd
}

spssdata.IsLastSplit <- function()
{
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    if(is.null(getOption("is.lastSplit"))) options(is.lastSplit = FALSE)
    getOption("is.lastSplit")
}

spssdata.GetSplitVariableCount <- function()
{
    n <- spssdata.GetSplitVariableNames()
    length(n)
}

spssdata.GetSplitVariableNames <- function()
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    err <- 0
    out <- .Call("ext_GetSplitVariableNames",as.integer(err),PACKAGE=spss_package)

    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
        as.factor(result)
    }
    result
}


spssdata.GetDataSetList <- function()
{
    spssError.reset()
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    err <- 0

    out <- .Call("ext_GetSpssDatasets",as.integer(err),PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
        as.factor(result)
    }

    result
}

spssdata.GetOpenedDataSetList <- function()
{
    spssError.reset()
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    
    err <- 0
    if( !getOption("is.dataStepRunning") )
    {
        out <- .C("ext_StartDataStep",as.integer(err),PACKAGE=spss_package)
        last.SpssError <<- out[[1]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }

    out <- .Call("ext_GetOpenedSpssDatasets",as.integer(err),PACKAGE=spss_package)
    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- out[1:(n-1)]
        for(i in 1:(n-1))
            result[[i]] <- unicodeConverterOutput(result[[i]])
        as.factor(result)
    }

    if( !getOption("is.dataStepRunning") )
    {
        out <- .C("ext_EndDataStep",as.integer(err),PACKAGE=spss_package)
        last.SpssError <<- out[[1]] 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }

    result
}

spssdata.SetDataToSPSS <- function(datasetName,x, categoryDictionary = NULL)
{
    spssError.reset()
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    if( !getOption("is.dataStepRunning") )
    {
        last.SpssError <<- 1009 
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    datasetName <- unicodeConverterInput(datasetName)      
    if(!is.null(categoryDictionary))
    {
        if(!spssdictionary.CategoryDictionaryValid(categoryDictionary))
        {
            last.SpssError <<- 1021
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        }
    }
    x <- as.list(x)
    varNums <- length(x)
    err <- 0
    varType <- 0
    varName <- ""
    for(i in 1:varNums)
    {   
        x[[i]] <- unlist(x[[i]])
        if(("factor" %in% class(x[[i]])) && (!is.null(categoryDictionary)))
        {
          
          varName <- spssdictionary.GetVariableNameInDS(datasetName, i-1)
          idx <- match(varName, categoryDictionary$name)
          if(!is.na(idx))
          {
            levelscount <- nlevels(x[[i]])
            dictionary <- categoryDictionary$dictionary[[idx]]
            if(levelscount >= length(dictionary$levels))
            {
                len <- length(x[[i]])
                indextemp <- match(x[[i]], dictionary$levels)
                for (j in 1:len)
                {
                    if (is.na(indextemp[j]))
                    {
                        indextemp <- match(x[[i]], dictionary$labels)
                        break
                    }
                }
                x[[i]]<- as.character(x[[i]])
                for (j in 1:len)
                {
                    if(!is.na(indextemp[j]))
                    {
                        if(indextemp[j] <= length(dictionary$levels))
                            x[[i]][j] <- dictionary$levels[indextemp[j]]
                    }
                }
            }
          }
        }
        if("POSIXt"%in%class(x[[i]]))
          x[[i]]<-as.double(difftime(as.POSIXct(x[[i]]),as.POSIXct(0,origin="1582-10-14 00:00:00",tz="GMT"),units = "secs"))
        x[[i]] <- as.vector(x[[i]])
        varType <- .C("ext_GetVarTypeInDS",as.character(datasetName),
                                       as.integer(i-1),
                                       as.integer(varType),
                                       as.integer(err),
                                       PACKAGE=spss_package)[[3]]
        if( 0 == varType )
        {
            x[[i]] <- sapply(x[[i]],as.numeric)
        }
        else
            x[[i]] <- sapply(x[[i]],as.character)
            
    }
    
    isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
    if(isUnicodeOn)
    {
        for(i in 1:varNums)
            x[i] <- unicodeConverterInput(x[i])
    }
    
    out <- .Call("ext_SetDataToSPSS",as.character(datasetName),x,as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[1] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
}

spssdata.GetFileHandles <- function()
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    err <- 0
    out <- .Call("ext_GetFileHandles",as.integer(err),PACKAGE=spss_package)

    n <- length(out)
    last.SpssError <<- out[[n]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)

    if(1==n)
        result <- NULL
    else
    {
        result <- unlist(out[1:(n-1)])
        for(i in 1:n)
            result[i] <- unicodeConverterOutput(result[i])

        tripleout <- NULL
        x <- 1
        while (x < length(result)){
            aHandle <- c(result[x],result[x+1],result[x+2])
            x <- x+3
            if ( is.null(tripleout))
                tripleout <- list(aHandle)
            else
                tripleout <- c(tripleout, list(aHandle))
        }
        result <- tripleout
    }
    result
}

