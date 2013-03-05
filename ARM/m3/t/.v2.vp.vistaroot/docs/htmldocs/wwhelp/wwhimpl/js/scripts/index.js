// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHIndex_Object()
{
  this.mbPanelInitialized  = false;
  this.mPanelAnchor        = null;
  this.mPanelTabTitle      = WWHFrame.WWHJavaScript.mMessages.mTabsIndexLabel;
  this.mPanelTabIndex      = -1;
  this.mPanelFilename      = ((WWHFrame.WWHBrowser.mBrowser == 1) ? "panelfni.htm" : "panelfsi.htm");
  this.mInitIndex          = 0;
  this.mOptions            = new WWHIndexOptions_Object();
  this.mTopEntry           = new WWHIndexEntry_Object(false, -1, null);
  this.mMaxLevel           = 0;
  this.mEntryCount         = 0;
  this.mSeeAlsoArray       = new Array();
  this.mSectionIndex       = 0;
  this.mbThresholdExceeded = null;
  this.mSectionCache       = new WWHSectionCache_Object();
  this.mIterator           = new WWHIndexIterator_Object();
  this.mHTMLSegment        = new WWHStringBuffer_Object();
  this.mEventString        = WWHPopup_EventString();
  this.mClickedEntry       = null;

  this.fInitHeadHTML          = WWHIndex_InitHeadHTML;
  this.fInitBodyHTML          = WWHIndex_InitBodyHTML;
  this.fInitLoadBookIndex     = WWHIndex_InitLoadBookIndex;
  this.fAddSeeAlsoEntry       = WWHIndex_AddSeeAlsoEntry;
  this.fProcessSeeAlsoEntries = WWHIndex_ProcessSeeAlsoEntries;
  this.fNavigationHeadHTML    = WWHIndex_NavigationHeadHTML;
  this.fNavigationBodyHTML    = WWHIndex_NavigationBodyHTML;
  this.fHeadHTML              = WWHIndex_HeadHTML;
  this.fStartHTMLSegments     = WWHIndex_StartHTMLSegments;
  this.fAdvanceHTMLSegment    = WWHIndex_AdvanceHTMLSegment;
  this.fGetHTMLSegment        = WWHIndex_GetHTMLSegment;
  this.fEndHTMLSegments       = WWHIndex_EndHTMLSegments;
  this.fPanelNavigationLoaded = WWHIndex_PanelNavigationLoaded;
  this.fPanelViewLoaded       = WWHIndex_PanelViewLoaded;
  this.fHoverTextTranslate    = WWHIndex_HoverTextTranslate;
  this.fHoverTextFormat       = WWHIndex_HoverTextFormat;
  this.fGetPopupAction        = WWHIndex_GetPopupAction;
  this.fThresholdExceeded     = WWHIndex_ThresholdExceeded;
  this.fGetSectionNavigation  = WWHIndex_GetSectionNavigation;
  this.fDisplaySection        = WWHIndex_DisplaySection;
  this.fSelectionListHeadHTML = WWHIndex_SelectionListHeadHTML;
  this.fSelectionListBodyHTML = WWHIndex_SelectionListBodyHTML;
  this.fSelectionListLoaded   = WWHIndex_SelectionListLoaded;
  this.fDisplayLink           = WWHIndex_DisplayLink;
  this.fGetEntry              = WWHIndex_GetEntry;
  this.fClickedEntry          = WWHIndex_ClickedEntry;
  this.fClickedSeeAlsoEntry   = WWHIndex_ClickedSeeAlsoEntry;

  // Set options
  //
  WWHJavaScriptSettings_Index_DisplayOptions(this.mOptions);
}

function  WWHIndex_InitHeadHTML()
{
  var  InitHeadHTML = "";


  return InitHeadHTML;
}

function  WWHIndex_InitBodyHTML()
{
  var  VarHTML = new WWHStringBuffer_Object();
  var  VarBookList = WWHFrame.WWHHelp.mBooks.mBookList;
//  var  MGCBooklist = new Array;


  // Display initializing message
  //
  VarHTML.fAppend("<h2>" + WWHFrame.WWHJavaScript.mMessages.mInitializingMessage + "</h2>\n");

  // Load index data
  //
  this.mInitIndex = 0;
  for (MaxIndex = VarBookList.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
    // Reference Index data
    //
    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(VarBookList[Index].mDirectory) + "wwhdata/js/index.js\"></script>\n");

    // Load Index data for current book
    //
    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/index1s.js\"></script>\n");
//    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhdata/wwhimpl/js/scripts/index1s.js\"></script>\n");
  }
//MGCRK added document.js and LibraryName.js
//    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/document.js\"></script>\n");
//    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/Index/LibraryName.js\"></script>\n");
//    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/IndexSearchCommon.js\"></script>\n");

  return VarHTML.fGetBuffer();
}

function  WWHIndex_InitLoadBookIndex(ParamAddIndexEntriesFunc)
{
  var  VarMaxIndex;
  var  VarIndex;


  // Load Index
  //
  ParamAddIndexEntriesFunc(this.mTopEntry);

  // Increment init book index
  //
  this.mInitIndex++;

  // Check if done
  //
  if (this.mInitIndex == WWHFrame.WWHHelp.mBooks.mBookList.length)
  {
    // Process see also entries to set up links between source and target
    // Do this before the top level hashes are cleared by the sort children call
    //
    this.fProcessSeeAlsoEntries();

    // Sort top level entries
    //
    if (this.mTopEntry.mChildrenSortArray == null)
    {
      WWHIndexEntry_SortChildren(this.mTopEntry);
    }

    // Assign section indices
    //
    for (VarMaxIndex = this.mTopEntry.mChildrenSortArray.length, VarIndex = 0 ; VarIndex < VarMaxIndex ; VarIndex++)
    {
      this.mTopEntry.mChildrenSortArray[VarIndex].mSectionIndex = VarIndex;
    }

    // Panel is initialized
    //
    this.mbPanelInitialized = true;
  }
}

function  WWHIndex_AddSeeAlsoEntry(ParamEntry)
{
  this.mSeeAlsoArray[this.mSeeAlsoArray.length] = ParamEntry;
}

function  WWHIndex_ProcessSeeAlsoEntries()
{
  var  VarMaxIndex;
  var  VarIndex;
  var  VarEntry;
  var  VarSeeAlsoGroupEntry;
  var  VarSeeAlsoEntry;


  // Set see also references
  //
  for (VarMaxIndex = this.mSeeAlsoArray.length, VarIndex = 0 ; VarIndex < VarMaxIndex ; VarIndex++)
  {
    // Access entry
    //
    VarEntry = this.mSeeAlsoArray[VarIndex];

    // Access group entry
    //
    VarSeeAlsoGroupEntry = this.mTopEntry.mChildren[VarEntry.mSeeAlsoGroupKey + "~"];
    if ((typeof(VarSeeAlsoGroupEntry) != "undefined") &&
        (VarSeeAlsoGroupEntry != null) &&
        (VarSeeAlsoGroupEntry.mChildren != null))
    {
      // Access see also entry
      //
      VarSeeAlsoEntry = VarSeeAlsoGroupEntry.mChildren[VarEntry.mSeeAlsoKey + "~"];
      if ((typeof(VarSeeAlsoEntry) != "undefined") &&
          (VarSeeAlsoEntry != null))
      {
        // Setup links between source and destination
        //

        // See if target entry is already tagged
        //
        if (typeof(VarSeeAlsoEntry.mSeeAlsoTargetName) == "undefined")
        {
          // Update target entry
          //
          VarSeeAlsoEntry.mSeeAlsoTargetName = "s" + VarIndex;
        }

        // Update source entry
        //
        VarEntry.mSeeAlsoTargetName = VarSeeAlsoEntry.mSeeAlsoTargetName;
        VarEntry.mSeeAlsoTargetGroupID = VarSeeAlsoGroupEntry.mGroupID;
      }
    }
  }

  // Clear see also array
  //
  this.mSeeAlsoArray = null;
}

function  WWHIndex_NavigationHeadHTML()
{
  var  HTML = new WWHStringBuffer_Object();
  var  WWHFrame = eval("parent.parent.parent");
  // Generate style section
  //
//  HTML.fAppend(WWHFrame.MGCWWGenerateNavStyle());
  HTML.fAppend("<style type=\"text/css\">\n");
  HTML.fAppend(" <!--\n");
  HTML.fAppend("  a.selected\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mNavigationCurrentColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  a.enabled\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mNavigationEnabledColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p.ActiveLetter\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    " + WWHFrame.WWHJavaScript.mSettings.mIndex.mNavigationFontStyle + ";\n");
  HTML.fAppend("    font-weight: bold;\n");
  HTML.fAppend("    font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p.pInActiveLetter\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n");
  HTML.fAppend("  font-style: normal;\n");
  HTML.fAppend("  font-variant: normal;\n");
  HTML.fAppend("  font-weight: bold;\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p.navigation\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mNavigationDisabledColor + ";\n");
  HTML.fAppend("    " + WWHFrame.WWHJavaScript.mSettings.mIndex.mNavigationFontStyle + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("    p.MGCCIndexNavigation {\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 0pt;\n");
  HTML.fAppend("    	font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    	font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
  HTML.fAppend("    }\n");
  HTML.fAppend("    p.MGCFormTitleB {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    	font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    	font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
  HTML.fAppend("    	color: #000000;\n");
  HTML.fAppend("    }\n");
  HTML.fAppend("    p.MGCScopeSel {\n");
  HTML.fAppend("    margin-top: 0pt;\n");
  HTML.fAppend("    margin-left: 0.28in;\n");
  HTML.fAppend("    margin-bottom: 0pt;\n");
  HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
  HTML.fAppend("    text-indent: -0.22in;\n");
  HTML.fAppend("    	color: #000000;\n");
  HTML.fAppend("    }\n");


  HTML.fAppend("    a\:link    { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:visited { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:active, focus:  { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:hover   { color\: #0000FF\;text-decoration\: underline\; }\n");
  HTML.fAppend("  }\n");
  HTML.fAppend(" -->\n");
  HTML.fAppend("</style>\n");
  return HTML.fGetBuffer();
}


// MGCRK - rewrote this to handle our custom index
// MGCRK - This is the index letter navigator panel.
//
function  WWHIndex_NavigationBodyHTML()
{
   var  HTML = new WWHStringBuffer_Object();
   var  VarMaxIndex;
   var  VarIndex;
   var  Letter;
   var  Letterl;
   var  WWHFrame = eval("parent.parent.parent");
   WWHFrame.InGlobalIndex = true;

   HTML.fAppend("<style type=\"text/css\">\n");
   HTML.fAppend(" <!--\n");
   HTML.fAppend("    input {\n");
   HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-se;\n");
   HTML.fAppend("    font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
   HTML.fAppend("    margin-top: 0pt;\n");
   HTML.fAppend("    vertical-align: text-top;\n");
   MarginBottom = 3;
   if (WWHFrame.browsername == "Internet Explorer") { MarginBottom = 0; }
   HTML.fAppend("    margin-bottom: " + MarginBottom + "pt;\n");
   HTML.fAppend("    }\n");

   HTML.fAppend("  p.MenuItemB\n");
   HTML.fAppend("  {\n");
   HTML.fAppend("    color: Black;\n");
   HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-se;\n");
   HTML.fAppend("    font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
   HTML.fAppend("    line-height: " + WWHFrame.BaseNavFontSize + "px;\n");
   HTML.fAppend("    margin-bottom: 2px;\n");
   HTML.fAppend("    margin-top: 2px;\n");
   HTML.fAppend("    margin-left: 10px;\n");
   HTML.fAppend("    margin-right: 2px;\n");
   HTML.fAppend("    font-style: normal;\n");
   HTML.fAppend("    font-variant: normal;\n");
   HTML.fAppend("    font-weight: normal;\n");
   HTML.fAppend("    text-decoration: none;\n");
   HTML.fAppend("    text-indent: 0in;\n");
   HTML.fAppend("    text-transform: none;\n");
   HTML.fAppend("  }\n");
   HTML.fAppend("  p.MenuItemW\n");
   HTML.fAppend("  {\n");
   HTML.fAppend("    color: White;\n");
   HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-se;\n");
   HTML.fAppend("    font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
   HTML.fAppend("    line-height: " + WWHFrame.BaseNavFontSize + "px;\n");
   HTML.fAppend("    margin-bottom: 2px;\n");
   HTML.fAppend("    margin-top: 2px;\n");
   HTML.fAppend("    margin-left: 10px;\n");
   HTML.fAppend("    margin-right: 2px;\n");
   HTML.fAppend("    font-style: normal;\n");
   HTML.fAppend("    font-variant: normal;\n");
   HTML.fAppend("    font-weight: normal;\n");
   HTML.fAppend("    text-decoration: none;\n");
   HTML.fAppend("    text-indent: 0in;\n");
   HTML.fAppend("    text-transform: none;\n");
   HTML.fAppend("  }\n");
   HTML.fAppend("  .BarMenuItemW\n");
   HTML.fAppend("  {\n");
   HTML.fAppend("    color: White;\n");
   HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-se;\n");
   HTML.fAppend("    font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
   HTML.fAppend("    line-height: " + WWHFrame.BaseNavFontSize + "px;\n");
   HTML.fAppend("    margin-bottom: 2px;\n");
   HTML.fAppend("    margin-top: 2px;\n");
   HTML.fAppend("    margin-left: 10px;\n");
   HTML.fAppend("    margin-right: 2px;\n");
   HTML.fAppend("    font-style: normal;\n");
   HTML.fAppend("    font-variant: normal;\n");
   HTML.fAppend("    font-weight: bold;\n");
   HTML.fAppend("    text-decoration: none;\n");
   HTML.fAppend("    text-indent: 0in;\n");
   HTML.fAppend("    text-transform: none;\n");
   HTML.fAppend("  }\n");
   HTML.fAppend("  .MenuItemB:active, .MenuItemB:focus\n");
   HTML.fAppend("  {\n");
   HTML.fAppend("    text-decoration: none;\n");
   HTML.fAppend("    color: blue;\n");
   HTML.fAppend("  }\n");
   HTML.fAppend("  .BarMenuItemW:active, .BarMenuItemW:focus\n");
   HTML.fAppend("  {\n");
   HTML.fAppend("    text-decoration: none;\n");
   HTML.fAppend("    color: white;\n");
   HTML.fAppend("  }\n");
   HTML.fAppend("  .BarMenuItemW a:link\n");
   HTML.fAppend("  {\n");
   HTML.fAppend("    text-decoration: none;\n");
   HTML.fAppend("    color: white;\n");
   HTML.fAppend("  }\n");
   HTML.fAppend("  .BarMenuItemW a:hover\n");
   HTML.fAppend("  {\n");
   HTML.fAppend("    text-decoration: underline;\n");
   HTML.fAppend("    color: white;\n");
   HTML.fAppend("  }\n");

   HTML.fAppend(" -->\n");
   HTML.fAppend("</style>\n");



   HTML.fAppend(WWHFrame.InsertIXPopupDivStyles());
   HTML.fAppend(WWHFrame.InsertIndexOptions());
   TabTitle = "Index Scope";
   HTML.fAppend("<div class=\"mIXScope\" id=\"MGCSScopeDiv\";>");
   HTML.fAppend("<form name=\"ScopeSelectIX\";\">\n");
   HTML.fAppend(WWHFrame.InsertIXDocTitleScope());
   HTML.fAppend("</form>");
   HTML.fAppend("</div>");
   HTML.fAppend("<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + WWHFrame.BaseNavFontSize + "px\" margin-top: 1pt margin-bottom: 1pt>");
   MenuLink = "<a style=\"color:#FFFFFF\" href=\"javascript:WWHFrame.myvoid()\" onclick=\"WWHFrame.ShowIndexOptions();\" title=\"Click to change index options.\">";
   MenuLink += "<b>Options&nbsp;<img src=\"../../common/images/menu_up.gif\" border=0 /></b></a>";
   if (WWHFrame.ShowSearchBooks == "NO")
   { SearchTitle = "<b><span class=\"BarMenuItemW\">&nbsp;&nbsp;Topic:</span></b>"; }
   else
   { SearchTitle = "<b><span class=\"BarMenuItemW\">&nbsp;&nbsp;Book/Topic:</b></span>"; }
   HTML.fAppend("<div STYLE=\"position:absolute; left:0px; bottom:0px; width:98%;background-color:#416E98; border: 2px solid #000000; border-top-width: 2px;border-top-color: grey;border-left-width: 2px;border-left-color: grey;border-right-width: 2px;border-right-color: #000000; \">");
   HTML.fAppend("<table border=0 cellpadding=0 cellspacing=0>\n");
   HTML.fAppend("<tr><td class=\"MGCNowrap\" width=25% height=\"12\">" + "" + "</td>");
   HTML.fAppend("<td class=\"MGCNowrap\" width=45%>" + SearchTitle + "</td>");
   HTML.fAppend("<td class=\"MGCNowrap\" width=30%><span class=\"BarMenuItemW\">" + MenuLink + "</span></td>");
   HTML.fAppend("</tr></table></div>");
   ActiveButtonDiv = "<div STYLE=\"background-color:#999999; border: 2px solid #000000; border-top-width: 2px;border-top-color: grey;border-left-width: 3px;border-left-color: grey;border-right-width: 3px;border-right-color: #000000; \">";
   InActiveButtonDiv = "<div STYLE=\"background-color:#99FFFF; border: 2px solid #000000; border-top-width: 2px;border-top-color: grey;border-left-width: 3px;border-left-color: grey;border-right-width: 3px;border-right-color: #000000; \">";
   HTML.fAppend("<tr><td colspan=\"3\" height=\"2\"></td></tr>");
   HTML.fAppend("<tr><td colspan=\"3\" height=\"2\" bgcolor=\"\#000000\"></td></tr>");
   HTML.fAppend("<tr valign=\"middle\"><td width=\"19\" valign=\"middle\"></td><td>");
   var IXLetters = "&ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   if (MGCCookiesEnabled())
   {
       WWHFrame.LastIndexLetter = MGCGetCookie("MGCLastIndexLetter");
       if (WWHFrame.LastIndexLetter == null)
       { 
          WWHFrame.LastIndexLetter = "a";
          MGCSetCookie("MGCLastIndexLetter",LastIndexLetter);
       }
   }

   HTML.fAppend("<table border=0 cellpadding=0 cellspacing=0>\n");
   if ( (WWHFrame.operatingsystem == "Unix") && (WWHFrame.browsername != "Firefox") )
   {
      HTML.fAppend("<tr><td>&nbsp;</td></tr>\n");
   }

   for (VarMaxIndex = IXLetters.length, VarIndex = 0 ; VarIndex < VarMaxIndex ; VarIndex++)
   {
      Letter = IXLetters.charAt(VarIndex);
      Letterl = IXLetters.charAt(VarIndex).toLowerCase();
      if ( (VarIndex == "9") ||  (VarIndex == "18") )
      {
         HTML.fAppend("</tr><tr>");
      }
      if ((Letter == "?") || (Letter == "&"))
      {
         Letter = '&';
         Letterl = 'symbols';
         title = " title\=\"Numbers\, Symbols\, and Miscellaneous index items \"";
      }
      if (Letterl != WWHFrame.LastIndexLetter)
      {
         HTML.fAppend("<td width=20 height=20 align=\"center\">");
         HTML.fAppend("<a href=\"javascript\:WWHFrame.DisplayIndexLetter(\'" + Letterl + "\'\)\;\"><span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-weight: bold; font-size: " + WWHFrame.BaseNavFontSize + "px;\">" + "<img src=\"../../common/images/" + Letterl + ".png\" border=\"0\" />" + "</span></a> ");
         HTML.fAppend("</div></td>");
      }
      else
      {
         HTML.fAppend("<td width=20 height=20 align=\"center\">");
         HTML.fAppend("<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-weight: bold; font-size: " + WWHFrame.BaseNavFontSize + "px;\"><font color=\"#ffffff\"> " + "<img src=\"../../common/images/" + Letterl + "_x.png\" border=\"0\" />" + " </font></span>");
         HTML.fAppend("</div></td>");
      }
   }
   HTML.fAppend("</tr></table></span>");
   return HTML.fGetBuffer();
}


function  WWHIndex_NavigationBodyHTML_org()
{
  var  HTML = new WWHStringBuffer_Object();
  var  VarCacheKey;


  // Define accessor functions to reduce file size
  //
  HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\">\n");
  HTML.fAppend(" <!--\n");
  HTML.fAppend("  function  fD(ParamSectionIndex)\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHIndex.fDisplaySection(ParamSectionIndex);\n");
  HTML.fAppend("  }\n");
  HTML.fAppend(" // -->\n");
  HTML.fAppend("</script>\n");

  // Display navigation shortcuts
  //
  if (this.fThresholdExceeded())
  {
    VarCacheKey = this.mSectionIndex;
  }
  else
  {
    VarCacheKey = -1;
  }

  // Calculate section navigation if not already cached
  //
  if (typeof(this.mSectionCache[VarCacheKey]) == "undefined")
  {
    this.mSectionCache[VarCacheKey] = this.fGetSectionNavigation();
  }

  // Display section selection
  //
  HTML.fAppend(this.mSectionCache[VarCacheKey]);
  HTML.fAppend("<p>&nbsp;</p>\n");

  return HTML.fGetBuffer();
}

function  WWHIndex_HeadHTML()
{
  var  HTML = new WWHStringBuffer_Object();
  var  MaxLevel;
  var  Level;


  // Generate style section
  //
  HTML.fAppend("<style type=\"text/css\">\n");
  HTML.fAppend(" <!--\n");
  HTML.fAppend("  a.Section\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    font-weight: bold;\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  a:active\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    background-color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mHighlightColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  a:hover\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: underline;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mEnabledColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  a\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mEnabledColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  a.AnchorOnly\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mDisabledColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mDisabledColor + ";\n");
  HTML.fAppend("    " + WWHFrame.WWHJavaScript.mSettings.mIndex.mFontStyle + ";\n");
  HTML.fAppend("  }\n");
  for (MaxLevel = this.mMaxLevel + 1, Level = 0 ; Level <= MaxLevel ; Level++)
  {
    HTML.fAppend("  p.l" + Level + "\n");
    HTML.fAppend("  {\n");
    HTML.fAppend("    margin-left: " + (WWHFrame.WWHJavaScript.mSettings.mIndex.mIndent * Level) + "pt;\n");
    HTML.fAppend("  }\n");
  }
  HTML.fAppend(" -->\n");
  HTML.fAppend("</style>\n");
  return HTML.fGetBuffer();
}

function  WWHIndex_StartHTMLSegments()
{
  var  HTML = new WWHStringBuffer_Object();
  HTML.fAppend("&nbsp;");
  return HTML.fGetBuffer();
}

function  WWHIndex_AdvanceHTMLSegment()
{
  var  MaxHTMLSegmentSize = WWHFrame.WWHJavaScript.mMaxHTMLSegmentSize;
  var  mbAccessible = WWHFrame.WWHHelp.mbAccessible;
  var  BaseEntryInfo = "";
  var  Entry;
  var  EntryAnchorName;
  var  VarAccessibilityTitle = "";
  var  MaxIndex;
  var  Index;
  var  VarParentEntry;
  var  EntryPrefix;
  var  EntrySuffix;
  var  EntryInfo;


  // Add index in top entry to entry info if IteratorScope != TopEntry
  //
  if (this.fThresholdExceeded())
  {
    BaseEntryInfo += this.mSectionIndex;
  }

  this.mHTMLSegment.fReset();
  while ((this.mHTMLSegment.fSize() < MaxHTMLSegmentSize) &&
         (this.mIterator.fAdvance()))
  {
    Entry = this.mIterator.mEntry;

    // Insert breaks between sections
    //
    if (Entry.mbGroup)
    {
      // Emit spacing, if necessary
      //
      if (this.mHTMLSegment.fSize() == 0)
      {
        // No spacing
        //
      }
      else
      {
        // Emit a space
        //
        this.mHTMLSegment.fAppend("<p>&nbsp;</p>\n");
      }
    }

    // Display the entry
    //

    // See if entry needs a named anchor target
    //
    if (typeof(Entry.mSeeAlsoTargetName) == "string")
    {
      EntryAnchorName = " name=\"sa" + Entry.mSeeAlsoTargetName + "\"";
    }
    else
    {
      EntryAnchorName = "";
    }

    // Determine accessibility title
    //
    if (mbAccessible)
    {
      VarAccessibilityTitle = "";
      for (MaxIndex = this.mIterator.mParentStack.length, Index = 0 ; Index < MaxIndex ; Index++)
      {
        VarParentEntry = this.mIterator.mParentStack[Index];

        if ((VarParentEntry == this.mTopEntry) ||
            (VarParentEntry.mbGroup))
        {
          // Nothing to do
          //
        }
        else
        {
          VarAccessibilityTitle += VarParentEntry.mText + WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
        }
      }

      VarAccessibilityTitle += Entry.mText;

      VarAccessibilityTitle = WWHStringUtilities_EscapeHTML(VarAccessibilityTitle);

      VarAccessibilityTitle = " title=\"" + VarAccessibilityTitle + "\"";
    }

    // Determine entry type
    //
    if (Entry.mbGroup)
    {
      EntryPrefix = "<b><a class=\"Section\" name=\"section" + Entry.mSectionIndex + "\">";
      EntrySuffix = "</a></b>";
    }
    else if (typeof(Entry.mSeeAlsoKey) == "string")
    {
      if (typeof(Entry.mSeeAlsoTargetName) == "string")
      {
        // Use position stack for link info
        //
        EntryInfo = BaseEntryInfo;
        for (MaxIndex = this.mIterator.mPositionStack.length, Index = 0 ; Index < MaxIndex ; Index++)
        {
          if (EntryInfo.length > 0)
          {
            EntryInfo += ":";
          }
          EntryInfo += this.mIterator.mPositionStack[Index];
        }

        EntryPrefix = "<i><a href=\"javascript:fA('" + EntryInfo + "');\"" + this.fGetPopupAction(EntryInfo) + VarAccessibilityTitle + ">";
        EntrySuffix = "</a></i>";
      }
      else
      {
        EntryPrefix = "<i>";
        EntrySuffix = "</i>";
      }
    }
    else if (Entry.mBookLinks != null)
    {
      // Use position stack for link info
      //
      EntryInfo = BaseEntryInfo;
      for (MaxIndex = this.mIterator.mPositionStack.length, Index = 0 ; Index < MaxIndex ; Index++)
      {
        if (EntryInfo.length > 0)
        {
          EntryInfo += ":";
        }
        EntryInfo += this.mIterator.mPositionStack[Index];
      }

      EntryPrefix = "<a" + EntryAnchorName + " href=\"javascript:fC('" + EntryInfo + "');\"" + this.fGetPopupAction(EntryInfo) + VarAccessibilityTitle + ">";
      EntrySuffix = "</a>";
    }
    else if (EntryAnchorName.length > 0)
    {
      EntryPrefix = "<a class=\"AnchorOnly\"" + EntryAnchorName + VarAccessibilityTitle + ">";
      EntrySuffix = "</a>";
    }
    else
    {
      EntryPrefix = "";
      EntrySuffix = "";
    }

    this.mHTMLSegment.fAppend("<p class=l" + (this.mIterator.mPositionStack.length) + "><nobr>" + EntryPrefix + Entry.mText + EntrySuffix + "</nobr></p>\n");
  }

  return (this.mHTMLSegment.fSize() > 0);
}

function  WWHIndex_GetHTMLSegment()
{
  return this.mHTMLSegment.fGetBuffer();
}

function  WWHIndex_EndHTMLSegments()
{
  return "";
}

function  WWHIndex_PanelNavigationLoaded()
{
  // Restore focus
  //
  WWHFrame.WWHHelp.fFocus("WWHPanelNavigationFrame", "in" + this.mSectionIndex);
}

function  WWHIndex_PanelViewLoaded()
{
}

function  WWHIndex_HoverTextTranslate(ParamEntryInfo)
{
  var  Entry;


  // Locate specified entry
  //
  Entry = this.fGetEntry(ParamEntryInfo);

  return Entry.mText;
}

function  WWHIndex_HoverTextFormat(ParamWidth,
                                   ParamTextID,
                                   ParamText)
{
  var  FormattedText   = "";
  var  ForegroundColor = WWHFrame.WWHJavaScript.mSettings.mHoverText.mForegroundColor;
  var  BackgroundColor = WWHFrame.WWHJavaScript.mSettings.mHoverText.mBackgroundColor;
  var  BorderColor     = WWHFrame.WWHJavaScript.mSettings.mHoverText.mBorderColor;
  var  ImageDir        = WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/common/images";
  var  ReqSpacer1w2h   = "<img src=\"" + ImageDir + "/spc1w2h.gif\" width=1 height=2>";
  var  ReqSpacer2w1h   = "<img src=\"" + ImageDir + "/spc2w1h.gif\" width=2 height=1>";
  var  ReqSpacer1w7h   = "<img src=\"" + ImageDir + "/spc1w7h.gif\" width=1 height=7>";
  var  ReqSpacer5w1h   = "<img src=\"" + ImageDir + "/spc5w1h.gif\" width=5 height=1>";
  var  Spacer1w2h      = ReqSpacer1w2h;
  var  Spacer2w1h      = ReqSpacer2w1h;
  var  Spacer1w7h      = ReqSpacer1w7h;
  var  Spacer5w1h      = ReqSpacer5w1h;


  // Netscape 6.x (Mozilla) renders table cells with graphics
  // incorrectly inside of <div> tags that are rewritten on the fly
  //
  if (WWHFrame.WWHBrowser.mBrowser == 4)  // Shorthand for Netscape 6.x (Mozilla)
  {
    Spacer1w2h = "";
    Spacer2w1h = "";
    Spacer1w7h = "";
    Spacer5w1h = "";
  }

  FormattedText += "<table width=\"" + ParamWidth + "\" border=0 cellspacing=0 cellpadding=0 bgcolor=\"" + BackgroundColor + "\">";
  FormattedText += " <tr>";
  FormattedText += "  <td height=2 colspan=5 bgcolor=\"" + BorderColor + "\">" + Spacer1w2h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += "  <td height=7 colspan=3>" + Spacer1w7h + "</td>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td bgcolor=\"" + BorderColor + "\">" + ReqSpacer2w1h + "</td>";
  FormattedText += "  <td>" + ReqSpacer5w1h + "</td>";
  FormattedText += "  <td width=\"100%\" id=\"" + ParamTextID + "\" style=\"color: " + ForegroundColor + " ; " + WWHFrame.WWHJavaScript.mSettings.mHoverText.mFontStyle + "\">" + ParamText + "</td>";
  FormattedText += "  <td>" + ReqSpacer5w1h + "</td>";
  FormattedText += "  <td bgcolor=\"" + BorderColor + "\">" + ReqSpacer2w1h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += "  <td height=7 colspan=3>" + Spacer1w7h + "</td>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td height=2 colspan=5 bgcolor=\"" + BorderColor + "\">" + Spacer1w2h + "</td>";
  FormattedText += " </tr>";
  FormattedText += "</table>";

  return FormattedText;
}

function  WWHIndex_GetPopupAction(ParamEntryInfo)
{
  var  PopupAction = "";


  if (WWHFrame.WWHJavaScript.mSettings.mHoverText.mbEnabled)
  {
    PopupAction += " onMouseOver=\"fS('" + ParamEntryInfo + "', " + this.mEventString + ");\"";
    PopupAction += " onMouseOut=\"fH();\"";
  }

  return PopupAction;
}

function  WWHIndex_ThresholdExceeded()
{
  if (this.mbThresholdExceeded == null)
  {
    if ((WWHFrame.WWHHelp.mbAccessible) ||
        ((this.mOptions.mThreshold > 0) &&
         (this.mEntryCount > this.mOptions.mThreshold)))
    {
      this.mbThresholdExceeded = true;
    }
    else
    {
      this.mbThresholdExceeded = false;
    }
  }

  return this.mbThresholdExceeded;
}

function  WWHIndex_GetSectionNavigation()
{
  var  SectionNavHTML = "";
  var  SectionArray;
  var  MaxIndex;
  var  Index;


  SectionNavHTML += "<p class=\"navigation\">";

  // Calculate section selection
  //
  SectionArray = this.mTopEntry.mChildrenSortArray;
  for (MaxIndex = SectionArray.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
    // Add spacers if necessary
    //
    if (Index > 0)
    {
      SectionNavHTML += this.mOptions.mSeperator;
    }

    // Display section with or without link as necessary
    //
    if ((this.fThresholdExceeded()) &&
        (Index == this.mSectionIndex))  // Currently being displayed
    {
      SectionNavHTML += "<a class=\"selected\" name=\"in" + Index + "\" href=\"javascript:void(0);\">" + SectionArray[Index].mText + "</a>";
    }
    else if ((SectionArray[Index].mChildren == null) &&         // Always display group
             (SectionArray[Index].mChildrenSortArray == null))  // SortArray null before sort, hash null after
    {
      SectionNavHTML += SectionArray[Index].mText;
    }
    else
    {
      SectionNavHTML += "<a class=\"enabled\" name=\"in" + Index + "\" href=\"javascript:fD(" + Index + ");\">" + SectionArray[Index].mText + "</a>";
    }
  }

  SectionNavHTML += "</p>";

  return SectionNavHTML;
}

function  WWHIndex_DisplaySection(ParamSectionIndex)
{
  // Set section
  //
  this.mSectionIndex = ParamSectionIndex;

  if (this.fThresholdExceeded())
  {
    // Reload panel
    //
    WWHFrame.WWHJavaScript.mPanels.fClearScrollPosition();
    WWHFrame.WWHJavaScript.mPanels.fReloadPanel();
  }
  else
  {
    // Focus current section
    //
    WWHFrame.WWHHelp.fFocus("WWHPanelNavigationFrame", "in" + this.mSectionIndex);

    // Whole index already visible, just jump to the specified entry
    //
    this.mPanelAnchor = "section" + this.mSectionIndex;

    // Workaround for IE problems
    //
    if (WWHFrame.WWHBrowser.mbSupportsFocus)
    {
      if (WWHFrame.WWHBrowser.mBrowser == 2)  // Shorthand for IE
      {
        WWHFrame.WWHBrowser.mbSupportsFocus = false;

        WWHFrame.WWHJavaScript.mPanels.fJumpToAnchor();

        WWHFrame.WWHBrowser.mbSupportsFocus = true;
      }
    }

    WWHFrame.WWHJavaScript.mPanels.fJumpToAnchor();
  }
}

function  WWHIndex_SelectionListHeadHTML()
{
  var  HTML = new WWHStringBuffer_Object();
  var  Level;


  HTML.fAppend("<style type=\"text/css\">\n");
  HTML.fAppend(" <!--\n");
  HTML.fAppend("  a\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mEnabledColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mDisabledColor + ";\n");
  HTML.fAppend("    " + WWHFrame.WWHJavaScript.mSettings.mIndex.mFontStyle + ";\n");
  HTML.fAppend("  }\n");
  for (Level = 1 ; Level < 3 ; Level++)
  {
    HTML.fAppend("  p.l" + Level + "\n");
    HTML.fAppend("  {\n");
    HTML.fAppend("    margin-left: " + (WWHFrame.WWHJavaScript.mSettings.mIndex.mIndent * Level) + "pt;\n");
    HTML.fAppend("  }\n");
  }
  HTML.fAppend("  h2\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    " + WWHFrame.WWHJavaScript.mSettings.mIndex.mFontStyle + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend(" -->\n");
  HTML.fAppend("</style>\n");

  return HTML.fGetBuffer();
}

function  WWHIndex_SelectionListBodyHTML()
{
  var  HTML = new WWHStringBuffer_Object();
  var  BookList = WWHFrame.WWHHelp.mBooks.mBookList;
  var  EntryClass;
  var  MaxBookIndex;
  var  BookIndex;
  var  BookListEntry;
  var  LinkArray;
  var  MaxLinkIndex;
  var  LinkIndex;
  var  Parts;
  var  PrevLinkFileIndex;
  var  LinkFileIndex;
  var  LinkAnchor;
  var  VarAccessibilityTitle;
  var  NumberedLinkCounter;
  var  DocumentURL;


  if (this.mClickedEntry != null)
  {
    // Display multiple entry message
    //
    HTML.fAppend("<h2>");
    HTML.fAppend(WWHFrame.WWHJavaScript.mMessages.mIndexSelectMessage1 + " ");
    HTML.fAppend(WWHFrame.WWHJavaScript.mMessages.mIndexSelectMessage2);
    HTML.fAppend("</h2>\n");

    // Display text of entry clicked
    //
    HTML.fAppend("<p><b>" + this.mClickedEntry.mText + "</b></p>\n");

    // Determine level at which to display entries
    //
    if (BookList.length == 1)
    {
      EntryClass = "l1";
    }
    else
    {
      EntryClass = "l2";
    }

    // Display each book's link for this entry
    //
    for (MaxBookIndex = BookList.length, BookIndex = 0 ; BookIndex < MaxBookIndex ; BookIndex++)
    {
      if (typeof(this.mClickedEntry.mBookLinks[BookIndex]) != "undefined")
      {
        BookListEntry = BookList[BookIndex];

        // Write the book's title, if necessary
        //
        if (BookList.length > 1)
        {
          HTML.fAppend("<p>&nbsp;</p>\n");
          HTML.fAppend("<p class=\"l1\"><nobr><b>" + BookListEntry.mTitle + "</b>");
        }

        // Sort link array to group files with anchors
        //
        // Use for loop to copy entries to workaround bug/problem in IE 5.0 on Windows
        //
        LinkArray = new Array();
        for (MaxLinkIndex = this.mClickedEntry.mBookLinks[BookIndex].length, LinkIndex = 0 ; LinkIndex < MaxLinkIndex ; LinkIndex++)
        {
          LinkArray[LinkIndex] = this.mClickedEntry.mBookLinks[BookIndex][LinkIndex];
        }
        LinkArray = LinkArray.sort();

        // Now display file links
        //
        PrevLinkFileIndex = null;
        for (MaxLinkIndex = LinkArray.length, LinkIndex = 0 ; LinkIndex < MaxLinkIndex ; LinkIndex++)
        {
          // Determine link file index and anchor
          //
          Parts = LinkArray[LinkIndex].split("#");
          LinkFileIndex = parseInt(Parts[0]);
          LinkAnchor = null;
          if (Parts.length > 1)
          {
            if (Parts[1].length > 0)
            {
              LinkAnchor = Parts[1];
            }
          }

          // Determine if all links for a single document have been processed
          //
          if ((PrevLinkFileIndex == null) ||
              (LinkFileIndex != PrevLinkFileIndex))
          {
            NumberedLinkCounter = 1;

            // Determine title for accessibility
            //
            if (WWHFrame.WWHHelp.mbAccessible)
            {
              VarAccessibilityTitle = WWHStringUtilities_FormatMessage(WWHFrame.WWHJavaScript.mMessages.mAccessibilityIndexEntry,
                                                                       BookListEntry.mFiles.fFileIndexToTitle(LinkFileIndex),
                                                                       BookListEntry.mTitle);
              VarAccessibilityTitle = WWHStringUtilities_EscapeHTML(VarAccessibilityTitle);
              VarAccessibilityTitle = " title=\"" + VarAccessibilityTitle + "\"";
            }

            HTML.fAppend("</nobr></p>\n");

            // Build up absolute link URL
            //
            DocumentURL = WWHFrame.WWHHelp.fGetBookIndexFileIndexURL(BookIndex, LinkFileIndex, LinkAnchor);
            DocumentURL = WWHFrame.WWHBrowser.fRestoreEscapedSpaces(DocumentURL);
            DocumentURL = WWHStringUtilities_EscapeURLForJavaScriptAnchor(DocumentURL);

            HTML.fAppend("<p class=\"" + EntryClass + "\"><nobr>");
            HTML.fAppend("<a name=\"indexselect\" href=\"javascript:WWHFrame.WWHIndex.fDisplayLink('" + DocumentURL + "');\"" + VarAccessibilityTitle + ">");
            HTML.fAppend(BookListEntry.mFiles.fFileIndexToTitle(LinkFileIndex) + "</a>");
          }
          else
          {
            NumberedLinkCounter += 1;

            // Determine title for accessibility
            //
            if (WWHFrame.WWHHelp.mbAccessible)
            {
              VarAccessibilityTitle = WWHStringUtilities_FormatMessage(WWHFrame.WWHJavaScript.mMessages.mAccessibilityIndexSecondEntry,
                                                                       BookListEntry.mFiles.fFileIndexToTitle(LinkFileIndex),
                                                                       BookListEntry.mTitle,
                                                                       NumberedLinkCounter);
              VarAccessibilityTitle = WWHStringUtilities_EscapeHTML(VarAccessibilityTitle);
              VarAccessibilityTitle = " title=\"" + VarAccessibilityTitle + "\"";
            }

            // Build up absolute link URL
            //
            DocumentURL = WWHFrame.WWHHelp.fGetBookIndexFileIndexURL(BookIndex, LinkFileIndex, LinkAnchor);
            DocumentURL = WWHFrame.WWHBrowser.fRestoreEscapedSpaces(DocumentURL);
            DocumentURL = WWHStringUtilities_EscapeURLForJavaScriptAnchor(DocumentURL);

            HTML.fAppend(",&nbsp;");
            HTML.fAppend("<a href=\"javascript:WWHFrame.WWHIndex.fDisplayLink('" + DocumentURL + "');\"" + VarAccessibilityTitle + ">");
            HTML.fAppend(NumberedLinkCounter + "</a>");
          }

          PrevLinkFileIndex = LinkFileIndex;
        }

        HTML.fAppend("</nobr></p>\n");
      }
    }
  }

  return HTML.fGetBuffer();
}

function  WWHIndex_SelectionListLoaded()
{
  // Move focus to document selection list
  //
  WWHFrame.WWHHelp.fFocus("WWHDocumentFrame", "indexselect");
}

function  WWHIndex_DisplayLink(ParamURL)
{
  WWHFrame.WWHHelp.fSetDocumentHREF(ParamURL, false);
}

function  WWHIndex_GetEntry(ParamEntryInfo)
{
  var  Entry = null;
  var  EntryInfoParts;
  var  MaxIndex;
  var  Index;


  // Locate specified entry
  //
  Entry = this.mTopEntry;
  EntryInfoParts = ParamEntryInfo.split(":");
  for (MaxIndex = EntryInfoParts.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
    Entry = Entry.mChildrenSortArray[EntryInfoParts[Index]];
  }

  return Entry;
}

function  WWHIndex_ClickedEntry(ParamEntryInfo)
{
  var  Entry;
  var  BookCount;
  var  BookIndex;
  var  BookListEntry;
  var  Parts;
  var  LinkFileIndex;
  var  LinkAnchor;
  var  DocumentURL;


  // Locate specified entry
  //
  Entry = this.fGetEntry(ParamEntryInfo);

  // Display target document or selection list
  //
  BookCount = 0;
  for (BookIndex in Entry.mBookLinks)
  {
    BookCount++;
  }

  // See if this is a single entry
  //
  if ((BookCount == 1) &&
      (Entry.mBookLinks[BookIndex].length == 1))
  {
    BookListEntry = WWHFrame.WWHHelp.mBooks.mBookList[BookIndex];

    // Determine link file index and anchor
    //
    Parts = Entry.mBookLinks[BookIndex][0].split("#");
    LinkFileIndex = parseInt(Parts[0]);
    LinkAnchor = null;
    if (Parts.length > 1)
    {
      if (Parts[1].length > 0)
      {
        LinkAnchor = Parts[1];
      }
    }

    // Set Document
    //
    DocumentURL = WWHFrame.WWHHelp.fGetBookIndexFileIndexURL(BookIndex, LinkFileIndex, LinkAnchor);
  }
  else
  {
    // Display selection list
    //
    this.mClickedEntry = Entry;
    DocumentURL = WWHFrame.WWHHelp.mBaseURL + "wwhelp/wwhimpl/js/html/indexsel.htm";
  }

  this.fDisplayLink(DocumentURL);
}

function  WWHIndex_ClickedSeeAlsoEntry(ParamEntryInfo)
{
  var  Entry;
  var  TargetSectionIndex;
  var  MaxIndex;
  var  Index;


  // Locate specified entry
  //
  Entry = this.fGetEntry(ParamEntryInfo);

  // Confirm entry has target information
  //
  if ((typeof(Entry.mSeeAlsoTargetName) == "string") &&
      (typeof(Entry.mSeeAlsoTargetGroupID) == "number"))
  {
    // Determine if we need to jump to another page
    //
    TargetSectionIndex = -1;
    for (MaxIndex = this.mTopEntry.mChildrenSortArray.length, Index = 0 ; Index < MaxIndex ; Index++)
    {
      if (this.mTopEntry.mChildrenSortArray[Index].mGroupID == Entry.mSeeAlsoTargetGroupID)
      {
        TargetSectionIndex = Index;

        // Exit for loop
        //
        Index = MaxIndex;
      }
    }

    // Confirm the target entry was located
    //
    if (TargetSectionIndex != -1)
    {
      // Set target entry
      //
      this.mPanelAnchor = "sa" + Entry.mSeeAlsoTargetName;

      // Change navigation bar?
      //
      if ((this.fThresholdExceeded()) &&
          (TargetSectionIndex != this.mSectionIndex))
      {
        // Need to switch to proper section
        //
        this.fDisplaySection(TargetSectionIndex);
      }
      else
      {
        // Focus current section
        //
        WWHFrame.WWHHelp.fFocus("WWHPanelNavigationFrame", "in" + this.mSectionIndex);

        // We're on the right page, so just jump to the correct entry
        //
        WWHFrame.WWHJavaScript.mPanels.fJumpToAnchor();
      }
    }
  }
}

function  WWHIndexIterator_Object()
{
  this.mIteratorScope      = null;
  this.mEntry              = null;
  this.mParentStack        = new Array();
  this.mPositionStack      = new Array();

  this.fReset   = WWHIndexIterator_Reset;
  this.fAdvance = WWHIndexIterator_Advance;
}

function  WWHIndexIterator_Reset(ParamIndex)
{
  if (ParamIndex == -1)  // Iterate buckets as well!
  {
    this.mIteratorScope = WWHFrame.WWHIndex.mTopEntry;
  }
  else
  {
    this.mIteratorScope = WWHFrame.WWHIndex.mTopEntry.mChildrenSortArray[ParamIndex];
  }
  this.mEntry                = this.mIteratorScope;
  this.mParentStack.length   = 0;
  this.mPositionStack.length = 0;
}

function  WWHIndexIterator_Advance()
{
  var  ParentEntry;
  var  StackTop;


  // Advance to the next visible entry
  //
  if (this.mEntry != null)
  {
    // Check for children
    //
    if (this.mEntry.mChildren != null)
    {
      // Determine sort order if necessary
      //
      if (this.mEntry.mChildrenSortArray == null)
      {
        WWHIndexEntry_SortChildren(this.mEntry);
      }
    }

    // Process children
    //
    if (this.mEntry.mChildrenSortArray != null)
    {
      this.mParentStack[this.mParentStack.length] = this.mEntry;
      this.mPositionStack[this.mPositionStack.length] = 0;
      this.mEntry = this.mEntry.mChildrenSortArray[0];
    }
    // If we've reached the iterator scope, we're done
    //
    else if (this.mEntry == this.mIteratorScope)
    {
      this.mEntry = null;
    }
    else
    {
      ParentEntry = this.mParentStack[this.mParentStack.length - 1];
      this.mEntry = null;

      // Find next child of parent entry
      //
      while (ParentEntry != null)
      {
        // Increment position
        //
        StackTop = this.mPositionStack.length - 1;
        this.mPositionStack[StackTop]++;

        // Confirm this is a valid entry
        //
        if (this.mPositionStack[StackTop] < ParentEntry.mChildrenSortArray.length)
        {
          // Return the parent's next child
          //
          this.mEntry = ParentEntry.mChildrenSortArray[this.mPositionStack[StackTop]];

          // Signal break from loop
          //
          ParentEntry = null;
        }
        else
        {
          // Last child of parent, try up a level
          //
          if (ParentEntry == this.mIteratorScope)
          {
            ParentEntry = null;
          }
          else
          {
            this.mParentStack.length--;
            this.mPositionStack.length--;

            ParentEntry = this.mParentStack[this.mParentStack.length - 1];
          }
        }
      }
    }
  }

  return (this.mEntry != null);
}

function  WWHIndexEntry_Object(bParamGroupHeading,
                               ParamBookIndex,
                               ParamText,
                               ParamLinks,
                               ParamSeeAlsoKey,
                               ParamSeeAlsoGroupKey)
{
  if (bParamGroupHeading)
  {
    this.mbGroup  = true;
    this.mGroupID = WWHFrame.WWHIndex.mEntryCount;
  }
  else
  {
    this.mbGroup = false;
  }

  this.mText              = ParamText;
  this.mBookLinks         = null;
  this.mChildren          = null;
  this.mChildrenSortArray = null;

  if (typeof(ParamSeeAlsoKey) == "string")
  {
    this.mSeeAlsoKey = ParamSeeAlsoKey;
  }
  if (typeof(ParamSeeAlsoGroupKey) == "string")
  {
    this.mSeeAlsoGroupKey = ParamSeeAlsoGroupKey;
  }

  this.fAddEntry  = WWHIndexEntry_AddEntry;
  this.fA         = WWHIndexEntry_AddEntry;

  // Bump entry count if not the top level node
  //
  if (ParamBookIndex != -1)
  {
    WWHFrame.WWHIndex.mEntryCount++;
  }

  // Add links
  //
  if ((typeof(ParamLinks) != "undefined") &&
      (ParamLinks != null))
  {
    this.mBookLinks = new WWHIndexEntryBookHash_Object();
    this.mBookLinks[ParamBookIndex] = ParamLinks;
  }
}

function  WWHIndexEntry_GetKey(ParamGroupTag,
                               ParamText,
                               ParamSort)
{
  var  VarKey = null;


  if ((typeof(ParamText) != "undefined") &&
      (ParamText != null) &&
      (ParamText.length > 0))
  {
    if ((typeof(ParamGroupTag) != "undefined") &&
        (ParamGroupTag != null) &&
        (ParamGroupTag.length > 0))
    {
      if (VarKey == null)
      {
        VarKey = "";
      }

      VarKey += ParamGroupTag;
    }

    if ((typeof(ParamSort) != "undefined") &&
        (ParamSort != null) &&
        (ParamSort.length > 0))
    {
      if (VarKey == null)
      {
        VarKey = "";
      }

      VarKey += ":" + ParamSort;
    }

    if (VarKey == null)
    {
      VarKey = "";
    }

    VarKey += ":" + ParamText;
  }

  return VarKey;
}

function  WWHIndexEntry_AddEntry(ParamText,
                                 ParamLinks,
                                 ParamSort,
                                 ParamGroupTag,
                                 ParamSeeAlso,
                                 ParamSeeAlsoSort,
                                 ParamSeeAlsoGroup,
                                 ParamSeeAlsoGroupSort,
                                 ParamSeeAlsoGroupTag)
{
  var  bVarGroupHeading;
  var  Links;
  var  VarKey;
  var  VarSeeAlsoKey;
  var  VarSeeAlsoGroupKey;
  var  BookIndex;
  var  ChildEntry;
  var  BookLinks;
  var  MaxIndex;
  var  Index;


  // See if this is a group heading
  //
  if ((typeof(ParamGroupTag) != "undefined") &&
      (ParamGroupTag != null) &&
      (ParamGroupTag.length > 0))
  {
    bVarGroupHeading = true;
  }

  // Set links if entries exist
  //
  if ((typeof(ParamLinks) != "undefined") &&
      (ParamLinks != null) &&
      (ParamLinks.length > 0))
  {
    Links = ParamLinks;
  }
  else
  {
    Links = null;
  }

  // See if this object has any children
  //
  if (this.mChildren == null)
  {
    this.mChildren = new WWHIndexEntryHash_Object();
  }

  // Define keys
  //
  VarKey             = WWHIndexEntry_GetKey(ParamGroupTag, ParamText, ParamSort);
  VarSeeAlsoKey      = WWHIndexEntry_GetKey(null, ParamSeeAlso, ParamSeeAlsoSort);
  VarSeeAlsoGroupKey = WWHIndexEntry_GetKey(ParamSeeAlsoGroupTag, ParamSeeAlsoGroup, ParamSeeAlsoGroupSort);

  // Access entry, creating it if it doesn't exist
  //
  BookIndex = WWHFrame.WWHIndex.mInitIndex;
  ChildEntry = this.mChildren[VarKey + "~"];
  if (typeof(ChildEntry) == "undefined")
  {
    ChildEntry = new WWHIndexEntry_Object(bVarGroupHeading, BookIndex, ParamText,
                                          Links, VarSeeAlsoKey, VarSeeAlsoGroupKey);
    this.mChildren[VarKey + "~"] = ChildEntry;

    // Add entry to see also collection if it is a see also entry
    //
    if (typeof(VarSeeAlsoKey) == "string")
    {
      WWHFrame.WWHIndex.fAddSeeAlsoEntry(ChildEntry);
    }
  }
  else  // Child entry exists, update with new information
  {
    // Add book links
    //
    if (Links != null)
    {
      if (ChildEntry.mBookLinks == null)
      {
        ChildEntry.mBookLinks = new WWHIndexEntryBookHash_Object();
      }

      if (typeof(ChildEntry.mBookLinks[BookIndex]) == "undefined")
      {
        ChildEntry.mBookLinks[BookIndex] = Links;
      }
      else
      {
        // Append new links
        //
        BookLinks = ChildEntry.mBookLinks[BookIndex];
        for (MaxIndex = Links.length, Index = 0 ; Index < MaxIndex ; Index++)
        {
          BookLinks[BookLinks.length] = Links[Index];
        }
      }
    }
  }

  return ChildEntry;
}

function  WWHIndexEntry_SortChildren(ParamEntry)
{
  var  UnsortedArray;
  var  KeyHash = new Object();
  var  SortedArray;
  var  VarKey;
  var  VarKeyUpperCase;
  var  MaxIndex;
  var  Index;


  // Accumulate hash keys
  //
  UnsortedArray = new Array();
  for (VarKey in ParamEntry.mChildren)
  {
    VarKeyUpperCase = VarKey.toUpperCase();

    UnsortedArray[UnsortedArray.length] = VarKeyUpperCase;
    if (VarKeyUpperCase != VarKey)
    {
      KeyHash[VarKeyUpperCase] = VarKey;
    }
  }

  // Insure array exists
  //
  if (UnsortedArray.length > 0)
  {
    // Sort array
    //
    SortedArray = UnsortedArray.sort();

    // Replace sort keys with entries
    //
    for (MaxIndex = SortedArray.length, Index = 0 ; Index < MaxIndex ; Index++)
    {
      VarKey = SortedArray[Index];
      if ((typeof(KeyHash[VarKey]) != "undefined") &&
          (KeyHash[VarKey] != null))
      {
        VarKey = KeyHash[VarKey];
      }
      SortedArray[Index] = ParamEntry.mChildren[VarKey];
    }
  }
  else
  {
    // No children, possible error occurred?
    //
    SortedArray = new Array();
  }

  // Set children sort array
  // Clear hash table as it is no longer needed
  //
  ParamEntry.mChildrenSortArray = SortedArray;
  ParamEntry.mChildren = null;
}

function  WWHIndexEntryHash_Object()
{
}

function  WWHIndexEntryBookHash_Object()
{
}

function  WWHSectionCache_Object()
{
}

function  WWHIndexOptions_Object()
{
  this.mThreshold     = 0;

  this.fSetThreshold = WWHIndexOptions_SetThreshold;
  this.fSetSeperator = WWHIndexOptions_SetSeperator;
}

function  WWHIndexOptions_SetThreshold(ParamThreshold)
{
  this.mThreshold = ParamThreshold;
}

function  WWHIndexOptions_SetSeperator(ParamSeperator)
{
  this.mSeperator = ParamSeperator;
}

function myvoid() {}

function SetIndexScope(source)
{
 // alert("Changing scope to " + source);
   WWHFrame.MySearchPrefs = source;
//   WWHFrame.LoadedFirstSearchEntry = false;
   if (source == "DOC")
   {
      Handle = WWHFrame.MGCContent.MGCDocContent.DocHandle;
      Title = WWHFrame.MGCContent.MGCDocContent.DocTitle;
      WWHFrame.mSource = "doc";
      WWHFrame.mHandle = Handle;
      WWHFrame.DocHandle = Handle;
   }
   if (source == "MYDOCS") { MGCReloadMyDocs(); }  
   if (source == "SNet")
   {
      WWHFrame.SearchSupportNet(WWHFrame.GetIHUBHandle()[0],WWHFrame.GlobalSearchWords);
   }
   else
   {
      DisplayIndexLetter(WWHFrame.LastIndexLetter);
   }
}

function ShowIndexOptions()
{
 iState = 1;
 szDivID = "pMenu";
 WWHFrame.MGCShowSearchFilter = true;
 if(WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers)	   //NN4+
 {
    WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers[szDivID].visibility = iState ? "show" : "hide";
    WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers[szDivID].display = iState ? "block" : "none";
 }
 if (WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.getElementById)	  //gecko(NN6) + IE 5+
 {
     var obj = WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.getElementById(szDivID);
     obj.style.visibility = iState ? "visible" : "hidden";
     obj.style.display = iState ? "block" : "none";
 }
 else if(WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all)	// IE 4
 {
     WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
     WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all[szDivID].style.display = iState ? "block" : "none";
 }
}

function HideIndexOptions()
{
   iState = 0;
   szDivID = "pMenu";
   WWHFrame.MGCShowSearchFilter = false;
//   if(WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers)	   //NN4+
//   {
//      WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers[szDivID].visibility = iState ? "show" : "hide";
//      WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers[szDivID].display = iState ? "block" : "none";
//   }
   if (WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.getElementById)	  //gecko(NN6) + IE 5+
   {
       var obj = WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.getElementById(szDivID);
       obj.style.visibility = iState ? "visible" : "hidden";
       obj.style.display = iState ? "block" : "none";
   }
   else if(WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all)	// IE 4
   {
       WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
       WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all[szDivID].style.display = iState ? "block" : "none";
   }
if (WWHFrame.operatingsystem == "Unix")
   {   UpdateIndexScope(); }
}

function InsertIndexOptions()
{
   SOHTML = "";
 
   SOHTML += "<div class=\"mPercent\" id=\"pMenu\" style=\"left:30px; bottom:15px;\">";
   SOHTML += "<table border=0 cellspacing=0 cellpadding=0>";
   SOHTML += "<tr bgcolor=\"#416E98\"><td width=13>&nbsp;</td><td colspan=\"2\" align=\"left\" height=12><font color=\"#FFFFFF\"><b>Change Index Options</b></font></td><td align=\"right\"><a href=\"javascript:WWHFrame.HideIndexOptions();\" title=\"Close\"><font color=\"#FFFFFF\"><b></b></font>&nbsp;&nbsp;&nbsp;<img src=\"../../common/images/closesm.png\" border=\"0\"/></a></td></tr>"; 
   SOHTML += "<tr><td colspan=\"3\" height=2> </td></tr>";
   if ( (WWHFrame.LibraryAvailable) && (WWHFrame.MySearchPrefs != "DOC") )
   {
      if (WWHFrame.ShowSearchBooks != "NO")
      {
         SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleIXhBooks('1');\">List Results By BOOK</a></td></tr>";
         SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleIXhBooks('0');\">List Results By TOPIC</a></td></tr>";
      }
      else
      {
         SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleIXhBooks('1');\">List Results By BOOK</a></td></tr>";
         SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleIXhBooks('0');\">List Results By TOPIC</a></td></tr>";
      }
      SOHTML += "<tr><td colspan=\"3\" height=12><hr width=95%></td></tr>";
   }
   if (WWHFrame.ISVerbose)
   {
      SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleISVerbose();\">Show Context Detail</a></td></tr>";
   }
   else
   {
      SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleISVerbose();\">Show Context Detail</a></td></tr>";
   }
   SOHTML += "</table>";
   SOHTML += "</div>";
   return SOHTML;
}

function MGCToggleIXhBooks(HS)
{
   if (HS == '0')
   {  WWHFrame.ShowSearchBooks = "NO"; }
   else
   {  WWHFrame.ShowSearchBooks = "YES"; }

   if (MGCCookiesEnabled())
   {
      MGCSetCookie("MGCShowSearchBooks",WWHFrame.ShowSearchBooks);
   }
   WWHFrame.MGCShowSearchFilter = false;
   HideIndexOptions();
   //WWHFrame.MGCNavigate.MGCIndex.location.reload(true);
   //WWHFrame.WWHJavaScript.mPanels.fClearScrollPosition();
   UpdateIndexScope();
} 


function UpdateIndexScope()
{
   szDivID = "MGCSScopeDiv";
//   if(WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers)	   //NN4+
//   {
//      WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.layers[szDivID].innerHTML=InsertIXDocTitleScope();
//   }
   if (WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav)
   {
      if ( (WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav) &&  (WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.getElementById) )	  //gecko(NN6) + IE 5+
      {
         WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.getElementById(szDivID).innerHTML=InsertIXDocTitleScope();
      }
      else if(WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all)	// IE 4
      {
         WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.document.all[szDivID].innerHTML=InsertIXDocTitleScope();
      }
      WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.location.reload(true);
      WWHFrame.MGCNavigate.MGCIndex.MGCIndexContent.location.reload(true);
   }
}

function DisplayIndexLetter(letter)
{
   WWHFrame.LastIXLetter = letter;
   WWHFrame.LastIndexLetter = letter;
   if (MGCCookiesEnabled())
      { MGCSetCookie("MGCLastIndexLetter",letter); }

   WWHFrame.MGCNavigate.MGCIndex.MGCIndexContent.location = "MGCIndexBlank.htm";
   WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.location.reload(true);
//   WWHFrame.MGCNavigate.MGCIndex.MGCIndexContent.location = "MGCIndex.htm";

}

function MGCToggleISVerbose()
{
   if (WWHFrame.ISVerbose)
      { WWHFrame.ISVerbose = false; }
   else
      { WWHFrame.ISVerbose = true; }
   HideIndexOptions();
   WWHFrame.MGCNavigate.MGCIndex.MGCIndexNav.location.reload(true);
   WWHFrame.MGCNavigate.MGCIndex.MGCIndexContent.location = "MGCIndexBlank.htm";
}

function InsertIXDocTitleScope()
{
   SOHTML = "";
   var ptag = "<p class=\"MGCScopeSel\">";

  // Generate style section
  //
  SOHTML += "<style type=\"text/css\">\n";
  SOHTML += " <!--\n";
  SOHTML += "    p.MGCScopeSel {\n";
  SOHTML += "    margin-top: 0pt;\n";
  SOHTML += "    margin-left: 0.28in;\n";
  SOHTML += "    margin-bottom: 0pt;\n";
  SOHTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
  SOHTML += "    font-size: " + WWHFrame.BaseNavFontSize + "px;\n";
  SOHTML += "    text-indent: -0.22in;\n";
  SOHTML += "    	color: #000000;\n";
  SOHTML += "    }\n";
  SOHTML += " -->\n";
  SOHTML += "</style>\n";
   WWHFrame.MGCReloadMyDocs();
   WWHFrame.ThisDocTitle = WWHFrame.MGCContent.MGCDocContent.DocTitle;
   SOHTML += "<br /><p class=\"MGCFormTitleB\"><b>Index Scope:</b></p>";
   if (WWHFrame.MySearchPrefs == "DOC" )
   {
       SOHTML += ptag + "<input align=\"top\" type=\"radio\" id=\"inputID1\" CHECKED name=\"group2\" value=\"DOC\"><label for=\"inputID1\">" + WWHFrame.ThisDocTitle + "</label></p>\n";
   }
   else
   {
       SOHTML += ptag + "<input align=\"top\" type=\"radio\" id=\"inputID1\" name=\"group2\" value=\"DOC\"  onclick=\"javascript:WWHFrame.SetIndexScope('DOC');return false;\"><label for=\"inputID1\">" + WWHFrame.ThisDocTitle + "</label></p>\n";
   }
   if (WWHFrame.LibraryAvailable)
   {
      if (WWHFrame.MySearchPrefs == "LIB" )
      {
          SOHTML += ptag + "<input type=\"radio\" id=\"inputID2\" CHECKED name=\"group2\" value=\"LIB\"><label for=\"inputID2\">All Installed Docs</label></p>\n";
      }
      else
      {
          SOHTML += ptag + "<input type=\"radio\" id=\"inputID2\" name=\"group2\" value=\"LIB\"  onclick=\"javascript:WWHFrame.SetIndexScope('LIB');return false;\"><label for=\"inputID2\">All Installed Docs</label></p>\n";
      }
      if ( (WWHFrame.mInfoHubName != "Mentor Graphics") && (WWHFrame.mInfoHubName != "mgc_ih") )
      {
         if (WWHFrame.MySearchPrefs == "IHUB" )
         {
             SOHTML += ptag + "<input type=\"radio\" id=\"inputID3\" CHECKED name=\"group2\" value=\"IHUB\"><label for=\"inputID3\">" + WWHFrame.mInfoHubName + "</label></p>\n";
         }
         else
         {
             SOHTML += ptag + "<input type=\"radio\" id=\"inputID3\" name=\"group2\" value=\"IHUB\"  onclick=\"javascript:WWHFrame.SetIndexScope('IHUB');return false;\"><label for=\"inputID3\">" + WWHFrame.mInfoHubName + "</label></p>\n";
         }
      }


      MyDocsEnable = "";
      MyDocsText = "Edit";
      MyDocsClass = "";
      MyDocsFontB = "";
      MyDocsFontE = "";
      MyDocsTip = "Add or Remove books from your local Search/Index.";
      if ( (WWHFrame.mMyDocsList.length < 1) || (WWHFrame.mMyDocsList[0][0] == "None Selected") )
      {
         MyDocsEnable = "disabled";
         MyDocsText = "Create";
         MyDocsFontB = "<span style=\"color: #C8C8C8;\ font-style: italic;\"> ";
         MyDocsFontE = "</span>";
         MyDocsTip = "Create a custom list of books for your local Search/Index.";
      }
      SOHTML += MyDocsFontB;
      if (WWHFrame.MySearchPrefs == "MYDOCS" )
      {
          SOHTML += ptag + "<input " + MyDocsEnable + " type=\"radio\" id=\"inputID4\" CHECKED name=\"group2\" value=\"MYDOCS\"><label for=\"inputID4\">My Search List</label>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"MenuItemB\"><a href=\"javascript\:WWHFrame.DisplaySearchPrefs();\" title=\"" + MyDocsTip + "\">" + MyDocsText + "</a></span></p>\n";
      }
      else
      {
          SOHTML += ptag + "<input " + MyDocsEnable + " type=\"radio\" id=\"inputID4\" name=\"group2\" value=\"MYDOCS\"  onclick=\"javascript:WWHFrame.SetSearchScope('MYDOCS');return false;\"><label for=\"inputID4\">My Search List</label>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"MenuItemB\"><a href=\"javascript\:WWHFrame.DisplaySearchPrefs();\" title=\"" + MyDocsTip + "\">" + MyDocsText + "</a></span></p>\n";
      }
      SOHTML += MyDocsFontE;
   }
   
   return SOHTML;
}

function SetIndexScope(source)
{
   SavedPrefs = WWHFrame.MySearchPrefs;
   WWHFrame.MySearchPrefs = source;
   WWHFrame.LoadedFirstSearchEntry = false;
   if (source == "DOC")
   {
      Handle = WWHFrame.MGCContent.MGCDocContent.DocHandle;
      Title = WWHFrame.MGCContent.MGCDocContent.DocTitle;
      WWHFrame.mSource = "doc";
      WWHFrame.mHandle = Handle;
      WWHFrame.DocHandle = Handle;
   }
   if (source == "MYDOCS")
   {
      MGCReloadMyDocs();
      if ( (WWHFrame.mMyDocsList.length < 1) || (WWHFrame.mMyDocsList[0][0] == "None Selected") )
      {
         WWHFrame.MySearchPrefs = SavedPrefs;
         alert("You must first define a set of documents");
      }
   }  
   UpdateIndexScope();
}


function InsertIXPopupDivStyles()
{
   var divHTML = "";
   divHTML += "<style type=\"text/css\">\n";
   divHTML += " <!--\n";
   divHTML += "    td.MGCNowrap {\n";
   divHTML += "    white-space: nowrap;\n";
   divHTML += "    }\n";
   divHTML += "  div\.mPercent\n";
   divHTML += "  {\n";
   divHTML += "    font-size: " + WWHFrame.BaseNavFontSize + "px;\n";
   if (MGCShowSearchFilter)
   { divHTML += "    visibility: visible;\n"; }
   else
   { divHTML += "    visibility: hidden;\n"; }
   divHTML += "    position: absolute;\n";
   divHTML += "    background-color:#FFFFFF;\n";
   divHTML += "    border: 2px solid #000000;\n";
   divHTML += "    border-top-width: 2px;\n";
   divHTML += "    border-top-color: grey;\n";
   divHTML += "    border-left-width: 2px;\n";
   divHTML += "    border-left-color: grey;\n";
   divHTML += "    border-right-width: 4px;\n";
   divHTML += "    border-right-color: #000000;\n";
   divHTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   divHTML += "    margin-top: 1pt;\n";
   divHTML += "    margin-top: 1pt;\n";
   divHTML += "    margin-bottom: 1pt;\n";
   divHTML += "    margin-left: 0pt;\n";
   divHTML += "    text-indent: 0pt;\n";
   divHTML += "    text-align: left;\n"; 
   divHTML += "  }\n";

   divHTML += "  div\.mIXScope\n";
   divHTML += "  {\n";
   divHTML += "    font-size: " + WWHFrame.BaseNavFontSize + "px;\n";
   divHTML += "    visibility: visible;\n";
   divHTML += "    position: relative;\n";
   // Set position based on search/index UNIX/PC Netscape/FireFox/IE
   var Dtop = "\-16";
   if (WWHFrame.browsername == "Internet Explorer")
      {  Dtop = "0"; }
   else
   {
      if (WWHFrame.browsername == "Firefox")
      {
         if (WWHFrame.WWHJavaScript.mCurrentTab == "1")  //Index
            {  Dtop = "-8"; }
         if (WWHFrame.WWHJavaScript.mCurrentTab == "2")  //Search
            {  Dtop = "0"; }
      }
      if (WWHFrame.browsername == "Netscape Navigator")
      {
         if (WWHFrame.WWHJavaScript.mCurrentTab == "1")  //Index
            {  Dtop = "0"; }
         if (WWHFrame.WWHJavaScript.mCurrentTab == "2")  //Search
            {  Dtop = "0"; }
      }
   }
   divHTML += "    top: " + Dtop + "px;\n";
//   divHTML += "    bottom: -10px;\n";
//   divHTML += "    left: 23px;\n";

   divHTML += "    border: 0px solid #000000;\n";
   divHTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   divHTML += "    margin-top: 0pt;\n";
   divHTML += "    margin-top: 0pt;\n";
   divHTML += "    margin-bottom: 0pt;\n";
   divHTML += "    margin-left: 0pt;\n";
   divHTML += "    text-indent: 0pt;\n";
   divHTML += "    text-align: left;\n"; 
   divHTML += "  }\n";



   divHTML += " -->\n";
   divHTML += "</style>\n";
   divHTML += "<script type=\"text/javascript\" language=\"JavaScript1.2\">\n";
   divHTML += " <!--\n";
   divHTML += "function SHPercentMenu(szDivID, iState) // 1 visible, 0 hidden\n";
   divHTML += "{\n";
   divHTML += "    if(document.layers)	   //NN4+\n";
   divHTML += "    {\n";
   divHTML += "       document.layers[szDivID].visibility = iState ? \"show\" : \"hide\";\n";
   divHTML += "       document.layers[szDivID].display = iState ? \"block\" : \"none\";\n";
   divHTML += "    }\n";
   divHTML += "    else if(document.getElementById)	  //gecko(NN6) + IE 5+\n";
   divHTML += "    {\n";
   divHTML += "        var obj = document.getElementById(szDivID);\n";
   divHTML += "        obj.style.visibility = iState ? \"visible\" : \"hidden\";\n";
   divHTML += "        obj.style.display = iState ? \"block\" : \"none\";\n";
   divHTML += "    }\n";
   divHTML += "    else if(document.all)	// IE 4\n";
   divHTML += "    {\n";
   divHTML += "        document.all[szDivID].style.visibility = iState ? \"visible\" : \"hidden\";\n";
   divHTML += "        document.all[szDivID].style.display = iState ? \"block\" : \"none\";\n";
   divHTML += "    }\n";
   divHTML += "}\n";
   divHTML += " // -->\n";
   divHTML += "</script>\n";
   return divHTML;
}
