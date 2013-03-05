// Copyright (c) 2001-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHJavaScriptSettings_Object()
{
  this.mHoverText = new WWHJavaScriptSettings_HoverText_Object();

  this.mTabs   = new WWHJavaScriptSettings_Tabs_Object();
  this.mTOC    = new WWHJavaScriptSettings_TOC_Object();
  this.mIndex  = new WWHJavaScriptSettings_Index_Object();
  this.mSearch = new WWHJavaScriptSettings_Search_Object();
  this.mFavorites = new WWHJavaScriptSettings_Favorites_Object();
//  this.mHistory = new WWHJavaScriptSettings_History_Object();
}

function  WWHJavaScriptSettings_HoverText_Object()
{
  this.mbEnabled = true;
//MGCRK - added code to determine UNIX vs PC to adjust text size
  textsize = 11;
  if (WWHFrame.operatingsystem == "Unix")
     textsize = 15;

  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + textsize + "px;";

  this.mWidth = 150;
//MGCRK - modified to match popups in index pane

//  this.mForegroundColor = "#FFFFFF";
//  this.mBackgroundColor = "#999999";
//  this.mBorderColor     = "#FFFFFF";
  this.mForegroundColor = "#000000";
  this.mBackgroundColor = "#F6F6DC";
  this.mBorderColor     = "#cccc99";
}

function  WWHJavaScriptSettings_Tabs_Object()
{
  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 11px";
//  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 10pt";
  //MGCRK increased font size if on UNIX
//  if (WWHFrame.BaseFontSize == 3)
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 12pt";
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 14px";
//  }

  this.mSelectedTabColor       = "#1E1D78";
  this.mSelectedTabBorderColor = "#333333";
  this.mSelectedTabTextColor   = "#FFFFFF";

  this.mDefaultTabColor       = "#BFBFC4";
  this.mDefaultTabBorderColor = "#666666";
  this.mDefaultTabTextColor   = "#000000";
}

function  WWHJavaScriptSettings_TOC_Object()
{
  this.mbShow = true;
  WWHFrame = eval("parent.parent");
  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  if (WWHFrame.BaseFontSize == 3)
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 14px";
//  }
//  else
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 11px";
//  }
  this.mHighlightColor = "#CCCCCC";
  this.mEnabledColor   = "blue";
//  this.mEnabledColor   = "#315585";
  this.mDisabledColor  = "black";

  this.mIndent = 17;
}

function  WWHJavaScriptSettings_Index_Object()
{
  this.mbShow = true;

  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + (WWHFrame.BaseNavFontSize-3) + "px;";
//  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";

  this.mHighlightColor = "#CCCCCC";
  this.mEnabledColor   = "#315585";
  this.mDisabledColor  = "black";

  this.mIndent = 17;

  this.mNavigationFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + (WWHFrame.BaseNavFontSize-4) + "px;";
//  this.mNavigationFontStyle      = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 7pt ; font-weight: bold";
  this.mNavigationCurrentColor   = "black";
  this.mNavigationHighlightColor = "#CCCCCC";
  this.mNavigationEnabledColor   = "#315585";
  this.mNavigationDisabledColor  = "#999999";
}

function  WWHJavaScriptSettings_Index_DisplayOptions(ParamIndexOptions)
{
  ParamIndexOptions.fSetThreshold(500);
  ParamIndexOptions.fSetSeperator(" - ");
}

function  WWHJavaScriptSettings_Search_Object()
{
  this.mbShow = true;

  WWHFrame = eval("parent.parent");
  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  if (WWHFrame.BaseFontSize == 3)
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 12pt";
//  }
//  else
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
//  }

  this.mHighlightColor = "#CCCCCC";
  this.mEnabledColor   = "#315585";
  this.mDisabledColor  = "black";

  this.mIndent = 17;

  this.mbResultsByBook = true;
  this.mbShowRank      = true;
}

function  WWHJavaScriptSettings_Favorites_Object()
{
  this.mbShow = true;

  WWHFrame = eval("parent.parent");
  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  if (WWHFrame.BaseFontSize == 3)
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 12pt";
//  }
//  else
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
//  }

  this.mHighlightColor = "#CCCCCC";
  this.mEnabledColor   = "#315585";
  this.mDisabledColor  = "black";

  this.mIndent = 17;

  this.mbResultsByBook = true;
  this.mbShowRank      = true;
}
function  WWHJavaScriptSettings_Favorites_DisplayOptions(ParamIndexOptions)
{
  ParamIndexOptions.fSetThreshold(500);
  ParamIndexOptions.fSetSeperator(" - ");
}
function  WWHJavaScriptSettings_History_Object()
{
  this.mbShow = true;

  WWHFrame = eval("parent.parent");
  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  if (WWHFrame.BaseFontSize == 3)
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 12pt";
//  }
//  else
//  {
//    this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
//  }

  this.mHighlightColor = "#CCCCCC";
  this.mEnabledColor   = "#315585";
  this.mDisabledColor  = "black";

  this.mIndent = 17;

  this.mbResultsByBook = true;
  this.mbShowRank      = true;
}
function  WWHJavaScriptSettings_History_DisplayOptions(ParamIndexOptions)
{
  ParamIndexOptions.fSetThreshold(500);
  ParamIndexOptions.fSetSeperator(" - ");
}
