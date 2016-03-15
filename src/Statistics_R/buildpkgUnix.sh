#!/bin/sh

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

MACHINE=`uname`

if [ $MACHINE = "Darwin" ] ; then
    VARFILE=Makevars.mac

elif [ $MACHINE = "Linux" ] ; then
    VARFILE=Makevars.lnx64
fi

SRCPKGPATH=$HOME/tmp

if [ -d $SRCPKGPATH ]; then
    rm -fr $SRCPKGPATH/tempr
    mkdir $SRCPKGPATH/tempr
else
    mkdir $SRCPKGPATH
    mkdir $SRCPKGPATH/tempr
fi

mkdir $SRCPKGPATH/tempr/spss
mkdir $SRCPKGPATH/tempr/spss/inst
mkdir $SRCPKGPATH/tempr/spss/inst/lang
mkdir $SRCPKGPATH/tempr/spss/inst/lang/en
mkdir $SRCPKGPATH/tempr/spss/inst/lang/de
mkdir $SRCPKGPATH/tempr/spss/inst/lang/es
mkdir $SRCPKGPATH/tempr/spss/inst/lang/fr
mkdir $SRCPKGPATH/tempr/spss/inst/lang/it
mkdir $SRCPKGPATH/tempr/spss/inst/lang/ja
mkdir $SRCPKGPATH/tempr/spss/inst/lang/ko
mkdir $SRCPKGPATH/tempr/spss/inst/lang/pl
mkdir $SRCPKGPATH/tempr/spss/inst/lang/ru
mkdir $SRCPKGPATH/tempr/spss/inst/lang/zh_cn
mkdir $SRCPKGPATH/tempr/spss/inst/lang/zh_tw
mkdir $SRCPKGPATH/tempr/spss/inst/lang/pt_BR
mkdir $SRCPKGPATH/tempr/spss/man
mkdir $SRCPKGPATH/tempr/spss/R
mkdir $SRCPKGPATH/tempr/spss/src

# copy DESCRIPTION file and update bugfix version in it.
cp spss/DESCRIPTION $SRCPKGPATH/tempr/spss/
cp spss/NAMESPACE $SRCPKGPATH/tempr/spss/

cp spss/source.r $SRCPKGPATH/tempr/spss/

cp lang/en/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/en/
cp lang/de/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/de/
cp lang/es/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/es/
cp lang/fr/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/fr/
cp lang/it/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/it/
cp lang/ja/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/ja/
cp lang/ko/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/ko/
cp lang/pl/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/pl/
cp lang/ru/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/ru/
cp lang/zh_cn/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/zh_cn/
cp lang/zh_tw/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/zh_tw/
cp lang/pt_BR/spssr.properties $SRCPKGPATH/tempr/spss/inst/lang/pt_BR/

cp spss/man/SPSS-package.Rd $SRCPKGPATH/tempr/spss/man/SPSS-package.Rd
cp spss/man/spssdata.Rd $SRCPKGPATH/tempr/spss/man/spssdata.Rd
cp spss/man/spssdictionary.Rd $SRCPKGPATH/tempr/spss/man/spssdictionary.Rd
cp spss/man/spsspivottable.Rd $SRCPKGPATH/tempr/spss/man/spsspivottable.Rd
cp spss/man/spssxmlworkspace.Rd $SRCPKGPATH/tempr/spss/man/spssxmlworkspace.Rd
cp spss/man/spssRGraphics.Rd $SRCPKGPATH/tempr/spss/man/spssRGraphics.Rd
cp spss/man/class.BasePivottable.Rd $SRCPKGPATH/tempr/spss/man/class.BasePivottable.Rd
cp spss/man/class.CellText.Number.Rd $SRCPKGPATH/tempr/spss/man/class.CellText.Number.Rd
cp spss/man/class.CellText.String.Rd $SRCPKGPATH/tempr/spss/man/class.CellText.String.Rd
cp spss/man/class.CellText.VarName.Rd $SRCPKGPATH/tempr/spss/man/class.CellText.VarName.Rd
cp spss/man/class.CellText.VarValue.Rd $SRCPKGPATH/tempr/spss/man/class.CellText.VarValue.Rd
cp spss/man/class.spss.Dimension.Rd $SRCPKGPATH/tempr/spss/man/class.spss.Dimension.Rd
cp spss/man/class.TextBlock.Rd $SRCPKGPATH/tempr/spss/man/class.TextBlock.Rd
cp spss/man/extension.Rd $SRCPKGPATH/tempr/spss/man/extension.Rd

cp spss/R/action.R $SRCPKGPATH/tempr/spss/R/action.R
cp spss/R/convert.R $SRCPKGPATH/tempr/spss/R/convert.R
cp spss/R/error.R $SRCPKGPATH/tempr/spss/R/error.R
cp spss/R/pivottable.R $SRCPKGPATH/tempr/spss/R/pivottable.R
cp spss/R/spssdata.R $SRCPKGPATH/tempr/spss/R/spssdata.R
cp spss/R/spssdictionary.R $SRCPKGPATH/tempr/spss/R/spssdictionary.R
cp spss/R/spssRGraphics.R $SRCPKGPATH/tempr/spss/R/spssRGraphics.R
cp spss/R/version.R $SRCPKGPATH/tempr/spss/R/version.R
cp spss/R/xmlworkspace.R $SRCPKGPATH/tempr/spss/R/xmlworkspace.R
cp spss/R/extension.R $SRCPKGPATH/tempr/spss/R/extension.R
cp spss/R/zzz.r $SRCPKGPATH/tempr/spss/R/zzz.r

cp spss/src/RInvokeSpss.cpp $SRCPKGPATH/tempr/spss/src/RInvokeSpss.cpp
cp spss/src/RInvokeSpss.h $SRCPKGPATH/tempr/spss/src/RInvokeSpss.h

if [ "${VARFILE}" != "" ]; then
    cp spss/src/$VARFILE $SRCPKGPATH/tempr/spss/src/Makevars
fi
cd $SRCPKGPATH/tempr
R CMD INSTALL --html --no-test-load ./spss
cd ../..

rm -fr $SRCPKGPATH/tempr
