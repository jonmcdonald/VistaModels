// Copyright (c) 2000-2006 Mentor Graphics Corporation.  All rights reserved.
//

//MGCRK - new function to open help on search/other mini-helps
function PopupTopic(url) 
   {
       chrome = "location=0,"
         + "width=600," 
         + "height=500," 
         + "menubar=0,"
         + "resizable=1,"
         + "scrollbars=1,"
         + "status=0," 
         + "titlebar=1,"
         + "toolbar=0,"
         + "hotkeys=0,"
         + "left=450,"
         + "top=100";
       x=window.open(url,'',chrome);
       x.focus();
}

function oT(behavior,topic,context)
{
   // Make sure the book is installed before trying to link to it
   //
   //mLibraryList
   var  WWHFrame = eval("parent.parent");
   var Installed = false;
   var DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
   if (WWHFrame.WWHHelp.fSingleTopic())
   {
      DocumentFramePath = WWHFrame.MGCContent;
   }
   CurrentDocHandle = DocumentFramePath.DocHandle;
   if ( typeof(context) == "undefined")
      { context = CurrentDocHandle; }
   if ( typeof(WWHFrame.mLibraryList) == "undefined")
   {
      DMerge = false;
      alert("This document tree has not been properly installed.\nSearches, Index, and interbook links will not work.\nContact your System Administrator or Support at Mentor Graphics.");
   }
   else
   {
      for (MaxIndex = WWHFrame.mLibraryList.length, Index = 0 ; Index < MaxIndex ; Index++)
      {
         if (context == WWHFrame.mLibraryList[Index][1])
            { Installed = true; }
      }
   }
   if ((!Installed) && (behavior != "PDF"))
   {
      alert("The requested document is not currently installed in your SW Tree");
      return;
   }
   // remove any special characters from the topic title
   var topic = topic.replace("[^A-Z,a-z,0-9,_\-]","");
   topic = topic.replace(/ /g,"");
//   topic = topic.replace(/-/g,"");
   var url;
   var file;
   if (behavior == "STD")
   {
      if (context == CurrentDocHandle)
      {
         // Open topic within same document
         file = WWHBookData_MatchTopic(topic);
         window.location=file;
      }
      else
      {
         // Open topic within different document
         url = "../" + context + "/" + "wwhelp.htm\?context=" + context + "\&topic=" + topic;
         WWHFrame.location = url;
      }
   }
   if (behavior == "SNG")
   {
      // Open topic in separate window in "single mode" (no tabs w/nav buttons)
      if (context == CurrentDocHandle)
      {
         file = WWHFrame.WWHBookData_MatchTopic(topic);
         url = "../" + context + "/" + file;
      }
      else
      {
         url = "../" + context + "/" + "wwhelp/wwhimpl/common/html/wwhelp.htm\?context=" + context + "\&topic=" + topic + "\&single=true";
      }
      PopupWindow(url,800,400);
   }
   if (behavior == "CRF") {
      // Open cross-reference topic within same document
      window.location=topic;
      if ( typeof(WWHFrame.InSingleTopic) != "undefined" && WWHFrame.InSingleTopic != "YES" )
      {
         WWHFrame.WWHControls.fClickedSyncTOC();
      }
   }
   if (behavior == "NEW") {
      // Open topic within different document, new window, all navigation & tabs
      var url = "../" + context + "/" + "wwhelp.htm\?context=" + context + "\&topic=" + topic;
      window.open(url);
      //PopupWindow(url,800,400);
   }
   if (behavior == "OLH") {
      // Open topic for a RoboHelp generated OLH, new window
      var url = "../" + context + "/" + context + ".htm\#" + "topic";
      window.open(url);
   }
   if (behavior == "PDF") {
      // Open PDF topic, new window
      var url = "../../pdfdocs/" + context + ".pdf";
      PopupWindow(url,600,800);
   }
   if (behavior == "POP") {
      // Open popup topic, new window, no menu, etc.
      var url = "../" + context + "/" + "wwhelp.htm\?context=" + context + "\&topic=" + topic + "\&single=popup";
      PopupWindow(url,600,400);
   }
}

//MGCRK - new function to open help on search/other mini-helps
function PopupWindow(url,width,height) 
   {
       chrome = "location=0,"
         + "width=" + width + "," 
         + "height=" + height + "," 
         + "menubar=0,"
         + "resizable=1,"
         + "scrollbars=1,"
         + "status=0," 
         + "titlebar=1,"
         + "toolbar=0,"
         + "hotkeys=0,"
         + "left=450,"
         + "top=100";
       x=window.open(url,'',chrome);
       x.focus();
}
