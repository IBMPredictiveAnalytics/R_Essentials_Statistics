/************************************************************************
** IBM Confidential
**
** OCO Source Materials
**
** IBM SPSS Products: Statistics Common
**
** (C) Copyright IBM Corp. 1989, 2014
**
** The source code for this program is not published or otherwise divested of its trade secrets, 
** irrespective of what has been deposited with the U.S. Copyright Office.
************************************************************************/

#ifndef _DXCALLBACK_H_
#define _DXCALLBACK_H_

#ifdef __cplusplus
extern "C" {
#endif

// Check whether Statistics backend is in UTF8 mode
// Return non-Zero number for UTF8 mode, 0 for locale mode
typedef int (*Fp_IsUTF8mode)();

// Get Statistics application type
// return -1 for unknown, 0 for server, 1 for client
typedef int (*Fp_AppMode)(); 

// Get the DX version 
// return null-terminated version nubmer
typedef const char* (*Fp_GetDXVersion)();

// Get DX temporary directory
// return null-terminated folder path
typedef const char* (*Fp_GetDXTempDir)();

// Get current nest depth
// return 0 for no nest, positive integer for nest depth
typedef int (*Fp_GetNestLevel)();

// Add log information to SPSSDX
// para msg, null-terminated log message
typedef void (*Fp_Trace)(const char* msg);

// Get one line syntax/script, which come from callback function Fp_SetSyntax
// para buf, buffer for return syntax
// para len, buf size
// return 0 for success
typedef int (*Fp_GetSyntaxLine)(char *buf, int len);

// Put syntax/script to SPSSDX
// para buf, null-terminated syntax/script, '\n' is uesed for line separator
// return 0 for success
typedef int (*Fp_SetSyntax)(const char *buf);

// Start a Console
// return 0 for success
typedef int (*Fp_StartConsole)();

// Stop the Console created by Fp_StartConsole
// return 0 for success
typedef int (*Fp_StopConsole)();

// Write message to the Console created by Fp_StartConsole
// para buf, message 
// para len, message length
// return 0 for success
typedef int (*Fp_WriteToConsole)(const char* buf, int len);

// Read message from the Console created by Fp_StartConsole
// para buf, message 
// para len, message length
// return 0 for success
typedef int (*Fp_ReadFromConsole)(char* buf, int len);

// Convert code page string to utf8 string
typedef int   (*FP_ConvertCp2UTF8)(const char*, size_t, char*, size_t);
// Record browser output
// para buf, message for record
// para len, message length
// para fp_ConvertCp2UTF8, convert function
typedef void (*Fp_RecordBrowserOutput)(const char * buf, size_t len, FP_ConvertCp2UTF8 fp_ConvertCp2UTF8);

//Redirect the output.
// par text, message
// par length, message length
typedef int (*Fp_PostSpssOutput)(const char* text, int length);

//Increase nest layer 
typedef void (*Fp_IncreaseNestLayer)();

//Decrease nest layer
typedef void (*Fp_DecreaseNestLayer)();

#ifdef __cplusplus
}
#endif

typedef struct {
    Fp_AppMode              AppMode;
    Fp_IsUTF8mode           IsUTF8mode;
    Fp_GetDXVersion         GetDXVersion;
    Fp_GetDXTempDir         GetDXTempDir;
    Fp_GetNestLevel         GetNestLevel;
    Fp_Trace                Trace;
    Fp_GetSyntaxLine        GetSyntaxLine;
    Fp_SetSyntax            SetSyntax;
    Fp_StartConsole         StartConsole;
    Fp_StopConsole          StopConsole;
    Fp_WriteToConsole       WriteToConsole;
    Fp_ReadFromConsole      ReadFromConsole;
    Fp_RecordBrowserOutput  RecordBrowserOutput;
    Fp_PostSpssOutput       PostSpssOutput;
    Fp_IncreaseNestLayer    IncreaseNestLayer;
    Fp_DecreaseNestLayer    DecreaseNestLayer;

} DXCallBack, *DXCallBackHandle;


#endif
