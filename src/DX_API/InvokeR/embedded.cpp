/************************************************************************
** IBM?SPSS?Statistics - Essentials for R
** (c) Copyright IBM Corp. 1989, 2015
** 
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License version 2 as published by
** the Free Software Foundation.
** 
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
** 
** You should have received a copy of the GNU General Public License version 2
** along with this program; if not, write to the Free Software
** Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA.
************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif


#ifdef MS_WINDOWS
    #define WIN32_LEAN_AND_MEAN 1
    #define	SIGBREAK 21
    #define Win32 1
    #include <windows.h>		
    #include <process.h> 
#else
    #include "IBM_SPSS_Copyright.h"
#endif

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <wchar.h>

#include <Rembedded.h>
#include <Riconv.h>

/* for askok and askyesnocancel */
#ifdef MS_WINDOWS       
    #include <Rversion.h>
    #include <R_ext/RStartup.h>
    #include "ga.h"
#else
    #define CSTACK_DEFNS
    #include <Rinterface.h>
    #include <eventloop.h>
    #include <Rinterface.h>
#endif

#include "dxcallback.h"

#ifdef LINUX
    #ifdef HAVE_LIBC_STACK_END
        extern void *__libc_stack_end;
        void *stack_end_bak;
    #endif
#endif

#ifdef MACOSX
extern unsigned long R_CStackStart;
extern unsigned long R_CStackLimit;
#endif

#ifdef _WINDOWS
  #ifdef STATR_EXPORTS
  #define DLL_API __declspec(dllexport) 
  #else
  #define DLL_API __declspec(dllimport)
  #endif

#else
  #define DLL_API
#endif

# define PrintWarnings		Rf_PrintWarnings
extern Rboolean             AllDevicesKilled;
/* one way to allow user interrupts: called in ProcessEvents */
extern int                  UserBreak;
//__declspec(dllimport) extern int R_CollectWarnings;
/* calls into the R DLL */
#ifdef MS_WINDOWS
extern size_t Rf_utf8towcs(wchar_t *wc, const char *s, size_t n);
#endif
extern char *getDLLVersion(), *getRUser(), *get_R_HOME();
extern void R_DefParams(Rstart), R_SetParams(Rstart), R_setStartTime();
extern void ProcessEvents(void);
extern int R_ReplDLLdo1();
extern void mainloop(void);

extern int  (*ptr_R_ReadConsole)(const char *, unsigned char *, int, int);
extern void (*ptr_R_WriteConsole)(const char *, int);
extern void (*ptr_R_ResetConsole)(void);
extern void (*ptr_R_FlushConsole)(void);
extern void (*ptr_R_ClearerrConsole)(void);


static DXCallBackHandle DxHandle = 0;
static int DxRunning = 0;
// below are DX call back function

int SPSS_AppMode()
{
    assert(DxHandle);
    return DxHandle->AppMode();
}

int SPSS_IsUTF8mode()
{
    assert(DxHandle);
    return DxRunning ? DxHandle->IsUTF8mode() : 0;
}

void SPSS_Trace(const char* msg)
{
    assert(DxHandle);
    DxHandle->Trace(msg);
}

int SPSS_GetSyntaxLine(char *buf, int len)
{
    assert(DxHandle);
    return DxHandle->GetSyntaxLine(buf, len);
}

int SPSS_SetSyntax(const char *buf)
{
    assert(DxHandle);
    return DxHandle->SetSyntax(buf);
}

int SPSS_StartConsole()
{
    assert(DxHandle);
    return DxHandle->StartConsole();
}

int SPSS_StopConsole()
{
    assert(DxHandle);
    return DxHandle->StopConsole();
}

int SPSS_WriteToConsole(const char* buf, int len)
{
    assert(DxHandle);
    return DxHandle->WriteToConsole(buf, len);
}

int SPSS_ReadFromConsole(char* buf, int len)
{
    assert(DxHandle);
    return DxHandle->ReadFromConsole(buf, len);
}

void SPSS_RecordBrowserOutput(const char * buf, size_t len, FP_ConvertCp2UTF8 fp_ConvertCp2UTF8)
{
    assert(DxHandle);
    if(DxRunning)
        DxHandle->RecordBrowserOutput(buf, len, fp_ConvertCp2UTF8);
}

int SPSS_PostSpssOutput(const char* text, int length) 
{
    assert(DxHandle);
    return DxHandle->PostSpssOutput(text, length);
}

int SPSS_GetNestLevel()
{
    assert(DxHandle);
    return DxHandle->GetNestLevel();
}

void SPSS_IncreaseNestLayer()
{
    assert(DxHandle);
    DxHandle->IncreaseNestLayer();
}

void SPSS_DecreaseNestLayer()
{
    assert(DxHandle);
    DxHandle->DecreaseNestLayer();
}


int    isBrowse = 0;
int    currBrowseMode = 0;
const  int dataLen = 1024;
char   *browserOutputText = 0;
static const char *tprompt;
#ifdef MS_WINDOWS
char UTF8in[4] = "\002\377\376", UTF8out[4] = "\003\377\376";
static DWORD mainThreadId;
HANDLE ReadWakeup;
static char *tbuf;
static  int tlen, thist, rLineCatch;

static size_t enctowcs(wchar_t *wc, char *s, int n)
{
    size_t nc = 0;
    char *pb, *pe;
    if((pb = strchr(s, UTF8in[0])) && *(pb+1) == UTF8in[1] &&
       *(pb+2) == UTF8in[2]) {
	//pb=s;
	*pb = '\0';
	nc += mbstowcs(wc, s, n);
	pb += 3; pe = pb;
	while(*pe &&
	      !((pe = strchr(pb, UTF8out[0])) && *(pe+1) == UTF8out[1] &&
	      *(pe+2) == UTF8out[2])) pe++;
	if(!*pe) return nc; /* FIXME */;
	*pe = '\0';
	/* convert string starting at pb from UTF-8 */
	nc += Rf_utf8towcs(wc+nc, pb, (pe-pb));
	pe += 3;
	nc += enctowcs(wc+nc, pe, n-nc);
    } else nc = mbstowcs(wc, s, n);
    return nc;
}
#endif

#ifdef MS_WINDOWS

static int appReadConsole(const char *prompt, char *buf, int len, int addtohistory)
{
    char sinkSyntax[256];
	int  errLevel = 0;
    char *tempBuf;    
    char data[1024];
	size_t bufSize = 0;
	char tmpbuf[1024];
	int i,result;
	char* tmppointer;

    memset(sinkSyntax,'\0',256);
    memset(tmpbuf,'\0',1024);
	memset(buf,'\0',len); 
	if(strcmp("Browse[1]> ",prompt) == 0 || strcmp("Browse[2]> ",prompt) == 0)
	{
	    if(!isBrowse) 
        {
            strcpy(sinkSyntax,"SetOutputFromBrowser(\"ON\")\n");        
        }
	    isBrowse = 1;
	    currBrowseMode = 1;                
	}
	//else if(strcmp("Selection: ",prompt) == 0)
    //{
        //buf[0] = '4';
        //return 1;
    //}
		    
	if(isBrowse && currBrowseMode)
	{   	        
        if(strcmp("> ",prompt) == 0)
        {
            currBrowseMode = 0;
            errLevel = SPSS_GetSyntaxLine((char*)buf,len);

			if(SPSS_IsUTF8mode())
			{
				bufSize = strlen(buf);
				/* max no of chars */
				strcpy(tmpbuf, UTF8in); strcat(tmpbuf, buf); strcat(tmpbuf, UTF8out);
				enctowcs(buf, tmpbuf, strlen(tmpbuf) + 1);
				tmppointer = tmpbuf;
				for(i = 0; i < wcslen(buf); i++)
				{
					if(((wchar_t*)buf)[i]>=0 && ((wchar_t*)buf)[i]<128)
					{
						sprintf(tmppointer,"%c\0",((wchar_t*)buf)[i]);
					}
					else //non ascii code
					{
						sprintf(tmppointer,"\\u%04x\0",((wchar_t*)buf)[i]);
					}
					tmppointer = tmpbuf+strlen((char*)tmpbuf);
				}
				strcpy(buf, tmpbuf);
			}

            if(errLevel == 0)
            {
                return 1;			    
            }			
            else
            {
                return 0;
            }	
        }
        else
        {
            if(1 == SPSS_AppMode())
            {
                SPSS_WriteToConsole(prompt, strlen(prompt));	
                memset(data,'\0',dataLen);
                result = SPSS_ReadFromConsole(data, dataLen);               
                
                if(strlen(data) == 0 && result > 0)
                {
                    memset(buf,'\0',len);
                    isBrowse = 0;
                    buf[0] = 'c'; 
                    buf[1] = '\n';
                    buf[2] = '\0';
                }
                else
                {
                    //std::string tempCmd = TrimSpace(data);
                    memset(buf,'\0',len);
                    strcpy((char*)buf,sinkSyntax);
                    tempBuf = (char*)buf;
                    tempBuf += strlen(sinkSyntax);
                    strcpy(tempBuf,data);		        
                    buf[strlen((char*)buf)] = '\n';		        		   
                }
            }
            else
            {   
                //for statistics server, don't start Browser.
                //just continue to run
                buf[0] = 'c'; 
                buf[1] = '\n';
                buf[2] = '\0';
				isBrowse = 0;
				currBrowseMode = 0;
            }
        }
		return 1;	
	}
	else
	{
		errLevel = SPSS_GetSyntaxLine((char*)buf,len);

        //SPSS_Trace(buf);
		if(SPSS_IsUTF8mode())
		{
			bufSize = strlen(buf);
			/* max no of chars */
			strcpy(tmpbuf, UTF8in); strcat(tmpbuf, buf); strcat(tmpbuf, UTF8out);
			enctowcs(buf, tmpbuf, strlen(tmpbuf) + 1);
			tmppointer = tmpbuf;
			for(i = 0; i < wcslen(buf); i++)
			{
				if(((wchar_t*)buf)[i]>=0 && ((wchar_t*)buf)[i]<128)
				{
					sprintf(tmppointer,"%c\0",((wchar_t*)buf)[i]);
				}
				else //non ascii code
				{
					sprintf(tmppointer,"\\u%04x\0",((wchar_t*)buf)[i]);
				}
				tmppointer = tmpbuf+strlen((char*)tmpbuf);
			}
			strcpy(buf, tmpbuf);
		}

	    //char bufSize = 0;
		if(errLevel == 0)
        {
            
            if(buf[0] == 26) //EOFKEY
            {
                return 0;
            }
            else
            {
                return 1;			    
            }
            
            return 1;
        }			
        else
        {
            return 0;
        }			
    }
}

static void myReaderThread(void *unused)
{
    while(1) {
	    WaitForSingleObject(ReadWakeup,INFINITE);
	    tlen = appReadConsole(tprompt,tbuf,tlen,thist);
	    rLineCatch = 1;
	    PostThreadMessage(mainThreadId, 0, 0, 0);
    }
}

static int myReadConsole_X(const char *prompt, char *buf, int len, int addtohistory)
{
    mainThreadId = GetCurrentThreadId();
    rLineCatch = 0;
    tprompt = prompt;
    tbuf = buf;
    tlen = len;
    thist = addtohistory;
    SetEvent(ReadWakeup);
    while (1) {
	    if ( !peekevent() ) 
            WaitMessage();

	    if ( rLineCatch ) 
            break;

	    doevent();
    }
    rLineCatch = 0;

    return tlen;
}

#else
int myReadConsole_X(const char *prompt, unsigned char *buf, int len, int addtohistory)
{
    char sinkSyntax[256];
    int  errLevel = 0;
    char *tempBuf;    
    char data[1024];
    size_t bufSize = 0;
    char tmpbuf[1024];
    int i,result;
    char* tmppointer;
    tprompt = prompt;

    memset(sinkSyntax,'\0',256);
    memset(tmpbuf,'\0',1024);
    memset(buf,'\0',len); 
    if(strcmp("Browse[1]> ",prompt) == 0 || strcmp("Browse[2]> ",prompt) == 0)
    {
        if(!isBrowse) 
        {
            strcpy(sinkSyntax,"SetOutputFromBrowser(\"ON\")\n");        
        }
        isBrowse = 1;
        currBrowseMode = 1;                
    }
    //else if(strcmp("Selection: ",prompt) == 0)
    //{
        //buf[0] = '4';
        //return 1;
    //}
		    
    if(isBrowse && currBrowseMode)
    {   	        
        if(strcmp("> ",prompt) == 0)
        {
            currBrowseMode = 0;
            errLevel = SPSS_GetSyntaxLine((char*)buf,len);
             
            if(errLevel == 0)
            {
                return 1;			    
            }			
            else
            {
                return 0;
            }	
        }
        else
        {
            if(1 == SPSS_AppMode())
            {
                SPSS_WriteToConsole(prompt, strlen(prompt));	
                memset(data,'\0',dataLen);
                result = SPSS_ReadFromConsole(data, dataLen);               
                
                if(strlen(data) == 0 && result > 0)
                {
                    memset(buf,'\0',len);
                    isBrowse = 0;
                    buf[0] = 'c'; 
                    buf[1] = '\n';
                    buf[2] = '\0';
                }
                else
                {
                    //std::string tempCmd = TrimSpace(data);
                    memset(buf,'\0',len);
                    strcpy((char*)buf,sinkSyntax);
                    tempBuf = (char*)buf;
                    tempBuf += strlen(sinkSyntax);
                    strcpy(tempBuf,data);		        
                    buf[strlen((char*)buf)] = '\n';		        		   
                }
            }
            else
            {   
                //for statistics server, don't start Browser.
                //just continue to run
                buf[0] = 'c'; 
                buf[1] = '\n';
                buf[2] = '\0';
                isBrowse = 0;
                currBrowseMode = 0;
            }
        }
        return 1;	
    }
    else
    {
        errLevel = SPSS_GetSyntaxLine((char*)buf,len);

	    //char bufSize = 0;
        if(errLevel == 0)
        {
            
            if(buf[0] == 26) //EOFKEY
            {
                return 0;
            }
            else
            {
                return 1;			    
            }
            
            return 1;
        }			
        else
        {
            return 0;
        }			
    }
}
#endif


int ConvertCp2UTF8(const char *inBuf, size_t inBufLen, char *outBuf, size_t outBufLen)
{
    void *obj;
    int  res;
//#ifdef MS_WINDOWS
    obj = Riconv_open("UTF-8", ""); /* (to, from) */
    res = Riconv(obj, &inBuf , &inBufLen, &outBuf, &outBufLen);    
    Riconv_close(obj);						            
//#endif
    return res;
}

static void myWriteConsole_X(const char *buf, int len)
{		
    if(buf == 0 || len == 0)
    {
        SPSS_Trace("NULL");
        return ;
    }
    SPSS_Trace(buf);
    if(isBrowse)
    {   
        SPSS_WriteToConsole(buf,len);
        //myWriteStdOut(buf,len);	
    }
    SPSS_RecordBrowserOutput(buf,(size_t)len,ConvertCp2UTF8);
//    if(myRecordBrowserOutput)
//    {
////#ifdef MS_WINDOWS
//        myRecordBrowserOutput(buf,(size_t)len,ConvertCp2UTF8);
////#else
//        //myRecordBrowserOutput(buf,(size_t)len,NULL);
////#endif
//    }    			
}

static void myCallBack()
{
    /* called during i/o, eval, graphics in ProcessEvents */
}

static void myBusy(int which)
{
    /* set a busy cursor ... if which = 1, unset if which = 0 */
}

static void my_onintr(int sig)
{
    //UserBreak = 1;
}

/* Indicate that input is coming from the console */
static void
myResetConsole (void)
{
}

/* Stdio support to ensure the console file buffer is flushed */
static void
myFlushConsole (void)
{
}


/* Reset stdin if the user types EOF on the console. */
static void
myClearerrConsole (void)
{
}


//extern Rboolean R_LoadRconsole;
#ifdef MS_WINDOWS
int Rf_initialize_R_X(int argc, char **argv)
{
    structRstart rp;
    Rstart Rp = &rp;
    char Rversion[25], *RHome;
    sprintf(Rversion, "%s.%s", R_MAJOR, R_MINOR);
    if(strncmp(getDLLVersion(), Rversion, 3) != 0) {
	    //printf("Error: R.DLL version does not match\n");
	    return 1;
    }

    R_setStartTime();
    R_DefParams(Rp);
    if((RHome = get_R_HOME()) == NULL) {
	    //printf("R_HOME must be set in the environment or Registry\n");
	    return 2;
    }
    Rp->rhome = RHome;
    Rp->home = getRUser();
    Rp->CharacterMode = LinkDLL;
    Rp->ReadConsole = myReadConsole_X;
    Rp->WriteConsole = myWriteConsole_X;
    Rp->CallBack = myCallBack;
    Rp->ShowMessage = askok;
    Rp->YesNoCancel = askyesnocancel;
    Rp->Busy = myBusy;

    Rp->R_Quiet = TRUE;
    Rp->R_Interactive = TRUE;
    Rp->RestoreAction = SA_RESTORE;
    Rp->SaveAction = SA_NOSAVE;
    R_SetParams(Rp);
    R_set_command_line_arguments(argc, argv);

    FlushConsoleInputBuffer(GetStdHandle(STD_INPUT_HANDLE));

    signal(SIGBREAK, my_onintr);
    GA_initapp(0, 0);
    readconsolecfg();

    if ( !(ReadWakeup = CreateEvent(NULL, FALSE, FALSE, NULL) ) ||
	    ( _beginthread(myReaderThread, 0, NULL) == -1) ) {
      //printf("impossible to create 'reader thread\n");
	    return 3;
    }

    return 0;
}
#endif


DLL_API void setup_dxcallback(void* dxhandle)
{
    DxHandle = (DXCallBackHandle)dxhandle;
}

DLL_API int Rf_initEmbeddedR_X(int argc, char **argv)
{
#ifdef MS_WINDOWS
    int errLevel = 0;
    errLevel = Rf_initialize_R_X(argc, argv);
    if(errLevel) 
    {
        return errLevel;
    }
    setup_Rmainloop();
    run_Rmainloop();
#else
    //char* av[] = {argv[0],"--silent","--no-save"};
    R_Interactive = (Rboolean)true;
    Rf_initialize_R(argc,argv);    
    ptr_R_ReadConsole = myReadConsole_X;
    ptr_R_WriteConsole = myWriteConsole_X;
    ptr_R_ResetConsole = myResetConsole;
    ptr_R_FlushConsole = myFlushConsole;
    ptr_R_ClearerrConsole = myClearerrConsole;
    R_Consolefile = NULL;
    R_Outputfile = NULL;   
    R_Interactive = (Rboolean)true;

#ifdef UNX_MACOSX 
    R_CStackLimit = (uintptr_t)-1;
#endif

#ifdef LINUX
    R_CStackLimit = (uintptr_t)-1;
#endif

    //setup_Rmainloop();
    Rf_mainloop();
#endif
    return(0);
}

/* use fatal !=0 for emergency bail out */
DLL_API void Rf_endEmbeddedR_X(int fatal)
{    
#ifdef MS_WINDOWS
    R_RunExitFinalizers();
    Rf_CleanEd();
    R_CleanTempDir();
    if(!fatal)
    {
	    Rf_KillAllDevices();
	    //AllDevicesKilled = TRUE;
    }
    //if(!fatal && R_CollectWarnings)
    {
	    PrintWarnings();	/* from device close and .Last */
	}
    app_cleanup();
#else
    Rf_endEmbeddedR(0);
#endif

}

DLL_API int init_embedded_x(int argc, char **argv)
{
    int errLevel = 0;
    DxRunning = 1;
    errLevel = Rf_initEmbeddedR_X(argc, argv);
    return errLevel;
}

DLL_API int  execute_x(char* cmd)
{
    if( cmd )
        SPSS_SetSyntax(cmd);
    return 0;
}

DLL_API int  stop_embedded_x()
{
    int errLevel = 0;
    //execute_x("quit(\"no\")");
    Rf_endEmbeddedR_X(0);
    return errLevel;
}

DLL_API int  pre_action()
{   
    int curnest = SPSS_GetNestLevel();
    if(0 == curnest)
    {
        DxRunning = 1;
        SPSS_SetSyntax("library(spss240)\nprespss()");
    }
    else
    {
        SPSS_IncreaseNestLayer();
    }
    
    return 0;
}

DLL_API int post_action()
{
    int curnest = SPSS_GetNestLevel();
    int res = 0;
    if(0 == curnest)
    {
        char post[128] = {0};
        if (strcmp("+ ",tprompt) == 0)
        {
            SPSS_PostSpssOutput("Error: unexpected end of input", 30);
            exit(0);
        }
        if(isBrowse)
            strcpy( post,"SetOutputFromBrowser(\"OFF\")\n");
        strcat(post, "postspss()\n");
        isBrowse = 0;
        res = execute_x(post);
        SPSS_StopConsole();
        // run a blank syntax that make sure all syntax has been submitted and runned.
        execute_x("\n");
        DxRunning = 0;
    }
    else
    {
        SPSS_DecreaseNestLayer();
    }
    
    return res;
}

#ifdef __cplusplus
}
#endif
