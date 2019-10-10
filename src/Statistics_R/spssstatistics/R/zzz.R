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

.onLoad <- function(libname, pkgname)
{
    loadStatus <- get_essentials_for_r_loading_status()
    if(!loadStatus)
    {
        statsVerCfg <- file.path(libname, pkgname, "spssstatistics.ini")
        verInfo <- ""
        if(file.exists(statsVerCfg))
        {
            lines <- scan(statsVerCfg,
                          what='character',
                          blank.lines.skip=FALSE,
                          sep='\n',
                          skip=1,
                          quiet=TRUE)
            
            if(any(i <- grep("statistics_version",lines,fixed = TRUE )))
            {
                lineCount <- length(i)
                validVer <- i[lineCount]
                verInfo <- unlist(strsplit(lines[validVer],"="))[2]
                verInfo <- gsub("(^ +)|( +$)", "", verInfo)
            }
            size <- nchar(verInfo)
            if(3 != size)
            {
                verInfo <- latest_essentials_for_r_version()
            }
        }
        else
        {
            verInfo <- latest_essentials_for_r_version()
        }
        statspkg <- paste("spss", verInfo, sep = "")
        options(SPSSPkgName = statspkg)
        load_essentials_for_r_package(statspkg, loadStatus)
    }
}

.onUnload <- function(libpath)
{
    statspkg <- getOption("SPSSPkgName")
    name <- paste("package", statspkg, sep = ":")
    detach(name, unload=TRUE, character.only = TRUE)
}