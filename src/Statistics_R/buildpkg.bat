@REM ************************************************************************
@REM Licensed Materials - Property of IBM 
@REM
@REM IBM SPSS Products: Statistics Common
@REM
@REM (C) Copyright IBM Corp. 1989, 2019
@REM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp. 
@REM ************************************************************************

SET PLATFORM_FOLDER=%1

IF not EXIST c:\temp\R mkdir c:\temp\R
SET SRCPKGPATH=c:\temp\R

rem for g++ compile because g++ don't support slash directory.
SET SRCPKG=c:/temp/R

rem SET RTOOLS=c:\RTools
rem SET HTMLHELP=C:\Progra~1\HTML Help Workshop
SET PATH=%HTMLHELP%;%RTOOLS%\bin;%RTOOLS%\gcc-4.6.3\bin;%Path%

cd /d %SRCPKGPATH%
IF EXIST spss rd /S /Q spss

rem build source package.

rem Rcmd BATCH will create the spss directory in %SRCPKGPATH%. if there are some syntax error in source.r,
rem it can't create the spss directory. You can open the source.r in rgui, and rgui will report the systax error
rem and you must fix it. 
cd /d %R_HOME%\bin\%PLATFORM_FOLDER%
Rcmd BATCH %2\Statistics_R\spss\source.r

IF not EXIST %SRCPKGPATH%\spss\R mkdir %SRCPKGPATH%\spss\R
IF not EXIST %SRCPKGPATH%\spss\man mkdir %SRCPKGPATH%\spss\man
rem IF not EXIST %SRCPKGPATH%\spss\libs mkdir %SRCPKGPATH%\spss\libs
IF not EXIST %SRCPKGPATH%\spss\src mkdir %SRCPKGPATH%\spss\src

rem replace the rd document.
copy /Y %2\Statistics_R\spss\R\*.R %SRCPKGPATH%\spss\R
copy /Y %2\Statistics_R\spss\R\zzz.r %SRCPKGPATH%\spss\R
copy /Y %2\Statistics_R\spss\man\*.Rd %SRCPKGPATH%\spss\man
copy /Y %2\Statistics_R\spss\DESCRIPTION %SRCPKGPATH%\spss\DESCRIPTION
copy /Y %2\Statistics_R\spss\NAMESPACE %SRCPKGPATH%\spss\NAMESPACE

copy /Y %2\Statistics_R\spss\src\*.cpp %SRCPKGPATH%\spss\src
copy /Y %2\Statistics_R\spss\src\*.h %SRCPKGPATH%\spss\src
copy /Y %2\Statistics_R\spss\src\Makevars.win %SRCPKGPATH%\spss\src\Makevars

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
copy /Y %2\Statistics_R\lang\en\spssr.properties %SRCPKGPATH%\spss\inst\lang\en
copy /Y %2\Statistics_R\lang\de\spssr.properties %SRCPKGPATH%\spss\inst\lang\de
copy /Y %2\Statistics_R\lang\es\spssr.properties %SRCPKGPATH%\spss\inst\lang\es
copy /Y %2\Statistics_R\lang\fr\spssr.properties %SRCPKGPATH%\spss\inst\lang\fr
copy /Y %2\Statistics_R\lang\it\spssr.properties %SRCPKGPATH%\spss\inst\lang\it
copy /Y %2\Statistics_R\lang\ja\spssr.properties %SRCPKGPATH%\spss\inst\lang\ja
copy /Y %2\Statistics_R\lang\ko\spssr.properties %SRCPKGPATH%\spss\inst\lang\ko
copy /Y %2\Statistics_R\lang\pl\spssr.properties %SRCPKGPATH%\spss\inst\lang\pl
copy /Y %2\Statistics_R\lang\ru\spssr.properties %SRCPKGPATH%\spss\inst\lang\ru
copy /Y %2\Statistics_R\lang\zh_cn\spssr.properties %SRCPKGPATH%\spss\inst\lang\zh_cn
copy /Y %2\Statistics_R\lang\zh_tw\spssr.properties %SRCPKGPATH%\spss\inst\lang\zh_tw
copy /Y %2\Statistics_R\lang\pt_BR\spssr.properties %SRCPKGPATH%\spss\inst\lang\pt_BR
copy /Y %2\Statistics_R\spss\spssxdcfg.ini %SRCPKGPATH%\spss\inst\spssxdcfg.ini

rem install package.
R CMD INSTALL --html --no-test-load --library="%R_HOME%\library" %SRCPKG%/spss

rem build spssstatistics package.
IF EXIST %SRCPKGPATH%\spssstatistics rd /S /Q %SRCPKGPATH%\spssstatistics
IF not EXIST %SRCPKGPATH%\spssstatistics\R mkdir %SRCPKGPATH%\spssstatistics\R
IF not EXIST %SRCPKGPATH%\spssstatistics\inst mkdir %SRCPKGPATH%\spssstatistics\inst
IF not EXIST %SRCPKGPATH%\spssstatistics\man mkdir %SRCPKGPATH%\spssstatistics\man

copy /Y %2\Statistics_R\spssstatistics\R\*.R %SRCPKGPATH%\spssstatistics\R
copy /Y %2\Statistics_R\spssstatistics\inst\spssstatistics.ini %SRCPKGPATH%\spssstatistics\inst
copy /Y %2\Statistics_R\spssstatistics\man\*.Rd %SRCPKGPATH%\spssstatistics\man
copy /Y %2\Statistics_R\spssstatistics\DESCRIPTION %SRCPKGPATH%\spssstatistics\DESCRIPTION
copy /Y %2\Statistics_R\spssstatistics\NAMESPACE %SRCPKGPATH%\spssstatistics\NAMESPACE

R CMD INSTALL --html --no-test-load --library="%R_HOME%\library"  %SRCPKG%/spssstatistics

rd /S /Q %SRCPKGPATH%
