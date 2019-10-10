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
## Class spssxmlworkspace.
#############################################

spssxmlworkspace.CreateXPathDictionary <- function(handle)
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    err <- 0
    handle <- unicodeConverterInput(handle)
    out <- .C("ext_CreateXPathDictionary",as.character(handle), as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
}

spssxmlworkspace.GetHandleList <- function()
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    err <- 0
    out <- .Call("ext_GetHandleList",as.integer(err),PACKAGE=spss_package)

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

spssxmlworkspace.EvaluateXPath <- function(handle, context, expression)
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    err <- 0
    handle <- unicodeConverterInput(handle)
    context <- unicodeConverterInput(context)
    expression <- unicodeConverterInput(expression)
    out <- .Call("ext_EvaluateXPath",as.character(handle),as.character(context),as.character(expression),
                                  as.integer(err),PACKAGE=spss_package)
    
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
    }
    result
}

spssxmlworkspace.DeleteXmlWorkspaceObject <- function(handle)
{
    if( !spsspkg.IsBackendReady())
    {
        spsspkg.StartStatistics()
    }
    
    err <- 0
    handle <- unicodeConverterInput(handle)
    
    out <- .C("ext_RemoveXPathHandle",as.character(handle), as.integer(err),PACKAGE=spss_package)
    last.SpssError <<- out[[2]] 
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
}
