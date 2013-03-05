// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//
// Security Patch: dts0100640734 

function  WWHControlEntry_Object(ParamControlName,
                                 bParamEnabled,
                                 bParamStatus,
                                 ParamLabel,
                                 ParamIconEnabled,
                                 ParamIconDisabled,
                                 ParamAnchorMethod,
                                 ParamFrameName)
{
  this.mControlName  = ParamControlName;
  this.mbEnabled     = bParamEnabled;
  this.mbStatus      = bParamStatus;
  this.mLabel        = ParamLabel;
  this.mIconEnabled  = ParamIconEnabled;
  this.mIconDisabled = ParamIconDisabled;
  this.mAnchorMethod = ParamAnchorMethod;
  this.mFrameName    = ParamFrameName;

  this.fSetStatus  = WWHControlEntry_SetStatus;
  this.fGetIconURL = WWHControlEntry_GetIconURL;
  this.fGetHTML    = WWHControlEntry_GetHTML;
  this.fGetLabel   = WWHControlEntry_GetLabel;
  this.fUpdateIcon = WWHControlEntry_UpdateIcon;
}

function  WWHControlEntry_SetStatus(bParamStatus)
{
  if (this.mbEnabled)
  {
    this.mbStatus = bParamStatus;
  }
  else
  {
    this.mbStatus = false;
  }
}

function  WWHControlEntry_GetIconURL()
{
  var  VarIconURL = "";


  if (this.mbEnabled)
  {
    // Create absolute path to icon
    //
    VarIconURL += WWHFrame.WWHHelp.mHelpURLPrefix;
    VarIconURL += "wwhelp/wwhimpl/common/images/";

    // Determine which icon to return
    //
    if (this.mbStatus)
    {
      VarIconURL += this.mIconEnabled;
    }
    else
    {
      VarIconURL += this.mIconDisabled;
    }
  }

  return VarIconURL;
}

function  WWHControlEntry_GetHTML()
{
  var  VarHTML = "";
  var  VarLabel;
  if (this.mbEnabled)
  {
    // Set label
    //
    VarLabel = this.mLabel;
    if (WWHFrame.WWHHelp.mbAccessible)
    {
      if ( ! this.mbStatus)
      {
        VarLabel = WWHStringUtilities_FormatMessage(WWHFrame.WWHHelp.mMessages.mAccessibilityDisabledNavigationButton, this.mLabel);
        VarLabel = WWHStringUtilities_EscapeHTML(VarLabel);
      }
    }
    VarLabel = WWHStringUtilities_EscapeHTML(VarLabel);

    // Display control
    //
//RKMGC modified to width of 29 to support our icons, except prev/next to pull them tight together.
//    VarHTML += "  <td width=\"23\">";
//    VarHTML += "  <td width=\"29\">";
    Iwidth = 29;
    if ( (this.mControlName == "WWHPrevIcon") || (this.mControlName == "WWHNextIcon") )
       { Iwidth = 27; }
    VarHTML += "  <td width=\"" + Iwidth + "\">";
//    var PrevButton = "<td><a href=\"javascript:WWHFrame.WWHControls.fClickedPrevious()\"><img src=\"../images/prev.png\" title=\"Display Previous Topic\" border=\"0\"  /></a></td>\n";
//    var NextButton = "<td><a href=\"javascript:WWHFrame.WWHControls.fClickedNext()\"><img src=\"../images/next.png\" title=\"Display Next Topic\" border=\"0\"  /></a></td>\n";
//    if ( (this.mControlName == "WWHPrevIcon") || (this.mControlName == "WWHNextIcon") )
//    {
//       if (this.mControlName == "WWHPrevIcon")
//          { VarHTML += PrevButton; }
//       else
//          { VarHTML += NextButton; }
//    }
//    else
//    {
       VarHTML += "<a name=\"" + this.mControlName + "\" href=\"javascript:WWHFrame.WWHControls." + this.mAnchorMethod + "();\" title=\"" + VarLabel + "\">";
       //RKMGC modified to width of 29 and removed width to autoscale to support our icons
       VarHTML += "<img name=\"" + this.mControlName + "\" alt=\"" + VarLabel + "\" border=\"0\" src=\"" + this.fGetIconURL() + "\">";
       VarHTML += "</a>";
//    }
    VarHTML += "</td>\n";
  }
  return VarHTML;
}


function  WWHControlEntry_GetLabel()
{
  var  VarLabel = "";


  if (this.mbEnabled)
  {
    // Set label
    //
    VarLabel = this.mLabel;
  }

  return VarLabel;
}

function MGCIconMouseover(icon)
{
   IconPath = "../images/";
   SIcon = icon + ".png";
   switch (icon)
   {
      case "home" : IconIndex = 0;break;
      case "prev" : IconIndex = 1;break;
      case "next" : IconIndex = 2;break;
      default : IconIndex = 0;
   }
   HoverIcon = WWHFrame.MGCContent.MGCDocNav.MGCDocNavL.document.images[IconIndex].src;
   parts = HoverIcon.split("/");
   mIcon = parts[(parts.length-1)];
   if (mIcon == SIcon)
   {
      WWHFrame.MGCContent.MGCDocNav.MGCDocNavL.document.images[IconIndex].src = IconPath + icon + "_h.png";
   }
}

function MGCIconMouseout(icon)
{
   IconPath = "../images/";
   SIcon = icon + "_h.png";
   switch (icon)
   {
      case "home" : IconIndex = 0;break;
      case "prev" : IconIndex = 1;break;
      case "next" : IconIndex = 2;break;
      default : IconIndex = 0;
   }
   HoverIcon = WWHFrame.MGCContent.MGCDocNav.MGCDocNavL.document.images[IconIndex].src;
   parts = HoverIcon.split("/");
   mIcon = parts[(parts.length-1)];
   if (mIcon == SIcon)
   {
      WWHFrame.MGCContent.MGCDocNav.MGCDocNavL.document.images[IconIndex].src = IconPath + icon + ".png";
   }
}





function  WWHControlEntry_UpdateIcon()
{
  var  VarControlDocument;
//alert("Updating icon for " + this.mControlName);
  IconIndex = 1;
  if (this.mControlName == "WWHNextIcon")
     { IconIndex = 2; }
  if (this.mbEnabled)
  {
    // Access control document
    //
    VarControlDocument = eval(WWHFrame.WWHHelp.fGetFrameReference(this.mFrameName) + ".document");

    // Update icon
    //
//    VarControlDocument.images[this.mControlName].src = this.fGetIconURL();
//mbStatus   enableRolloverImg(elem,name,enable)

//    VarControlDocument.images[IconIndex].src = this.fGetIconURL();
//WWHFrame.enableRolloverImg(VarControlDocument.images[IconIndex],this.mControlName,this.mbStatus)
    VarControlDocument.images[IconIndex].src = this.fGetIconURL();
  }
}

function  WWHControlEntry_UpdateIconOrg()
{
  var  VarControlDocument;
//  return;
  if (this.mbEnabled)
  {
    // Access control document
    //
  IconIndex = 0;
  if (this.mControlName == "WWHPrevIcon")
     { IconIndex = 1; }
  if (this.mControlName == "WWHNextIcon")
     { IconIndex = 2; }
    VarControlDocument = eval(WWHFrame.WWHHelp.fGetFrameReference(this.mFrameName) + ".document");
//    VarControlDocument = WWHFrame.MGCContent.MGCDocNav.MGCDocNavL + ".document";
//alert("LOCATION is " + VarControlDocument.location + " \nIMAGES are " + VarControlDocument.images[1].src);
//alert("WWHFrame.mSyncPrevNext[2] is " + WWHFrame.mSyncPrevNext[2]);
//alert("WWHFrame.MGCContent.MGCDocNav.MGCDocNavL.location " + WWHFrame.MGCContent.MGCDocNav.MGCDocNavL.location);

    // Update icon
    //
//    VarControlDocument.images[this.mControlName].src = this.fGetIconURL();
    VarControlDocument.images[IconIndex].src = this.fGetIconURL();
  }
}





function  WWHControlEntries_Object()
{
}

function  WWHControls_Object()
{
  this.mControls      = new WWHControlEntries_Object();
  this.mSyncPrevNext  = new Array(null, null, null);
  this.mFocusedFrame  = "";
  this.mFocusedAnchor = "";

  this.fReloadControls        = WWHControls_ReloadControls;
  this.fControlsLoaded        = WWHControls_ControlsLoaded;
  this.fAddControl            = WWHControls_AddControl;
  this.fGetControl            = WWHControls_GetControl;
  this.fInitialize            = WWHControls_Initialize;
  this.fSansNavigation        = WWHControls_SansNavigation;
  this.fCanSyncTOC            = WWHControls_CanSyncTOC;
  this.fLeftHTML              = WWHControls_LeftHTML;
  this.fRightHTML             = WWHControls_RightHTML;
  this.fLeftFrameTitle        = WWHControls_LeftFrameTitle;
  this.fRightFrameTitle       = WWHControls_RightFrameTitle;
  this.fUpdateHREF            = WWHControls_UpdateHREF;
  this.fRecordFocus           = WWHControls_RecordFocus;
  this.fRestoreFocus          = WWHControls_RestoreFocus;
  this.fSwitchToNavigation    = WWHControls_SwitchToNavigation;
  this.fClickedShowNavigation = WWHControls_ClickedShowNavigation;
  this.fClickedSyncTOC        = WWHControls_ClickedSyncTOC;
  this.fClickedPrevious       = WWHControls_ClickedPrevious;
  this.fClickedNext           = WWHControls_ClickedNext;
  this.fClickedRelatedTopics  = WWHControls_ClickedRelatedTopics;
  this.fClickedEmail          = WWHControls_ClickedEmail;
  this.fClickedPrint          = WWHControls_ClickedPrint;
  this.fShowNavigation        = WWHControls_ShowNavigation;
  this.fSyncTOC               = WWHControls_SyncTOC;
  this.fPrevious              = WWHControls_Previous;
  this.fNext                  = WWHControls_Next;
  this.fRelatedTopics         = WWHControls_RelatedTopics;
  this.fEmail                 = WWHControls_Email;
  this.fPrint                 = WWHControls_Print;
  this.fProcessAccessKey      = WWHControls_ProcessAccessKey;

}

function  WWHControls_ReloadControls()
{
  // Load the left frame it it will cascade and load the other frames
  //
  WWHFrame.WWHHelp.fReplaceLocation("WWHControlsLeftFrame", WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/common/html/controll.htm");
}

function  WWHControls_ControlsLoaded(ParamDescription)
{
  if (ParamDescription == "left")
  {
    WWHFrame.WWHHelp.fReplaceLocation("WWHControlsRightFrame", WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/common/html/controlr.htm");
  }
  else if (ParamDescription == "right")
  {
    WWHFrame.WWHHelp.fReplaceLocation("WWHTitleFrame", WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/common/html/title.htm");
  }
  else  // (ParamDescription == "title")
  {
    if ( ! WWHFrame.WWHHelp.mbInitialized)
    {
      // All control frames are now loaded
      //
      WWHFrame.WWHHelp.fInitStage(5);
    }
    else
    {
      // Restore previous focus
      //
      this.fRestoreFocus();
    }
  }
}

function  WWHControls_AddControl(ParamControlName,
                                 bParamEnabled,
                                 bParamStatus,
                                 ParamLabel,
                                 ParamIconEnabled,
                                 ParamIconDisabled,
                                 ParamAnchorMethod,
                                 ParamFrameName)
{
  var  VarControlEntry;


  VarControlEntry = new WWHControlEntry_Object(ParamControlName,
                                               bParamEnabled,
                                               bParamStatus,
                                               ParamLabel,
                                               ParamIconEnabled,
                                               ParamIconDisabled,
                                               ParamAnchorMethod,
                                               ParamFrameName);

  this.mControls[ParamControlName + "~"] = VarControlEntry;
}

function  WWHControls_GetControl(ParamControlName)
{
  var  VarControlEntry;


  VarControlEntry = this.mControls[ParamControlName + "~"];
  if (typeof(VarControlEntry) == "undefined")
  {
    VarControlEntry = null;
  }

  return VarControlEntry;
}

function  WWHControls_Initialize()
{
  var  VarSettings;
  var  VarDocumentFrame;
//MGCRK Check to see if icons should be enabled.
//If this is a popup, or single topic mode with icons disabled
//we need to prevent display of all left control icons.
//
  MGCPopup = "NO";
  if (WWHFrame.popup == undefined)
  {
     MGCPopup = "NO";
  }
  else
  {
     MGCPopup = WWHFrame.popup;
  }
  var  ShowIcons = "NO";
  if (MGCPopup == "NO")
  {
     var  ShowIcons = "YES";
  }
  DocPage = unescape(WWHFrame.MGCContent.MGCDocContent.location);
  path = DocPage.split("/");
  book = path[path.length-2];
  file = path[path.length-1];
  WWHFrame.FFile = file;
  if ( (file == "searching_for_text.html") || (file == "global_search2.html") ) { WWHFrame.NavIconsEnabled = "DISABLE"; }

  if (WWHFrame.NavIconsEnabled == "DISABLE")
  {
     var  ShowIcons = "NO";
  }


  // Access settings
  //
  VarSettings = WWHFrame.WWHHelp.mSettings;
//MGCRK - disable prev/next icons if popup or nav disabled

  if (ShowIcons == "NO")
  {
    VarSettings.mbNextEnabled = false;
    VarSettings.mbPrevEnabled = false;
  }

  // Confirm Sync TOC can be enabled
  //
  if (this.fSansNavigation())
  {
    VarSettings.mbSyncContentsEnabled = false;
  }
  // Confirm E-mail can be enabled
  //
  if (VarSettings.mbEmailEnabled)
  {
    VarSettings.mbEmailEnabled = ((typeof(VarSettings.mEmailAddress) == "string") &&
                                  (VarSettings.mEmailAddress.length > 0));
  }

  // Confirm Print can be enabled
  //
  if (VarSettings.mbPrintEnabled)
  {
    VarDocumentFrame = eval(WWHFrame.WWHHelp.fGetFrameReference("WWHTitleFrame"));
    VarSettings.mbPrintEnabled = ((typeof(VarDocumentFrame.focus) != "undefined") &&
                                  (typeof(VarDocumentFrame.print) != "undefined"))
  }
  // MGCRK - for global, disable default print & email
  VarSettings.mbEmailEnabled = false;
  VarSettings.mbPrintEnabled = false;


  // Create control entries
  //
  this.fAddControl("WWHFrameSetIcon", this.fSansNavigation(), this.fSansNavigation(),
                   WWHFrame.WWHHelp.mMessages.mShowNavigationIconLabel,
                   "frameset.png", "frameset.gif", "fClickedShowNavigation", "WWHControlsLeftFrame");
  this.fAddControl("WWHSyncTOCIcon", VarSettings.mbSyncContentsEnabled, false,
                   WWHFrame.WWHHelp.mMessages.mSyncIconLabel,
                   "sync.gif", "syncx.gif", "fClickedSyncTOC", "WWHControlsLeftFrame");
  this.fAddControl("WWHPrevIcon", VarSettings.mbPrevEnabled, false,
                   WWHFrame.WWHHelp.mMessages.mPrevIconLabel,
                   "prev.png", "prev_x.png", "fClickedPrevious", "WWHControlsLeftFrame");
  this.fAddControl("WWHNextIcon", VarSettings.mbNextEnabled, false,
                   WWHFrame.WWHHelp.mMessages.mNextIconLabel,
                   "next.png", "next_x.png", "fClickedNext", "WWHControlsLeftFrame");
  this.fAddControl("WWHRelatedTopicsIcon", VarSettings.mbRelatedTopicsEnabled, false,
                   WWHFrame.WWHHelp.mMessages.mRelatedTopicsIconLabel,
                   "related.gif", "relatedx.gif", "fClickedRelatedTopics", "WWHControlsRightFrame");
  this.fAddControl("WWHEmailIcon", VarSettings.mbEmailEnabled, false,
                   WWHFrame.WWHHelp.mMessages.mEmailIconLabel,
                   "email.gif", "emailx.gif", "fClickedEmail", "WWHControlsRightFrame");
  this.fAddControl("WWHPrintIcon", VarSettings.mbPrintEnabled, false,
                   WWHFrame.WWHHelp.mMessages.mPrintIconLabel,
                   "print.gif", "printx.gif", "fClickedPrint", "WWHControlsRightFrame");
  // Load control frames
  //
  this.fReloadControls();
}

function  WWHControls_SansNavigation()
{
  var  bSansNavigation = false;


  if (WWHFrame.WWHHelp.fSingleTopic())
  {
    bSansNavigation = true;
  }

  return bSansNavigation;
}

function  WWHControls_CanSyncTOC()
{
  var  bVarCanSyncTOC = false;


  if (this.mSyncPrevNext[0] != null)
  {
    bVarCanSyncTOC = true;
  }

  return bVarCanSyncTOC;
}

function  WWHControls_LeftHTML()
{
  var  VarHTML = "";
  MGCPopup = "NO";
  if (WWHFrame.popup == undefined)
  {
     MGCPopup = "NO";
  }
  else
  {
     MGCPopup = WWHFrame.popup;
  }
  var  ShowIcons = "NO";
  if (MGCPopup == "NO")
  {
     var  ShowIcons = "YES";
  }
  if (WWHFrame.NavIconsEnabled == "DISABLE")
  {
     var  ShowIcons = "NO";
  }

  // Confirm user did not reload the frameset
  //
  if (this.fGetControl("WWHFrameSetIcon") != null)
  {
    VarHTML += "<table border=\"0\" colspacing=0 cellpadding=0>\n";
    VarHTML += " <tr>\n";
    //MGCRK added icon to switch to Topic-Only display (No Content/Index/Search tabs)
    var MGCHomeButton = "<td><a href=\"javascript:WWHFrame.MGC_GoToTitlePage();\" onMouseOver=WWHFrame.MGCIconMouseover('home'); onMouseOut=WWHFrame.MGCIconMouseout('home');  ><img name=\"MGCHomeICon\" src=\"../images/home.png\" title=\"Display title page for this document\" border=\"0\"  /></a></td><td>&nbsp;</td>\n";
    var PrevButton = "<td><a href=\"javascript:WWHFrame.WWHControls.fClickedPrevious();\"  onMouseOver=WWHFrame.MGCIconMouseover('prev'); onMouseOut=WWHFrame.MGCIconMouseout('prev');  ><img name=\"MGCPrevICon\" src=\"../images/prev.png\" title=\"Display Previous Topic\" border=\"0\"  /></a></td>\n";
    var NextButton = "<td><a href=\"javascript:WWHFrame.WWHControls.fClickedNext();\" onMouseOver=WWHFrame.MGCIconMouseover('next'); onMouseOut=WWHFrame.MGCIconMouseout('next'); ><img name=\"MGCNextICon\" src=\"../images/next.png\" title=\"Display Next Topic\" border=\"0\"  /></a></td>\n";
    if (ShowIcons == "YES") 
    {
    VarHTML += MGCHomeButton;
       VarHTML += PrevButton;
       VarHTML += NextButton;
    }
    VarHTML += " </tr>\n";
    VarHTML += "</table>\n";
  }
  return VarHTML;
}

function InsertImgStyle()
{
   var imgHTML = "";
   imgHTML += "<style type=\"text/css\">\n";
   imgHTML += " <!--\n";
   imgHTML += "  img\.mIcon\n";
   imgHTML += "  {\n";
   imgHTML += "    border: 0px;\n";
   imgHTML += "    border-width: 0;\n";
   imgHTML += "    margin-top: 0pt;\n";
   imgHTML += "    margin-bottom: 0pt;\n";
   imgHTML += "    margin-left: 0pt;\n";
   imgHTML += "    margin-right: 0pt;\n";
   imgHTML += "  }\n";
   imgHTML += " -->\n";
   imgHTML += "</style>\n";
   return imgHTML;
}


function  WWHControls_RightHTML()
{
  var  VarHTML = "";
  VarHTML += InsertImgStyle();
//  VarHTML += InsertFontMenu();
  
//  var DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
  var mgcFontChange = InsertImgStyle();
  mgcFontChange += "<td>";
  mgcFontChange += "<a href=\"javascript:WWHFrame.MGCChangeFont(0)\"><img class=\"mIcon\" src=\"../images/text_size_sm.png\" title=\"Change Font Size to SMALL\" /></a>";
  mgcFontChange += "<a href=\"javascript:WWHFrame.MGCChangeFont(1)\"><img class=\"mIcon\" src=\"../images/text_size_med.png\" title=\"Change Font Size to NORMAL\" /></a>";
  mgcFontChange += "<a href=\"javascript:WWHFrame.MGCChangeFont(2)\"><img class=\"mIcon\" src=\"../images/text_size_lg.png\" title=\"Change Font Size to LARGE\" /></a>";
  mgcFontChange += "</td>\n";
  var mgcfeedback = "<td><a href=\"javascript:WWHFrame.SubmitFeedback()\"> <img src=\"../images/feedback.png\" title=\"Submit feedback on this document to Mentor Graphics\" border=\"0\"  /></a></td>\n";
  var mgcprint = "";
  if ((WWHFrame.PrintEnable != "NO") && (MGCPopup == "NO") && (WWHFrame.NavIconsEnabled == "ENABLE"))
  {
     var mgcprint = "<td><a href=\"javascript:WWHFrame.MGC_Print()\"> <img src=\"../images/print.png\" title=\"Print this topic\" border=\"0\"  /></a></td>\n";
  }

  // Confirm user did not reload the frameset
  //
//  if (this.fGetControl("WWHRelatedTopicsIcon") != null)
//  {
       //RKMGC added the following variables to add the MGC logo, bookcase icon, and PDF icon to the nav bar
       //Added code to check and see if certain icons should be disabled (help, bookcase, pdf)
       var mgcbookcase = "";
       var mgcpdf = "";
       var mgchelp = "";
       var mgcihub = "";
       MGCPopup = "NO";
       WWHFrame.NavIconsEnabled == "ENABLE"
       var mgchelp = "";
       var mgchelp = "<td><a href=\"javascript:WWHFrame.DisplayHelp(\'../../../../mgc_html_help/mgc_html_help.htm\')\"><img src=\"../images/help.png\" title=\"Help\" border=\"0\"  /></a></td>\n";
       var mgclogo = "<td><img src=\"../images/mgc_logo.gif\"  /></td>\n";
//       if (GetPDFLink() == "YES")
//       {
          var mgcpdf = "<td><a href=\"javascript:WWHFrame.OpenPDF()\"><img src=\"../images/pdf.png\" title=\"Display PDF\" border=\"0\"  /></a></td>\n";
//       }
       if ( (typeof(GetIHUBHandle()) != "undefined") && (GetIHUBHandle() != "NONE") && (!WWHFrame.OnSupportNet) )
       {
          var mgcihub = "<td><a href=\"javascript:WWHFrame.OpenInfoHub()\"><img src=\"../images/infohub.png\" title=\"Display InfoHub\" border=\"0\"  /></a></td>\n";
       }
       VarHTML += "<table border=\"0\">\n";
       VarHTML += " <tr>\n";
//       VarHTML += this.fGetControl("WWHRelatedTopicsIcon").fGetHTML();
       //RKMGC added the following to add the bookcase and PDF icons to the nav bar
       VarHTML += " " + mgcFontChange + " ";
       VarHTML += " " + mgchelp + " ";
       VarHTML += " " + mgcihub + " ";
       VarHTML += " " + mgcpdf + " ";
       VarHTML += " " + mgcprint + "";
//       VarHTML += this.fGetControl("WWHPrintIcon").fGetHTML();
//       VarHTML += this.fGetControl("WWHEmailIcon").fGetHTML();
       //RKMGC added the following to add the MGC logo to the nav bar
       VarHTML += " " + mgcfeedback + "";
       VarHTML += " " + mgclogo + " ";
//       VarHTML += this.fGetControl("WWHBookmarkIcon").fGetHTML();

    VarHTML += " </tr>\n";
    VarHTML += "</table>\n";
//  }
  return VarHTML;
}

function  WWHControls_LeftFrameTitle()
{
  var  VarTitle = "";


  if (this.fGetControl("WWHFrameSetIcon").fGetLabel().length > 0)
  {
    if (VarTitle.length > 0)
    {
      VarTitle += WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
    }
    VarTitle += this.fGetControl("WWHFrameSetIcon").fGetLabel();
  }

  if (this.fGetControl("WWHSyncTOCIcon").fGetLabel().length > 0)
  {
    if (VarTitle.length > 0)
    {
      VarTitle += WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
    }
    VarTitle += this.fGetControl("WWHSyncTOCIcon").fGetLabel();
  }

  if (this.fGetControl("WWHPrevIcon").fGetLabel().length > 0)
  {
    if (VarTitle.length > 0)
    {
      VarTitle += WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
    }
    VarTitle += this.fGetControl("WWHPrevIcon").fGetLabel();
  }

  if (this.fGetControl("WWHNextIcon").fGetLabel().length > 0)
  {
    if (VarTitle.length > 0)
    {
      VarTitle += WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
    }
    VarTitle += this.fGetControl("WWHNextIcon").fGetLabel();
  }

  return VarTitle;
}

function  WWHControls_RightFrameTitle()
{
  var  VarTitle = "";


  if (this.fGetControl("WWHRelatedTopicsIcon").fGetLabel().length > 0)
  {
    if (VarTitle.length > 0)
    {
      VarTitle += WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
    }
    VarTitle += this.fGetControl("WWHRelatedTopicsIcon").fGetLabel();
  }

  if (this.fGetControl("WWHEmailIcon").fGetLabel().length > 0)
  {
    if (VarTitle.length > 0)
    {
      VarTitle += WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
    }
    VarTitle += this.fGetControl("WWHEmailIcon").fGetLabel();
  }

  if (this.fGetControl("WWHPrintIcon").fGetLabel().length > 0)
  {
    if (VarTitle.length > 0)
    {
      VarTitle += WWHFrame.WWHHelp.mMessages.mAccessibilityListSeparator + " ";
    }
    VarTitle += this.fGetControl("WWHPrintIcon").fGetLabel();
  }

  return VarTitle;
}

function  WWHControls_UpdateHREF(ParamHREF)
{

//MGCRK Check to see if icons should be enabled.
//If this is a popup, or single topic mode with icons disabled
//we need to prevent display of all left control icons.
//
  MGCPopup = "NO";
  if (WWHFrame.popup == undefined)
  {
     MGCPopup = "NO";
  }
  else
  {
     MGCPopup = WWHFrame.popup;
  }
  var  ShowIcons = "NO";
  if (MGCPopup == "NO")
  {
     var  ShowIcons = "YES";
  }
  if (WWHFrame.NavIconsEnabled == "DISABLE")
  {
     var  ShowIcons = "NO";
  }

  // Update sync/prev/next array
  //
  this.mSyncPrevNext = WWHFrame.WWHHelp.fGetSyncPrevNext(ParamHREF);
  WWHFrame.mSyncPrevNext = WWHFrame.WWHHelp.fGetSyncPrevNext(ParamHREF);

  // Update status
  //
  if (ShowIcons == "YES") 
  {
    this.fGetControl("WWHFrameSetIcon").fSetStatus(this.fSansNavigation());
  }
  this.fGetControl("WWHSyncTOCIcon").fSetStatus(this.fCanSyncTOC());
  this.fGetControl("WWHPrevIcon").fSetStatus(this.mSyncPrevNext[1] != null);
  this.fGetControl("WWHNextIcon").fSetStatus(this.mSyncPrevNext[2] != null);
  this.fGetControl("WWHRelatedTopicsIcon").fSetStatus(WWHFrame.WWHRelatedTopics.fHasRelatedTopics());
  this.fGetControl("WWHEmailIcon").fSetStatus(this.fCanSyncTOC());
  this.fGetControl("WWHPrintIcon").fSetStatus(this.fCanSyncTOC());
  // Update controls
  //
  if (WWHFrame.WWHHelp.mbAccessible)
  {
    // Reload control frames
    //
    this.fReloadControls();
  }
  else
  {
    // Update icons in place
    //
  if (ShowIcons == "YES") 
  {
//    this.fGetControl("WWHFrameSetIcon").fUpdateIcon();
  }
//    this.fGetControl("WWHSyncTOCIcon").fUpdateIcon();
    this.fGetControl("WWHPrevIcon").fUpdateIcon();
    this.fGetControl("WWHNextIcon").fUpdateIcon();
//    this.fGetControl("WWHRelatedTopicsIcon").fUpdateIcon();
//    this.fGetControl("WWHEmailIcon").fUpdateIcon();
//    this.fGetControl("WWHPrintIcon").fUpdateIcon();
    // Restore previous focus
    //
    this.fRestoreFocus();
  }
}

function  WWHControls_RecordFocus(ParamFrameName,
                                  ParamAnchorName)
{
  this.mFocusedFrame  = ParamFrameName;
  this.mFocusedAnchor = ParamAnchorName;
}

function  WWHControls_RestoreFocus()
{
  if ((this.mFocusedFrame.length > 0) &&
      (this.mFocusedAnchor.length > 0))
  {
    WWHFrame.WWHHelp.fFocus(this.mFocusedFrame, this.mFocusedAnchor);
  }

  this.mFocusedFrame  = "";
  this.mFocusedAnchor = "";
}

function  WWHControls_SwitchToNavigation(ParamTabName)
{
  var  VarDocumentFrame;
  var  VarDocumentURL;
  var  VarSwitchURL;


  // Switch to navigation
  //
  VarDocumentFrame = eval(WWHFrame.WWHHelp.fGetFrameReference("WWHDocumentFrame"));
  VarDocumentURL = WWHFrame.WWHBrowser.fNormalizeURL(VarDocumentFrame.location.href);
  VarDocumentTopic = VarDocumentFrame.ThisTopic;
  VarDocumentHandle = VarDocumentFrame.DocHandle;
alert("Opening " + WHFrame.WWHHelp.mHelpURLPrefix + "../../wwhelp.htm?context=" + VarDocumentHandle + "&topic=" + VarDocumentTopic);
  window.location = WWHFrame.WWHHelp.mHelpURLPrefix + "../../wwhelp.htm?context=" + VarDocumentHandle + "&topic=" + VarDocumentTopic;
  VarDocumentURL = WWHFrame.WWHHelp.fGetBookFileHREF(VarDocumentURL);
  VarSwitchURL = WWHFrame.WWHHelp.mHelpURLPrefix + "/wwhelp/wwhimpl/common/html/switch.htm?href=" + WWHFrame.WWHBrowser.fRestoreEscapedSpaces(VarDocumentURL);
  if (WWHFrame.WWHHelp.mbAccessible)
  {
    VarSwitchURL += "&accessible=true";
  }
  if ((typeof(ParamTabName) != "undefined") &&
      (ParamTabName != null))
  {
    VarSwitchURL += "&tab=" + ParamTabName;
  }
  WWHFrame.WWHSwitch.fExec(false, VarSwitchURL);
}

function  WWHControls_ClickedShowNavigation()
{
  this.fShowNavigation();
}

function  WWHControls_ClickedSyncTOC()
{
  this.fSyncTOC(true);
}

function  WWHControls_ClickedPrevious()
{
  // Record focused icon
  //
  this.fRecordFocus("WWHControlsLeftFrame", "WWHPrevIcon");

  this.fPrevious();
}

function  WWHControls_ClickedNext()
{
  // Record focused icon
  //
  this.fRecordFocus("WWHControlsLeftFrame", "WWHNextIcon");

  this.fNext();
}

function  WWHControls_ClickedRelatedTopics()
{
  this.fRelatedTopics();
}

function  WWHControls_ClickedEmail()
{
  this.fEmail();
}

function  WWHControls_ClickedPrint()
{
  this.fPrint();
}

function  WWHControls_ShowNavigation()
{
  var  VarDocumentFrame;
  var  VarDocumentURL;


  if (WWHFrame.WWHHandler.fIsReady())
  {
    this.fSwitchToNavigation();
  }
}

function  WWHControls_SyncTOC(bParamReportError)
{
  if (this.fCanSyncTOC())
  {
    if (WWHFrame.WWHHandler.fIsReady())
    {
      WWHFrame.WWHHelp.fSyncTOC(this.mSyncPrevNext[0], bParamReportError);
    }
  }
}

function  WWHControls_Previous()
{
//WWHFrame.document.write("InSearchTips is " + 
  if (WWHFrame.InSearchTips()) { WWHFrame.DisplayNA();return; }
  if (this.mSyncPrevNext[1] != null)
  {
    WWHFrame.WWHHelp.fSetDocumentHREF(this.mSyncPrevNext[1], false);
  }
}

function  WWHControls_Next()
{
   if (WWHFrame.InSearchTips()) { WWHFrame.DisplayNA();return; }
//  DocPage = unescape(WWHFrame.MGCContent.MGCDocContent.location);
//  path = unescape(WWHFrame.MGCContent.MGCDocContent.location).split("/");
//  book = path[path.length-2];
//  file = path[path.length-1];
//  if (file == "searching_for_text.html" ) { return; }
  if (this.mSyncPrevNext[2] != null)
  {
    WWHFrame.WWHHelp.fSetDocumentHREF(this.mSyncPrevNext[2], false);
  }
}

function  WWHControls_RelatedTopics()
{
  var  VarDocumentFrame;
  var  VarDocumentURL;


  if (WWHFrame.WWHRelatedTopics.fHasRelatedTopics())
  {
    if (WWHFrame.WWHBrowser.mbSupportsPopups)
    {
      WWHFrame.WWHRelatedTopics.fShow();
    }
    else
    {
      VarDocumentFrame = eval(WWHFrame.WWHHelp.fGetFrameReference("WWHDocumentFrame"));

      VarDocumentURL = WWHFrame.WWHBrowser.fNormalizeURL(VarDocumentFrame.location.href);
      VarDocumentURL = WWHStringUtilities_GetURLFilePathOnly(VarDocumentURL);

      WWHFrame.WWHHelp.fSetLocation("WWHDocumentFrame", VarDocumentURL + "#WWHRelatedTopics");
    }
  }
}

function  WWHControls_Email()
{
//MGCRK modified message and referenced file format.
//MGCRK modified to use new feedback form (09/07/2004).
//MGCRK modified to work in single-topic mode (11/04/2004).
  var  VarLocation;
  var  VarMessage;
  var  VarSubject;
  var  VarMailTo;

  if (this.fCanSyncTOC())
  {
    WWHFrame.SubmitFeedback();
//    if (WWHFrame.WWHHelp.fSingleTopic())
//    {
//       DocumentFramePath = WWHFrame.MGCContent;
//    }
//    else
//    {
//       DocumentFramePath = WWHFrame.MGCContent.MGCDocContent;
//    }
//    var page = new String(DocumentFramePath.location);
//    var pos = page.lastIndexOf("/") + 1;
//    var File = page.substr(pos);
//    var DocTitle = DocumentFramePath.DocTitle;
//    var SWRelease = DocumentFramePath.SWRelease;
//    window.open("http://www.mentor.com/supportnet/documentation/reply_form.cfm?doc_title\=" + DocTitle + " \(" + File + "\)&version\=" + SWRelease);
  }
}


function  WWHControls_Print()
{
  var  VarDocumentFrame;


  if (this.fCanSyncTOC())
  {
    VarDocumentFrame = eval(WWHFrame.WWHHelp.fGetFrameReference("WWHDocumentFrame"));

    VarDocumentFrame.focus();
    VarDocumentFrame.print();
  }
}

function  WWHControls_ProcessAccessKey(ParamAccessKey)
{
  switch (ParamAccessKey)
  {
    case 4:
      this.fClickedPrevious();
      break;

    case 5:
      this.fClickedNext();
      break;

    case 6:
      this.fClickedRelatedTopics();
      break;

    case 7:
      this.fClickedEmail();
      break;

    case 8:
      this.fClickedPrint();
      break;
  }
}
