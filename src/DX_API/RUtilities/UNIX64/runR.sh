#!/bin/bash

#/***********************************************************************
# * Licensed Materials - Property of IBM 
# *
# * IBM SPSS Products: Statistics Common
# *
# * (C) Copyright IBM Corp. 1989, 2011
# *
# * US Government Users Restricted Rights - Use, duplication or disclosure
# * restricted by GSA ADP Schedule Contract with IBM Corp. 
# ************************************************************************/


# Set the PATH to include the installation directory
HERE="${0%/*}"
D=`dirname "${HERE}"`
B=`basename "${HERE}"`
INSTALLDIR="`cd \"$D\" 2>/dev/null && pwd || echo \"$D\"`/$B"

PATH=${INSTALLDIR}:${PATH}

# Run passed in paramater
exec "$@"
