// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHTabs_Object(ParamPanels)
{
  this.mWidth = null;

  this.fReload   = WWHTabs_Reload;
  this.fHeadHTML = WWHTabs_HeadHTML;
//MGCRK - account for new history/favorites tab
//     this.fBodyHTML = WWHTabs_BodyHTML;
     this.fBodyHTML = WWHTabs_BodyHTML_MGC;
  this.fLoaded   = WWHTabs_Loaded;

  // Calculate width based on number of panels
  //
  if (ParamPanels > 0)
  {
//MGCRK - account for new history/favorites tab
//    if (WWHFrame.EnableHistory != "YES")
//    {
//WWHFrame.document.write("Favorites is enabled");
//      this.mGIFWidth = "" + (350 / ParamPanels) + "%";
//    }
//    else
//    {
      this.mWidth = "" + (100 / ParamPanels) + "%";
//    }
  }
}

function  WWHTabs_Reload()
{
  WWHFrame.WWHHelp.fReplaceLocation("WWHTabsFrame", WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/js/html/tabs.htm");
}

function  WWHTabs_HeadHTML()
{
  var  StylesHTML = "";


  // Generate style section
  //
  StylesHTML += "<style type=\"text/css\">\n";
  StylesHTML += " <!--\n";
  StylesHTML += "  a.active\n";
  StylesHTML += "  {\n";
  StylesHTML += "    text-decoration: none;\n";
  StylesHTML += "    color: " + WWHFrame.WWHJavaScript.mSettings.mTabs.mSelectedTabTextColor + ";\n";
  StylesHTML += "    " + WWHFrame.WWHJavaScript.mSettings.mTabs.mFontStyle + ";\n";
  StylesHTML += "  }\n";
  StylesHTML += "  a.inactive\n";
  StylesHTML += "  {\n";
  StylesHTML += "    text-decoration: none;\n";
  StylesHTML += "    color: " + WWHFrame.WWHJavaScript.mSettings.mTabs.mDefaultTabTextColor + ";\n";
  StylesHTML += "    " + WWHFrame.WWHJavaScript.mSettings.mTabs.mFontStyle + ";\n";
  StylesHTML += "  }\n";
  StylesHTML += "  th.tabs\n";
  StylesHTML += "  {\n";
  StylesHTML += "    height: 22px\;font-size:2px\;";
  StylesHTML += "    padding: 0px 0px\;";
  StylesHTML += "    color: " + WWHFrame.WWHJavaScript.mSettings.mTabs.mSelectedTabTextColor + ";\n";
  StylesHTML += "    " + WWHFrame.WWHJavaScript.mSettings.mTabs.mFontStyle + ";\n";
  StylesHTML += "  }\n";
  StylesHTML += "  td.tabs\n";
  StylesHTML += "  {\n";
  StylesHTML += "    height: 5px\;font-size:2px\;";
  StylesHTML += "    padding: 0px 0px\;";
  StylesHTML += "    color: " + WWHFrame.WWHJavaScript.mSettings.mTabs.mDefaultTabTextColor + ";\n";
  StylesHTML += "    " + WWHFrame.WWHJavaScript.mSettings.mTabs.mFontStyle + ";\n";
  StylesHTML += "  }\n";
  StylesHTML += "  td.Size3\n";
  StylesHTML += "  {\n";
  StylesHTML += "    height: 3px\;font-size:2px\;";
  StylesHTML += "    padding: 0px 0px\;";
  StylesHTML += "    color: " + WWHFrame.WWHJavaScript.mSettings.mTabs.mDefaultTabTextColor + ";\n";
  StylesHTML += "    " + WWHFrame.WWHJavaScript.mSettings.mTabs.mFontStyle + ";\n";
  StylesHTML += "  }\n";
  StylesHTML += "  td.Size5\n";
  StylesHTML += "  {\n";
  StylesHTML += "    height: 5px\;font-size:2px\;;";
  StylesHTML += "    padding: 0px 0px\;";
  StylesHTML += "    color: " + WWHFrame.WWHJavaScript.mSettings.mTabs.mDefaultTabTextColor + ";\n";
  StylesHTML += "    " + WWHFrame.WWHJavaScript.mSettings.mTabs.mFontStyle + ";\n";
  StylesHTML += "  }\n";
  StylesHTML += "  div.ContentTab\n";
  StylesHTML += "  {\n";
  StylesHTML += "    border: 0px solid green\;;";
  StylesHTML += "    background: white\;";
  StylesHTML += "  }\n";
  StylesHTML += " -->\n";
  StylesHTML += "</style>\n";

  return StylesHTML;
}

function  WWHTabs_BodyHTML_MGC()
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
  TabsHTML += "<div border=1 style=\"position: relative\; background-color:#FFFFFF\; left:0\;top:0\;height:3px\; font-size:2px\; \" ><img src=\"../../common/images/spc5w1h.gif\" border=\"0\" /></div>";
  TabsHTML += "<table border=0 cellspacing=0 cellpadding=0>\n";
  MaxTabIndex = 4;
  for (MaxIndex = MaxTabIndex, Index = 0 ; Index < MaxIndex ; Index++)
  {
    // Get tab title
    //
    VarTabTitle = TabTitles[Index];
    VarTabImage = "<img src=\"../../common/images/" + ActiveTabImage[Index] + "\" border=\"0\" hspace=\"0\" />";
    if ( (Index == 3) && (WWHFrame.OnSupportNet) )
    {
       VarTabImage = "<img src=\"../../common/images/mytopics_disable.png\" border=\"0\" hspace=\"0\" />";
    }

    // Display anchor only if not selected
    //
    if (Index == WWHFrame.WWHJavaScript.mCurrentTab) 
    {
        ThisTabTitle = TabTitles[Index];
      // Determine title for accessibility
      //
      VarAccessibilityTitle = " title=\"" + TabTitles[Index].replace("Favorites","My Topics") + " tab is active\"";
      CellType = "th";
      WrapPrefix = "<a class=\"active\" name=\"tab" + Index + "\" href=\"javascript:void(0);\"" + VarAccessibilityTitle + ">";
      if ( (Index == 3) && (WWHFrame.OnSupportNet) )
      {
         WrapPrefix = "<a class=\"active\" name=\"tab" + Index + "\" href=\"javascript:void(0);\"" + "title='My Topics is NOT Available on SupportNet'" + ">";
      }
      WrapSuffix = "</a>";
      OnClick = "";
    }
    else
    {
      VarTabImage = "<img src=\"../../common/images/" + NonActiveTabImage[Index] + "\" border=\"0\" />";
      if ( (Index == 3) && (WWHFrame.OnSupportNet) )
      {
        VarTabImage = "<img src=\"../../common/images/mytopics_disable.png\" border=\"0\" hspace=\"0\" />";
      }
      if (Index == MaxIndex-1)
      {
        ThisTabTitle = TabTitles[Index];
      }
      // Determine title for accessibility
      //
      VarAccessibilityTitle = " title=\"Switch to " + TabTitles[Index].replace("Favorites","My Topics") + " tab\"";
      CellType = "td";
      if (Index != 0)
         { WrapPrefix = "<a class=\"inactive\" name=\"tab" + Index + "\" href=\"javascript:WWHFrame.WWHJavaScript.fClickedChangeTab(" + Index + ");\"" + VarAccessibilityTitle + ">"; }
      else
        { WrapPrefix = "<a class=\"inactive\" name=\"tab" + Index + "\" href=\"javascript:MGC_ShowContents();\"" + VarAccessibilityTitle + ">"; }
       
      WrapSuffix = "</a>";
      if (Index != 0)
         { OnClick = " onClick=\"WWHFrame.WWHJavaScript.fClickedChangeTabWithDelay(" + Index + ");\""; }
      else
         { OnClick = " onClick=\"MGC_ShowContents();\""; }
      
    }
    if ( ( (Index == 3) && (WWHFrame.OnSupportNet) ) || (WWHFrame.MGCContent.MGCDocContent.DocTitle == "Search Tips"))
    {
       WrapPrefix = "<a class=\"active\" name=\"tab" + Index + "\" href=\"javascript:void(0);\"" + "title='My Topics is NOT Available on SupportNet'" + ">";
    }
//    TabsHTML += "<td class=\"tab\" valign=\"bottom\"bgcolor=\"#FFFFFF\">";
//    TabsHTML += "<table width=20% border=1 cellspacing=0 cellpadding=0 bgcolor=\"#FFFFFF\">";
//    TabsHTML += "<tr bgcolor=\"#FFFFFF\">";
//    TabsHTML += "<td class=\"tab\" width=\"" + TabWidth[Index] + "\" nowrap " + OnClick + ">";
    TabsHTML += "<td  width=\"" + TabWidth[Index] + "\" nowrap " + OnClick + ">";
//    if (Index == 0) { TabsHTML += "<div class='ContentTab' id='ContentTab'>\n"; }
//    if (Index == 3) { TabsHTML += "<div class='MyTopicsTab' id='MyTopicsTab'>\n"; }
    TabsHTML += WrapPrefix;
    TabsHTML += VarTabImage;
    TabsHTML += WrapSuffix;
//    if ( (Index == 0) || (Index == 3) )  { TabsHTML += "</div>"; }
    TabsHTML += "</td>" ;
//    TabsHTML += "</tr>";
//    TabsHTML += "</table>";
//    TabsHTML += "</td>\n";
//    if (Index == 0) { TabsHTML += "</div>"; }
  }
  CloseGif = "../../common/images/close.png";

  TabsHTML += "<td bgcolor=\"#FFFFFF\" nowrap " + "><img src=\"../../common/images/spc5w1h.gif\" border=\"0\" /></td>";
  TabsHTML += "<td nowrap bgcolor=\"#FFFFFF\" " + "><a href=\"javascript:WWHFrame.MGC_Display_Single_Topic()\" title=\"Hide Contents, Index, Search Tabs\"><img src=\"" + CloseGif + "\" border=0 vspace=0 /></a></td>";
  TabsHTML += "</tr>";
  TabsHTML += "</table>\n";
  TabsHTML += "<div border=1 style=\"position: relative\; background-color:#416E98\; left:0\; top:-7px\; height:7px\; font-size:5px\; \" ><img src=\"../../common/images/spc5w1h.gif\" border=\"0\" /></div>";
  return TabsHTML;
}

function MGC_ShowContents2()
{
  var WWHFrame = eval("parent.parent");
//  DocumentFramePath = WWHFrame.MGCContent.MGCDocContent
////  FramePath = WWHFrame.MGCContent.MGCDocContent;
  VarDocumentHandle = WWHFrame.MGCContent.MGCDocContent.DocHandle;
  VarDocumentTopic =  WWHFrame.MGCContent.MGCDocContent.PDFLinkTitle.replace(/./g,"");
  //alert("Handle is " + VarDocumentHandle + "\nTopic is " + VarDocumentTopic); 
  WWHFrame.window.location = WWHFrame.WWHHelp.mHelpURLPrefix + VarDocumentHandle + "/wwhelp.htm?context=" + VarDocumentHandle + "&topic=" + VarDocumentTopic;
//   alert ( "prefix is " + WWHFrame.WWHHelp.mHelpURLPrefix);
}
function MGC_InsertEnabledContentsTab()
{
   var ContentTabHTML = "";
   VarTabImage = "<img src=\"../../common/images/contents.png\" border=\"0\" hspace=\"0\" />";
   VarAccessibilityTitle = " title=\"Switch to Contents tab\"";
   WrapPrefix = "<a class=\"inactive\" name=\"tab0\" href=\"javascript:MGC_ShowContents();\"" + VarAccessibilityTitle + ">";
   WrapSuffix = "</a>";
   OnClick = " onClick=\"MGC_ShowContents();\"";
   ContentTabHTML += WrapPrefix;
   ContentTabHTML += VarTabImage;
   ContentTabHTML += WrapSuffix;
   UpdateContentsTab(ContentTabHTML);
}

function MGC_InsertDisabledContentsTab()
{
   var ContentTabHTML = "";
   VarTabImage = "<img src=\"../../common/images/contents_disable.png\" border=\"0\" hspace=\"0\" />";
   VarAccessibilityTitle = " title=\"Contents tab not available - no active document\"";
   WrapPrefix = "<a class=\"inactive\" name=\"tab0\" href=\"javascript:void(0);\"" + VarAccessibilityTitle + ">";
   WrapSuffix = "</a>";
   OnClick = " onClick=\"MGC_ShowContents();\"";
   ContentTabHTML += WrapPrefix;
   ContentTabHTML += VarTabImage;
   ContentTabHTML += WrapSuffix;
   UpdateContentsTab(ContentTabHTML);
}

function UpdateContentsTab(content)
{
   iState = 1;
   szDivID = "ContentTab";
   if (WWHFrame.MGCNavigate.MGCTabs.document.getElementById)	  //gecko(NN6) + IE 5+
   {
      WWHFrame.MGCNavigate.MGCTabs.document.getElementById(szDivID).innerHTML=content;
   }
   else if(WWHFrame.MGCNavigate.MGCTabs.document.all)	// IE 4
   {
      WWHFrame.MGCNavigate.MGCTabs.document.all[szDivID].innerHTML=content;
   }
}


function MGC_InsertEnabledMyTopicsTab()
{
   var ContentTabHTML = "";
   VarTabImage = "<img src=\"../../common/images/mytopics.png\" border=\"0\" hspace=\"0\" />";
   VarAccessibilityTitle = " title=\"Switch to My Topics tab\"";
   WrapPrefix = "<a class=\"inactive\" name=\"tab3\" href=\"javascript:WWHFrame.WWHJavaScript.fClickedChangeTabWithDelay('3');\"" + VarAccessibilityTitle + ">";
   WrapSuffix = "</a>";
   OnClick = " onClick=\"MGC_ShowContents();\"";
   ContentTabHTML += WrapPrefix;
   ContentTabHTML += VarTabImage;
   ContentTabHTML += WrapSuffix;
   UpdateMyTopicsTab(ContentTabHTML);
}

function MGC_InsertDisabledMyTopicsTab()
{
   var ContentTabHTML = "";
   VarTabImage = "<img src=\"../../common/images/mytopics_disable.png\" border=\"0\" hspace=\"0\" />";
   VarAccessibilityTitle = " title=\"My Topics tab not available - no active document\/topic\"";
   WrapPrefix = "<a class=\"inactive\" name=\"tab3\" href=\"javascript:void(0);\"" + VarAccessibilityTitle + ">";
   WrapSuffix = "</a>";
   OnClick = " onClick=\"MGC_ShowContents();\"";
   ContentTabHTML += WrapPrefix;
   ContentTabHTML += VarTabImage;
   ContentTabHTML += WrapSuffix;
   UpdateMyTopicsTab(ContentTabHTML);
}
function UpdateMyTopicsTab(content)
{
   iState = 1;
   szDivID = "MyTopicsTab";
   if (WWHFrame.MGCNavigate.MGCTabs.document.getElementById)	  //gecko(NN6) + IE 5+
   {
      WWHFrame.MGCNavigate.MGCTabs.document.getElementById(szDivID).innerHTML=content;
   }
   else if(WWHFrame.MGCNavigate.MGCTabs.document.all)	// IE 4
   {
      WWHFrame.MGCNavigate.MGCTabs.document.all[szDivID].innerHTML=content;
   }
}





function MGC_ShowContents()
{
  var WWHFrame = eval("parent.parent");
  if (WWHFrame.mHandle == "_a_search_tips")
  {
//     MGCNoContents();
//     return;
  }
  else
  {
  //alert("WWHFrame.MGCContent.MGCDocContent.name is " + WWHFrame.MGCContent.MGCDocContent.name);
  if (WWHFrame.NoSearchResults)
  {
    if (typeof(WWHFrame.mHandle) != "undefined")
    {
       WWHFrame.window.location = "../../../../" + WWHFrame.mHandle + "/wwhelp.htm";
    }
    else
    {
       if ((typeof(WWHFrame.WWHFrame.GetIHUBHandle()) != "undefined") && (WWHFrame.WWHFrame.GetIHUBHandle() != "NONE"))
       {
          WWHFrame.window.location = "../../../../../infohubs/" + WWHFrame.WWHFrame.GetIHUBHandle() + "/index.html";
       }
       else
       {
          WWHFrame.window.location = "../../../../../infohubs/index.html";
       }
    }
    return;
  }
  var Topic = WWHFrame.MGCContent.MGCDocContent.PDFLinkTitle.replace(/\./g,"");
  WWHFrame.window.location = WWHFrame.WWHHelp.mHelpURLPrefix + WWHFrame.MGCContent.MGCDocContent.DocHandle + "/wwhelp.htm?context=" + WWHFrame.MGCContent.MGCDocContent.DocHandle + "&topic=" + Topic;
}
}

function MGCNoContents()
{
   alert("Contents Tab is not available at this time because there is no active book.\nYou must either execute a search with results or open a specific book from the InfoHub.");
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


  // Setup table for tab display
  //
  TabsHTML += "<table border=5 cellspacing=0 cellpadding=0>\n";
  TabsHTML += "<tr bgcolor=\"#FFFFFF\"><td height=\"3\" colspan=6><img src=\"../../common/images/spc5w1h.gif\" border=\"0\" /></td></tr>";

  for (MaxIndex = WWHFrame.WWHJavaScript.mPanels.mPanelEntries.length, Index = 0 ; Index < MaxIndex ; Index++)
  {
    // Get tab title
    //
    VarTabTitle = WWHFrame.WWHJavaScript.mPanels.mPanelEntries[Index].mPanelObject.mPanelTabTitle;
    TabGif = "../../common/images/" + VarTabTitle + ".gif";

    // Display anchor only if not selected
    //
    if (Index == WWHFrame.WWHJavaScript.mCurrentTab)
    {
      TabGif = "../../common/images/" + VarTabTitle + "x.gif";
      // Determine title for accessibility
      //
      if (WWHFrame.WWHHelp.mbAccessible)
      {
        VarAccessibilityTitle = WWHStringUtilities_FormatMessage(WWHFrame.WWHJavaScript.mMessages.mAccessibilityActiveTab,
                                                                 VarTabTitle);
        VarAccessibilityTitle = " title=\"" + WWHStringUtilities_EscapeHTML(VarAccessibilityTitle) + "\"";
      }

      CellType = "th";
      BorderColor = WWHFrame.WWHJavaScript.mSettings.mTabs.mSelectedTabBorderColor;
      BackgroundColor = WWHFrame.WWHJavaScript.mSettings.mTabs.mSelectedTabColor;
      WrapPrefix = "<b><a class=\"active\" name=\"tab" + Index + "\" href=\"javascript:void(0);\"" + VarAccessibilityTitle + ">";
      WrapSuffix = "</a></b>";
      OnClick = "";
    }
    else
    {
      // Determine title for accessibility
      //
      if (WWHFrame.WWHHelp.mbAccessible)
      {
        VarAccessibilityTitle = WWHStringUtilities_FormatMessage(WWHFrame.WWHJavaScript.mMessages.mAccessibilityInactiveTab,
                                                                 VarTabTitle);
        VarAccessibilityTitle = " title=\"" + WWHStringUtilities_EscapeHTML(VarAccessibilityTitle) + "\"";
      }

      CellType = "td";
      BorderColor = WWHFrame.WWHJavaScript.mSettings.mTabs.mDefaultTabBorderColor;
      BackgroundColor = WWHFrame.WWHJavaScript.mSettings.mTabs.mDefaultTabColor;
      WrapPrefix = "<b><a class=\"inactive\" name=\"tab" + Index + "\" href=\"javascript:WWHFrame.WWHJavaScript.fClickedChangeTab(" + Index + ");\"" + VarAccessibilityTitle + ">";
      WrapSuffix = "</a></b>";
      OnClick = " onClick=\"WWHFrame.WWHJavaScript.fClickedChangeTabWithDelay(" + Index + ");\"";
    }

    TabsHTML += "<td  valign=\"bottom\"bgcolor=\"#FFFFFF\">";
    TabsHTML += "<table border=1 cellspacing=0 cellpadding=0 bgcolor=\"#FFFFFF\">";
    TabsHTML += "<tr bgcolor=\"#FFFFFF\">";
    TabsHTML += "<" + CellType + " nowrap " + OnClick + ">";
    TabsHTML += WrapPrefix;
    TabsHTML += VarTabImage;
    TabsHTML += WrapSuffix;
    TabsHTML += "</" + CellType + ">" ;
    TabsHTML += "</tr>";
    TabsHTML += "</table>";
    TabsHTML += "</td>\n";
  }

  TabsHTML += "</tr>\n";
  TabsHTML += "</table>\n";
  return TabsHTML;
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
