#############################################
# IBM® SPSS® Statistics - Essentials for R
# (c) Copyright IBM Corp. 1989, 2013
#
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License version 2 as published by
#the Free Software Foundation.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License version 2
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA.
#############################################

#define the VariableDict class
#the type for variable dictionary of Statistics 
setClass("VariableDictClass",representation(safe="logical",keys="list",numvars="integer"))

##defind the constructor method for VariableDict class
##define the constructor method
##templ will be an object of Template class
setMethod("initialize","VariableDictClass",function(.Object,namelist=NULL,safe=FALSE,variableType=NULL,variableLevel=NULL) {    
    match = makeVariableFilter(pattern, variableType, variableLevel)  
})

##retun the first value in the list
getvalue <- function(value,islist)
{
    if(islist) {
        return(list(value))
    } else {
        if(length(value) > 0) return(value[[1]])
        else return(list())
    }
}


GetVarNames<-function()
{
    varNames<-list()
    varCount <- spssdictionary.GetVariableCount()       
    for(i in 0:(varCount-1))
    {
        varNames <- append(varNames,spssdictionary.GetVariableName(i))
        
    }
    return(varNames)
}

##
getvarlist <- function(value, islist, vardict) 
{
    varNames<-list()
    allVarNames <- GetVarNames()
	if(!islist) {
        if(length(value) > 1)
        {
            stop("More than one variable specified where only one is allowed")
        }
        else if(length(value) == 1) 
        {            
            if(tolower(value[[1]]) == "all" )
            {
                ##deal with ALL option
                varNames<-allVarNames
            }
            else
            {
                varNames<-value
            }            
        }
        else
        {
            stop("Needs to input one varibale.")
        }
    }	
	else 
    {            
        isUnicodeOn <- .C("ext_IsUTF8mode",as.logical(FALSE),PACKAGE=spss_package)[[1]]      
        for(i in 1:length(value))
        {
            tempS <- value[[i]]
            ##if(isUnicodeOn && ("windows" == .Platform$OS.type))
            ##    tempS <- iconv(tempS,to="UTF-8")
            if(tempS %in% allVarNames)
            {                
                varNames <- append(varNames,tempS)
            }
            else if(tolower(value[[i]]) == "to")
            {
                start = match(value[[i-1]],allVarNames)+1
                end = match(value[[i+1]],allVarNames) - 1     
                if(start > end) 
                    continue            
                varNames <- append(varNames,allVarNames[start:end])
            }
            else
            {
                stop(paste("invalid variable name: ",value[[i]],sep=""))
            }
            
        }		
    } 
    if(length(varNames) > 1) return(list(varNames))
    else return(varNames)
}

##find a postion for character in a string
findCharPos<-function(str,ch)
{    
    strLen <- nchar(str)
    strVec <- substring(str,1:strLen,1:strLen)
    r<-c()
    for(i in 1:length(strVec)) if(ch == strVec[i]) r<-append(r,i)
    return(r)
}


##a utility method to convert a format string to be double
floatex<-function(value,format=NULL)
{
    result<-tryCatch(as.double(value),warning=function(ex) {
        if(is.character(format) && nchar(format) > 0 && format=="#.#") {
            value=sub(",",".",value)
            return(as.double(value))  
        }
        lastdot <- findCharPos(value,".")
        lastdot <- lastdot[length(lastdot)]
        lastcomma = findCharPos(value,",")
        lastcomma <- lastcomma[length(lastcomma)]        
        if(length(lastcomma) > 0 && length(lastdot) > 0) {
            if(lastcomma > lastdot) {
                value<-sub(".","",value)
                value<-sub(",",".",value)  
            } else if(lastdot > lastcomma) {
                while(TRUE) {
                    value<-sub(",","",value)
                    v<-grep(",",value)
                    if(length(v) == 0) {
                        break
                    } 
                }
            }
        }
        value<-sub(",",".",value)
        result<-tryCatch({as.double(value)}, 
                    warning=function(ex) {
                        vData<-substring(value,1:nchar(value),1:nchar(value))                        
                        v<-""
                        digit<-c("0","1","2","3","4","5","6","7","8","9")
                        symbol<-c("-", ".", "+", "e","E", "/")
                        for(d in vData)  if(d %in% digit || d %in% symbol) v<-paste(v,d,sep="")
                        return(as.double(v))
                        }
                )
        return(result)
        }
    )
    result
}

##This is entry point for the end user to use the extension feature.
spsspkg.processcmd<-function(oobj,myArgs,f="",excludedargs=NULL, lastchancef = NULL, vardict=NULL)
{          
    oobj<-parsecmd(oobj,myArgs,vardict=vardict)
    ##get the arguments of f method
    args = formalArgs(f)
    if(length(excludedargs) > 0) {
        for(item in excludedargs) {
            index<-grep(item,args)
            args<-args[-index]
        }
    }
    fArgs = formals(f)
    argNames=names(fArgs)
    omittedArgs<-c()
    for(i in 1:length(fArgs)) {
        item<-fArgs[[i]]
        if(missing(item)) { ##to test whether a value was specified as an argument to a function. 
            if(!(argNames[i] %in% names(oobj@parsedparams)))
            {
                if(is.null(omittedArgs)) omittedArgs<-c(argNames[i])
                else omittedArgs<-append(omittedArgs,argNames[i])
            }
        }        
    }
    if(length(omittedArgs) > 0) {
        stop(paste("The following required parameters were not supplied:",
            paste(omittedArgs, collapse=", "), collapse=""))
    }
    ##call the extension procedure, end user need to implement the f method.
    return(do.call(f,oobj@parsedparams))
}

#define the Syntax class
setClass("SyntaxClass",representation(parsedparams="list",unicodemode="logical",unistr="character",subcdict="list"))

##define the constructor method
##templ will be an object of Template class
setMethod("initialize","SyntaxClass",function(.Object,templ) {    
    .Object@unicodemode = FALSE
    .Object@subcdict=list()
    tempList=list()
    for(t in templ)
    {
        subcNames = names(tempList)
        ##the object related with the sub command.
        tempSubc=tempList[[t@subc]]
        ##if there is not a sub command object, create it. 
        if(is.null(tempSubc) || length(tempSubc) == 0) {
            tempSubc=list()            
        } 
        ##connect the kwd with template calss object
        tempSubc[[t@kwd]]=t        
        tempList[[t@subc]]=tempSubc
    }
    .Object@subcdict = tempList
    .Object@parsedparams = list()
    .Object
})

##declare parsecmd method for Syntax class
setGeneric("parsecmd",function(object,cmd,vardict=NULL) {standardGeneric("parsecmd")})

##define the parsecmd method
setMethod("parsecmd","SyntaxClass",function(object,cmd,vardict=NULL) {
    for(sc in names(cmd)) {
        ##get the value of sub command.
        p = cmd[sc]    
        if(length(p[[1]]) > 0)
        {    
            for(i in 1:length(p[[1]])) {
                if(is.character(names(p[[1]])) && names(p[[1]]) == "TOKENLIST") 
                {
                    object<-parseitem(object,sc,p[[1]],vardict)
                }
                else  object<-parseitem(object,sc,p[[1]][[i]],vardict)           
            }
        }
    } 
    ##If there is bool type and doesn't be parsed, the default value will be FALSE
    parsedVarName <- names(object@parsedparams)
    templNum <- length(object@subcdict)
    if(templNum > 0)
    {
        for(i in 1:templNum)
        {
            varNames<-names(object@subcdict[[i]])
            for(j in 1:length(varNames))
            {
                t<-object@subcdict[[i]][varNames[j]]                
                t1<-t[[1]]
                if((! t1@var %in% parsedVarName) && t1@ktype == "bool" && tolower(t1@var) == "leadingtoken")
                {                    
                    object@parsedparams[t1@var] = FALSE                                            
                }
            }
        }
    }
       
    object    
})

##set the parseitem to be generic function. so it will be added to be member method for SyntaxClass. 
setGeneric("parseitem",function(object,subc, item, vardict=NULL) standardGeneric("parseitem"))

##define the parseitem method
setMethod("parseitem","SyntaxClass", function(object,subc,item, vardict=NULL) {
    key <- names(item)[[1]]
    tempValue <- item[key]
	if(key == "TOKENLIST") 
    {
        key = " "   #tokenlists are anonymous, i.e., they have no keyword
        value <- tempValue$TOKENLIST
    } 
    else 
    {        
        value <- tempValue[[1]]
    }

	if(length(object@subcdict) > 0)
	{
         myNames= names(object@subcdict)
         if(subc %in% myNames) {
            kw <- object@subcdict[[subc]][[key]]  # template for this keyword
         } else {
            stop(paste("A keyword was used that is defined in the extension xml for this command but not in the extension module Syntax definition:",subc))
        }    
    } else {
        stop(paste("A keyword was used that is defined in the extension xml for this command but not in the extension module Syntax definition:",subc))
    }
        
	if(kw@ktype %in% list("bool", "str")) {
		value <- tolower(value)
		if(length(kw@vallist) > 0) {
			for(v in value) {
				if(!(v %in% kw@vallist)) {
                    errMsg <- "Invalid value for keyword:"
                    errMsg <- paste(errMsg,key)
                    errMsg <- paste(errMsg,":",sep="")
                    errMsg <- paste(errMsg,v,sep="")
					stop(errMsg)
				}
			}
		}
		if(kw@ktype == "str") {
			object@parsedparams[kw@var] <- getvalue(value, kw@islist)
		} else {
		    if(length(value) == 0) ##the BOOL type has no input value. So the default will be TRUE.
		    {
		        object@parsedparams[kw@var] <- TRUE
		    }
		    else
		    {
		        object@parsedparams[kw@var] <- getvalue(value, kw@islist) %in% list("true", "yes", NULL)
    			if(is.null(unlist(object@parsedparams[kw@var]))) 
    			{
    			    object@parsedparams[kw@var] = TRUE	
    			}		       
		    }		    			
			
		}
	} else if(kw@ktype %in% list("varname", "literal")) {
        object@parsedparams[kw@var] <- getvalue(value, kw@islist)        
	} else if(kw@ktype %in% list("int", "float")) {
		if(kw@ktype == "int") {
			value <- as.integer(value)
		} else {
            value <- as.double(value)
		}
		for(v in value) {
			if (!(kw@vallist[[1]] <= v && v <= kw@vallist[[2]])) {
                errMsg <- "Value for keyword:"
                errMsg <- paste(errMsg,kw@kwd)
                errMsg <- paste(errMsg,"is out of range")
				stop(errMsg)
			}
		}
		object@parsedparams[kw@var] = getvalue(value, kw@islist)
	} else if(kw@ktype %in% list("existingvarlist")) {
		object@parsedparams[kw@var] = getvarlist(value, kw@islist, vardict)
	}
	object
})


##return a SyntaxClass definition. The caller can create an object of the SyntaxClass.
getSyntaxClass <- function()
{
    return(getClass("SyntaxClass"))
}

##define the Tempalte class
setClass("TemplateClass",representation(kwd="character",var="character",ktype="character",subc="character",vallist="list",islist="logical"))

##define the contructor function, when call new(...), the initialize will be called.
setMethod("initialize","TemplateClass",function(.Object, kwd, subc="", var=NULL, ktype="str", islist=FALSE,vallist=list()) {
    ktypes <- list("bool", "str", "int", "float", "literal", "varname", "existingvarlist")
    if(!(ktype %in% ktypes))
    {
        errMsg <- "option type must be in Template ktypes:"
        for(v in ktypes) errMsg <- paste(errMsg,v)
        stop(errMsg)
    }		
    if(is.null(var) || var == "") 
    {   
        if(kwd == "") stop("if kwd is '', var must be specified.")
        else var <- tolower(kwd)
    }
        
    ##trim the leading and trailing space of the kwd. 
    myKwd <- gsub("(^ +)|( +$)", "", kwd)
    if(myKwd == "")
    {
        ##R doesn't support the empty string to be a key. So change the empty to be one space string
        kwd <- " ";
    }
    ##trim the leading and trailing space of the subc. 
    mySubc <- gsub("(^ +)|( +$)", "", subc)
    if(mySubc == "")
    {
        ##R doesn't support the empty string to be a key. So change the empty to be one space string
        subc <- " ";
    }
	.Object@ktype = ktype
	.Object@kwd = kwd
	.Object@subc = subc
    .Object@var = var
	.Object@islist = islist
	.Object@vallist = vallist

	if (ktype == "bool" && (is.null(.Object@vallist) || length(.Object@vallist) == 0))
    {
		.Object@vallist <- list("true", "false", "yes", "no")
    }
	else if(ktype %in% list("int","float"))
    {
		if(ktype == "int")
        {
			.Object@vallist=list(-2**31+1, 2**31-1)
        }
		else
        {
			.Object@vallist = list(-1e308, 1e308)
        }   
		if(length(vallist) == 1)
        {
			.Object@vallist[[1]] = vallist[[1]]
        }
		else if(length(vallist) == 2)
        {
			if(!is.null(vallist[[1]]))
            {
				.Object@vallist[[1]] = vallist[[1]]
            }
			.Object@vallist[[2]] = vallist[[2]]
        }
    }
    .Object
    })

## set hte parseA as generic function, so it will be added to be member method for TemplateClass
setGeneric("parseA",function(object,item) {standardGeneric("parseA")}) #,PACKAGE=spss_package

##define the parse function
setMethod("parseA","TemplateClass",function(object,item) {
		key=names(item[[1]])
        tempValue=item[[1]]
        value=tempValue[[1]][[1]]
        if(key == "TOKENLIST") key=""
        key
		})
		
##return the TemplateClass defintion. The caller will create a object of the TemplateClass.
getTemplateClass <- function() {
    return(getClass("TemplateClass"))
}  

checkrequiredparams <- function(implementingfunc, params, exclude=NULL)
{
    args = formalArgs(f)
    if(length(exclude) > 0 ) {
        for(item in exclude) {
            index<-grep(item,args)
            args<-args[-index]
        }
    }
    
    fArgs = formals(f)
    argNames=names(fArgs)
    omittedArgs<-c()
    for(i in 1:length(fArgs)) {
        item<-fArgs[[i]]
        if(missing(item)) {
            if(!(argNames[i] %in% oobj@parsedparams))
            {
                omittedArgs<-append(omittedArgs,argNames[i])
            }
        }        
    }
    if(length(omittedArgs) > 0) {
        missingArgsErr<-"The following required parameters were not supplied: "
        for(i in 1:length(omittedArgs)) paste(missingArgsErr,omittedArgs[i],sep=",")
        stop(missingArgsErr)
    }

}

##create a new Template object
##   kwd -- 
##   subc -- the sub command in the Satistics Syntax
##   
spsspkg.Template <-function(kwd, subc="", var=NULL, ktype="str", islist=FALSE,vallist=list())
{
    myTemplate<-getTemplateClass()    
    ##create a Tempalte class object and return it.
    return(new(myTemplate,kwd, subc, var, ktype, islist,vallist))
}

##create a new Syntax object
##   templ -- the Template class object.
spsspkg.Syntax <- function(templ)
{
    ##get the Syntax class definition
    mySyntax<-getSyntaxClass()
    ##create the Syntax class object 
    return(new(mySyntax,templ))
}



