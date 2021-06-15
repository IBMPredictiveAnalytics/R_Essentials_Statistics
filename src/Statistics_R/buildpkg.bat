@REM ************************************************************************
@REM Licensed Materials - Property of IBM 
@REM
@REM IBM SPSS Products: Statistics Common
@REM
@REM (C) Copyright IBM Corp. 1989, 2021
@REM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp. 
@REM ************************************************************************

IF not EXIST c:\temp\R mkdir c:\temp\R
SET SRCPKGPATH=c:\temp\R

rem SET RTOOLS=c:\RTools
SET PATH=%RTOOLS%\mingw64\bin;%RTOOLS%\usr\bin;%Path%

IF EXIST %SRCPKGPATH%\spss rd /S /Q %SRCPKGPATH%\spss

IF not EXIST %SRCPKGPATH%\spss\R mkdir %SRCPKGPATH%\spss\R
IF not EXIST %SRCPKGPATH%\spss\man mkdir %SRCPKGPATH%\spss\man
rem IF not EXIST %SRCPKGPATH%\spss\libs mkdir %SRCPKGPATH%\spss\libs
IF not EXIST %SRCPKGPATH%\spss\src mkdir %SRCPKGPATH%\spss\src

rem replace the rd document.
copy /Y spss\R\*.R %SRCPKGPATH%\spss\R
copy /Y spss\R\zzz.r %SRCPKGPATH%\spss\R
copy /Y spss\man\*.Rd %SRCPKGPATH%\spss\man
copy /Y spss\DESCRIPTION %SRCPKGPATH%\spss\DESCRIPTION
copy /Y spss\NAMESPACE %SRCPKGPATH%\spss\NAMESPACE

copy /Y spss\src\*.cpp %SRCPKGPATH%\spss\src
copy /Y spss\src\*.h %SRCPKGPATH%\spss\src
copy /Y spss\src\Makevars.win %SRCPKGPATH%\spss\src\Makevars

mkdir %SRCPKGPATH%\spss\inst\lang\en
mkdir %SRCPKGPATH%\spss\inst\lang\de
mkdir %SRCPKGPATH%\spss\inst\lang\es
mkdir %SRCPKGPATH%\spss\inst\lang\fr
mkdir %SRCPKGPATH%\spss\inst\lang\it
mkdir %SRCPKGPATH%\spss\inst\lang\ja
mkdir %SRCPKGPATH%\spss\inst\lang\ko
mkdir %SRCPKGPATH%\spss\inst\lang\pl
mkdir %SRCPKGPATH%\spss\inst\lang\ru
mkdir %SRCPKGPATH%\spss\inst\lang\zh_cn
mkdir %SRCPKGPATH%\spss\inst\lang\zh_tw
mkdir %SRCPKGPATH%\spss\inst\lang\pt_BR
copy /Y lang\en\spssr.properties %SRCPKGPATH%\spss\inst\lang\en
copy /Y lang\de\spssr.properties %SRCPKGPATH%\spss\inst\lang\de
copy /Y lang\es\spssr.properties %SRCPKGPATH%\spss\inst\lang\es
copy /Y lang\fr\spssr.properties %SRCPKGPATH%\spss\inst\lang\fr
copy /Y lang\it\spssr.properties %SRCPKGPATH%\spss\inst\lang\it
copy /Y lang\ja\spssr.properties %SRCPKGPATH%\spss\inst\lang\ja
copy /Y lang\ko\spssr.properties %SRCPKGPATH%\spss\inst\lang\ko
copy /Y lang\pl\spssr.properties %SRCPKGPATH%\spss\inst\lang\pl
copy /Y lang\ru\spssr.properties %SRCPKGPATH%\spss\inst\lang\ru
copy /Y lang\zh_cn\spssr.properties %SRCPKGPATH%\spss\inst\lang\zh_cn
copy /Y lang\zh_tw\spssr.properties %SRCPKGPATH%\spss\inst\lang\zh_tw
copy /Y lang\pt_BR\spssr.properties %SRCPKGPATH%\spss\inst\lang\pt_BR
copy /Y spss\spssxdcfg.ini %SRCPKGPATH%\spss\inst\spssxdcfg.ini

rem install package.
cd /d "%R_HOME%"\bin\x64
R CMD INSTALL --html --no-test-load --library="%R_HOME%\library" %SRCPKGPATH%\spss

rd /S /Q %SRCPKGPATH%
