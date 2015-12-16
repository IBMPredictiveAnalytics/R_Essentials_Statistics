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

toSPSSFormat <- function(fmt)
{
    if( "E" == fmt )
        FIELD_Type.fmt_E
    else
    {
        switch(fmt,
               A        = FIELD_Type.fmt_A,
               AHEX     = FIELD_Type.fmt_AHEX,
               COMMA    = FIELD_Type.fmt_COMMA,
               DOLLAR   = FIELD_Type.fmt_DOLLAR,
               F        = FIELD_Type.fmt_F,
               IB       = FIELD_Type.fmt_IB,
               IBHEX    = FIELD_Type.fmt_IBHEX,
               PIBHEX    = FIELD_Type.fmt_IBHEX, #use IBHEX for both PIBHEX and IBHEX.
               P        = FIELD_Type.fmt_P,
               PIB      = FIELD_Type.fmt_PIB,
               PK       = FIELD_Type.fmt_PK,
               RB       = FIELD_Type.fmt_RB,
               RBHEX    = FIELD_Type.fmt_RBHEX,
               Z        = FIELD_Type.fmt_Z,
               N        = FIELD_Type.fmt_N,
               #E       = FIELD_Type.fmt_E,
               DATE     = FIELD_Type.fmt_DATE,
               TIME     = FIELD_Type.fmt_TIME,
               DATETIME = FIELD_Type.fmt_DATETIME,
               ADATE    = FIELD_Type.fmt_ADATE,
               JDATE    = FIELD_Type.fmt_JDATE,
               DTIME    = FIELD_Type.fmt_DTIME,
               WKDAY    = FIELD_Type.fmt_WKDAY,
               MONTH    = FIELD_Type.fmt_MONTH,
               MOYR     = FIELD_Type.fmt_MOYR,
               QYR      = FIELD_Type.fmt_QYR,
               WKYR     = FIELD_Type.fmt_WKYR,
               PERCENT  = FIELD_Type.fmt_PERCENT,
               PCT      = FIELD_Type.fmt_PERCENT, #use PERCENT for both PCT and PERCENT.
               DOT      = FIELD_Type.fmt_DOT,
               CCA      = FIELD_Type.fmt_CCA,
               CCB      = FIELD_Type.fmt_CCB,
               CCC      = FIELD_Type.fmt_CCC,
               CCD      = FIELD_Type.fmt_CCD,
               CCE      = FIELD_Type.fmt_CCE,
               EDATE    = FIELD_Type.fmt_EDATE,
               SDATE    = FIELD_Type.fmt_SDATE,
               )
    }         
}

#reverse strings
strReverse <- function(str)
{
  sapply(lapply(strsplit(str, NULL), rev), paste, collapse="")
}

#trim leading and trailing white space
strTrim <- function(str)
{
  str <- sub('[[:space:]]+$', '', str)
  str <- sub('[[:space:]]+$', '', strReverse(str))
  str <- strReverse(str)
}

ParseVarName <- function(var, dsName = NULL)
{
  result <- NULL
  
  if(is.numeric(var))
  {
    result <- c(var)
  }
  else
  {
    #support TO construct
    comma <- strsplit(var, ",")[[1]]
    str <- ""
    for( i in 1:length(comma) )
    {
       str <- paste(str, strTrim(comma[i]))
    }
    str <- strTrim(str)
    space <- strsplit(str,"[[:space:]]{1,}")[[1]]
    varlist <- unlist(space)

    #tolist <- grep("to", varlist, ignore.case = TRUE)
    tolist <- NULL
    for ( v in 1:length(varlist) ){
        if ( "to" == tolower(varlist[v]) ){
            tolist <- c(tolist, v)
        }
    }
    tolist <- as.list(tolist)
    
    if(length(tolist) > 0)
    {
        for(x in tolist)
        {
            if(1 == x )
            {
              varIndex <- GetVarIndex(varlist[x+1],dsName)
              result <- c(0:varIndex)
            }
            else if(length(varlist) == x)
            {
              varIndex <- GetVarIndex(varlist[x-1],dsName)
              if(is.null(dsName))
                  varNum <- spssdictionary.GetVariableCount()
              else
                  varNum <- spssdictionary.GetVariableCountInDS(dsName)
              result <- c(result,varIndex:(varNum-1))
            }
            else
            {
                index <- match(x, tolist)
                if((x > 2) && (1 == index))
                {
                    result <- ParseVarList(varlist, 1, x-2, FALSE, dsName)
                }
                
                result <- c(result,ParseVarList(varlist, x-1, x+1, TRUE, dsName))
                
                nextToIndex <- length(varlist)
                if(length(tolist)>index)
                {
                    nextToIndex <- tolist[[index+1]]-2
                }
                
                if(x+1 < nextToIndex)
                {
                    result <- c(result,ParseVarList(varlist, x+2, nextToIndex, FALSE, dsName))
                }
            }
        }
        
    }
    else
    {
        result <- ParseVarList(varlist, 1, length(varlist), FALSE, dsName)
    }

  }
  #sort(result)
  result
}

ParseVarList <- function(varlist, varIndexStart, varIndexEnd, tolist, dsName = NULL)
{
    result <-NULL
    if(tolist)
    {
        varIndexStart <- GetVarIndex(varlist[varIndexStart],dsName)
        varIndexEnd <- GetVarIndex(varlist[varIndexEnd],dsName)

        if ( varIndexStart > varIndexEnd ){
          last.SpssError <<- 1017
          if( is.SpssError(last.SpssError))
              stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
        else{
          result <- c(result,varIndexStart:varIndexEnd)
        }
    }
    else
    {
        if(length(varlist)>0)
        {
            for( x in varlist[varIndexStart:varIndexEnd] )
            {
                if( any(varlist == x ) && "to" != tolower(x))
                {
                    varIndex = GetVarIndex(x,dsName)
                    if( !any(result == varIndex ))
                    {
                        result <- c(result,varIndex)
                    }
                }
            }
        }
    }
    
    result
}

GetVarIndex <- function(var, dsName = NULL)
{
    oldwarn = getOption("warn")
    options(warn = -1)
    try(temp <- as.integer(var),TRUE)
    options(warn = oldwarn)
    if(is.na(temp))
        temp <- var
    
    var <- temp
    result <- NULL
    if(is.numeric(var))
        result <- var
    else
    {
        if(is.null(dsName))
            varNum <- spssdictionary.GetVariableCount()
        else
            varNum <- spssdictionary.GetVariableCountInDS(dsName)
			
        for(i in 0:(varNum-1))
        {
            if(is.null(dsName))
                varName <- spssdictionary.GetVariableName(i)
            else
                varName <- spssdictionary.GetVariableNameInDS(dsName,i)
            
            if(nchar(varName) == nchar(var) && !is.na(charmatch(varName,var)))
            {
                result <- i
                break
            }
        }
    }
    if( is.null(result))
    {
        last.SpssError <<- 1010
        if( is.SpssError(last.SpssError))
            stop(printInvalidNameError(last.SpssError, var),call. = FALSE, domain = NA)
    }
    result
}

ParseVarNames <- function(vars, dsName = NULL)
{
  result <- NULL
  if( is.vector(vars))
  {
    for(var in vars)
    {
      result <- c(result,ParseVarName(var,dsName))
    }
  }
  else if( is.list(vars))
  {
    vars <- unlist(vars)
    for(var in vars)
    {
      result <- c(result,ParseVarName(var,dsName))
    }
  }
  else if( is.character(vars))
  {
    result <- ParseVarName(vars,dsName)
  }
  else if( !is.null(vars))
  {
      last.SpssError <<- 1011
      if( is.SpssError(last.SpssError))
          stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
  }
  result
}

unicodeConverterInput <- function(x)
{
  if(is.character(x))
  {
    if(length(x)>0)
		{
  		for(i in 1:length(x))
  		{
        isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]  
        if ("windows" == .Platform$OS.type)
		    {
            if(isUnicodeOn)
            {
                if(Encoding(x[[i]])!="UTF-8")
                    x[[i]] <- iconv(x[[i]],to="UTF-8")
            }
            else
            {
                if(Encoding(x[[i]]) == "UTF-8")
                    x[[i]] <- iconv(x[[i]], from="UTF-8")
            }
            Encoding(x[[i]])<-"native.enc"    
    		}else{
    			Encoding(x[[i]])<-"native.enc"   
    		}
  		}
		}
  }   
  x
}

unicodeConverterOutput <- function(x)
{
  if(is.character(x))
  {
    if(length(x)>0)
		{
  		for(i in 1: length(x))
  		{
    		isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
        if ("windows" == .Platform$OS.type)
    		{
            if(isUnicodeOn)
              Encoding(x[[i]])<-"UTF-8"
    		}else
    		{
    			if(isUnicodeOn)
    				Encoding(x[[i]]) <- "UTF-8"
    			else
					  Encoding(x[[i]])<-"native.enc"
    		}
  		}
		}
  }
  x   
}

spsspkg.GetSPSSLocale <- function()
{
    spssError.reset()
    
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    err <- 0
    out <- .C("ext_GetSPSSLocale",as.character(""),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]]
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)

    locVar <- out[[1]]
    if("" == locVar)
        locVar <- NULL
    unicodeConverterOutput(locVar)
}

spsspkg.SetOutputLanguage <- function(lang)
{
    spssError.reset()
    
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    err <- 0
    lang <- unicodeConverterInput(lang)
    out <- .C("ext_SetOutputLanguage",as.character(lang),as.integer(err),PACKAGE=spss_package)
    supportlang <- c("English", "French","German", "Italian", "Japanese", "Korean", "Polish", "Russian", "Simplified Chinese", "Spanish", "Traditional Chinese", "SChinese", "TChinese", "BPortugu")
    last.SpssError <<- out[[2]]
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    if( is.SpssWarning(last.SpssError))
    {
        if (out[[1]]%in%supportlang)
        {
            warning(printSpssWarning(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        }
        else
        {
            last.SpssError <<-1074
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
        }
    }
}

spsspkg.GetOutputLanguage <- function()
{
    spssError.reset()
    
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    err <- 0
    out <- .C("ext_GetOutputLanguage",as.character(""),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    olang <- out[[1]]  
    if("" == olang)
        olang <- NULL
    unicodeConverterOutput(olang)
}

spsspkg.GetStatisticsPath <- function()
{
    spssError.reset()
    
    if( !spsspkg.IsBackendReady())
    {
        last.SpssError <<- 17
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
    path <- getOption("spssPath")
    path <- as.vector(path)
    if("" == path)
        path <- NULL
    unicodeConverterOutput(path)
}

