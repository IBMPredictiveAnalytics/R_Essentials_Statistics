@ECHO OFF
REM ************************************************************************
REM Licensed Materials - Property of IBM
REM
REM IBM SPSS Products: Documentation Tools
REM
REM (C) Copyright IBM Corp. 2000, 2011
REM
REM US Government Users Restricted Rights - Use, duplication or disclosure
REM restricted by GSA ADP Schedule Contract with IBM Corp.
REM ***********************************************************************

if exist help-screen-reader-on.js do (
  if exist help-screen-reader.js do (
    rename help-screen-reader.js help-screen-reader-off.js
  )
  rename help-screen-reader-on.js help-screen-reader.js
)
