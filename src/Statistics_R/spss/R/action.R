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

filename <- function()
{
    R_SPSSPath <- tempfile()
    R_SPSSPath
}

filenameForSpssDriven <- function()
{
    temppath <- tempdir()
    if (!file.exists(temppath))
    {
        dir.create(temppath, showWarnings = TRUE, recursive = FALSE)
    }
    filename <- 'r_spss.tmp'
    R_SPSSPath <- file.path(dirname(temppath), basename(temppath), filename)
    R_SPSSPath
}



getWidth <- function()
{
    outputWidth <- 80
    errLevel <- 0
    out <- .C('ext_GetSpssOutputWidth', as.integer(outputWidth),
                                 as.integer(errLevel),
                                 PACKAGE=spss_package)
    out[[1]]
}

oldErrorOpt <- getOption("error")

setRTempFolderToSPSS <- function()
{
    err <- 0
    spssError.reset()
    tmpdir <- tempdir()    
    out <- .C("ext_SetRTempFolderToSPSS",as.character(tmpdir),as.integer(err),PACKAGE=spss_package)
    last.SpssError <<-  out[[2]]
    if( is.SpssError(last.SpssError))
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
}

getLangMap <- function(outputLang)
{
    langMap <- list(

        olang = c("German","English","Spanish","French", "Italian", "Japanese", 
              "Korean", "Polish", "Russian", "TChinese", "SChinese", "BPortugu"),
        lang  = c("de_DE", "en_EN", "es_ES", "fr_FR", "it_IT", "ja_JP", "ko_KO",
           "pl_PL", "ru_RU", "zh_TW", "zh_CN", "pt_BR"))
    
    matchResult<-match(outputLang, langMap$olang)
    if(length(matchResult)==0)
    {
        last.SpssError <<-  1074
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
    }
    langMap$lang[[matchResult[[1]]]]    
}

getLC_ALLMap <- function(myLocale)
{
    if(myLocale == "C")
    {
        return (myLocale)
    }
    isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
    myLocale <- tolower(substr(myLocale,1,5))
    resultLocale<-NULL
    if(! isUnicodeOn)
    {
        queryStr<- paste("locale -a|grep -i '",myLocale,"'", sep="") 
    	resultLocale <- system(queryStr,intern=TRUE)		
    }
    else
    {
    	locReg <- strsplit(myLocale,".", fixed=TRUE)[[1]][[1]]
    	queryStr<- paste("locale -a|grep -i '^",locReg,"'|grep -i utf|grep -i 8", sep="") 
        resultLocale <- system(queryStr,intern=TRUE)
    }
    if(length(resultLocale) == 0)
    {
        last.SpssError <<-  1077
        warning(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        return (myLocale)
    }    
    return (resultLocale[[1]])
}

getCodePageMap <- function(myLocale)
{
     if("windows" == .Platform$OS.type)
     {
        tryCatch(
          {
             cpnumber = strsplit(myLocale,"\\.")[[1]][[2]]
             return (paste("CP",cpnumber,sep=""))
          }, 
          error=function(ex) 
          {
              return (NULL)

          }
        )
     }
     else
     {
        myLocale <- tolower(substr(myLocale,1,5))
        codePageMap <- list(
        locale = c("de","en","es","fr", "it", "ja", 
                "ko", "pl", "ru", "zh_tw", "zh_cn"),
        codepage  = c("CP1252", "CP1252", "CP1252", "CP1252", "CP1252", "CP932", "CP949",
             "CP1250", "CP1251", "CP950", "CP936"))
        for(i in 1:length(codePageMap$locale))
      	{
      		 if(length(grep(codePageMap$locale[[i]],myLocale))!=0)
      		 {
      			 return (codePageMap$codepage[[i]])
      		 }	
      	}
      	return (NULL)
    }
}

getLanguageLocale <- function(lang)
{
     resLang <-lang
     if(lang == "SChinese")
        resLang <- "CHS"
     else if(lang == "TChinese")
        resLang <- "CHT"
     else if(lang == "BPortugu")
        resLang <- "Portuguese"
     resLang
}

getOutputLanguageMap<- function(olang)
{
    if("windows"!=.Platform$OS.type)
    {
        langMap <- list(

            olang = c("German","English","Spanish","French", "Italian", "Japanese", 
                    "Korean", "Polish", "Russian", "TChinese", "SChinese", "BPortugu"),
            locale  = c("de_DE", "en_US", "es_ES", "fr_FR", "it_IT", "ja_JP", "ko_KR",
                    "pl_PL", "ru_RU", "zh_TW", "zh_CN", "pt_BR"))
    
        matchResult<-match(olang, langMap$olang)
        if(length(matchResult)==0)
        {
            last.SpssError <<-  1074
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)    
        }
        
        resLang <- langMap$locale[[matchResult[[1]]]]
        resLang <- paste(resLang, ".UTF-8", sep="")
        
        resLang
    }
    else
    {
        getLanguageLocale(olang)
    }
}

prespss <- function()
{
    ##By default, the R output will be redirected to Stat output view
    ##for the first call R plug-in, the toStatOutputView will be set to TRUE.
    initPackage()
    
    options(hasBrowser = FALSE)
    spss.PivotTableMap <<- list()
    spss.DimensionMap <<- list()
    spss.CellTextMap <<- list()

    errLevel <- 0

    out <- .C("ext_GetOutputLanguage",as.character(""),as.integer(errLevel),PACKAGE=spss_package)
    last.SpssError <<-  out[[2]]
    if( is.SpssError(last.SpssError))
    {
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
    }
    options(spssOutputLanguage = out[[1]])
    
  	out <- .C("ext_GetCLocale",as.character(""),as.integer(errLevel),PACKAGE=spss_package)
  	last.SpssError <<-  out[[2]]
  	if( is.SpssError(last.SpssError))
  		stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)

  	options(spssLocale = out[[1]])
  	if("windows" != .Platform$OS.type)
  	{
      #in case getlocale return mutiple string.
  	  locVector<- strsplit(getOption("spssLocale"), " ")
      if(length(locVector[[1]])>1)
          options(spssLocale = locVector[[1]][[2]])     #2 for CTYPE
      else
          options(spssLocale = locVector[[1]][[1]])
  	}

    isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]	
    Sys.setenv(LANGUAGE=getLangMap(getOption("spssOutputLanguage")))
    if((!isUnicodeOn)&&("windows" != .Platform$OS.type))
    {
        Sys.setlocale("LC_ALL",getOption("spssLocale"))
    }
    else if(isUnicodeOn)
    {
        loc <- getOutputLanguageMap(getOption("spssOutputLanguage"))
        Sys.setlocale("LC_ALL",loc)
    }
    else
    {
        withCallingHandlers(
                    {                    
                        if("windows" != .Platform$OS.type)
                        {
                            loc <-getLC_ALLMap(getOption("spssLocale"))
                            Sys.setlocale("LC_ALL",loc)
                        }
                        else
                        {
                            Sys.setlocale("LC_ALL",getOption("spssLocale"))
                        }
                    },
                    warning=function(w) 
                    {
                        err <- 0;
                        s<-as.character(w);
                        .C('ext_PostOutput',s,as.integer(1),as.integer(err),PACKAGE=spss_package);
                        .C('ext_PostOutput',"Warning: Fail to set locale. R will set the current locale to English.",as.integer(1),as.integer(err),PACKAGE=spss_package);
                        Sys.setlocale("LC_ALL","English")
                    }
                    )
    }
    
    options(count = 0)
    outputWidth <- getWidth()
    if ("windows" == .Platform$OS.type)  
    {    
        closeAllConnections()
    }
    
    tempfullname <- filenameForSpssDriven()
    
    # Remove the temp file if it is existing.
    if(file.exists(tempfullname))
    {
        unlink(tempfullname)
    }    

    # Stop all existing error message diversion  if any.
    if(sink.number(type = "message") > 0)
    {
        for( i in 1:sink.number(type = "message") )
        {
            sink(type = "message")
        }
    }

    # Stop all existing output diversion  if any.
    if(sink.number() > 0)
    {
        for( i in 1:sink.number() )
        {
            sink()
        }
    }

    codepageName <- getCodePageMap(getOption("spssLocale"))
    if( isUnicodeOn || l10n_info()$'UTF-8')
        fp <- file(tempfullname, open="at", encoding="UTF-8")
    else
    {
        if(is.null(codepageName))
          fp <- file(tempfullname, open="at")
        else
          fp <- file(tempfullname, open="at",encoding=codepageName)
    }

    options(toStatOutputFileHandle=fp)
    if(getOption("toStatOutputView"))
    {
        sink(fp)
        sink(fp,type="message") 
    }
    
    options(filePosForSpssDriven = 0)
    
    if (redirectswitch())
    {
        GraphictmpPath <- getGraphictmpPath()

        if (file.exists(GraphictmpPath))
        {
            unlink(GraphictmpPath, recursive = TRUE)
        }     
        png(filename=GraphictmpPath)
    }

    if ("windows" == .Platform$OS.type)
    {
        redirection("1")
    }
    else
    {
        redirection()
    }

    if (!getOption("checkRpluginVer"))
    {
        stop(gettextf("package '%s' load failed because SPSS version '%s' does not match plugin version '%s'",
                       spss_package, spssdx_version, plugin_version),
                       call. = FALSE, domain = NA)
    }
    
    if (!getOption("spssdxFile"))
    {
        stop(gettextf("There is no spssdxcfg.ini file in '%s'",getOption("spssPath")))
    }
    spss.language <<- getLanguage()
    spss.errtable <<- getErrTable(spss.language,spss.lib,spss.pkg)
    spss.generalErr <<- getGeneralErr(spss.language,spss.lib,spss.pkg)
}

postspss <- function()
{
    if(getOption("count") > 0)
    {        
        return(NULL)
    }
    
    # Stop all existing error message diversion  if any.
    if(sink.number(type = "message") > 0)
    {
        for( i in 1:sink.number(type = "message") )
        {
            sink(type = "message")
        }
    }
    # Stop all existing output diversion if any.
    if(sink.number() > 0)
    {
        for( i in 1:sink.number() )
        {
            sink()
        }
    }
    
    postOutputToSpss()
    
    tryCatch(disconnection(),error = function(e) print(e))
    if (redirectswitch())
    {
        tryCatch(dev.off(),error = function(e) print(e))
    }
    options(spssRGraphics.displayTurnOn = TRUE)

    closeAllConnections()
    options(error = oldErrorOpt)
    options(count = getOption("count")+1)

    ## make sure all R temp files and directories to be deleted.    
    unlink(getgraphicpath(), recursive = TRUE)
    unlink(filenameForSpssDriven())
    unlink(getGraphictmpPath())
    unlink(tempdir())
    spssdata.CloseDataConnection()
    err <- 0
    if(out <- .C("ext_HasProcedure",as.integer(err),PACKAGE=spss_package)[[1]] == 1)
    {
        .C("ext_EndProcedure",as.integer(err),PACKAGE=spss_package)
        options(is.pvTableConnectionOpen = FALSE)
    }
}



quitToSPSS <- function()
{
    quit(save="ask")
}

getRtmpPath <- function()
{
	temppath <- tempdir()
	RTmpPath <- file.path(dirname(temppath), basename(temppath), 'Rtmp*')
    RTmpPath
}

getgraphicpath <- function()
{
    temppath <- tempdir()
	GraphicPath <- file.path(dirname(temppath), basename(temppath), 'RGraphics')
    GraphicPath
}

getGraphictmpPath <- function()
{
    temppath <- tempdir()
    GraphicTmpPath <- file.path(dirname(temppath), basename(temppath), 'Rplot.png')
    GraphicTmpPath
}


redirectswitch <- function()
{
    if ("windows" == .Platform$OS.type)
    {
        getX11result <- TRUE
    }

    else
    {
        getX11result <- (capabilities()[["X11"]]) && (capabilities()[["png"]])
    }
    getX11result
}

redirection <- function(displaylabel="RGraphic")
{
    if(is.null(getOption("is.firstRunRplugin"))) options(is.firstRunRplugin = TRUE)
    Rgraphicpath <- getgraphicpath()
    if(getOption("is.firstRunRplugin"))
    {
        if (file.exists(Rgraphicpath))
        {
            unlink(Rgraphicpath, recursive = TRUE)
        }    
        dir.create(Rgraphicpath, showWarnings = TRUE, recursive = FALSE)
        options(is.firstRunRplugin = FALSE)
    }
    else
    {
        if (!file.exists(Rgraphicpath))
        {
            dir.create(Rgraphicpath, showWarnings = TRUE, recursive = FALSE)
        }
    }
    if ("windows" == .Platform$OS.type)
    {
        if(is.null(getOption("graphicLabelCount"))) options(graphicLabelCount = 1)
        if(is.null(getOption("graphicLabel"))) options(graphicLabel = c("RGraphic"))
    }
    
    Rgraphicpath <- file.path(Rgraphicpath, displaylabel)
    if (!file.exists(Rgraphicpath))
    {
        dir.create(Rgraphicpath, showWarnings = TRUE, recursive = FALSE)
    }
    Rgraphicname <- 'Rplot%03d.png'
    Rgraphicfullname <- file.path(Rgraphicpath, Rgraphicname)
    
    if (redirectswitch())
    {
        png(filename=Rgraphicfullname)
    }
    else
    {
        warning("Unable to open connection to X11 display.")
    }
}

disconnection <- function()
{
    if(is.null(getOption("spssRGraphics.displayTurnOn"))) options(spssRGraphics.displayTurnOn = TRUE)
    if (getOption("spssRGraphics.displayTurnOn") && (redirectswitch()))
    {
        dev.off()
    }
    
    errLevel <- 0
        
    Rgraphicpath <- getgraphicpath()
    xdir <- list.dirs(Rgraphicpath, recursive = FALSE)
    if (length(xdir) == 0)
    {
        return(NULL)
    }
    for (RgraphDir in xdir)
    {
        xpath <- list.files( RgraphDir )
        displaylabel <- basename(RgraphDir)
        if ("windows" == .Platform$OS.type)
        {
            pos = as.integer(displaylabel)
            displaylabel = getOption("graphicLabel")[[pos]]
        }
        
        if ( length( xpath ) == 0 )
        {
            next
        }
        
        if ( length( xpath ) == 1)
        {
            Rgraphicfullname <- file.path(RgraphDir, xpath[1])
            if ( file.info(Rgraphicfullname)$size < 500 )
            {
                file.remove(Rgraphicfullname)
                next
            }
        }
        
        for( file in xpath )
        {
            Rgraphicfullname <- file.path(RgraphDir, file)
            if (getOption("InitRplugin"))
            {
                if (getOption("spssRGraphics.displayTurnOn") && getOption("toStatOutputView"))
                {
                    out <- .C("ext_SetGraphicsLabel", as.character(unicodeConverterInput(displaylabel)),
                            as.character(unicodeConverterInput(displaylabel)), as.integer(errLevel), PACKAGE=spss_package)
                    
                    last.SpssError <<- out[[3]]
                    
                    spssRGraphics.Submit(Rgraphicfullname)
                }
            }       
            file.remove(Rgraphicfullname)
        }
    }
}

          

extrapath <- function(spssPath)
{
    majorVer=unlist(strsplit(plugin_version[[1]],"\\."))[1]
    
    ##set spss application data path for extension
    defaultlibpath = .libPaths()
    if ("windows" == .Platform$OS.type)
    {
        app_path = Sys.getenv("LOCALAPPDATA")
	    if ( !file.exists(app_path ) )
	    {
		    app_path = file.path(Sys.getenv("USERPROFILE"), "AppData\\Local")
		    if ( !file.exists(app_path ) )
		    {
			    app_path = file.path(Sys.getenv("USERPROFILE"), "Local Settings\\Application Data")
		    }
	    }
	    spss_app_path = file.path(app_path, "IBM\\SPSS\\Statistics")
    }
    else if ( length(grep("darwin", R.Version()$os, ignore.case=TRUE)) > 0 )
    {
        spss_app_path = file.path(Sys.getenv("HOME"), "Library/Application Support/IBM/SPSS/Statistics")
    }
    else
    {
        spss_app_path = file.path(Sys.getenv("HOME"), ".IBM/SPSS/Statistics")
    }
    spss_ext_app_path = file.path(spss_app_path, majorVer, "extensions")
    .libPaths(c(spss_ext_app_path, defaultlibpath))
    
    #set spss default extension path 
    defaultlibpath = .libPaths()
    if ( length(grep("darwin", R.Version()$os, ignore.case=TRUE)) > 0 )
    {
        spssExtension = file.path("/Library/Application Support/IBM/SPSS/Statistics", majorVer, "extensions")
    }
    else
    {
        spssExtension = file.path(spssPath, "extensions" )
    }
    .libPaths(c(spssExtension, defaultlibpath))
    
    if ("windows" == .Platform$OS.type)
    {
        defaultlibpath = .libPaths()
        profile_path = file.path(Sys.getenv("ALLUSERSPROFILE"), "IBM\\SPSS\\Statistics", majorVer, "extensions")
        .libPaths(c(profile_path, defaultlibpath))
    }

    if ("" != Sys.getenv("SPSS_EXTENSIONS_PATH")){
        defaultlibpath = .libPaths()
        spss_ext_path = strsplit(Sys.getenv("SPSS_EXTENSIONS_PATH"), .Platform$path.sep)
        spss_ext_path = paste(unlist(spss_ext_path), sep=",")
        .libPaths(c(spss_ext_path, defaultlibpath))
    }

    if ("" != Sys.getenv("SPSS_RPACKAGES_PATH")){
        defaultlibpath = .libPaths()
        spss_pkg_path = strsplit(Sys.getenv("SPSS_RPACKAGES_PATH"), .Platform$path.sep)
        spss_pkg_path = paste(unlist(spss_pkg_path), sep=",")
        .libPaths(c(spss_pkg_path, defaultlibpath))
    }    
}

##control if to redirect R output to Statistics output view.
## output -- OFF : don't redirect to Statistics output view.
##        -- ON  : redirect to Statistics output view
spsspkg.SetOutput <- function(output)
{
    errLevel <- 0
    myArg <- list("ON","OFF")
    if(output %in% myArg) 
    {
        if ( !spsspkg.IsXDriven())
        {
            if(output == "ON") 
            {
                if(getOption("hasBrowser"))
                {
                    options(toStatOutputView = TRUE)
                    ##record the original state of output
                    options(originalOutputState = TRUE)
                    .C('ext_SetRecordBrowserOutput', as.character(filenameForSpssDriven()),as.integer(1),as.integer(errLevel),PACKAGE=spss_package)
                    spssRGraphics.SetOutput("ON")  
                }

                else if(!getOption("toStatOutputView"))
                {   
                    options(toStatOutputView = TRUE)
                    fp <- getOption("toStatOutputFileHandle")
                    sink(fp,append=TRUE)
                    sink(fp,append=TRUE,type="message") 
                    spssRGraphics.SetOutput("ON")  
                }            
            }

            else 
            {
                if(getOption("hasBrowser"))
                {
                    spssRGraphics.SetOutput("OFF")
                    options(toStatOutputView = FALSE)
                    .C('ext_SetRecordBrowserOutput', as.character(filenameForSpssDriven()),as.integer(0),as.integer(errLevel),PACKAGE=spss_package)
                }

                else if(getOption("toStatOutputView"))
                {
                    ## Stop all existing error message diversion  if any.
                    if(sink.number(type = "message") > 0)
                    {
                        for( i in 1:sink.number(type = "message") )
                        {
                            sink(type = "message")
                        }
                    }

                    ## Stop all existing output diversion  if any.
                    if(sink.number() > 0)
                    {
                        for( i in 1:sink.number() )
                        {
                            sink()
                        }
                    }    
                    spssRGraphics.SetOutput("OFF")              
                    options(toStatOutputView = FALSE)
                }
            }
        }
    }
    else stop("The argument of SetOutput should be OFF or ON ");
}

GetOutput <- function()
{
    if(getOption("toStatOutputView")) return("ON")
    else return("OFF")
}

SetOutputFromBrowser <- function(output)
{
    errLevel <- 0
    if(output %in% c("ON","OFF"))
    {
        if(output == "ON" )
        {
            options(hasBrowser = TRUE)
        }
        ##we are redirecting the R output to Statistics's output view. So we need to close this redirection.
        ##And control R otuput and Browser output to redirect to Statistics's output view.
        if(output == "ON" && getOption("toStatOutputView")) 
        {            
            ## Stop all existing error message diversion  if any.
            if(sink.number(type = "message") > 0)
            {
                for( i in 1:sink.number(type = "message") )
                {
                    sink(type = "message")
                }
            }

            ## Stop all existing output diversion  if any.
            if(sink.number() > 0)
            {
                for( i in 1:sink.number() )
                {
                    sink()
                }
            }    
            options(hasBrowser = TRUE)
            .C('ext_SetRecordBrowserOutput', as.character(filenameForSpssDriven()),as.integer(1),as.integer(errLevel),PACKAGE=spss_package)
            close(getOption("toStatOutputFileHandle"))
            options(toStatOutputFileHandle = NULL)
        }
        else if(output == "OFF" && getOption("hasBrowser"))
        {
            .C('ext_SetRecordBrowserOutput', as.character(filenameForSpssDriven()),as.integer(0),as.integer(errLevel),PACKAGE=spss_package) 
            options(hasBrowser = FALSE)              
        }
    }
    else 
    {
        stop("The argument of SetOutputFromBrowser should be ON or OFF")   
    }            

}

initPackage <- function()
{
    if(is.null(getOption("isInitialized"))) options(isInitialized = FALSE)
    
    if(!getOption("isInitialized"))
    {
        if(is.null(getOption("toStatOutputView"))) options(toStatOutputView = TRUE)
        if(is.null(getOption("is.splitConnectionOpen"))) options(is.splitConnectionOpen = FALSE)
        if(is.null(getOption("is.pvTableConnectionOpen"))) options(is.pvTableConnectionOpen = FALSE)
        if(is.null(getOption("spssRGraphics.displayTurnOn"))) options(spssRGraphics.displayTurnOn = TRUE)
        if(is.null(getOption("is.dataStepRunning"))) options(is.dataStepRunning = FALSE)

        if(bindingIsLocked("spss.PivotTableMap", asNamespace(spssNamespace)))
            unlockBinding("spss.PivotTableMap", asNamespace(spssNamespace))
            
        if(bindingIsLocked("spss.DimensionMap", asNamespace(spssNamespace)))
            unlockBinding("spss.DimensionMap", asNamespace(spssNamespace))
            
        if(bindingIsLocked("spss.CellTextMap", asNamespace(spssNamespace)))
            unlockBinding("spss.CellTextMap", asNamespace(spssNamespace))
            
        options(isInitialized = TRUE)
        options(runStartStatistics = FALSE)
        if(is.null(getOption("statsOutputInR"))) options(statsOutputInR = TRUE)
        if(is.null(getOption("filePosForRDriven"))) options(filePosForRDriven = 0)
        if(is.null(getOption("SPSSStatisticsTraceback"))) options(SPSSStatisticsTraceback = TRUE)
    }
}

postOutputToSpss <- function()
{
    tempfile <- filenameForSpssDriven()
    tryCatch(
      {
        isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
        if( isUnicodeOn )
        {
            myEncoding <- "UTF-8"
        }
        else
        {
            myEncoding <- "unknown"
        }

        checkoutput<-scan(tempfile,
                          what='raw',
                          blank.lines.skip=FALSE,
                          sep='\n',
                          skip=getOption("filePosForSpssDriven"),
                          quiet=TRUE,
                          encoding = myEncoding)
      },
      error=function(ex) 
      {
          checkoutput<-'File did not exist or invalid!'
      }
    )
    
    err <- 0
    width <- 255
    lines<-length(checkoutput)
    if( lines > 0 )
    {
        if( is.null(checkoutput[lines]) || "" == checkoutput[lines])
        {
            lines <- lines - 1
            checkoutput <- checkoutput[1:lines]
        }
        for( i in 1:lines )
        {
            if( is.null(checkoutput[i]) || "" == checkoutput[i])
            {
                text <- ""
                out <- .C('ext_PostOutput',as.character((text)),
                                           as.integer(1),
                                           as.integer(err),
                                           PACKAGE=spss_package)
            }

            else
            {
                text <- checkoutput[i]
                isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
                if( isUnicodeOn )  ##make sure the nchar() can be correctly calculated. 
                    Encoding(text)<-"UTF-8"

                if(!is.na(nchar(text, "chars", TRUE)))
                { 
                    loop <- as.integer(nchar(text)/(width))
                    rm <- abs(nchar(text) - loop*(width))                  

                    if(loop>0)
                    {
                        for( m in 1:loop )
                        {
                            subtext <- substr(text,as.integer((m-1)*width+1),as.integer(m*width))
					        Encoding(subtext)<-"native.enc"
                            out <- .C('ext_PostOutput',as.character((subtext)),
                                                       as.integer(1),
                                                       as.integer(err),
                                                       PACKAGE=spss_package)
                        }
                    }

                    if( rm >0 )
                    {
                        subtext <- substr(text,as.integer(loop*width+1),nchar(text))
						Encoding(subtext)<-"native.enc"
                        out <- .C('ext_PostOutput',as.character((subtext)),
                                                   as.integer(1),
                                                   as.integer(err),
                                                   PACKAGE=spss_package)
                    }
                }

                else    ## exception case: is.na(nchar(text, "chars", TRUE))
                {
                    Encoding(text)<-"native.enc"
          					out <- .C('ext_PostOutput',as.character((text)),
                                   as.integer(1),
                                   as.integer(err),
                                   PACKAGE=spss_package)
                }
            }
        }
    }
    tempLines <- getOption("filePosForSpssDriven") + lines
    options(filePosForSpssDriven = tempLines)
}

postOutputToR <- function()
{   
    tryCatch(
      { 
        isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
        if( isUnicodeOn )
        {
            myEncoding <- "UTF-8"
        }
        else
        {
            myEncoding <- "unknown"
        }
        # Stop all existing error message diversion  if any.
        if(sink.number(type = "message") > 0)
        {
            for( i in 1:sink.number(type = "message") )
            {
                sink(type = "message")
            }
        }
        # Stop all existing output diversion if any.
        if(sink.number() > 0)
        {
            for( i in 1:sink.number() )
            {
                sink()
            }
        }

        checkoutput<-scan(getOption("RDrivenTempfile"),
                          what='raw',
                          blank.lines.skip=FALSE,
                          sep='\n',
                          skip=getOption("filePosForRDriven"),
                          quiet=TRUE,
                          encoding = myEncoding)        
      },
      error=function(ex) 
      {
          checkoutput<-'File did not exist or invalid!'
      }
    )
    
    err <- 0
    lines<-length(checkoutput)
    if( lines > 0 )
    {
        for( i in 1:lines )
        {
            result <- ""
            if( is.null(checkoutput[i]) || "" == checkoutput[i])
            {
                result <- ""
            }

            else
            {
                result <- checkoutput[i]
                isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
                if( isUnicodeOn )  ##make sure the nchar() can be correctly calculated.
                {
                    Encoding(result)<-"UTF-8"
                }
                else
                {
                    Encoding(result)<-"native.enc"
                }
            }
            cat(result, "\n")
        }
    }
    tempLines <- getOption("filePosForRDriven") + lines
    options(filePosForRDriven = tempLines)
}

spsspkg.StartStatistics <- function(hide="", show="", nfc=TRUE, nl=TRUE)
{
    errLevel <- 0
    initPackage()
    isRDriven <- spsspkg.IsXDriven()
    if(isRDriven)
    {
        isReady <- spsspkg.IsBackendReady()
        if(!isReady)
        {
            cmd <- ""
            if("" != hide)
            {
                cmd <- paste(cmd, "-hide", hide)
            }
            if("" != show)
            {
                cmd <- paste(cmd, "-show", show)
            }
            if(!nfc)
            {
                cmd <- paste(cmd, "-nfc")
            }
            if(!nl)
            {
                cmd <- paste(cmd, "-nl")
            }
            
            tempfullname <- filename()
            options(RDrivenTempfile = tempfullname)
            
            # Remove the temp file if it is existing.
            if(file.exists(tempfullname))
            {
                unlink(tempfullname)
            }
            
            commandLine <- paste("-out", tempfullname)
            commandLine <- paste(commandLine, cmd, sep="")
            out <- .C("ext_StartSpss", as.character(commandLine), as.integer(errLevel), PACKAGE=spss_package)
            last.SpssError <<- out[[2]]
            
            spss.language <<- getLanguage()
            spss.errtable <<- getErrTable(spss.language,spss.lib,spss.pkg)
            spss.generalErr <<- getGeneralErr(spss.language,spss.lib,spss.pkg)
            
            if( is.SpssError(last.SpssError))
                stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
                
            options(runStartStatistics = TRUE)
        }
    }
}

spsspkg.StopStatistics <- function()
{
    errLevel <- 0
    isReady <- spsspkg.IsBackendReady()
    if(isReady)
    {
        isRDriven <- spsspkg.IsXDriven()
        if(isRDriven)
        {
            out <- .C("ext_StopSpss", as.integer(errLevel), PACKAGE=spss_package)
            last.SpssError <<- out[[1]]
            if( is.SpssError(last.SpssError))
                stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
            
            unlink(getOption("RDrivenTempfile"))
            options(filePosForRDriven = 0)
        }
    }
}

spsspkg.Submit <- function(commands)
{
    errLevel <- 0
    isReady <- spsspkg.IsBackendReady()
    if(!isReady)
    {
        spsspkg.StartStatistics()
    }
    if (is.vector(commands))
    {
        tempVec <- c()
        commandCount<-length(commands)
        if (commandCount>1)
        {
            for( i in 1:commandCount )
            {
                tempVec <- c(tempVec, commands[[i]])
            }
        }
        else
        {
            commands <- strsplit(commands, "\n")[[1]]
            cmdCount <- length(commands)
            for ( i in 1:cmdCount )
            {
                tempVec <- c(tempVec, commands[[i]])
            }
        }
        
        tempLen <- length(tempVec)
        if (tempLen > 1)
        {
            for ( command in tempVec[1:tempLen-1] )
            {
                cmdLength <- nchar(command)
                out <- .C("ext_QueueCommandPart", as.character(command), as.integer(cmdLength), as.integer(errLevel), PACKAGE=spss_package)
                last.SpssError <<- out[[3]]
                if( is.SpssError(last.SpssError))
                    stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
            }
        }
        
        if(!getOption("runStartStatistics"))
        {
            postOutputToSpss()
        }
        
        cmdLength <- nchar(tempVec[tempLen])
        out <- .C("ext_Submit", as.character(tempVec[tempLen]), as.integer(cmdLength), as.integer(errLevel), PACKAGE=spss_package)
        if(getOption("runStartStatistics") && getOption("statsOutputInR"))
        {
            postOutputToR()
        }
        last.SpssError <<- out[[3]]
        if( is.SpssError(last.SpssError))
            stop(printSpssError(last.SpssError),call. = getOption("SPSSStatisticsTraceback"), domain = NA)
    }
}

spsspkg.SetStatisticsOutput <- function(output)
{
    errLevel <- 0
    myArg <- list("ON","OFF")
    if(toupper(output) %in% myArg) 
    {
        if(output == "ON") 
        {
            options(statsOutputInR = TRUE)
        }

        else 
        {
            options(statsOutputInR = FALSE)
        }
    }
    else stop("The argument of SetStatisticsOutput should be OFF or ON ");
}

spsspkg.IsXDriven <- function()
{
    isRDriven <- .C("ext_IsXDriven",as.logical(FALSE),PACKAGE=spss_package)[[1]]
    
    return (isRDriven)
}

spsspkg.IsUTF8mode <- function()
{
    isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
    
    return (isUnicodeOn)
}

spsspkg.IsBackendReady <- function()
{
    isReady <- .C("ext_IsBackendReady",as.logical(FALSE),PACKAGE=spss_package)[[1]]
    
    return (isReady)
}

