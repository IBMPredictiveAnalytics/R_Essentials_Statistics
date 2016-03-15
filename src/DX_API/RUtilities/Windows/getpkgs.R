#/***********************************************************************
# * Licensed Materials - Property of IBM 
# *
# * IBM SPSS Products: Statistics Common
# *
# * (C) Copyright IBM Corp. 1989, 2013
# *
# * US Government Users Restricted Rights - Use, duplication or disclosure
# * restricted by GSA ADP Schedule Contract with IBM Corp. 
# ************************************************************************/

if ("" != Sys.getenv("SPSS_RPACKAGES_PATH")){
    defaultlibpath = .libPaths()
    spss_pkg_path = strsplit(Sys.getenv("SPSS_RPACKAGES_PATH"), .Platform$path.sep)
    spss_pkg_path = paste(unlist(spss_pkg_path), sep=",")
    .libPaths(c(spss_pkg_path, defaultlibpath))
}
args<-commandArgs(TRUE)
pkgs<-c()
pkgstoget<-c()
pkgstoupdate<-c()
path<-""
downloadrepos=""
for (i in 1:length(args)){
  if (length(grep("'",args[[i]])>0)){
     for (j in i:length(args)){
        path<-paste(path,args[[j]])
     }
     path<-gsub("^\\s*'","",path)
     path<-gsub("'\\s*$","",path)
     break
  }
  else pkgs<-c(pkgs,args[[i]])
}

for (i in 1:length(pkgs)){
    res<-tryCatch(library(pkgs[[i]], character.only=TRUE),
        error=function(e){return(FALSE)})
    if (identical(res,FALSE)){
        pkgstoget<-c(pkgstoget,pkgs[[i]])
    }else
    {
        pkgstoupdate<-c(pkgstoupdate,pkgs[[i]])
    }
}

if (strsplit(Sys.getlocale("LC_CTYPE"),"_")[[1]][1] == "Chinese" || strsplit(Sys.getlocale("LC_CTYPE"),"_")[[1]][1] == "zh")
{
    downloadrepos = "http://ftp.ctex.org/mirrors/CRAN"
}else
{
    downloadrepos = "http://cran.r-project.org"
}

if (!is.null(pkgstoget)){
    pkgsfailed<-c()
    for (i in 1:length(pkgstoget)){
        for (j in 1:length(.libPaths())){
            res<-tryCatch(install.packages(pkgstoget[[i]], lib=.libPaths()[[j]], repos=downloadrepos),error=function(e){return(FALSE)})
            res<-tryCatch(library(pkgstoget[[i]], character.only=TRUE),error=function(e){return(FALSE)})
            if (!identical(res,FALSE)) break
        }
        if (identical(res,FALSE)){pkgsfailed<-c(pkgsfailed,pkgstoget[[i]])}
    }
    if(!is.null(pkgsfailed)){
       f<-file(description=path,open="w")
       writeLines(pkgsfailed,con=f)
       close(f)
       stop()
    }
}

if (!is.null(pkgstoupdate)){
    for (i in 1:length(pkgstoupdate)){
        packagestring <- paste("package:", pkgstoupdate[[i]], sep="")
        detach(packagestring, character.only=TRUE, force=TRUE)
    }
    res<-tryCatch(update.packages(repos=downloadrepos, ask=FALSE,oldPkgs=pkgstoupdate),error=function(e){return(FALSE)})
}
