@REM /***********************************************************************
@REM * Licensed Materials - Property of IBM 
@REM *
@REM * IBM SPSS Products: Statistics Common
@REM *
@REM * (C) Copyright IBM Corp. 1989, 2014
@REM *
@REM * US Government Users Restricted Rights - Use, duplication or disclosure
@REM * restricted by GSA ADP Schedule Contract with IBM Corp. 
@REM ************************************************************************/

@ECHO OFF

@REM set the PATH to include the installation directory
SET INSTALLDIR=%~sdp0
SET PATH=%INSTALLDIR%;%PATH%

@REM run passed in paramater
%*
