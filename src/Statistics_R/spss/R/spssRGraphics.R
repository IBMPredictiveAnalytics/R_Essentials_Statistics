#############################################
# IBM?SPSS?Statistics - Essentials for R
# (c) Copyright IBM Corp. 1989, 2013
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

spssRGraphics.Submit <- function(filename)
{
	errLevel <- 0

	if (!file.exists(filename))
	{
        last.SpssError <<- 1014 
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
		return("file name error")
	}
    spsstemplist <- toupper(unlist(strsplit(filename, "\\.")))
	tempname <- spsstemplist[length(spsstemplist)]
	if (is.na(tempname))
	{
        last.SpssError <<- 1015 
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
		return("file format error")
	}
	if (tempname!="PNG" && tempname!="JPG" && tempname!="BMP")
	{
        last.SpssError <<- 1015 
        stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
		return("file format error")
	}
	
	out <- .C('ext_GetGraphic', as.character(unicodeConverterInput(filename)),
							 as.integer(errLevel),
							 PACKAGE=spss_package)
	last.SpssError <<- out[[2]]

}

spssRGraphics.SetOutput <- function(switch)
{
    if (getOption("toStatOutputView"))
    {
        if (toupper(switch) == "ON")
        {
            if (!getOption("spssRGraphics.displayTurnOn"))
            {
                if ("windows" == .Platform$OS.type)
                {
                    folder = getOption("graphicLabelCount")
                    redirection(sprintf('%d',folder))
                }
                else
                {
                    redirection()
                }
                
                options(spssRGraphics.displayTurnOn = TRUE)
            }
        }
        else if (toupper(switch) == "OFF")
        {
            if (getOption("spssRGraphics.displayTurnOn"))
            {
                disconnection()
                
                options(spssRGraphics.displayTurnOn = FALSE)
            }
        }
        else
        {
            last.SpssError <<- 1016 
            stop(printSpssError(last.SpssError),call. = FALSE, domain = NA)
        }
    }
}

spssRGraphics.SetGraphicsLabel <- function(displaylabel="RGraphic")
{
    if(is.null(getOption("spssRGraphics.displayTurnOn"))) options(spssRGraphics.displayTurnOn = TRUE)
    if (getOption("spssRGraphics.displayTurnOn") && (redirectswitch()))
    {
        dev.off()
    }
    
    if ("windows" == .Platform$OS.type)
    {
        folder = getOption("graphicLabelCount")
        folder = folder + 1
        redirection(sprintf('%d',folder))
        options(graphicLabel = c(getOption("graphicLabel"), displaylabel))
        options(graphicLabelCount = folder)
    }
    else
    {
        redirection(displaylabel)
    }
}