// Copyright (c) 2006 Mentor Graphics Corporation.  All rights reserved.
//

//MGCRK - added new function to update navigation pane
//        if in a different manual than the last one to
//        ensure that the doc title is updated
//

function MGCUpdateNavPane()
{
   var DocumentFramePath;
   if (WWHFrame.HighlightSearchTerms)
   {
      WWHFrame.MGCHighlightSearchTerms(WWHFrame.WWHSearch.mSavedSearchWords,false);
   }
   WWHFrame.HighlightSearchTerms = false;
   if (WWHFrame.popup != "YES")
   {
      if (!WWHFrame.WWHHelp.fSingleTopic())
      {
         if (WWHFrame.WWHJavaScript.mCurrentTab == 1)
         {
            WWHFrame.UpdateIndexScope();
         }
         if (WWHFrame.WWHJavaScript.mCurrentTab == 2)
         {
            WWHFrame.UpdateSearchScope();
         }
         if (WWHFrame.WWHJavaScript.mCurrentTab == 3)
         {
            WWHFrame.MGCNavigate.MGCIndex.location.reload(true);
         }
      }
   }
}
function MGCGetLevel(level)
{
   var hier = "";
   for (MaxIndex = level, Index = 0 ; Index < MaxIndex-1 ; Index++)
   {
      hier += "../";
   }
   return hier;
}
function MGCGetDocumentStyleSheet(level)
{
   return "<link rel=\"stylesheet\" href=\"" + MGCGetLevel(level) + "document.css\" type=\"text/css\" />";
}
function MGCGetPGFStyleSheet(level)
{
   var catalog = "catalog.css";
//   if (WWHFrame.operatingsystem == "Unix") { catalog = "catalogU.css"};
//   if (WWHFrame.operatingsystem == "Windows") { catalog = "catalog.css"};
//   if (WWHFrame.operatingsystem == "Linux") { catalog = "catalogU.css"};
   return "<link rel=\"stylesheet\" href=\"" + MGCGetLevel(level) + catalog + "\" type=\"text/css\" />";
}
function MGCGetInternalStyleSheet(level)
{
   return MGCGenerateBodyStyle() + "\n<link rel=\"stylesheet\" href=\"" + "../" + "internal.css\" type=\"text/css\" />";
}

function  MGCGenerateBodyStyle()
{
  var  BodyHTML = "";
  BodyHTML += "<style type=\"text/css\">\n";
  BodyHTML += " <!--\n";
  BodyHTML += " body {\n";
  BodyHTML += "   background-color: #FFFFFF;\n";
  BodyHTML += "   color: Black;\n";
  BodyHTML += "   font-family: Verdana, Arial, Helvetica, sans-serif;\n";
  BodyHTML += "   font-size: " + WWHFrame.BaseBodyFontSize + "px;\n";
  BodyHTML += "   font-variant: normal;\n";
  BodyHTML += "   font-style: normal;\n";
  BodyHTML += "   font-weight: normal;\n";
  BodyHTML += "   text-decoration: none;\n";
  BodyHTML += "   text-indent: 0px;\n";
  BodyHTML += "   text-transform: none;\n";
  BodyHTML += "   text-align: left;\n";
  BodyHTML += "   margin-left: 10px;\n";
  BodyHTML += "   margin-right: 10px;\n";
  BodyHTML += " }\n";
  BodyHTML += " // -->\n";
  BodyHTML += "</style>\n";
  return BodyHTML;
}







function MGCInsertRTHeader(ix)
{
   Pointers = mBreadcrumb[ix];
   L1ptr = Pointers[0];
   if (L1ptr == 0) { return; }
   L2ptr = Pointers[1];
   L3ptr = Pointers[2];
   
   Bread1 = mFileList[L1ptr][1];
   Bread2 = "";
   Bread3 = "";
   if ( (L2ptr != 0) && (L3ptr != 0) )
   { 
      Bread1 = "<a href=\"" + mFileList[L1ptr][0] + ".html\">" + mFileList[L1ptr][1] + "</a> ";
      Bread2 = "&nbsp;&gt;&nbsp;<a href=\"" + mFileList[L2ptr][0] + ".html\">" + mFileList[L2ptr][1] + "</a>";
      Bread3 = "&nbsp;&gt;&nbsp;" + mFileList[L3ptr][1];
   }
   if ( (L2ptr != 0) && (L3ptr == 0) )
   { 
      Bread1 = "<a href=\"" + mFileList[L1ptr][0] + ".html\">" + mFileList[L1ptr][1] + "</a> ";
      Bread2 = "&nbsp;&gt;&nbsp;" + mFileList[L2ptr][1];
      Bread3 = "";
   }
   document.write("<p class=\"pMGCBreadcrumbs\">" + Bread1 + Bread2 + Bread3 + "</p><hr>");
}
function MGCInsertRTFooter()
{
   var DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
   if (WWHFrame.WWHHelp.fSingleTopic())
   {
      DocumentFramePath = WWHFrame.MGCContent;
   }
   if (DocumentFramePath.ThisTopic == "manualtitle")
   {
      document.write("<br clear=\"left\" /><table width=\"90\%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" background=\"wwhelp/wwhimpl/common/images/splash_screen_bottom2.gif\"><tr height=\"200\"><td>&nbsp\;</td></tr></table>");
      document.write("<p class=\"pMGCFooter\"><a href=\"javascript:WWHFrame.DisplayHelp('../mgc_html_help/mgc_html_help.htm?topic=browser_settings.html')\">Browser Requirements</a></p>");
      return false;
   }
   document.write("<br /><br />\n");
   if (Draft == "DRAFT")
   {
      document.write("<p class=\"pMGCFooter\"><span class=\"cBold\">DRAFT</span></p>\n");
   }
   document.write("<p class=\"pMGCFooter\">" + DocumentFramePath.DocTitle + ",&nbsp;" + DocumentFramePath.SWRelease + "</p>\n");
   document.write("<p class=\"pMGCFooter\">&#169;&nbsp;" + DocumentFramePath.Copyright + "&nbsp;Mentor Graphics Corporation. All rights reserved.</p>");
   document.write("<p class=\"pMGCFooter\"><a href=\"javascript:WWHFrame.DisplayHelp('../mgc_html_help/mgc_html_help.htm?topic=browser_settings.html')\">Browser Requirements</a></p>");
}

// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHGetWWHFrame(ParamToBookDir)
{
  var  Frame = null;


  // Set reference to top level help frame
  //
  if ((typeof(parent.WWHHelp) != "undefined") &&
      (parent.WWHHelp != null))
  {
    Frame = eval("parent");
  }
  else if ((typeof(parent.parent.WWHHelp) != "undefined") &&
           (parent.parent.WWHHelp != null))
  {
    Frame = eval("parent.parent");
  }

  // Redirect if Frame is null
  //
  if (Frame == null)
  {
    var  bPerformRedirect = true;
    var  Agent;


    // No redirect if running Netscape 4.x
    //
    Agent = navigator.userAgent.toLowerCase();
    if ((Agent.indexOf("mozilla") != -1) &&
        (Agent.indexOf("spoofer") == -1) &&
        (Agent.indexOf("compatible") == -1))
    {
      var  MajorVersion;


      MajorVersion = parseInt(navigator.appVersion)
      if (MajorVersion < 5)
      {
        window.location.replace("wwhelp/wwhimpl/js/html/browser_reqmts.html");
        bPerformRedirect = false;  // Skip redirect for Netscape 4.x
      }
    }

    if (bPerformRedirect)
    {
      var  BaseFilename;


      BaseFilename = location.href.substring(location.href.lastIndexOf("/") + 1, location.href.length);

      if (ParamToBookDir.length > 0)
      {
        var  RelativePathList = ParamToBookDir.split("/");
        var  PathList         = location.href.split("/");
        var  BaseList = new Array();
        var  MaxIndex;
        var  Index;


        PathList.length--;
        for (MaxIndex = RelativePathList.length, Index = 0 ; Index < MaxIndex ; Index++)
        {
          if (RelativePathList[Index] == ".")
          {
            ;  // Do nothing!
          }
          else if (RelativePathList[Index] == "..")
          {
            if (BaseList.length == 0)
            {
              BaseList[BaseList.length] = PathList[PathList.length - 1];
              PathList.length = PathList.length - 1;
            }
            else
            {
              BaseList.length--;
            }
          }
          else
          {
            BaseList[BaseList.length] = RelativePathList[Index];
          }
        }

        BaseFilename = BaseList.join("/") + BaseFilename;
      }

      location.replace(WWHToWWHelpDirectory() + ParamToBookDir + "wwhelp/wwhimpl/common/html/wwhelp.htm?context=" + WWHBookData_Context() + "&file=" + BaseFilename);
    }
  }

  return Frame;
}


//MGCRK New functions to Show/Hide progressive disclosure Div's

function ShowHidePDInfo(id,state)
{
 iState = 1;
 if (state == "hide") { iState = 0; }
 szDivID = id;
 szDivIDShow = id + "Show";
 if (state == 'show')
 {
    if (document.getElementById)	  //gecko(NN6) + IE 5+
    {
       var obj = document.getElementById(szDivID);
       var obj2 = document.getElementById(szDivIDShow);
       obj.style.visibility = "visible";
       obj.style.display = "block";
       obj2.style.visibility = "hidden";
       obj2.style.display = "none";
    }
    else if(WWHFrame.MGCContent.MGCDocContent.document.all)	// IE 4
    {
       document.all[szDivID].style.visibility = "visible";
       document.all[szDivID].style.display = "block";
       document.all[szDivIDShow].style.visibility = "hidden";
       document.all[szDivIDShow].style.display = "none";
    }
 }
 else
 {
    if (document.getElementById)	  //gecko(NN6) + IE 5+
    {
       var obj = document.getElementById(szDivID);
       var obj2 = document.getElementById(szDivIDShow);
       obj.style.visibility = "hidden";
       obj.style.display = "none";
       obj2.style.visibility = "visible";
       obj2.style.display = "block";
    }
    else if(WWHFrame.MGCContent.MGCDocContent.document.all)	// IE 4
    {
       document.all[szDivID].style.visibility = "hidden";
       document.all[szDivID].style.display = "none";
       document.all[szDivIDShow].style.visibility = "visible";
       document.all[szDivIDShow].style.display = "block";
    }
 
 } 
}




function  WWHShowPopup(ParamContext,
                       ParamLink,
                       ParamEvent)
{
  if (WWHFrame != null)
  {
    if ((ParamEvent == null) &&
        (typeof(window.event) != "undefined"))
    {
      ParamEvent = window.event;  // Older IE browsers only store event in window.event
    }

    WWHFrame.WWHHelp.fShowPopup(ParamContext, ParamLink, ParamEvent);
  }
}

function  WWHHidePopup()
{
  if (WWHFrame != null)
  {
    WWHFrame.WWHHelp.fHidePopup();
  }
}

function  WWHClickedPopup(ParamContext,
                          ParamLink)
{
  if (WWHFrame != null)
  {
    WWHFrame.WWHHelp.fClickedPopup(ParamContext, ParamLink);
  }
}

function  WWHShowTopic(ParamContext,
                       ParamTopic)
{
  if (WWHFrame != null)
  {
    WWHFrame.WWHHelp.fShowTopic(ParamContext, ParamTopic);
  }
}

function  WWHUpdate()
{
  if (WWHFrame.NavIconsEnabled != "ENABLE")
  {
     return;
  }
  var  bVarSuccess = true;
  if (WWHFrame != null)
  {
    bVarSuccess = WWHFrame.WWHHelp.fUpdate(location.href);
  }

  return bVarSuccess;
}

function  WWHUnload()
{
  var  bVarSuccess = true;


  if (WWHFrame != null)
  {
    if (typeof(WWHFrame.WWHHelp) != "undefined")
    {
      bVarSuccess = WWHFrame.WWHHelp.fUnload();
    }
  }

  return bVarSuccess;
}

function  WWHHandleKeyDown(ParamEvent)
{
  var  bVarSuccess = true;


  if (WWHFrame != null)
  {
    bVarSuccess = WWHFrame.WWHHelp.fHandleKeyDown(ParamEvent);
  }

  return bVarSuccess;
}

function  WWHHandleKeyPress(ParamEvent)
{
  var  bVarSuccess = true;


  if (WWHFrame != null)
  {
    bVarSuccess = WWHFrame.WWHHelp.fHandleKeyPress(ParamEvent);
  }

  return bVarSuccess;
}

function  WWHHandleKeyUp(ParamEvent)
{
  var  bVarSuccess = true;


  if (WWHFrame != null)
  {
    bVarSuccess = WWHFrame.WWHHelp.fHandleKeyUp(ParamEvent);
  }

  return bVarSuccess;
}

function  WWHClearRelatedTopics()
{
  if (WWHFrame != null)
  {
    WWHFrame.WWHRelatedTopics.fClear();
  }
}

function  WWHAddRelatedTopic(ParamText,
                             ParamContext,
                             ParamFileURL)
{
  if (WWHFrame != null)
  {
    WWHFrame.WWHRelatedTopics.fAdd(ParamText, ParamContext, ParamFileURL);
  }
}

function  WWHRelatedTopicsInlineHTML()
{
  var  HTML = "";


  if (WWHFrame != null)
  {
    HTML = WWHFrame.WWHRelatedTopics.fInlineHTML();
  }

  return HTML;
}

function  WWHDoNothingHREF()
{
  // Nothing to do.
  //
}

function  WWHShowRelatedTopicsPopup(ParamEvent)
{
  if (WWHFrame != null)
  {
    if ((ParamEvent == null) &&
        (typeof(window.event) != "undefined"))
    {
      ParamEvent = window.event;  // Older IE browsers only store event in window.event
    }

    WWHFrame.WWHRelatedTopics.fShowAtEvent(ParamEvent);
  }
}

function  WWHShowALinksPopup(ParamKeywordArray,
                             ParamEvent)
{
  if (WWHFrame != null)
  {
    if ((ParamEvent == null) &&
        (typeof(window.event) != "undefined"))
    {
      ParamEvent = window.event;  // Older IE browsers only store event in window.event
    }

    WWHFrame.WWHALinks.fShow(ParamKeywordArray, ParamEvent);
  }
}

function  WWHRelatedTopicsDivTag()
{
  var  RelatedTopicsDivTag = "";


  if (WWHFrame != null)
  {
    RelatedTopicsDivTag = WWHFrame.WWHRelatedTopics.fPopupHTML();
  }

  return RelatedTopicsDivTag;
}

function  WWHPopupDivTag()
{
  var  PopupDivTag = "";


  if (WWHFrame != null)
  {
    PopupDivTag = WWHFrame.WWHHelp.fPopupHTML();
  }

  return PopupDivTag;
}

function  WWHALinksDivTag()
{
  var  ALinksDivTag = "";


  if (WWHFrame != null)
  {
    ALinksDivTag = WWHFrame.WWHALinks.fPopupHTML();
  }

  return ALinksDivTag;
}


