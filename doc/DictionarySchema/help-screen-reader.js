/************************************************************************
** Licensed Materials - Property of IBM
**
** IBM SPSS Products: Documentation Tools
**
** (C) Copyright IBM Corp. 2000, 2011
**
** US Government Users Restricted Rights - Use, duplication or disclosure
** restricted by GSA ADP Schedule Contract with IBM Corp.
************************************************************************/

/*

	This javascript file sets a variable to indicate whether
  screen reader help is activated. By putting the text frame
  on the left instead of the right, we get much better behavior
  in screen readers	like JAWS.

	This script sets the default to screen reader off. To set
  the screenreader format on, rename this file and rename
  help-screen-reader-on.js to help-screen-reader.js. (That's what
  format-for-screen-readers.bat does.)
  
*/

var screenreaderenabled = false;
