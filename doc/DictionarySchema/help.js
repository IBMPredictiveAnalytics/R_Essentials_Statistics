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

//This file contains functions used by online help.
//Note: Functions containing localizable text are stored in helploc.js.

/* Following collection of functions are used to display help in a frameset,
with an index and/or toc in the left frame, and topics on the right.
Ordinary html links can be used to launch a frameset, but not to specify
the topic file displayed within the frameset. This means if you want to do
context-sensitive links, scripting is needed. We currently support two
general approaches for doing this:

The launchHelp() function is used for browser-based applications, where
a browser launches the help window. Thus one browser window spawns another:
the function opens the help frameset in a new window, then displays the
requested topic.

The loadHelp() function is used for non-browser-based applications, where
the initial help call does not originate in a browser. The function is
called *after* the browser window is opened, and loads the requested topic
in the current window. This function is typically called by loadFrames().
When an application calls a topic, the loadFrames function creates a
frameset and loads the requested topic.

*/

var currentLink = 1;

// node type constants
// define these here, because the different browser object models
// provide incompatible ways of accessing the Node interface constants

ELEMENT_NODE = 1;
ATTRIBUTE_NODE = 2;
TEXT_NODE = 3;
CDATA_SECTION_NODE = 4;
ENTITY_REFERENCE_NODE = 5;
ENTITY_NODE = 6;
PROCESSING_INSTRUCTION_NODE = 7;
COMMENT_NODE = 8;
DOCUMENT_NODE = 9;
DOCUMENT_TYPE_NODE = 10;
DOCUMENT_FRAGMENT_NODE = 11;
NOTATION_NODE = 12;

if (modules_defined = 'undefined') {modules_defined = false;}

/*
Here's Clay's new function for making topic file "smart". Basically,
each topic file should call this function on load. If the topic has been
opened directly, the function will replace it with the appropriate frameset
and reload the topic in a frame. (Of course, if the topic is opened in a
frame it should just open normally.)

This should be defined at the top of the file to avoid timing issues
with IE7.
*/
function loadFrames(filename) {
  // skip if notoc is specified
  if (location.search == "?notoc") return;
  // define frames
  navframehtml = "  <frame src=\"blank.htm\" name=\"navframe\" frameborder=\"0\" border=\"0\" scrolling=\"no\" onresize=\"top.navframe.setclip()\">\n";
  topicframehtml = "  <frame src=\"blank.htm\" name=\"topic\" scrolling=\"AUTO\">\n";
  if (isScreenReader())  {
    framehtml = topicframehtml + navframehtml;
    cols = "*,250";
  }
  else {
    framehtml = navframehtml + topicframehtml;
    cols = "250,*";
  }
  
  //define frameset
  html = "<frameset rows=\"*\" cols=\"" + cols + "\" onload=\"navEvent('toc_top.htm','"+filename+"')\"> \n";
  html += framehtml;
  html += "</frameset></html>\n";
  
  // add frameset to document
  document.write(html);
  document.close();
}

/* call help from a browser. This function replaces the deprecated launchHelp()
and loadHelp() functions */
function startHelp(topicpathname){
	helpWindow=window.open("", "helpWindow", "height=550px,width=750px,resizable,toolbar");	
	helpWindow.opener=self;
	helpWindow.location.href=topicpathname;
	helpWindow.focus();
}

/* The following function handles navigation frame events. The arguments are
tested to make sure they exist, and then they are used to update the nav
frame and/or the topic frame, as appropriate. This function replaces both
loadTOC() and loadIndex() */
function navEvent(navsrc,topicsrc) {
  if ((typeof navsrc != 'undefined') && (navsrc != '')) {
    if ((typeof topicsrc != 'undefined') && (topicsrc != '')) {
      // if both are specified, delay the nav page a bit to give the
      // topic time to load, in case the nav file is huge and slow
      setTimeout("parent.navframe.location.replace('" + navsrc + "')",500);
    }
    else {
      // otherwise, just load the page immediately
      parent.navframe.location.replace(navsrc);
    }
  }
  if ((typeof topicsrc != 'undefined') && (topicsrc != '')) {
    goTopic(topicsrc);
  }
}

/*display requested topic in topic frame. Links from index or toc use this function.*/ 
function goTopic(id){
  // fix docjet window name
  top.loaded = false;
  try {
    if (top.frames[1].name == "Body") {
      top.frames[1].name = "topic";
    }
  }
  catch (e) {}
  parent.topic.location.href=id;
  top.topic.focus();
}

function isDocjetTopic() {
  result = false;
  if (top.topic.document.getElementsByTagName("table").item(0).className == "NavBar") {
    result = true;
  }
  return result;
}

function isJavadocTopic() {
  // search for "Generated by javadoc" comment
  result = false;
  headstuff = top.topic.document.getElementsByTagName("head").item(0).childNodes;
  nheaditems = headstuff.length;
  for (var i=0; i < nheaditems; i++) {
    headitem = headstuff.item(i);
    if ((headitem.nodeName == "#comment") && (headitem.nodeValue.indexOf("Generated by javadoc") != -1)) {
      result = true;
      break;
    }
  }
  return result;
}

function isNdocTopic() {
  result = false;
  if (top.topic.document.getElementById("nsbanner")) result = true;
  return result;
}

function isScreenReader() {
  // check for screenreader cookie
  return screenreaderenabled;
}

/*
This is a sister function to launchHelpTopic() that loads a
help topic into an existing topic frame. The main difference is
that this version is used in situation where there is no "opener"
window, and topicvar is a variable of the current window. This will
generally be true when this help is called from an application or
launched independently, rather than called from a browser window.
*/
function loadHelpTopic() {
  if (self.topicvar) { //check for topicvar in the current window
    self.topic.location.href=self.topicvar;
  }
  top.topic.focus();
}

// This function pops up a little window containing the passed text--very
// useful for glossary and bibliography xrefs
function popup(title,text,event) {
  //pops up a mini window to display the text string passed
    if (event == null) event = window.event;
    // remove existing popup if any
    p = document.getElementById("defwindow");
    if (p != null) p.parentNode.removeChild(p);

    // create new popup
    b = document.getElementsByTagName("body").item(0);
    t = event.target?event.target:event.srcElement;
    p = document.createElement("div");
    newx = parseInt((event.clientX>0?event.clientX:0) + b.scrollLeft) + 10 + "px";
    newy = parseInt((event.clientY>0?event.clientY:0) + b.scrollTop) + 10 + "px";

    // set popup div attributes
    p.style.position = "absolute";
    p.style.top = newy;
    p.style.left = newx;
    p.id = "defwindow";
    p.className = "popup";

    // add closer control
    closer = document.createElement("div");
    closerbutton = document.createElement("a");
    closerbutton.setAttribute("href","javascript:document.getElementById('defwindow').parentNode.removeChild(document.getElementById('defwindow'));void(0);");
    closerbutton.setAttribute("title",stb_close_popup);
    closerimage = document.createElement("img");
    closerimage.setAttribute("src","images/popup_closer.gif");
    closerimage.setAttribute("alt",stb_close_popup);
    closerimage.setAttribute("border","0");
    closerbutton.appendChild(closerimage);
    closerbutton.style.fontSize = "14px";
    closerbutton.style.lineHeight = "11px";
    closerbutton.style.textDecoration = "none";
    closerbutton.style.color = "black";
    closer.appendChild(closerbutton);

    // set title
    titlediv = document.createElement("div");
    titlediv.appendChild(document.createTextNode(title));
    titlediv.style.cursor = "move";
    titlediv.onmousedown = popup_drag;
    titlediv.className = "glossary-term";
    titlediv.style.fontWeight = "bold";
    titlediv.style.marginRight = "10px";
    titlediv.style.textIndent = "0px";
    p.appendChild(titlediv);
    p.appendChild(document.createElement("hr"));

    // set text
    textdiv = document.createElement("div");
    textdiv.className = "glossary-definition";
    textdiv.style.textIndent = "0px";
    textdiv.innerHTML = text;
    p.appendChild(textdiv);
    p.appendChild(closer);
    closer.style.position = "absolute";
    closer.style.right = "2px";
    closer.style.top = "2px";
    closer.style.border = "1px solid black";
    closer.className = "glossary-definition";
    closer.style.textIndent = "0px";

    // add it to document
    if (t.nextSibling) t.parentNode.insertBefore(p,t.nextSibling);
    else (t.parentNode.appendChild(p));
    
    // set window focus to closer
    closerbutton.focus(p);
}

function popup_drag(event) {
  // adapted from code in Flanagan, Javascript:The Definitive Guide, 4e
  // pp 372-373
  if (event == null) event = window.event;
  var popup = document.getElementById("defwindow");
  var x = parseInt(popup.style.left);
  var y = parseInt(popup.style.top);
  var mouseX = event.clientX;
  var mouseY = event.clientY;
  document.onmousemove = popup_move;
  document.onmouseup = popup_drop;
  event.stopPropagation?event.stopPropagation():event.cancelBubble=true;
  event.preventDefault?event.preventDefault():event.returnValue=false;
  
  function popup_move(event) {
    if (event == null) event = window.event;
    popup.style.left = parseInt(popup.style.left) + (event.clientX - mouseX) + "px";
    popup.style.top = parseInt(popup.style.top) + (event.clientY - mouseY) + "px";
    mouseX = event.clientX;
    mouseY = event.clientY;
    event.stopPropagation?event.stopPropagation():event.cancelBubble=true;
  }
  
  function popup_drop(event) {
    if (event == null) event = window.event;
    document.onmousemove = null;
    document.onmouseup = null;
    event.stopPropagation?event.stopPropagation():event.cancelBubble=true;
  }
    
}

// This function pops up a browser window containing the linked graphic
function graphicpopup(title,src) {
  if (typeof popupwin != "undefined") {
    popupwin.close();
  }
  popupwin = window.open("","popup","resizable");
  html = "<HTML>\n<HEAD>\n<TITLE>" + title + "</TITLE>\n" + 
  "<BODY>\n" +
  "<img src=" + "'" + "images/" + src + "'" + ">" + "\n" +
  "</BODY>\n</HTML>\n";
  popupwin.document.write(html);
  popupwin.document.close();
}


///////////////////////////////////////////////////////////////
//                       TOC controls                        //
///////////////////////////////////////////////////////////////


// This function controls the displaying/hiding of TOC elements
// and collapsible blocks
function expando(context) {
  // if context isn't passed, read it from event target
  if (typeof context == "undefined" || context.target) {
    var eventTarget = context?context.target:event.srcElement;
    if (eventTarget.nodeName.toLowerCase() == "img") eventTarget = eventTarget.parentNode;
    context_id = eventTarget.getAttribute("id");
    context = context_id.substring(0,context_id.lastIndexOf("_"));
  }
  var target = document.getElementById(context);
  var children = target.childNodes;
  var expando_status = "none";
  if (target.getElementsByTagName("div").length == 0) {
    // first expansion, add TOC entries from tocdata
    // get corresponding node in tocdata
    var t_data = null;
    for (var t=0; (t_file = tocdata[t]); t++) {
      if (t_data = t_file.getElementsByTagName(context).item(0)) break;
    }
      
    // add its children
    if (t_data) {
      toc_current_node[t] = target;
      for (var k=0; (kid = t_data.childNodes.item(k)); k++) {
        if (kid.nodeType == ELEMENT_NODE) {
          toc_current_data[t] = kid;
          addTocNode(t);
        }
      }
    }
  }
  else if (target.getElementsByTagName("div").item(0).style.display == "block") {
    expando_status = "block";
  }
  var descendants = false;
  for (var i=0;i<children.length;i++) {
    if (children.item(i).tagName == "DIV") {
      descendants = true;
      if (expando_status == "block") {
        // it's currently open, so close it
        children.item(i).style.display = "none";
      }
      else {
        // it's closed, so open it
        children.item(i).style.display = "block";
      }
    }
  }
  // setTimeout needed here to prevent Safari from crashing heinously
  // timeout values of 0 and 1 update them in the right order to prevent flicker
  if (descendants) {
    windowname = window.name;
    setTimeout("top." + windowname + ".document.getElementById('" + context + "_opener').style.display = '" + (expando_status=="block"?"inline":"none") + "';",(expando_status=="block"?0:10));
    setTimeout("top." + windowname + ".document.getElementById('" + context + "_closer').style.display = '" + (expando_status=="block"?"none":"inline") + "';",(expando_status=="block"?10:0));
  }
}

function display(context,setfocus) {
  var contextNode = document.getElementById(context);
  if (contextNode == null) {
    // look for it in tocdata
    var t_data = null;
    //debugger;
    if (typeof tocdata != "undefined") {
      for (var t=0; (t_file = tocdata[t]);t++) {
        var matches = t_file.getElementsByTagName(context)
        if (matches.length > 0) {
          t_data = matches.item(0);
          break;
        }
      }
    }
    if (t_data) {
      // render the portion of the TOC containing the target
      
      // find closest ancestor that is already rendered
      var ancestors = new Array();
      var toc_ancestor = t_data.parentNode;
      var toc_ancestor_node = document.getElementById(toc_ancestor.nodeName);
      while (toc_ancestor.nodeName != "es" && !toc_ancestor_node) {
        ancestors.push(toc_ancestor);
        toc_ancestor = toc_ancestor.parentNode;
        toc_ancestor_node = document.getElementById(toc_ancestor.nodeName);
      }
      ancestors.push(toc_ancestor);
      // render everything from that ancestor to the target
      // (including target siblings)
      toc_current_node[t] = toc_ancestor_node;
      t_data = toc_ancestor;
      //debugger;
      while (t_data = ancestors.pop()) {
        var next_ancestor = ancestors[ancestors.length-1];
        var next_node = null;
        for (var n = 0; (kid = t_data.childNodes.item(n)); n++) {
          if (kid.nodeType == ELEMENT_NODE) {
            toc_current_data[t] = kid;
            if (kid.nodeName == context) {
              contextNode = addTocNode(t);
            }
            else if (kid == next_ancestor) {
              next_node = addTocNode(t);
            }
            else { addTocNode(t); }
          }
        }
        toc_current_node[t] = next_node;
      }
    }
  }
  if (contextNode != null) {
    //show context node
    if (contextNode.tagName == "DIV") {
      contextNode.style.display = "block";
    }
    //show sibs of context node
    var mommy = contextNode.parentNode;
    for (i=0;(sib=mommy.childNodes[i]);i++) {
      if (sib.tagName == "DIV") {
        sib.style.display = "block";
      }
    }
    //recurse up the tree to show ancestors
    if (mommy.className == "tocindex" ||
    mommy.className == "top") {
      display(mommy.id,false);
    }
    
    //set focus
    if ((typeof setfocus == "undefined") ||
    (setfocus == true)) {
      for (j=0; j<contextNode.childNodes.length; j++) {
        if (contextNode.childNodes[j].tagName=="A") {
          setFocus(contextNode.childNodes[j]);
          break;
        }
      }
    }
  }
}

function sync_toc(context) {
  // this is called when the topic page loads. It basically calls
  // display(context) on the navframe, but it will wait if the navframe
  // hasn't loaded yet.
  if (location.search == "?notoc") {
    parent.loaded = true;
    return;
  }
  if (typeof parent.navframe.display != "undefined") {
    parent.navframe.display(context);
  }
  else {
    // check again in a half-second
    setTimeout("sync_toc('" + context + "')",500);
  }
  // this is the onload() function for topics, so define a
  // variable that can be used by other functions to test
  // whether the page is finished loading
  parent.loaded = true;
  // highlight search terms, if any are defined
  highlightSearch();
  // finally, set a variable on this frame that can be used by the TOC to
  // sync itself on load, just in case the user switches topics with another
  // tab active
  this.tocid = context;
}

// this function lets the TOC check to see if there's a topic already loaded
// when it loads. That way if the user is on the index or search tab, and then
// switches back to the TOC tab, it can sync itself to the already-opened topic
function sync_toc_onload() {
	if (typeof top.topic != "undefined" &&
      typeof top.topic.tocid != "undefined" &&
      top.topic.tocid != "") {
		display(top.topic.tocid);
	}
}

if (typeof toc_current_node == "undefined") toc_current_node = new Array();
if (typeof toc_current_data == "undefined") toc_current_data = new Array();
if (typeof toc_done == "undefined") toc_done = new Array();

// this function renders the TOC based on the modular script components *_toc.js.xml
function renderToc() {
  // load javascript code from XML files
  // this lets it fail silently if no such file is found
  if (typeof tocdata == "undefined") {
    tocdata = new Array();
    loadXMLfile("base_toc.js.xml",tocdata);
    if (typeof modules_defined != 'undefined' && modules_defined) {
      for (var i=0; (module = module_array[i]); i++) {
        if (eval(module[1])) {
          loadXMLfile(module[0].substring(module[0].indexOf("_")+1) + "_toc.js.xml",tocdata);
        }
      }
    }
  }
  // now convert data structure into HTML elements
  var tocdiv = top.navframe.document.getElementById("toccontainer");
  var extras = null;
  for (var t=0; (tocfile = tocdata[t]); t++) {
    toc_current_node[t] = tocdiv;
    var kids = tocfile.documentElement.childNodes;
    toc_done[t] = false;
    for (var d = 0; (t_node = kids[d]); d++) {
      if (t_node.nodeType == ELEMENT_NODE) {
        // if it's an "extras" chapter, save it for the end
        if (t_node.nodeName == "extras") {
          extras = t_node;
        }
        else {
          toc_current_data[t] = t_node;
          addTocNode(t);
        }
      }
    }
  }
  // if there were extras, render them now
  if (extras) {
    toc_current_data[0] = extras;
    addTocNode(0);
  }
}

function addTocNode(module_number) {
  // params based on global vars, which lets us use setTimeout
  // to prevent the script from locking up the browser while it renders
  var t_data = toc_current_data[module_number];
  var id = t_data.nodeName;
  var t_url = t_data.getAttribute("u");
  // container div
  var div = document.createElement("div");
  div.setAttribute("id",id);
  if (toc_current_node[module_number].getAttribute("id")=="toccontainer") {
    div.className = "top";
  }
  else {
    div.className = "tocindex";
  }
  // opener and closer
  var nkids = t_data.childNodes.length-1; // subtract the text node
  var url = "javascript:";
  
  if (nkids > 0) {
    var opener = document.createElement("span");
    var openerimage = document.createElement("img");
    openerimage.setAttribute("src","images/book_closed.gif");
    openerimage.setAttribute("alt",top.stb_expand);
    opener.appendChild(openerimage);
    opener.setAttribute("id", id + "_opener");
    div.appendChild(opener)
    opener.onclick = expando;
    var closer = document.createElement("span");
    closer.onclick = expando;
    var closerimage = document.createElement("img");
    closerimage.setAttribute("src","images/book_open.gif");
    closerimage.setAttribute("alt",top.stb_collapse);
    closer.appendChild(closerimage);
    closer.setAttribute("id", id + "_closer");
    closer.style.display = "none";
    div.appendChild(closer);
    url += "expando('" + id + "');";
  }
  else {
    var icon = document.createElement("span");
    icon.onclick = "top.navEvent('','" + t_url + "')";
    iconimage = document.createElement("img");
    iconimage.setAttribute("src","images/book_page.gif");
    iconimage.setAttribute("alt",top.stb_page);
    icon.appendChild(iconimage);
    icon.setAttribute("id", id + "_opener");
    div.appendChild(icon)
  }
  // TOC link
  var link = document.createElement("a");
  if (t_url) {
    if (startsWith(t_url,"http:") ||
      startsWith(t_url,"ftp:") ||
      startsWith(t_url,"file:") ||
      startsWith(t_url,"www.")) {
      url = t_url;
      link.setAttribute("target",id);
    }
    else {
      url += "top.navEvent('','" + t_url + "');";
    }
  }
  link.setAttribute("href",url);
  link.setAttribute("title",t_data.firstChild.nodeValue);
  link.appendChild(document.createTextNode(t_data.firstChild.nodeValue));
  div.appendChild(link);
  link.onfocus = function() { setFocus(this);}
  toc_current_node[module_number].appendChild(div);
  // return created node for potential future processing
  return div;
}

function startsWith(str, prefix) {
  if (str.length < prefix.length) return false;
  else return (str.substring(0,prefix.length)==prefix);
}

function getNextSibling(node) {
  // returns node's next sibling element, ignoring text nodes
  next_node = node.nextSibling;
  while (next_node && next_node.nodeType == TEXT_NODE) {
    next_node = next_node.nextSibling;
  }
  return next_node;
}

function loadJavaScript(file) {
  // loads a javascript file as if it were XML, and executes the code using eval()
  filearray = new Array();
  loadXMLfile(file,filearray);
  if (filearray.length > 0 && filearray[0].documentElement && filearray[0].documentElement.firstChild) {
    eval(filearray[0].documentElement.firstChild.nodeValue);
  }
}

/*
 * This function tidies up and handles TOC synchronization for merged
 * API topics.
 *
 * For NDoc and Javadoc API documentation, add the following snippet to
 * the page footer (NDoc) or bottom (Javadoc):
 *
 * <script type='text/javascript'>if (top.cleanAPITopic) window.onload = top.cleanAPITopic;</script>
 */
function cleanAPITopic() {
  // removes frame controls, etc. from Docjet topic
  fc = top.frames[1].document.getElementsByTagName("table");
  for (var i=0; (t = fc.item(i)); i++) {
    if (t.className == "NavBarActionLine") {
      t.style.display = "none";
      break;
    }
  }
  // remove frame controls from Javadoc topic
  anchors = top.frames[1].document.getElementsByTagName("a");
  for (var i=0; (anchor = anchors[i]); i++) {
    if (anchor.innerHTML == "<b>FRAMES</b>" || anchor.innerHTML == "<b>NO FRAMES</b>" ||
        anchor.innerHTML == "<B>FRAMES</B>" || anchor.innerHTML == "<B>NO FRAMES</B>") {
       anchor.parentNode.removeChild(anchor);
       i--;
    }
  }
  // sync TOC and highlight search text if any
  sync_toc_docjet(top.frames[1].location.href);
  highlightSearch();
}

function sync_toc_docjet(url) {
  // sync TOC based on URL

  // get filename from url
//  start = url.lastIndexOf("/") + 1;
//  fn = url.substring(start);
  fn = url;
  if (fn.indexOf("#") != -1) {
    fn = fn.substring(0,fn.indexOf("#"));
  }
  // find TOC entry containing the filename
  toc = top.navframe.document.getElementById("scrolldiv").getElementsByTagName("a");
  for (var i=0; (link = toc[i]); i++) {
    link_href = link.getAttribute("href");
    if (link_href.indexOf("javascript") != -1) {
      link_href = link_href.replace(/javascript:.*?\.navEvent\('','(.*?)'\).*/,"$1");
    }
    if (fn.indexOf(link_href) != -1) {
      // display it
      top.navframe.display(link.parentNode.getAttribute("id"));
      break;
    }
  }
}

/////////////////////////////////////////////////////////
//                Index controls                       //
/////////////////////////////////////////////////////////


// Initiates a search of the index. This function is basically a wrapper
// for search(), to allow the browser time to update the status message
// ("Searching...") before going zombie in the actual search
function searchSelect() {
  setTimeout("search()",200);
}

var index_entries = new Array();
var index_keys = new Array();
var index_initials = new Array();
var index_initialflags = new Array();
var index_currenttab;
var index_sep = "   ";
var index_prefix = "_";

function initIndexInitials() {
  // set up initials, if necessary
  if (typeof index_initials == "undefined" || index_initials.length == 0) {
    // read entries to get initials
    readEntries();
    for (i=0;(idoc = indexdocs[i]);i++) {
      initials = idoc.getElementsByTagName("i");
      for (j=0; (initial = initials[j]); j++) {
        index_initialflags[initial.getAttribute("i")] = true;
      }
    }
    for (initial in index_initialflags) {
      index_initials.push(initial);
    }
    index_initials.sort();
  }
  if (location.href.split("?")[1]) {
    index_currenttab = decodeURI(location.href.split("?")[1]);
  }
}

function renderIndex(thistab) {
  newstart = new Date();
  initIndexInitials();
  // clone the index container to replace existing index
  idiv = document.getElementById("indexdiv");
  indexcontainer = idiv.cloneNode(false);
  indexcontainer.appendChild(document.getElementById("searching_message").cloneNode(true));
  indexcontainer.appendChild(document.getElementById("loading_message").cloneNode(true));
  // generate page tabs
  if ((typeof thistab == "undefined") || (thistab == null)) { thistab = index_initials[0]; } 
  insertPageTabs(index_keys,thistab,indexcontainer);
  scroller = document.getElementById("scrolldiv").cloneNode(false);
  entrycontainer = document.createElement("div");
  entrycontainer.style.padding="4px";
  // render all entries starting with this character
  index_entries = getIndexEntries(thistab);
  for (var i=0;(entry = index_entries[i]);i++) {
    renderIndexEntry(entry,entrycontainer);
  }
  scroller.appendChild(entrycontainer);
  indexcontainer.appendChild(scroller);
  idiv.parentNode.replaceChild(indexcontainer,idiv);
  document.getElementById("loading_message").style.display="none";
  end = new Date();
  setclip();
}

function insertPageTabs(keylist,thistab,container) {
  tabstart = new Date();
    tabs = document.createElement("div");
    tabs.className = "indexsubtabs";
    tabs.style.marginBottom = "0px";
    tabs.setAttribute("id","indexsubtabs");
    for (var i=0; (initial = index_initials[i]); i++) {
      tab = document.createElement("a");
      tab.setAttribute("href","javascript:renderIndex('"+(initial=="'"?"\\"+initial:initial)+"');");
      if (initial == thistab) tab.className="indexsubtabselected";
      else tab.className = "indexsubtab";
      tab.appendChild(document.createTextNode(initial+' '));
      tabs.appendChild(tab);
    }
  container.appendChild(tabs);
  tabend = new Date();
}

function getIndexEntries(tab) {
  // gets the index entries from the XML docs and sorts and collapses them
  // returns an array of arrays
  tabentries = new Array();
  // get entries from each indexdoc, add to array
  for (var i=0; (indexdoc = indexdocs[i]); i++) {
    var initials = indexdoc.getElementsByTagName("i");
    var initial = null;
    for (var j=0; (initial = initials[j]); j++) {
      if (initial.getAttribute("i") == tab) {
        break;
      }
    }
    if (initial != null) {
      ts = indexdoc.getElementsByTagName("t");
      toffset = parseInt(ts[0].getAttribute("t"));
      for (var k=0; (e = initial.childNodes[k]); k++) {
        explicit_sortkey = e.getAttribute("s");
        sortkey = index_prefix + (explicit_sortkey?explicit_sortkey:e.getAttribute("n"));
        titlenode = ts[parseInt(e.getAttribute("t")) - toffset];
        // make the specific topic link array
        link = [titlenode.firstChild.nodeValue,titlenode.getAttribute("u")];
        if (tabentries[sortkey] == null) {
          tabentries[sortkey] = new Array();
          tabentries[sortkey].push(e.childNodes);
        }
        tabentries[sortkey].push(link);
      }
    }
  }
  // transform associative array to sorted normal array
  sorted = new Array();
  for (entry in tabentries) {
    sorted.push([entry.substring(1),tabentries[entry][0],tabentries[entry].slice(1)]);
  }
  sorted.sort(function(a,b) { if (a[0] < b[0]) return -1; else if (a[0] == b[0]) return 0; else return 1;});
  // return the array
  return sorted;
}

function renderIndexEntry(key_entry,container) {
  
  key = key_entry[0];
  hits = key_entry[1];
  div = document.createElement("div");
  div.style.marginLeft = ((key.indexOf(index_sep)!=-1)?40:20) + "px";
  div.className = "index";
  div.setAttribute("class","index");
  a = document.createElement("a");
  a.setAttribute("href",'javascript:smartLink2("' + key + '");');
  for (var i=0; (kid = hits[i]); i++) {
    // IE's node handling is broken, so have to recreate node in target document
    dup = null;
    if (kid.nodeType == 3) { // text node
      dup = document.createTextNode(kid.nodeValue.replace("   "," "));
    }
    else {
      dup = document.createElement(kid.nodeName);
      // have to use getAttribute("class") because source is XML, so className property
      // doesn't work there
      if (kid.getAttribute("class")) { dup.className = kid.getAttribute("class");}
      dup.appendChild(document.createTextNode(kid.firstChild.nodeValue));
    }
    a.appendChild(dup);
  }
  div.appendChild(a);
  container.appendChild(div);
}


function smartLink2(key) {
//handle links with multiple targets.
//target is passed as key into entries associative array
  var e=0;
  while (index_entries[e][0] < key && e < index_entries.length) {
    e++;
  }
  if (index_entries[e] && index_entries[e][0] == key) {
    targetList = index_entries[e][2];
    //In the case of a single target, just go there
    if (targetList.length == 1) {
      target = targetList[0][1];
      navEvent('',target);
    //If multiple targets are specified, list the topics so the user can choose
    } else {
    
  
      var newContent = "<html><head>\n";
      newContent += "<script type=\"text/javascript\" src=\"helploc.js\"><" + "/script>\n";
      newContent += "<title>" + stb_topics_found + "</title>\n</head>\n";
      newContent += '<body onload="document.body.scrollTop=0"><h1>' + stb_select_a_topic + '</h1>\n';
  
        for(var i = 0; i < targetList.length; i++) {
              newContent += '<div style="display:block; margin-top:4px">'
              newContent += '<a href="' + targetList[i][1] + '">' + removeSlashes(targetList[i][0]) + "</a><br />"
              newContent += '</div>\n'
        }
  
      newContent += "</body>\n</html>";
      parent.topic.document.write(newContent);
      parent.topic.document.close(); //close layout stream
    }
  }
}

var indexdocs = new Array();

function readEntries() {
  if (indexdocs.length == 0) {
    status = stb_fts_loading_index;
    loadXMLfile("base_index.xml",indexdocs)
    if (typeof modules_defined != 'undefined' && modules_defined) {
      for (i=0;(module=module_array[i]);i++) {
        if (eval(module[1])) {
          status = stb_fts_loading_index + module[0].substring(7);
          loadXMLfile(module[0].substring(7) + "_index.xml",indexdocs);
        }
      }
    }
  }
  status = "";
}

function removeSlashes(text) {
  // removes slashes used to escape apostrophe's and quotes
  return text.replace(/\\(.)/g,"$1");
}

function setclip(offset) {
  //this function sets a viewport for the main container (the one that holds the content)
  //so that it scrolls when the container is too small to hold the contents. This function
  //is called by the onload() and onresize() event handlers for pages.
  //param offset indicates a height offset necessary for nav pages, since they have a
  //non-scrolling control at the top
  IEADJUST = 1;
  var d = document.getElementById("scrolldiv");
  var b = document.getElementById("navtabs");
  var s = d.style;
  cw = (b.offsetWidth==0)?250:b.offsetWidth; // for some reason b.offsetWidth returns 0 on TOC & index pages...
  if (typeof offset == "undefined") offset = 0;
  wh = getHeight(top.document.body);
  h = wh - d.offsetTop;
  // adjust for IE's poor handling of borders
  if (document.all) { h-=2; }
  s.width= cw + "px";
  s.height = h + "px";
  s.overflow = "auto";
  s.padding = "0px";
  s.margin = "0px";
}

function getHeight(element) {
  h = element.offsetHeight;
  if (document.all) {
    // adjust for IE's boneheaded handling of padding and border
    if (element.style.padding != "" ||
        element.style.padding-top != "" ||
        element.style.padding-bottom != "") {
      h-=1;
    }
    if (element.style.border != "" ||
        element.style.border-top != "" ||
        element.style.border-bottom != "") {
      h-=1;
    }
  }
  return h;
}


///////////////////////////////////////////////////////////
//        functions to support full text search          //
///////////////////////////////////////////////////////////

var results; // will be array of Result objects

// this function takes the input from the search form and calls the proper search
// function, either ftssearch() (fulltext) or search() (keywords)
function helpsearch(query,type) {
  document.getElementById("searching_message").style.display = "block";
  query = query.replace(/[.,\/<>?;:'\[{\]}\|!@#$%^&;*()`~_=+]/g," ");
  if (type == "fulltext") {
    setTimeout("ftssearch('" + query + "',render_search_results);",200);
  }
  else {
    setTimeout("keywordsearch('" + query + "',render_search_results);",200);
  }
  
}

// This is the call back function to handle results
function render_search_results(results,type)
{
  if (typeof type == "undefined" || type == null) type = "fulltext";
  oldresultspanel = document.getElementById("indexdiv");
  resultspanel = oldresultspanel.cloneNode(false);
  oldresultspanel.parentNode.replaceChild(resultspanel, oldresultspanel);
  resultspanel.style.marginLeft = "10px";
  if (results == null || results.length==0)
  {
    d = document.createElement("div");
    d.setAttribute("class","index");
    d.style.marginLeft = "20px";
    d.appendChild(document.createTextNode(stb_fts_no_matches));
    resultspanel.appendChild(d);
    return;
  }
  // store entries in an array so we can sort by relevance
  fts_entries = new Array();
  if (type == "fulltext") {
    resulttopiclists = topiclists;
  }
  else {
    resulttopiclists = indextopiclists;
  }
  for(var listindex=0; listindex < results.length; listindex++) {
    result = results[listindex];
    if (result != null && result.length > 0) {
      lasttopic = -1;
      topicoffset = parseInt(resulttopiclists[listindex][0].getAttribute("t"));
      for (var i=result.length-1; i >= 0; i--) {
        topicindex = result[i][0];
        if (topicindex != lasttopic) {
          // look up topic info for the result
          topicinfo = resulttopiclists[listindex][topicindex-topicoffset];
          // collect position info
          j = i;
          var poses = new Array();
          while ((j >= 0) && (result[j][0] == topicindex)) {
            poses = poses.concat(result[j--][1]);
          }
          fts_entries.push([topicinfo.getAttribute("u"),topicinfo.firstChild?topicinfo.firstChild.nodeValue:"(no heading)",poses.length]);
          lasttopic = topicindex;
        }
      }
    }
  }

  document.getElementById("searching_message").style.display = "none";
  // sort entries by relevance (reverse order, so higher relevance is at top)
  if(fts_entries == null || fts_entries.length==0)
  {
    d = document.createElement("div");
    d.setAttribute("class","index");
    d.appendChild(document.createTextNode(stb_fts_no_matches));
    resultspanel.appendChild(d);
    return;
  }
  fts_entries.sort(function(a,b) { if (a[2] > b[2]) return -1; else if (a[2] == b[2]) return 0; else return 1; });
  // get query string so we can append it to URL for highlighter script
  // escape apostrophes so they don't bollox up the JS call below, and set URI encoding
  fts_query = encodeURIComponent(top.navframe.document.getElementById('searchText').value.replace("'","\\'"));
  fts_container = resultspanel;
  render_fts_hit(0);
  results = null;
}

var fts_query = "";
var fts_container = null;
var fts_entries = new Array();
var max_relevance = 0;

function render_fts_hit(ptr) {
	hit = fts_entries[ptr];
	if (ptr == 0) max_relevance = hit[2];
  d = document.createElement("div");
  d.className = "index";
  d.style.whiteSpace = "nowrap";

  e = document.createElement("a");
  e.setAttribute("href","javascript:top.navframe.navEvent('','" + hit[0] + "?search=" + fts_query + "');");
  e.setAttribute("onclick","blur()");
  e.appendChild(document.createTextNode(hit[1]));
  d.appendChild(e);
  d.appendChild(document.createTextNode(" ["+Math.round(parseInt(hit[2])/max_relevance * 100) + "%]"));
  
  fts_container.appendChild(d);
	if (++ptr < fts_entries.length) {
		setTimeout("render_fts_hit(" + (ptr) + ")",1);
	}
}  


function calculateRelevance(hits) {
  // returns a numeric value indicating relevence of this topic to the search query
  // for now just calculates number of hits; later maybe make it more sophisticated,
  // taking distance between words, etc. into account
  if (hits == null) return 0;
  else return hits.length;
}

var xmldocs = new Array();
var wordlists = new Array();
var wordlist;
var topiclists = new Array();
var topiclist;
var fts_search_term;

function ftssearch(term,callback) {
  // full text search: uses a binary search algorithm on XML based text index files
  // load xml docs if necessary
  if (xmldocs.length == 0) {
    loadXMLfile("ftsdata.xml",xmldocs);
    window.status = stb_fts_loading_ftsdata + "ftsdata.xml";
    if (modules_defined) {
      for (i=0; module = module_array[i]; i++) {
        if (module[1]=='true') {
          status = stb_fts_loading_ftsdata + module[0].substring(7);
          loadXMLfile("ftsdata_" + module[0].substring(7) + ".xml",xmldocs);
        }
      }
    }
  }
  status = "";
  callback(runquery(term));
}

function getUserLanguage() {
  // gets user's language setting from user agent
  lang = "";
  if (navigator.language) {
    lang = navigator.language;
  }
  else if (navigator.userLanguage) {
    lang = navigator.userLanguage;
  }
  return lang;
}

function loadXMLfile(url,domarray) {
  // loads an XML file and appends it to the array of dom objects
  var xmldoc = null;
  
  // for Safari, Konqueror, Opera, and Mozilla
  if (window.XMLHttpRequest) {
	  try {
			xmlhttp = new XMLHttpRequest();
			xmlhttp.open("GET",url,false);
			xmlhttp.send(null);
			xmldoc = xmlhttp.responseXML;
		}
		catch (ex) {
      xmldoc = null;
		}
  }

  // for IE--this will also catch IE7 if the XMLHttpResponse fails
  if (xmldoc == null && window.ActiveXObject)
  { 
    xmldoc = new ActiveXObject("Msxml2.DOMDocument");   // Create doc
    xmldoc.async="false";
    try {
      xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
      xmlHTTP.open("GET", url, false);
      xmlHTTP.setRequestHeader("Content-type","application/xml");
      xmlHTTP.send();
      xmldoc.loadXML(xmlHTTP.responseText);
    }
    catch (ex) {
      // that didn't work, try using explicit server request
      try {
        xmldoc.setProperty("ServerHTTPRequest", true)
        xmldoc.load(url);                                     // Start loading!
        skip = false;
        if (xmldoc.parseError.errorCode != 0) {
          xmldoc = null;
        }
      }
      catch (ex) {
        // no corresponding file; could be because the module applies to some other
        // docset but not this one. Just skip the file
        xmldoc = null;
      }
    }
  }
  if (xmldoc != null && xmldoc.documentElement && xmldoc.documentElement.nodeName.toLowerCase() != "html") {
    domarray.push(xmldoc);
  }
}

var ftsModuleIndex;
var xmlhttp;

function loadXMLasync(url) {
  // loads an XML file and appends it to the array of dom objects
  var xmldoc = null;
  window.status = stb_fts_loading_ftsdata + url;
  var nextFile = null
  
  // for Safari, Konqueror, Opera, and Mozilla
  if (window.XMLHttpRequest) {
	  try {
			xmlhttp = new XMLHttpRequest();
      xmlhttp.onreadystatechange = loadNextXMLasync;
			xmlhttp.open("GET",url,true);
			xmlhttp.send(null);
		}
		catch (ex) {
      xmldoc = null;
		}
  }

  // for IE--this will also catch IE7 if the XMLHttpResponse fails
  if (xmldoc == null && window.ActiveXObject)
  { 
    xmldoc = new ActiveXObject("Msxml2.DOMDocument");   // Create doc
    xmldoc.async="false";
    try {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
      xmlhttp.open("GET", url, false);
      xmlhttp.setRequestHeader("Content-type","application/xml");
      xmlhttp.send();
      xmldoc.loadXML(xmlhttp.responseText);
    }
    catch (ex) {
      // that didn't work, try using explicit server request
      try {
        xmldoc.setProperty("ServerHTTPRequest", true)
        xmldoc.load(url);                                     // Start loading!
        skip = false;
        if (xmldoc.parseError.errorCode != 0) {
          xmldoc = null;
        }
      }
      catch (ex) {
        // no corresponding file; could be because the module applies to some other
        // docset but not this one. Just skip the file
        xmldoc = null;
      }
    }
    if (xmldoc != null) xmldocs.push(xmldoc);
    loadNextXMLasync();
  }
}

function loadNextXMLasync() {
  // continues loading module FTS files
  if (xmlhttp.readyState != 4) { return; }
  if (xmlhttp.responseXML) {
    xmldocs.push(xmlhttp.responseXML);
  }
  if (modules_defined && (ftsModuleIndex < (module_array.length-1))) {
    ftsModuleIndex++;
    loadXMLasync("ftsdata_" + module_array[ftsModuleIndex][0].substring(7) + ".xml");
  }
  else {
    // done, start search
    window.status = "";
    render_search_results(runquery(fts_search_term));
  }
}
  
function runquery(query) {
  // parse query
  // a query is:
  //   (word | phrase | excluded-word)+
  //   add boolean support later
  // get atoms
  if (wordlists.length == 0) {
    for (i=0;(xmldoc=xmldocs[i]);i++) {
      wordlists.push(xmldoc.getElementsByTagName("w"));
      topiclists.push(xmldoc.getElementsByTagName("t"));
    }
  }
  query = query.toLowerCase();
  parsed = parse_query(query);
  words = parsed[0];
  phrases = parsed[1]
  exclusions = parsed[2];
  combined_results = new Array();
  // run query separately on each word list
  for (var listindex=0; (wordlist = wordlists[listindex]); listindex++) {
    topiclist = topiclists[listindex];
    // now execute the separate queries and combine
    results = new Array();
    for (i=0; (phrase = phrases[i]); i++) {
      result = find_phrase(phrase);
      results.push(result);
    }
    for (var i=0; (word = words[i]) ; i++) {
      result = find_word(word);
      results.push(result);
    }
    while (results.length > 1) {
      a = results.pop();
      b = results.pop();
      ab = intersect_results(b,a);
      results.push(ab);
    }
    // now get the exclusions
    if (exclusions.length > 0) {
      var exresults = new Array();
      for (var i=0; (word = exclusions[i]); i++) {
        if (word.substring(0,1) == "\"") result = find_phrase(word.substring(1));
        else result = find_word(word);
        exresults.push(result);
      }
      while (exresults.length > 1) {
        a = exresults.pop();
        b = exresults.pop();
        a = a.concat(b);
        a.sort(sortSearchResults);
        exresults.push(a);
      }
      // remove exclusions from hits
      a = results.pop();
      b = exresults.pop();
      ab = disjunct_results(a,b);
      results.push(ab);
    }
    combined_results.push(results[0]);
  }
  final_results = new Array();
  final_results = final_results.concat(combined_results);
  // finally, combine and report results
  return final_results;
}

function parse_query(query) {
  // returns words, phrases, and exclusions from query string
  fullquery = query;
  var phrases = new Array();
  var words = new Array();
  var exclusions = new Array();
  // first get phrases
  while (query.indexOf("\"") != -1) {
    start = query.indexOf("\"");
    end = query.indexOf("\"",start+1);
    if (end == -1) end = query.length;
    if (query.substr(start - 1,1) == "-") exclusions.push(query.substring(start--,end));
    else phrases.push(query.substring(start+1,end));
    query = query.substring(0,start) + query.substring(end+1);
  }
  // then find words in the non-phrase part
  while (query.length > 0) {
    while (query.substring(0,1) == " ") { query = query.substring(1); }
    end = query.indexOf(" ");
    if (end == -1) end = query.length;
    if (query.substring(0,1) == "-") exclusions.push(query.substring(1,end));
    else words.push(query.substring(0,end));
    query = query.substring(end+1);
  }
  return [words,phrases,exclusions];
}

function intersect_results(a,b) {
  // consolidate results, only include topics with hits in both a and b
  if (a == null || b == null) return null;
  var result = new Array();
  b_ptr = 0;
  for (var i=0; (a_topic = a[i]); i++) {
    // advance b_ptr to skip topics before current a_topic
    for (;(b_topic = b[b_ptr]) && (b_topic[0] < a_topic[0]);b_ptr++) {
    }
    if (b_topic && (b_topic[0] == a_topic[0])) {
      result.push(a_topic);
    }
  }
  if (result.length == 0) return null;
  else return result.sort(sortSearchResults);
}

function disjunct_results(a,b) {
  // only include topics with hits in a but not b
  if (a == null) return null;
  if (b == null) return a;
  var result = new Array();
  b_ptr = 0;
  for (var i=0; (a_topic = a[i]); i++) {
    // advance b_ptr to skip topics before current a_topic
    for (;(b_topic = b[b_ptr]) && (b_topic[0] < a_topic[0]);b_ptr++) {
    }
    if (!b_topic || (b_topic[0] > a_topic[0])) {
      result.push(a_topic);
    }
  }
  if (result.length == 0) return null;
  else return result.sort(sortSearchResults);
}

function find_phrase(phrase) {
  // finds phrases by finding individual words then using position info to
  // check for complete phrase
  
  // get words
  phrasewords = new Array();
  while (phrase.length > 0) {
    end = phrase.indexOf(" "); // can we use something like BreakIterator to handle asian languages?
    if (end == -1) end = phrase.length;
    phrasewords.push(phrase.substring(0,end));
    phrase = phrase.substring(end+1);
  }
  // get hits for each word
  wordhits = new Array();
  for (var i=0; (word=phrasewords[i]); i++) {
    hits = find_word(word);
    if (hits == null) {
      // if any word is not found, phrase search fails, return null
      return null;
    }
    else {
      wordhits.push(hits);
    }
  }
  // use intersection to reduce each word list to topics where all words appear
  // for efficiency intersect from shortest list
  var shortest = 0;
  var shortest_len = 10000000;
  for (var j=1; (b = wordhits[j]); j++) {
    if (b.length < shortest_len) {
      shortest_len = b.length;
      shortest = j;
    }
  }
  for (var j=0; (b = wordhits[j]); j++) {
    if (j != shortest) {
      wordhits[shortest] = intersect_results(wordhits[shortest],b);
      // if intersection is empty, don't bother with the rest
      if (wordhits[shortest] == null) return null;
      wordhits[j] = intersect_results(wordhits[j],wordhits[shortest]);
    }
  }
  // look for instances where the words appear in consecutive positions
  result = new Array();
  firstword = wordhits[0];
  for (var t=0; (topic = firstword[t]); t++) {
    for (var p=0; (position = topic[1][p]); p++) {
      found = true;
      for (var w=1; (word = wordhits[w]); w++) {
        if (!checktopicposition(word,topic[0],++position)) {
          found = false;
          break
        }
      }
      if (found) result.push(topic);
    }
  }
  if (result.length > 0) {
    return result;
  }
  else { return null;}
}

var ctp_lasthits = null;
var ctp_i;

function checktopicposition(hits,topic,position) {
  // checks to see whether there is a match in hits for the specified topic and position
  if (ctp_lasthits == hits) {
    // if it's the same hit list as last time, we can pick up where we left off
    // and save some time
    start = ctp_i;
  }
  else {
    start = 0;
    ctp_lasthits = hits;
  }
  for (var i=start; (hit=hits[i]); i++) {
    ctp_i = i;
    hittopic = hit[0];
    if (hittopic > topic) {return false;}
    if (hittopic == topic) {
      poses = hit[1];
      for (var j=0; (pos = poses[j]); j++) {
        if (pos == position) return true;
      }
      return false;
    }
  }
  return false;
}

function find_word(thisterm) {
  // get the hits for the given word
  newresults = new Array();
  
  var high = wordlist.length-1;
  var low = 0;
  var found = false;
  var target = null;
  // binary search
  while ((low <= high) && !found) {
    mid = Math.round((high + low)/2);
    word = wordlist[mid].firstChild.data;
    if (thisterm == word) {
      found = true;
      target = wordlist[mid];
    }
    else if (thisterm > word) {
      low = mid + 1;
    }
    else if (thisterm < word) {
      high = mid - 1;
    }
  }
  // return results
  if (found) {
    hits = target.getAttribute("d").split(".");
    for (var i=0;(hit=hits[i]);i++) {
      topicindex = decodeChar(hit.charAt(0));
      positions = decodeChars(hit.substring(1));
      newresults.push([topicindex,positions]);
    }
  }
  if (newresults.length == 0) return null;
  else return newresults;
}

function decodeChar(uchar) {
  // converts unicode character to (decimal value - 160)
  return uchar.charCodeAt(0) - 160;
}

function decodeChars(str) {
  // converts a string of coded values to an array of decoded ints
  result = new Array();
  for (i=0;(c = str.charAt(i));i++) {
    result.push(decodeChar(c));
  }
  return result;
}

function highlightSearch() {
	// this retrieves search terms from the search portion of the URL and highlights occurrences
	// in the document
	if (top.frames.length > 1 && typeof top.frames[1].location.search != "undefined" &&
	top.frames[1].location.search != "") {
		//get list of search terms
		query = decodeURIComponent(top.frames[1].location.search.substring(top.frames[1].location.search.indexOf("search=")+7));
    // parse query
    parsed = parse_query(query);
    termlist = parsed[0].concat(parsed[1]);
		bodytext = top.frames[1].document.body.innerHTML;
    // for non-standard topics, e.g. API topics, use explicit style info instead of class
    stdtopic = (bodytext.indexOf('src="modules.js"')!=-1);
    nodes = top.frames[1].document.body.getElementsByTagName("*");
		for (j=0; (term = termlist[j]); j++) {
			re = new RegExp(term,"i");
      textnodes = new Array();
      for (var m=0; (thisnode = nodes[m]); m++) {
        for (var n=0; (kid = thisnode.childNodes[n]); n++) {
          if (kid.nodeType == 3) { // text node
            textnodes.push(kid);
          }
        }
      }
      for (var k=0; (textnode = textnodes[k]); k++) {
        nodetext = textnode.nodeValue;
        ptr = nodetext.search(re);
        // if found, check for ancestor expando and expand if necessary
        if (ptr != -1) {
          mom = textnode.parentNode;
          while (mom != null) {
            if (mom.tagName.toLowerCase() == "div" && mom.className == "collapsible_block") {
              // Found it, make sure it's expanded
              if (mom.style.display == "none") {
                top.topic.expando(mom.parentNode.getAttribute("id"));
              }
              break;
            }
            mom = mom.parentNode;
            if (mom.tagName.toLowerCase() == "body") break;
          }
        }
        replace = new Array();
        while (ptr != -1) {
          // split text node, add span, and process following text
          before = top.frames[1].document.createTextNode(nodetext.substring(0,ptr));
          hit = top.frames[1].document.createElement("span");
          hit.className = "searchhighlight";
          if (!stdtopic) hit.style.backgroundColor = "yellow";
          hit.appendChild(top.frames[1].document.createTextNode(nodetext.substr(ptr,term.length)));
          replace.push(before);
          replace.push(hit);
          nodetext = nodetext.substring(ptr + term.length);
          ptr = nodetext.search(re);
        }
        if (replace.length > 0) {
          // get last bit of text
          replace.push(top.frames[1].document.createTextNode(nodetext));
          // replace original text node with series of nodes from replace array
          mom = textnode.parentNode;
          span = top.frames[1].document.createElement("span");
          while (newnode = replace.shift()) {
            span.appendChild(newnode);
          }
          mom.replaceChild(span,textnode);
        }
      }
      
		}
	}
}

function sortSearchResults(a,b) {
  // this function is used in calls to array.sort() to sort an array of search results
  return a[0] - b[0];
}

/************************************
*
*  keyword search
*
*************************************/

function keywordsearch(term,callback) {

  readEntries();  
  status = "";
  callback(runkeywordquery(term),"keyword");
}

var indexentrylists = new Array();
var indextopiclists = new Array();
var indexentrylist;
var indextopiclist;

function runkeywordquery(query) {
  // get atoms
  if (indexentrylists.length == 0) {
    for (var i=0;(indexdoc=indexdocs[i]);i++) {
      indexentrylists.push(indexdoc.getElementsByTagName("e"));
      indextopiclists.push(indexdoc.getElementsByTagName("t"));
    }
  }
  query = query.toLowerCase();
  parsed = parse_query(query);
  words = parsed[0];
  phrases = parsed[1]
  exclusions = parsed[2];
  combined_results = new Array();
  // run query separately on each word list
  for (var listindex=0; (indexentrylist = indexentrylists[listindex]); listindex++) {
    indextopiclist = indextopiclists[listindex];
    // now execute the separate queries and combine
    results = new Array();
    for (var i=0; (phrase = phrases[i]); i++) {
      result = keyword_find_phrase(phrase);
      results.push(result);
    }
    for (var i=0; (word = words[i]) ; i++) {
      result = keyword_find_word(word);
      results.push(result);
    }
    while (results.length > 1) {
      a = results.pop();
      b = results.pop();
      ab = intersect_results(b,a);
      results.push(ab);
    }
    // now get the exclusions
    if (exclusions.length > 0) {
      var exresults = new Array();
      for (var i=0; (word = exclusions[i]); i++) {
        if (word.substring(0,1) == "\"") result = keyword_find_phrase(word.substring(1));
        else result = keyword_find_word(word);
        exresults.push(result);
      }
      while (exresults.length > 1) {
        a = exresults.pop();
        b = exresults.pop();
        a.concat(b);
        exresults.push(a);
      }
      // remove exclusions from hits
      a = results.pop();
      b = exresults.pop();
      ab = disjunct_results(a,b);
      results.push(ab);
    }
    combined_results.push(results[0]);
  }
  final_results = new Array();
  final_results = final_results.concat(combined_results);
  // finally, combine and report results
  return final_results;
}

function keyword_find_phrase(phrase) {
  // for keywords, just apply brute-force approach of keyword_find_word
  // to the entire phrase
  
  // strip quotes
  phrase = phrase.replace('"','');
  // search
  return keyword_find_word(phrase);
}

function keyword_find_word(thisterm) {
  // get the hits for the given word
  // for keywords, use brute force
  var hits = new Array();
  var target = thisterm.toLowerCase();
  var e = null;
  for (var i=0; (e = indexentrylist[i]); i++) {
    if (e.getAttribute("n").indexOf(target) != -1) {
      hits.push([parseInt(e.getAttribute("t")),0]);
    }
  }
  if (hits.length == 0) return null;
  else return hits.sort(sortSearchResults);
}

////////////////////////////////////////////////////////////////////////
//                        Multi-topic printing                        //
////////////////////////////////////////////////////////////////////////

var windowLoaded = false;

var tempdoc = null;
var subdoc = null;

var windows = new Array();
var mainwin = top;
var printwin;
var printSubtopics = new Array();

function printFromTOC(id,subtopics) {
  if (!subtopics) {
    // clear windows array
    windows = new Array();
    printwin = mainwin;
    mainwin.loaded = false;
    // load selected doc
    d = top.navframe.document.getElementById(id);
    links = d.getElementsByTagName("A");
    firstlink = 0;
    while (links[firstlink].getAttribute("href").indexOf("navEvent(") == -1) {
      firstlink++;
    }
    href = links[firstlink].getAttribute("href");
    mainwin.topic.focus();
    mainwin.topic.print();
    setTimeout(href,500);
  }
  else {
    if (!confirm(stb_print_many_confirm)) {
      return;
    }
    mainwin = top;
    //get list of documents
    if (typeof tocdata != "undefined") {
      for (var t=0; (t_file = tocdata[t]);t++) {
        var matches = t_file.getElementsByTagName(id)
        if (matches.length > 0) {
          t_data = matches.item(0);
          break;
        }
      }
    }
    if (t_data) {
      printSubtopics = getLinksFromTOCNode(t_data);
      //append each subsequent doc
      printwin = window.open(printSubtopics[0]+"?notoc","print");
      waitForLoad();
    }
    else {
      alert("Error: Couldn't get list of subtopics from TOC data");
    }
  }
}

function getLinksFromTOCNode(node) {
  result = new Array();
  if (node.getAttribute("u")) {
    result.push(node.getAttribute("u"));
  }
  for (var i=0;(kid = node.childNodes.item(i));i++) {
    if (kid.nodeType == ELEMENT_NODE) {
      result = result.concat(getLinksFromTOCNode(kid));
    }
  }
  return result;
}

function waitForLoad() {
  // waits for all subtopic windows to finish loading
  if (printwin.loaded) {
    importSubtopics();
  }
  else {
    setTimeout('waitForLoad();',300);
  }
}

function loadHTMLFile(url) {
  // loads an HTML file and returns the file's content as a markup string
  var xmldoc = null;
  
  // for Safari, Konqueror, Opera, and Mozilla
  if (window.XMLHttpRequest) {
	  try {
			xmlhttp = new XMLHttpRequest();
			xmlhttp.open("GET",url,false);
			xmlhttp.send(null);
			xmldoc = xmlhttp.responseText;
		}
		catch (ex) {
      xmldoc = null;
		}
  }

  // for IE--this will also catch IE7 if the XMLHttpResponse fails
  if (xmldoc == null && window.ActiveXObject)
  { 
    try {
      xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
      xmlHTTP.open("GET", url, false);
      xmlHTTP.setRequestHeader("Content-type","application/xml");
      xmlHTTP.send();
      xmldoc = xmlHTTP.responseText;
    }
    catch (ex) {
      // that didn't work, try using explicit server request
      try {
        xmldoc = new ActiveXObject("Msxml2.DOMDocument");   // Create doc
        xmldoc.async="false";
        xmldoc.setProperty("ServerHTTPRequest", true)
        xmldoc.load(url);                                     // Start loading!
        skip = false;
        if (xmldoc.parseError.errorCode != 0) {
          xmldoc = null;
        }
        else {
          xmldoc = xmldoc.xml;
        }
      }
      catch (ex) {
        // no corresponding file; could be because the module applies to some other
        // docset but not this one. Just skip the file
        xmldoc = null;
      }
    }
  }
  return xmldoc;
}

function importSubtopics() {
  // copies content of subtopics into main topic and
  // closes subtopic windows
  tempdoc = printwin.document;
  var link = null;
  for (var i=1; i < printSubtopics.length; i++) {
    link = printSubtopics[i];
    if (link) {
      var html = loadHTMLFile(link);
      bodyStart = html.search(/<body.*?>/i);
      contentStart = html.indexOf(">",bodyStart) + 1;
      contentEnd = html.search(/<\/body>/i);
      if ((contentStart != -1) && (contentStart < contentEnd)) {
        content = html.substring(contentStart,contentEnd);
        var section = tempdoc.createElement("div");
        section.innerHTML = content;
        tempdoc.body.appendChild(section);
      }
    }
  }
  printwin.print();
  printwin.close();
}

function currentLinkId() {
  // gets the ID value for the div containing the currently
  // selected link
  links = top.navframe.document.links;
  return links[top.navframe.currentLink].parentNode.id;
}

////////////////////////////////////////////////////////////////////////
// The following functions pertain to hiding and displaying of content//
// based on module information                                        //
////////////////////////////////////////////////////////////////////////


function filter_modules_toc() {
  
  // This function works by defining styles dynamically at load time based on
  // the module status array.
  
  if (modules_defined) {
    styleInfo = "<STYLE>\n";
    for (i=0;i<module_array.length;i++) {
      styleInfo += "." + module_array[i][0] + " { display:" + (module_array[i][1]=='true'?"block":"none") + ";}\n";
    }
    styleInfo += "</STYLE>\n";
    document.write(styleInfo);
    document.close();
  }
}

function filter_modules_index() {
  
  // This function also works by dynamically defining styles at load time.
  // It's a little different from the TOC version, in that this version
  // has to account for every possible combination of modules. We can avoid
  // creating styles for every possible combination of modules by accounting
  // for only those combination of modules that aren't installed. If all modules
  // are installed, it's fast. If only the last module is installed and there
  // are 15 or so modules, it can be quite slow.
  
  if (modules_defined) {
    
    // get the integer representing all the modules set to true
    var mod_true = "";
    for (k = 0; k < module_array.length; k++) {
      if (module_array[k][1] == 'true') {
        mod_true = mod_true + "1";
      } else {
        mod_true = mod_true + "0";
      }
    }
    
    var mod_true_int = parseInt(mod_true, 2);
    
    //start modular approach
    //This is the modular approach, which could end up being too
    //slow for a large number of modules, if only a couple of modules
    //are installed.
    
    // assemble the style definitions
    styleInfo = "<STYLE>\n";
    
    // set style for all zeros to "block", so entries that don't belong
    // to any module are always displayed
    styleInfo += ".module_0 { display:block }\n";
    
    //get integer that represents all modules
    var all_modules_int = (Math.pow(2,module_array.length) - 1);
    
    //create style for each combination of modules that shouldn't
    //be displayed
    var diff = all_modules_int - mod_true_int
    for (j = 1; j < diff + 1; j++) {
      if ((j & diff) != 0) {
        styleInfo += ".module_" + j + " { display:";
          var display = "none";
        styleInfo += display + ";}\n";
      }
    }
    styleInfo += "</STYLE>\n";
    //end modular approach
    
    /*
    //start linear approach
    //This is the linear approach. This cannot work with
    //the current sharedindex.xsl. It must be modified to
    //write the call to filter_modules_index at the end of the
    //body. Also, each link must be hidden by default. Lastly,
    //only the number representing the module should be written
    //to the DIV class, not "module_nnn". This approach is
    //prohibitively slow for large indexes, but it's included
    //here just in case the other approach fails for a large
    //number of modules
    // browser sniff (shudder)
    ns = (navigator.appName.indexOf("Netscape") != -1);
    
    // magic numbers
    FIRST_INDEX_DIV = ns?9:3;
    LINK_NODE_INDEX = ns?1:0;
    
    kids = document.getElementById("indexdiv").childNodes;
    
    for (i=FIRST_INDEX_DIV;i<kids.length;i++) {
      if ((kids[i].tagName == "DIV")) {
        if ((parseInt(kids[i].className) & mod_true_int) != 0) {
          //display the link and the subentries, too
          grandkids = kids[i].childNodes;
          grandkids[LINK_NODE_INDEX].style.display = "block"; //the link itself
          for (j=1;j<grandkids.length;j++) {
            if (grandkids[j].tagName=="DIV") {
              if ((parseInt(grandkids[j].className) & mod_true_int) != 0) {
                //display the subentry links
                grandkids[j].childNodes[LINK_NODE_INDEX].style.display = "block";
              } else {
                grandkids[j].childNodes[LINK_NODE_INDEX].style.display = "none";
              }
            }
          }
        }
        else {
          // see if any child nodes matches
          grandkids = kids[i].childNodes;
          // hide parent entry (we'll unhide it if a child matches)
          grandkids[LINK_NODE_INDEX].style.display = "none";
          for (j=0;j<grandkids.length;j++) {
            if ((grandkids[j].tagName == "DIV")) {
              if ((parseInt(grandkids[j].className) & mod_true_int) != 0) {
                // match, so the parent should be displayed as well as the child
                grandkids[LINK_NODE_INDEX].style.display="block";
                displayValue = "block";
              }
              else {
                displayValue="none";
              }
              // apply the displayValue to the link
              grandkids[j].childNodes[LINK_NODE_INDEX].style.display = displayValue;
            }
          }
        }
      }
    }
    //end linear approach
    */
    
    // write the style info to the page
    document.write(styleInfo);
    document.close();
    
  }
  
}

function indexEntryHasInstalledModule(entry) {
  
  /*  if (typeof entry.module_list != 'undefined') {
    modules = eval(entry.module_list);
    returnValue = false;
    for (j=0;j<modules.length;j++) {
      if (eval(modules[j])) {
        returnValue = true;
        break;
      }
    }
    return returnValue;
  }
  else return true; */
  return true;
}

function filter_modules_topic() {
  if (modules_defined) {
    spans = document.getElementsByTagName("SPAN");
    for (i=0;i<spans.length;i++) {
      if (spans[i].className.substring(0,7)=="module_") {
        if (!eval(spans[i].className)) {
          // module is missing, so hide the span
          spans[i].style.display="none";
        }
      }
    }
  }	
}

///////////////////////////////////////////////////////////////
// The following functions handle navigation of the TOC tree //
///////////////////////////////////////////////////////////////

function keyhandler(evt) {
  
  // This function intercepts the keypresses when the TOC has
  // focus, and makes the arrow keys do the appropriate things
  
  // define character code constants for arrow keys
  LEFT_ARROW = 37;
  UP_ARROW = 38;
  RIGHT_ARROW = 39;
  DOWN_ARROW = 40;
  
  var key_handled = false;
  // handle different event models for IE vs. NS
  e = (evt) ? evt : event;
  keypressed = e.keyCode;
  
  if (keypressed == DOWN_ARROW) {
    // find next link that's displayed and give it focus
    for (i=currentLink+1; // start with next link in list
    i<document.links.length; // go to end of TOC links, but not to nav buttons
    i++) {
      if (linkIsDisplayed(document.links[i])) {
        //setFocus(document.links[i]);
        document.links[i].focus();
        currentLink = i;
        break;
      }
    }
    key_handled = true;
  }
  else if (keypressed == UP_ARROW) {
    // find the first previous link that's displayed and give it focus
    for (i=currentLink-1;i>=4;i--) {
      if (linkIsDisplayed(document.links[i])) {
        //setFocus(document.links[i]);
        document.links[i].focus();
        currentLink = i;
        break;
      }
    }
    key_handled = true;
  }
  else if (keypressed == RIGHT_ARROW) {
    // if this link is a collapsed branch, expand it
    // skip to first child div
    container = document.links[currentLink].parentNode;
    i=0;
    thisChild = container.childNodes[i];
    while (i < container.childNodes.length && thisChild.tagName != "DIV") {
      i++;
      thisChild = container.childNodes[i];
    }
    // found first child, now see if it's expanded
    if (i < container.childNodes.length) { // we didn't reach the end of the list
      if (!linkIsDisplayed(thisChild.childNodes[0])) { // it's collapsed
        // expand it
        expando(container.id);
      }
      else { // it is displayed, so do nothing
      }
    }
    else { // didn't find any child divs, so it's a leaf link
      // do nothing
      expando(container.id);
    }
    key_handled = true;
  }
  else if (keypressed == LEFT_ARROW) {
    // if this link is an expanded branch, collapse it
    // skip to first child div
    container = document.links[currentLink].parentNode;
    i=0;
    thisChild = container.childNodes[i];
    while (i < container.childNodes.length && thisChild.tagName != "DIV") {
      i++;
      thisChild = container.childNodes[i];
    }
    // found first child, now see if it's expanded
    if ((i < container.childNodes.length) &&  // we didn't reach the end of the list
    (linkIsDisplayed(thisChild.childNodes[0]))) { // it's an expanded branch
      // collapse it
      expando(container.id);
    }
    else { // it is already collapsed, or it's a leaf node so go to its parent
      // and collapse it
      // don't try to collapse the parent if we're already at the top level of
      // the toc!
      if (container.parentNode.id != "toccontainer") {
        expando(container.parentNode.id);
        // find the parent node's link and set focus to it
        kids = container.parentNode.childNodes;
        for (j=0;j<kids.length;j++) {
          if (kids[j].tagName == "A") {
            setFocus(kids[j]);
            break;
          }
        }
      }
    }
    key_handled = true;
  }
  // cancel event bubble so it doesn't mess up the scrolling
  if (key_handled) {
    if (e.preventDefault) e.preventDefault();
    else e.returnValue = false;
  }
  //if (event.stopPropagation) event.stopPropagation();
  //else event.cancelBubble = true;
}

function linkIsDisplayed(thisLink) {
  // checks to see whether thisLink is in a displayed DIV or not
  // by walking up the tree and checking every parent DIV.
  
  // Note that we can't just query element.style.display, because
  // the DIV's as rendered on load don't return a style object, even
  // though they have display properties set by the external stylesheet.
  // So, we basically have to say "it's displayed UNLESS it's style is
  // tocindex and its style is undefined".
  displayed = true;
  while (thisLink.parentNode && displayed) {
    thisLink = thisLink.parentNode;
    if ((thisLink.className == "tocindex") &&
      (typeof thisLink.style != "undefined") &&
    !(thisLink.style.display == "block")) {
      displayed = false;
      break;
    }
  }
  return displayed;
}

function setFocus(link) {
  
  // This function sets the focus on a link in the TOC. It
  // have side effect in addition to actually setting
  // the focus:
  //
  // * It updates a global variable currentLink that keeps track of which
  //   link is selected
  //
  // We don't have to set the background color any more, because we switched
  // to using the :active and :focus pseudoelements to handle this in
  // help-base.css.
  
  for (i=0;i<document.links.length;i++) {
    if (document.links[i] == link) {
      currentLink = i;
      break;
    }
  }
  link.focus();
  
}

function setPageFocus() {
  // Sets the focus for the page when it loads. For help
  // it should do nothing; the topic page will set the focus.
  // For tutorial it should focus on the first TOC link (link 0).
  // In the screen reader version, it should do nothing.
  if (!top.navframe) {
    firstLink = 0;
    document.links[firstLink].blur();
    document.links[firstLink].focus();
  }
}

// This function is just used for debugging. It shouldn't affect
// the actual help system in operation
function debug(message) {
  // open the debug window
  debugwin = window.open("","debug");
  // write header, if necessary
  if (debugwin.document.getElementsByTagName("h2").length == 0) {
    debugwin.document.write("<H2>Debug messages</H2>\n");
  }
  debugwin.document.write("<p>" + escape(message) + " (" + new Date() + ")</p>");
}

function watch(vars) {
  // writes debug message showing values of variables passed in array
  msg = ""
  for (var i=0; (v=vars[i]); i++) {
    msg += v + " = " + eval(v) + " | ";
  }
  debug("watch:" + msg);
}

function escape(text) {
  newtext = text.replace(/&/g,"&amp;");
  newtext = newtext.replace(/</g,"&lt;");
  newtext = newtext.replace(/\n/g,"<br />");
  return newtext;
}

//
//
//      MathML rendering support functions
//
//      Adapted from David Carlisle's pmathmlcss.xsl stylesheet
//      see http://www.w3.org/Math/XSL/

function malign (l)
{
  var m = 0;
  for ( i = 0; i < l.length ; i++)
  {
    m = Math.max(m,l[i].offsetLeft);
  }
  for ( i = 0; i < l.length ; i++)
  {
    l[i].style.marginLeft=m - l[i].offsetLeft;
  }
}

function mrowStretch (opid,opt,ope,opm,opb){
  opH = document.getElementById(opid).offsetHeight;
  var opH;
  var i;
  var es;
  lh = "100%";
  if (mrowH > opH * 2) {
    m= "<font size='+1' face='symbol' style='line-height:" + lh + "'>" + opm + "</font><br/>" ;
    if ((mrowH < opH * 3) && (opm == ope) ) m="";
    es="";
    for ( i = 3; i <= mrowH / (2*opH) ; i += 1) es += "<font size='+1' face='symbol' style='line-height:" + lh + "'>" + ope + "</font><br/>" ;
    document.getElementById(opid).innerHTML="<table class='lr'><tr><td><font size='+1' face='symbol' style='line-height:" + lh + "'>" +
    opt + "</font><br/>" +
    es +
    m +
    es +
    "<font size='+1' face='symbol' style='line-height:" + lh + "'>" + opb + "</font></td></tr></table>";
  }
}

function msubsup (bs,bbs,x,b,p){
  p.style.setExpression("top",bs +" .offsetTop -"  + (p.offsetHeight/2));
  b.style.setExpression("top",bs + ".offsetTop + " + (bbs.offsetHeight - b.offsetHeight*.5));
  x.style.setExpression("marginLeft",Math.max(p.offsetWidth,b.offsetWidth));
	document.recalc(true);
}

function msup (bs,x,p){
  p.style.setExpression("top",bs +" .offsetTop -"  + (p.offsetHeight/2));
  x.style.setExpression("marginLeft", bs +"p.offsetWidth");
  x.style.setExpression("height", bs + ".offsetHeight + " + p.offsetHeight);
  document.recalc(true);
}

function msub (bs,x,p){
  p.style.setExpression("top",bs +" .offsetTop +"  + (p.offsetHeight/2));
  x.style.setExpression("marginLeft", bs +"p.offsetWidth");
  x.style.setExpression("height", bs + ".offsetHeight + " + p.offsetHeight);
  document.recalc(true);
}

function munderover(id) {
  // rearranges elements of an munderover group
  group = document.getElementById(id);
  // find width = max child width
  w = 0;
  kids = new Array();
  for (var i=0; i < group.childNodes.length; i++) {
    kid = group.childNodes.item(i);
    if (kid.offsetWidth) {
      w = Math.max(w,kid.offsetWidth);
      kids.push(kid);
    }
  }
  // center top element and move it up
  t = kids[0];
  mid = kids[1];
  b = kids[2];
  strut = kids[3];
  ieadjust = document.all?6:0;
  tleft = (0.5 * w - 0.5 * t.offsetWidth + ieadjust);
  t.style.left = tleft + "px";
  t.style.top = (-mid.offsetHeight) + "px";
  // center middle element
  mleft = (0.5*w - 0.5*mid.offsetWidth - t.offsetWidth)
  mid.style.left = mleft + "px";
  // center bottom element and move it down
  bleft = (0.5 * w - 0.5 * b.offsetWidth  - mid.offsetWidth - t.offsetWidth - ieadjust);
  b.style.left = bleft + "px";
  b.style.top = (b.offsetHeight + 3) + "px";
  // make sure the equation is tall enough to contain the thing
  strut.style.top = -mid.offsetHeight + "px";
  strut.style.width = "30px";
  strut.style.lineHeight = t.offsetHeight + mid.offsetHeight + b.offsetHeight + "px";
  // add negative space after to account for all the shifting around
  group.style.marginRight = (bleft - 30 + w) + "px";
}

function toggle (x) {
  for ( i = 0 ; i < x.childNodes.length ; i++) {
    if (x.childNodes.item(i).style.display=='inline') {
      x.childNodes.item(i).style.display='none';
      if ( i+1 == x.childNodes.length) {
        x.childNodes.item(0).style.display='inline';
      } else {
        x.childNodes.item(i+1).style.display='inline';
      };
      break;
    }
  }
}


/* FOLLOWING FUNCTIONS ARE DEPRECATED AND REMAIN IN STYLESHEET 
ONLY TO SUPPORT CALLS TO EXISTING SMUGGLER HELP FILES. 
IF YOUR HELP FILE DOESN'T ALREADY USE THESE FUNCTIONS, DON'T USE THEM NOW
These functions should not be called by newer help files but are left in the script
because older help files use them (including many existing Smuggler templates */


/*launch help window and display file specified in locationpath parameter.
if locationpath points to a frameset, optional topicfile parameter specifies
the file to display in the topic frame. This must be done in two steps
cuz you can't update the topic frame until after frameset is loaded*/
/* DEPRECATED */
function launchHelp(locationpath, topicfile){
	if (topicfile) {
		lastslashpos = locationpath.lastIndexOf("/");
    rootpath = locationpath.substr(0, lastslashpos + 1);
    topicpathname =  rootpath + topicfile;
		startHelp(topicpathname);
	} else {
		startHelp(locationpath);
	}
}


/*after displaying a help frameset, checks whether file is displayed in a secondary window.
If yes, assume launchHelp() function was used and check value of topicvar to determine
what topic to display. If frameset was launched in main window, 
or if no topic was specified, do nothing*/
/* DEPRECATED */
function launchHelpTopic() {
  
	if (window.opener) {  //true only when frameset is launched in a secondary window 
    if (window.opener.topicvar != "notopic") { //if not topic specified, do nothing
      parent.topic.location=window.opener.topicvar
    }
	}
}


/* Here's a sister function for launchHelp(), which loads the help files in
the current window rather than opening a new one. 
if locationpath points to a frameset, optional topicfile parameter specifies
the file to display in the topic frame. This must be done in two steps
cuz you can't update the topic frame until after frameset is loaded*/
/* DEPRECATED */
function loadHelp(locationpath, topicfile){
	
  //if topic file was specified, save to global var that will persist after frameset is loaded
	if (topicfile) topicvar=topicfile
		else {topicvar = "notopic"}
  self.location = locationpath;
  self.resizeTo(700,550);
}


// end hiding scripts from silly old browswers -->





