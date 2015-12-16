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

installed_essentials_for_r_version <- function()
{
    packageList <- list.files(.libPaths(), pattern="^spss[0-9]{3}")
    verList <- c()
    for(package in packageList)
    {
        if(7 == nchar(package))
        {
            verList <- c(verList, substr(package, 5, 7))
        }
    }
    return(verList)
}

latest_essentials_for_r_version <- function()
{
    verList <- installed_essentials_for_r_version()
    size <- length(verList)
    verList <- sort(verList)
    return(verList[size])
}

get_essentials_for_r_loading_status <- function()
{
    loadingList <- .packages()
    for(pkg in loadingList)
    {
        result <- grepl("^spss[0-9]{3}", pkg)
        if(result)
        {
            break
        }
    }
    return(result)
}

load_essentials_for_r_package <- function(pkgname, status)
{
    if(!status)
    {
        library(pkgname, character.only = TRUE)
    }
}