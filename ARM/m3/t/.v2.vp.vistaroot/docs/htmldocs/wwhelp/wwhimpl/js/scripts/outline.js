// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHOutline_Object()
{
  var  bUseSafeMethods = true;


  // Determine display method based on browser type
  //
  if ((WWHFrame.WWHBrowser.mBrowser == 2) ||  // Shorthand for IE
      (WWHFrame.WWHBrowser.mBrowser == 3) ||  // Shorthand for iCab
      (WWHFrame.WWHBrowser.mBrowser == 4) ||  // Shorthand for Netscape 6.0 (Mozilla)
      (WWHFrame.WWHBrowser.mBrowser == 5))    // Shorthand for Safari
  {
    bUseSafeMethods = false;
  }

  this.mbPanelInitialized = false;
  this.mPanelAnchor       = null;
  this.mPanelTabTitle     = WWHFrame.WWHJavaScript.mMessages.mTabsTOCLabel;
  this.mPanelTabIndex     = -1;
  this.mPanelFilename     = "panelvie.htm";
  this.mInitIndex         = 0;
  this.mBookEntryArray    = new Array();
  this.mEntryHash         = new WWHOutlineEntryHash_Object();
  this.mTopEntry          = new WWHOutlineEntry_Top_Object();
  this.mNextEntryID       = 0;
  this.mMaxLevel          = 0;
  this.mSyncBookIndex     = null;
  this.mSyncFileIndex     = null;
  this.mSyncAnchor        = null;
  this.mImagingObject     = (bUseSafeMethods) ? new WWHOutlineImagingSafe_Object() : new WWHOutlineImagingFast_Object();

  this.fInitHeadHTML          = WWHOutline_InitHeadHTML;
  this.fInitBodyHTML          = WWHOutline_InitBodyHTML;
  this.fInitGroupings         = WWHOutline_InitGroupings;
  this.fInitLoadBookTOC       = WWHOutline_InitLoadBookTOC;
  this.fHeadHTML              = WWHOutline_HeadHTML;
  this.fClickedExpand         = WWHOutline_ClickedExpand;
  this.fClickedCollapse       = WWHOutline_ClickedCollapse;
  this.fClickedDisplayDoc     = WWHOutline_ClickedDisplayDoc;
  this.fStartHTMLSegments     = WWHOutline_StartHTMLSegments;
  this.fAdvanceHTMLSegment    = WWHOutline_AdvanceHTMLSegment;
  this.fGetHTMLSegment        = WWHOutline_GetHTMLSegment;
  this.fEndHTMLSegments       = WWHOutline_EndHTMLSegments;
  this.fPanelNavigationLoaded = WWHOutline_PanelNavigationLoaded;
  this.fPanelViewLoaded       = WWHOutline_PanelViewLoaded;
  this.fHoverTextTranslate    = WWHOutline_HoverTextTranslate;
  this.fHoverTextFormat       = WWHOutline_HoverTextFormat;
  this.fExpand                = WWHOutline_Expand;
  this.fCollapse              = WWHOutline_Collapse;
  this.fDisplayDoc            = WWHOutline_DisplayDoc;
  this.fSync                  = WWHOutline_Sync;
}

function  WWHOutline_InitHeadHTML()
{
  var  InitHeadHTML = "";


  return InitHeadHTML;
}

function  WWHOutline_InitBodyHTML()
{
  var  HTML = new WWHStringBuffer_Object();
  var  BookList = WWHFrame.WWHHelp.mBooks.mBookList;
  var  MaxIndex;
  var  Index;

  // Display initializing message
  //
  HTML.fAppend("<h2>" + WWHFrame.WWHJavaScript.mMessages.mInitializingMessage + "</h2>\n");

  // Create top level entries for groups and books
  //
  this.fInitGroupings(this.mTopEntry, WWHFrame.WWHHelp.mBookGroups);

  // Load book TOC data
  //
  this.mInitIndex = 0;
  for (MaxIndex = BookList.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
    // Reference TOC data
    //
      HTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(BookList[Index].mDirectory) + "wwhdata/js/toc.js\"></script>\n");

      // Load TOC data for current book
      //
      HTML.fAppend("<script language=\"JavaScript1.2\" src=\"" + WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/scripts/outlin1s.js\"></script>\n");
  }

  return HTML.fGetBuffer();
}

function  WWHOutline_InitGroupings(ParamParentEntry,
                                   ParamGroup)
{
  var  MaxIndex;
  var  Index;
  var  GroupEntry;
  var  TOCEntry;
  var MyHandle = WWHFrame.mHandle + "/";
alert("Handle for current doc is: " + WWHFrame.mHandle);
  for (MaxIndex = ParamGroup.mChildren.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
    GroupEntry = ParamGroup.mChildren[Index];
    if (GroupEntry.mbGrouping)
    {
      // Create entry in TOC
      //
      TOCEntry = ParamParentEntry.fNewChild(GroupEntry.mTitle, "", GroupEntry.mIcon, GroupEntry.mOpenIcon);
      TOCEntry.mbExpanded = GroupEntry.mbExpand;

      this.fInitGroupings(TOCEntry, GroupEntry);
    }
    else  // Must be a book directory
    {
      TOCEntry = ParamParentEntry.fNewChild(WWHFrame.WWHHelp.mBooks.mBookList[this.mBookEntryArray.length].mTitle, "", GroupEntry.mIcon, GroupEntry.mOpenIcon);
      ShowDoc = false;
//MGCRK - If this is not the current manual, disable showing it's TOC so only one book is ever displayed in the TOC tab
if (MyHandle == WWHFrame.WWHHelp.mBooks.mBookList[this.mBookEntryArray.length].mDirectory)
{ 
  GroupEntry.mbShow = true;
}
else
{ 
  GroupEntry.mbShow = false;
//  GroupEntry.mbExpand = false;
}
      // Set display options
      //
      TOCEntry.mbShow = GroupEntry.mbShow;
      if (GroupEntry.mbShow)
      {
        TOCEntry.mbExpanded = GroupEntry.mbExpand;
      }
      else
      {
        TOCEntry.mbExpanded = true;
        TOCEntry.mLevel     = ParamParentEntry.mLevel;
      }
if (MyHandle == WWHFrame.WWHHelp.mBooks.mBookList[this.mBookEntryArray.length].mDirectory)
{
        TOCEntry.mbExpanded = true;
}
else
{
        TOCEntry.mbExpanded = false;
}

      // Add to mBookEntryArray
      //
      this.mBookEntryArray[this.mBookEntryArray.length] = TOCEntry;
    }
  }
}

function  WWHOutline_InitLoadBookTOC(ParamAddTOCEntriesFunc)
{
  var  BookEntry;

  // Access book entry
  //
  BookEntry = this.mBookEntryArray[this.mInitIndex];
  // Set Book Index
  //
  BookEntry.mBookIndex = this.mInitIndex;
  //
  ParamAddTOCEntriesFunc(BookEntry);

  // Assign URL for book entry
  //
  if ( (BookEntry.mbShow) &&
      (WWHFrame.WWHHelp.mBooks.mBookList[BookEntry.mBookIndex].mFiles.mFileList.length > 0))
  {
    BookEntry.mURL = "0";
  }

  // Increment init book index
  //
  this.mInitIndex++;

  // Mark initialized if done
  //
  if (this.mInitIndex == WWHFrame.WWHHelp.mBooks.mBookList.length)
  {
    this.mbPanelInitialized = true;

    // Sync contents if necessary
    //
    if ((this.mSyncBookIndex != null) &&
        (this.mSyncFileIndex != null)
        (this.mSyncAnchor != null))
    {
      this.fSync(this.mSyncBookIndex, this.mSyncFileIndex, this.mSyncAnchor, false);

      this.mSyncBookIndex = null;
      this.mSyncFileIndex = null;
      this.mSyncAnchor    = null;
    }
  }
}

function  WWHOutline_HeadHTML()
{
  var  HTML = new WWHStringBuffer_Object();


  // Write formatting styles
  //
  HTML.fAppend(this.mImagingObject.fGenerateStyles());
  return HTML.fGetBuffer();
}

function  WWHOutline_ClickedExpand(ParamEntryID)
{
  var  VarAnchorPrefix;
//alert(ParamEntryID);

  // Expand
  //
  this.fExpand(ParamEntryID);

  // Set focus
  //
  if (WWHFrame.WWHHelp.mbAccessible)
  {
    VarAnchorPrefix = "t";
  }
  else
  {
    VarAnchorPrefix = "tb";
  }
  WWHFrame.WWHHelp.fFocus("WWHPanelViewFrame", VarAnchorPrefix + ParamEntryID);
}

function  WWHOutline_ClickedCollapse(ParamEntryID)
{
  var  VarAnchorPrefix;


  // Collapse
  //
  this.fCollapse(ParamEntryID);

  // Set focus
  //
  if (WWHFrame.WWHHelp.mbAccessible)
  {
    VarAnchorPrefix = "t";
  }
  else
  {
    VarAnchorPrefix = "tb";
  }
  WWHFrame.WWHHelp.fFocus("WWHPanelViewFrame", VarAnchorPrefix + ParamEntryID);
}

function  WWHOutline_ClickedDisplayDoc(ParamEntryID)
{
  this.fDisplayDoc(ParamEntryID);
}

function  WWHOutline_StartHTMLSegments()
{
  var  HTML = new WWHStringBuffer_Object();


  // Reset imaging object
  //
  this.mImagingObject.fReset();

  // Define accessor functions to reduce file size
  //
  HTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\">\n");
  HTML.fAppend(" <!--\n");
  HTML.fAppend("  function  fE(ParamEntryID)\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHOutline.fClickedExpand(ParamEntryID);\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("\n");
  HTML.fAppend("  function  fC(ParamEntryID)\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHOutline.fClickedCollapse(ParamEntryID);\n");
  HTML.fAppend("  }\n");
  HTML.fAppend("\n");
  HTML.fAppend("  function  fD(ParamEntryID)\n");
  HTML.fAppend("  {\n");
  HTML.fAppend("    WWHFrame.WWHOutline.fClickedDisplayDoc(ParamEntryID);\n");
  HTML.fAppend("    WWHFrame.ClickedTOC=ParamEntryID;\n");
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

function  WWHOutline_AdvanceHTMLSegment()
{
  return this.mImagingObject.fAdvance(WWHFrame.WWHJavaScript.mMaxHTMLSegmentSize);
}

function  WWHOutline_GetHTMLSegment()
{
  return this.mImagingObject.mHTMLSegment.fGetBuffer();
}

function  WWHOutline_EndHTMLSegments()
{
  return "";
}

function  WWHOutline_PanelNavigationLoaded()
{
}

function  WWHOutline_PanelViewLoaded()
{
  // Restore focus
  //
  WWHFrame.WWHHelp.fFocus("WWHPanelViewFrame");
}

function  WWHOutline_HoverTextTranslate(ParamEntryID)
{
  return this.mEntryHash[ParamEntryID].mText;
}

function  WWHOutline_HoverTextFormat(ParamWidth,
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

function  WWHOutline_Expand(ParamEntryID)
{
  var  Entry = this.mEntryHash[ParamEntryID];


  Entry.mbExpanded = true;
  this.mImagingObject.fUpdateEntry(Entry);
}

function  WWHOutline_Collapse(ParamEntryID)
{
  var  Entry = this.mEntryHash[ParamEntryID];


  Entry.mbExpanded = false;
  this.mImagingObject.fUpdateEntry(Entry);
}

function  WWHOutline_DisplayDoc(ParamEntryID)
{
  var  Entry;
  var  Parent;
  var  Parts;
  var  LinkFileIndex;
  var  LinkAnchor;
  var  BookListEntry;
  var  URL;


  // Close down any popups we had going to prevent JavaScript errors
  //
  WWHFrame.WWHJavaScript.mPanels.mPopup.fHide();

  // Access entry
  //
  Entry = this.mEntryHash[ParamEntryID];

  // Determine which book this document belongs to
  //
  Parent = Entry;
  while ((typeof(Parent.mBookIndex) != "number") &&
         (Parent.mParent != null))
  {
    Parent = Parent.mParent;
  }

  if (typeof(Parent.mBookIndex) == "number")
  {
    // Confirm URL defined (handles group entries)
    //
    if (Entry.mURL.length > 0)
    {
      // Determine link file index and anchor
      //
      Parts = Entry.mURL.split("#");
      LinkFileIndex = parseInt(Parts[0]);
      LinkAnchor = null;
      if (Parts.length > 1)
      {
        if (Parts[1].length > 0)
        {
          LinkAnchor = Parts[1];
        }
      }

      URL = WWHFrame.WWHHelp.fGetBookIndexFileIndexURL(Parent.mBookIndex, LinkFileIndex, LinkAnchor);
      WWHFrame.WWHHelp.fSetDocumentHREF(URL, false);
    }
  }

  // Expand/collapse view as needed
  //
  if (Entry.mbExpanded)
  {
    // Collapse folder if Accessible
    //
    if (WWHFrame.WWHHelp.mbAccessible)
    {
      this.fCollapse(ParamEntryID);

      // Set focus
      //
      WWHFrame.WWHHelp.fFocus("WWHPanelViewFrame", "t" + ParamEntryID);
    }
  }
  else
  {
    // Expand if folder
    //
    if (Entry.mChildren != null)
    {
      this.fExpand(ParamEntryID);

      // Set focus
      //
      WWHFrame.WWHHelp.fFocus("WWHPanelViewFrame", "t" + ParamEntryID);
    }
  }
}

function  WWHOutline_Sync(ParamBookIndex,
                          ParamFileIndex,
                          ParamAnchor,
                          bParamVisible,
                          bParamReportError)
{
  var  BookEntry;
  var  MaxIndex;
  var  Index;
  var  SearchPattern;
  var  Iterator;
  var  MatchedEntry;
  var  CandidateEntry;


  if ( ! this.mbPanelInitialized)
  {
    this.mSyncBookIndex = ParamBookIndex;
    this.mSyncFileIndex = ParamFileIndex;
    this.mSyncAnchor    = ParamAnchor;
  }
  else  // (this.mbPanelInitialized)
  {
    BookEntry = null;
    MatchedEntry = null;

    // Find book entry
    //
    if (this.mBookEntryArray.length > 0)
    {
      // Find matching book entry
      //
      for (MaxIndex = this.mBookEntryArray.length, Index = 0 ; Index < MaxIndex ; Index++)
      {
        if (this.mBookEntryArray[Index].mBookIndex == ParamBookIndex)
        {
          BookEntry = this.mBookEntryArray[Index];
        }
      }
    }

    // Confirm we found our matching book entry
    //
    if (BookEntry != null)
    {
      // Confirm we have a possible entry
      //
      if (ParamFileIndex != -1)
      {
        SearchPattern = "" + ParamFileIndex + ParamAnchor;
        Iterator = new WWHOutlineIterator_Object(false);

        if (ParamAnchor.length > 0)
        {
          // Look for match
          //
          Iterator.fReset(BookEntry);
          while ((MatchedEntry == null) &&
                 (Iterator.fAdvance(null)))
          {
            if (Iterator.mEntry.mURL == SearchPattern)
            {
              MatchedEntry = Iterator.mEntry;
            }
          }
        }

        // If match not found, search using just the file index without the anchor
        //
        if (MatchedEntry == null)
        {
          SearchPattern = "" + ParamFileIndex;

          // Look for match
          //
          Iterator.fReset(BookEntry);
          while ((MatchedEntry == null) &&
                 (Iterator.fAdvance(null)))
          {
            // Trim of any trailing anchor information, if specified
            //
            if (Iterator.mEntry.mURL.indexOf("#") != -1)
            {
              CandidateEntry = Iterator.mEntry.mURL.substring(0, Iterator.mEntry.mURL.indexOf("#"));
            }
            else
            {
              CandidateEntry = Iterator.mEntry.mURL;
            }

            if (CandidateEntry == SearchPattern)
            {
              MatchedEntry = Iterator.mEntry;
            }
          }
        }

        // See if this matches the book entry
        //
        if ((MatchedEntry == null) &&
            (BookEntry.mbShow))
        {
          SearchPattern = "" + ParamFileIndex;

          if (SearchPattern == BookEntry.mURL)
          {
            MatchedEntry = BookEntry;
          }
        }

        // Sync display if entry found
        //
        if (MatchedEntry != null)
        {
          // Update display
          //
	          this.mImagingObject.fRevealEntry(MatchedEntry, bParamVisible);
        }
      }
    }

    // Display a message if the entry was not found
    //
    if (bParamReportError)
    {
      if ((BookEntry == null) ||
          (MatchedEntry == null))
      {
        setTimeout("alert(\"" + WWHFrame.WWHJavaScript.mMessages.mTOCFileNotFoundMessage + "\");", 1);
      }
    }
  }
}

function  WWHOutlineEntry_Top_Object()
{
  this.mParent    = null;
  this.mbShow     = false;
  this.mText      = "Top Level";
  this.mURL       = "";
  this.mID        = -1;
  this.mLevel     = -1;
  this.mbExpanded = true;
  this.mChildren  = null;

  this.fNewChild = WWHOutlineEntry_NewChild;
  this.fN        = WWHOutlineEntry_NewChild;
}

function  WWHOutlineEntry_Object(ParamParent,
                                 ParamText,
                                 ParamURL,
                                 ParamIcon,
                                 ParamOpenIcon)
{
  this.mParent    = ParamParent;
  this.mbShow     = true;
  this.mText      = ParamText;
  this.mURL       = (typeof(ParamURL) == "string") ? ParamURL : "";
  this.mID        = WWHFrame.WWHOutline.mNextEntryID;
  this.mLevel     = ParamParent.mLevel + 1;
  this.mbExpanded = false;
  this.mChildren  = null;

  this.fNewChild = WWHOutlineEntry_NewChild;
  this.fN        = WWHOutlineEntry_NewChild;

  // Assign custom icons if defined
  //
  if (typeof(ParamIcon) == "string")
  {
    this.mIcon = ParamIcon;
  }
  if (typeof(ParamOpenIcon) == "string")
  {
    this.mOpenIcon = ParamOpenIcon;
  }

  // Increment ID
  //
  WWHFrame.WWHOutline.mNextEntryID++;
}

function  WWHOutlineEntry_NewChild(ParamText,
                                   ParamURL,
                                   ParamIcon,
                                   ParamOpenIcon)
{
  var  NewChild;


  // Create a new entry
  //
  NewChild = new WWHOutlineEntry_Object(this, ParamText, ParamURL, ParamIcon, ParamOpenIcon);

  // Expand top level entries, if necessary
  //
  if (NewChild.mLevel == 0)
  {
    if (WWHFrame.WWHHelp.mBookGroups.mbExpandAllAtTop)
    {
      NewChild.mbExpanded = true;
    }
  }

  // Add to entry hash keyed by ID
  //
  WWHFrame.WWHOutline.mEntryHash[NewChild.mID] = NewChild;

  // Add child to parent entry
  //
  if (this.mChildren == null)
  {
    this.mChildren = new Array(NewChild);
  }
  else
  {
    this.mChildren[this.mChildren.length] = NewChild;
  }

  // Bump mMaxLevel if we've exceeded it
  //
  if (NewChild.mLevel > WWHFrame.WWHOutline.mMaxLevel)
  {
    WWHFrame.WWHOutline.mMaxLevel = NewChild.mLevel;
  }

  return NewChild;
}

function  WWHOutlineEntryHash_Object()
{
}

function  WWHOutlineIterator_Object(bParamVisibleOnly)
{
  this.mbVisibleOnly  = bParamVisibleOnly;
  this.mIteratorScope = null;
  this.mEntry         = null;
  this.mStack         = new Array();

  this.fReset   = WWHOutlineIterator_Reset;
  this.fAdvance = WWHOutlineIterator_Advance;
}

function  WWHOutlineIterator_Reset(ParamEntry)
{
  this.mIteratorScope = ParamEntry;
  this.mEntry         = ParamEntry;
  this.mStack.length  = 0;
}

function  WWHOutlineIterator_Advance(ParamLevelStatusObject)
{
  var  bSameLevel;
  var  ParentEntry;
  var  StackTop;


  // Advance to the next visible entry
  //
  if (this.mEntry != null)
  {
    // Check for visible children
    //
    if ((this.mEntry.mChildren != null) &&
        (( ! this.mbVisibleOnly) ||
         (this.mEntry.mbExpanded)))
    {
      // Process children
      //
      this.mEntry = this.mEntry.mChildren[0];
      this.mStack[this.mStack.length] = 0;

      if (ParamLevelStatusObject != null)
      {
        ParamLevelStatusObject.fOpenLevel();
      }
    }
    // If we've reached the iterator scope, we're done
    //
    else if (this.mEntry.mID == this.mIteratorScope.mID)
    {
      this.mEntry = null;
    }
    else
    {
      bSameLevel = true;
      ParentEntry = this.mEntry.mParent;
      this.mEntry = null;

      // Find next child of parent entry
      //
      while (ParentEntry != null)
      {
        // Increment position
        //
        StackTop = this.mStack.length - 1;
        this.mStack[StackTop]++;

        // Confirm this is a valid entry
        //
        if (this.mStack[StackTop] < ParentEntry.mChildren.length)
        {
          // Return the parent's next child
          //
          this.mEntry = ParentEntry.mChildren[this.mStack[StackTop]];

          // Signal break from loop
          //
          ParentEntry = null;
        }
        else
        {
          // Last child of parent, try up a level
          //
          if (ParentEntry.mID == this.mIteratorScope.mID)
          {
            ParentEntry = null;
          }
          else
          {
            ParentEntry = ParentEntry.mParent;
          }

          this.mStack.length--;

          bSameLevel = false;

          if (ParamLevelStatusObject != null)
          {
            ParamLevelStatusObject.fCloseLevel(ParentEntry == null);
          }
        }
      }

      if (bSameLevel)
      {
        if (ParamLevelStatusObject != null)
        {
          ParamLevelStatusObject.fSameLevel();
        }
      }
    }
  }

  return (this.mEntry != null);
}

function  WWHOutlineImaging_ImageSrcDir()
{
  var  ImageSrcDir = "../../../";


  // Update img src reference based on browser type and platform
  //
  if ((WWHFrame.WWHBrowser.mBrowser == 2) &&  // Shorthand for IE
      (WWHFrame.WWHBrowser.mPlatform == 2))   // Shorthand for Macintosh
  {
    ImageSrcDir = WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/";
  }

  return ImageSrcDir;
}

function  WWHOutlineImaging_GetIconURL(ParamEntry)
{
  var  IconURL = "";


  if (ParamEntry.mChildren != null)
  {
    if (ParamEntry.mbExpanded)
    {
      if (typeof(ParamEntry.mOpenIcon) == "string")
      {
        IconURL = this.mImageSrcDir + "images/" + ParamEntry.mOpenIcon;
      }
      else if (typeof(ParamEntry.mIcon) == "string")
      {
        IconURL = this.mImageSrcDir + "images/" + ParamEntry.mIcon;
      }
      else
      {
        IconURL = this.mImageSrcDir + "wwhimpl/common/images/minus.gif";
      }
    }
    else
    {
      if (typeof(ParamEntry.mIcon) == "string")
      {
        IconURL = this.mImageSrcDir + "images/" + ParamEntry.mIcon;
      }
      else
      {
        IconURL = this.mImageSrcDir + "wwhimpl/common/images/plus.gif";
      }
    }
  }
  else
  {
    if (typeof(ParamEntry.mIcon) == "string")
    {
      IconURL = this.mImageSrcDir + "images/" + ParamEntry.mIcon;
    }
    else
    {
      IconURL = this.mImageSrcDir + "wwhimpl/common/images/doc2.gif";
    }
  }

  return IconURL;
}

function  WWHOutlineImaging_GetPopupAction(ParamEntry)
{
  var  PopupAction = "";


  if (WWHFrame.WWHJavaScript.mSettings.mHoverText.mbEnabled)
  {
    PopupAction += " onMouseOver=\"fS(" + ParamEntry.mID + ", " + this.mEventString + ");\"";
    PopupAction += " onMouseOut=\"fH();\"";
  }

  return PopupAction;
}

function  WWHOutlineImaging_GetLink(ParamEntry,
                                    bParamForIcon)
{
  var  VarLink;
  var  VarAccessibilityMessage;
  var  VarAccessibilityTitle = "";
  var  VarSiblings;
  var  VarMaxIndex;
  var  VarIndex;
  var  VarIDPrefix;


  // Initialize return value
  //
  VarLink = "";

  // Determine title for accessibility
  //
  if (WWHFrame.WWHHelp.mbAccessible)
  {
    // Determine if this is a book or a topic
    //
    if (ParamEntry.mChildren != null)
    {
      if (ParamEntry.mbExpanded)
      {
        VarAccessibilityMessage = WWHFrame.WWHJavaScript.mMessages.mAccessibilityTOCBookExpanded;
      }
      else
      {
        VarAccessibilityMessage = WWHFrame.WWHJavaScript.mMessages.mAccessibilityTOCBookCollapsed;
      }
    }
    else
    {
      VarAccessibilityMessage = WWHFrame.WWHJavaScript.mMessages.mAccessibilityTOCTopic;
    }

    // Format message
    //
    VarAccessibilityTitle = WWHStringUtilities_FormatMessage(VarAccessibilityMessage,
                                                             ParamEntry.mText);

    // Add position information
    //
    if (ParamEntry.mParent != null)
    {
      VarSiblings = ParamEntry.mParent.mChildren;
      VarMaxIndex = VarSiblings.length;
      VarIndex = 0;
      while (VarIndex < VarMaxIndex)
      {
        if (VarSiblings[VarIndex].mID == ParamEntry.mID)
        {
          // Record position
          //
          VarAccessibilityTitle += " " + WWHStringUtilities_FormatMessage(WWHFrame.WWHJavaScript.mMessages.mAccessibilityTOCOneOfTotal,
                                                                          (VarIndex + 1),
                                                                          VarMaxIndex);

          // Exit loop
          //
          VarIndex = VarMaxIndex;
        }

        VarIndex += 1;
      }
    }

    VarAccessibilityTitle = WWHStringUtilities_EscapeHTML(VarAccessibilityTitle);
    VarAccessibilityTitle = " title=\"" + VarAccessibilityTitle + "\"";
  }

  // Set link
  //
  if ((ParamEntry.mURL.length > 0) ||
      (ParamEntry.mChildren != null))
  {
    if (bParamForIcon)
    {
      VarIDPrefix = "tb";
    }
    else
    {
      VarIDPrefix = "t";
    }
    ActiveEntry = "";
//    if (WWHFrame.ClickedTOC == ParamEntry.mID)
//    {  ActiveEntry = "<b>"; }
//alert(WWHFrame.ClickedTOC);
    VarLink += ActiveEntry;
    VarLink += "<a name=\"" + VarIDPrefix + ParamEntry.mID + "\" href=\"javascript:fD(" + ParamEntry.mID + ");\"" + VarAccessibilityTitle;
    VarLink += this.fGetPopupAction(ParamEntry) + ">";
  }

  return VarLink;
}

function  WWHOutlineImaging_GetEntryHTML(ParamEntry)
{
  var  EntryHTML = "";
  var  IconURL;
  var  VarLink;


  EntryHTML += "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
  EntryHTML += "<tr>";
  if (ParamEntry.mLevel > 0)
  {
    EntryHTML += "<td valign=\"top\" width=\"" + (WWHFrame.WWHJavaScript.mSettings.mTOC.mIndent * ParamEntry.mLevel) + "\">";
    EntryHTML += "<img width=\"" + (WWHFrame.WWHJavaScript.mSettings.mTOC.mIndent * ParamEntry.mLevel) + "\" height=\"2\" border=\"0\" src=\"" + this.mImageSrcDir + "wwhimpl/common/images/spc1w2h.gif\">";
    EntryHTML += "</td>";
  }
  EntryHTML += "<td valign=\"top\" width=\"19\">";
//  EntryHTML += "<nobr>";

  IconURL = this.fGetIconURL(ParamEntry);
  if ((WWHFrame.WWHHelp.mbAccessible) ||
      (ParamEntry.mChildren == null))
  {
    VarLink = this.fGetLink(ParamEntry, true);
    if (VarLink.length > 0)
    {
      EntryHTML += VarLink;
    }
    EntryHTML += "<img width=\"17\" height=\"17\" border=\"0\" src=\"" + IconURL + "\">";
    EntryHTML += "<img width=\"2\" height=\"1\" border=\"0\" src=\"" + this.mImageSrcDir + "wwhimpl/common/images/spc2w1h.gif\">";
    if (VarLink.length > 0)
    {
      EntryHTML += "</a>";
    }

    EntryHTML += "</nobr>";
    EntryHTML += "</td>";
    EntryHTML += "<td valign=\"top\">";
 //   EntryHTML += "<nobr>";

    VarLink = this.fGetLink(ParamEntry, false);
    if (VarLink.length > 0)
    {
      EntryHTML += VarLink;
    }
    EntryHTML += ParamEntry.mText;
    if (VarLink.length > 0)
    {
      EntryHTML += "</a>";
    }
  }
  else
  {
    if (ParamEntry.mbExpanded)
    {
      EntryHTML += "<a name=\"tb" + ParamEntry.mID + "\" href=\"javascript:fC(" + ParamEntry.mID + ");\"" + this.fGetPopupAction(ParamEntry) + ">";
    }
    else
    {
      EntryHTML += "<a name=\"tb" + ParamEntry.mID + "\" href=\"javascript:fE(" + ParamEntry.mID + ");\"" + this.fGetPopupAction(ParamEntry) + ">";
    }
    EntryHTML += "<img width=\"17\" height=\"17\" border=\"0\" src=\"" + IconURL + "\"></a>";
    EntryHTML += "<img width=\"2\" height=\"1\" border=\"0\" src=\"" + this.mImageSrcDir + "wwhimpl/common/images/spc2w1h.gif\">";

    EntryHTML += "</nobr>";
    EntryHTML += "</td>";
    EntryHTML += "<td valign=\"top\">";
//    EntryHTML += "<nobr>";

    VarLink = this.fGetLink(ParamEntry, false);
    if (VarLink.length > 0)
    {
      EntryHTML += VarLink;
    }
    EntryHTML += ParamEntry.mText;
    if (VarLink.length > 0)
    {
      EntryHTML += "</b></a>";
    }
  }

  EntryHTML += "</nobr>";
  EntryHTML += "</td>";
  EntryHTML += "</tr>";
  EntryHTML += "</table>";

  return EntryHTML;
}
