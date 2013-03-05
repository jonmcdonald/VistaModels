// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHFavorites_Object()
{
  this.mbPanelInitialized  = false;
  this.mPanelAnchor        = null;
  this.mPanelTabTitle      = WWHFrame.WWHJavaScript.mMessages.mTabsFavoritesLabel;
  this.mPanelTabIndex      = -1;
  this.mPanelFilename      = ((WWHFrame.WWHBrowser.mBrowser == 1) ? "panelfni.htm" : "panelfsi.htm");
  this.mInitFavorites          = 0;
  this.mOptions            = new WWHFavoritesOptions_Object();
  this.mTopEntry           = new WWHFavoritesEntry_Object(false, -1, null);
  this.mMaxLevel           = 0;
  this.mEntryCount         = 0;
  this.mSeeAlsoArray       = new Array();
  this.mSectionFavorites       = 0;
  this.mbThresholdExceeded = null;
  this.mSectionCache       = new WWHSectionCache_Object();
  this.mIterator           = new WWHFavoritesIterator_Object();
  this.mHTMLSegment        = new WWHStringBuffer_Object();
  this.mEventString        = WWHPopup_EventString();
  this.mClickedEntry       = null;

  this.fInitHeadHTML          = WWHFavorites_InitHeadHTML;
  this.fInitBodyHTML          = WWHFavorites_InitBodyHTML;
  this.fInitLoadBookIndex     = WWHFavorites_InitLoadBookIndex;
  this.fAddSeeAlsoEntry       = WWHFavorites_AddSeeAlsoEntry;
  this.fProcessSeeAlsoEntries = WWHFavorites_ProcessSeeAlsoEntries;
  this.fNavigationHeadHTML    = WWHFavorites_NavigationHeadHTML;
  this.fNavigationBodyHTML    = WWHFavorites_NavigationBodyHTML;
  this.fHeadHTML              = WWHFavorites_HeadHTML;
  this.fStartHTMLSegments     = WWHFavorites_StartHTMLSegments;
  this.fAdvanceHTMLSegment    = WWHFavorites_AdvanceHTMLSegment;
  this.fGetHTMLSegment        = WWHFavorites_GetHTMLSegment;
  this.fEndHTMLSegments       = WWHFavorites_EndHTMLSegments;
  this.fPanelNavigationLoaded = WWHFavorites_PanelNavigationLoaded;
  this.fPanelViewLoaded       = WWHFavorites_PanelViewLoaded;
  this.fHoverTextTranslate    = WWHFavorites_HoverTextTranslate;
  this.fHoverTextFormat       = WWHFavorites_HoverTextFormat;
  this.fGetPopupAction        = WWHFavorites_GetPopupAction;
  this.fThresholdExceeded     = WWHFavorites_ThresholdExceeded;
  this.fGetSectionNavigation  = WWHFavorites_GetSectionNavigation;
  this.fDisplaySection        = WWHFavorites_DisplaySection;
  this.fSelectionListHeadHTML = WWHFavorites_SelectionListHeadHTML;
  this.fSelectionListBodyHTML = WWHFavorites_SelectionListBodyHTML;
  this.fSelectionListLoaded   = WWHFavorites_SelectionListLoaded;
  this.fDisplayLink           = WWHFavorites_DisplayLink;
  this.fGetEntry              = WWHFavorites_GetEntry;
  this.fClickedEntry          = WWHFavorites_ClickedEntry;
  this.fClickedSeeAlsoEntry   = WWHFavorites_ClickedSeeAlsoEntry;
  this.mbPanelInitialized  = true;

  // Set options
  //
  WWHJavaScriptSettings_Favorites_DisplayOptions(this.mOptions);
}

function  WWHFavorites_InitHeadHTML()
{
  var  InitHeadHTML = "";
//  InitHeadHTML = "<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + ic_da_olh + "wwhdata/js/topics.js\"></script>\n"";


  return InitHeadHTML;
}

function  WWHFavorites_InitBodyHTML()
{
  WWHFrame.InGlobalSearch = false;
 WWHFrame.InGlobalIndex = false;
  var  VarHTML = new WWHStringBuffer_Object();
  var  VarBookList = WWHFrame.WWHHelp.mBooks.mBookList;


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
////    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(VarBookList[Index].mDirectory) + "wwhdata/js/index.js\"></script>\n");

    // Load Index data for current book
    //
////    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/Favorites1s.js\"></script>\n");
//MGCRK added document.js
  }
    VarHTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhdata/js/document.js\"></script>\n");

//MGCRK added style sheets that are used for the documents

    if (WWHFrame.operatingsystem == "Unix") {
	VarHTML.fAppend("<link rel=\"stylesheet\" type=\"text/css\" href=\"./catalogU.css\" />");
    } else {
	VarHTML.fAppend("<link rel=\"stylesheet\" type=\"text/css\" href=\"./catalog.css\" />");
    }
  return VarHTML.fGetBuffer();
}

function  WWHFavorites_InitLoadBookIndex(ParamAddIndexEntriesFunc)
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
      WWHFavoritesEntry_SortChildren(this.mTopEntry);
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

function  WWHFavorites_AddSeeAlsoEntry(ParamEntry)
{
////  this.mSeeAlsoArray[this.mSeeAlsoArray.length] = ParamEntry;
}

function  WWHFavorites_ProcessSeeAlsoEntries()
{
return;
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

function  WWHFavorites_NavigationHeadHTML()
{
  var  HTML = new WWHStringBuffer_Object();
  var  WWHFrame = eval("parent.parent.parent");
  var  FontSize = WWHFrame.BaseNavFontSize;
//  if (WWHFrame.operatingsystem == "Unix")
//  {
//     FontSize = "13";
//  }
  WWHFrame.IndexFontSize = FontSize;
  // Generate style section
  //
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
  HTML.fAppend("  p.navigation\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mNavigationDisabledColor + ";\n");
  HTML.fAppend("    " + WWHFrame.WWHJavaScript.mSettings.mIndex.mNavigationFontStyle + ";\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("  .MGCButtons\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 1pt;\n");
  HTML.fAppend("    	font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    	font-size: " + FontSize + "px;\n");
  HTML.fAppend("  }\n");


  HTML.fAppend("    p.MGCCIndexNavigation {\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    margin-top: 1pt;\n");
  HTML.fAppend("    margin-bottom: 0pt;\n");
  HTML.fAppend("    	font-family: Verdana, Arial, Helvetica, sans-serif;\n");
  HTML.fAppend("    	font-size: " + WWHFrame.IndexFontSize + "px;\n");
  HTML.fAppend("    }\n");

  HTML.fAppend("    a\:link    { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:visited { color\: #2652A2\;text-decoration\: none\; }\n");
  HTML.fAppend("    a\:active, a:focus  { color\: #2652A2\;text-decoration\: none\; background-color: " + WWHFrame.WWHJavaScript.mSettings.mIndex.mHighlightColor + "; }\n");
  HTML.fAppend("    a\:hover   { color\: #0000FF\;text-decoration\: underline\; }\n");
  HTML.fAppend("  }\n");
  HTML.fAppend(" -->\n");
  HTML.fAppend("</style>\n");
  return HTML.fGetBuffer();
}


// MGCRK - rewrote this to handle our custom index
// MGCRK - This is the index letter navigator panel.
// MGCRK - original Quadralay function follows this custom one for MGC
//

function  WWHFavorites_NavigationBodyHTML()
{
   var  HTML = new WWHStringBuffer_Object();
   var  VarMaxIndex;
   var  VarIndex;
   var  Letter;
   var  Letterl;
   var  FontSize = WWHFrame.BaseNavFontSize;
   var LastFavorites = new Array();
   var SavedFavorites;
   var RestoredFavorites;
//   if (WWHFrame.operatingsystem == "Unix")
//   {
//     FontSize = "13";
//   }

   Highlight  = "<STYLE type=\"text/css\">\n";
   Highlight += "<!--\n";
   Highlight += "    .highlight \{ background: #CCCCCC;font-weight: bold; \}\n";
   Highlight += "  li.Fav\n";
   Highlight += "  {\n";
   Highlight += "  position: relative; left: -12px\;";
   Highlight += "    margin-top: 3px;\n";
   Highlight += "    margin-bottom: 3px;\n";
   Highlight += "    	font-family: Verdana, Arial, Helvetica, sans-serif;\n";
   Highlight += "    	font-size: " + FontSize + "px;\n";
   Highlight += "  }\n";
   Highlight += "-->\n";
   Highlight += "</STYLE>\n";
   HTML.fAppend(Highlight);


// Load previous Favorites from Cookie
//
   if (CookiesEnabled)
   {
      if (MGCGetCookie("MGCFavorites") != null)
      {
         SavedFavorites = MGCGetCookie("MGCFavorites");
         RestoredFavorites = unescape(SavedFavorites).replace(",,",",");
         WWHFrame.Favorites = RestoredFavorites.split("::zQZq,");
//         if ( WWHFrame.Favorites.length > 22 )
//         {
//            WWHFrame.TempFavorites = WWHFrame.Favorites.slice(1,22);
//            WWHFrame.Favorites = WWHFrame.TempFavorites;
//         }
         for (MaxIndex = WWHFrame.Favorites.length, Index = 0 ; Index < MaxIndex-1 ; Index++)
         {
            WWHFrame.Favorites[Index] = "qQzq" + WWHFrame.Favorites[Index] + "::zQZq";
            WWHFrame.Favorites[Index] = WWHFrame.Favorites[Index].replace(/qQzq,/,"").replace(/qQzq/,"");
         }
         WWHFrame.FavoritesPointer = (WWHFrame.Favorites.length-1);
      }
      else
      {
         WWHFrame.Favorites = new Array();
         WWHFrame.FavoritesPointer = -1;
      }
   }
   else
   {
      HTML.fAppend("Cookies are not enabled.  You must enable cookies for this functionality to work.");
      return HTML.fGetBuffer();
   }





   WWHFrame.IndexFontSize = FontSize;
   HTML.fAppend("<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + (WWHFrame.BaseNavFontSize+2) + "px\" margin-top: 1pt margin-bottom: 1pt>");
   if (WWHFrame.browsername != "Internet Explorer")
   {
    Label = "My Topics";
   }
   else
   {
    Label = "My Topics";
   }

//   HTML.fAppend("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
   HTML.fAppend("<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + FontSize + "px\" margin-top: 1pt margin-bottom: 1pt>");
   HTML.fAppend("<table width=\"90\%\" border=0 cellpadding=1 cellspacing=0>");
   HTML.fAppend("<tr><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td width=\"75%\"><b>My Saved Topics:</b><br />(Limit 20)</td><td><a href='javascript:WWHFrame.MGCFavoritesAdd()' title=\"Add Current Topic\" /><img src\=\"../../common/images/add_topic.png\" border=0 /></a></td></tr><tr><td>&nbsp;</td><td>&nbsp;</td></tr></table>");
//   HTML.fAppend("<div align=\"left\">");
   HTML.fAppend("<table width=\"90\%\" border=0 cellpadding=1 cellspacing=0>");
//   HTML.fAppend("<tr><td colspan=2><a href='javascript:WWHFrame.MGCFavoritesAdd()' title=\"Add Current Topic\" /><img src\=\"../../common/images/add_topic.png\" border=0 /></a></td></tr>");
   var DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
   CurrentDocHandle = DocumentFramePath.DocHandle;
   CurrentDocTitle = DocumentFramePath.DocTitle;
   CurrentPageTitle = DocumentFramePath.PageTitle;
   CurrentFile = DocumentFramePath.CurrentFile;
//   for (MaxIndex = WWHFrame.Favorites.length, Index = 0 ; Index < MaxIndex-1 ; Index++)
//alert("Favorites length is " + WWHFrame.Favorites.length + " " + WWHFrame.Favorites);
   for (MaxIndex = WWHFrame.Favorites.length, Index = 0 ; Index < MaxIndex-1 ; Index++)
   {
      BoldStart = "";
      BoldEnd = "";
      Background = "";
      FavoritesParts = WWHFrame.Favorites[Index].split("::");
      if ( (CurrentDocHandle == FavoritesParts[0]) && (CurrentPageTitle == FavoritesParts[2]) && (CurrentFile == FavoritesParts[3]) )
      {
         BoldStart = "<span class=\"highlight\">";
         BoldEnd = "</span>";
         Background = " ";
      }
   // Make sure the book is in the library - it might have been deleted since the user saved this favorite
      InLib = false;
      for (Mxix = WWHFrame.mLibraryList.length, xix = 0 ; xix < Mxix ; xix++)
      {
//alert("Comparing " + mLibraryList[xix][1] + " to " + FavoritesParts[0]);
         if (mLibraryList[xix][1] == FavoritesParts[0]) { InLib = true; }
      }
      if (InLib)
      {
//         HTML.fAppend("<tr><td align\=\"left\" valign=\"top\" " + Background + ">ol start=\"" + (Index+1) + "\" li class=\"Fav\" \"</td><td>&nbsp;</td><td align\=\"left\" valign=\"top\" width\=\"12\"> /li /ol </td></tr>\n");
         HTML.fAppend("<tr><td align\=\"right\" valign=\"top\" " + Background + ">" + (Index+1) + ".&nbsp;</td><td align\=\"left\" valign=\"top\" " + Background + "><a href='javascript:WWHFrame.DFav(\"" + Index + "\");' title=\"View this topic in " + FavoritesParts[1] + "\">" + BoldStart + FavoritesParts[2] + BoldEnd + "</a></td><td>&nbsp;</td><td align\=\"left\" valign=\"top\" width\=\"12\"><a href='javascript:WWHFrame.MGCFavoritesDelete(\"" + Index + "\")' title= \"Delete this topic from my Favorites\"><img src\=\"../../common/images/delete_topic.png\" border=0 vspace=0 /></a></td></tr>\n");
      }
      else
      {
         HTML.fAppend("<tr><td align\=\"right\" valign=\"top\" " + Background + ">" + (Index+1) + ".&nbsp;</td><td align\=\"left\" valign=\"top\" " + Background + ">" + FavoritesParts[2] + "<i>\ (Topic not in this library\)</i></td><td>&nbsp;</td><td align\=\"left\" valign=\"top\" width\=\"12\"><a href='javascript:WWHFrame.MGCFavoritesDelete(\"" + Index + "\")' title= \"Delete this topic from my Favorites\"><img src\=\"../../common/images/delete_topic.png\" border=0 vspace=0 /></a></td><td width=12>&nbsp;</td></tr>\n");
      }
   }
//   HTML.fAppend("</ol>");
   HTML.fAppend("</table></span><br />");

   return HTML.fGetBuffer();
}

function  MGCFavoritesAdd()
{
//alert("Favorites length is " + WWHFrame.Favorites.length + "\n" + WWHFrame.Favorites);
   if ( WWHFrame.Favorites.length > 20 )
   {
      alert("You have already saved 20 topics.\nYou must delete one or more topics before you can add any more.");
      return;
   }
   var DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
   CurrentDocHandle = DocumentFramePath.DocHandle;
   CurrentDocTitle = DocumentFramePath.DocTitle;
   CurrentPageTitle = DocumentFramePath.PageTitle;
   if (CurrentPageTitle == " ") { CurrentPageTitle[0] = ""; }
   CurrentFile = DocumentFramePath.CurrentFile;
   if (MGCCookiesEnabled() != null)
   {
      if (MGCGetCookie("MGCFavorites") != null)
      {
         SavedFavorites = MGCGetCookie("MGCFavorites");
         RestoredFavorites = unescape(SavedFavorites).replace(",,",",");
         WWHFrame.Favorites = RestoredFavorites.split("::zQZq,");
         for (MaxIndex = WWHFrame.Favorites.length, Index = 0 ; Index < MaxIndex-1 ; Index++)
         {
            WWHFrame.Favorites[Index] = WWHFrame.Favorites[Index] + "::zQZq";
         }
         WWHFrame.FavoritesPointer = (WWHFrame.Favorites.length-1);
      }
      else
      {
         WWHFrame.Favorites = new Array();
         WWHFrame.FavoritesPointer = -1;
      }
   }
   else
   {
      return
   }
   WWHFrame.Favorites.push(CurrentDocHandle + "::" + CurrentDocTitle + "::" + CurrentPageTitle + "::" + CurrentFile + "::zQZq");
   WWHFrame.FavoritesPointer++;
   WWHFrame.MGCSetCookie("MGCFavorites",WWHFrame.Favorites + ",");
   DocumentFramePath.location.replace("../../../../" + CurrentDocHandle + "/" + CurrentFile);
   WWHFrame.MGCNavigate.MGCIndex.location.reload(true);
}

function  MGCFavoritesDelete(element)
{
   var DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
   if (WWHFrame.browsername != "Internet Explorer")
   {
    Label = " bookmarked ";
   }
   else
   {
    Label = " favorite ";
   }
//   CurrentDocHandle = DocumentFramePath.DocHandle;
//   CurrentDocTitle = DocumentFramePath.DocTitle;
//   CurrentPageTitle = DocumentFramePath.PageTitle;
//   CurrentFile = DocumentFramePath.CurrentFile;
   Parts = WWHFrame.Favorites[element].split("::");
   var x=window.confirm("Are you sure you want to delete your" + Label + "topic: " + Parts[2] + " ?");
   if (x)
   {
      if (MGCCookiesEnabled() != null)
      {
      if (MGCGetCookie("MGCFavorites") != null)
         {
            SavedFavorites = MGCGetCookie("MGCFavorites");
            RestoredFavorites = unescape(SavedFavorites).replace(",,",",");
            WWHFrame.Favorites = RestoredFavorites.split("::zQZq,");
            WWHFrame.Favorites.splice(element,1);
            for (MaxIndex = WWHFrame.Favorites.length, Index = 0 ; Index < MaxIndex-1 ; Index++)
            {
             WWHFrame.Favorites[Index] = WWHFrame.Favorites[Index] + "::zQZq";
            }
            WWHFrame.FavoritesPointer = element;
         }
         WWHFrame.MGCSetCookie("MGCFavorites",WWHFrame.Favorites + ",")
         WWHFrame.MGCNavigate.MGCTabs.location.reload(true);
      }
   }
   else
   { return; }
}


function DFav(item)
{
//alert(WWHFrame.Favorites[item].split("::"));
   FavoritesParts = WWHFrame.Favorites[item].split("::");
   var DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
   var CurentDoc = DocumentFramePath.DocHandle
   var Handle = FavoritesParts[0];
   var DocTitle = FavoritesParts[1];
   var Topic = FavoritesParts[2];
   var File = FavoritesParts[3].replace("::zQZq","");
//   if (CurentDoc == Handle)
//   {
      WWHFrame.ModifyFavoritesOK = "NOTOK";
      DocumentFramePath.location.replace("../../../../" + Handle + "/" + File); 
//   }
   WWHFrame.FavoritesPointer = item;
   WWHFrame.MGCNavigate.MGCTabs.location.reload(true);
}

function MGCFavoritesNoAction()
{
// do nothing
}

function  WWHFavorites_HeadHTML()
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
  HTML.fAppend("  a:active, a:focus\n");
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





















function  WWHFavorites_StartHTMLSegments()
{
  var  HTML = new WWHStringBuffer_Object();
  HTML.fAppend("&nbsp;");
  return HTML.fGetBuffer();
}


function  WWHFavorites_StartHTMLSegments_org()
{
  var  HTML = new WWHStringBuffer_Object();


  // Setup iterator for display
  //
  if (this.fThresholdExceeded())
  {
    this.mIterator.fReset(this.mSectionIndex);
  }
  else
  {
    this.mIterator.fReset(-1);
  }

  // Define accessor functions to reduce file size
  //
  HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\">\n");
  HTML.fAppend(" <!--\n");
  HTML.fAppend("  function  fC(ParamEntryInfo)\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHFavorites.fClickedEntry(ParamEntryInfo);\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("\n");
  HTML.fAppend("  function  fA(ParamEntryInfo)\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHFavorites.fClickedSeeAlsoEntry(ParamEntryInfo);\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("\n");
  HTML.fAppend("  function  fS(ParamEntryID,\n");
  HTML.fAppend("               ParamEvent)\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHJavaScript.mPanels.mPopup.fShow(ParamEntryID, ParamEvent);\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("\n");
  HTML.fAppend("  function  fH()\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHJavaScript.mPanels.mPopup.fHide();\n");
  HTML.fAppend("  }\n");
  HTML.fAppend(" // -->\n");
  HTML.fAppend("</script>\n");
  return HTML.fGetBuffer();
}

function  WWHFavorites_AdvanceHTMLSegmentMGC()
{
}

function  WWHFavorites_AdvanceHTMLSegment()
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

function  WWHFavorites_GetHTMLSegment()
{
  return this.mHTMLSegment.fGetBuffer();
}

function  WWHFavorites_EndHTMLSegments()
{
  return "";
}

function  WWHFavorites_PanelNavigationLoaded()
{
  // Restore focus
  //
  WWHFrame.WWHHelp.fFocus("WWHPanelNavigationFrame", "in" + this.mSectionFavorites);
}

function  WWHFavorites_PanelViewLoaded()
{
}

function  WWHFavorites_HoverTextTranslate(ParamEntryInfo)
{
  var  Entry;


  // Locate specified entry
  //
  Entry = this.fGetEntry(ParamEntryInfo);

  return Entry.mText;
}

function  WWHFavorites_HoverTextFormat(ParamWidth,
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

function  WWHFavorites_GetPopupAction(ParamEntryInfo)
{
  var  PopupAction = "";


  if (WWHFrame.WWHJavaScript.mSettings.mHoverText.mbEnabled)
  {
    PopupAction += " onMouseOver=\"fS('" + ParamEntryInfo + "', " + this.mEventString + ");\"";
    PopupAction += " onMouseOut=\"fH();\"";
  }

  return PopupAction;
}

function  WWHFavorites_ThresholdExceeded()
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

function  WWHFavorites_GetSectionNavigation()
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

function  WWHFavorites_DisplaySection(ParamSectionIndex)
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

function  WWHFavorites_SelectionListHeadHTML()
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

function  WWHFavorites_SelectionListBodyHTML()
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
            HTML.fAppend("<a name=\"indexselect\" href=\"javascript:WWHFrame.WWHFavorites.fDisplayLink('" + DocumentURL + "');\"" + VarAccessibilityTitle + ">");
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
            HTML.fAppend("<a href=\"javascript:WWHFrame.WWHFavorites.fDisplayLink('" + DocumentURL + "');\"" + VarAccessibilityTitle + ">");
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

function  WWHFavorites_SelectionListLoaded()
{
  // Move focus to document selection list
  //
  WWHFrame.WWHHelp.fFocus("WWHDocumentFrame", "indexselect");
}

function  WWHFavorites_DisplayLink(ParamURL)
{
  WWHFrame.WWHHelp.fSetDocumentHREF(ParamURL, false);
}

function  WWHFavorites_GetEntry(ParamEntryInfo)
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

function  WWHFavorites_ClickedEntry(ParamEntryInfo)
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

function  WWHFavorites_ClickedSeeAlsoEntry(ParamEntryInfo)
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

function  WWHFavoritesIterator_Object()
{
  this.mIteratorScope      = null;
  this.mEntry              = null;
  this.mParentStack        = new Array();
  this.mPositionStack      = new Array();

  this.fReset   = WWHFavoritesIterator_Reset;
  this.fAdvance = WWHFavoritesIterator_Advance;
}

function  WWHFavoritesIterator_Reset(ParamIndex)
{
  if (ParamIndex == -1)  // Iterate buckets as well!
  {
    this.mIteratorScope = WWHFrame.WWHFavorites.mTopEntry;
  }
  else
  {
    this.mIteratorScope = WWHFrame.WWHFavorites.mTopEntry.mChildrenSortArray[ParamIndex];
  }
  this.mEntry                = this.mIteratorScope;
  this.mParentStack.length   = 0;
  this.mPositionStack.length = 0;
}

function  WWHFavoritesIterator_Advance()
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
        WWHFavoritesEntry_SortChildren(this.mEntry);
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

function  WWHFavoritesEntry_Object(bParamGroupHeading,
                               ParamBookIndex,
                               ParamText,
                               ParamLinks,
                               ParamSeeAlsoKey,
                               ParamSeeAlsoGroupKey)
{
  if (bParamGroupHeading)
  {
    this.mbGroup  = true;
    this.mGroupID = WWHFrame.WWHFavorites.mEntryCount;
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

  this.fAddEntry  = WWHFavoritesEntry_AddEntry;
  this.fA         = WWHFavoritesEntry_AddEntry;

  // Bump entry count if not the top level node
  //
  if (ParamBookIndex != -1)
  {
    WWHFrame.WWHFavorites.mEntryCount++;
  }

  // Add links
  //
  if ((typeof(ParamLinks) != "undefined") &&
      (ParamLinks != null))
  {
    this.mBookLinks = new WWHFavoritesEntryBookHash_Object();
    this.mBookLinks[ParamBookIndex] = ParamLinks;
  }
}

function  WWHFavoritesEntry_GetKey(ParamGroupTag,
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

function  WWHFavoritesEntry_AddEntry(ParamText,
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
    this.mChildren = new WWHFavoritesEntryHash_Object();
  }

  // Define keys
  //
  VarKey             = WWHFavoritesEntry_GetKey(ParamGroupTag, ParamText, ParamSort);
  VarSeeAlsoKey      = WWHFavoritesEntry_GetKey(null, ParamSeeAlso, ParamSeeAlsoSort);
  VarSeeAlsoGroupKey = WWHFavoritesEntry_GetKey(ParamSeeAlsoGroupTag, ParamSeeAlsoGroup, ParamSeeAlsoGroupSort);

  // Access entry, creating it if it doesn't exist
  //
  BookIndex = WWHFrame.WWHFavorites.mInitIndex;
  ChildEntry = this.mChildren[VarKey + "~"];
  if (typeof(ChildEntry) == "undefined")
  {
    ChildEntry = new WWHFavoritesEntry_Object(bVarGroupHeading, BookIndex, ParamText,
                                          Links, VarSeeAlsoKey, VarSeeAlsoGroupKey);
    this.mChildren[VarKey + "~"] = ChildEntry;

    // Add entry to see also collection if it is a see also entry
    //
    if (typeof(VarSeeAlsoKey) == "string")
    {
      WWHFrame.WWHFavorites.fAddSeeAlsoEntry(ChildEntry);
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
        ChildEntry.mBookLinks = new WWHFavoritesEntryBookHash_Object();
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

function  WWHFavoritesEntry_SortChildren(ParamEntry)
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

function  WWHFavoritesEntryHash_Object()
{
}

function  WWHFavoritesEntryBookHash_Object()
{
}

function  WWHSectionCache_Object()
{
}

function  WWHFavoritesOptions_Object()
{
  this.mThreshold     = 0;

  this.fSetThreshold = WWHFavoritesOptions_SetThreshold;
  this.fSetSeperator = WWHFavoritesOptions_SetSeperator;
}

function  WWHFavoritesOptions_SetThreshold(ParamThreshold)
{
  this.mThreshold = ParamThreshold;
}

function  WWHFavoritesOptions_SetSeperator(ParamSeperator)
{
  this.mSeperator = ParamSeperator;
}
