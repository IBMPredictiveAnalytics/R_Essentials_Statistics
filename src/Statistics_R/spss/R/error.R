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

SPSS_Error <- NULL
SPSS_Warning <- NULL
error_code <- NULL
with_message <- NULL

getErrTable <- function(language,lib,pkg)
{
    errTable <- NULL

    rootPath <- file.path(lib,pkg)
    #rootPath <- spssPath
    langPath <- file.path(rootPath, "lang", language)
    fileName <- "spssr.properties"
    errfile <- file.path(langPath, fileName)

    if(!file.exists(errfile))
    {
        language = "en"
        langPath <- file.path(rootPath, "lang", language)
        errfile <- file.path(langPath, fileName)
        warning("Can not find localized error message file. Using default spssr.properties for English.")
    }
    if(!file.exists(errfile))
    {
        stop(gettextf("SPSSError: Can not find error file '%s'", errfile))
    }

    lines <- readLines(errfile,encoding="UTF-8")
    #         scan(errfile,
    #             what='character',
    #              blank.lines.skip=TRUE,
    #              sep='\n',
    #              skip=1,
    #              quiet=TRUE,
    #              fileEncoding="UTF-8")
    #              #encoding="UTF-8")
    errLevel <- 0
    if(bindingIsLocked("SPSS_Error", asNamespace(spssNamespace)))
		unlockBinding("SPSS_Error", asNamespace(spssNamespace))
    if(bindingIsLocked("SPSS_Warning", asNamespace(spssNamespace)))
		unlockBinding("SPSS_Warning", asNamespace(spssNamespace))
    if(bindingIsLocked("error_code", asNamespace(spssNamespace)))
		unlockBinding("error_code", asNamespace(spssNamespace))
    if(bindingIsLocked("with_message", asNamespace(spssNamespace)))
		unlockBinding("with_message", asNamespace(spssNamespace))
		
	isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
    for(line in lines)
    {
        if( nchar(line) == 0 )
            next
        if (!isUnicodeOn )
        {
            if ( length(grep("darwin", R.Version()$os, ignore.case=TRUE)) > 0 )
            {
                templine <- line
                line <- iconv(line,from="UTF-8")
                if(is.na(line))
                    line <- iconv(templine, from="UTF-8", to="MAC")
            }
            else
            {
                line <- iconv(line,from="UTF-8")
            }
        }
        if( substr(line,1,1) == "#" )
            next
        if( substr(line,1,9) == "SPSSError" )
        {
            SPSS_Error <<-substring(line, 11)
        }
        if( substr(line,1,11) == "SPSSWarning" )
        {
            SPSS_Warning <<-substring(line, 13)
        }
        if( substr(line,1,10) == "error_code" )
        {
            error_code <<-substring(line, 12)
        }
        if( substr(line,1,12) == "with_message" )
        {
            with_message <<-substring(line, 14)
        }
        if( substr(line,1,1) != "[" )
            next
        
        #line <- .C("ext_TransCode", as.character(""), as.character(line), 
        #            as.integer(errLevel), PACKAGE=spss_package)[[1]]
        
        tmp <- unlist(strsplit(line,"\\]_"))
        
        errType <- unlist(strsplit(tmp[1],"\\["))[2]
        errs <- unlist(strsplit(tmp[2],"="))
        errLevel <- as.integer(errs[1])
        
        #trim preceding space and tab
        errMsg <- sub('[[:space:]]+','',errs[2])
        #trim trailing white space and tab
        errMsg <- sub('[[:space:]]+$','',errMsg)
        
        oneErr <- c(errorType = errType,errorLevel = errLevel, errorMessage = errMsg)
        if(is.null(errTable))
            errTable <- data.frame(oneErr,stringsAsFactors=FALSE)
        else
            errTable <- data.frame(errTable,oneErr,stringsAsFactors=FALSE)
    }
    options(messageFile = errfile)
    errTable
}

getGeneralErr <- function(language,lib,pkg)
{
    generalTable <- NULL
    errfile <- getOption("messageFile")
    if(!file.exists(errfile))
        stop(gettextf("SPSSError: Can not find error file '%s'", errfile))

    lines <- scan(errfile,
                  what='character',
                  blank.lines.skip=TRUE,
                  sep='\n',
                  skip=1,
                  quiet=TRUE,
                  encoding="UTF-8") 
    for(line in lines)
    {
        isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]
        if (!isUnicodeOn )
        {
            if ( length(grep("darwin", R.Version()$os, ignore.case=TRUE)) > 0 )
            {
                templine <- line
                line <- iconv(line,from="UTF-8")
                if(is.na(line))
                    line <- iconv(templine, from="UTF-8", to="MAC")
            }
            else
            {
                line <- iconv(line,from="UTF-8")
            }
        }
        if( substr(line,1,1) == "#" )
            next
        if( substr(line,1,1) == "[" )
            next
        
        tmp <- unlist(strsplit(line,"="))
        if( length(tmp) < 2 )
            next
        orignal <- tmp[1]
        translated <- tmp[2]

        #trim preceding space and tab
        orignal <- sub('[[:space:]]+','',orignal)
        #translated <- sub('[[:space:]]+','',translated)
        #trim trailing white space and tab
        orignal <- sub('[[:space:]]+$','',orignal)
        #translated <- sub('[[:space:]]+$','',translated)
        
        oneMsg <- c(orignalMsg = orignal,translatedMsg = translated)
        if(is.null(generalTable))
            generalTable <- data.frame(oneMsg,stringsAsFactors=FALSE)
        else
            generalTable <- data.frame(generalTable,oneMsg,stringsAsFactors=FALSE)
    }
    generalTable
}

getLanguage <- function()
{
    lang <- "en"
    #locale <- Sys.getlocale(category = "LC_COLLATE")
    locale <- Sys.getenv("LANGUAGE")[[1]]
    
    #remvoe charset.
    #locale <- unlist(strsplit(locale,"\\."))[1]

    #Supports English only for this release.
    if("SChinese" == locale || "zh_CN" == locale)
        lang <- "zh_cn"
    else if("TChinese" == locale || "zh_TW" == locale)
        lang <- "zh_tw"
    else if("German" == locale || "de_DE" == locale)
        lang <- "de"
    else if("Spanish" == locale || "es_ES" == locale)
        lang <- "es"
    else if("French" == locale || "fr_FR" == locale)
        lang <- "fr"
    else if("Italian" == locale || "it_IT" == locale)
        lang <- "it"
    else if("Japanese" == locale || "ja_JP" == locale)
        lang <- "ja"
    else if("Korean" == locale || "ko_KO" == locale)
        lang <- "ko"
    else if("Polish" == locale || "pl_PL" == locale)
        lang <- "pl"
    else if("Russian" == locale || "ru_RU" == locale)
        lang <- "ru"
    else if("BPortugu" == locale || "pt_BR" == locale)
        lang <- "pt_BR"
    else if("English" == locale || "en_EN" == locale)
        lang <- "en"
    lang
}

is.SpssError <- function(errCode) 
{
    isErr <- FALSE
    find <- FALSE
    for( err in spss.errtable )
    {
        if( err[2] == errCode )
        {
            find <- TRUE
            if( err[1] == "error" || err[1] == "RError" )
            {
                isErr <- TRUE
                break
            }
        } 
    }
    if(!find)
        isErr <- TRUE
    isErr
}   
                        
is.SpssWarning <- function(errCode) 
{
    isWarning <- FALSE
    find <- FALSE
    for( err in spss.errtable )
    {
        if( err[2] == errCode )
        {
            find <- TRUE
            if( err[1] == "warning" )
            {
                isWarning <- TRUE
                break
            }
        } 
    }
    if(!find)
        isWarning <- TRUE
    isWarning
}                           

spss.errMsg <- function(errCode)
{
    errMsg <- "Unknown Error."
    for( err in spss.errtable )
    {
        if( err[2] == errCode )
        {
            errMsg <- err[3]
            break
        } 
    }
    errMsg
}

printSpssError <- function(err)
{
    #gettextf("%s: %s '%s' %s '%s'",translateMsg("SPSSError"),
    #          translateMsg("error_code"),err,translateMsg("with_message"),spss.errMsg(err))
    gettextf("%s: %s '%s' %s '%s'",SPSS_Error,
              error_code,err,with_message,spss.errMsg(err))
}

printSpssWarning <- function(err)
{
    #gettextf("%s: %s '%s' %s '%s'",translateMsg("SPSSWarning"),
    #          translateMsg("error_code"),err,translateMsg("with_message"),spss.errMsg(err))
    gettextf("%s: %s '%s' %s '%s'",SPSS_Warning,
              error_code,err,with_message,spss.errMsg(err))
}

options(warn=1)
last.SpssError <- 0
spssError.reset <- function() last.SpssError <<- 0

translateMsg <- function(message)
{
    msg <- message
    for( m in spss.generalErr )
    {
        if( m[1] == message )
        {
            msg <- m[2]
            break
        } 
    }
    errLevel <- 0
    msg <- .C("ext_TransCode", as.character(""), as.character(msg), 
                as.integer(errLevel), PACKAGE=spss_package)[[1]]
    msg
}


