// Copyright (c) 2001-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHCommonSettings_Object()
{
  this.mTitle = "ic_da_olh";

  this.mbCookies            = true;
  this.mCookiesDaysToExpire = 30;
  this.mCookiesID           = "SMFRTRKS";

  this.mAccessible       = "true";
  this.mbForceJavaScript = true;

  this.mbSyncContentsEnabled  = true;
  this.mbPrevEnabled          = true;
  this.mbNextEnabled          = true;
  this.mbRelatedTopicsEnabled = false;
  this.mbEmailEnabled         = false;
  this.mbPrintEnabled         = false;
  this.mbBookmarkEnabled      = false;

  this.mEmailAddress = "regis_krug@mentor.com";

  this.mRelatedTopics = new WWHCommonSettings_RelatedTopics_Object();
  this.mALinks        = new WWHCommonSettings_ALinks_Object();
  this.mPopup         = new WWHCommonSettings_Popup_Object();

  this.mbHighlightingEnabled        = true;
  this.mHighlightingForegroundColor = "#FFFFFF";
  this.mHighlightingBackgroundColor = "#333399";
}

function  WWHCommonSettings_RelatedTopics_Object()
{
  this.mWidth = 250;

  this.mTitleFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  this.mTitleFontStyle       = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 10pt";
  this.mTitleForegroundColor = "#FFFFFF";
  this.mTitleBackgroundColor = "#003399";

  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + (WWHFrame.BaseNavFontSize-3) + "px;";
//  this.mFontStyle       = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
  this.mForegroundColor = "#003399";
  this.mBackgroundColor = "#FFFFFF";
  this.mBorderColor     = "#666666";

  this.mbInlineEnabled = false;
  this.mInlineFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  this.mInlineFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 10pt";
  this.mInlineForegroundColor = "#003366";
}

function  WWHCommonSettings_ALinks_Object()
{
  this.mbShowBook = false;

  this.mWidth  = 250;
  this.mIndent = 17;

  this.mTitleFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + WWHFrame.BaseNavFontSize + "px;";
//  this.mTitleFontStyle       = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 10pt";
  this.mTitleForegroundColor = "#FFFFFF";
  this.mTitleBackgroundColor = "#999999";

  this.mFontStyle = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: " + (WWHFrame.BaseNavFontSize-3) + "px;";
//  this.mFontStyle       = "font-family: Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
  this.mForegroundColor = "#003399";
  this.mBackgroundColor = "#FFFFFF";
  this.mBorderColor     = "#666666";
}

function  WWHCommonSettings_Popup_Object()
{
  this.mWidth = 200;

  this.mBackgroundColor = "#FFFFCC";
  this.mBorderColor     = "#999999";
}
