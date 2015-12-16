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

<!-- hide scripts from silly old browsers

///////////////////////////////////////////////////////////////////////////////
//                Localizable strings                                        //
///////////////////////////////////////////////////////////////////////////////

var stb_topics_found = "Topics Found";
var stb_select_a_topic = "Select a Topic:";
var stb_fts_no_matches = "No matches";
var stb_fts_contents = "Contents";
var stb_fts_index = "Index";
var stb_fts_search = "Search";
var stb_fts_search_terms = "Search term(s):";
var stb_print_many_confirm = "Print the selected topic and all subtopics?";
var stb_close_popup = "Close popup window";
var stb_expand = "Expand";
var stb_collapse = "Collapse";
var stb_page = "Page";
var stb_fts_search_fulltext = "Full text";  // context is search tab option
var stb_fts_search_keywords = "Keywords only"; // ditto
var stb_fts_loading_index = "Loading index data "; // preserve the space (word separator) at the end
var stb_fts_loading_ftsdata = "Loading full text search data "; // preserve the space (word separator) at the end

///////////////////////////////////////////////////////////////////////////////
//                End localizable strings                                    //
///////////////////////////////////////////////////////////////////////////////

//Smuggler help navigation

function smartLink(targetList) {
//handle links with multiple targets.
//targets are passed as items in a targetList array
//with the URL for each target followed by its title
//thus a single target the value of targetList would be "['myURL.htm', 'My Title']"
//
//CH: updated 2/2002 to handle modules; each entry now has 3 items: URL, title, and module name
	
  //In the case of a single target, just go there
  if (targetList.length <= 4) { //4 'cuz the array may end with an extra comma if written by a stylesheet
    // don't need to check for module because the entire link should be
    // hidden if the link is in a missing module
    parent.topic.location.href=targetList[0];

  //If multiple targets are specified, list the topics so the user can choose
  } else {
  

    var newContent = "<HTML><HEAD>\n";
    newContent += "<SCRIPT type=\"text/javascript\" src=\"helploc.js\"></SCRIPT>\n";
    newContent += "<TITLE>" + stb_topics_found + "</TITLE>\n</HEAD>\n";
    newContent += '<BODY><H1 style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:x-small; font-weight:bold;">' + stb_select_a_topic + '</H1>\n';

      for(var i = 0; i < targetList.length; i+=3) {
        if (targetList[i] != null) {
          if (!modules_defined || targetList[i+2]=="" || eval(targetList[i+2])) {
            newContent += '<div style="display:block; font-family:Verdana; font-size:x-small; margin-top:4px">'
            newContent += '<A href="' + targetList[i] + '">' + targetList[i+1] + "</A><BR>"
            newContent += '</div>\n'
          }
        }
      }

    newContent += "</BODY>\n</HTML>";
    parent.topic.document.write(newContent);
    parent.topic.document.close(); //close layout stream
  }
}


function smartLinkNF(targetList) {
//version of smartLink customized to handle "no frame" implementation of web help.
//basically this means we pipe output to a layer rather than a frame.
	
	//In the case of a single target, just go there
	if (targetList.length <= 3) { //3 'cuz the array may end with an extra comma if written by a stylesheet
		parent.location.href=targetList[0];

	//If multiple targets are specified, list the topics so the user can choose
	} else {
	

		var newContent = "<HTML><HEAD>\n";
		newContent += "<TITLE>" + stb_topics_found + "</TITLE>\n</HEAD>\n";
		newContent += '<div class="topicblock"><H1 style="font-family:Verdana; font-size:x-small; font-weight:bold; color:008080">' + stb_select_a_topic + '</H1>\n';

			for(var i = 0; i < targetList.length; i+=2) {
				if (targetList[i] != null) {
					newContent += '<div style="display:block; font-family:Verdana; font-size:x-small; margin-top:4px">'
					newContent += '<A href="' + targetList[i] + '">' + targetList[i+1] + "</A><BR>"
					newContent += '</div>\n'
				}
			}

		newContent += "</div>\n</HTML>";
		parent.document.write(newContent);
		parent.document.close(); //close layout stream
	}
}



// end hiding scripts from silly old browswers -->
