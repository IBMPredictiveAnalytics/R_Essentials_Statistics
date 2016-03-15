@REM ************************************************************************
@REM IBM Confidential
@REM
@REM OCO Source Materials
@REM
@REM IBM SPSS Products: Statistics Common
@REM
@REM (C) Copyright IBM Corp. 1989, 2011
@REM
@REM The source code for this program is not published or otherwise divested of its trade secrets, 
@REM irrespective of what has been deposited with the U.S. Copyright Office.
@REM ************************************************************************

@ECHO OFF

@REM set the PATH to include the installation directory
SET INSTALLDIR=%~sdp0
SET PATH=%INSTALLDIR%;%PATH%

@REM run passed in paramater
%*
