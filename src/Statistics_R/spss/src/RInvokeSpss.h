/************************************************************************
** IBM® SPSS® Statistics - Essentials for R
** (c) Copyright IBM Corp. 1989, 2014
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

/**
 * NAME
 *
 * DESCRIPTION
 *
 * REVISIONS
 *--------------------------------------------------------
 *
 * Copyright (c) 2008 SPSS Inc. All rights reserved.
 */


#ifndef _RINVOKESPSS_H
#define _RINVOKESPSS_H

#ifdef MS_WINDOWS
  #ifdef RINVOKESPSS_EXPORTS
  #define RINVOKESPSS_API __declspec(dllexport)
  #else
  #define RINVOKESPSS_API __declspec(dllimport)
  #endif
#else
  #define RINVOKESPSS_API
#endif

#include <wchar.h>
#include <Rdefines.h>



extern "C" {
 #include <R_ext/Rdynload.h>

  
  /**
   * C routine for R call.
   * It calls "PostOutput()".
   *
   * @param text The text to post to SPSS output.
   * @param length The length of text.
   * @param errLevel: error level.
   */
  RINVOKESPSS_API void ext_PostOutput(const char **text, int *length, int *errLevel);
                                      
  RINVOKESPSS_API void ext_StartProcedure(const char** procName, const char** omsIdentifier, int* errLevel);
  RINVOKESPSS_API void ext_EndProcedure(int* errLevel);
  RINVOKESPSS_API void ext_HasProcedure(int* errLevel);
  
  RINVOKESPSS_API void ext_AddCellFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** dimName,
                                 int * place,
                                 int * position,
                                 int * hideName,
                                 int * hideLabels,
                                 const char** footnoots,
                                 int * errLevel);
                                 
  RINVOKESPSS_API void ext_AddOutlineFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** footnoots,
                                 int * errLevel);

  RINVOKESPSS_API void ext_AddTitleFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** footnoots,
                                 int * errLevel);
  
  RINVOKESPSS_API void ext_AddDimFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** dimName,
                                 int * place,
                                 int * position,
                                 int * hideName,
                                 int * hideLabels,
                                 const char** footnoots,
                                 int * errLevel);
                                 
  RINVOKESPSS_API void ext_AddCategoryFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** dimName,
                                 int * place,
                                 int * position,
                                 int * hideName,
                                 int * hideLabels,
                                 const char** footnoots,
                                 int * errLevel);

  RINVOKESPSS_API void ext_HidePivotTableTitle(const char** outline,
                                   const char** tableName,
                                   const char** templateName,
                                   int * isSplit,
                                   int * errLevel);
                                   
  RINVOKESPSS_API void ext_AddTextBlock(const char** name, const char** content, const char** outline, int* skip, int* errLevel);
  RINVOKESPSS_API void ext_SplitChange(const char** procName, int* errLevel);
  RINVOKESPSS_API void ext_IsEndSplit(int* endSplit, int* errLevel);
  
  RINVOKESPSS_API void ext_GetSpssOutputWidth(int* outputWidth, int* errLevel);
  //RINVOKESPSS_API int ext_GetSpssOutputWidth(int* errLevel);
  
  RINVOKESPSS_API void ext_MakeCaseCursor(const char** accessType, int* errLevel);
  RINVOKESPSS_API void ext_HasCursor(int* hasCursor, int* errLevel);
  RINVOKESPSS_API void ext_GetCursorPosition(int* cursorPosition, int* errLevel);
  RINVOKESPSS_API void ext_RemoveCaseCursor(int* errLevel);
  RINVOKESPSS_API void ext_NextCase(int* errLevel);
  RINVOKESPSS_API void ext_GetNumericValue(int* varIndex, double* result, int* isMissing, int* errLevel);
  RINVOKESPSS_API void ext_GetStringValue(int* varIndex, char** result, 
                                          int* bufferLength, int* isMissing, int* errLevel);
  RINVOKESPSS_API void ext_GetSystemMissingValue(double *sysMissing, int* errLevel);
  
  RINVOKESPSS_API SEXP ext_GetDataFromSPSS(SEXP variables, SEXP nCases, SEXP bKeepUserMissing, SEXP bMissingValueToNA, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetSplitDataFromSPSS(SEXP procName,SEXP variables, SEXP bKeepUserMissing, SEXP bMissingValueToNA, SEXP rIsSkipOver, SEXP errLevel);

  RINVOKESPSS_API void ext_GetVarNMissingValues(
                        int* varIndex, int* missingFormat, double* v1, double* v2, double* v3,int* errLevel);
  RINVOKESPSS_API void ext_GetVarCMissingValues(
                        int* varIndex, int* missingFormat,char** v1, char** v2, char** v3,int* errLevel);
  RINVOKESPSS_API SEXP ext_GetNValueLabels(SEXP index, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetCValueLabels(SEXP index, SEXP errLevel);

  RINVOKESPSS_API void ext_GetVariableFormatType(int* varIndex, int* formatType, 
                                          int* formatWidth, int* formatDecimal, int* errLevel);

  //for quickly retrieve information of lots of variables.                                        
  RINVOKESPSS_API SEXP ext_GetVarNames(SEXP variables, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetVarTypes(SEXP variables, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetVarLabels(SEXP variables, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetVarMeasurementLevels(SEXP variables, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetVarFormats(SEXP variables, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetVarFormatTypes(SEXP variables, SEXP errLevel);

  RINVOKESPSS_API void ext_GetCaseCount(int* caseNum, int* errLevel);
  RINVOKESPSS_API void ext_GetVariableCount(int* varNum, int* errLevel);
  RINVOKESPSS_API void ext_GetVariableName(const char** name, int* index, int* errLevel);
  RINVOKESPSS_API void ext_GetVariableLabel(const char** label, int* index, int* errLevel);
  RINVOKESPSS_API void ext_GetVariableType(int* type, int* index, int* errLevel);
  RINVOKESPSS_API void ext_GetVariableFormat(const char** format, int* index, int* errLevel);
  RINVOKESPSS_API void ext_GetVariableMeasurementLevel(int* measurementLevel, int* index, int* errLevel);

  RINVOKESPSS_API void ext_GetWeightVar(char** weightVar, int* errLevel);
  RINVOKESPSS_API void ext_SetRTempFolderToSPSS(char** tmpdir, int* errLevel);
  RINVOKESPSS_API SEXP ext_GetVarAttributeNames(SEXP varIndex, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetVarAttributes(SEXP varIndex, SEXP attrName, SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetDataFileAttributeNames(SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetDataFileAttributes(SEXP attrName, SEXP errLevel);

  RINVOKESPSS_API SEXP ext_GetSplitVariableNames(SEXP errLevel);

  RINVOKESPSS_API SEXP ext_SetVarNameAndType(SEXP varNames, SEXP varTypes, SEXP errLevel);
  RINVOKESPSS_API void ext_AllocNewVarsBuffer(int* size, int* errLevel);
  RINVOKESPSS_API void ext_CommitHeader(int* errLevel);


  RINVOKESPSS_API void ext_CreateXPathDictionary(const char** handle, int* errLevel);
  RINVOKESPSS_API void ext_RemoveXPathHandle(const char** handle, int* errLevel);
  RINVOKESPSS_API SEXP ext_GetHandleList(SEXP errLevel);
  RINVOKESPSS_API SEXP ext_EvaluateXPath(SEXP handle, SEXP context, SEXP xpath, SEXP errLevel);


  RINVOKESPSS_API void ext_StartDataStep( int* errLevel);
  RINVOKESPSS_API void ext_EndDataStep( int* errLevel);
  RINVOKESPSS_API void ext_CreateDataset(const char** name, int *isEmpty, int *hidden,int* errLevel);
  RINVOKESPSS_API void ext_CloseDataset(const char** name, int* errLevel);

  RINVOKESPSS_API SEXP ext_GetSpssDatasets( SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetOpenedSpssDatasets( SEXP errLevel);
  RINVOKESPSS_API void ext_InsertVariable(const char** dsName, const int* index,
                                          const char** varName, const int* type, int* errLevel);
  RINVOKESPSS_API void ext_SetVarLabelInDS(const char** dsName, const int* index, 
                                           const char** varLabel, int* errLevel);
  RINVOKESPSS_API void ext_SetVarFormatInDS(const char** dsName,
                                            const int* index,
                                            const int* formatType,
                                            const int* formatWidth,
                                            const int* formatDecimal,
                                            int* errLevel);
  RINVOKESPSS_API void ext_SetVarMeasurementLevelInDS(const char** dsName, const int* index, 
                                                      const char** varMeasurement, int* errLevel);
  RINVOKESPSS_API void ext_SetVarNMissingValuesInDS(const char** dsName,
                                                    const int* index,
                                                    const int* missingFormat,
                                                    const double* missingValue1,
                                                    const double* missingValue2,
                                                    const double* missingValue3,
                                                    int* errLevel);
  RINVOKESPSS_API void ext_SetVarCMissingValuesInDS(const char** dsName,
                                                    const int* index,
                                                    const int* missingFormat,
                                                    const char** missingValue1,
                                                    const char** missingValue2,
                                                    const char** missingValue3,
                                                    int* errLevel);
  RINVOKESPSS_API SEXP ext_SetVarAttributesInDS(SEXP dsName,
                                                SEXP index,
                                                SEXP attrName,
                                                SEXP attributes,
                                                SEXP length,
                                                SEXP errLevel);

  RINVOKESPSS_API SEXP ext_SetDataFileAttributesInDS(SEXP dsName,
                                                SEXP attrName,
                                                SEXP attributes,
                                                SEXP length,
                                                SEXP errLevel);


  RINVOKESPSS_API void ext_SetVarNValueLabelInDS(const char** dsName,
                                                 const int* index,
                                                 const double* value,
                                                 const char** label,
                                                 int* errLevel);
  RINVOKESPSS_API void ext_SetVarCValueLabelInDS(const char** dsName,
                                                 const int* index,
                                                 const char** value,
                                                 const char** label,
                                                 int* errLevel);
  RINVOKESPSS_API void ext_InsertCase(const char** dsName,const long* rowIndex, int* errLevel);
  RINVOKESPSS_API void ext_SetNCellValue(const char** dsName,
                                         const long* rowIndex,
                                         const int* columnIndex,
                                         const double* value,
                                         int* errLevel);
  RINVOKESPSS_API void ext_SetCCellValue(const char** dsName,
                                         const long* rowIndex,
                                         const int* columnIndex,
                                         const char** value,
                                         int* errLevel);

  RINVOKESPSS_API SEXP ext_SetDataToSPSS(SEXP dsName, SEXP data, SEXP errLevel);
  RINVOKESPSS_API void ext_SetActive( const char** dsName, int* errLevel);


//===================APIs for pivot table=======================

 RINVOKESPSS_API void ext_StartPivotTable(const char** outline,
                                           const char** title,
                                           const char** templateTitle,
                                           int* isSplit,
                                           int* errLevel);  

RINVOKESPSS_API void ext_PivotTableCaption(const char** outline, 
                                             const char** title,
                                             const char** templateName, 
                                             int* isSplit,
                                             const char** caption, 
                                             int* errLevel);

  RINVOKESPSS_API void ext_AddDimension(const char** outline, 
                                        const char** title, 
                                        const char** templateName,
                                        int* isSplit,
                                        const char** dimName,
                                        int* place,
                                        int* position,
                                        int* hideName,
                                        int* hideLabels,
                                        int* errLevel);

  RINVOKESPSS_API void ext_MinDataColumnWidth(const char **outline, 
                                              const char **title, 
                                              const char **templateName,
                                              int *isSplit,
                                              int *nMinInPoints,
                                              int* errLevel);

  RINVOKESPSS_API void ext_MaxDataColumnWidth(const char **outline, 
                                              const char **title, 
                                              const char **templateName,
                                              int *isSplit,
                                              int *nMaxInPoints,
                                              int* errLevel);

  RINVOKESPSS_API void ext_AddNumberCategory(const char** outline, 
                                             const char** title, 
                                             const char** templateName,
                                             int* isSplit,
                                             const char** dimName,
                                             int* place,
                                             int* position,
                                             int* hideName,
                                             int* hideLabels,
                                             double* category ,
                                             int* errLevel);

  RINVOKESPSS_API void ext_AddStringCategory(const char** outline, 
                                             const char** title, 
                                             const char** templateName,
                                             int* isSplit,
                                             const char** dimName,
                                             int* place,
                                             int* position,
                                             int* hideName,
                                             int* hideLabels,
                                             const char** category, 
                                             int* errLevel);
   RINVOKESPSS_API void ext_AddVarNameCategory(const char** outline, 
                                 const char** title, 
                                 const char** templateName,
                                 int* isSplit,
                                 const char** dimName,
                                 int* place,
                                 int* position,
                                 int* hideName,
                                 int* hideLabels,
                                 int* category, 
                                 int* errLevel);
 
    RINVOKESPSS_API void ext_AddVarValueStringCategory(const char** outline, 
                                 const char** title, 
                                 const char** templateName,
                                 int* isSplit,
                                 const char** dimName,
                                 int* place,
                                 int* position,
                                 int* hideName,
                                 int* hideLabels,
                                 int* category, 
                                 const char** ch,
                                 int* errLevel);
    
    RINVOKESPSS_API void ext_AddVarValueDoubleCategory(const char** outline, 
                                 const char** title, 
                                 const char** templateName,
                                 int* isSplit,
                                 const char** dimName,
                                 int* place,
                                 int* position,
                                 int* hideName,
                                 int* hideLabels,
                                 int* category, 
                                 double * d,
                                 int* errLevel);

    RINVOKESPSS_API void ext_SetVarNameCell(const char** outline, 
                            const char** title, 
                            const char** templateName,
                            int* isSplit,
                            const char** dimName,
                            int* place,
                            int* position,
                            int* hideName,
                            int* hideLabels,
                            int* cell,
                            int* errLevel); 
    
    RINVOKESPSS_API void ext_SetVarValueStringCell(const char** outline, 
                            const char** title, 
                            const char** templateName,
                            int* isSplit,
                            const char** dimName,
                            int* place,
                            int* position,
                            int* hideName,
                            int* hideLabels,
                            int* cell,
                            const char** ch,
                            int* errLevel);     
     
    RINVOKESPSS_API void ext_SetVarValueDoubleCell(const char** outline, 
                            const char** title, 
                            const char** templateName,
                            int* isSplit,
                            const char** dimName,
                            int* place,
                            int* position,
                            int* hideName,
                            int* hideLabels,
                            int* cell,
                            double* d,
                            int* errLevel);    
    
  RINVOKESPSS_API void ext_SetNumberCell( const char** outline, 
                                          const char** title, 
                                          const char** templateName,
                                          int* isSplit,
                                          const char** dimName,
                                          int* place,
                                          int* position,
                                          int* hideName,
                                          int* hideLabels,
                                          double* cellVal,
                                          int* errLevel);

  RINVOKESPSS_API void ext_SetStringCell( const char** outline, 
                                          const char** title, 
                                          const char** templateName,
                                          int* isSplit,
                                          const char** dimName,
                                          int* place,
                                          int* position,
                                          int* hideName,
                                          int* hideLabels,
                                          const char** cellVal,
                                          int* errLevel);

  RINVOKESPSS_API void ext_SetFormatSpecCoefficient(int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecCoefficientSE( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecCoefficientVar( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecCorrelation( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecGeneralStat( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecMean(int* varIndex, int* errLevel);  
  RINVOKESPSS_API void ext_SetFormatSpecCount( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecPercent( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecPercentNoSign( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecProportion( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecSignificance( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecResidual( int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecVariable(int* varIndex, int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecStdDev(int* varIndex, int* errLevel); 
  RINVOKESPSS_API void ext_SetFormatSpecDifference(int* varIndex, int* errLevel);
  RINVOKESPSS_API void ext_SetFormatSpecSum(int* varIndex, int* errLevel);  


//===================APIs for multiple response set=========================
  RINVOKESPSS_API SEXP ext_GetMultiResponseSetNames(SEXP errLevel);
  RINVOKESPSS_API SEXP ext_GetMultiResponseSet(SEXP mrsetName,SEXP errlvl);
  RINVOKESPSS_API SEXP ext_SetMultiResponseSetInDS(SEXP datasetName, 
                                         SEXP mrsetName,
                                         SEXP mrsetLabel,
                                         SEXP mrsetCodeAs,
                                         SEXP mrsetCountedValue,
                                         SEXP elemVarNames,
                                         SEXP errlvl);

  RINVOKESPSS_API void ext_IsUTF8mode(int *mode);
  RINVOKESPSS_API void ext_GetVarCountInDS(const char **dsName, int *varCount, int *errLevel);
  RINVOKESPSS_API void ext_GetVarTypeInDS(const char **dsName, const int *index, int *varType, int* errLevel);
  RINVOKESPSS_API void ext_GetVarNameInDS(const char **dsName, const int *index, const char **varName, int* errLevel);
  

//===================APIs for R graph=======================
  RINVOKESPSS_API void ext_GetGraphic(const char **fileName, int *errLevel);

//===================APIs for R locale=======================
RINVOKESPSS_API void ext_GetSPSSLocale(char** localeVar, int* errLevel);
RINVOKESPSS_API void ext_GetCLocale(char** localeVar, int* errLevel);
RINVOKESPSS_API void ext_SetCLocale(int* errLevel);
RINVOKESPSS_API void ext_GetOutputLanguage(const char** olang, int* errLevel);
RINVOKESPSS_API void ext_SetOutputLanguage(const char ** lang, int* errLevel);
                                                        

//===================new APIs in 18.0=======================
RINVOKESPSS_API SEXP ext_GetFileHandles( SEXP errLevel);
RINVOKESPSS_API void ext_SetDateCell( const char** outline, 
                                      const char** title, 
                                      const char** templateName,
                                      int* isSplit,
                                      const char** dimName,
                                      int* place,
                                      int* position,
                                      int* hideName,
                                      int* hideLabels,
                                      const char** cellVal,
                                      int* errLevel);
RINVOKESPSS_API void ext_SetRecordBrowserOutput( const char** ,int*,int* );
RINVOKESPSS_API void ext_TransCode(const char** dest, const char** orig, int* errLevel);  
RINVOKESPSS_API void ext_SetGraphicsLabel(const char** displaylabel, const char** invariantdisplaylabel, int* errLevel);

//===================new APIs in 23.0=======================
RINVOKESPSS_API void ext_StartSpss(const char** commandline, int* errLevel);
RINVOKESPSS_API void ext_StopSpss(int* errLevel);
RINVOKESPSS_API void ext_Submit(const char** command, int* length, int* errLevel);
RINVOKESPSS_API void ext_QueueCommandPart(const char** command, int* length, int* errLevel);
RINVOKESPSS_API void ext_IsBackendReady(int* isReady);
RINVOKESPSS_API void ext_IsXDriven(int* isXdrive);



//===================R initialize=========================

  /*
   * This routine will be invoked when R loads the shared InvokeSPSS DLL.
   * It registers InvokeSPSS DLL with R.
   */
   RINVOKESPSS_API void R_init_RInvokeSPSS(DllInfo *info);
  
  /*
   * This routine will be invoked when R unloads the shared InvokeSPSS DLL.
   */
  RINVOKESPSS_API void R_unload_RInvokeSPSS(DllInfo *info);
  
}

#endif
