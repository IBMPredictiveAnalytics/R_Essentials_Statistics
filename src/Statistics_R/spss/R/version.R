#############################################
# IBM® SPSS® Statistics - Essentials for R
# (c) Copyright IBM Corp. 1989, 2011
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

spsspkg.Version <- function()
{
	ver <- list(
				platform = R.Version()$platform,
				arch = R.Version()$arch,
				os = R.Version()$os,
				system = R.Version()$system,
				version.string = plugin_version
			   )
    ver
}

GetSPSSPlugInVersion <- function()
{
    plugin_version
}

GetSPSSVersion <- function()
{
    spssdx_version
}

spsspkg.GetSPSSPlugInVersion <- function()
{
    plugin_version
}

spsspkg.GetSPSSVersion <- function()
{
    spssdx_version
}
