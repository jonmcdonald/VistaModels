// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHTabs_Object(ParamPanels)
{
  this.mWidth = null;

  this.fReload   = WWHTabs_Reload;
  this.fBodyHTML = WWHTabs_BodyHTML;
  this.fLoaded   = WWHTabs_Loaded;

  // Calculate width based on number of panels
  //
  if (ParamPanels > 0)
  {
     this.mWidth = "" + (100 / ParamPanels) + "%";
  }
}

function  WWHTabs_Reload()
{
  WWHFrame.WWHHelp.fReplaceLocation("WWHTabsFrame", WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/html/tabs.htm");
}


function  WWHTabs_BodyHTML()
{
  var  TabsHTML = "";
  var  Height = 24;
  var  MaxIndex;
  var  Index;
  var  VarTabTitle;
  var  VarAccessibilityTitle = "";
  var  CellType;
  var  BorderColor;
  var  BackgroundColor;
  var  WrapPrefix;
  var  WrapSuffix;
  var  OnClick;
  var  TabGif;
  var  TabTitles = new Array();
  var  NonActiveTabTitles = new Array();
  var  ActiveTabImage = new Array();
  var  NonActiveTabImage = new Array();
  var  HighlightTabImage = new Array();
  var  TabWidth = new Array();

  TabTitles[0] = "Contents";
  TabTitles[1] = "Index";
  TabTitles[2] = "Search";
  TabTitles[3] = "Favorites";
  NonActiveTabImage[0] = "contents.png";
  NonActiveTabImage[1] = "index.png";
  NonActiveTabImage[2] = "search.png";
  NonActiveTabImage[3] = "mytopics.png";
  ActiveTabImage[0] = "contents_x.png";
  ActiveTabImage[1] = "index_x.png";
  ActiveTabImage[2] = "search_x.png";
  ActiveTabImage[3] = "mytopics_x.png";
  HighlightTabImage[0] = "contents_h.png";
  HighlightTabImage[1] = "index_h.png";
  HighlightTabImage[2] = "search_h.png";
  HighlightTabImage[3] = "mytopics_h.png";
  TabWidth[0] = "64";
  TabWidth[1] = "44";
  TabWidth[2] = "51";
  TabWidth[3] = "69";


  // Setup table for tab display
  //
  TabsHTML += "<table border=0 cellspacing=0 cellpadding=0>\n";
  TabsHTML += "<tr bgcolor=\"#FFFFFF\"><td height=\"3\" colspan=6><img src=\"../../common/images/spc5w1h.gif\" border=\"0\" /></td></tr>";
  for (MaxIndex = 4, Index = 0 ; Index < MaxIndex ; Index++)
  {
    // Get tab title
    //
    VarTabTitle = TabTitles[Index];
    VarTabImage = "<img src=\"../../common/images/" + ActiveTabImage[Index] + "\" border=\"0\" hspace=\"0\"/>";

    // Display anchor only if not selected
    //
    if (Index == WWHFrame.WWHJavaScript.mCurrentTab)
    {
      // Determine title for accessibility
      //
      if (WWHFrame.WWHHelp.mbAccessible)
      {
        VarAccessibilityTitle = WWHStringUtilities_FormatMessage(WWHFrame.WWHJavaScript.mMessages.mAccessibilityActiveTab,
                                                                 VarTabTitle);
        VarAccessibilityTitle = " title=\"" + WWHStringUtilities_EscapeHTML(VarAccessibilityTitle) + "\"";
      }
      if ( (Index == 3)  && (WWHFrame.OnSupportNet) )
      {
         WrapPrefix = "<a class=\"active\" name=\"tab" + Index + "\" href=\"javascript:void(0);\"" + "title='My Topics is NOT Available on SupportNet'" + ">";
      }
      CellType = "th";
      WrapPrefix = "<b><a class=\"active\" name=\"tab" + Index + "\" href=\"javascript:void(0);\"" + VarAccessibilityTitle + ">";
      WrapSuffix = "</a></b>";
      OnClick = "";
    }
    else
    {
      VarTabImage = "<img src=\"../../common/images/" + NonActiveTabImage[Index] + "\" border=\"0\" />";
      if ( (Index == 3) && (WWHFrame.OnSupportNet) )
      {
        VarTabImage = "<img src=\"../../common/images/mytopics_disable.png\" border=\"0\" hspace=\"0\" />";
      }
      ThisTabTitle = NonActiveTabTitles[Index];
      if (Index == MaxIndex-1)
      {
        ThisTabTitle = TabTitles[Index];
      }
      // Determine title for accessibility
      //
      if (WWHFrame.WWHHelp.mbAccessible)
      {
        VarAccessibilityTitle = WWHStringUtilities_FormatMessage(WWHFrame.WWHJavaScript.mMessages.mAccessibilityInactiveTab,
                                                                 VarTabTitle).replace("Favorites","My Topics");
        VarAccessibilityTitle = " title=\"" + WWHStringUtilities_EscapeHTML(VarAccessibilityTitle).replace("Favorites","My Topics") + "\"";
      }
      CellType = "td";
      switch (Index)
      {
         case 0: WrapPrefixLink = "\" href=\"javascript:WWHFrame.WWHJavaScript.fClickedChangeTab(" + Index + ");\""; break;
         case 1: WrapPrefixLink = "\" href=\"javascript:WWHFrame.MGCOpenTab(" + Index + ");\""; break;
         case 2: WrapPrefixLink = "\" href=\"javascript:WWHFrame.MGCOpenTab(" + Index + ");\""; break;
         case 3: WrapPrefixLink = "\" href=\"javascript:WWHFrame.MGCOpenTab(" + Index + ");\""; break;
         default: WrapPrefixLink = "\" href=\"javascript:WWHFrame.MGCOpenTab(0);\"";
      }

      WrapPrefix = "<a class=\"inactive\" name=\"tab" + Index + WrapPrefixLink + VarAccessibilityTitle + ">";
      WrapSuffix = "</a>";
      OnClick = " onClick=\"WWHFrame.WWHJavaScript.fClickedChangeTabWithDelay(" + Index + ");\"";
    }
    if ( (Index == 3)  && (WWHFrame.OnSupportNet) )
    {
       WrapPrefix = "<a class=\"active\" name=\"tab" + Index + "\" href=\"javascript:void(0);\"" + "title='My Topics is NOT Available on SupportNet'" + ">";
    }
    TabsHTML += "<td  valign=\"bottom\"bgcolor=\"#FFFFFF\">";
    TabsHTML += "<table border=0 cellspacing=0 cellpadding=0 bgcolor=\"#FFFFFF\">";
    TabsHTML += "<tr bgcolor=\"#FFFFFF\">";
    TabsHTML += "<" + CellType + " width=\"" + TabWidth[Index] + "\" nowrap " + OnClick + ">";
    TabsHTML += WrapPrefix;
    TabsHTML += VarTabImage;
    TabsHTML += WrapSuffix;
    TabsHTML += "</" + CellType + ">" ;
    TabsHTML += "</tr>";
    TabsHTML += "</table>";
    TabsHTML += "</td>\n";
  }
  CloseGif = "../../common/images/close.png";
  TabsHTML += "<" + CellType + " bgcolor=\"#FFFFFF\" nowrap " + ">&nbsp;&nbsp;</" + CellType + ">";
  TabsHTML += "<" + CellType + " nowrap bgcolor=\"#FFFFFF\" " + "><a href=\"javascript:WWHFrame.MGC_Display_Single_Topic()\" title=\"Hide Contents, Index, Search Tabs\"><img src=\"" + CloseGif + "\" border=0 \/></" + CellType + "></a>";
  TabsHTML += "</tr>\n";
  TabsHTML += "<tr bgcolor=\"#416E98\"><td bgcolor=\"#416E98\" height=\"5\" colspan=6>&nbsp;</td></tr>";
  TabsHTML += "</table>\n";
  return TabsHTML;
}

function MGCOpenTab(index)
{
   ihub = WWHFrame.MGCContent.MGCDocContent.IHUBHandle;
   var page = new String(WWHFrame.MGCContent.MGCDocContent.location);
   var pos = page.lastIndexOf("/") + 1;
   var File = page.substr(pos);
   var ReturnDoc = WWHFrame.MGCContent.MGCDocContent.DocHandle;
   var CurrentDoc = WWHFrame.DocumentHandle;
//alert("Index is " + index + "\nlocation is ../../../../../wwhelp.htm\?href=" + ReturnDoc + "/" + File);
   switch (index)
   {
      case 1: WWHFrame.location = "../../../../../wwhelp.htm\?href=" + ReturnDoc + "/" + File + "\&tab=index"  + "&ihub=" + ihub; break;
      case 2: WWHFrame.location = "../../../../../wwhelp.htm\?href=" + ReturnDoc + "/" + File + "\&tab=search"  + "&ihub=" + ihub; break;
      case 3: WWHFrame.location = "../../../../../wwhelp.htm\?href=" + ReturnDoc + "/" + File + "\&tab=favorites"  + "&ihub=" + ihub; break;
      default: URL = WWHFrame.location;
   }
}

function  WWHTabs_Loaded()
{
  // Set frame name for accessibility
  //
  if (WWHFrame.WWHHelp.mbAccessible)
  {
    WWHFrame.WWHHelp.fSetFrameName("WWHTabsFrame");
  }

  // Display requested panel
  //
  WWHFrame.WWHJavaScript.mPanels.fChangePanel(WWHFrame.WWHJavaScript.mCurrentTab);
}
