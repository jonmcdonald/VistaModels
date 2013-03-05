// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHJavaScript_Object()
{
  this.mSettings           = new WWHJavaScriptSettings_Object();
  this.mMessages           = new WWHJavaScriptMessages_Object();
  this.mInitialTab         = -1;
  this.mbClickedChangeTab  = false;
  this.mbChangingTabs      = false;
  this.mCurrentTab         = -1;
  this.mPanels             = null;
  this.mTabs               = null;
  this.mMaxHTMLSegmentSize = 8192;  // Best tested value is 8192

  this.fInit                      = WWHJavaScript_Init;
  this.fClickedChangeTab          = WWHJavaScript_ClickedChangeTab;
  this.fClickedChangeTabWithDelay = WWHJavaScript_ClickedChangeTabWithDelay;
  this.fStartChangeTab            = WWHJavaScript_StartChangeTab;
  this.fEndChangeTab              = WWHJavaScript_EndChangeTab;
  this.fSyncTOC                   = WWHJavaScript_SyncTOC;

  // Load up messages
  //
  this.mMessages.fSetByLocale(WWHFrame.WWHBrowser.mLocale);

  // Disable hover text for accessibility or if popups are not supported
  //
  if (( ! WWHFrame.WWHBrowser.mbSupportsPopups) ||
      (WWHFrame.WWHHelp.mbAccessible))
  {
    this.mSettings.mHoverText.mbEnabled = false;
  }
}

function  WWHJavaScript_Init()
{
  // Create panels and tabs objects
  //
  this.mPanels = new WWHPanels_Object();
  this.mTabs   = new WWHTabs_Object(this.mPanels.mPanelEntries.length);


  // Determine initial tab setting
  //
  switch (WWHFrame.WWHHelp.mInitialTabName)
  {
    case "contents":
      this.mInitialTab = WWHFrame.WWHOutline.mPanelTabIndex;
      break;

    case "index":
      this.mInitialTab = WWHFrame.WWHIndex.mPanelTabIndex;
      break;

    case "search":
      this.mInitialTab = WWHFrame.WWHSearch.mPanelTabIndex;
      break;
    case "favorites":
      this.mInitialTab = WWHFrame.WWHFavorites.mPanelTabIndex;
      break;
    case "history":
      this.mInitialTab = WWHFrame.WWHHistory.mPanelTabIndex;
      break;

  }
  if (this.mInitialTab < 0)
  {
    this.mInitialTab = 0;
  }

  // Complete initialization process
  //
  if ( ! WWHFrame.WWHHandler.mbInitialized)
  {
    WWHFrame.WWHHandler.mbInitialized = true;
    WWHFrame.WWHHelp.fHandlerInitialized();
  }
}

function  WWHJavaScript_ClickedChangeTab(ParamIndex)
{
  if ( ! this.mbClickedChangeTab)
  {
    // Change tabs
    //
    this.mbClickedChangeTab = true;
    this.fStartChangeTab(ParamIndex);
//    window.open("../html/tabs.htm");
  }
}

function  WWHJavaScript_ClickedChangeTabWithDelay(ParamIndex)
{
  setTimeout("WWHFrame.WWHJavaScript.fClickedChangeTab(" + ParamIndex + ");", 1);
}

function  WWHJavaScript_StartChangeTab(ParamIndex)
{
  if (( ! this.mbChangingTabs) &&
      (this.mCurrentTab != ParamIndex))
  {
    // Signal that we are changing tabs
    //
    this.mbChangingTabs = true;

    // Update tab index
    //
    this.mCurrentTab = ParamIndex;

    // Update tab frame
    //
    this.mTabs.fReload();
  }
}

function  WWHJavaScript_EndChangeTab()
{
  if (this.mbClickedChangeTab)
  {
    this.mbClickedChangeTab = false;
  }

  // Signal that the change tab process is complete
  //
  this.mbChangingTabs = false;

  // Perform additional processing if initial tab specified
  //
  if (WWHFrame.WWHHelp.mInitialTabName == "contents")
  {
    WWHFrame.WWHHelp.mInitialTabName = null;
    WWHFrame.WWHHelp.mbAutoSyncTOC = true;
  }
  setTimeout("WWHFrame.WWHHelp.fAutoSyncTOC();", 1);
}

function  WWHJavaScript_SyncTOC(ParamBookIndex,
                                ParamFileIndex,
                                ParamAnchor,
                                bParamReportError)
{
  var  TabIndex;
  var  Index;


  // Confirm TOC is available as a tab
  //
  if (this.mSettings.mTOC.mbShow)
  {
    // Confirm file is part of a known book
    //
    if ((ParamBookIndex >= 0) &&
        (ParamFileIndex >= 0))
    {
      // Determine visibility
      //
      if (this.mPanels.fGetCurrentPanelObject().mPanelTabTitle == this.mMessages.mTabsTOCLabel)
      {
        // Sync TOC
        //
        WWHFrame.WWHOutline.fSync(ParamBookIndex, ParamFileIndex, ParamAnchor, true, bParamReportError);
      }
      else
      {
        // Determine tab to display for TOC
        //
        TabIndex = -1;
        Index = 0;
        while ((TabIndex == -1) &&
               (Index < WWHFrame.WWHJavaScript.mPanels.mPanelEntries.length))
        {
          if (WWHFrame.WWHJavaScript.mPanels.mPanelEntries[Index].mPanelObject.mPanelTabTitle == WWHFrame.WWHJavaScript.mMessages.mTabsTOCLabel)
          {
            TabIndex = Index;
          }

          Index++;
        }

        // Display contents tab and sync
        //
        if (TabIndex != -1)
        {
          // Force auto sync on tab display
          //
          WWHFrame.WWHHelp.mInitialTabName = "contents";
          WWHFrame.WWHJavaScript.fStartChangeTab(TabIndex);
        }
      }
    }
  }
}
//MGCRK - new function to open help on search/other mini-helps
function openIt(url) 
   {
       chrome = "width=500," 
         + "height=400," 
         + "location=0," 
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

