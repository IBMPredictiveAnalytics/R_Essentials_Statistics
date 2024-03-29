#############################################
# IBM?SPSS?Statistics - Essentials for R
# (c) Copyright IBM Corp. 1989, 2021
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

readPkgVersion <- function(lib, pkg)
{
    ver <- NULL
    pfile <- file.path(lib, pkg, "Meta", "package.rds")
    if(file.exists(pfile))
    {
        # Read version from package.rds file
        ver <- readRDS(pfile)$DESCRIPTION["Version"]
    }
    else
    {
        # Read version from DESCRIPTION file
        dfile <- file.path(lib, pkg, "DESCRIPTION")
        if(!file.exists(dfile))
            stop(gettextf("There is no 'DESCRIPTION' file in '%s'",file.path(lib, pkg)))
        ver <- read.dcf(dfile,"Version")[1, ]
    }
    ver
}

plugin_version <- NULL
spssdx_version <- NULL

readSpssVersion <- function()
{
    spssExePath <- getOption("spssPath")
    spssExePath <- file.path(dirname(spssExePath), basename(spssExePath))
    if ("windows" == .Platform$OS.type)
    {
        spssdxcfg <- file.path(spssExePath,"spssdxcfg.ini")
    }
    else
    {
        spssdxcfg <- file.path(spssExePath,"bin/spssdxcfg.ini")
    }
    if(!file.exists(spssdxcfg))
    {
        spssExePath <- getwd()
        spssExePath <- file.path(dirname(spssExePath), basename(spssExePath))
        spssdxcfg <- file.path(spssExePath,"spssdxcfg.ini")
    }
    if(!file.exists(spssdxcfg))
    {
        options(InitRplugin = FALSE)
        options(spssdxFile = FALSE)
    }        
    
    if ("windows" == .Platform$OS.type)
    {
        Sys.setenv(SPSS_HOME=spssExePath)
        options(spssPath = spssExePath)
    }
    else
    {
        Sys.setenv(SPSS_HOME=dirname(spssExePath))
        options(spssPath = dirname(spssExePath))
    }

    lines <- scan(spssdxcfg,
                  what='character',
                  blank.lines.skip=FALSE,
                  sep='\n',
                  skip=1,
                  quiet=TRUE)
    
    ver = ""
    if(any(i <- grep("SpssdxVersion",lines,fixed = TRUE )))
    {
        ver <- unlist(strsplit(lines[i],"="))[2]        
        ver <- gsub("(^ +)|( +$)", "", ver)
    }    
    ver
}

readXDPathAndType <- function(lib, pkg)
{
    spssxdcfg <- file.path(lib, pkg, "spssxdcfg.ini")
    if(!file.exists(spssxdcfg))
    {
        stop(gettextf("There is no 'spssxdcfg.ini' file in '%s'",file.path(lib, pkg)))
    }
    lines <- scan(spssxdcfg,
                  what='character',
                  blank.lines.skip=FALSE,
                  sep='\n',
                  skip=1,
                  quiet=TRUE)

    path <- ""
    if(any(i <- grep("spssxd_path",lines,fixed = TRUE )))
    {
        path <- unlist(strsplit(lines[i],"="))[2]
        path <- gsub("(^ +)|( +$)", "", path)
    }
    if (is.na(path) || path == "")
    {
        if (Sys.info()["sysname"] == "Darwin")
        {
            path <- file.path(dirname(dirname(dirname(lib))), "SPSS Statistics.app", "Contents")
        }
        else
        {
            path <- dirname(dirname(lib))
        }
    }
    options(spssPath = path)
    
    type <- "onPrem"
    if(any(i <- grep("SpssxdVersionType",lines,fixed = TRUE )))
    {
        type <- unlist(strsplit(lines[i],"="))[2]
        type <- gsub("(^ +)|( +$)", "", path)
    }
    options(spssType = type)
}

setenvs <- function()
{
    rhome <- Sys.getenv("R_HOME")
    if("" == rhome)
    {
        stop(gettextf("Environment variable R_HOME must be set."))
    }
    #remove the last "\\" or "/"
    rhome <- file.path(dirname(rhome), basename(rhome))
    if( "bin" != basename(rhome) )
    {
        rhome <- file.path(rhome,"bin")
    }
    
    thePath <- Sys.getenv("PATH")
    if ("windows" == .Platform$OS.type)
    {
        pSep <- ";"
    }
    else
    {
        pSep <- ":"
    }
    thePath <- paste(rhome,thePath,sep=pSep)
    Sys.setenv(PATH=thePath)
    
    if("" == Sys.getenv("SPSSDXTEMP")){
        if("" != Sys.getenv("TEMP"))
            Sys.setenv(SPSSDXTEMP=Sys.getenv("TEMP"))
        else if("" != Sys.getenv("TMP"))
            Sys.setenv(SPSSDXTEMP=Sys.getenv("TMP"))
        else{
            #no temp folder defined.
        }
    }
    ## Add the following environement variable to make sure it is in accordance 
    ## to the R start shell
  	if ("windows" != .Platform$OS.type)
  	{
  		Sys.setenv(R_SHARE_DIR=paste(Sys.getenv("R_HOME"),"/share",sep=""))
  		Sys.setenv(R_INCLUDE_DIR=paste(Sys.getenv("R_HOME"),"/include",sep=""))
  		Sys.setenv(R_DOC_DIR=paste(Sys.getenv("R_HOME"),"/doc",sep=""))
  		Sys.setenv(R_ARCH=paste("/",.Platform$r_arch,sep=""))
  		options(htmlhelp = TRUE)
  	}    
}

# Global variable. Initilized when load pkg.
spss.errtable <- NULL
spss.generalErr <- NULL
spss_package <- NULL
spss.lib <- NULL
spss.pkg <- NULL
spssNamespace <- "spssstatistics"
spss.language <- NULL

.onAttach <- function(lib, pkg)
{
    options(InitRplugin = TRUE)
    options(checkRpluginVer = TRUE)
    options(spssdxFile = TRUE)
    
    if(bindingIsLocked("spss_package", asNamespace(spssNamespace)))
		unlockBinding("spss_package", asNamespace(spssNamespace))
        
    if(bindingIsLocked("spssdx_version", asNamespace(spssNamespace)))
		unlockBinding("spssdx_version", asNamespace(spssNamespace))
        
    if(bindingIsLocked("plugin_version", asNamespace(spssNamespace)))
		unlockBinding("plugin_version", asNamespace(spssNamespace))
        
    if(bindingIsLocked("spss.errtable", asNamespace(spssNamespace)))
		unlockBinding("spss.errtable", asNamespace(spssNamespace))
        
    if(bindingIsLocked("spss.generalErr", asNamespace(spssNamespace)))
		unlockBinding("spss.generalErr", asNamespace(spssNamespace))
        
    if(bindingIsLocked("spss.lib", asNamespace(spssNamespace)))
		unlockBinding("spss.lib", asNamespace(spssNamespace))
        
    if(bindingIsLocked("spss.pkg", asNamespace(spssNamespace)))
		unlockBinding("spss.pkg", asNamespace(spssNamespace))
        
    if(bindingIsLocked("spss.language", asNamespace(spssNamespace)))
		unlockBinding("spss.language", asNamespace(spssNamespace))
        
    if(bindingIsLocked("last.SpssError", asNamespace(spssNamespace)))
            unlockBinding("last.SpssError", asNamespace(spssNamespace))
    
    spss_package <<- pkg
    readXDPathAndType(lib, pkg)
    spssdx_version <<- readSpssVersion()
    plugin_version <<- readPkgVersion(lib, pkg)

    spssdx_version_list <<- unlist(strsplit(spssdx_version, "\\."))
    plugin_version_list <<- unlist(strsplit(plugin_version, "\\."))
    
    spssmajor_version <- paste(spssdx_version_list[1], spssdx_version_list[2], sep='.')
    pluginmajor_version <- paste(plugin_version_list[1],plugin_version_list[2],sep='.')

    setenvs()

    if(pluginmajor_version != spssmajor_version)
    {
        options(InitRplugin = FALSE)
        options(checkRpluginVer = FALSE)
    }

    library.dynam(spss_package, pkg, lib)
    
    ## Initialize error table
    spss.language <<- getLanguage()
    spss.lib <<- lib
    spss.pkg <<- pkg
    spss.errtable <<- getErrTable(spss.language,lib,pkg)
    spss.generalErr <<- getGeneralErr(spss.language,lib,pkg)
    extrapath(getOption("spssPath"), getOption("spssType"))
}

.onDetach <- function(libpath)
{
    spsspkg.StopStatistics()
}
