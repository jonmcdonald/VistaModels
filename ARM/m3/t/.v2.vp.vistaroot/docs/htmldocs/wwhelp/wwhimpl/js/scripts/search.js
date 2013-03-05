// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHSearch_Object()
{

  this.mbSearchPopups        = SearchPopupsEnabled();
  this.mbPanelInitialized    = false;
  this.mPanelAnchor          = null;
  this.mPanelTabTitle        = WWHFrame.WWHJavaScript.mMessages.mTabsSearchLabel;
  this.mPanelTabIndex        = -1;
  this.mPanelFilename        = ((WWHFrame.WWHBrowser.mBrowser == 1) ? "panelfns.htm" : "panelfss.htm");
  this.mInitIndex            = 0;
  this.mBookSearchInfoList   = new Array();
  this.mbSearching           = false;
  this.mSearchScopeInfo      = null;
  this.mSavedSearchWords     = "";
  this.mSavedSearchScope     = 0;
  this.mSearchWordList       = new Array();
  this.mSearchWordRegExpList = new Array();
  this.mBookIndex            = 0;
  this.mBookMatchesList      = new Array();
  this.mCombinedResults      = new WWHSearchResults_Object();

  this.fInitHeadHTML           = WWHSearch_InitHeadHTML;
  this.fInitBodyHTML           = WWHSearch_InitBodyHTML;
  this.fInitLoadBookSearchInfo = WWHSearch_InitLoadBookSearchInfo;
  this.fNavigationHeadHTML     = WWHSearch_NavigationHeadHTML;
  this.fNavigationBodyHTML     = WWHSearch_NavigationBodyHTML;
  this.fHeadHTML               = WWHSearch_HeadHTML;
  this.fStartHTMLSegments      = WWHSearch_StartHTMLSegments;
  this.fAdvanceHTMLSegment     = WWHSearch_AdvanceHTMLSegment;
  this.fGetHTMLSegment         = WWHSearch_GetHTMLSegment;
  this.fEndHTMLSegments        = WWHSearch_EndHTMLSegments;
  this.fPanelNavigationLoaded  = WWHSearch_PanelNavigationLoaded;
  this.fPanelViewLoaded        = WWHSearch_PanelViewLoaded;
  this.fHoverTextTranslate     = WWHSearch_HoverTextTranslate;
  this.fHoverTextFormat        = WWHSearch_HoverTextFormat;
  this.fDisplaySearchForm      = WWHSearch_DisplaySearchForm;
  this.fSubmit                 = WWHSearch_Submit;
  this.fForceSubmit            = MGC_ForceSubmit;  //MGCSD Added function
  this.fSetSearchWords         = WWHSearch_SetSearchWords;
  this.fCheckForMatch          = WWHSearch_CheckForMatch;
  this.fSearchComplete         = WWHSearch_SearchComplete;
  this.fCombineResults         = WWHSearch_CombineResults;
  this.fShowEntry              = WWHSearch_ShowEntry;
}

function  WWHSearch_InitHeadHTML()
{
  var  InitHeadHTML = "";


  // Create search scope info
  //
  this.mSearchScopeInfo = new WWHSearchScope_Object();

  return InitHeadHTML;
}

function  WWHSearch_InitBodyHTML()
{
  WWHFrame.InGlobalIndex = false;
  WWHFrame.InGlobalSearch = true;
  var  HTML = new WWHStringBuffer_Object();
  var  BookList;
  var  MaxIndex;
  var  Index;


  // Display initializing message
  //
  HTML.fAppend("<h2>" + WWHFrame.WWHJavaScript.mMessages.mInitializingMessage + "</h2>\n");

  // Load search info
  //
  this.mInitIndex = 0;
  BookList = WWHFrame.WWHHelp.mBooks.mBookList;
  WWHFrame.mParatext = new Array();
  HTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/search0.js\"></script>\n");
  HTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/search1s.js\"></script>\n");
  for (MaxIndex = BookList.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
     // Reference search info
     //
//     HTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(BookList[Index].mDirectory) + "wwhdata/js/search.js\"></script>\n");
     HTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(BookList[Index].mDirectory) + "wwhdata/common/ParaTxt2.js\"></script>\n");
     HTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/search1s.js\"></script>\n");
  }

  return HTML.fGetBuffer();
}

function  WWHSearch_InitLoadBookSearchInfo(ParamSearchFileCount,
                                        ParamMinimumWordLength,
                                        ParamSearchSkipWordsFunc)
{
  // Load book search info
  //
  this.mBookSearchInfoList[this.mInitIndex] = new WWHBookSearchInfo_Object(ParamSearchFileCount, ParamMinimumWordLength);
  ParamSearchSkipWordsFunc(this.mBookSearchInfoList[this.mInitIndex]);

  // Create match objects for each book
  //
  this.mBookMatchesList[this.mBookMatchesList.length] = new WWHSearchBookMatches_Object();

  // Increment init book index
  //
  this.mInitIndex++;

  // Mark initialized if done
  //
  if (this.mInitIndex == WWHFrame.WWHHelp.mBooks.mBookList.length)
  {
 this.mbPanelInitialized = true;
  }
}

function  WWHSearch_NavigationHeadHTML()
{
  return "";
}

function  WWHSearch_NavigationBodyHTML()
{
  return this.fDisplaySearchForm();
}

function  WWHSearch_HeadHTML()
{
  var  HTML = new WWHStringBuffer_Object();
  var  Settings = WWHFrame.WWHJavaScript.mSettings.mSearch;


  // Generate style section
  //
//  HTML.fAppend(WWHFrame.MGCWWGenerateNavStyle());
  HTML.fAppend("<style type=\"text/css\">\n");
  HTML.fAppend(" <!--\n");
  HTML.fAppend("  a:active, a:focus\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    background-color: " + Settings.mHighlightColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  a:hover\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: underline;\n");
  HTML.fAppend("    color: " + Settings.mEnabledColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  a\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    text-decoration: none;\n");
  HTML.fAppend("    color: " + Settings.mEnabledColor + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    " + Settings.mFontStyle + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p.BookTitle\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    font-weight: bold;\n");
  HTML.fAppend("    " + Settings.mFontStyle + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  ol\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  if (Settings.mbShowRank)
  {
 HTML.fAppend("    " + Settings.mFontStyle + ";\n");
  }
  else
  {
 HTML.fAppend("    list-style: none;\n");
  }
  HTML.fAppend("  }\n");
  HTML.fAppend("  li\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 2pt;\n");
  HTML.fAppend("    margin-bottom: 0pt;\n");
  HTML.fAppend("    " + Settings.mFontStyle + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("    a\:link    { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:visited { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:active  { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:hover   { color\: #0000FF\;text-decoration\: underline\; }\n");
  HTML.fAppend("  p.BookTitle\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    font-weight: bold;\n");
  HTML.fAppend("    font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
  HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  p.SearchEntry\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    font-size: " + WWHFrame.BaseNavFontSize + "px;\n");
  HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    margin-left: 3pt;\n");
  HTML.fAppend("    text-indent: 0pt;\n");
  HTML.fAppend("    text-align: left;\n"); 
  HTML.fAppend("  }\n");
  HTML.fAppend("  p.SearchEntryP\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n");
  HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    margin-left: 0pt;\n");
  HTML.fAppend("    text-indent: 0pt;\n"); 
  HTML.fAppend("    text-align: right;\n"); 
  HTML.fAppend("  }\n");
  HTML.fAppend("  div\.Percent\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n");
  HTML.fAppend("    visibility: visible;\n");
//  HTML.fAppend("    position: absolute;\n");
//  HTML.fAppend("    left:0px;\n");
//  HTML.fAppend("    bottom:0px;\n");
//  HTML.fAppend("    height:16px;\n");
  HTML.fAppend("    width:98%;\n");
  HTML.fAppend("    background-color:#99FFFF;\n");
  HTML.fAppend("    border: 2px solid #000000;\n");
  HTML.fAppend("    border-top-width: 2px;\n");
  HTML.fAppend("    border-top-color: grey;\n");
  HTML.fAppend("    border-left-width: 2px;\n");
  HTML.fAppend("    border-left-color: grey;\n");
  HTML.fAppend("    border-right-width: 4px;\n");
  HTML.fAppend("    border-right-color: #000000;\n");
  HTML.fAppend("    font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    margin-left: 0pt;\n");
  HTML.fAppend("    text-indent: 0pt;\n");
  HTML.fAppend("    text-align: left;\n"); 
  HTML.fAppend("  }\n");
  HTML.fAppend(" -->\n");
  HTML.fAppend("</style>\n");
  return HTML.fGetBuffer();
}

function  WWHSearch_StartHTMLSegments()
{
   var  HTML = new WWHStringBuffer_Object();
   var  MaxBookIndex;
   var  BookIndex;
   var  BookList;
   var  MaxIndex;
   var  Index;
   var  BookDirectory;
   var  bDisplayBookTitles;
   if (this.mbPanelInitialized)
   {
   // Perform search if required
   //
      if (this.mbSearching)
      {
      // Display searching message
      //
         HTML.fAppend("<h2>" + WWHFrame.WWHJavaScript.mMessages.mSearchSearchingMessage + "&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"../../common/images/animation_action_spin.gif\" width=22 border=0 /></h2>\n");

         // Handle single book search
         //
         BookList = WWHFrame.WWHHelp.mBooks.mBookList;
         if (this.mSavedSearchScope > 0)
         {
            BookIndex    = this.mSearchScopeInfo.mEntries[this.mSavedSearchScope - 1].mStartBookIndex;
            MaxBookIndex = this.mSearchScopeInfo.mEntries[this.mSavedSearchScope - 1].mEndBookIndex + 1;
         }
         else
         {
            BookIndex    = 0;
            MaxBookIndex = BookList.length;
         }

         // Generate search actions
         //
         this.mBookIndex = BookIndex;
         //alert("BookIndex is " + BookIndex);
         for ( ; BookIndex < MaxBookIndex ; BookIndex++)
         {
            BookDirectory = BookList[BookIndex].mDirectory;
            //  MGCRK  Modify this loop so it only loads the search files for the
            //  set or subset of books we want to search
            //
            //  Create an array that contains the handles (directories) for the books
            //  That should be searched, either 1 book, a specific infohub, or the user's list
            //  zzzzzzzzzzzzzzzzzzzzz
            SearchList = new Array();
//WWHFrame.MGCReloadMyDocs();
//alert("WWHFrame.mMyDocsList is\n " + WWHFrame.mMyDocsList);
            mCurrentDocList = new Array;
            mCurrentDocList[0] = ["xxxx",WWHFrame.mHandle];
            mCurrentDocList[1] = ["xxxx","zQiY"];
            switch (WWHFrame.MySearchPrefs)
            {
               case "LIB": SearchList = WWHFrame.mLibraryList; break;
               case "MYDOCS": WWHFrame.MGCReloadMyDocs();SearchList = WWHFrame.mMyDocsList; break;
               case "SNet": SearchList = WWHFrame.mLibraryList; break;
               case "IHUB": SearchList = WWHFrame.ihubDList; break;
               case "DOC": SearchList = WWHFrame.mCurrentDocList; break;
               default: SearchList = WWHFrame.mLibraryList;
            }
            //alert("SearchList is " + SearchList);
            for (MaxIndex = this.mBookSearchInfoList[BookIndex].mSearchFileCount, Index = 0 ; Index < MaxIndex ; Index++)
            {
               for (MxIx = SearchList.length, Ix = 0 ; Ix < MxIx ; Ix++)
               if (SearchList[Ix][1] == WWHFrame.WWHBrowser.fRestoreEscapedSpaces(BookDirectory).replace("/","") )
               {
//alert("Adding " + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(BookDirectory) + "wwhdata/js/search/search" + Index + ".js");
//                  HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(BookDirectory) + "wwhdata/js/search/search" + Index + ".js\"></script>\n");
                  HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(BookDirectory) + "wwhdata/js/search/search0_sort.js\"></script>\n");
                  HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/search2s.js\"></script>\n");
               }      
            }
            HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/search3s.js\"></script>\n");
         }
         HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/search4s.js\"></script>\n");
      }
      else
      {
      // Define accessor functions to reduce file size
      //
         HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\">\n");
         HTML.fAppend(" <!--\n");
         HTML.fAppend("  function  fC(ParamEntryID,pointer)\n");
         HTML.fAppend("  {\n");
         HTML.fAppend("    WWHFrame.WWHSearch.fShowEntry(ParamEntryID);\n");
         HTML.fAppend("    WWHFrame.CurrentSearchHit = pointer;\n");
         HTML.fAppend("  }\n");
         HTML.fAppend("\n");
         HTML.fAppend("  function  fS(ParamEntryID,\n");
         HTML.fAppend("               ParamEvent)\n");
         HTML.fAppend("  {\n");
         HTML.fAppend("    return;\n");
         HTML.fAppend("  }\n");
         HTML.fAppend("\n");
         HTML.fAppend("  function  fH()\n");
         HTML.fAppend("  {\n");
         HTML.fAppend("    WWHFrame.WWHJavaScript.mPanels.mPopup.fHide();\n");
         HTML.fAppend("  }\n");
         HTML.fAppend(" // -->\n");
         HTML.fAppend("</script>\n");
         // Display search message and/or prepare results for display
         //
         if (this.mSavedSearchWords.length == 0)
         {
            //        HTML.fAppend("<h3>" + WWHFrame.WWHJavaScript.mMessages.mSearchDefaultMessage + "</h3>\n");
         }
         else if ((typeof(this.mCombinedResults.mEntries) != "undefined") &&
            (this.mCombinedResults.mEntries.length > 0))
         {
         // Determine if book name should be displayed about results
         //
            if ((WWHFrame.WWHHelp.mBooks.mBookList.length == 1) ||
               ((this.mSavedSearchScope > 0) &&
             (this.mSearchScopeInfo.mEntries[this.mSavedSearchScope - 1].mStartBookIndex == this.mSearchScopeInfo.mEntries[this.mSavedSearchScope - 1].mEndBookIndex)))
            {
               // Single book scope selected, do not display book titles
               //
               bDisplayBookTitles = false;
            }
            else
            {
            // More than one book in search scope, display book titles
            //
               bDisplayBookTitles = true;
            }
            this.mCombinedResults.fDisplayReset(bDisplayBookTitles);
         }
         else
         // MGCRK - new "No Results" message
         {
            WWHFrame.LastDoc = WWHFrame.mHandle;
            WWHFrame.NoSearchResults = true;
            WWHFrame.MGCContent.MGCDocContent.location.replace("../../../../mgc_html_help/searching_no_results.html");
            HTML.fAppend("<p class=\"message\">&nbsp;</p><p class=\"message\">&nbsp;</p><p class=\"message\"><b>No Results<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + WWHFrame.BaseNavFontSize + "px; margin-top: 1pt margin-bottom: 1pt></b>\n");
            HTML.fAppend("<p class=\"message\">&nbsp;</p><p class=\"message\">Try new keywords, or see the help information at the right for tips on improving your search results or click the SupportNet link above.</p>\n");
            if (WWHFrame.ThisDocTitle == "Searching........")
            { 
               WWHFrame.MGCNavigate.MGCTabs.MGC_InsertDisabledContentsTab();
            }
            WWHFrame.MGCNavigate.MGCTabs.MGC_InsertDisabledMyTopicsTab();
            UpdateSearchScope();
         }
      }
   }
   return HTML.fGetBuffer();
}

function  WWHSearch_AdvanceHTMLSegment()
{
   var  bSegmentCreated = false;

   if (this.mbPanelInitialized)
   {
      if ( ! this.mbSearching)
      {
         bSegmentCreated = this.mCombinedResults.fDisplayAdvance();
      }
   }
   return bSegmentCreated;
}

function  WWHSearch_GetHTMLSegment()
{
   return this.mCombinedResults.mHTMLSegment.fGetBuffer();
}

function  WWHSearch_EndHTMLSegments()
{
   return "";
}

function  WWHSearch_PanelNavigationLoaded()
{
  // Set focus
  //
   WWHFrame.WWHHelp.fFocus("WWHPanelNavigationFrame");
  
   //MGCSD If Search param in URL, force search submission
   if ( WWHFrame.WWHHelp.fGetURLSearchWords() != "" )
   {
      WWHFrame.WWHSearch.fForceSubmit();
      WWHFrame.LoadedFirstSearchEntry = false;
   }
}

function  WWHSearch_PanelViewLoaded()
{
   // Display search results if necessary
   //
   if (this.mbSearching)
   {
      this.mbSearching = false;
      WWHFrame.WWHJavaScript.mPanels.fReloadView();
   }
}

function  WWHSearch_HoverTextTranslate(ParamEntryID)
{
  var  HTML     = "";
  var  BookList = WWHFrame.WWHHelp.mBooks.mBookList;
  var  Settings = WWHFrame.WWHJavaScript.mSettings.mSearch;
  var  Messages = WWHFrame.WWHJavaScript.mMessages;
  var  Entry;
  var  Rank = "";
  var  Title;
  var  Book = "";
  var  Format;


  // Retrieve specified entry
  //
  Entry = this.mCombinedResults.mEntries[ParamEntryID];

  // Get Rank
  //
  if (Settings.mbShowRank)
  {
 Rank = Math.floor((Entry.mScore / this.mCombinedResults.mMaxScore) * 100) + "%";
  }

  // Get Title
  //
  Title = Entry.mTitle;

  // Get Book
  //
  if ((BookList.length > 1) &&                 // More than one book exists
   (this.mCombinedResults.mSortedBy == 1))  // By Score
  {
 Book = BookList[Entry.mBookIndex].mTitle;
  }

  // Format for display
  //
  if ((Rank.length == 0) &&
   (Book.length == 0))
  {
 // Simple format, just the title
 //
 HTML = Title;
  }
  else
  {
 Format = " align=\"left\" valign=\"top\"><span style=\"" + WWHFrame.WWHJavaScript.mSettings.mHoverText.mFontStyle + "\">";

 // Complex format, requires a table
 //
 HTML += "<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\">";
 if (Rank.length > 0)
 {
   HTML += "<tr>";
   HTML += "<th" + Format + Messages.mSearchRankLabel + "</span></th>";
   HTML += "<td" + Format + Rank + "</span></td>";
   HTML += "</tr>";
 }
 HTML += "<tr>";
 HTML += "<th" + Format + Messages.mSearchTitleLabel + "</span></th>";
 HTML += "<td" + Format + Title + "</span></td>";
 HTML += "</tr>";
 if (Book.length > 0)
 {
   HTML += "<tr>";
   HTML += "<th" + Format + Messages.mSearchBookLabel + "</span></th>";
   HTML += "<td" + Format + Book + "</span></td>";
   HTML += "</tr>";
 }
 HTML += "</table>";

 // IE 5.0 on the Macintosh drops the last table for some reason
 //
 if (WWHFrame.WWHBrowser.mbMacIE50)
 {
   HTML += "<table><tr><td></td></tr></table>";
 }
  }

  return HTML;
}

function  WWHSearch_HoverTextFormat(ParamWidth,
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

function  WWHSearch_DisplaySearchForm()
{
   var  HTML = "";
   var  BookList = WWHFrame.WWHHelp.mBooks.mBookList;
   var  SelectedIndex;
   var  MaxIndex;
   var  Index;
   var  SearchScopeEntry;
   var  MaxLevel;
   var  Level;
   var  FontSize;

   //
   //MGCRK - Added buttons for local vs Global search.
   //
   WWHFrame = eval("parent.parent");
//   HTML += WWHFrame.MGCWWGenerateNavStyle();
   HTML += "<style type=\"text/css\">\n";
   HTML += " <!--\n";
   HTML += "    td.MGCNowrap {\n";
   HTML += "    white-space: nowrap;\n";
   HTML += "    }\n";
   HTML += "    p.MGCNavigation {\n";
   HTML += "    margin-top: 1pt;\n";
   HTML += "    margin-bottom: 1pt;\n";
   HTML += "    	font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   HTML += "    	font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n";
   HTML += "    }\n";
   HTML += "    p.MGCFormTitle {\n";
   HTML += "    margin-top: 1pt;\n";
   HTML += "    margin-bottom: 1pt;\n";
   HTML += "    	font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   HTML += "    	font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n";
   HTML += "    	color: #FFFFFF;\n";
   HTML += "    }\n";
   HTML += "    p.MGCFormTitleB {\n";
   HTML += "    margin-top: 1pt;\n";
   HTML += "    margin-bottom: 1pt;\n";
   HTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   HTML += "    font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n";
   HTML += "    color: #000000;\n";
   HTML += "    }\n";

   HTML += "    p.MGCScopeSel {\n";
   HTML += "    margin-top: 0pt;\n";
   HTML += "    margin-left: 0.28in;\n";
   HTML += "    margin-bottom: 0pt;\n";
   HTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   HTML += "    font-size: " + (WWHFrame.BaseNavFontSize) + "px;\n";
   HTML += "    text-indent: -0.22in;\n";
   HTML += "    	color: #000000;\n";
   HTML += "    }\n";
   HTML += "    input {\n";
   HTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   HTML += "    font-size: " + (WWHFrame.BaseNavFontSize+1) + "px;\n";
   HTML += "    margin-top: 0pt;\n";
   MarginBottom = 3;
   if (WWHFrame.browsername == "Internet Explorer") { MarginBottom = 0; }
   HTML += "    margin-bottom: " + MarginBottom + "pt;\n";
   HTML += "    vertical-align: text-top;\n";
   HTML += "    }\n";
   HTML += "  .MenuItemB\n";
   HTML += "  {\n";
   HTML += "    color: Black;\n";
   HTML += "    font-family: Verdana, Arial, Helvetica, sans-se;\n";
   HTML += "    font-size: " + WWHFrame.BaseNavFontSize + "px;\n";
   HTML += "    line-height: 1.0em;\n";
   HTML += "    margin-bottom: 2px;\n";
   HTML += "    margin-top: 2px;\n";
   HTML += "    margin-left: 10px;\n";
   HTML += "    margin-right: 2px;\n";
   HTML += "    font-style: normal;\n";
   HTML += "    font-variant: normal;\n";
   HTML += "    font-weight: normal;\n";
   HTML += "    text-decoration: none;\n";
   HTML += "    text-indent: 0in;\n";
   HTML += "    text-transform: none;\n";
   HTML += "  }\n";
   HTML += "  p.MenuItemW\n";
   HTML += "  {\n";
   HTML += "    color: White;\n";
   HTML += "    font-family: Verdana, Arial, Helvetica, sans-se;\n";
   HTML += "    font-size: " + WWHFrame.BaseNavFontSize + "px;\n";
   HTML += "    line-height: 1.0em;\n";
   HTML += "    margin-bottom: 2px;\n";
   HTML += "    margin-top: 2px;\n";
   HTML += "    margin-left: 10px;\n";
   HTML += "    margin-right: 2px;\n";
   HTML += "    font-style: normal;\n";
   HTML += "    font-variant: normal;\n";
   HTML += "    font-weight: normal;\n";
   HTML += "    text-decoration: none;\n";
   HTML += "    text-indent: 0in;\n";
   HTML += "    text-transform: none;\n";
   HTML += "  }\n";
   HTML += "  .BarMenuItemW, a.BarMenuItemW:active, a.BarMenuItemW:link, a.BarMenuItemW:hover, a.BarMenuItemW:focus \n";
//   HTML += "  .BarMenuItemW\n";
   HTML += "  {\n";
   HTML += "    color: #FFFFFF;\n";
   HTML += "    font-family: Verdana, Arial, Helvetica, sans-se;\n";
   HTML += "    font-size: " + WWHFrame.BaseNavFontSize + "px;\n";
   HTML += "    line-height: 1.0em;\n";
   HTML += "    margin-bottom: 2px;\n";
   HTML += "    margin-top: 2px;\n";
   HTML += "    margin-left: 5px;\n";
   HTML += "    margin-right: 2px;\n";
   HTML += "    font-style: normal;\n";
   HTML += "    font-variant: normal;\n";
   HTML += "    font-weight: bold;\n";
   HTML += "    text-decoration: none;\n";
   HTML += "    text-indent: 0in;\n";
   HTML += "    text-transform: none;\n";
   HTML += "  }\n";
   HTML += "  .MenuItemB:active, .MenuItemB:focus\n";
   HTML += "  {\n";
   HTML += "    text-decoration: none;\n";
   HTML += "    color: blue;\n";
   HTML += "  }\n";
   HTML += " -->\n";
   HTML += "</style>\n";
   HTML += InsertPopupDivStyles();
   var font = "<p class=\"MGCNavigation\">";
   HTML += "<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + WWHFrame.BaseNavFontSize + "px; margin-top: 1pt margin-bottom: 1pt>";
   HTML += "<table border=\"0\" width=\"100\%\" cellpadding=\"1\" cellspacing=\"0\">";
   HTML += "<tr><td height=\"14\">";
   if ( typeof(WWHFrame.MySearchPrefs) == "undefined" )
   { WWHFrame.MySearchPrefs = "LIB"; }
   if ( typeof(WWHFrame.mInfoHubName) == "undefined" )
   { WWHFrame.mInfoHubName = "mgc_ih"; }
   HTML += "<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + WWHFrame.BaseNavFontSize + "px; margin-top: 1pt margin-bottom: 3pt>";
   HTML += "<b>" + WWHFrame.WWHJavaScript.mMessages.mSearchDefaultMessage + "</b></td></tr>\n";
   HTML += "<tr><td height=\"12\">";
   HTML += "<form name=\"WWHSearchForm\" onSubmit=\"return WWHFrame.WWHSearch.fSubmit();\">\n";
   HTML += "<nobr>\n";
   //MGCSD Use words from URL search parameter, if provided
   if ( WWHFrame.WWHHelp.fGetURLSearchWords() != "" ) {
      HTML += "<input type=\"text\" name=\"WWHSearchWordsText\" size=\"20\" value=\"" + WWHFrame.WWHHelp.fGetURLSearchWords() + "\" onKeyDown=\"WWHFrame.WWHHelp.fIgnoreNextKeyPress((document.all||document.getElementById||document.layers)?event:null);\">\n";
   } else {
      HTML += "<input type=\"text\" name=\"WWHSearchWordsText\" size=\"20\" value=\"" + this.mSavedSearchWords + "\" onKeyDown=\"WWHFrame.WWHHelp.fIgnoreNextKeyPress((document.all||document.getElementById||document.layers)?event:null);\">\n";
   }
   HTML += "<input type=\"submit\" value=\"" + WWHFrame.WWHJavaScript.mMessages.mSearchButtonLabel + "\">\n";
   HTML += "</nobr><span class=\"MenuItemB\"><a href=\"javascript:WWHFrame.MGCDisplaySearchTips();\" title=\'Search Tips\'>Tips</a></span></td></tr>";
   HTML += "</form>";
   HTML += "</table>";
   if (BookList.length > 1)
   {
     SelectedIndex = this.mSavedSearchScope - 1;
   }
   // MGCRK Define search scopes  (Book, Library, InfoHub, My Search List, or SupportNet)
   // 
   HTML += "<div class=\"mScope\" id=\"MGCSScopeDiv\";>";
   HTML += "<form name=\"ScopeSelect\";\">\n";
   HTML += InsertDocTitleScope();
   HTML += "</form>";
   HTML += "</div>";
   HTML += "<span style=\" color: black; font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + WWHFrame.BaseNavFontSize + "px\" margin-top: 1pt margin-bottom: 1pt>";

   if (WWHFrame.MinSearchPercent ==  1) { PercentValue = "&nbsp;&nbsp;<img src=\"../../common/images/SearchH.gif\" border=0 />"; }
   if (WWHFrame.MinSearchPercent == 39) { PercentValue = "&nbsp;&nbsp;&nbsp;<img src=\"../../common/images/SearchM.gif\" border=0 />"; }
   if (WWHFrame.MinSearchPercent == 74) { PercentValue = "&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"../../common/images/SearchL.gif\" border=0 />"; }
//   if (WWHFrame.MinSearchPercent == 1) { PercentValue = "H\+M\+L"; }
//   if (WWHFrame.MinSearchPercent == 39) { PercentValue = "H\+M"; }
//   if (WWHFrame.MinSearchPercent == 74) { PercentValue = "H"; }
   ShownResults = "<a class=\"BarMenuItemW\" style=\"color:#FFFFFF\" href=\"javascript\:WWHFrame.myvoid()\" onMouseOver=\"javascript\:WWHFrame.DisplayLevelHelp()\" onMouseOut=\"javascript\:WWHFrame.CloseLevelHelp()\"><i>" + PercentValue + "</i></a>";
   MenuLink = "<a class=\"BarMenuItemW\" style=\"color:#FFFFFF\" href=\"javascript:WWHFrame.myvoid()\" onclick=\"WWHFrame.ShowSearchOptions();\" title=\"Click to change search options.\">";
   MenuLink += "<b>Options<img src=\"../../common/images/menu_up.gif\" border=0 /></b></a>";
   if (WWHFrame.ShowSearchBooks == "NO")
   { SearchTitle = "<span class=\"BarMenuItemW\"><b>&nbsp;Topic:</b></span>"; }
   else
   { SearchTitle = "<span class=\"BarMenuItemW\"><b>&nbsp;Book/Topic:</b></span>"; }
//Disable prev/next hit buttons for initial v2 release
   NextHit = " ";
   PrevHit = " ";
//MGCRK - reserve these buttons for possible page functions.
//   NextHit = "<a href=\"javascript:WWHFrame.DNSH();\" title=\"Click to view NEXT search hit for current results list.\"><img src=\"../../common/images/searchnext.png\" border=0 vspace=0 /></a>";
//   PrevHit = "<a href=\"javascript:WWHFrame.DPSH();\" title=\"Click to view PREVIOUS search hit for current results list.\"><img src=\"../../common/images/searchprev.png\" border=0 vspace=0 /></a>";
   NextHit = " ";
   PrevHit = " ";
   HTML += "<div STYLE=\"position:absolute; left:0px; bottom:0px; width:98%;background-color:#416E98; border: 2px solid #000000; border-top-width: 2px;border-top-color: grey;border-left-width: 2px;border-left-color: grey;border-right-width: 2px;border-right-color: #000000; \">";
   HTML += "<table border=0 width=100% cellpadding=0 cellspacing=0>\n";
   HTML += "<tr><td class=\"MGCNowrap\" width=25% height=\"12\" align=left><span class=\"BarMenuItemW\">" + ShownResults + "</span></td>";
   HTML += "<td class=\"MGCNowrap\" width=40%>" + SearchTitle + "</td>";
   HTML += "<td class=\"MGCNowrap\">" + PrevHit + "</td>";
   HTML += "<td class=\"MGCNowrap\">" + NextHit + "</td>";
   HTML += "<td class=\"MGCNowrap\" align=left width=30%><span class=\"BarMenuItemW\">" + MenuLink + "</span></td>";
   HTML += "</tr></table></div>";
   HTML += InsertLevelHelp();
   HTML += InsertSearchOptions();
   return HTML;
}

function MGCToggleSShBooks(HS)
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
   HideSearchOptions();
   WWHFrame.MGCNavigate.MGCIndex.location.reload(true);
} 

function MGCChangeSearchPercent(percent)
{
   WWHFrame.MinSearchPercent = percent;
   if (MGCCookiesEnabled())
   {
      MGCSetCookie("MGCMinSearchPercent",WWHFrame.MinSearchPercent);
   }
   WWHFrame.MGCShowSearchFilter = true;
   HideSearchOptions();
   WWHFrame.MGCNavigate.MGCIndex.location.reload(true);
}
function  WWHSearch_Submit()
{
   var  VarPanelNavigationFrame;
   var  SearchForm;
   var  NewSearchWords;
   var  NewSearchScope;
   var  MaxIndex;
   var  Index;
   WWHFrame.MGCNavigate.MGCTabs.MGC_InsertEnabledContentsTab();
   WWHFrame.MGCNavigate.MGCTabs.MGC_InsertEnabledMyTopicsTab();
   if (WWHFrame.NoSearchResults)
   {
     WWHFrame.MGCContent.MGCDocContent.location.replace("../../../../_a_search_tips/title1.html");
     WWHFrame.NoSearchResults = false;
   }
   
   if ( typeof(WWHFrame.GetIHUBHandle()) != "undefined" )
   {   CurrentIHUBHandle = WWHFrame.GetIHUBHandle()[0]; }
   else
   {   CurrentIHUBHandle = "mgc_ih" }
   
   if (WWHFrame.MySearchPrefs == "SNet")
   {
      if (CurrentIHUBHandle == "NONE") { CurrentIHUBHandle = "mgc_ih"; }
      VarPanelNavigationFrame = eval(WWHFrame.WWHHelp.fGetFrameReference("WWHPanelNavigationFrame"));
      SearchForm = VarPanelNavigationFrame.document.forms["WWHSearchForm"];
      WWHFrame.SearchSupportNet(CurrentIHUBHandle,SearchForm.elements["WWHSearchWordsText"].value);
      return false;
   }
   WWHFrame.LoadedFirstSearchEntry = false;
   WWHFrame.SearchPointers = new Array;;
   WWHFrame.CurrentSearchHit = 0;
   if (WWHFrame.ForceSearchSubmit)
   {
      this.mbSearching = true;
      WWHFrame.ForceSearchSubmit = false;
   }
   if (WWHFrame.WWHHandler.fIsReady())
   {
      VarPanelNavigationFrame = eval(WWHFrame.WWHHelp.fGetFrameReference("WWHPanelNavigationFrame"));
      SearchForm = VarPanelNavigationFrame.document.forms["WWHSearchForm"];
      // Update search words
      //
      NewSearchWords = SearchForm.elements["WWHSearchWordsText"].value.replace("\"","").replace("\"","").replace("\%27","").replace("\%27","").replace("\'","").replace("\'","");
      this.mSavedSearchWords = NewSearchWords.replace(/^\s*/,"").replace(/\s*$/,"").replace(/ +/g," ").replace(/ +/g," ");
      this.mbSearching = true;
      WWHFrame.MGCSearchWords = this.mSavedSearchWords;
     // Perform search if something changed
     //
     if (this.mbSearching)
     {
        if (this.mSavedSearchWords.length > 0)
        {
           // Clear previous results
           //
           for (MaxIndex = this.mBookMatchesList.length, Index = 0 ; Index < MaxIndex ; Index++)
           {
              this.mBookMatchesList[Index].fClear();
           }
           this.mCombinedResults.fClear();

           // Perform search
           //
           this.fSetSearchWords(WWHFrame.MGCSearchWords);
           WWHFrame.LastSearchWords = this.mSavedSearchWords;
           WWHFrame.WWHJavaScript.mPanels.fClearScrollPosition();

           // Submit will cause navigation area to reload which will trigger the view pane
           // to reload and perform the search.
           //
        }
     }
  }
  return this.mbSearching;
}

//MGCSD Added function to force submission of search form.
// The standard Submit function won't search if the document
// is not done loading.

function  MGC_ForceSubmit()
{
   var  VarPanelNavigationFrame;
   var  SearchForm;
   var  MaxIndex;
   var  Index;
   WWHFrame.MGCNavigate.MGCTabs.MGC_InsertEnabledContentsTab();
   WWHFrame.MGCNavigate.MGCTabs.MGC_InsertEnabledMyTopicsTab();
   if (WWHFrame.NoSearchResults)
   {
     WWHFrame.MGCContent.MGCDocContent.location.replace("../../../../_a_search_tips/title1.html");
     WWHFrame.NoSearchResults = false;
   }
   WWHFrame.SearchPointers = new Array;;
   WWHFrame.CurrentSearchHit = 0;

   /////  this.mbSearching = true;

   VarPanelNavigationFrame = eval(WWHFrame.WWHHelp.fGetFrameReference("WWHPanelNavigationFrame"));
   SearchForm = VarPanelNavigationFrame.document.forms["WWHSearchForm"];

   if ( typeof(SearchForm) != "undefined" )
   {
      // Update search words
      //
      this.mSavedSearchWords = SearchForm.elements["WWHSearchWordsText"].value.replace(/^\s*/,"").replace(/\s*$/,"").replace(/ +/g," ").replace(/ +/g," ");
      this.mbSearching = true;

      // Update search scope
      //
      if (WWHFrame.WWHHelp.mBooks.mBookList.length > 1)
      {
         //MGCRK removed search form list
         //MGCRK Set/Reset Search Scale here
         //      this.mSavedSearchScope = SearchForm.elements["WWHSearchScope"].selectedIndex;
      }

      if (this.mSavedSearchWords.length > 0)
      {
         // Clear previous results
         //
         for (MaxIndex = this.mBookMatchesList.length, Index = 0 ; Index < MaxIndex ; Index++)
         {
            this.mBookMatchesList[Index].fClear();
         }
         this.mCombinedResults.fClear();

         // Perform search
         //
         this.fSetSearchWords(this.mSavedSearchWords);
         WWHFrame.LastSearchWords = this.mSavedSearchWords;
         // ForceSubmit will cause navigation area to reload which will trigger the view pane
         // to reload and perform the search.
         //
      }
   }
   return this.mbSearching;
}

function  WWHSearch_SetSearchWords(ParamSearchWordsString)
{
  // Workaround for stupid Netscape 4.x bug
  //
  var  StringWithSpace = "x x";
  var  SearchWordList;
  var  MaxIndex;
  var  Index;
  var  SearchWord;
  var  SearchRegExpPattern;

  // Clear search words
  //
  this.mSearchWordList.length = 0;
  this.mSearchWordRegExpList.length = 0;

  // Add search words to hash
  //
  var SWords = ParamSearchWordsString.replace(/^\s*/,"").replace(/\s*$/,"").replace(/ +/g," ").replace(/ +/g," ");
//  alert("Init Words are x" + SWords + "y");
  SearchWordList = SWords.split(StringWithSpace.substring(1, 2));
//  alert("Words are x" + SearchWordList + "y");
  for (MaxIndex = SearchWordList.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
     // Skip 0 length words
     //
     if (SearchWordList[Index].length > 0)
     {
        // Add to search words hash
        //
        SearchWord = SearchWordList[Index].toLowerCase();
        SearchRegExpPattern = WWHStringUtilities_WordToRegExpPattern(SearchWord);

        this.mSearchWordList[this.mSearchWordList.length] = SearchWord;
        this.mSearchWordRegExpList[this.mSearchWordRegExpList.length] = new RegExp(SearchRegExpPattern, "i");
     }
  }
}

function  WWHSearch_CheckForMatch(ParamSearchFunc)
{
  var  Count;
  var  MaxIndex;
  var  Index;
  var  BookSearchInfoEntry;
  var  BookMatchesListEntry;
  var  SearchPattern;


  Count = 0;
  for (MaxIndex = this.mSearchWordList.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
 BookSearchInfoEntry = this.mBookSearchInfoList[this.mBookIndex]

 if (this.mBookSearchInfoList[this.mBookIndex].fValidSearchWord(this.mSearchWordList[Index]))
 {
//alert("Search word is " + this.mSearchWordList[Index] + "\nBook is " + this.mBookSearchInfoList[this.mBookIndex] );
   BookMatchesListEntry = this.mBookMatchesList[this.mBookIndex];

   BookMatchesListEntry.fSetMatchedWordIndex(Count);

   SearchPattern = this.mSearchWordRegExpList[Index];
   SearchPattern.t = SearchPattern.test;

   ParamSearchFunc(SearchPattern, BookMatchesListEntry);

   Count++;
 }
  }
}

function  WWHSearch_SearchComplete()
{
  // Combine results for display
  //
  this.fCombineResults();

  // Sort results based on single or multi-book display
  //
  if ((WWHFrame.WWHJavaScript.mSettings.mSearch.mbResultsByBook) ||
   ((WWHFrame.WWHHelp.mBooks.mBookList.length == 1) ||
    ((this.mSavedSearchScope > 0) &&
     (this.mSearchScopeInfo.mEntries[this.mSavedSearchScope - 1].mStartBookIndex == this.mSearchScopeInfo.mEntries[this.mSavedSearchScope - 1].mEndBookIndex))))
  {
 this.mCombinedResults.fSortByBookIndex();
  }
  else
  {
 this.mCombinedResults.fSortByScore();
  }
  
  //MGCSD Clear search words from stored URL, if necessary
  WWHFrame.WWHHelp.fClearURLSearchWords();
}

function  WWHSearch_CombineResults()
{
  var  MaxBookIndex;
  var  BookIndex;
  var  BookMatches;
  var  BookListEntry;
  var  FileID;
  var  FileIndex;


  this.mCombinedResults.fClear();
  for (MaxBookIndex = this.mBookMatchesList.length, BookIndex = 0 ; BookIndex < MaxBookIndex ; BookIndex++)
  {
 BookMatches = this.mBookMatchesList[BookIndex];
 BookListEntry = WWHFrame.WWHHelp.mBooks.mBookList[BookIndex];

 // Add results
 //
 BookMatches.fJoinFileScores();
 for (FileID in BookMatches.mFileScores)
 {
   FileIndex = parseInt(FileID.substring(1, FileID.length));

   this.mCombinedResults.fAddEntry(BookIndex, FileIndex, BookMatches.mFileScores[FileID], BookListEntry.mFiles.fFileIndexToTitle(FileIndex));
 }
  }
}

function  WWHSearch_ShowEntry(ParamIndex)
{
  this.mCombinedResults.fShowEntry(ParamIndex);
}

function  WWHSearchScope_Entry_Object(ParamLevel,
                                   ParamTitle,
                                   ParamBookIndex)
{
  this.mLevel          = ParamLevel;
  this.mTitle          = ParamTitle;
  this.mStartBookIndex = ParamBookIndex;
  this.mEndBookIndex   = ParamBookIndex;
}

function  WWHSearchScope_Object()
{
  this.mEntries = new Array();
  this.mGroupStack = new Array();
  this.mBookIndex = 0;

  this.fAddScopeEntries = WWHSearchScope_AddScopeEntries;

  // Set scope entries
  //
  this.fAddScopeEntries(WWHFrame.WWHHelp.mBookGroups);
}

function  WWHSearchScope_AddScopeEntries(ParamGroup)
{
  var  MaxIndex;
  var  Index;
  var  MaxGroupStackIndex;
  var  GroupStackIndex;
  var  ScopeEntry;


  for (MaxIndex = ParamGroup.mChildren.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
 if (ParamGroup.mChildren[Index].mbGrouping)
 {
   // Add an entry
   //
   ScopeEntry = new WWHSearchScope_Entry_Object(this.mGroupStack.length, ParamGroup.mChildren[Index].mTitle, -1);
   this.mEntries[this.mEntries.length] = ScopeEntry;

   // Push this entry onto the group stack
   //
   this.mGroupStack[this.mGroupStack.length] = ScopeEntry;

   // Process group entries
   //
   this.fAddScopeEntries(ParamGroup.mChildren[Index]);

   // Pop this entry off the group stack
   //
   this.mGroupStack.length -= 1;
 }
 else
 {
   // Add an entry
   //
   this.mEntries[this.mEntries.length] = new WWHSearchScope_Entry_Object(this.mGroupStack.length, WWHFrame.WWHHelp.mBooks.mBookList[this.mBookIndex].mTitle, this.mBookIndex);

   // Process all entries in the group stack, updating start/end book indicies
   //
   for (MaxGroupStackIndex = this.mGroupStack.length, GroupStackIndex = 0 ; GroupStackIndex < MaxGroupStackIndex ; GroupStackIndex++)
   {
     ScopeEntry = this.mGroupStack[GroupStackIndex];

     // Update start
     //
     if (ScopeEntry.mStartBookIndex == -1)
     {
       ScopeEntry.mStartBookIndex = this.mBookIndex;
     }

     // Update end
     //
     ScopeEntry.mEndBookIndex = this.mBookIndex;
   }

   // Increment book index
   //
   this.mBookIndex += 1;
 }
  }
}

function  WWHBookSearchInfo_Object(ParamSearchFileCount,
                                ParamMinimumWordLength)
{
  this.mSearchFileCount   = ParamSearchFileCount;
  this.mMinimumWordLength = ParamMinimumWordLength;
  this.mSkipWords         = new WWHBookSearchInfo_SkipWords_Object();

  this.fAddSkipWord     = WWHBookSearchInfo_AddSkipWord;
  this.fA               = WWHBookSearchInfo_AddSkipWord;
  this.fValidSearchWord = WWHBookSearchInfo_ValidSearchWord;
}

function  WWHBookSearchInfo_AddSkipWord(ParamSkipWord)
{
  if (ParamSkipWord.length > 0)
  {
 this.mSkipWords[ParamSkipWord + "~"] = 1;
  }
}

function  WWHBookSearchInfo_ValidSearchWord(ParamSearchWord)
{
  var  bValid = true;


  if ((ParamSearchWord.length < this.mMinimumWordLength) ||
   (typeof(this.mSkipWords[ParamSearchWord + "~"]) == "number"))
  {
 bValid = false;
  }

  return bValid;
}

function  WWHBookSearchInfo_SkipWords_Object()
{
}

function  WWHSearchBookMatches_Object()
{
  this.mFirstMatchedWordIndex = -1;
  this.mMatchedWordIndex      = -1;
  this.mWordFileScores        = new Array();
  this.mFileScores            = new WWHSearchBookMatches_FileScores_Object();

  this.fClear               = WWHSearchBookMatches_Clear;
  this.fSetMatchedWordIndex = WWHSearchBookMatches_SetMatchedWordIndex;
  this.fAddMatches          = WWHSearchBookMatches_AddMatches;
  this.f                    = WWHSearchBookMatches_AddMatches;  // For smaller search files
  this.fJoinFileScores      = WWHSearchBookMatches_JoinFileScores;
}

function  WWHSearchBookMatches_Clear()
{
  this.mFirstMatchedWordIndex = -1;
  this.mMatchedWordIndex      = -1;
  this.mWordFileScores.length = 0;
  this.mFileScores            = new WWHSearchBookMatches_FileScores_Object();
}

function  WWHSearchBookMatches_SetMatchedWordIndex(ParamMatchedWordIndex)
{
  this.mMatchedWordIndex = ParamMatchedWordIndex;
  if (ParamMatchedWordIndex == this.mWordFileScores.length)
  {
 this.mWordFileScores[this.mWordFileScores.length] = new WWHSearchBookMatches_FileScores_Object();
  }
}

function  WWHSearchBookMatches_AddMatches(ParamMatchString)
{
  var  MatchList = null;
  var  WordFileScoresEntry;
  var  MaxIndex;
  var  Index;
  var  FileID;
  var  Score;


  if (typeof(ParamMatchString) != "undefined")
  {
 MatchList = ParamMatchString.split(",");
  }

  if ((MatchList != null) &&
   (MatchList.length > 0))
  {
 WordFileScoresEntry = this.mWordFileScores[this.mMatchedWordIndex];

 // Add all entries to word file score entry
 //
 for (MaxIndex = MatchList.length, Index = 0 ; Index < MaxIndex ; Index += 2)
 {
   FileID = "i" + MatchList[Index];
   Score  = MatchList[Index + 1];

   WordFileScoresEntry[FileID] = parseInt(Score);
 }
  }
}

function  WWHSearchBookMatches_JoinFileScores()
{
  var  MaxIndex;
  var  Index;
  var  WordFileScoresEntry;


  this.mFileScores = new WWHSearchBookMatches_FileScores_Object();
  for (MaxIndex = this.mWordFileScores.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
 WordFileScoresEntry = this.mWordFileScores[Index];

 if (Index == 0)
 {
   // Add all entries if first entry
   //
   this.mFileScores = WordFileScoresEntry;
 }
 else
 {
   // Remove all entries not found in results set
   //
   for (FileID in this.mFileScores)
   {
     if (typeof(WordFileScoresEntry[FileID]) == "number")
     {
       this.mFileScores[FileID] += WordFileScoresEntry[FileID];
     }
     else
     {
       delete this.mFileScores[FileID];
     }
   }
 }
  }
}

function  WWHSearchBookMatches_FileScores_Object()
{
}

function  WWHSearchResults_Object()
{
  this.mSortedBy     = null;
  this.mEntries      = new Array();
  this.mMaxScore     = 0;
  this.mDisplayIndex = 0;
  this.mByBookDetect = -1;
  this.mHTMLSegment  = new WWHStringBuffer_Object();
  this.mEventString  = WWHPopup_EventString();

  this.fClear           = WWHSearchResults_Clear;
  this.fAddEntry        = WWHSearchResults_AddEntry;
  this.fSortByScore     = WWHSearchResults_SortByScore;
  this.fSortByBookIndex = WWHSearchResults_SortByBookIndex;
  this.fDisplayReset    = WWHSearchResults_DisplayReset;
  this.fDisplayAdvance  = WWHSearchResults_DisplayAdvance;
  this.fGetPopupAction  = WWHSearchResults_GetPopupAction;
  this.fShowEntry       = WWHSearchResults_ShowEntry;
}

function  WWHSearchResults_Clear()
{
  this.mSortedBy       = null;
  this.mEntries.length = 0;
  this.mMaxScore       = 0;
}

function  WWHSearchResults_AddEntry(ParamBookIndex,
                                 ParamFileIndex,
                                 ParamScore,
                                 ParamTitle)
{
  // Add a new entry
  //
  this.mEntries[this.mEntries.length] = new WWHSearchResultsEntry_Object(ParamBookIndex,
                                                                      ParamFileIndex,
                                                                      ParamScore,
                                                                      ParamTitle);

  // Bump mMaxScore if necessary
  //
  if (ParamScore > this.mMaxScore)
  {
 this.mMaxScore = ParamScore;
  }
}

function  WWHSearchResults_SortByScore()
{
  this.mSortedBy = 1;  // By Score

  if (this.mEntries.length > 0)
  {
 this.mEntries = this.mEntries.sort(WWHSearchResultsEntry_ByScoreByBookIndexByTitleFileIndexURL);
  }
}

function  WWHSearchResults_SortByBookIndex()
{
  this.mSortedBy = 2;  // By BookIndex

  if (this.mEntries.length > 0)
  {
 this.mEntries = this.mEntries.sort(WWHSearchResultsEntry_ByBookIndexByScoreByTitleFileIndexURL);
  }
}

function  WWHSearchResults_DisplayReset(bParamDisplayBookTitles)
{
  this.mDisplayIndex = 0;
  this.mByBookDetect = -1;

  if ( ! bParamDisplayBookTitles)
  {
 this.mByBookDetect = -2;
  }
}

//MGCRK new Advanced layout for search results
//
//
function  WWHSearchResults_DisplayAdvance()
{
  var  bSegmentCreated = false;
  var  Settings = WWHFrame.WWHJavaScript.mSettings.mSearch;
  var  HTML;
  var  MaxHTMLSegmentSize;
  var  BookList;
  var  MaxIndex;
  var  Index;
  var  Entry;
  var  VarAccessibilityTitle = "";
  var  VarPercent;
  var SortList = new Array;
  var SAIndex = 0;
////  WWHFrame.SearchPointers = "";
////  WWHFrame.CurrentSearchHit = -1;
//  ShowSearchBooks = WWHFrame.ShowSearchBooks;
  MinPercent = WWHFrame.MinSearchPercent;

  // Insure that there is something to display
  //
  if ((this.mSortedBy != null) &&
   (this.mEntries.length > 0))
  {
 MaxHTMLSegmentSize = WWHFrame.WWHJavaScript.mMaxHTMLSegmentSize;
 this.mHTMLSegment.fReset();
 BookList = WWHFrame.WWHHelp.mBooks.mBookList;

 // If this is the first entry, display the headers and open the list
 //
 if (this.mDisplayIndex == 0)
 {
   HTML = "";

   //MGCRK Search Options menu
   // Display column headers
   //
   if ((BookList.length > 1) &&  // More than one book exists
       (this.mSortedBy == 1))    // By Score
   {
      //MGCRK - Disable display of Rank/Book
      //MGCRK - New search results title
   }
   HTML += "<table border=0 cellpadding=0 cellspacing=0 width=\"100\%\">\n";
   this.mHTMLSegment.fAppend(HTML);
 }

 // Display result entries
 //
 MaxIndex = this.mEntries.length;
//    MaxIndex = MaxReturns;
 Index = this.mDisplayIndex;
 //
 //
 //MGCRK - get the first search result and display it
 //
 WWHFrame.MGCDisplayFirstResult = true;
 if (WWHFrame.MGCDisplayFirstResult)
 {
    if ( (!WWHFrame.LoadedFirstSearchEntry) && (WWHFrame.ShowSearchBooks == "NO") )
    {
//   alert("Displaying first result for TOPICS");
//
       WWHFrame.LoadedFirstSearchEntry = true;
       WWHFrame.WWHSearch.fShowEntry(0);
    }
 }
 while ((this.mHTMLSegment.fSize() < MaxHTMLSegmentSize) &&
        (Index < MaxIndex))
 {
   HTML = "";

   Entry = this.mEntries[Index];
   // Display Book
   //
   if ((BookList.length > 1) &&  // More than one book exists
       (this.mSortedBy == 2))    // By BookIndex
   {
     if (this.mByBookDetect == -2)
     {
       // Do not display book titles
       //
     }
     else if (this.mByBookDetect != Entry.mBookIndex)
     {
       // Close list for previous book
       //
       if (Index > 0)
       {
//            HTML += "</ol>\n";
       }

//          HTML += "<p><nobr>&nbsp;</nobr></p>";
//          HTML += "<p class=\"BookTitle\"><nobr>" + BookList[Entry.mBookIndex].mTitle + "</nobr></p>";

       this.mByBookDetect = Entry.mBookIndex;

       // Open new list for next book
       //
//xx          HTML += "<ol>\n";
     }
   }

   // Accessibility support
   //
   if (WWHFrame.WWHHelp.mbAccessible)
   {
     VarAccessibilityTitle = "";

     // Rank
     //
     if (Settings.mbShowRank)
     {
       VarPercent = Math.floor((Entry.mScore / this.mMaxScore) * 100 );

       // Some browsers do not allow value attributes to be 0
       //
       if (VarPercent < 1)
       {
         VarPercent = 1;
       }

       VarAccessibilityTitle += WWHStringUtilities_EscapeHTML(WWHFrame.WWHJavaScript.mMessages.mSearchRankLabel + " " + VarPercent + ", ");
     }

     // Title
     //
     VarAccessibilityTitle += WWHStringUtilities_EscapeHTML(WWHFrame.WWHJavaScript.mMessages.mSearchTitleLabel + " " + Entry.mTitle);

     // Book
     //
     if (BookList.length > 1)  // More than one book exists
     {
       VarAccessibilityTitle += WWHStringUtilities_EscapeHTML(WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " " + WWHFrame.WWHJavaScript.mMessages.mSearchBookLabel + " " + BookList[Entry.mBookIndex].mTitle);
     }

     VarAccessibilityTitle = " title=\"" + VarAccessibilityTitle + "\"";
   }

   // Display Rank
   //
   if (Settings.mbShowRank)
   {
     VarPercent = Math.floor((Entry.mScore / this.mMaxScore) * 100);

     // Some browsers do not allow value attributes to be 0
     //
     if (VarPercent <= 1)
     {
       VarPercent = 2;
     }
//        HTML += "<tr><td width=25><p class=\"SearchEntryP\">" + VarPercent + "</td><td><p class=\"SearchEntry\"><a href=\"javascript:fC(" + Index + ")\;\"" + "title=\"" + BookList[Entry.mBookIndex].mTitle + "\">" + Entry.mTitle + "</a></td></tr>";
//        HTML += "<li value=\"" + VarPercent + "\">";
   }
   else
   {
//MGCRK Change to <p> to save indentation.  (need new ptag)
//        HTML += "<li>";
//        HTML += "<p class=\"SearchEntry\">";
   }

   // Display Title
   //
   //MGCRK - add book title as tooltip (title=xxx)
//      WWHFrame.document.write("Popup action is: " + this.fGetPopupAction(Index));
//      HTML += "<a href=\"javascript:fC(" + Index + ");\"" + this.fGetPopupAction(Index) + VarAccessibilityTitle + ">";
     if ( VarPercent >= MinPercent )
     {
///////////           HTML += "<tr><td width=32 valign=\"top\"><p class=\"SearchEntryP\">" + VarPercent + "</p></td><td valign=\"top\"width=10><p class=\"SearchEntryP\">&nbsp&nbsp;</p></td><td valign=\"top\"><p class=\"SearchEntry\"><a href=\"javascript:fC(" + Index + ")\;\"" + "title=\"" + BookList[Entry.mBookIndex].mTitle + "\">" + Entry.mTitle + "</a></p></td></tr>\n";
  Entry = this.mEntries[SAIndex];
  URL = WWHFrame.WWHHelp.fGetBookIndexFileIndexURL(Entry.mBookIndex, Entry.mFileIndex, null);
  URLArray = URL.split("/");
  File = URLArray[URLArray.length-1];
  Context = URLArray[URLArray.length-2];
  TopicLoc = Context + "/" + File;
//alert("Context is " + Context);


        SortList[SAIndex] = ["<br>" + BookList[Entry.mBookIndex].mTitle, Entry.mTitle, Index, VarPercent, TopicLoc];
        SAIndex++;
     }



   // Display Book
   //
   if ((BookList.length > 1) &&  // More than one book exists
       (this.mSortedBy == 1))    // By Score
   {
   //MGCRK - Don't display book title here - it's in the popup
//        HTML += ", " + BookList[Entry.mBookIndex].mTitle;
   }

//MGCRK Change to <p> to save indentation.  (need new ptag)
//      HTML += "</p>\n";
//      HTML += "</li>\n";

   this.mHTMLSegment.fAppend(HTML);

   Index++;
 }

 // Record current display index so we can pick up where we left off
 //
 this.mDisplayIndex = Index;
 if (this.mHTMLSegment.fSize() > 0)
 {
   bSegmentCreated = true;
 }

 // If this is the last entry, close the list
 //
 if (this.mDisplayIndex == this.mEntries.length)
 {
//      this.mHTMLSegment.fAppend("</ol>\n");
 }
  }
  Highlight = "<font style='color:blue; background-color:yellow;'>" + WWHFrame.LastSearchWords + "</font>";
  LevelGraphic =  "<img src=\"../../common/images/SearchL.gif\" border=\"0\"/>";
  if (WWHFrame.ShowSearchBooks == "NO")
  {
     if (Settings.mbShowRank)
////     alert("Sorting search results by topic");
  for (MaxIndex = SortList.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
//     if ((SortList[Index][3] > MinPercent) || (SortList[Index][3] == MinPercent) )
     if (SortList[Index][3] > MinPercent) 
     {
//yyyyyyyyyyyyyy
         TopicTitle = Entry.mTitle;
        PText = "";
        Title = "";
        Popup = " title=\"" + SortList[Index][0].replace("<br>","") +"\"";
////        WWHFrame.ISVerbose = false;
        if (WWHFrame.ISVerbose)
        {
        File = SortList[Index][4].replace(/.*\//,"");
        Context = SortList[Index][4].replace(/\/.*/,"");

//alert("Context is " + Context + "\nFile is " + File);
               CurrentTopicTitle = SortList[Index][1];
               PTextALL = GetPTextID(Context,File);
               PText = "<br>" + PTextALL.replace(CurrentTopicTitle + "<br>","") + " ...";

//           PTextID = GetPTextID(SortList[Index][4]);
//           PTextALL = WWHFrame.mParatext[PTextID][1];
//           PTextBits = PTextALL.split(":yPSePx:");
//           if (PTextBits[0] == SortList[Index][1])
//           {
//              PText = "<br>" + PTextBits[1] + "<br>" + PTextBits[2];
//           }
//           else
//           {
//              PText = "<br>" + PTextBits[0] + "<br>" + PTextBits[1] + "<br>" + PTextBits[2];
//           }
           //  Add highlighting of search term(s) - WWHFrame.LastSearchWords
//           Highlight = "<font style='color:blue; background-color:yellow;'>" + WWHFrame.LastSearchWords + "</font>";
/////////////////////           PText = PText.replace(WWHFrame.LastSearchWords,Highlight);
//           PText = AddHighlight(PText);

           Title = SortList[Index][0].replace("<br>","");
           if (Title[Title.length-1] == " ") { Title[Title.length-1] = ""; }
           Title = " <i><span style=\"color: #0D990D;\">" + Title + "</i></span>";
           Popup = "";
        }
        WWHFrame.SearchPointers.push(SortList[Index][2]);
        pointer = WWHFrame.SearchPointers.length-1;
        Link = "<a href=\"javascript:fC(" + SortList[Index][2] + "," + pointer + ")\;\"" + Popup + "\">";
        LevelGraphic =  "<img src=\"../../common/images/SearchL.gif\" border=\"0\"/>";
        if (SortList[Index][3] > Settings.mbLowLevel) { LevelGraphic =  "<img src=\"../../common/images/SearchM.gif\" border=\"0\"/>"; }
        if (SortList[Index][3] > Settings.mbMediumLevel) { LevelGraphic = "<img src=\"../../common/images/SearchH.gif\" border=\"0\"/>"; }
///        HTML += "<tr><td valign=\"top\" width=25><p class=\"SearchEntryP\">" + LevelGraphic + "</td><td><p class=\"SearchEntry\">" + Link + SortList[Index][1] + "</a>" + PText + Title + "</td></tr>";
        CurrentSEntry = "<tr><td valign=\"top\" width=25><p class=\"SearchEntryP\">" + LevelGraphic + "</td><td><p class=\"SearchEntry\">" + Link + SortList[Index][1] + "</a>" + PText + Title + "</td></tr>";
        if (WWHFrame.ISVerbose)
        {
           HTML += AddHighlight(CurrentSEntry);
        }
        else
        {
           HTML += CurrentSEntry;
        }
//        WWHFrame.SearchPointers.push(SortList[Index][2]);
     }
  }
  }
  else
  {
  HTML += MGCSortResultsByBook(SortList);
  }
  HTML += "</table>";
  this.mHTMLSegment.fAppend(HTML)
//  this.mHTMLSegment.fAppend(SortList)
  return bSegmentCreated;
}

function AddHighlightOLDDDD(Text)
{
//alert("Adding highlight");
  var HighlightBegin = "<font style='color:blue; background-color:yellow;'>";
  var SearchWordArray = WWHFrame.LastSearchWords.split(" ");
  for (HIndex = SearchWordArray.length, Hx = 0 ; Hx < HIndex ; Hx++)
  {
     ReplaceString = "\/" + SearchWordArray[Hx] + "\/i";
     NewString = "BeGiNHlT" + SearchWordArray[Hx] + "EHlT";
alert("Replacing " + ReplaceString + " with " + "BeGiNHlT"+SearchWordArray[Hx]+"EHlT");
     Text = Text.replace(SearchWordArray[Hx],NewString);
  }
  for (HIndex = SearchWordArray.length, Hx = 0 ; Hx < HIndex ; Hx++)
  {
     Text = Text.replace("BeGiNHlT",HighlightBegin);
     Text = Text.replace("EHlT","</font>");
  }
  return Text;
}










function MGCSHighlight(uBodyText, searchTerm) 
{

//   HighlightBegin = "<font style='color:blue; background-color:yellow;'>";
//   HighlightEnd = "</font>";
   HighlightEnd = "</span>";
  
   // locate the search term in the body of the page and add highlight span tags.
   // ignore all HTML tags
   var newText = "";
   var i = -1;
   var HCount = 1;
   var Term = searchTerm.toLowerCase().replace("\*","").replace("\*","").replace("\*","");
   var lcaseTerm = Term;
   var lcaseBodyText = uBodyText.toLowerCase();
   while (uBodyText.length > 0) {
     i = lcaseBodyText.indexOf(lcaseTerm, i+1);
     if (i < 0) {
       newText += uBodyText;
       uBodyText = "";
     } else {
     //<span class="cLink">
//       if (HCount == 1) { Anchor = "<a name\=SString1" + "><\/a>"; } else { Anchor = ""; }
       HighlightBegin = "<span style=\"background-color:yellow;\">";
       // skip anything inside an HTML tag
       if (uBodyText.lastIndexOf(">", i) >= uBodyText.lastIndexOf("<", i)) {
         // don't highlight content is inside a <script> block
         if (lcaseBodyText.lastIndexOf("/script>", i) >= lcaseBodyText.lastIndexOf("<script", i)) {
//           newText += uBodyText.substring(0, i) + HighlightBegin + uBodyText.substr(i, searchTerm.length) + HighlightEnd + Anchor;
           newText += uBodyText.substring(0, i) + HighlightBegin + uBodyText.substr(i, lcaseTerm.length) + HighlightEnd;
           HCount ++;
           uBodyText = uBodyText.substr(i + lcaseTerm.length);
           lcaseBodyText = uBodyText.toLowerCase();
           i = -1;
         }
       }
     }
   }
   WWHFrame.PageHits = HCount - 1;
   return newText;
}


function AddHighlight(Text)
{
   searchArray = WWHFrame.LastSearchWords.split(" ");
   for (var i = 0; i < searchArray.length; i++)
   {
      Text = MGCSHighlight(Text, searchArray[i]);
   }
   return Text;
}
































function  WWHSearchResults_GetPopupAction(ParamEntryIndex)
{
  var  PopupAction = "";


  if (WWHFrame.WWHJavaScript.mSettings.mHoverText.mbEnabled)
  {
 PopupAction += " onMouseOver=\"fS('" + ParamEntryIndex + "', " + this.mEventString + ");\"";
 PopupAction += " onMouseOut=\"fH();\"";
  }

  return PopupAction;
}

function  WWHSearchResults_ShowEntry(ParamIndex)
{
  var  Entry;
  var  URL;
  WWHFrame.HighlightSearchTerms = true;


  // Update highlight words
  //
//  WWHFrame.WWHHighlightWords.fSetWordList(WWHFrame.WWHSearch.mSavedSearchWords);

  // Display document
  //
  Entry = this.mEntries[ParamIndex];
  URL = WWHFrame.WWHHelp.fGetBookIndexFileIndexURL(Entry.mBookIndex, Entry.mFileIndex, null);
  LinkFile = URL.split("/");
  LinkFile = LinkFile[LinkFile.length-1];
  CurrentFile = WWHFrame.MGCContent.MGCDocContent.location.toString();
  CurrentFile = CurrentFile.split("/");
  CurrentFile = CurrentFile[CurrentFile.length-1].replace(/\#.*/,"");
//  alert("Link file is \n" + LinkFile + "Current file is \n" + CurrentFile);
//  if (LinkFile == CurrentFile) { WWHFrame.MGCContent.MGCDocContent.location.replace(URL); }
  if (LinkFile == CurrentFile) { WWHFrame.MGCContent.MGCDocContent.location.replace(URL + "#SString1"); }
  WWHFrame.MGCHighlightSearchTerms(WWHFrame.WWHSearch.mSavedSearchWords,false);
  WWHFrame.CurrentSearchParam = ParamIndex;
  WWHFrame.WWHHelp.fSetDocumentHREF(URL + "#SString1", false);
}

function  WWHSearchResultsEntry_Object(ParamBookIndex,
                                    ParamFileIndex,
                                    ParamScore,
                                    ParamTitle)
{
  this.mBookIndex = ParamBookIndex;
  this.mFileIndex = ParamFileIndex;
  this.mScore     = ParamScore;
  this.mTitle     = ParamTitle;
}

function  WWHSearchResultsEntry_ByScoreByBookIndexByTitleFileIndexURL(ParamAlphaEntry,
                                                                   ParamBetaEntry)
{
  var  Result;


  Result = WWHSearchResultsEntry_CompareByScore(ParamAlphaEntry, ParamBetaEntry);
  if (Result == 0)
  {
 Result = WWHSearchResultsEntry_CompareByBookIndex(ParamAlphaEntry, ParamBetaEntry);
  }
  if (Result == 0)
  {
 Result = WWHSearchResultsEntry_CompareByTitleFileIndexURL(ParamAlphaEntry, ParamBetaEntry);
  }

  return Result;
}

function  WWHSearchResultsEntry_ByBookIndexByScoreByTitleFileIndexURL(ParamAlphaEntry,
                                                                   ParamBetaEntry)
{
  var  Result;


  Result = WWHSearchResultsEntry_CompareByBookIndex(ParamAlphaEntry, ParamBetaEntry);
  if (Result == 0)
  {
 Result = WWHSearchResultsEntry_CompareByScore(ParamAlphaEntry, ParamBetaEntry);
  }
  if (Result == 0)
  {
 Result = WWHSearchResultsEntry_CompareByTitleFileIndexURL(ParamAlphaEntry, ParamBetaEntry);
  }

  return Result;
}

function  WWHSearchResultsEntry_CompareByScore(ParamAlphaEntry,
                                            ParamBetaEntry)
{
  var  Result = 0;


  // Sort by score
  //
  if (ParamAlphaEntry.mScore < ParamBetaEntry.mScore)
  {
 Result = 1;
  }
  else if (ParamAlphaEntry.mScore > ParamBetaEntry.mScore)
  {
 Result = -1;
  }

  return Result;
}

function  WWHSearchResultsEntry_CompareByBookIndex(ParamAlphaEntry,
                                                ParamBetaEntry)
{
  var  Result = 0;


  if (ParamAlphaEntry.mBookIndex < ParamBetaEntry.mBookIndex)
  {
 Result = -1;
  }
  else if (ParamAlphaEntry.mBookIndex > ParamBetaEntry.mBookIndex)
  {
 Result = 1;
  }

  return Result;
}

function  WWHSearchResultsEntry_CompareByTitleFileIndexURL(ParamAlphaEntry,
                                                        ParamBetaEntry)
{
  var  Result = 0;
  var  BookList;
  var  AlphaBookEntry;
  var  BetaBookEntry;
  var  AlphaURL;
  var  BetaURL;


  // Sort by Title
  //
  if (ParamAlphaEntry.mTitle < ParamBetaEntry.mTitle)
  {
 Result = -1;
  }
  else if (ParamAlphaEntry.mTitle > ParamBetaEntry.mTitle)
  {
 Result = 1;
  }
  // Sort by FileIndex
  //
  else if (ParamAlphaEntry.mFileIndex < ParamBetaEntry.mFileIndex)
  {
 Result = -1;
  }
  else if (ParamAlphaEntry.mFileIndex > ParamBetaEntry.mFileIndex)
  {
 Result = 1;
  }
  // Sort by URL
  //
  else
  {
 BookList = WWHFrame.WWHHelp.mBooks.mBookList;

 AlphaBookEntry = BookList[ParamAlphaEntry.mBookIndex];
 BetaBookEntry  = BookList[ParamBetaEntry.mBookIndex];

 AlphaURL = WWHFrame.WWHHelp.mBaseURL + AlphaBookEntry.mDirectory + AlphaBookEntry.mFiles.fFileIndexToHREF(ParamAlphaEntry.mFileIndex);
 BetaURL  = WWHFrame.WWHHelp.mBaseURL + BetaBookEntry.mDirectory + BetaBookEntry.mFiles.fFileIndexToHREF(ParamBetaEntry.mFileIndex);

 if (AlphaURL < BetaURL)
 {
   Result = -1;
 }
 else if (AlphaURL > BetaURL)
 {
   Result = 1;
 }
  }

  return Result;
}
// MGCRK - new function to switch to the global Search
// not needed when we are already in global search

function GotoGlobalSearch()
{
var page = new String(WWHFrame.MGCContent.MGCDocContent.location);
var pos = page.lastIndexOf("/") + 1;
var File = page.substr(pos);
var ReturnDoc = WWHFrame.DocHandle;
window.open("../../../../../wwhelp.htm\?href=" + ReturnDoc + "/" + File);
}

// MGCRK - new function to switch to the local Search
//

function GotoLocalSearch()
{
var page = new String(WWHFrame.MGCContent.MGCDocContent.location);
var pos = page.lastIndexOf("/") + 1;
var File = page.substr(pos);
var ReturnDoc = WWHFrame.MGCContent.MGCDocContent.DocHandle;
//MGCSD Add current search terms to URL search parameter
var SearchString = WWHFrame.WWHSearch.mSavedSearchWords;
if ( SearchString != "" ) {
     SearchString = "\&query\=" + SearchString;
}
DocLocation = WWHFrame.MGCContent.MGCDocContent.location;
WWHFrame.InGlobalSearch = "false";
WWHFrame.location = "../../../../" + ReturnDoc + "/wwhelp.htm\?href=" + File + "\&tab=search" + SearchString;
}

function MGCDisplaySearchTips()
{
//WWHFrame.MGCContent.MGCDocContent.location.replace("../../../../mgc_html_help/searching_for_text.html");
   WWHFrame.DisplayHelp("../../../../mgc_html_help/searching_for_text.html");
}
function myvoid()
{
}

function MGCSortResultsByBook(raw)
{
var HTML = ""
var  Settings = WWHFrame.WWHJavaScript.mSettings.mSearch;
var Sdata = new Array;
var Cdata = new Array;
var BookArray = new Array;
var rankSums = new Array;
// Sort results by book
// Combine multi-dimension Array elements into 1
for (MaxIndex = raw.length, Index = 0 ; Index < MaxIndex ; Index++)
{
   Cdata[Index] = raw[Index][0] + "xSePy" + raw[Index][1] + "xSePy" + raw[Index][2] + "xSePy" + raw[Index][3];
}
Cdata.sort();
//
// Restore into a multi-dimensional array
for (MaxIndex = Cdata.length, Index = 0 ; Index < MaxIndex ; Index++)
{
   Sdata[Index] = Cdata[Index].split("xSePy");
}
//
// Add up the rank values for each book.
var BookData = new Array;
var MinRank = 49;
BookData[0] = ["xZmMQ",0,0,0,0];
// [0] = Book title
// [1] = sum of ranks for book
// [2] = number of hits (except under MinRank)
// [3] = Average rank (except under MinRank)
// [4] = number of actual hits
var BookDataIndex = -1;
var ResultsCount = 1;
var LastBook = "xZmMQ";
var RankSum = 0;
for (MaxIndex = Sdata.length, Index = 0 ; Index < MaxIndex ; Index++)
{
   if (Sdata[Index][0] == LastBook)
   {
      BookData[BookDataIndex][0] = Sdata[Index][0];
      BookData[BookDataIndex][4] = ResultsCount; // actual number of all hits
      if (eval(Sdata[Index][3]) > MinRank )
      {
         BookData[BookDataIndex][1] = (eval(Sdata[Index][3]) + eval(BookData[BookDataIndex][1]));
         BookData[BookDataIndex][2] = ResultsCount; // actual number of hits over MinRank
         ResultsCount++;
      }
   }
   else
   {
      BookDataIndex++;
      BookData[BookDataIndex] = ["xZmMQ",0,0,0,0];
      BookData[BookDataIndex][0] = Sdata[Index][0];
      LastBook = Sdata[Index][0];
      if (eval(Sdata[Index][3]) > MinRank )
      {
         BookData[BookDataIndex][1] = (eval(Sdata[Index][3]) + eval(BookData[BookDataIndex][1]));
      }
      else
         { BookData[BookDataIndex][1] = 0 ; }
      ResultsCount = 1;
      BookData[BookDataIndex][2] = ResultsCount; // number of hits over MinRank
      BookData[BookDataIndex][4] = ResultsCount; // actual number of all hits
   }
}
// Resort the average results to find out the display order of the books.
var NewSort = new Array;

for (MaxIndex = BookData.length, Index = 0 ; Index < MaxIndex ; Index++)
{
   NewSort[Index] = [5,"x"]; 
   NewSort[Index][0] = Math.floor(BookData[Index][1] / BookData[Index][2]); 
   NewSort[Index][1] = BookData[Index][2] + "xSePy" + BookData[Index][4] + "xSePy" + BookData[Index][1] + "xSePy" + BookData[Index][0] ; 
}      
WWHFrame.qsort ( NewSort, 0, NewSort.length-1);
NewSort.reverse();
FinalSortOrder = new Array;
for (MaxIndex = NewSort.length, Index = 0 ; Index < MaxIndex ; Index++)
{
   TitleData = NewSort[Index][1].split("xSePy");
   FinalSortOrder[Index] = TitleData[3]; 
}
// 
// Output search data now based on new book order
// Take into account if search results are below the Minimum rank value selected by user
 WWHFrame.MGCDisplayFirstResult = true;
 WWHFrame.LoadedFirstSearchEntry = false;


for (MaxIndex = FinalSortOrder.length, Index = 0 ; Index < MaxIndex ; Index++)
{
   ThisTitle = FinalSortOrder[Index];
   //
   // Loop through search results and output if over Min rank
   Results = "<tr><td colspan=2><p class=\"BookTitle\">" + ThisTitle + "</p></td></tr>";
   Found = false;
  Highlight = "<font style='color:blue; background-color:yellow;'>" + WWHFrame.LastSearchWords + "</font>";
  LevelGraphic = "<img src=\"../../common/images/SearchL.gif\" border=\"0\"/>";

   for (MX = raw.length, IX = 0 ; IX < MX ; IX++)
   {
      if ( (raw[IX][0] == ThisTitle) && (raw[IX][3] > WWHFrame.MinSearchPercent) )
      {
 if (WWHFrame.MGCDisplayFirstResult)
 {
    if ( (!WWHFrame.LoadedFirstSearchEntry) && (WWHFrame.ShowSearchBooks == "YES") )
    {
       WWHFrame.LoadedFirstSearchEntry = true;
       WWHFrame.WWHSearch.fShowEntry(raw[IX][2]);
       WWHFrame.LoadedFirstSearchEntry = true;
    }
 }

        PText = "";
        Title = "";
        Popup = " title=\"" + raw[IX][0].replace("<br>","") +"\"";
//////        WWHFrame.ISVerbose = false;
        if (WWHFrame.ISVerbose)
        {
           CurrentTopicTitle = raw[IX][1]
           File = raw[IX][4].replace(/.*\//,"");
           Context = raw[IX][4].replace(/\/.*/,"");
           PTextALL = GetPTextID(Context,File);
           PText = "<br>" + PTextALL.replace(CurrentTopicTitle + "<br>","") + " ...";


//           PTextALL = GetPTextID(Context,File);
//           PText = "<br>" + PTextALL.replace(TopicTitle + "<br>","");

//           PTextID = GetPTextID(raw[IX][4]);
//           PTextALL = WWHFrame.mParatext[PTextID][1];
//           PTextBits = PTextALL.split(":yPSePx:");
//           if (PTextBits[0] == raw[IX][1])
//           {
//              PText = "<br>" + PTextBits[1] + "<br>" + PTextBits[2];
//           }
//           else
//           {
//              PText = "<br>" + PTextBits[0] + "<br>" + PTextBits[1] + "<br>" + PTextBits[2];
//           }
//           PText = PText.replace(WWHFrame.LastSearchWords,Highlight);
           Popup = "";
        }


        LevelGraphic = "<img src=\"../../common/images/SearchL.gif\" border=\"0\"/>";
        if (raw[IX][3] > Settings.mbLowLevel) { LevelGraphic = "<img src=\"../../common/images/SearchM.gif\" border=\"0\"/>"; }
        if (raw[IX][3] > Settings.mbMediumLevel) { LevelGraphic = "<img src=\"../../common/images/SearchH.gif\" border=\"0\"/>"; }

//MGCRK - List results by book
        WWHFrame.SearchPointers.push(raw[IX][2]);
        pointer = WWHFrame.SearchPointers.length-1;
        Link = "<a href=\"javascript:fC(" + raw[IX][2] + "," + pointer + ")\;\"" + " title=\"" + raw[IX][0].replace("<br>","") + "\">";
//////////////        Results += "<tr><td valign=\"top\" width=25><p class=\"SearchEntryP\">" + LevelGraphic + "</td><td><p class=\"SearchEntry\">" + Link + raw[IX][1] + "</a>" + PText + Title + "</td></tr>";
        CurrentSEntry = "<tr><td valign=\"top\" width=25><p class=\"SearchEntryP\">" + LevelGraphic + "</td><td><p class=\"SearchEntry\">" + Link + raw[IX][1] + "</a>" + PText + Title + "</td></tr>";

        if (WWHFrame.ISVerbose)
        {
           Results += AddHighlight(CurrentSEntry);
        }
        else
        {
          Results += CurrentSEntry;
        }
        Found = true;
      }
   }
   if (Found)
   {   HTML += Results;  }
}     
return HTML;
}

function compare ( array, left, right ) {

 var depth = 0;
 
while ( depth < array[left].length && depth < array[right].length ) {

	
	if ( array[left][depth] < array[right][depth] )
	    return 1;
	else if ( array[left][depth] > array[right][depth] )
	    return -1;
	
	depth++;	    

 }
 return 0;
}

function qsort ( array, lo, hi ) {

   var low  = lo;
   var high = hi;
   mid = Math.floor( (low+high)/2 );
   do {
   while ( compare(array, low,  mid) > 0 )
     low++;
   while ( compare(array, high, mid) < 0 )
     high--;
   if ( low <= high ) {
     swap( array, low, high );
     low++;
     high--;
   }
   } while ( low <= high );
  
    if ( high > lo )
   qsort( array, lo, high );
  
    if ( low < hi )
   qsort( array, low, hi );
}

function swap ( a, i, j ) {

  var tmp = a[i]; 
  a[i] = a[j];
  a[j] = tmp;

}

function InsertPopupDivStyles()
{
//alert("Browser is " + WWHFrame.WWHBrowser.mBrowser + "\nOperating System is " + WWHFrame.operatingsystem + "\nName is " + WWHFrame.browsername  );
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
//   divHTML += "    background-color:#416E98;\n";
   divHTML += "    border: 2px solid #000000;\n";
   divHTML += "    border-top-width: 2px;\n";
   divHTML += "    border-top-color: grey;\n";
   divHTML += "    border-left-width: 2px;\n";
   divHTML += "    border-left-color: grey;\n";
   divHTML += "    border-right-width: 4px;\n";
   divHTML += "    border-right-color: #000000;\n";
   divHTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   divHTML += "    color: black;\n";
   divHTML += "    margin-top: 1pt;\n";
   divHTML += "    margin-top: 1pt;\n";
   divHTML += "    margin-bottom: 1pt;\n";
   divHTML += "    margin-left: 0pt;\n";
   divHTML += "    text-indent: 0pt;\n";
   divHTML += "    text-align: left;\n"; 
   divHTML += "  }\n";


   divHTML += "  div\.mScope\n";
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

function ShowSearchOptions()
{
 iState = 1;
 szDivID = "pMenu";
 WWHFrame.MGCShowSearchFilter = true;
 if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers)	   //NN4+
 {
    WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].visibility = iState ? "show" : "hide";
    WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].display = iState ? "block" : "none";
 }
 if (WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById)	  //gecko(NN6) + IE 5+
 {
     var obj = WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById(szDivID);
     obj.style.visibility = iState ? "visible" : "hidden";
     obj.style.display = iState ? "block" : "none";
 }
 else if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all)	// IE 4
 {
     WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
     WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.display = iState ? "block" : "none";
 }
}

function HideSearchOptions()
{
   iState = 0;
   szDivID = "pMenu";
   WWHFrame.MGCShowSearchFilter = false;
//   if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers)	   //NN4+
//   {
//      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].visibility = iState ? "show" : "hide";
//      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].display = iState ? "block" : "none";
//   }
   if (WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById)	  //gecko(NN6) + IE 5+
   {
       var obj = WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById(szDivID);
       obj.style.visibility = iState ? "visible" : "hidden";
       obj.style.display = iState ? "block" : "none";
   }
   else if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all)	// IE 4
   {
       WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
       WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.display = iState ? "block" : "none";
   }
//   UpdateSearchScope();
}


function DisplayLevelHelp()
{
   iState = 1;
   szDivID = "pLevelHelp";
   WWHFrame.MGCShowSearchFilter = true;
   if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers)	   //NN4+
   {
      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].visibility = iState ? "show" : "hide";
      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].display = iState ? "block" : "none";
   }
   if (WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById)	  //gecko(NN6) + IE 5+
   {
       var obj = WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById(szDivID);
       obj.style.visibility = iState ? "visible" : "hidden";
       obj.style.display = iState ? "block" : "none";
   }
   else if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all)	// IE 4
   {
       WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
       WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.display = iState ? "block" : "none";
   }
}

function CloseLevelHelp()
{
   iState = 0;
   szDivID = "pLevelHelp";
   WWHFrame.MGCShowSearchFilter = false;
   if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers)	   //NN4+
   {
      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].visibility = iState ? "show" : "hide";
      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.layers[szDivID].display = iState ? "block" : "none";
   }
   if (WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById)	  //gecko(NN6) + IE 5+
   {
       var obj = WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById(szDivID);
       obj.style.visibility = iState ? "visible" : "hidden";
       obj.style.display = iState ? "block" : "none";
   }
   else if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all)	// IE 4
   {
       WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
       WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].style.display = iState ? "block" : "none";
   }
}

function InsertSearchOptions()
{
   SOHTML = "";

   SOHTML += "<div class=\"mPercent\" id=\"pMenu\" style=\"left:30px; bottom:0px;\">";
   SOHTML += "<table border=0 cellspacing=0 cellpadding=0>";
   SOHTML += "<tr bgcolor=\"#416E98\"><td width=13>&nbsp;</td><td colspan=\"2\" align=\"left\" height=12><p class=\"MenuItemW\"><b>Change Search Options</b></p></td><td align=\"right\">&nbsp;&nbsp;&nbsp;<a href=\"javascript:WWHFrame.HideSearchOptions();\" title=\"Close\"><img src=\"../../common/images/closesm.png\" border=\"0\"/></a></td></tr>";
   SOHTML += "<tr><td colspan=\"3\" height=2> </td></tr>";
   if ( (WWHFrame.LibraryAvailable) && (WWHFrame.MySearchPrefs != "DOC") )
   {
      if (WWHFrame.ShowSearchBooks != "NO")
      {
         SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleSShBooks('1');\">List Results By BOOK</a></td></tr>";
         SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleSShBooks('0');\">List Results By TOPIC</a></td></tr>";
      }
      else
      {
         SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleSShBooks('1');\">List Results By BOOK</a></td></tr>";
         SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleSShBooks('0');\">List Results By TOPIC</a></td></tr>";
      }
      SOHTML += "<tr><td colspan=\"3\" height=12><hr width=95%></td></tr>";
   }
   if (WWHFrame.MinSearchPercent == 1)
   {  
      SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('39');\">Show Medium/High Results</a></td><td>&nbsp;</td></tr>";
      SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('74');\">Show High Results</a></td><td>&nbsp;</td></tr>";
      SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('1');\">Show All Results</a></td><td>&nbsp;</td></tr>";
   }
   if (WWHFrame.MinSearchPercent == 39)
   {  
      SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td class=\"MGCNowrap\"  colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('39');\">Show Medium/High Results</a></td><td>&nbsp;</td></tr>";
      SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('74');\">Show High Results</a></td><td>&nbsp;</td></tr>";
      SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('1');\">Show All Results</a></td><td>&nbsp;</td></tr>";
   }
   if (WWHFrame.MinSearchPercent == 74)
   {  
      SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('39');\">Show Medium/High Results</a></td><td>&nbsp;</td></tr>";
      SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('74');\">Show High Results</a></td><td>&nbsp;</td></tr>";
      SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCChangeSearchPercent('1');\">Show All Results</a></td><td>&nbsp;</td></tr>";
   }
      SOHTML += "<tr><td colspan=\"3\" height=12><hr width=95%></td></tr>";
      SOHTML += "<tr><td colspan=\"3\" height=2> </td></tr>";
      if (WWHFrame.ISVerbose)
      {
         SOHTML += "<tr><td width=13><img src=\"../../common/images/ckmark.gif\" height=\"10\" border=\"0\"/></td><td colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleISSVerbose();\">Show Context Detail</a></td></tr>";
      }
      else
      {
         SOHTML += "<tr><td width=13>&nbsp;</td><td class=\"MGCNowrap\" colspan=\"2\"><a href=\"javascript:WWHFrame.MGCToggleISSVerbose();\">Show Context Detail</a></td></tr>";
      }
   SOHTML += "</table></font>";
   SOHTML += "</div>";
   return SOHTML;
}


function ToggleSearchPopups(val)
{
   WWHFrame.EnableSearchPopups = val;
   if (MGCCookiesEnabled())
   {
      MGCSetCookie("MGCSearchPopup",WWHFrame.EnableSearchPopups);
   }
   WWHFrame.MGCNavigate.MGCIndex.location.reload(true);
   WWHFrame.WWHJavaScript.mPanels.fClearScrollPosition();
}

function InsertLevelHelp()
{
   SOHTML = "";
   SOHTML += "<div class=\"mPercent\" id=\"pLevelHelp\" style=\"width:155px; display:table-cell; left:18px; bottom:18px; visibility: hidden;\">";
   SOHTML += "<table border=0 cellspacing=0 cellpadding=0 width=100%>";
   SOHTML += "<tr bgcolor=\"#416E98\"><td class=\"MGCNowrap\" colspan=\"2\"><font color=\"#FFFFFF\"><b>Search Result Levels</b></font></td></tr>";
   SOHTML += "<tr><td align=\"right\" height=12 width=29><img src=\"../../common/images/SearchH.gif\" border=\"0\"/></td><td><p class=\"MenuItemB\"><b>H</b>igh Probability</font></p></td></tr>";
   SOHTML += "<tr><td align=\"right\" height=12 width=29><img src=\"../../common/images/SearchM.gif\" border=\"0\"/></td><td><b><p class=\"MenuItemB\">M</b>edium Probability</font></p></td></tr>";
   SOHTML += "<tr><td align=\"right\" height=12 width=29><img src=\"../../common/images/SearchL.gif\" border=\"0\"/></td><td><b><p class=\"MenuItemB\">L</b>ow Probability</font></p></td></tr>";
   SOHTML += "</table>";
   SOHTML += "</div>";
   return SOHTML;
}

function InsertDocTitleScope()
{
   SOHTML = "";
   var ptag = "<p class=\"MGCScopeSel\">";
   WWHFrame.ThisDocTitle = "Searching....";
   WWHFrame.ThisDocTitle = WWHFrame.MGCContent.MGCDocContent.DocTitle;
   //nnnnnnnnnnnn
   WWHFrame.MGCReloadMyDocs();
   if (WWHFrame.ThisDocTitle == "Search Tips") { WWHFrame.ThisDocTitle = "Searching........"; }
   if ( (WWHFrame.ThisDocTitle == "Searching........") && (WWHFrame.NoSearchResults) ) { WWHFrame.ThisDocTitle = "No Documents Found"; }
//   SOHTML += "<ul>";
   SOHTML += "<p class=\"MGCFormTitleB\"><b>Search Scope:</b></p>";
   if (!WWHFrame.LibraryAvailable)
   {
      WWHFrame.MySearchPrefs = "DOC";
   }
   MyDocsFontB = "<span style=\"color: #C8C8C8;\ font-style: italic;\"> ";
   MyDocsFontE = "</span>";
   var DOCHTML = "";
   DOCHTML = MyDocsFontB + ptag + "<input disabled align=\"top\" type=\"radio\" id=\"inputID1\" name=\"group2\" value=\"DOC\"  onclick=\"javascript:WWHFrame.SetSearchScope('DOC');return false;\"><label for=\"inputID1\">" + WWHFrame.ThisDocTitle + "</label></p>\n" + MyDocsFontE;
   if (WWHFrame.ThisDocTitle != "No Documents Found")
   {
      if (WWHFrame.MySearchPrefs == "DOC" )
      {
          DOCHTML = ptag + "<input align=\"top\" type=\"radio\" id=\"inputID1\" CHECKED name=\"group2\" value=\"DOC\"><label for=\"inputID1\">" + WWHFrame.ThisDocTitle + "</label></p>\n";
      }
  
      else
      {
         DOCHTML = ptag + "<input align=\"top\" type=\"radio\" id=\"inputID1\" name=\"group2\" value=\"DOC\"  onclick=\"javascript:WWHFrame.SetSearchScope('DOC');return false;\"><label for=\"inputID1\">" + WWHFrame.ThisDocTitle + "</label></p>\n";
      }
   }
   SOHTML += DOCHTML;
   if (WWHFrame.LibraryAvailable)
   {
      if (WWHFrame.MySearchPrefs == "LIB" )
      {
          SOHTML += ptag + "<input type=\"radio\" id=\"inputID2\" CHECKED name=\"group2\" value=\"LIB\"><label for=\"inputID2\">All Installed Docs</label></p>\n";
      }
      else
      {
          SOHTML += ptag + "<input type=\"radio\" id=\"inputID2\" name=\"group2\" value=\"LIB\"  onclick=\"javascript:WWHFrame.SetSearchScope('LIB');return false;\"><label for=\"inputID2\">All Installed Docs</label></p>\n";
      }
      if ( (WWHFrame.mInfoHubName != "Mentor Graphics") && (WWHFrame.mInfoHubName != "mgc_ih") )
      {
         if (WWHFrame.MySearchPrefs == "IHUB" )
         {
             SOHTML += ptag + "<input type=\"radio\" id=\"inputID3\" CHECKED name=\"group2\" value=\"IHUB\"><label for=\"inputID3\">" + WWHFrame.mInfoHubName + "</label></p>\n";
         }
         else
         {
             SOHTML += ptag + "<input type=\"radio\" id=\"inputID3\" name=\"group2\" value=\"IHUB\"  onclick=\"javascript:WWHFrame.SetSearchScope('IHUB');return false;\"><label for=\"inputID3\">" + WWHFrame.mInfoHubName + "</label></p>\n";
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
      if (WWHFrame.MySearchPrefs == "SNet" )
      {
          SOHTML += ptag + "<input type=\"radio\" id=\"inputID5\" CHECKED name=\"group2\" value=\"SNet\"><label for=\"inputID5\">SupportNet</label></p>\n";
      }
      else
      {
         SOHTML += ptag + "<input type=\"radio\" id=\"inputID5\" name=\"group2\" value=\"SNet\"  onclick=\"javascript:WWHFrame.SetSearchScope('SNet');return false;\"><label for=\"inputID5\">SupportNet</label></p>\n";
      }
   }
   return SOHTML;
}

function UpdateSearchScope()
{
   if (typeof(WWHFrame.MGCNavigate.MGCIndex.SearchForm) == "undefined")
      { return; }
   szDivID = "MGCSScopeDiv";
   if (WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById)	  //gecko(NN6) + IE 5+
   {
      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.getElementById(szDivID).innerHTML=InsertDocTitleScope();
   }
   else if(WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all)	// IE 4
   {
      WWHFrame.MGCNavigate.MGCIndex.SearchForm.document.all[szDivID].innerHTML=InsertDocTitleScope();
   }
}


function ReloadSearchPrefs()
{
   var ThisURL = window.location.href;
   window.location.href = ThisURL;
}

function DisplaySearchPrefs(initial)
{
   //MGCRK Save current topic page so it can be retrieved after prefs are set.
   SourceFrame = eval("parent.parent");
   SourceFrameName = SourceFrame.name;
   LastDocPage = unescape(WWHFrame.MGCContent.MGCDocContent.location);
   path = LastDocPage.split("/");
   book = path[path.length-2];
   file = path[path.length-1];
   ihub = WWHFrame.MGCContent.MGCDocContent.IHUBHandle;
   handle = WWHFrame.MGCContent.MGCDocContent.DocHandle;
   title = WWHFrame.MGCContent.MGCDocContent.DocTitle;
   
   //   URL = "../../../../../z_Prefs/MGCSearchPrefs.html?book=" + book + "&file=" + file + "&ihub=" + ihub + "&handle=" +handle + "&title=" + title;
   URL = "../../../../z_Prefs/MGCSearchPrefs.html?book=" + book + "&file=" + file + "&ihub=" + ihub + "&handle=" +handle + "&title=" + title + "&SFName=" + SourceFrameName;
   if (initial)
     { URL = "../z_Prefs/MGCSearchPrefs.html?book=" + book + "&file=" + file + "&ihub=" + ihub + "&handle=" +handle + "&title=" + title + "&SFName=" + SourceFrameName; }
   if ( file != "MGCSearchPrefs.html" )
   {
      MGCSetCookie("MGCLastSearchDoc", book + "/" + file);
      SearchPrefPage = "MGCSearchPrefs.html";
       chrome = "location=0,"
         + "alwaysRaised=1,"
         + "dependent=1,"
         + "width=550," 
         + "height=425," 
         + "menubar=0,"
         + "resizable=0,"
         + "scrollbars=0,"
         + "status=0," 
         + "titlebar=0,"
         + "toolbar=0,"
         + "hotkeys=0;"
   //         + "left=0,"
   //         + "top=0";
       x=window.open(URL,"MGCSearchPrefs",chrome);
       if (!x.opener)
         x.opener = "WWHFrameGS";
         if (window.focus) { x.focus() } 
   }
   return;
}


function PopSearchTopic(Topic)
{
   URL = "../../../../" + Topic;
   if (document.all) {
      var x = WWHFrame.MGCContent.screenLeft + 300;
      var y = WWHFrame.MGCContent.screenTop + 150;
   }
   else {
      var x = WWHFrame.MGCContent.screenX + 300;
      var y = WWHFrame.MGCContent.screenY + 250;
   }
   xloc = 'left=' + x;
   yloc = 'top=' + y;
   return;
}

function CloseSearchTopic()
{
   if (EnableSearchPopups == "YES")
   {
      if ( (!SearchTopicWindow.closed) || (SearchTopicWindow.closed != undefined) )
        SearchTopicWindow.close();
   }
}


function myvoid() {}

function SetSearchScope(source)
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
      WWHFrame.mSource = "MYDOCS";
      MGCReloadMyDocs();
      if ( (WWHFrame.mMyDocsList.length < 1) || (WWHFrame.mMyDocsList[0][0] == "None Selected") )
      {
//         WWHFrame.MySearchPrefs = SavedPrefs;
         WWHFrame.DisplaySearchPrefs(true);
//         MGCReloadMyDocs();
//         if ( (WWHFrame.mMyDocsList.length < 1) || (WWHFrame.mMyDocsList[0][0] == "None Selected") )
//         {         
//            alert("You must first define a set of documents");
//         }
      }
   }  
   WWHFrame.ForceSearchSubmit = true;
   if (WWHFrame.WWHJavaScript.mCurrentTab == "1")
      { UpdateIndexScope(); }
   if (WWHFrame.WWHJavaScript.mCurrentTab == "2")
      { UpdateSearchScope(); }
}

function SearchPopupsEnabled()
{
   var  SearchSettings = WWHFrame.WWHJavaScript.mSettings.mSearch;
   // Set default
   if (MGCCookiesEnabled())
   {
      EnableSearchPopups = MGCGetCookie("MGCSearchPopup");
      if (EnableSearchPopups == null)
      { 
         EnableSearchPopups = SearchSettings.mbEnableSearchPopups;
         MGCSetCookie("MGCSearchPopup",EnableSearchPopups);
      }
   }
   WWHFrame.EnableSearchPopups = EnableSearchPopups;
   return EnableSearchPopups;
}

//MGCRK New function to open SupportNet & pass search string
//
function SearchSupportNet(IHub,SearchString)
{
   WWHFrame = eval("window.self");
   var  SNSearchURL  = "http://supportnet.mentor.com/infohub.cfm";
   mInfoHub = IHub;
   if ( typeof(SearchString) != "undefined" && SearchString != "" )
   {
      var searchTerms = SearchString;
      searchTerms = searchTerms.split(" ").join("+");
   }
   else
   {
      searchTerms = "";
   }
   var QueryString = ""
   var IHubString = ""
   if ( searchTerms != "" && searchTerms != "undefined") {
      QueryString = "query=" + searchTerms;
   }
   // default to mgc_ih if mInfoHub not defined/valid
   if ( typeof(mInfoHub) != "undefined" && mInfoHub != "" ) {
      if ( mInfoHub.toLowerCase() == "none" ) {
         mInfoHub = "mgc_ih";
      }
   } else {
      mInfoHub = "mgc_ih";
   }
   IHubString = "\infohub=" + mInfoHub;
   if (QueryString != "" )
   {
   	   SNSearchURL += "\?" + IHubString + "\&" + QueryString + "\&field=HTML";
   }
   if (QueryString == "" )
   {
       SNSearchURL += "\?" + IHubString + "&link=microsite";
   }
//   alert ("SNSearchURL is " + SNSearchURL.replace('\?',"\n"));
   WWHFrame.SSnet=window.open(SNSearchURL);
   WWHFrame.SSnet.focus();
//   setTimeout("window.focus(WWHFrame.SSnet);", 1);
//   SetTimeout("window.focus(SSnet)");
}

function MGCReloadMyDocs()
{
   if (MGCGetCookie("MGCMyDocs") != null)
   {
       LocalMyDocsList = new Array();
       mMyDocsList[0] = ["None Selected","zzZZzz"];
       LocalMyDocsList[0] = ["None Selected","zzZZzz"];
       LArray = new Array;
       SavedMyDocs = MGCGetCookie("MGCMyDocs");
       RestoredMyDocs = unescape(SavedMyDocs).replace(",,",",");
       LocalMyDocsList = RestoredMyDocs.split(",");
       FoundOne = false;
       for (MaxIndex = LocalMyDocsList.length, Index = 0 ; Index < MaxIndex ; Index++)
       {
          // See if handle is in the library,
          // if not, leave it out of the list
          InLib = false;
          LData = LocalMyDocsList[Index].split("ySepZ");
          for (MaxIx = mLibraryList.length, Ix = 0 ; Ix < MaxIx ; Ix++)
          {
             if ( LData[1] == mLibraryList[Ix][1] )
                { InLib = true;FoundOne = true; }
          }
          if ( ( LData[1] != "zzZZzz" ) && InLib )
          { 
             mMyDocsList[Index] = LData;
             mLDocList[Index] = LData;
          }
      }
   WWHFrame.mMyDocsList = mMyDocsList;
   }
//alert("SavedMyDocs is " + SavedMyDocs);
//alert("mMyDocsList is " + mMyDocsList);
}

function GetPTextID(Context,File)
{
   File = File.replace(".html","")
//   File = File + ".html";
   for (MMx = WWHFrame.mLParatext[Context].length, Ix = 0 ; Ix < MMx ; Ix++)
   {
      if ( WWHFrame.mLParatext[Context][Ix][0] == File )
         { return WWHFrame.mLParatext[Context][Ix][1]; }
   }
   return "NOT FOUND";
}




function GetPTextIDORG(tag)
{
   SearchTag = tag.replace(".html","");
   for (MMx = WWHFrame.mParatext.length, Ix = 0 ; Ix < MMx ; Ix++)
   {
      if ( WWHFrame.mParatext[Ix][0] == SearchTag )
         { return Ix; }
   }
   return -1;
}
function MGCToggleISSVerbose()
{
   if (WWHFrame.ISVerbose)
      { WWHFrame.ISVerbose = false; }
   else
      { WWHFrame.ISVerbose = true; }
   HideSearchOptions();
   WWHFrame.MGCNavigate.MGCIndex.SearchForm.location.reload(true);
}
function DNSH()
{
   if  (WWHFrame.CurrentSearchHit < WWHFrame.SearchPointers.length)
   { WWHFrame.CurrentSearchHit++; }
   else
   { WWHFrame.CurrentSearchHit = 0; }
//   alert("Next search hit is " + WWHFrame.SearchPointers[WWHFrame.CurrentSearchHit]);
   WWHFrame.WWHSearch.fShowEntry(WWHFrame.SearchPointers[WWHFrame.CurrentSearchHit]);
}
function DPSH()
{
   if  (WWHFrame.CurrentSearchHit > 0)
   { WWHFrame.CurrentSearchHit--; }
   else
   { WWHFrame.CurrentSearchHit = WWHFrame.SearchPointers.length-1; }
   
//   alert("Next search hit is " + WWHFrame.SearchPointers[WWHFrame.CurrentSearchHit]);
   WWHFrame.WWHSearch.fShowEntry(WWHFrame.SearchPointers[WWHFrame.CurrentSearchHit]);
}
function DPSHxx()
{
//alert ("CurrentSearchHit is: " + WWHFrame.CurrentSearchHit + "\nWWHFrame.PageHits is: " + WWHFrame.PageHits);
   if  ( (WWHFrame.CurrentSearchHit < WWHFrame.PageHits) && (WWHFrame.CurrentSearchHit != 1) )
   {
      WWHFrame.CurrentSearchHit--;
      var  URL;
      var Page = new String(WWHFrame.MGCContent.MGCDocContent.location);
      var Parts;

      // Display previous search hit on this page
//      Page = WWHFrame.MGCContent.MGCDocContent.location;
//      document.write(Page);
      Parts = Page.split("#");
      URL = Parts[0] + "#SString" + WWHFrame.CurrentSearchHit;
      //
      //alert("URL is: " + URL);
      //document.write(URL);
      WWHFrame.WWHHelp.fSetDocumentHREF(URL, false);
   }
   else
   {
      if (WWHFrame.CurrentSearchParam > 0)
      {
         WWHFrame.CurrentSearchParam--;
         //alert("WWHFrame.CurrentSearchParam is: " + WWHFrame.CurrentSearchParam);
         WWHFrame.WWHSearch.fShowEntry(WWHFrame.CurrentSearchParam);
      }
   }
}
