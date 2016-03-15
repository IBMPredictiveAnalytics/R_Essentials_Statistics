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
*
*--------------------------------------------------------
*/

//for debug only
#include <iostream>
#include <locale.h>
#ifdef MS_WINDOWS
  #include <windows.h>
#else
  #include <dlfcn.h>
  #include <stdlib.h>
  //#include <string.h>
#endif

#include "RInvokeSpss.h"
#include <assert.h>
#include <Rversion.h>

#ifdef MS_WINDOWS
  #define LIBHANDLE        HMODULE
  #define GETADDRESS       GetProcAddress
  #define LIBNAME          "spssxd_p.dll"
#else
  #define LIBHANDLE        void*
  #define GETADDRESS       dlsym
  #ifdef DARWIN
   #define LIBNAME         "libspssxd_p.dylib"
  #elif HPUX64
   #define LIBNAME         "libspssxd_p.sl"
  #else
   #define LIBNAME         "libspssxd_p.so"
  #endif
#endif

//It needs to be retested on Hp-Ux64.
//It should be removed after retest.
#ifdef HPUX64
  typedef const char* MY_CHAR;/*R version is and later than 2.6.0.*/
#else
  typedef char* MY_CHAR;/*R version is and earlier than 2.5.1.*/
#endif
//

#if R_VERSION < 0x2600
  typedef char* R_CHAR_STAR;
#else
  typedef const char* R_CHAR_STAR;
#endif

extern "C"{
    LIBHANDLE pLib = 0;
    const char libName[] = LIBNAME;

    const int LOAD_FAIL = 8011;
    const int LOAD_SUCCESS = 0;

    const int STRING_VARIABLE = 56;
    const int NUMERIC_VARIABLE = 57;

    // The types of arguments, required by .C function calling.
    static R_NativePrimitiveArgType PostOutputArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType StartProcedureArgs[3] = {STRSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType EndProcedureArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType HasProcedureArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType AddCellFootnotesArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType AddDimFootnotesArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType AddCategoryFootnotesArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType HidePivotTableTitleArgs[5] = {STRSXP,STRSXP,STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType AddOutlineFootnotesArgs[6] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType AddTitleFootnotesArgs[6] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP};    
    static R_NativePrimitiveArgType AddTextBlockArgs[5] = {STRSXP,STRSXP,STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType SplitChangeArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType IsEndSplitArgs[2] = {INTSXP,INTSXP};
    
    static R_NativePrimitiveArgType GetSpssOutputWidthArgs[2] = {INTSXP,INTSXP};
    //static R_NativePrimitiveArgType GetSpssOutputWidthArgs[1] = {INTSXP};
    
    static R_NativePrimitiveArgType MakeCaseCursorArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType HasCursorArgs[2] = {INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetCursorPositionArgs[2] = {INTSXP,INTSXP};
    static R_NativePrimitiveArgType RemoveCaseCursorArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType NextCaseArgs[1] = {INTSXP};

    static R_NativePrimitiveArgType GetSystemMissingValueArgs[2] = {REALSXP,INTSXP};
    static R_NativePrimitiveArgType GetNumericValueArgs[4] = {INTSXP,REALSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetStringValueArgs[5] = {INTSXP,STRSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVarNMissingValuesArgs[6] = {INTSXP,INTSXP,REALSXP,REALSXP,REALSXP,INTSXP};
    static R_NativePrimitiveArgType GetVarCMissingValuesArgs[6] = {INTSXP,INTSXP,STRSXP,STRSXP,STRSXP,INTSXP};

    static R_NativePrimitiveArgType AllocNewVarsBufferArgs[2] = {INTSXP,INTSXP};
    static R_NativePrimitiveArgType CommitHeaderArgs[1] = {INTSXP};

    static R_NativePrimitiveArgType GetVariableFormatTypeArgs[5] = {INTSXP,INTSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetCaseCountArgs[2] = {INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVariableCountArgs[2] = {INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVariableNameArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVariableLabelArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVariableTypeArgs[3] = {INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVariableFormatArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVariableMeasurementLevelArgs[3] = {INTSXP,INTSXP,INTSXP};

    static R_NativePrimitiveArgType GetWeightVarArgs[2] = {STRSXP,INTSXP};
	static R_NativePrimitiveArgType SetRTempFolderToSPSSArgs[2] = {STRSXP,INTSXP};


    static R_NativePrimitiveArgType CreateXPathDictionaryArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType RemoveXPathHandleArgs[2] = {STRSXP,INTSXP};


    static R_NativePrimitiveArgType StartDataStepArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType EndDataStepArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType CreateDatasetArgs[4] = {STRSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType CloseDatasetArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType InsertVariableArgs[5] = {STRSXP,INTSXP,STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarLabelInDSArgs[4] = {STRSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarFormatInDSArgs[6] = {STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarMeasurementLevelInDSArgs[4] = {STRSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarNMissingValuesInDSArgs[7] = {STRSXP,INTSXP,INTSXP,REALSXP,REALSXP,REALSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarCMissingValuesInDSArgs[7] = {STRSXP,INTSXP,INTSXP,STRSXP,STRSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarNValueLabelInDSArgs[5] = {STRSXP,INTSXP,REALSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarCValueLabelInDSArgs[5] = {STRSXP,INTSXP,STRSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType InsertCaseArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType SetNCellValueArgs[5] = {STRSXP,INTSXP,INTSXP,REALSXP,INTSXP};
    static R_NativePrimitiveArgType SetCCellValueArgs[5] = {STRSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetActiveArgs[2] = {STRSXP,INTSXP};

    static R_NativePrimitiveArgType GetVarTypeInDSArgs[4] = {STRSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType GetVarNameInDSArgs[4] = {STRSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType GetVarCountInDSArgs[3] = {STRSXP,INTSXP,INTSXP};

    static R_NativePrimitiveArgType IsUTF8modeArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType GetOutputLanguageArgs[2] = {STRSXP,INTSXP}; 

    static R_NativePrimitiveArgType StartPivotTableArgs[5] = {STRSXP,STRSXP,STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType PivotTableCaptionArgs[6] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType AddDimensionArgs[10] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType MinDataColumnWidthArgs[6] = {STRSXP,STRSXP,STRSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType MaxDataColumnWidthArgs[6] = {STRSXP,STRSXP,STRSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType AddNumberCategoryArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,REALSXP,INTSXP};
    static R_NativePrimitiveArgType AddStringCategoryArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType AddVarNameCategoryArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType AddVarValueStringCategoryArgs[12] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType AddVarValueDoubleCategoryArgs[12] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP,REALSXP,INTSXP};    
    static R_NativePrimitiveArgType SetNumberCellArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,REALSXP,INTSXP};
    static R_NativePrimitiveArgType SetStringCellArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarNameCellArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarValueStringCellArgs[12] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetVarValueDoubleCellArgs[12] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,INTSXP,REALSXP,INTSXP};    
    static R_NativePrimitiveArgType SetFormatSpecCoefficientArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecCoefficientSEArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecCoefficientVarArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecCorrelationArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecGeneralStatArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecMeanArgs[2] = {INTSXP,INTSXP};      
    static R_NativePrimitiveArgType SetFormatSpecCountArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecPercentArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecPercentNoSignArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecProportionArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecSignificanceArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecResidualArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetFormatSpecVariableArgs[2] = {INTSXP,INTSXP}; 
    static R_NativePrimitiveArgType SetFormatSpecStdDevArgs[2] = {INTSXP,INTSXP}; 
    static R_NativePrimitiveArgType SetFormatSpecDifferenceArgs[2] = {INTSXP,INTSXP}; 
    static R_NativePrimitiveArgType SetFormatSpecSumArgs[2] = {INTSXP,INTSXP};             
    
    static R_NativePrimitiveArgType GetGraphicArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType GetSPSSLocaleArgs[2] = {STRSXP,INTSXP};
	static R_NativePrimitiveArgType GetCLocaleArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetCLocaleArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SetOutputLanguageArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetDateCellArgs[11] = {STRSXP,STRSXP,STRSXP,INTSXP,STRSXP,INTSXP,INTSXP,INTSXP,INTSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetRecordBrowserOutputArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType TransCodeArgs[3] = {STRSXP,STRSXP,INTSXP};
    static R_NativePrimitiveArgType SetGraphicsLabelArgs[3] = {STRSXP,STRSXP,INTSXP};
    //===================new APIs in 23.0=======================
    static R_NativePrimitiveArgType StartSpssArgs[2] = {STRSXP,INTSXP};
    static R_NativePrimitiveArgType StopSpssArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType SubmitArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType QueueCommandPartArgs[3] = {STRSXP,INTSXP,INTSXP};
    static R_NativePrimitiveArgType IsBackendReadyArgs[1] = {INTSXP};
    static R_NativePrimitiveArgType IsXDrivenArgs[1] = {INTSXP};
    
    // The method of using .C from R
    static const R_CMethodDef cMethods[] = {
        {"ext_PostOutput",(DL_FUNC)&ext_PostOutput,3,PostOutputArgs},
        {"ext_StartProcedure",(DL_FUNC)&ext_StartProcedure,3,StartProcedureArgs},
        {"ext_EndProcedure",(DL_FUNC)&ext_EndProcedure,1,EndProcedureArgs},
        {"ext_HasProcedure",(DL_FUNC)&ext_HasProcedure,1,HasProcedureArgs},
        {"ext_AddCellFootnotes",(DL_FUNC)&ext_AddCellFootnotes,11,AddCellFootnotesArgs},   
        {"ext_AddDimFootnotes",(DL_FUNC)&ext_AddDimFootnotes,11,AddDimFootnotesArgs}, 
        {"ext_AddCategoryFootnotes",(DL_FUNC)&ext_AddCategoryFootnotes,11,AddCategoryFootnotesArgs}, 
        {"ext_HidePivotTableTitle",(DL_FUNC)&ext_HidePivotTableTitle,5,HidePivotTableTitleArgs}, 
        {"ext_AddOutlineFootnotes",(DL_FUNC)&ext_AddOutlineFootnotes,6,AddOutlineFootnotesArgs}, 
        {"ext_AddTitleFootnotes",(DL_FUNC)&ext_AddTitleFootnotes,6,AddTitleFootnotesArgs},         
        {"ext_AddTextBlock",(DL_FUNC)&ext_AddTextBlock,5,AddTextBlockArgs},
        {"ext_SplitChange",(DL_FUNC)&ext_SplitChange,2,SplitChangeArgs},
        {"ext_IsEndSplit",(DL_FUNC)&ext_IsEndSplit,2,IsEndSplitArgs},

        {"ext_GetSpssOutputWidth",(DL_FUNC)&ext_GetSpssOutputWidth,2,GetSpssOutputWidthArgs},
        //{"ext_GetSpssOutputWidth",(DL_FUNC)&ext_GetSpssOutputWidth,1,GetSpssOutputWidthArgs},

        {"ext_MakeCaseCursor",(DL_FUNC)&ext_MakeCaseCursor,2,MakeCaseCursorArgs},
        {"ext_HasCursor",(DL_FUNC)&ext_HasCursor,2,HasCursorArgs},
        {"ext_GetCursorPosition",(DL_FUNC)&ext_GetCursorPosition,2,GetCursorPositionArgs},
        {"ext_RemoveCaseCursor",(DL_FUNC)&ext_RemoveCaseCursor,1,RemoveCaseCursorArgs},
        {"ext_NextCase",(DL_FUNC)&ext_NextCase,1,NextCaseArgs},

        {"ext_GetSystemMissingValue",(DL_FUNC)&ext_GetSystemMissingValue,2,GetSystemMissingValueArgs},
        {"ext_GetNumericValue",(DL_FUNC)&ext_GetNumericValue,4,GetNumericValueArgs},
        {"ext_GetStringValue",(DL_FUNC)&ext_GetStringValue,5,GetStringValueArgs},
        {"ext_GetVarNMissingValues",(DL_FUNC)&ext_GetVarNMissingValues,6,GetVarNMissingValuesArgs},
        {"ext_GetVarCMissingValues",(DL_FUNC)&ext_GetVarCMissingValues,6,GetVarCMissingValuesArgs},

        {"ext_AllocNewVarsBuffer",(DL_FUNC)&ext_AllocNewVarsBuffer,2,AllocNewVarsBufferArgs},
        {"ext_CommitHeader",(DL_FUNC)&ext_CommitHeader,1,CommitHeaderArgs},

        {"ext_GetVariableFormatType",(DL_FUNC)&ext_GetVariableFormatType,5,GetVariableFormatTypeArgs},
        {"ext_GetCaseCount",(DL_FUNC)&ext_GetCaseCount,2,GetCaseCountArgs},
        {"ext_GetVariableCount",(DL_FUNC)&ext_GetVariableCount,2,GetVariableCountArgs},
        {"ext_GetVariableName",(DL_FUNC)&ext_GetVariableName,3,GetVariableNameArgs},
        {"ext_GetVariableLabel",(DL_FUNC)&ext_GetVariableLabel,3,GetVariableLabelArgs},
        {"ext_GetVariableType",(DL_FUNC)&ext_GetVariableType,3,GetVariableTypeArgs},
        {"ext_GetVariableFormat",(DL_FUNC)&ext_GetVariableFormat,3,GetVariableFormatArgs},
        {"ext_GetVariableMeasurementLevel",(DL_FUNC)&ext_GetVariableMeasurementLevel,3,GetVariableMeasurementLevelArgs},
        {"ext_GetWeightVar",(DL_FUNC)&ext_GetWeightVar,2,GetWeightVarArgs},		
		{"ext_SetRTempFolderToSPSS",(DL_FUNC)&ext_SetRTempFolderToSPSS,2,SetRTempFolderToSPSSArgs},

        {"ext_CreateXPathDictionary",(DL_FUNC)&ext_CreateXPathDictionary,2,CreateXPathDictionaryArgs},
        {"ext_RemoveXPathHandle",(DL_FUNC)&ext_RemoveXPathHandle,2,RemoveXPathHandleArgs},

        {"ext_StartDataStep",(DL_FUNC)&ext_StartDataStep,1,StartDataStepArgs},
        {"ext_EndDataStep",(DL_FUNC)&ext_EndDataStep,1,EndDataStepArgs},
        {"ext_CreateDataset",(DL_FUNC)&ext_CreateDataset,4,CreateDatasetArgs},
        {"ext_CloseDataset",(DL_FUNC)&ext_CloseDataset,2,CloseDatasetArgs},
        {"ext_InsertVariable",(DL_FUNC)&ext_InsertVariable,5,InsertVariableArgs},
        {"ext_SetVarLabelInDS",(DL_FUNC)&ext_SetVarLabelInDS,4,SetVarLabelInDSArgs},
        {"ext_SetVarFormatInDS",(DL_FUNC)&ext_SetVarFormatInDS,6,SetVarFormatInDSArgs},
        {"ext_SetVarMeasurementLevelInDS",(DL_FUNC)&ext_SetVarMeasurementLevelInDS,4,SetVarMeasurementLevelInDSArgs},
        {"ext_SetVarNMissingValuesInDS",(DL_FUNC)&ext_SetVarNMissingValuesInDS,7,SetVarNMissingValuesInDSArgs},
        {"ext_SetVarCMissingValuesInDS",(DL_FUNC)&ext_SetVarCMissingValuesInDS,7,SetVarCMissingValuesInDSArgs},
        {"ext_SetVarNValueLabelInDS",(DL_FUNC)&ext_SetVarNValueLabelInDS,5,SetVarNValueLabelInDSArgs},
        {"ext_SetVarCValueLabelInDS",(DL_FUNC)&ext_SetVarCValueLabelInDS,5,SetVarCValueLabelInDSArgs},
        {"ext_InsertCase",(DL_FUNC)&ext_InsertCase,3,InsertCaseArgs},
        {"ext_SetNCellValue",(DL_FUNC)&ext_SetNCellValue,5,SetNCellValueArgs},
        {"ext_SetCCellValue",(DL_FUNC)&ext_SetCCellValue,5,SetCCellValueArgs},
        {"ext_SetActive",(DL_FUNC)&ext_SetActive,2,SetActiveArgs},


        {"ext_GetVarTypeInDS",(DL_FUNC)&ext_GetVarTypeInDS,4,GetVarTypeInDSArgs},
        {"ext_GetVarCountInDS",(DL_FUNC)&ext_GetVarCountInDS,3,GetVarCountInDSArgs},
        {"ext_GetVarNameInDS",(DL_FUNC)&ext_GetVarNameInDS,4,GetVarNameInDSArgs},
        {"ext_IsUTF8mode",(DL_FUNC)&ext_IsUTF8mode,1,IsUTF8modeArgs},
        {"ext_GetOutputLanguage",(DL_FUNC)&ext_GetOutputLanguage,2,GetOutputLanguageArgs},
        
        {"ext_StartPivotTable",(DL_FUNC)&ext_StartPivotTable,5,StartPivotTableArgs},
        {"ext_PivotTableCaption",(DL_FUNC)&ext_PivotTableCaption,6,PivotTableCaptionArgs},
        {"ext_AddDimension",(DL_FUNC)&ext_AddDimension,10,AddDimensionArgs},
        {"ext_MinDataColumnWidth",(DL_FUNC)&ext_MinDataColumnWidth,10,MinDataColumnWidthArgs},
        {"ext_MaxDataColumnWidth",(DL_FUNC)&ext_MaxDataColumnWidth,10,MaxDataColumnWidthArgs},
        {"ext_AddNumberCategory",(DL_FUNC)&ext_AddNumberCategory,11,AddNumberCategoryArgs},
        {"ext_AddStringCategory",(DL_FUNC)&ext_AddStringCategory,11,AddStringCategoryArgs},        
        {"ext_AddVarNameCategory",(DL_FUNC)&ext_AddVarNameCategory,11,AddVarNameCategoryArgs},
        {"ext_AddVarValueStringCategory",(DL_FUNC)&ext_AddVarValueStringCategory,12,AddVarValueStringCategoryArgs},
        {"ext_AddVarValueDoubleCategory",(DL_FUNC)&ext_AddVarValueDoubleCategory,12,AddVarValueDoubleCategoryArgs},
        {"ext_SetNumberCell",(DL_FUNC)&ext_SetNumberCell,11,SetNumberCellArgs},
        {"ext_SetStringCell",(DL_FUNC)&ext_SetStringCell,11,SetStringCellArgs},
        {"ext_SetVarNameCell",(DL_FUNC)&ext_SetVarNameCell,11,SetVarNameCellArgs},
        {"ext_SetVarValueStringCell",(DL_FUNC)&ext_SetVarValueStringCell,12,SetVarValueStringCellArgs},
        {"ext_SetVarValueDoubleCell",(DL_FUNC)&ext_SetVarValueDoubleCell,12,SetVarValueDoubleCellArgs},
        {"ext_SetFormatSpecCoefficient",(DL_FUNC)&ext_SetFormatSpecCoefficient,1,SetFormatSpecCoefficientArgs},
        {"ext_SetFormatSpecCoefficientSE",(DL_FUNC)&ext_SetFormatSpecCoefficientSE,1,SetFormatSpecCoefficientSEArgs},
        {"ext_SetFormatSpecCoefficientVar",(DL_FUNC)&ext_SetFormatSpecCoefficientVar,1,SetFormatSpecCoefficientVarArgs},
        {"ext_SetFormatSpecCorrelation",(DL_FUNC)&ext_SetFormatSpecCorrelation,1,SetFormatSpecCorrelationArgs},
        {"ext_SetFormatSpecGeneralStat",(DL_FUNC)&ext_SetFormatSpecGeneralStat,1,SetFormatSpecGeneralStatArgs},
        {"ext_SetFormatSpecMean",(DL_FUNC)&ext_SetFormatSpecMean,2,SetFormatSpecMeanArgs},
        {"ext_SetFormatSpecCount",(DL_FUNC)&ext_SetFormatSpecCount,1,SetFormatSpecCountArgs},
        {"ext_SetFormatSpecPercent",(DL_FUNC)&ext_SetFormatSpecPercent,1,SetFormatSpecPercentArgs},
        {"ext_SetFormatSpecPercentNoSign",(DL_FUNC)&ext_SetFormatSpecPercentNoSign,1,SetFormatSpecPercentNoSignArgs},
        {"ext_SetFormatSpecProportion",(DL_FUNC)&ext_SetFormatSpecProportion,1,SetFormatSpecProportionArgs},
        {"ext_SetFormatSpecSignificance",(DL_FUNC)&ext_SetFormatSpecSignificance,1,SetFormatSpecSignificanceArgs},
        {"ext_SetFormatSpecResidual",(DL_FUNC)&ext_SetFormatSpecResidual,1,SetFormatSpecResidualArgs},
        {"ext_SetFormatSpecVariable",(DL_FUNC)&ext_SetFormatSpecVariable,2,SetFormatSpecVariableArgs},
        {"ext_SetFormatSpecStdDev",(DL_FUNC)&ext_SetFormatSpecStdDev,2,SetFormatSpecStdDevArgs},
        {"ext_SetFormatSpecDifference",(DL_FUNC)&ext_SetFormatSpecDifference,2,SetFormatSpecDifferenceArgs},
        {"ext_SetFormatSpecSum",(DL_FUNC)&ext_SetFormatSpecSum,2,SetFormatSpecSumArgs},       
        {"ext_GetGraphic",(DL_FUNC)&ext_GetGraphic,2,GetGraphicArgs},
        {"ext_GetSPSSLocale",(DL_FUNC)&ext_GetSPSSLocale,2,GetSPSSLocaleArgs},
        {"ext_GetCLocale",(DL_FUNC)&ext_GetCLocale,2,GetSPSSLocaleArgs},        
        {"ext_SetCLocale",(DL_FUNC)&ext_SetCLocale,1,SetCLocaleArgs},
        {"ext_SetOutputLanguage",(DL_FUNC)&ext_SetOutputLanguage,2,SetOutputLanguageArgs},
        {"ext_SetDateCell",(DL_FUNC)&ext_SetDateCell,11,SetDateCellArgs},
        {"ext_SetRecordBrowserOutput",(DL_FUNC)&ext_SetRecordBrowserOutput,3,SetRecordBrowserOutputArgs},
        {"ext_TransCode",(DL_FUNC)&ext_TransCode,3,TransCodeArgs},
        {"ext_SetGraphicsLabel",(DL_FUNC)&ext_SetGraphicsLabel,3,SetGraphicsLabelArgs},
        {"ext_StartSpss",(DL_FUNC)&ext_StartSpss,2,StartSpssArgs},
        {"ext_StopSpss",(DL_FUNC)&ext_StopSpss,1,StopSpssArgs},
        {"ext_Submit",(DL_FUNC)&ext_Submit,3,SubmitArgs},
        {"ext_QueueCommandPart",(DL_FUNC)&ext_QueueCommandPart,3,QueueCommandPartArgs},
        {"ext_IsBackendReady",(DL_FUNC)&ext_IsBackendReady,1,IsBackendReadyArgs},
        {"ext_IsXDriven",(DL_FUNC)&ext_IsXDriven,1,IsXDrivenArgs},
        {0,0,0}
    };

    // The method of using .Call from R. 
    // Notes: .C should be used when it is good enough.
    // However, .C can pass simple argument only, for example, int, double, char*.
    // That is not good enough for below functions.
    static const R_CallMethodDef callMethods[] = {
        {"ext_GetHandleList",(DL_FUNC)&ext_GetHandleList,1},   // returns vector.
        {"ext_EvaluateXPath",(DL_FUNC)&ext_EvaluateXPath,4},   // returns vector.

        
        {"ext_GetNValueLabels",(DL_FUNC)&ext_GetNValueLabels,2},   // returns list.
        {"ext_GetCValueLabels",(DL_FUNC)&ext_GetCValueLabels,2},   // returns list.
        {"ext_GetVarAttributeNames",(DL_FUNC)&ext_GetVarAttributeNames,2},   // returns vector.
        {"ext_GetVarAttributes",(DL_FUNC)&ext_GetVarAttributes,3},   // returns vector.

        {"ext_GetDataFileAttributeNames",(DL_FUNC)&ext_GetDataFileAttributeNames,1},   // returns vector.
        {"ext_GetDataFileAttributes",(DL_FUNC)&ext_GetDataFileAttributes,2},   // returns vector.


        {"ext_GetSplitVariableNames",(DL_FUNC)&ext_GetSplitVariableNames,1},   // returns vector.
        {"ext_SetVarNameAndType",(DL_FUNC)&ext_SetVarNameAndType,3},   // inputs vecters.

        {"ext_GetSpssDatasets",(DL_FUNC)&ext_GetSpssDatasets,1},  
		{"ext_GetOpenedSpssDatasets",(DL_FUNC)&ext_GetOpenedSpssDatasets,1},  
        {"ext_SetVarAttributesInDS",(DL_FUNC)&ext_SetVarAttributesInDS,6},   
        {"ext_SetDataFileAttributesInDS",(DL_FUNC)&ext_SetDataFileAttributesInDS,5},   

        {"ext_GetMultiResponseSetNames",(DL_FUNC)&ext_GetDataFileAttributeNames,1},   // returns vector.
        {"ext_GetMultiResponseSet",(DL_FUNC)&ext_GetDataFileAttributes,2},   // returns vector.
        {"ext_SetMultiResponseSetInDS",(DL_FUNC)&ext_SetDataFileAttributesInDS,7},   

        {"ext_GetDataFromSPSS",(DL_FUNC)&ext_GetDataFromSPSS,5},
        {"ext_GetSplitDataFromSPSS",(DL_FUNC)&ext_GetSplitDataFromSPSS,6},
        {"ext_SetDataToSPSS",(DL_FUNC)&ext_SetDataToSPSS,3},

        {"ext_GetVarNames",(DL_FUNC)&ext_GetVarNames,2},
        {"ext_GetVarTypes",(DL_FUNC)&ext_GetVarTypes,2},
        {"ext_GetVarLabels",(DL_FUNC)&ext_GetVarLabels,2},
        {"ext_GetVarMeasurementLevels",(DL_FUNC)&ext_GetVarMeasurementLevels,2},
        {"ext_GetVarFormats",(DL_FUNC)&ext_GetVarFormats,2},
        {"ext_GetVarFormatTypes",(DL_FUNC)&ext_GetVarFormatTypes,2},
        {"ext_GetFileHandles",(DL_FUNC)&ext_GetFileHandles,1},  // returns vector.

        {0,0,0}
    };

    // The function pointer
    static int         (*PostSpssOutput)(const char *text, int length)     = 0;

    static int         (*StartProcedure)(const char* procName, const char* translatedName) = 0;
    static int         (*EndProcedure)()                                   = 0;
    static int         (*HasProcedure)()                                   = 0;
    
    static int         (*AddCellFootnotes)(const char *outline,
                                   const char *tableName,
                                   const char*templateName,
                                   bool isSplit,
                                   const char *dimName,
                                   int place, 
                                   int position, 
                                   bool hideName, 
                                   bool hideLabels,
                                   const char *footnotes)                  = 0;
  
    static int         (*AddOutlineFootnotes)(const char* outline,
                                        const char* tableName,
                                        const char* templateName,
                                        const char* footnotes,
                                        bool isSplit)                      = 0;
  
    static int         (*AddTitleFootnotes)(const char* outline,
                                 const char* tableName,
                                 const char* templateName,
                                 const char* footnotes,
                                 bool isSplit)                             = 0;
  
    static int         (*AddDimFootnotes)(const char* outline,
                                 const char* tableName,
                                 const char* templateName,
                                 bool isSplit,
                                 const char* dimName,
                                 int place,
                                 int position,
                                 bool hideName,
                                 bool hideLabels,
                                 const char* footnoots)                    = 0;
  
    static int         (*AddCategoryFootnotes)(const char* outline,
                                 const char* tableName,
                                 const char* templateName,
                                 bool isSplit,
                                 const char* dimName,
                                 int  place,
                                 int  position,
                                 bool hideName,
                                 bool hideLabels,
                                 const char* footnoots)                    = 0;

    static int         (*HidePivotTableTitle)(const char* outline,
                                   const char* tableName,
                                   const char* templateName,
                                   bool isSplit)                           = 0;
    
    static int         (*AddTextBlock)(const char *outline, 
                                      const char *name, 
                                      const char *content, 
                                      int skip)                            = 0;
    static int         (*SplitChange)(const char *procName)                = 0;
    static int         (*IsEndSplit)(int & endSplit)                       = 0;

    static int         (*GetSpssOutputWidth)(int& errLevel)                = 0;

    static int         (*MakeCaseCursor)(const char *accessType)           = 0;
    static int         (*HasCursor)(int&)                                  = 0;
    static int         (*GetCursorPosition)(int& cursorPosition)           = 0;
    static int         (*RemoveCaseCursor)()                               = 0;
    static int         (*NextCase)()                                       = 0;
    static int         (*GetSystemMissingValue)(double &sysMissing)        = 0;
    static int         (*GetNumericValue)(unsigned varIndex, 
                                   double& result, 
                                   int& isMissing)                         = 0;
    static int         (*GetStringValue)(unsigned varIndex, 
                                  char*& result, 
                                  int bufferLength,
                                  int& isMissing)                          = 0;

    static int         (*GetVarNMissingValues)(const int varIndex,
                                        int *missingFormat,
                                        double *v1, 
                                        double *v2, 
                                        double *v3)                        = 0;
    static int         (*GetVarCMissingValues)(const int varIndex,
                                        int *missingFormat,
                                        char *v1, 
                                        char *v2, 
                                        char *v3)                          = 0;
    static int         (*GetNValueLabels)(int index,
                                   double **values, 
                                   char ***labels, 
                                   int *numOfValueLabels)                  = 0;
    static int         (*GetCValueLabels)(int index,
                                   char ***values, 
                                   char ***labels, 
                                   int *numOfValueLabels)                  = 0;
                                   
                                   
    static int         (*FreeNValueLabels)(double *values, char **labels, int numOfValueLabels) = 0;
    static int         (*FreeCValueLabels)(char **values, char **labels, int numOfValueLabels) = 0;
    
    static int         (*GetVariableFormatType)(int varIndex, 
                                         int& formatType, 
                                         int& formatWidth, 
                                         int& formatDecimal)        = 0;
    static long        (*GetCaseCount)(int &err)                           = 0;
    static unsigned    (*GetVariableCount)(int &err)                       = 0;
    static const char* (*GetVariableName)(int index, int &err)             = 0;
    static const char* (*GetVariableLabel)(int index, int &err)            = 0;
    static int         (*GetVariableType)(int index, int &err)             = 0;
    static const char* (*GetVariableFormat)(int index, int &err)           = 0;
    static int         (*GetVariableMeasurementLevel)(int index, int &err) = 0;

    static char*       (*GetWeightVar)(int &err)                           = 0;
	static int         (*SetRTempFolderToSPSS)(char *tmpdir)              = 0;
    static int         (*GetVarAttributeNames)(const int index, char ***name, int *numOfNames) = 0;
    static int         (*GetVarAttributes)(const int index, const char *attrName, char ***attr, int *numOfAttr) = 0;

    static int         (*GetDataFileAttributeNames)(char ***name, int *numOfNames) = 0;
    static int         (*GetDataFileAttributes)(const char *attrName, char ***attr, int *numOfAttr) = 0;


    static int         (*FreeAttributeNames)(char **name, const int numOfNames) = 0;
    static int         (*FreeAttributes)(char **attr, const int numOfAttr) = 0;

    static void*         (*GetSplitVariableNames)(int& err)                        = 0;

    static int         (*SetVarNameAndType)(char *varName[],
                                     const int *varType,
                                     const unsigned int numOfVar)   = 0;
    static int         (*AllocNewVarsBuffer)(int size)                     = 0;
    static int         (*CommitHeader)()                                   = 0;
//  int         (*)() = 0;


    static int         (*CreateXPathDictionary)(const char *handle)        = 0;
    static int         (*RemoveXPathHandle)(const char *handle)            = 0;
    static void*       (*EvaluateXPath)(const char *handle, 
                                 const char *context, 
                                 const char *expression, 
                                 int& errLevel)                     = 0;
    static void*         (*GetHandleList)(int& err)                        = 0;
    static int         (*GetStringListLength)(void* listHandle)            = 0;
    static const char* (*GetStringFromList)(void* listHandle, int index)   = 0;
    static int         (*RemoveStringList)(void* listHandle)               = 0;

    static int         (*StartDataStep)()      = 0;
    static int         (*EndDataStep)()        = 0;
    static int         (*CreateDataset)(const char *name, const bool isEmpty, const bool hidden)      = 0;
    static int         (*GetSpssDatasets)(char*** nameList,int& length)        = 0;
	static int         (*GetOpenedSpssDatasets)(char*** nameList,int& length)        = 0;
    static int         (*FreeStringArray)(char **array, const int length)      = 0;
    static int         (*FreeString)(char *str)      = 0;
    static int         (*CloseDataset)(const char *name)       = 0;
    static int         (*InsertVariable)(const char *dsName,
                                  const int index,
                                  const char *varName,
                                  const int type)     = 0;
    static int         (*SetVarLabelInDS)(const char *dsName,
                                   const int index,
                                   const char *varLabel)     = 0;
    static int         (*SetVarFormatInDS)(const char *dsName,
                                    const int index,
                                    const int formatType,
                                    const int formatWidth,
                                    const int formatDecima)       = 0;
    static int         (*SetVarMeasurementLevelInDS)(const char *dsName,
                                              const int index,
                                              const char *varMeasure)       = 0;
    static int         (*SetVarNMissingValuesInDS)(const char *dsName,
                                            const int index,
                                            const int missingFormat,
                                            const double missingValue1,
                                            const double missingValue2,
                                            const double missingValue3)     = 0;
    static int         (*SetVarCMissingValuesInDS)(const char *dsName,
                                            const int index,
                                            const int missingFormat,
                                            const char *missingValue1,
                                            const char *missingValue2,
                                            const char *missingValue3)      = 0;
    static int         (*SetVarAttributesInDS)(const char *dsName,
                                        const int index,
                                        const char *attrName,
                                        char ** attributes,
                                        const int length)       = 0;

    static int         (*SetDataFileAttributesInDS)(const char *dsName,
                                        const char *attrName,
                                        char ** attributes,
                                        const int length)       = 0;


    static int         (*SetVarNValueLabelInDS)(const char *dsName,
                                        const int index,
                                        const double value,
                                        const char *label)      = 0;
    static int         (*SetVarCValueLabelInDS)(const char *dsName,
                                        const int index,
                                        const char *value,
                                        const char *label)      = 0;
    static int         (*InsertCase)(const char *dsName, const long rowIndex)        = 0;
    static int         (*SetNCellValue)(const char *dsName,
                                 const long rowIndex,
                                 const int columnIndex,
                                 const double value)     = 0;
    static int         (*SetCCellValue)(const char *dsName,
                                 const long rowIndex,
                                 const int columnIndex,
                                 const char *value)      = 0;

    static int         (*SetActive)(const char *name)          = 0;

    static int         (*GetVarTypeInDS)(const char *dsName, const int index, int& errLevel)     = 0;
    static const char* (*GetVarNameInDS)(const char *dsName, const int index, int& errLevel)     = 0;
    static unsigned    (*GetVarCountInDS)(const char *dsName, int& errLevel)     = 0;
    static int         (*IsUTF8mode)()     = 0;
    static const char* (*GetOutputLanguage)(int& errLevel)    = 0;

    static int         (*StartPivotTable)(const char *outline, const char *title,const char *templateName, bool isSplit) = 0;
    static int         (*PivotTableCaption)(const char *outline, const char *title,const char *templateName, bool isSplit,const char *caption) = 0;
    static int         (*AddDimension)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels)    = 0;
    static int         (*AddNumberCategory)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,double category)    = 0;
    static int         (*AddStringCategory)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,const char *category)   = 0;
    static int         (*AddVarNameCategory)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int cellVal)    = 0;
    static int         (*AddVarValueStringCategory)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, const char *cellVal)    = 0;
    static int         (*AddVarValueDoubleCategory)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, double)    = 0;
    static int         (*SetNumberCell)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,double cellVal) = 0;
    static int         (*SetStringCell)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,const char *cellVal)    = 0;
    static int         (*SetVarNameCell)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int cellVal)    = 0;
    static int         (*SetVarValueStringCell)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, const char*)    = 0;
    static int         (*SetVarValueDoubleCell)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, double)    = 0;
    
    static int         (*MinDataColumnWidth)(const char *outline, const char *title, const char *templateName,bool isSplit,int nMinInPoints)          = 0;
    static int         (*MaxDataColumnWidth)(const char *outline, const char *title, const char *templateName,bool isSplit,int nMaxInPoints)          = 0;
   
    static int         (*SetFormatSpecCoefficient)()       = 0;
    static int         (*SetFormatSpecCoefficientSE)()     = 0;
    static int         (*SetFormatSpecCoefficientVar)()    = 0;
    static int         (*SetFormatSpecCorrelation)()       = 0;
    static int         (*SetFormatSpecGeneralStat)()       = 0;
    static int         (*SetFormatSpecMean)(int)           = 0;     
    static int         (*SetFormatSpecCount)()             = 0;
    static int         (*SetFormatSpecPercent)()           = 0;
    static int         (*SetFormatSpecPercentNoSign)()     = 0;
    static int         (*SetFormatSpecProportion)()        = 0;
    static int         (*SetFormatSpecSignificance)()      = 0;
    static int         (*SetFormatSpecResidual)()          = 0;

    static int         (*SetFormatSpecVariable)(int)       = 0;
    static int         (*SetFormatSpecStdDev)(int)         = 0;
    static int         (*SetFormatSpecDifference)(int)     = 0;
    static int         (*SetFormatSpecSum)(int)            = 0;



    static void*       (*GetMultiResponseSetNames)(int &errlvl)     = 0;
    static void        (*GetMultiResponseSet)(const char *mrsetName, 
                                                char **mrsetLabel, 
                                                int &mrsetCodeAs,
                                                char **mrsetCountedValue,
                                                int &mrsetDataType,
                                                void **elemVarNames, 
                                                int &errlvl)        = 0;
    static void        (*SetMultiResponseSetInDS)(const char *datasetName, 
                                                    const char *mrsetName,
                                                    const char *mrsetLabel,
                                                    const int mrsetCodeAs,
                                                    const char *mrsetCountedValue,
                                                    const void *elemVarNames,
                                                    const int numOfVars,
                                                    int &errlvl)    = 0;

    static int         (*GetGraphic)(const char *fileName) = 0;
    static char*       (*GetSPSSLocale)(int &errCode) = 0;
    static int         (*GetCLocale)(char **) = 0;
    static void        (*SetOutputLanguage)(const char *lang, int &errLevel) = 0;
    static void*       (*GetFileHandles)(int& err) = 0;
    static int         (*SetDateCell)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,const char *cellVal)    = 0;
    static int         (*SetRecordBrowserOutput)(const char *filePath,bool isRecord)    = 0;
    
    static const char* (*TransCode)(const char* orig, int& errLevel)             = 0;
    static int         (*SetGraphicsLabel)(const char* displaylabel, const char* invariantdisplaylabel)    = 0;
    
    //===================new APIs in 23.0=======================
    static int         (*StartSpss)(const char* commandline) = 0;
    static void        (*StopSpss)() = 0;
    static int         (*Submit)(const char* command, int length) = 0;
    static int         (*QueueCommandPart)(const char* command, int length) = 0;
    static bool        (*IsBackendReady)() = 0;
    static bool        (*IsXDriven)() = 0;
    
    //Initialize the function pointer
    void InitializeFP()
    {
        PostSpssOutput = (int (*)(const char*, int ))GETADDRESS(pLib,"PostSpssOutput");

        StartProcedure = (int (*)(const char*, const char*))GETADDRESS(pLib,"StartProcedure");
        EndProcedure = (int (*)())GETADDRESS(pLib,"EndProcedure");
        HasProcedure = (int (*)())GETADDRESS(pLib,"HasProcedure");
      
        AddCellFootnotes = (int(*)(const char *,
                                   const char *,
                                   const char*,
                                   bool ,
                                   const char *,
                                   int , 
                                   int , 
                                   bool , 
                                   bool ,
                                   const char *))GETADDRESS(pLib,"AddCellFootnotes");
  
        AddOutlineFootnotes = (int(*)(const char* ,
                                        const char* ,
                                        const char* ,
                                        const char*,
                                        bool ))GETADDRESS(pLib,"AddOutlineFootnotes");
  
        AddTitleFootnotes = (int(*)(const char* ,
                                 const char* ,
                                 const char* ,
                                 const char*,
                                 bool ))GETADDRESS(pLib,"AddTitleFootnotes");
  
        AddDimFootnotes = (int(*)(const char* ,
                                 const char* ,
                                 const char* ,
                                 bool ,
                                 const char* ,
                                 int ,
                                 int ,
                                 bool ,
                                 bool ,
                                 const char* ))GETADDRESS(pLib,"AddDimFootnotes");
  
       AddCategoryFootnotes = (int(*)(const char* ,
                                 const char* ,
                                 const char* ,
                                 bool ,
                                 const char* ,
                                 int  ,
                                 int  ,
                                 bool ,
                                 bool ,
                                 const char* ))GETADDRESS(pLib,"AddCategoryFootnotes");
  
        HidePivotTableTitle = (int(*)(const char* ,
                                   const char* ,
                                   const char* ,
                                   bool ))GETADDRESS(pLib,"HidePivotTableTitle"); 
        
        AddTextBlock = (int (*)(const char*, const char*, const char*,int))GETADDRESS(pLib,"AddTextBlock");
        SplitChange = (int (*)(const char*))GETADDRESS(pLib,"SplitChange");
        IsEndSplit = (int (*)(int&))GETADDRESS(pLib,"IsEndSplit");

        GetSpssOutputWidth = (int (*)(int&))GETADDRESS(pLib,"GetSpssOutputWidth");

        MakeCaseCursor = (int (*)(const char*))GETADDRESS(pLib,"MakeCaseCursor");
        HasCursor = (int (*)(int& ))GETADDRESS(pLib,"HasCursor");
        GetCursorPosition = (int (*)(int& ))GETADDRESS(pLib,"GetCursorPosition");
        RemoveCaseCursor = (int (*)())GETADDRESS(pLib,"RemoveCaseCursor");
        NextCase = (int (*)())GETADDRESS(pLib,"NextCase");
        GetSystemMissingValue = (int (*)(double&))GETADDRESS(pLib,"GetSystemMissingValue");
        GetNumericValue = (int (*)(unsigned,double&,int&))GETADDRESS(pLib,"GetNumericValue");
        GetStringValue = (int (*)(unsigned,char*&,int,int&))GETADDRESS(pLib,"GetStringValue");
        GetVarNMissingValues = (int (*)(int,int*,double*,double*,double*))GETADDRESS(pLib,"GetVarNMissingValues");
        GetVarCMissingValues = (int (*)(int,int*,char*,char*,char*))GETADDRESS(pLib,"GetVarCMissingValues");
        GetNValueLabels = (int (*)(int,double**,char***,int* ))GETADDRESS(pLib,"GetNValueLabels");
        GetCValueLabels = (int (*)(int,char***,char***,int* ))GETADDRESS(pLib,"GetCValueLabels");
        FreeNValueLabels = (int (*)(double*,char**,int ))GETADDRESS(pLib,"FreeNValueLabels");
        FreeCValueLabels = (int (*)(char**,char**,int ))GETADDRESS(pLib,"FreeCValueLabels");

        GetVariableFormatType = (int (*)(int,int&,int&,int&))GETADDRESS(pLib,"GetVariableFormatType");
        GetCaseCount = (long (*)(int& ))GETADDRESS(pLib,"GetRowCount");
        GetVariableCount = (unsigned (*)(int& ))GETADDRESS(pLib,"GetVariableCount");
        GetVariableName = (const char* (*)(int , int& ))GETADDRESS(pLib,"GetVariableName");
        GetVariableLabel = (const char* (*)(int , int& ))GETADDRESS(pLib,"GetVariableLabel");
        GetVariableType = (int (*)(int , int& ))GETADDRESS(pLib,"GetVariableType");
        GetVariableFormat = (const char* (*)(int , int& ))GETADDRESS(pLib,"GetVariableFormat");
        GetVariableMeasurementLevel = (int (*)(int , int& ))GETADDRESS(pLib,"GetVariableMeasurementLevel");

        GetWeightVar = (char* (*)(int& ))GETADDRESS(pLib,"GetWeightVar");
		SetRTempFolderToSPSS = (int (*)(char*))GETADDRESS(pLib,"SetRTempFolderToSPSS");
        GetVarAttributeNames = (int (*)(const int,char***,int*))GETADDRESS(pLib,"GetVarAttributeNames");
        GetVarAttributes = (int (*)(const int,const char*,char***,int* ))GETADDRESS(pLib,"GetVarAttributes");
        GetDataFileAttributeNames = (int (*)(char***,int*))GETADDRESS(pLib,"GetDataFileAttributeNames");
        GetDataFileAttributes = (int (*)(const char*,char***,int* ))GETADDRESS(pLib,"GetDataFileAttributes");
        FreeAttributeNames = (int (*)(char**, const int ))GETADDRESS(pLib,"FreeAttributeNames");
        FreeAttributes = (int (*)(char**, const int ))GETADDRESS(pLib,"FreeAttributes");

        GetSplitVariableNames = (void* (*)(int& ))GETADDRESS(pLib,"GetSplitVariableNames");

        SetVarNameAndType = (int (*)(char *[],const int*,const unsigned int))GETADDRESS(pLib,"SetVarNameAndType");
        AllocNewVarsBuffer = (int (*)(int ))GETADDRESS(pLib,"AllocNewVarsBuffer");
        CommitHeader = (int (*)())GETADDRESS(pLib,"CommitHeader");
                                     
        CreateXPathDictionary = (int (*)(const char*))GETADDRESS(pLib,"CreateXPathDictionary");
        RemoveXPathHandle = (int (*)(const char*))GETADDRESS(pLib,"RemoveXPathHandle");
        EvaluateXPath = (void* (*)(const char*,const char*,const char*,int&))GETADDRESS(pLib,"EvaluateXPath");
        GetHandleList = (void* (*)(int&))GETADDRESS(pLib,"GetHandleList");
        GetStringListLength = (int (*)(void*))GETADDRESS(pLib,"GetStringListLength");
        GetStringFromList = (const char* (*)(void*, int))GETADDRESS(pLib,"GetStringFromList");
        RemoveStringList = (int (*)(void*))GETADDRESS(pLib,"RemoveStringList");

        StartDataStep = (int (*)())GETADDRESS(pLib,"StartDataStep");
        EndDataStep = (int (*)())GETADDRESS(pLib,"EndDataStep");
        CreateDataset = (int (*)(const char *,const bool,const bool))GETADDRESS(pLib,"CreateDataset");
        CloseDataset = (int (*)(const char*))GETADDRESS(pLib,"CloseDataset");
        GetSpssDatasets = (int (*)(char***, int& ))GETADDRESS(pLib,"GetSpssDatasets");
		GetOpenedSpssDatasets = (int (*)(char***, int& ))GETADDRESS(pLib,"GetOpenedSpssDatasets");
        InsertVariable = (int (*)(const char*, const int,const char*,int ))GETADDRESS(pLib,"InsertVariable");
        SetVarLabelInDS = (int (*)(const char*,const int,const char* ))GETADDRESS(pLib,"SetVarLabelInDS");
        FreeStringArray = (int (*)(char **, const int ))GETADDRESS(pLib,"FreeStringArray");
        FreeString = (int (*)(char *))GETADDRESS(pLib,"FreeString");
        SetVarFormatInDS = (int (*)(const char* ,const int ,const int ,const int ,const int))GETADDRESS(pLib,"SetVarFormatInDS");
        SetVarMeasurementLevelInDS = (int (*)(const char*,const int,const char* ))GETADDRESS(pLib,"SetVarMeasurementLevelInDS");
        SetVarNMissingValuesInDS = (int (*)(const char* ,const int ,const int,
                                            const double ,
                                            const double ,
                                            const double ))GETADDRESS(pLib,"SetVarNMissingValuesInDS");
        SetVarCMissingValuesInDS = (int (*)(const char* ,
                                            const int ,
                                            const int ,
                                            const char* ,
                                            const char* ,
                                            const char* ))GETADDRESS(pLib,"SetVarCMissingValuesInDS");
        SetVarAttributesInDS = (int (*)(const char* ,
                                        const int ,
                                        const char* ,
                                        char ** ,
                                        const int ))GETADDRESS(pLib,"SetVarAttributesInDS");
        SetDataFileAttributesInDS = (int (*)(const char* ,
                                        const char* ,
                                        char ** ,
                                        const int ))GETADDRESS(pLib,"SetDataFileAttributesInDS");
        SetVarNValueLabelInDS = (int (*)(const char* ,
                                        const int ,
                                        const double ,
                                        const char* ))GETADDRESS(pLib,"SetVarNValueLabelInDS");
        SetVarCValueLabelInDS = (int (*)(const char* ,
                                        const int ,
                                        const char* ,
                                        const char* ))GETADDRESS(pLib,"SetVarCValueLabelInDS");
        InsertCase = (int (*)(const char* ,const long  ))GETADDRESS(pLib,"InsertCase");
        SetNCellValue = (int (*)(const char* ,
                                 const long ,
                                 const int ,
                                 const double  ))GETADDRESS(pLib,"SetNCellValue");
        SetCCellValue = (int (*)(const char* ,
                                 const long ,
                                 const int ,
                                 const char* ))GETADDRESS(pLib,"SetCCellValue");
        SetActive = (int (*)(const char*))GETADDRESS(pLib,"SetActive");

        GetVarTypeInDS = (int (*)(const char*,const int,int& ))GETADDRESS(pLib,"GetVarTypeInDS");
        GetVarNameInDS = (const char* (*)(const char*,const int,int& ))GETADDRESS(pLib,"GetVarNameInDS");
        GetVarCountInDS = (unsigned (*)(const char*,int& ))GETADDRESS(pLib,"GetVarCountInDS");
        IsUTF8mode = (int (*)())GETADDRESS(pLib,"IsUTF8mode");
        GetOutputLanguage = (const char*(*)(int& errCode))GETADDRESS(pLib,"GetOutputLanguage");

        StartPivotTable = (int (*)(const char*, const char*,const char*, bool))GETADDRESS(pLib,"StartPivotTable");
        PivotTableCaption = (int (*)(const char*, const char*,const char*, bool,const char*))GETADDRESS(pLib,"PivotTableCaption");
        AddDimension = (int (*)(const char* , const char* , const char* ,bool ,const char* ,int ,int ,bool ,bool ))GETADDRESS(pLib,"AddDimension");
        MinDataColumnWidth = (int (*)(const char* , const char* , const char* ,bool ,int ))GETADDRESS(pLib,"MinDataColumnWidth");
        MaxDataColumnWidth = (int (*)(const char* , const char* , const char* ,bool ,int ))GETADDRESS(pLib,"MaxDataColumnWidth");
        AddNumberCategory = (int (*)(const char* , const char* , const char* ,bool ,const char* ,int ,int ,bool ,bool ,double))GETADDRESS(pLib,"AddNumberCategory");
        AddStringCategory = (int (*)(const char* , const char* , const char* ,bool ,const char* ,int ,int ,bool ,bool ,const char*))GETADDRESS(pLib,"AddStringCategory");

        AddVarNameCategory = (int(*)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int cellVal))GETADDRESS(pLib,"AddVarNameCategory");
        AddVarValueStringCategory = (int(*)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, const char *cellVal))GETADDRESS(pLib,"AddVarValueStringCategory");
        AddVarValueDoubleCategory = (int(*)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, double))GETADDRESS(pLib,"AddVarValueDoubleCategory");
        SetNumberCell = (int (*)(const char* , const char* , const char* ,bool ,const char* ,int ,int ,bool ,bool ,double))GETADDRESS(pLib,"SetNumberCell");
        SetStringCell = (int (*)(const char* , const char* , const char* ,bool ,const char* ,int ,int ,bool ,bool ,const char*))GETADDRESS(pLib,"SetStringCell");
        SetVarNameCell = (int(*)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int cellVal))GETADDRESS(pLib,"SetVarNameCell");
        SetVarValueStringCell = (int(*)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, const char*))GETADDRESS(pLib,"SetVarValueStringCell");
        SetVarValueDoubleCell = (int(*)(const char *outline, const char *title, const char *templateName,bool isSplit,const char *dimName,int place,int position,bool hideName,bool hideLabels,int, double))GETADDRESS(pLib,"SetVarValueDoubleCell");
        SetFormatSpecCoefficient = (int (*)())GETADDRESS(pLib,"SetFormatSpecCoefficient");
		SetFormatSpecCoefficientSE = (int (*)())GETADDRESS(pLib,"SetFormatSpecCoefficientSE");
        SetFormatSpecCoefficientVar = (int (*)())GETADDRESS(pLib,"SetFormatSpecCoefficientVar");
        SetFormatSpecCorrelation = (int (*)())GETADDRESS(pLib,"SetFormatSpecCorrelation");
        SetFormatSpecGeneralStat = (int (*)())GETADDRESS(pLib,"SetFormatSpecGeneralStat");
        SetFormatSpecMean = (int (*)(int))GETADDRESS(pLib,"SetFormatSpecMean");        
        SetFormatSpecCount = (int (*)())GETADDRESS(pLib,"SetFormatSpecCount");
        SetFormatSpecPercent = (int (*)())GETADDRESS(pLib,"SetFormatSpecPercent");
        SetFormatSpecPercentNoSign = (int (*)())GETADDRESS(pLib,"SetFormatSpecPercentNoSign");
        SetFormatSpecProportion = (int (*)())GETADDRESS(pLib,"SetFormatSpecProportion");
        SetFormatSpecSignificance = (int (*)())GETADDRESS(pLib,"SetFormatSpecSignificance");
        SetFormatSpecResidual = (int (*)())GETADDRESS(pLib,"SetFormatSpecResidual");
        SetFormatSpecVariable  = (int (*)(int))GETADDRESS(pLib,"SetFormatSpecVariable");
        SetFormatSpecStdDev = (int (*)(int))GETADDRESS(pLib,"SetFormatSpecStdDev");
        SetFormatSpecDifference= (int (*)(int))GETADDRESS(pLib,"SetFormatSpecDifference");
        SetFormatSpecSum = (int (*)(int))GETADDRESS(pLib,"SetFormatSpecSum"); 

        GetMultiResponseSetNames = (void* (*)(int&))GETADDRESS(pLib,"GetMultiResponseSetNames");
        GetMultiResponseSet = (void (*)(const char *,char **,int &,char **,int &,void **,int &))GETADDRESS(pLib,"GetMultiResponseSet");
        SetMultiResponseSetInDS = (void (*)(const char *,const char *,const char *,const int ,
                                            const char* ,const void *,const int, int & ))GETADDRESS(pLib,"SetMultiResponseSetInDS");
        GetGraphic = (int (*)(const char* ))GETADDRESS(pLib,"GetGraphic");
        GetSPSSLocale = (char* (*)(int& ))GETADDRESS(pLib,"GetSPSSLocale");
        GetCLocale = (int(*)(char**))GETADDRESS(pLib,"GetCLocale");
        SetOutputLanguage = (void (*)(const char*,int &))GETADDRESS(pLib,"SetOutputLanguage");
        GetFileHandles = (void* (*)(int&))GETADDRESS(pLib,"GetFileHandles");
        SetDateCell = (int (*)(const char* , const char* , const char* ,bool ,const char* ,int ,int ,bool ,bool ,const char*))GETADDRESS(pLib,"SetDateCell");
        SetRecordBrowserOutput = (int (*)(const char* , bool ))GETADDRESS(pLib,"SetRecordBrowserOutput");
        
        TransCode = (const char* (*)(const char* , int& ))GETADDRESS(pLib,"TransCode");
        SetGraphicsLabel = (int (*)(const char* , const char* ))GETADDRESS(pLib,"SetGraphicsLabel");
        //===================new APIs in 23.0=======================
        StartSpss = (int (*)(const char*))GETADDRESS(pLib, "StartSpss");
        StopSpss = (void (*)())GETADDRESS(pLib, "StopSpss");
        Submit = (int (*)(const char*, int))GETADDRESS(pLib, "Submit");
        QueueCommandPart = (int (*)(const char*, int))GETADDRESS(pLib, "QueueCommandPart");
        IsBackendReady = (bool (*)())GETADDRESS(pLib, "IsBackendReady");
        IsXDriven = (bool (*)())GETADDRESS(pLib, "IsXDriven");
    }

    //load spssxd_p.dll
  int LoadLib()
  {

    // The object holding the new PATH env string cannot go out of scope.
    const char* spsshome = NULL;
    char* libPath = NULL;
    if (getenv("SPSS_HOME")) {
        spsshome = getenv("SPSS_HOME");
    }
    if (NULL == spsshome){
        int libLen = strlen(libName)+1;
        libPath = new char[libLen];
        memset(libPath,'\0',libLen);
        strcpy(libPath,libName);
    }
    else{
#ifdef MS_WINDOWS
    int libLen = strlen(spsshome) + strlen(libName) + 2;
    libPath = new char[libLen];
    memset(libPath,'\0',libLen);
    strcpy(libPath,spsshome);
    if(spsshome[strlen(spsshome)-1] != '\\')
        strcat(libPath,"\\");
    strcat(libPath,libName);
#else
    int libLen = strlen(spsshome) + strlen(libName) + 20;
    libPath = new char[libLen];
    memset(libPath,'\0',libLen);
    strcpy(libPath,spsshome);
    strcat(libPath,"/lib/");
    strcat(libPath,libName);
#endif
}
    if(NULL == pLib) {

#ifdef MS_WINDOWS
         //find out spssxd module, it will success when spss drive
         pLib = GetModuleHandle(libPath);
         //find out spssxd module failure, load it.
         if(NULL == pLib){
             pLib = LoadLibraryEx(libPath,NULL,LOAD_WITH_ALTERED_SEARCH_PATH);
         }
//         // force to load libifcoremd.dll
//         if (NULL == pLib1){
//           pLib1 = LoadLibrary("libifcoremd.dll");
//         }
#else
         int mode;
         #ifdef DARWIN
             mode = RTLD_LOCAL;     
         #else
             mode = RTLD_NOW | RTLD_GLOBAL;
         #endif
         
         pLib = dlopen(libPath,mode);
#endif
    }
   if (pLib) {
     InitializeFP();
   }
   else {//load failure
       #ifndef MS_WINDOWS
       char *perr = dlerror();
       if(perr) {
           printf("dlopen fails with error: %s.\n",perr);
       }
       #endif
       delete []libPath;
       return LOAD_FAIL;
   }
   delete []libPath;

   return LOAD_SUCCESS;
  }

    //unload spssxd_p.dll
    void FreeLib()
    {
#ifdef MS_WINDOWS
        FreeLibrary(pLib);
#else
        dlclose(pLib);
#endif
        pLib                    = 0;
        PostSpssOutput          = 0;
        
        StartProcedure          = 0;
        EndProcedure            = 0;
        HasProcedure            = 0;
        
        AddCellFootnotes        = 0;
        AddDimFootnotes         = 0;
        AddCategoryFootnotes    = 0;
        HidePivotTableTitle     = 0;
        AddOutlineFootnotes     = 0;
        AddTitleFootnotes       = 0;
         
        AddTextBlock            = 0;
        SplitChange             = 0;
        IsEndSplit              = 0;
        
        GetSpssOutputWidth      = 0;
        
        MakeCaseCursor          = 0;
        HasCursor               = 0;
        GetCursorPosition       = 0;
        RemoveCaseCursor        = 0;
        NextCase                = 0;
        GetSystemMissingValue         = 0;
        GetNumericValue         = 0;
        GetStringValue          = 0;
        
        GetVarNMissingValues    = 0;
        GetVarCMissingValues    = 0;
        GetNValueLabels         = 0;
        GetCValueLabels         = 0;
                    
                    
        FreeNValueLabels        = 0;
        FreeCValueLabels        = 0;
        
        GetVariableFormatType   = 0;
        GetCaseCount            = 0;
        GetVariableCount        = 0;
        GetVariableName         = 0;
        GetVariableLabel        = 0;
        GetVariableType         = 0;
        GetVariableFormat       = 0;
        GetVariableMeasurementLevel       = 0;
        
        GetWeightVar            = 0;
		SetRTempFolderToSPSS    = 0;
        GetVarAttributeNames    = 0;
        GetVarAttributes        = 0;
        GetDataFileAttributeNames    = 0;
        GetDataFileAttributes        = 0;
        FreeAttributeNames      = 0;
        FreeAttributes          = 0;
        
        GetSplitVariableNames   = 0;
        
        SetVarNameAndType       = 0;
        AllocNewVarsBuffer      = 0;
        CommitHeader            = 0;
        
        
        CreateXPathDictionary   = 0;
        RemoveXPathHandle       = 0;
        EvaluateXPath           = 0;
        GetHandleList           = 0;
        GetStringListLength     = 0;
        GetStringFromList       = 0;
        RemoveStringList        = 0;
        
        StartDataStep           = 0;
        EndDataStep             = 0;
        CreateDataset           = 0;
        GetSpssDatasets         = 0;
		GetOpenedSpssDatasets   = 0;
        FreeStringArray         = 0;
        FreeString              = 0;
        CloseDataset            = 0;
        InsertVariable          = 0;
        SetVarLabelInDS         = 0;
        SetVarFormatInDS                = 0;
        SetVarMeasurementLevelInDS      = 0;
        SetVarNMissingValuesInDS        = 0;
        SetVarCMissingValuesInDS        = 0;
        SetVarAttributesInDS            = 0;
        SetDataFileAttributesInDS            = 0;
        SetVarNValueLabelInDS           = 0;
        SetVarCValueLabelInDS           = 0;
        InsertCase                      = 0;
        SetNCellValue                   = 0;
        SetCCellValue                   = 0;
        SetActive                       = 0;

        GetVarTypeInDS                  = 0;
        GetVarNameInDS                  = 0;
        GetVarCountInDS                 = 0;
        IsUTF8mode                      = 0;
        GetOutputLanguage               = 0;
        
        StartPivotTable                 = 0;
        PivotTableCaption               = 0;
        AddDimension                    = 0;
        MinDataColumnWidth              = 0;
        MaxDataColumnWidth              = 0;
        AddNumberCategory               = 0;
        AddStringCategory               = 0;
        AddVarNameCategory = 0;
        AddVarValueStringCategory = 0;
        AddVarValueDoubleCategory = 0;
        SetNumberCell                   = 0;
        SetStringCell                   = 0;
        SetVarNameCell = 0;
        SetVarValueStringCell = 0;
        SetVarValueDoubleCell = 0;       
        SetFormatSpecCoefficient        = 0;
        SetFormatSpecCoefficientSE      = 0;
        SetFormatSpecCoefficientVar     = 0;
        SetFormatSpecCorrelation        = 0;
        SetFormatSpecGeneralStat        = 0;
        SetFormatSpecMean               = 0;
        SetFormatSpecCount              = 0;
        SetFormatSpecPercent            = 0;
        SetFormatSpecPercentNoSign      = 0;
        SetFormatSpecProportion         = 0;
        SetFormatSpecSignificance       = 0;
        SetFormatSpecResidual           = 0;
        SetFormatSpecVariable           = 0;
        SetFormatSpecStdDev             = 0;
        SetFormatSpecDifference         = 0;
        SetFormatSpecSum                = 0;        

        GetMultiResponseSetNames    = 0;
        GetMultiResponseSet         = 0;
        SetMultiResponseSetInDS     = 0;
        GetGraphic                  = 0;
        GetSPSSLocale               = 0;
        GetCLocale                  = 0;
        SetOutputLanguage           = 0;
        GetFileHandles              = 0;
        SetDateCell               = 0;
        SetRecordBrowserOutput               = 0;
        TransCode                   = 0;
        SetGraphicsLabel                   = 0;
        //===================new APIs in 23.0=======================
        StartSpss = 0;
        StopSpss = 0;
        Submit = 0;
        QueueCommandPart = 0;
        IsBackendReady = 0;
        IsXDriven = 0;
    }

    void ext_PostOutput(
        const char** text,
        int* length,
        int* errLevel)
    {
        *errLevel = LoadLib();
        //For Chinese character, R will send wrong character length.
        //Re-calculate here.
        int real_length = strlen(*text);
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = PostSpssOutput(*text, real_length);
        }
    }

    void ext_StartProcedure(const char** procName, const char** omsIdentifier, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = StartProcedure(*omsIdentifier,*procName);
    }

    void ext_EndProcedure(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = EndProcedure();
    }
    
    void ext_HasProcedure(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = HasProcedure();
    }

    void ext_AddCellFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** dimName,
                                 int * place,
                                 int * position,
                                 int * hideName,
                                 int * hideLabels,
                                 const char** footnotes,
                                 int * errLevel)
    {
       *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
        *errLevel = AddCellFootnotes(*outline,*tableName,*templateName,(bool)*isSplit,
                                    *dimName,*place, *position, (bool)*hideName, (bool)*hideLabels,
                                    *footnotes);
    }
  
  
    void ext_AddOutlineFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** footnotes,
                                 int * errLevel)
    {
       *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
        *errLevel = AddOutlineFootnotes(*outline,*tableName,*templateName,*footnotes,(bool)*isSplit);
    }
  
    void ext_AddTitleFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** footnotes,
                                 int * errLevel)
    {
       *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = AddTitleFootnotes(*outline,*tableName,*templateName,*footnotes,(bool)*isSplit);
    }
  
    void ext_AddDimFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** dimName,
                                 int * place,
                                 int * position,
                                 int * hideName,
                                 int * hideLabels,
                                 const char** footnotes,
                                 int * errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = AddDimFootnotes(*outline,*tableName,*templateName,(bool)*isSplit,
                                        *dimName,*place, *position, (bool)*hideName, (bool)*hideLabels,
                                        *footnotes);
    }
  
    void ext_AddCategoryFootnotes(const char** outline,
                                 const char** tableName,
                                 const char** templateName,
                                 int * isSplit,
                                 const char** dimName,
                                 int * place,
                                 int * position,
                                 int * hideName,
                                 int * hideLabels,
                                 const char** footnotes,
                                 int * errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = AddCategoryFootnotes(*outline,*tableName,*templateName,(bool)*isSplit,
                                        *dimName,*place, *position, (bool)*hideName, (bool)*hideLabels,
                                        *footnotes);
    }

    void ext_HidePivotTableTitle(const char** outline,
                                   const char** tableName,
                                   const char** templateName,
                                   int * isSplit,
                                   int * errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = HidePivotTableTitle(*outline, *tableName,*templateName,(bool)*isSplit);
    }
    
    void ext_AddTextBlock(const char** name, const char** content, const char** outline, int* skip, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = AddTextBlock(*outline,*name,*content,*skip);
    }

    void ext_SplitChange(const char** procName, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = SplitChange(*procName);
    }

    void ext_IsEndSplit(int* endSplit, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = IsEndSplit(*endSplit);
    }           
    
    void ext_GetSpssOutputWidth(int* width, int* errLevel) //void
    {
        *errLevel = LoadLib();
        if(LOAD_SUCCESS == *errLevel)
          *width = GetSpssOutputWidth(*errLevel);
    }

    void ext_MakeCaseCursor(const char** accessType, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = MakeCaseCursor(*accessType);
    }

    void ext_HasCursor(int* hasCursor, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = HasCursor(*hasCursor);
    }

    void ext_GetCursorPosition(int* cursorPosition, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = GetCursorPosition(*cursorPosition);
    }

    void ext_RemoveCaseCursor(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = RemoveCaseCursor();
    }

    void ext_NextCase(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = NextCase();
    }

    void ext_GetSystemMissingValue(double* sysMissing, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = GetSystemMissingValue(*sysMissing);
    }
    
    SEXP ext_GetDataFromSPSS(SEXP variables, SEXP cases, SEXP bKeepUserMissing, SEXP bMissingValueToNA, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);
        int keepUserMissing = INTEGER_VALUE(bKeepUserMissing);
        int missingValueToNA = INTEGER_VALUE(bMissingValueToNA);

        SEXP ans = PROTECT(allocVector(VECSXP, nvar+1));//The last element is for errLevel.
        SEXP ans_names = PROTECT(allocVector(STRSXP, nvar));
    
        int i;
        int ncases = 0,N;
        double dValue;
        char *sValue;
        int isMissing;

        int *varIndices = new int[nvar];
        int *varTypes = new int[nvar];
        int totalCases = INTEGER_VALUE(cases);        
        if(totalCases != -1)
            N = totalCases;
        else
            N = 100;
        for (i = 0; i < nvar; ++i) {
            varIndices[i] = INTEGER_VALUE(VECTOR_ELT(variables,i));
            varTypes[i] = GetVariableType(varIndices[i],*cErr);
            if(*cErr != 0)
              goto error;
            const char* tmpStr = GetVariableName(varIndices[i],*cErr);  
            if(*cErr != 0)
              goto error;
            SET_STRING_ELT(ans_names, i, IsUTF8mode()?mkCharCE(tmpStr,CE_UTF8):mkChar(tmpStr));
            
            if (0 == varTypes[i]) {
                SET_VECTOR_ELT(ans, i, allocVector(REALSXP, N));
            } else {
                SET_VECTOR_ELT(ans, i, allocVector(STRSXP, N));
            }
        }
        
        *cErr = MakeCaseCursor("r");
        if(*cErr !=0)
            goto error;        
        if(*cErr == 0){
            *cErr = NextCase();
            while( ncases < totalCases && 0 == *cErr) {

                if (ncases == N) {
                    N *= 2;
                    for (i = 0; i < nvar; ++i) {
                        SEXP elt = VECTOR_ELT(ans, i);
                        elt = lengthgets(elt, N);
                        SET_VECTOR_ELT(ans, i, elt);
                    }
                }
                for (i = 0; i < nvar; i++) {
                    if ( 0 == varTypes[i] ) {
                        *cErr = GetNumericValue(varIndices[i], dValue, isMissing);

                        if(*cErr != 0)
                            goto error;                        
                        //isMissing == 2 means this value is System_MissingValue.
                        //isMissing == 1 means this values is user missing value.
                        if(2 == isMissing || (1 == isMissing && 0 == keepUserMissing)){
                            if(missingValueToNA == 0)
                            {
                                dValue = R_NaN;                  
                            }
                            else
                            {
                                dValue = R_NaReal;
                            }
                        }
                        REAL(VECTOR_ELT(ans, i))[ncases] = dValue;
                    }
                    else{
                        sValue = new char[varTypes[i] + 1];
                        memset(sValue,'\0',varTypes[i] + 1);
                        
                        *cErr = GetStringValue(varIndices[i],sValue,varTypes[i],isMissing);

                        if(*cErr != 0)
                            goto error;                        
                        //isMissing == 1 means this values is user missing value.
                        if( 1 == isMissing && 0 == keepUserMissing ){
                            SET_STRING_ELT(VECTOR_ELT(ans, i), ncases, R_NaString);
                        }
                        else{
                            SET_STRING_ELT(VECTOR_ELT(ans, i), ncases, IsUTF8mode()?mkCharCE(sValue,CE_UTF8):mkChar(sValue));
                        }
                    }
                }
                ++ncases;
                *cErr = NextCase();
            }
            *cErr = RemoveCaseCursor();
            if(*cErr != 0)
                goto error;
            if (N != ncases) {
                for (i = 0; i < nvar; ++i) {
                    SEXP elt = VECTOR_ELT(ans, i);
                    elt = lengthgets(elt, ncases);
                    SET_VECTOR_ELT(ans, i, elt);
                }
            }
            //setAttrib(ans, R_NamesSymbol, ans_names);
            delete []varIndices;
            delete []varTypes;
        }//end if(*cErr == 0)
        
    error:    
		int hasCursor=0;
		HasCursor(hasCursor);
		if(hasCursor)
			*cErr = RemoveCaseCursor();
        SEXP rErr;
        PROTECT(rErr = allocVector(INTSXP,1));
        INTEGER(rErr)[0] = *cErr;
        SET_VECTOR_ELT(ans, nvar, rErr);
        UNPROTECT(3);
        return ans;

    } 
    
    SEXP ext_GetSplitDataFromSPSS(SEXP procName, SEXP variables, SEXP bKeepUserMissing, SEXP bMissingValueToNA, SEXP bIsSkipOver, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);
        int keepUserMissing = INTEGER_VALUE(bKeepUserMissing);
        int missingValueToNA = INTEGER_VALUE(bMissingValueToNA);
        int isSkipOver = INTEGER_VALUE(bIsSkipOver);
        R_CHAR_STAR proc = STRING_VALUE(procName);

        //The last element in ans is for errLevel.;
        SEXP ans = PROTECT(allocVector(VECSXP, nvar+1));
        SEXP ans_names = PROTECT(allocVector(STRSXP, nvar));
    
        int i;
        int ncases = 0;
        int N = 10;
        double dValue;
        char *sValue;
        int isMissing;

        int *varIndices = new int[nvar];
        int *varTypes = new int[nvar];
        
        for (i = 0; i < nvar; ++i) {
            varIndices[i] = INTEGER_VALUE(VECTOR_ELT(variables,i));
            varTypes[i] = GetVariableType(varIndices[i],*cErr);
            if(*cErr !=0)
                goto error;
            const char* tmpStr = GetVariableName(varIndices[i],*cErr);
            if(*cErr != 0)
                goto error;
            SET_STRING_ELT(ans_names, i, IsUTF8mode()?mkCharCE(tmpStr,CE_UTF8):mkChar(tmpStr));
            
            if (0 == varTypes[i]) {
                SET_VECTOR_ELT(ans, i, allocVector(REALSXP, N));
            } else {
                SET_VECTOR_ELT(ans, i, allocVector(STRSXP, N));
            }
        }
        
        if(*cErr == 0){
            if( isSkipOver == 0 )
                *cErr = NextCase();
            while( 0 == *cErr) {
                if (ncases == N) {
                    N *= 2;
                    for (i = 0; i < nvar; ++i) {
                        SEXP elt = VECTOR_ELT(ans, i);
                        elt = lengthgets(elt, N);
                        SET_VECTOR_ELT(ans, i, elt);
                    }
                }
                for (i = 0; i < nvar; i++) {
                    if ( 0 == varTypes[i] ) {
                        *cErr = GetNumericValue(varIndices[i], dValue, isMissing);

                        if(*cErr != 0)
                            goto error;                        
                        //isMissing == 2 means this value is System_MissingValue.
                        //isMissing == 1 means this values is user missing value.
                        if(2 == isMissing || (1 == isMissing && 0 == keepUserMissing)){
                            if(missingValueToNA==0)
                                dValue = R_NaN;
                            else
                                dValue = R_NaReal;
                        }
                        REAL(VECTOR_ELT(ans, i))[ncases] = dValue;
                    }
                    else{
                        sValue = new char[varTypes[i] + 1];
                        memset(sValue,'\0',varTypes[i] + 1);
                        *cErr = GetStringValue(varIndices[i],sValue,varTypes[i],isMissing);

                        if(*cErr != 0)
                            goto error;                        
                        //isMissing == 1 means this values is user missing value.
                        if( 1 == isMissing && 0 == keepUserMissing ){
                            SET_STRING_ELT(VECTOR_ELT(ans, i), ncases, R_NaString);
                        }
                        else{
                            SET_STRING_ELT(VECTOR_ELT(ans, i), ncases, IsUTF8mode()?mkCharCE(sValue,CE_UTF8):mkChar(sValue));
                        }
                    }
                }//end for
                ++ncases;
                *cErr = NextCase();
            }//end while
            if (N != ncases) {
                for (i = 0; i < nvar; ++i) {
                    SEXP elt = VECTOR_ELT(ans, i);
                    elt = lengthgets(elt, ncases);
                    SET_VECTOR_ELT(ans, i, elt);
                }
            }
            //setAttrib(ans, R_NamesSymbol, ans_names);
            *cErr = SplitChange(proc);
            if(*cErr != 0)
                goto error;
            delete []varIndices;
            delete []varTypes;
        }//end if(*cErr == 0)
  error:
		SEXP rErr;
        PROTECT(rErr = allocVector(INTSXP,1));
        INTEGER(rErr)[0] = *cErr;
        SET_VECTOR_ELT(ans, nvar, rErr);
        UNPROTECT(3);        
        return ans;
    }
    
    SEXP ext_GetVarNames(SEXP variables, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);

        SEXP ans = PROTECT(allocVector(STRSXP, nvar+1));//The last element is for errLevel.
    
        int i, varIndex;
        for (i = 0; i < nvar && 0==*cErr; ++i) {
            varIndex = INTEGER_VALUE(VECTOR_ELT(variables,i));
            const char* tmpStr = GetVariableName(varIndex,*cErr);
            if(*cErr == 0)            
              SET_STRING_ELT(ans, i, IsUTF8mode()?mkCharCE(tmpStr,CE_UTF8):mkChar(tmpStr));
            else
              break;
        }

        SET_STRING_ELT(ans, nvar, asChar(errLevel));
        UNPROTECT(1);
        return ans;
    }
    
    SEXP ext_GetVarLabels(SEXP variables, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);

        SEXP ans = PROTECT(allocVector(STRSXP, nvar+1));//The last element is for errLevel.
    
        int i, varIndex;
        for (i = 0; i < nvar && 0==*cErr; ++i) {
            varIndex = INTEGER_VALUE(VECTOR_ELT(variables,i));
            const char* tmpStr = GetVariableLabel(varIndex,*cErr);
            if(*cErr == 0)
              SET_STRING_ELT(ans, i, IsUTF8mode()?mkCharCE(tmpStr,CE_UTF8):mkChar(tmpStr));
            else
              break;
        }

        SET_STRING_ELT(ans, nvar, asChar(errLevel));
        UNPROTECT(1);
        return ans;
    }
    
    SEXP ext_GetVarFormats(SEXP variables, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);

        SEXP ans = PROTECT(allocVector(STRSXP, nvar+1));//The last element is for errLevel.
    
        int i, varIndex;
        for (i = 0; i < nvar && 0==*cErr; ++i) {
            varIndex = INTEGER_VALUE(VECTOR_ELT(variables,i));
            const char* tmpStr = GetVariableFormat(varIndex,*cErr);
            if(*cErr == 0)
              SET_STRING_ELT(ans, i, IsUTF8mode?mkCharCE(tmpStr,CE_UTF8):mkChar(tmpStr));
            else
              break;
        }
        SET_STRING_ELT(ans, nvar, asChar(errLevel));
        UNPROTECT(1);
        return ans;
    }
    
    SEXP ext_GetVarMeasurementLevels(SEXP variables, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);

        SEXP ans = PROTECT(allocVector(STRSXP, nvar+1));//The last element is for errLevel.
    
        int i, varIndex;
        int measurementlevel;
        for (i = 0; i < nvar && 0==*cErr; ++i) {
            varIndex = INTEGER_VALUE(VECTOR_ELT(variables,i));
            measurementlevel = GetVariableMeasurementLevel(varIndex,*cErr);
            if(*cErr ==0)
            {
                if( 1 == measurementlevel )
                    SET_STRING_ELT(ans, i, IsUTF8mode()?mkCharCE("unknown",CE_UTF8):mkChar("unknown"));
                else if( 2 == measurementlevel )
                    SET_STRING_ELT(ans, i, IsUTF8mode()?mkCharCE("nominal",CE_UTF8):mkChar("nominal"));
                else if( 3 == measurementlevel )
                    SET_STRING_ELT(ans, i, IsUTF8mode()?mkCharCE("ordinal",CE_UTF8):mkChar("ordinal"));
                else if( 4 == measurementlevel )
                    SET_STRING_ELT(ans, i, IsUTF8mode()?mkCharCE("scale",CE_UTF8):mkChar("scale"));
                else
                    SET_STRING_ELT(ans, i, IsUTF8mode()?mkCharCE("error",CE_UTF8):mkChar("error"));
            }
            else
                break;    
        }
        SET_STRING_ELT(ans, nvar, asChar(errLevel));
        UNPROTECT(1);
        return ans;
    }
    
    SEXP ext_GetVarTypes(SEXP variables, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);

        SEXP ans = PROTECT(allocVector(INTSXP, nvar+1));//The last element is for errLevel.
    
        int i,varIndex;
        for (i = 0; i < nvar; ++i) {
            varIndex = INTEGER_VALUE(VECTOR_ELT(variables,i));
            INTEGER(ans)[i] = GetVariableType(varIndex,*cErr);
            if(*cErr !=0)
              break;
        }
        INTEGER(ans)[nvar] = *cErr;
        UNPROTECT(1);
        return ans;
    }
    
    SEXP ext_GetVarFormatTypes(SEXP variables, SEXP errLevel)
    {
        int nvar = LENGTH(variables);
        int *cErr = INTEGER(errLevel);

        SEXP ans = PROTECT(allocVector(INTSXP, nvar+1));//The last element is for errLevel.
    
        int i,varIndex;
        int formatType,formatWidth,formatDecimal;

        for (i = 0; i < nvar; ++i) {
            varIndex = INTEGER_VALUE(VECTOR_ELT(variables,i));
            *cErr = GetVariableFormatType(varIndex,formatType,formatWidth,formatDecimal);
            if(*cErr !=0)
              break;            
            INTEGER(ans)[i] = formatType;
        }

        INTEGER(ans)[nvar] = *cErr;
        UNPROTECT(1);
        return ans;
    }
    void ext_GetNumericValue(int* varIndex, double* result, int* isMissing, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = GetNumericValue(*varIndex, *result, *isMissing);
    }
    
    void ext_GetStringValue(int* varIndex, 
                            char** result, 
                            int* bufferLength, 
                            int* isMissing, 
                            int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
        {
            *result = (char*) R_alloc((*bufferLength)+1, sizeof(char));
            memset(*result,'\0',(*bufferLength)+1);
            *errLevel = GetStringValue(*varIndex, *result, *bufferLength, *isMissing);
        }
    }

    void ext_GetVarNMissingValues(int* varIndex, 
                                  int* missingFormat,
                                  double* v1, 
                                  double* v2, 
                                  double* v3,
                                  int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = GetVarNMissingValues(*varIndex, missingFormat, v1, v2, v3);
    }
    
    void ext_GetVarCMissingValues(int* varIndex, 
                                  int* missingFormat,
                                  char** v1, 
                                  char** v2, 
                                  char** v3,
                                  int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
        {
            int varType = GetVariableType(*varIndex, *errLevel);
            if( 0 == *errLevel )
            {
                assert(varType > 0);
                
                //Keep the same string length with that defined in XD:
                //Definition in XD: const int MissingValue::STR_MISSINGVALUE_LEN = sizeof(double);
                const int XD_STR_MISSINGVALUE_LEN = sizeof(double);
                char var1[XD_STR_MISSINGVALUE_LEN];
                char var2[XD_STR_MISSINGVALUE_LEN];
                char var3[XD_STR_MISSINGVALUE_LEN];
                memset(var1,'\0',XD_STR_MISSINGVALUE_LEN);
                memset(var2,'\0',XD_STR_MISSINGVALUE_LEN);
                memset(var3,'\0',XD_STR_MISSINGVALUE_LEN);

                *errLevel = GetVarCMissingValues(*varIndex, missingFormat, var1, var2, var3);

                int size = varType+1;
                *v1 = (char*) R_alloc(size, sizeof(char));
                *v2 = (char*) R_alloc(size, sizeof(char));
                *v3 = (char*) R_alloc(size, sizeof(char));
                memset(*v1,'\0',size);
                memset(*v2,'\0',size);
                memset(*v3,'\0',size);
                
                //For long string
                if(varType > XD_STR_MISSINGVALUE_LEN)
                {
                    //Pad with white space.
                    int padlen = varType - XD_STR_MISSINGVALUE_LEN;
                    char *pad = new char[padlen+1];
                    memset(pad,'\0',padlen+1);
                    memset(pad, ' ',padlen);
                    
                    strncpy(*v1,var1,XD_STR_MISSINGVALUE_LEN);
                    strncpy(*v2,var2,XD_STR_MISSINGVALUE_LEN);
                    strncpy(*v3,var3,XD_STR_MISSINGVALUE_LEN);
                    
                    strcat(*v1,pad);
                    strcat(*v2,pad);
                    strcat(*v3,pad);
                    
                    delete []pad;
                }
                else
                {
                    strncpy(*v1,var1,varType);
                    strncpy(*v2,var2,varType);
                    strncpy(*v3,var3,varType);
                }
            }
        }
    }

    SEXP ext_GetNValueLabels(SEXP index, SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();
        if( LOAD_SUCCESS == *cErr ){
            int* cIndex = INTEGER(index);
            double *values = 0;
            char **labels = 0;
            int numOfValues = 0;
            *cErr = GetNValueLabels(*cIndex,&values,&labels,&numOfValues);

            SEXP rValues;
            PROTECT(rValues = allocVector(REALSXP, numOfValues));
            if ( 0 == *cErr && numOfValues > 0 ){
                for( int i=0; i<numOfValues; ++i ){
                    REAL(rValues)[i] = values[i];
                }
            }

            SEXP rLabels;
            PROTECT(rLabels = allocVector(STRSXP, numOfValues));
            if ( 0 == *cErr && numOfValues > 0 ){
                for( int i=0; i<numOfValues; ++i ){

                    SET_STRING_ELT(rLabels, i, IsUTF8mode()?mkCharCE(labels[i],CE_UTF8):mkChar(labels[i]));
                }
            }
            
            SEXP rErr;
            PROTECT(rErr = allocVector(INTSXP,1));
            INTEGER(rErr)[0] = *cErr;

            PROTECT(result = allocVector(VECSXP, 3));

            SET_VECTOR_ELT(result,0,rValues);
            SET_VECTOR_ELT(result,1,rLabels);
            SET_VECTOR_ELT(result,2,rErr);
           
            UNPROTECT(4);
            *cErr = FreeNValueLabels(values,labels,numOfValues);
            assert(0 == *cErr);
        }
        return result;
    }
    
    SEXP ext_GetCValueLabels(SEXP index, SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            int* cIndex = INTEGER(index);
            char **values = 0;
            char **labels = 0;
            int numOfValues = 0;
        
            *cErr = GetCValueLabels(*cIndex,&values,&labels,&numOfValues);

            SEXP rValues;
            PROTECT(rValues = allocVector(STRSXP, numOfValues));
            if ( 0 == *cErr && numOfValues > 0 ){
                for( int i=0; i<numOfValues; ++i ){
                    SET_STRING_ELT(rValues, i, IsUTF8mode()?mkCharCE(values[i],CE_UTF8):mkChar(values[i]));
                }
            }

            SEXP rLabels;
            PROTECT(rLabels = allocVector(STRSXP, numOfValues));
            if ( 0 == *cErr && numOfValues > 0 ){
                for( int i=0; i<numOfValues; ++i ){
                    SET_STRING_ELT(rLabels, i, IsUTF8mode()?mkCharCE(labels[i],CE_UTF8):mkChar(labels[i]));
                }
            }
            
            SEXP rErr;
            PROTECT(rErr = allocVector(INTSXP,1));
            INTEGER(rErr)[0] = *cErr;

            PROTECT(result = allocVector(VECSXP, 3));
            SET_VECTOR_ELT(result,0,rValues);
            SET_VECTOR_ELT(result,1,rLabels);
            SET_VECTOR_ELT(result,2,rErr);
            
            UNPROTECT(4);
            *cErr = FreeCValueLabels(values,labels,numOfValues);
            assert(0 == *cErr);
        }
        return result;
    }

    void ext_GetVariableFormatType(int* varIndex, 
                                   int* formatType, 
                                   int* formatWidth,
                                   int* formatDecimal, 
                                   int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
            *errLevel = GetVariableFormatType(*varIndex, *formatType, *formatWidth, *formatDecimal);
    }


    void
        ext_GetCaseCount(
        int* caseNum,
        int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *caseNum = GetCaseCount(*errLevel);
        }
    }

    void
        ext_GetVariableCount(
        int* varNum,
        int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *varNum = GetVariableCount(*errLevel);
        }
    }

    void
        ext_GetVariableName(
        const char** name,
        int* index,
        int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *name = GetVariableName(*index,*errLevel);
            if(0 != *errLevel)
            {
                *name = "";
            }
        }
    }

    void
        ext_GetVariableLabel(
        const char** label,
        int* index,
        int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *label = GetVariableLabel(*index,*errLevel);
            if(0 != *errLevel)
            {
                *label = "";
            }
        }
    }

    void
        ext_GetVariableType(
        int* type,
        int* index,
        int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *type = GetVariableType(*index,*errLevel);
        }
    }

    void
        ext_GetVariableFormat(
        const char** format,
        int* index,
        int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *format = GetVariableFormat(*index,*errLevel);
            if(0 != *errLevel)
            {
                *format = "";
            }
        }
    }

    void
        ext_GetVariableMeasurementLevel(
        int* measurementLevel,
        int* index,
        int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *measurementLevel = GetVariableMeasurementLevel(*index,*errLevel);
        }
    }

    void ext_GetWeightVar(char** weightVar, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *weightVar = GetWeightVar(*errLevel);
            if(0 != *errLevel)
            {
                *weightVar = "";
            }
        }
    }

	void ext_SetRTempFolderToSPSS(char** tmpdir, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetRTempFolderToSPSS(*tmpdir);
        }
    }

    SEXP ext_GetVarAttributeNames(SEXP varIndex, SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            int index = INTEGER_VALUE(varIndex);
            int numOfNames = 0;
            char **name;
            *cErr = GetVarAttributeNames(index, &name, &numOfNames);

            PROTECT(result = allocVector(STRSXP, numOfNames+1));
            if ( 0 == *cErr && numOfNames > 0 ){
                for( int i=0; i<numOfNames; ++i ){
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(name[i],CE_UTF8):mkChar(name[i]));
                }
            }
            SET_STRING_ELT(result, numOfNames, asChar(errLevel));
            UNPROTECT(1);
            FreeAttributeNames(name,numOfNames);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }
    
    SEXP ext_GetVarAttributes(SEXP varIndex, SEXP attrName, SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            int index = INTEGER_VALUE(varIndex);
            R_CHAR_STAR name = STRING_VALUE(attrName);
            int numOfAttr = 0;
            char **attr;

            *cErr = GetVarAttributes(index, name, &attr, &numOfAttr);

            PROTECT(result = allocVector(STRSXP, numOfAttr+1));
            if ( 0 == *cErr && numOfAttr > 0 ){
                for( int i=0; i<numOfAttr; ++i ){
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(attr[i],CE_UTF8):mkChar(attr[i]));
                }
            }
            SET_STRING_ELT(result, numOfAttr, asChar(errLevel));
            UNPROTECT(1);
            FreeAttributes(attr,numOfAttr);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }

    SEXP ext_GetDataFileAttributeNames(SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            int numOfNames = 0;
            char **name;
            *cErr = GetDataFileAttributeNames(&name, &numOfNames);

            PROTECT(result = allocVector(STRSXP, numOfNames+1));
            if ( 0 == *cErr && numOfNames > 0 ){
                for( int i=0; i<numOfNames; ++i ){
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(name[i],CE_UTF8):mkChar(name[i]));
                }
            }
            SET_STRING_ELT(result, numOfNames, asChar(errLevel));
            UNPROTECT(1);
            FreeAttributeNames(name,numOfNames);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }
    
    SEXP ext_GetDataFileAttributes(SEXP attrName, SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            R_CHAR_STAR name = STRING_VALUE(attrName);
            int numOfAttr = 0;
            char **attr;

            *cErr = GetDataFileAttributes(name, &attr, &numOfAttr);

            PROTECT(result = allocVector(STRSXP, numOfAttr+1));
            if ( 0 == *cErr && numOfAttr > 0 ){
                for( int i=0; i<numOfAttr; ++i ){
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(attr[i],CE_UTF8):mkChar(attr[i]));
                }
            }
            SET_STRING_ELT(result, numOfAttr, asChar(errLevel));
            UNPROTECT(1);
            FreeAttributes(attr,numOfAttr);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }

    SEXP ext_GetSplitVariableNames(SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            //temp code
            void* cResult = GetSplitVariableNames(*cErr);
            //void* cResult = 0;
            //end temp code
            
            int size = GetStringListLength(cResult);

            PROTECT(result = allocVector(STRSXP, size+1));
            if ( 0 == *cErr && size > 0 && cResult != 0){
                for( int i=0; i<size; ++i ){
                    const char *str = GetStringFromList(cResult,i);
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(str,CE_UTF8):mkChar(str));
                }
            }
            SET_STRING_ELT(result, size, asChar(errLevel));
            UNPROTECT(1);
            RemoveStringList(cResult);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }

    SEXP ext_SetVarNameAndType(SEXP varNames, SEXP varTypes, SEXP errLevel)
    {
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
          int varNum = length(varNames);
          char ** names = new char *[varNum];
          int* types = new int[varNum];
          for( int i =0; i<varNum; ++i){
              R_CHAR_STAR varName = STRING_VALUE(VECTOR_ELT(varNames, i));
              names[i] = new char[strlen(varName)+1];
              memset( names[i], '\0', strlen(varName)+1 );
              strcpy( names[i], varName );
              types[i] = INTEGER_VALUE(VECTOR_ELT(varTypes, i));
          }
          *cErr = SetVarNameAndType(names, types, varNum);
          for( int i =0; i<varNum; ++i){
              delete []names[i];
          }
          delete []names;
          delete []types;
        }
        return errLevel;
    }

    void ext_AllocNewVarsBuffer(int* size, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = AllocNewVarsBuffer(*size);
        }
    }

    void ext_CommitHeader(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = CommitHeader();
        }
    }

    void ext_CreateXPathDictionary(const char** handle, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = CreateXPathDictionary(*handle);
        }
    }

    void ext_RemoveXPathHandle(const char** handle, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = RemoveXPathHandle(*handle);
        }
    }

    SEXP ext_GetHandleList(SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            void* cResult = GetHandleList(*cErr);
            int size = GetStringListLength(cResult);

            PROTECT(result = allocVector(STRSXP, size+1));
            if ( 0 == *cErr && size > 0 && cResult != 0){
                for( int i=0; i<size; ++i ){
                    const char *str = GetStringFromList(cResult,i);
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(str,CE_UTF8):mkChar(str));
                }
            }
            SET_STRING_ELT(result, size, asChar(errLevel));
            UNPROTECT(1);
            RemoveStringList(cResult);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }

    SEXP ext_EvaluateXPath(SEXP handle, SEXP context, SEXP xpath, SEXP errLevel)
    {
        SEXP result = R_NilValue;

        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            R_CHAR_STAR cHandle = STRING_VALUE(handle);
            R_CHAR_STAR cContext = STRING_VALUE(context);
            R_CHAR_STAR cXPath = STRING_VALUE(xpath);
            void* cResult = EvaluateXPath(cHandle,cContext,cXPath,*cErr);
            int size = GetStringListLength(cResult);

            PROTECT(result = allocVector(STRSXP, size+1));
            if ( 0 == *cErr && size > 0 && cResult != 0){
                for( int i=0; i<size; ++i ){
                    const char *str = GetStringFromList(cResult,i);
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(str,CE_UTF8):mkChar(str));
                }
            }
            SET_STRING_ELT(result, size, asChar(errLevel));
            UNPROTECT(1);
            RemoveStringList(cResult);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }
    
    void ext_StartDataStep( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = StartDataStep();
        }
    }
    
    void ext_EndDataStep( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = EndDataStep();
        }
    }
    
    void ext_CreateDataset(const char** name, int *isEmpty,int *hidden,int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            #ifdef HPUX64
            *errLevel = CreateDataset(*name,(bool)*isEmpty,(bool)*hidden);
            #else
            *errLevel = CreateDataset(*name,(const bool)*isEmpty,(const bool)*hidden);
            #endif
            
        }
    }
    
    void ext_CloseDataset(const char** name, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = CloseDataset(*name);
        }
    }
    
 
    SEXP ext_GetSpssDatasets( SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            char** nameList = 0;
            int length = 0;
            *cErr = GetSpssDatasets(&nameList,length);

            PROTECT(result = allocVector(STRSXP, length+1));
            if ( 0 == *cErr && length > 0 && nameList != 0){
                for( int i=0; i<length; ++i ){
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(nameList[i],CE_UTF8):mkChar(nameList[i]));
                }
            }
            SET_STRING_ELT(result, length, asChar(errLevel));
            UNPROTECT(1);
            FreeStringArray(nameList,length);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        
        return result;
    }
   
    SEXP ext_GetOpenedSpssDatasets( SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            char** nameList = 0;
            int length = 0;
            *cErr = GetOpenedSpssDatasets(&nameList,length);

            PROTECT(result = allocVector(STRSXP, length+1));
            if ( 0 == *cErr && length > 0 && nameList != 0){
                for( int i=0; i<length; ++i ){
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(nameList[i],CE_UTF8):mkChar(nameList[i]));
                }
            }
            SET_STRING_ELT(result, length, asChar(errLevel));
            UNPROTECT(1);
            FreeStringArray(nameList,length);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        
        return result;
    }

    void ext_InsertVariable(const char** dsName, const int* index,
                            const char** varName, const int* type, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = InsertVariable(*dsName,*index,*varName,*type);
        }
    }
    
    void ext_SetVarLabelInDS(const char** dsName, const int* index, 
                             const char** varLabel, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarLabelInDS(*dsName,*index,*varLabel);
        }
    }
    
    void ext_SetVarFormatInDS(const char** dsName,
                              const int* index,
                              const int* formatType,
                              const int* formatWidth,
                              const int* formatDecimal,
                              int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarFormatInDS(*dsName,*index,* formatType,* formatWidth,* formatDecimal);
        }
    }
    
    void ext_SetVarMeasurementLevelInDS(const char** dsName, const int* index, 
                                        const char** varMeasurement, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarMeasurementLevelInDS(*dsName,*index,*varMeasurement);
        }
    }
    
    void ext_SetVarNMissingValuesInDS(const char** dsName,
                                      const int* index,
                                      const int* missingFormat,
                                      const double* missingValue1,
                                      const double* missingValue2,
                                      const double* missingValue3,
                                      int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarNMissingValuesInDS(*dsName,*index,
                                                 * missingFormat,
                                                 * missingValue1,
                                                 * missingValue2,
                                                 * missingValue3);
        }
    }
    
    void ext_SetVarCMissingValuesInDS(const char** dsName,
                                      const int* index,
                                      const int* missingFormat,
                                      const char** missingValue1,
                                      const char** missingValue2,
                                      const char** missingValue3,
                                      int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarCMissingValuesInDS(*dsName,*index,
                                                 * missingFormat,
                                                 * missingValue1,
                                                 * missingValue2,
                                                 * missingValue3);
        }
    }
    
    SEXP ext_SetVarAttributesInDS(SEXP dsName,
                                  SEXP index,
                                  SEXP attrName,
                                  SEXP attributes,
                                  SEXP length,
                                  SEXP errLevel)
    {
        
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            int varIndex = INTEGER_VALUE(index);
            int size = INTEGER_VALUE(length);
            R_CHAR_STAR dataset = STRING_VALUE(dsName);
            R_CHAR_STAR varAttrName = STRING_VALUE(attrName);

            char ** varAttrs = new char*[size];
            for( int i =0; i<size; ++i){
                R_CHAR_STAR attr = STRING_VALUE(VECTOR_ELT(attributes, i));
                varAttrs[i] = new char[strlen(attr)+1];
                memset( varAttrs[i], '\0', strlen(attr)+1 );
                strcpy( varAttrs[i], attr);
            }
            *cErr = SetVarAttributesInDS(dataset,varIndex,varAttrName,varAttrs,size);

            for( int i =0; i<size; ++i){
                delete []varAttrs[i];
            }
            delete []varAttrs;
        }
        return errLevel;
    }
    
    SEXP ext_SetDataFileAttributesInDS(SEXP dsName,
                                  SEXP attrName,
                                  SEXP attributes,
                                  SEXP length,
                                  SEXP errLevel)
    {
        
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            int size = INTEGER_VALUE(length);
            R_CHAR_STAR dataset = STRING_VALUE(dsName);
            R_CHAR_STAR cAttrName = STRING_VALUE(attrName);

            char ** cAttrs = new char *[size];
            for( int i =0; i<size; ++i){
                R_CHAR_STAR attr = STRING_VALUE(VECTOR_ELT(attributes, i));
                cAttrs[i] = new char[strlen(attr)+1];
                memset( cAttrs[i], '\0', strlen(attr)+1 );
                strcpy(cAttrs[i], attr);
            }
            *cErr = SetDataFileAttributesInDS(dataset,cAttrName,cAttrs,size);

            for( int i =0; i<size; ++i){
                delete []cAttrs[i];
            }
            delete []cAttrs;
        }
        return errLevel;
    }
    
    void ext_SetVarNValueLabelInDS(const char** dsName,
                                   const int* index,
                                   const double* value,
                                   const char** label,
                                   int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarNValueLabelInDS(*dsName,*index, * value,* label );
        }
    }
    
    void ext_SetVarCValueLabelInDS(const char** dsName,
                                   const int* index,
                                   const char** value,
                                   const char** label,
                                   int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarCValueLabelInDS(*dsName,*index,* value,* label);
        }
    }
    
    void ext_InsertCase(const char** dsName,const long* rowIndex, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = InsertCase(*dsName,*rowIndex);
        }
    }
    
    void ext_SetNCellValue(const char** dsName,
                           const long* rowIndex,
                           const int* columnIndex,
                           const double* value,
                           int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetNCellValue(*dsName,*rowIndex,* columnIndex,* value);
        }
    }
    
    void ext_SetCCellValue(const char** dsName,
                           const long* rowIndex,
                           const int* columnIndex,
                           const char** value,
                           int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetCCellValue(*dsName,*rowIndex,* columnIndex,*value);
        }
    }

    SEXP ext_SetDataToSPSS(SEXP dsName, SEXP data, SEXP errLevel)
    {
        R_CHAR_STAR datasetName = STRING_VALUE(dsName);
        int *cErr = INTEGER(errLevel);
        int varNum = LENGTH(data);
        int *varTypes = new int[varNum];
        double systemMissing,dValue;
        int caseNum, i;
        char *sValue;
        SEXP elts;
        
        for( i=0; i<varNum; ++i)
        {
            varTypes[i] = GetVarTypeInDS(datasetName,i,*cErr);
        }
        
        *cErr = GetSystemMissingValue(systemMissing);
        caseNum = LENGTH(VECTOR_ELT(data, 0));
        for( i=0; i<caseNum; ++i)
        {
            *cErr = InsertCase(datasetName,i);
            if( 0 != *cErr )
                return errLevel;
            for(int j=0; j<varNum; ++j)
            {
                if( 0 == varTypes[j])
                {
                    elts = VECTOR_ELT(data, j);
                    if(!isNumeric(elts))
                        *cErr = NUMERIC_VARIABLE;
                    else
                    {   
                        if(IS_INTEGER(elts))
                            dValue = INTEGER(elts)[i];
                        else
                            dValue = REAL(elts)[i];
                        if(!R_finite(dValue))
                            dValue = systemMissing;
                        *cErr = SetNCellValue(datasetName,i,j,dValue);
                    }
                    if( 0 != *cErr )
                        return errLevel;
                }
                else
                {
                    elts = VECTOR_ELT(data, j);
                    if(!IS_CHARACTER(elts))
                        *cErr = STRING_VARIABLE;
                    
                    R_CHAR_STAR sVal = CHAR(STRING_ELT(elts, i));
                    if(strcmp(sVal,"NA")== 0){
                        *cErr = SetCCellValue(datasetName,i,j,"");
                    }
                    else{
                        sValue = new char[strlen(sVal)+1];
                        memset ( sValue, '\0', strlen(sVal)+1 );
                        strcpy(sValue, sVal);
                        *cErr = SetCCellValue(datasetName,i,j,sValue);
                        delete []sValue;
                    }
                    if( 0 != *cErr )
                        return errLevel;
                }
            }
        }
        //CommitDataInDS(datasetName, varTypes, varNum, caseNum );
        delete []varTypes;
        return errLevel;
    }
      
    void ext_SetActive( const char** dsName, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetActive(*dsName);
        }
    }

    void ext_GetVarTypeInDS(const char** dsName, const int* index, 
                            int* varType, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *varType = GetVarTypeInDS(*dsName,*index,*errLevel);
        }
    }
    
    void ext_GetVarNameInDS(const char** dsName, const int* index, 
                            const char** varName, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *varName = GetVarNameInDS(*dsName,*index,*errLevel);
            if(0 != *errLevel)
            {
                *varName = "";
            }
        }
    }
    
    void ext_GetVarCountInDS(const char** dsName,  
                             int* varCount, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *varCount = (int)GetVarCountInDS(*dsName,*errLevel);
        }
    }
    
    void ext_IsUTF8mode(int *mode)
    {
        int errLevel = LoadLib();
        if( LOAD_SUCCESS == errLevel ){
            *mode = IsUTF8mode();
        }
    }
    
    void ext_GetOutputLanguage(const char** olang, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel )
        {
            *olang = GetOutputLanguage(*errLevel);
            if(0 != *errLevel)
            {
                *olang = "";
            }
        }
    }    
    
    void ext_StartPivotTable(const char** outline,
                              const char** title,
                              const char** templateName,
                              int* isSplit,
                              int* errLevel)
    {
         *errLevel = LoadLib();
          if( LOAD_SUCCESS == *errLevel ){
              *errLevel = StartPivotTable(*outline,*title,*templateName,(bool)*isSplit);
          }
    }

    void ext_PivotTableCaption(const char** outline, 
                               const char** title,
                               const char** templateName, 
                               int* isSplit,
                               const char** caption, 
                               int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = PivotTableCaption(*outline,*title,*templateName,(bool)*isSplit,*caption);
        }
    }


    
    void ext_AddDimension(const char** outline, 
                          const char** title, 
                          const char** templateName,
                          int* isSplit,
                          const char** dimName,
                          int* place,
                          int* position,
                          int* hideName,
                          int* hideLabels,
                          int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = AddDimension(*outline,*title,*templateName,(bool)*isSplit,
                                          *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels);
        }
    }
 
    void ext_MinDataColumnWidth(const char **outline, 
                                const char **title, 
                                const char **templateName,
                                int *isSplit,
                                int *nMinInPoints,
                                int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = MinDataColumnWidth(*outline,*title,*templateName,(bool)*isSplit,*nMinInPoints);
        }
    }
 
    void ext_MaxDataColumnWidth(const char **outline, 
                                const char **title, 
                                const char **templateName,
                                int *isSplit,
                                int *nMaxInPoints,
                                int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = MaxDataColumnWidth(*outline,*title,*templateName,(bool)*isSplit,*nMaxInPoints);
        }
    }
 
    void ext_AddNumberCategory(const char** outline, 
                               const char** title, 
                               const char** templateName,
                               int* isSplit,
                               const char** dimName,
                               int* place,
                               int* position,
                               int* hideName,
                               int* hideLabels,
                               double* category ,
                               int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = AddNumberCategory(*outline,*title,*templateName,(bool)*isSplit,
                                          *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                          *category);
        }
    }

    void ext_AddStringCategory(const char** outline, 
                               const char** title, 
                               const char** templateName,
                               int* isSplit,
                               const char** dimName,
                               int* place,
                               int* position,
                               int* hideName,
                               int* hideLabels,
                               const char** category, 
                               int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = AddStringCategory(*outline,*title,*templateName,(bool)*isSplit,
                                          *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                          *category);
        }
    }
    
    void ext_AddVarNameCategory(const char** outline, 
                                 const char** title, 
                                 const char** templateName,
                                 int* isSplit,
                                 const char** dimName,
                                 int* place,
                                 int* position,
                                 int* hideName,
                                 int* hideLabels,
                                 int* category, 
                                 int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = AddVarNameCategory(*outline,*title,*templateName,(bool)*isSplit,
                                          *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                          *category);
        }
    }
 
    void ext_AddVarValueStringCategory(const char** outline, 
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
                                 int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = AddVarValueStringCategory(*outline,*title,*templateName,(bool)*isSplit,
                                          *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                          *category, *ch);
        }
    } 
    
    void ext_AddVarValueDoubleCategory(const char** outline, 
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
                                 int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = AddVarValueDoubleCategory(*outline,*title,*templateName,(bool)*isSplit,
                                          *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                          *category, *d);
        }
    }     
 
    void ext_SetNumberCell( const char** outline, 
                            const char** title, 
                            const char** templateName,
                            int* isSplit,
                            const char** dimName,
                            int* place,
                            int* position,
                            int* hideName,
                            int* hideLabels,
                            double* cellVal,
                            int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetNumberCell(*outline,*title,*templateName,(bool)*isSplit,
                                      *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                      *cellVal);
        }
    }
 
    void ext_SetStringCell( const char** outline, 
                            const char** title, 
                            const char** templateName,
                            int* isSplit,
                            const char** dimName,
                            int* place,
                            int* position,
                            int* hideName,
                            int* hideLabels,
                            const char** cellVal,
                            int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetStringCell(*outline,*title,*templateName,(bool)*isSplit,
                                      *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                      *cellVal);
        }
    }

    void ext_SetVarNameCell(const char** outline, 
                            const char** title, 
                            const char** templateName,
                            int* isSplit,
                            const char** dimName,
                            int* place,
                            int* position,
                            int* hideName,
                            int* hideLabels,
                            int* cell,
                            int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarNameCell(*outline,*title,*templateName,(bool)*isSplit,
                                      *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                      *cell);
        }
    }    
    
    void ext_SetVarValueStringCell(const char** outline, 
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
                            int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarValueStringCell(*outline,*title,*templateName,(bool)*isSplit,
                                      *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                      *cell,*ch);
        }
    }        
     
    void ext_SetVarValueDoubleCell(const char** outline, 
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
                            int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetVarValueDoubleCell(*outline,*title,*templateName,(bool)*isSplit,
                                      *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                      *cell,*d);
        }
    }      
    void ext_SetFormatSpecCoefficient(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecCoefficient();
        }
    }
    void ext_SetFormatSpecCoefficientSE( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecCoefficientSE();
        }
    }
    void ext_SetFormatSpecCoefficientVar( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecCoefficientVar();
        }
    }
    void ext_SetFormatSpecCorrelation( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecCorrelation();
        }
    }
    void ext_SetFormatSpecGeneralStat( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecGeneralStat();
        }
    }
    void ext_SetFormatSpecMean(int* varIndex, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecMean(*varIndex);
        }
    }    
    void ext_SetFormatSpecCount( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecCount();
        }
    }
    void ext_SetFormatSpecPercent( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecPercent();
        }
    }
    void ext_SetFormatSpecPercentNoSign( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecPercentNoSign();
        }
    }
    void ext_SetFormatSpecProportion( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecProportion();
        }
    }
    void ext_SetFormatSpecSignificance( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecSignificance();
        }
    }
    void ext_SetFormatSpecResidual( int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecResidual();
        }
    }
    void ext_SetFormatSpecVariable(int* varIndex, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecVariable(*varIndex);
        }
    } 
    void ext_SetFormatSpecStdDev(int* varIndex, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecStdDev(*varIndex);
        }
    } 
    void ext_SetFormatSpecDifference(int* varIndex, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecDifference(*varIndex);
        }
    } 
    void ext_SetFormatSpecSum(int* varIndex, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetFormatSpecSum(*varIndex);
        }
    }             
    SEXP ext_GetMultiResponseSetNames(SEXP errLevel)
    {
        SEXP result = R_NilValue;

        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            void* cResult = GetMultiResponseSetNames(*cErr);
            if( 0 == *cErr ){
                int size = GetStringListLength(cResult);
    
                PROTECT(result = allocVector(STRSXP, size+1));
                if ( size > 0 && cResult != 0){
                    for( int i=0; i<size; ++i ){
                        const char *str = GetStringFromList(cResult,i);
                        SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(str,CE_UTF8):mkChar(str));
                    }
                }
                SET_STRING_ELT(result, size, asChar(errLevel));
    
                UNPROTECT(1);
                RemoveStringList(cResult);
            }
            else{
                PROTECT(result = allocVector(STRSXP, 1));
                SET_STRING_ELT(result, 0, asChar(errLevel));
                UNPROTECT(1);
            }
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }
    
    SEXP ext_GetMultiResponseSet(SEXP mrsetName,SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            R_CHAR_STAR name = STRING_VALUE(mrsetName);
            char *label,*countedValue;
            int codeAs, type;
            void *elementVars;

            GetMultiResponseSet(name, &label, codeAs, &countedValue, type,&elementVars,*cErr);
            
            if(0 == *cErr){
                SEXP rLabel;
                PROTECT(rLabel = allocVector(STRSXP,1));
                SET_STRING_ELT(rLabel, 0, IsUTF8mode()?mkCharCE(label,CE_UTF8):mkChar(label));
                
                SEXP rCodeAs;
                PROTECT(rCodeAs = allocVector(INTSXP,1));
                INTEGER(rCodeAs)[0] = codeAs;
    
                SEXP rCountedValue;
                PROTECT(rCountedValue = allocVector(STRSXP,1));
                SET_STRING_ELT(rCountedValue, 0, IsUTF8mode()?mkCharCE(countedValue,CE_UTF8):mkChar(countedValue));
                
                SEXP rType;
                PROTECT(rType = allocVector(INTSXP,1));
                INTEGER(rType)[0] = type;
    
                SEXP rVars;
                int size = GetStringListLength(elementVars);
                PROTECT(rVars = allocVector(STRSXP, size));
                if ( size > 0 && elementVars != 0){
                    for( int i=0; i<size; ++i ){
                        const char *str = GetStringFromList(elementVars,i);
                        SET_STRING_ELT(rVars, i, IsUTF8mode()?mkCharCE(str,CE_UTF8):mkChar(str));
                    }
                }
    
                SEXP rErr;
                PROTECT(rErr = allocVector(STRSXP,1));
                SET_STRING_ELT(rErr, 0, asChar(errLevel));
    
                PROTECT(result = allocVector(VECSXP, 6));
                SET_VECTOR_ELT(result,0,rLabel);
                SET_VECTOR_ELT(result,1,rCodeAs);
                SET_VECTOR_ELT(result,2,rCountedValue);
                SET_VECTOR_ELT(result,3,rType);
                SET_VECTOR_ELT(result,4,rVars);
                SET_VECTOR_ELT(result,5,rErr);
    
                UNPROTECT(7);
                FreeString(label);
                FreeString(countedValue);
                RemoveStringList(elementVars);
            }
            else{
                SEXP rErr;
                PROTECT(rErr = allocVector(STRSXP,1));
                SET_STRING_ELT(rErr, 0, asChar(errLevel));

                PROTECT(result = allocVector(VECSXP, 1));
                SET_VECTOR_ELT(result,0,rErr);
                UNPROTECT(2);
            }
        }
        else{
            SEXP rErr;
            PROTECT(rErr = allocVector(STRSXP,1));
            SET_STRING_ELT(rErr, 0, asChar(errLevel));

            PROTECT(result = allocVector(VECSXP, 1));
            SET_VECTOR_ELT(result,0,rErr);
            UNPROTECT(2);
        }
        return result;
    }

    SEXP ext_SetMultiResponseSetInDS(SEXP dsName, 
                                     SEXP mrsetName,
                                     SEXP mrsetLabel,
                                     SEXP mrsetCodeAs,
                                     SEXP mrsetCountedValue,
                                     SEXP elemVarNames,
                                     SEXP errLevel)
    {
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            R_CHAR_STAR dataset = STRING_VALUE(dsName);
            R_CHAR_STAR cMrName = STRING_VALUE(mrsetName);
            R_CHAR_STAR cMrLabel = STRING_VALUE(mrsetLabel);
            R_CHAR_STAR cCountVal = STRING_VALUE(mrsetCountedValue);
            
            int code = INTEGER_VALUE(mrsetCodeAs);
            int numOfVars = LENGTH(elemVarNames);

            char ** cVars = new char *[numOfVars];
            for( int i =0; i<numOfVars; ++i){
                R_CHAR_STAR var = STRING_VALUE(VECTOR_ELT(elemVarNames, i));
                cVars[i] = new char[strlen(var)+1];
                memset( cVars[i], '\0', strlen(var)+1 );
                strcpy( cVars[i], var );
            }
            SetMultiResponseSetInDS(dataset,cMrName,cMrLabel,code,cCountVal,cVars,numOfVars,*cErr);

            for( int i =0; i<numOfVars; ++i){
                delete []cVars[i];
            }
            delete []cVars;
        }
        return errLevel;
    }


    void ext_GetGraphic( const char **fileName, int *errLevel )
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = GetGraphic(*fileName);
        }
    }

    void ext_GetSPSSLocale(char** localeVar, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *localeVar = GetSPSSLocale(*errLevel);
        }
    }
    
    void ext_GetCLocale(char** localeVar, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            * errLevel = GetCLocale(localeVar);            
        }
    }
    
    void ext_SetCLocale(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            char *xdlocale = 0;
            *errLevel = GetCLocale(&xdlocale);
            if ( xdlocale )
            {
                setlocale(LC_ALL, xdlocale);
            }
            FreeString( xdlocale );    
        }        
    }

    SEXP ext_GetFileHandles(SEXP errLevel)
    {
        SEXP result = R_NilValue;
        int* cErr = INTEGER(errLevel);
        *cErr = LoadLib();

        if( LOAD_SUCCESS == *cErr ){
            void* cResult = GetFileHandles(*cErr);
            int size = GetStringListLength(cResult);

            PROTECT(result = allocVector(STRSXP, size+1));
            if ( 0 == *cErr && size > 0 && cResult != 0){
                for( int i=0; i<size; ++i ){
                    const char *str = GetStringFromList(cResult,i);
                    SET_STRING_ELT(result, i, IsUTF8mode()?mkCharCE(str,CE_UTF8):mkChar(str));
                }
            }
            SET_STRING_ELT(result, size, asChar(errLevel));
            UNPROTECT(1);
            RemoveStringList(cResult);
        }
        else{
            PROTECT(result = allocVector(STRSXP, 1));
            SET_STRING_ELT(result, 0, asChar(errLevel));
            UNPROTECT(1);
        }
        return result;
    }

    void ext_SetOutputLanguage(const char **lang, int *errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            SetOutputLanguage(*lang, *errLevel);
        }
    }
    
    void ext_SetDateCell( const char** outline, 
                            const char** title, 
                            const char** templateName,
                            int* isSplit,
                            const char** dimName,
                            int* place,
                            int* position,
                            int* hideName,
                            int* hideLabels,
                            const char** cellVal,
                            int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetDateCell(*outline,*title,*templateName,(bool)*isSplit,
                                      *dimName,*place,*position,(bool)*hideName,(bool)*hideLabels,
                                      *cellVal);
        }
    }
    
    void ext_SetRecordBrowserOutput( const char** filePath,int* isRecord,int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ) {
            *errLevel = SetRecordBrowserOutput(*filePath,(bool)*isRecord);
        }
    }
    
    void ext_TransCode(const char** dest, const char** orig, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *dest = TransCode(*orig,*errLevel);
            if(0 != *errLevel)
            {
                *dest = "";
            }
        }
    }
    
    void ext_SetGraphicsLabel(const char** displaylabel, const char** invariantdisplaylabel, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = SetGraphicsLabel(*displaylabel,*invariantdisplaylabel);            
        }
    }
    
    //===================new APIs in 23.0=======================
    void ext_StartSpss(const char** commandline, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = StartSpss(*commandline);
        }
    }
    
    void ext_StopSpss(int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            StopSpss();
            FreeLib();
        }
    }
    
    void ext_IsBackendReady(int* isReady)
    {
        if(NULL == IsBackendReady) {
            *isReady = 0;
        } else {
            *isReady = IsBackendReady();
        }
        
    }
    
    void ext_IsXDriven(int* isXdrive)
    {
        int errCode = LoadLib();
        if (LOAD_SUCCESS == errCode) {
            *isXdrive = IsXDriven();
        } else {
            *isXdrive = 1;
        }
    }
    
    void ext_Submit(const char** command, int* length, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = Submit(*command, *length);
        }
    }
    
    void ext_QueueCommandPart(const char** command, int* length, int* errLevel)
    {
        *errLevel = LoadLib();
        if( LOAD_SUCCESS == *errLevel ){
            *errLevel = QueueCommandPart(*command, *length);
        }
    }
    
    
    
///////////////////////===============================================
    void 
        R_init_RInvokeSpss(DllInfo *info)
    {
        R_registerRoutines(
            info,
            cMethods,
            callMethods,
            0,
            0
            );
        LoadLib();
    }

    void
        R_unload_RInvokeSpss(DllInfo *info)
    {
        FreeLib();
        return;
    }
}
