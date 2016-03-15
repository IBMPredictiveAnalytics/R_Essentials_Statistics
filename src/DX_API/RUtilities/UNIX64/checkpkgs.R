if ("" != Sys.getenv("SPSS_RPACKAGES_PATH")){
                    defaultlibpath = .libPaths()
    spss_pkg_path = strsplit(Sys.getenv("SPSS_RPACKAGES_PATH"), .Platform$path.sep)
                    spss_pkg_path = paste(unlist(spss_pkg_path), sep=",")
                    .libPaths(c(spss_pkg_path, defaultlibpath))
                    }
args<-commandArgs(TRUE)
pkgs<-c()
path<-""
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

pkgsfailed<-c()
for (i in 1:length(pkgs)){
    res<-tryCatch(library(pkgs[[i]], character.only=TRUE),
        error=function(e){return(FALSE)})
    if (identical(res,FALSE)){pkgsfailed<-c(pkgsfailed,pkgs[[i]])}
}

if(!is.null(pkgsfailed)){
    f<-file(description=path,open="w")
    writeLines(pkgsfailed,con=f)
    close(f)
    stop()
}
