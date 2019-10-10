\name{extension}
\title{Functions for creating R extension commands in IBM SPSS Statistics}
\alias{extension}
\alias{spsspkg.Syntax}
\alias{spsspkg.Template}
\alias{spsspkg.processcmd}
\description{
  Functions for creating R extension commands in IBM® SPSS® Statistics.
}
\usage{
spsspkg.processcmd(oobj,myArgs,f="",excludedargs=NULL,lastchancef = NULL, vardict=NULL)
spsspkg.Template(kwd, subc="", var=NULL, ktype="str", islist=FALSE,vallist=list())
spsspkg.Syntax(templ)
}
\arguments{
  \item{oobj}{A value returned by the Syntax function. It contains all of the 
    information needed to parse the values passed to the Run function associated 
    with an extension command.
    }
  \item{myArgs}{The argument myArgs should be specified as:
    \code{myArgs = args[[2]]}
    where args is the argument passed to the Run function. myArgs contains the run-time 
    values of the keywords associated with the extension command. 
    }
  \item{f}{The name of a function that implements the extension command. 
    }
  \item{excludedargs}{An optional list of arguments to be ignored when checking for
    arguments required by the implementation function f.
    }
  \item{lastchancef}{An optional function that will be called just before executing the 
    command and passed the parsed parameters object.
    }
  \item{vardict}{A variable dictionary to be passed to the parser for variable validation. 
    }
  \item{kwd}{The name of the keyword (in uppercase) as it appears in the
    command syntax for the extension command. 
    }
  \item{subc}{The name of the subcommand in uppercase that contains the keyword. 
    If the keyword belongs to the anonymous subcommand, the argument can be omitted 
    or set to the empty string. The anonymous subcommand is an unnamed subcommand
    (there can be only one per extension command) and is used to handle keywords that 
    are not part of an explicit subcommand. 
    }
  \item{var}{The name of the R variable that receives the value specified for the
    keyword. If var is omitted, the lowercase value of kwd is used.  
    }
  \item{ktype}{The type of keyword, such as whether the keyword specifies a variable name, 
    a string, or a floating point number. The following values are allowed:
    
    \emph{bool}: Accepts values of true, false, yes, or no and converts them into the corresponding
    boolean values of TRUE or FALSE. If the keyword is declared as LeadingToken in the XML
    specification of the extension command and treated as bool here, then the presence or 
    absence of the keyword maps to TRUE or FALSE.
    
    \emph{str}: A string or quoted literal or list of either. Values are always converted to lower 
    case. You can use the vallist argument to specify a set of allowed values.
    
    \emph{int}: An integer or list of integers with optional range constraints that you can specify 
    in the vallist argument.
    
    \emph{float}: A real number or list of real numbers with optional range constraints that you can
    specify in the vallist argument.
    
    \emph{literal}: An arbitrary string or list of strings with no case conversion or validation.
    
    \emph{varname}: An arbitrary, unvalidated variable name (or syntactical equivalent such as a dataset
    name) or list of variable names with no case conversion.
    
    \emph{existingvarlist}: A list of variable names that are validated against the variables in the 
    active dataset. Set islist to TRUE when using existingvarlist. Supports the IBM SPSS Statistics TO 
    and ALL keywords for variable lists. To use TO and ALL, specify the associated keyword as
    parameter type TokenList in the XML specification for the extension command.
    }
  \item{islist}{A boolean (TRUE or FALSE) specifying whether the keyword contains a list 
    of values. The default is FALSE.
    }
  \item{vallist}{An R list, specifying a set of allowed values. For a keyword of type str,
    values are checked in uppercase. For keywords of types int and float, vallist is a 2-element
    list specifying the lower and upper bounds of the range of allowed values. To specify only
    an upper bound, use a lower bound of -Inf. To specify only a lower bound, use an upper bound 
    of Inf.
    }
  \item{templ}{A list of TemplateClass objects, created with the spsspkg.Template function. 
    The list should include a TemplateClass object for each possible keyword associated 
    with the syntax for the extension command.
    }
}
\value{
}
\details{
spsspkg.processcmd parses the values passed to the Run function associated with an extension 
command, and executes the implementation function.

spsspkg.Template creates the template for a specified keyword associated with the syntax for 
an extension command. The template for a keyword specifies the details needed to process the 
value (of this keyword) passed to the Run function. The result is a TemplateClass object for 
use with the Syntax function.  

Any default values for the keyword are specified in the signature of the implementation function named in the call to spsspkg.processcmd.  If a parameter has no default value and the user input does not specify a value, the procedure is stopped and an error message is issued.

spsspkg.Syntax validates values passed to the Run function of an extension command,
according to the specified template.
}
\references{
}
\seealso{
  \code{\link{spsspkg.helper}},
  \code{\link{external}},
  \code{\link{spssdata}},
  \code{\link{spssdictionary}},
  \code{\link{spsspkg}},
  \code{\link{spsspivottable}},
  \code{\link{spssRGraphics}},
  \code{\link{spssxmlworkspace}},
  \code{\link{TextBlock}}
}
\examples{
Consider an extension command named MYCOMMAND with the following syntax chart:
MYCOMMAND VARIABLES=variable list
[/OPTIONS [MISSING={LISTWISE*}] ]
{FAIL }

The associated specification for the spsspkg.Syntax function is:
oobj<-spsspkg.Syntax(templ=list(
spsspkg.Template("VARIABLES",subc="",var="vars",ktype="existingvarlist",islist=TRUE),
spsspkg.Template("MISSING",subc="OPTIONS",var="missing",ktype="str")
))
Note: The spsspkg.Syntax function is used in conjunction with the implementation code for
an extension command implemented in R. Specifically, it is for use in the Run function that implements the extension
command.

© Copyright IBM Corp. 1989, 2015
}
\keyword{classes}
\keyword{methods}
