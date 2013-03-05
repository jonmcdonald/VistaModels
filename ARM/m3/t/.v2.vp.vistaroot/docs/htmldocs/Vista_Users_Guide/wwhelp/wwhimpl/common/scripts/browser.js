// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHBrowserUtilities_SearchReplace(ParamString,
                                            ParamSearchString,
                                            ParamReplaceString)
{
  var  ResultString;
  var  Index;


  ResultString = ParamString;

  if ((ParamSearchString.length > 0) &&
      (ResultString.length > 0))
  {
    Index = 0;
    while ((Index = ResultString.indexOf(ParamSearchString, Index)) != -1)
    {
      ResultString = ResultString.substring(0, Index) + ParamReplaceString + ResultString.substring(Index + ParamSearchString.length, ResultString.length);
      Index += ParamReplaceString.length;
    }
  }

  return ResultString;
}

function  WWHBrowserUtilities_EscapeURLForJavaScriptAnchor(ParamURL)
{
  var  EscapedURL = ParamURL;


  // Escape problematic characters
  // \ " ' < >
  //
  EscapedURL = WWHBrowserUtilities_SearchReplace(EscapedURL, "\\", "\\\\");
  EscapedURL = WWHBrowserUtilities_SearchReplace(EscapedURL, "\"", "\\u0022");
  EscapedURL = WWHBrowserUtilities_SearchReplace(EscapedURL, "'", "\\u0027");
  EscapedURL = WWHBrowserUtilities_SearchReplace(EscapedURL, "<", "\\u003c");
  EscapedURL = WWHBrowserUtilities_SearchReplace(EscapedURL, ">", "\\u003e");

  return EscapedURL;
}

function  WWHBrowser_Object()
{
  this.mLocale                 = "en";
  this.mPlatform               = 0;      // Shorthand for Unknown
  this.mBrowser                = 0;      // Shorthand for Unknown
  this.mCookiePath             = "/";
  this.mbCookiesEnabled        = null;
  this.mbSupportsFocus         = false;
  this.mbSupportsPopups        = true;
  this.mbSupportsFrameRenaming = true;
  this.mbWindowIE40            = false;  // Needed for special case handling
  this.mbMacIE45               = false;  // Needed for special case handling
  this.mbMacIE50               = false;  // Needed for special case handling
  this.mbUnescapeHREFs         = true;   // Needed for special case handling
  this.mbWindowsIE60           = false;  // Needed for special case handling
  this.mbUnsupported           = false;
  this.mbJavaCapable           = false;
  this.mbJavaEnabled           = false;

  this.fInitialize           = WWHBrowser_Initialize;
  this.fNormalizeURL         = WWHBrowser_NormalizeURL;
  this.fRestoreEscapedSpaces = WWHBrowser_RestoreEscapedSpaces;
  this.fSetLocation          = WWHBrowser_SetLocation;
  this.fReplaceLocation      = WWHBrowser_ReplaceLocation;
  this.fReloadLocation       = WWHBrowser_ReloadLocation;
  this.fSetCookiePath        = WWHBrowser_SetCookiePath;
  this.fCookiesEnabled       = WWHBrowser_CookiesEnabled;
  this.fSetCookie            = WWHBrowser_SetCookie;
  this.fGetCookie            = WWHBrowser_GetCookie;
  this.fDeleteCookie         = WWHBrowser_DeleteCookie;
  this.fFocus                = WWHBrowser_Focus;

  // Initialize object
  //
  this.fInitialize();
}

function  WWHBrowser_Initialize()
{
  var  Agent;
  var  MajorVersion = 0;
  var  VersionString;
  var  Version = 0.0;


  // Reset locale to correct language value
  //
  if ((typeof(navigator.language) != "undefined") &&
      (navigator.language != null))
  {
    this.mLocale = navigator.language;
  }
  else if ((typeof(navigator.userLanguage) != "undefined") &&
           (navigator.userLanguage != null))
  {
    this.mLocale = navigator.userLanguage;
  }

  // Convert everything to lowercase
  //
  this.mLocale = this.mLocale.toLowerCase();

  // Replace '-'s with '_'s
  //
  this.mLocale = WWHBrowserUtilities_SearchReplace(this.mLocale, "-", "_");

  // Get browser info
  //
  Agent = navigator.userAgent.toLowerCase();

  // Determine platform
  //
  if ((Agent.indexOf("win") != -1) ||
      (Agent.indexOf("16bit") != -1))
  {
    this.mPlatform = 1;  // Shorthand for Windows
  }
  else if (Agent.indexOf("mac") != -1)
  {
    this.mPlatform = 2;  // Shorthand for Macintosh
  }

  // Determine browser
  //
  if ((Agent.indexOf("mozilla") != -1) &&
      (Agent.indexOf("spoofer") == -1) &&
      (Agent.indexOf("compatible") == -1))
  {
    MajorVersion = parseInt(navigator.appVersion)

    if (MajorVersion >= 5)
    {
      this.mBrowser = 4;  // Shorthand for Netscape 6.0
      this.mbSupportsFocus = true;

      // Netscape 6.0 is unsupported
      //
      if (navigator.userAgent.indexOf("m18") != -1)
      {
        this.mbUnsupported = true;
      }
    }
    else if (MajorVersion >= 4)
    {
      this.mBrowser = 1;  // Shorthand for Netscape

      this.mbSupportsFrameRenaming = false;
    }
  }
  else if (Agent.indexOf("msie") != -1)
  {
    MajorVersion = parseInt(navigator.appVersion)
    if (MajorVersion >= 4)
    {
      this.mBrowser = 2;  // Shorthand for IE
      this.mbSupportsFocus = true;

      // Additional info needed for popups
      //
      VersionString = navigator.appVersion.toLowerCase();
      MSIEVersionString = VersionString.substring(VersionString.indexOf("msie") + 4);
      Version = parseFloat(MSIEVersionString);
      if ((Version >= 4.0) &&
          (Version < 4.1))
      {
        if (this.mPlatform == 1)  // Shorthand for Windows
        {
          this.mbWindowsIE40 = true;
        }
      }
      else if ((Version >= 4.5) &&
               (Version < 4.6))
      {
        if (this.mPlatform == 2)  // Shorthand for Macintosh
        {
          this.mbMacIE45 = true;
        }
      }
      else if ((Version >= 5.0) &&
               (Version < 5.1))
      {
        if (this.mPlatform == 2)  // Shorthand for Macintosh
        {
          this.mbMacIE50 = true;
        }
      }
      else if (Version >= 6.0)
      {
        this.mbWindowsIE60 = true;
      }
    }
  }
  else if (Agent.indexOf("icab") != -1)
  {
    this.mBrowser = 3;  // Shorthand for iCab

    this.mbSupportsPopups = false;
  }

  // Safari may spoof as just about anything
  //
  if (Agent.indexOf("safari") != -1)
  {
    this.mBrowser = 5;  // Shorthand for Safari

    this.mbSupportsPopups = true;
    this.mbSupportsFocus = false;
  }

  // Set mbUnescapeHREFs boolean
  //
  if ((this.mBrowser == 2) &&  // Shorthand for IE
      (this.mPlatform == 1))   // Shorthand for Windows
  {
    if (MajorVersion >= 5)
    {
      this.mbUnescapeHREFs = false;
    }
  }

  // Determine if platform can support Java
  //
  this.mbJavaCapable = false;
  if (this.mBrowser == 1)  // Shorthand for Netscape
  {
    if (this.mPlatform == 1)  // Shorthand for Windows
    {
      this.mbJavaCapable = true;  // Java works on NS for Windows
    }
    else if (this.mPlatform == 2)  // Shorthand for Macintosh
    {
      this.mbJavaCapable = false;  // Java doesn't work on NS for Macintosh
    }
    else
    {
      this.mbJavaCapable = true;  // Java is slow on UNIX
    }
  }
  else if (this.mBrowser == 2)  // Shorthand for IE
  {
    if (this.mPlatform == 1)  // Shorthand for Windows
    {
      this.mbJavaCapable = true;  // Java works on IE for Windows
    }
    else if (this.mPlatform == 2)  // Shorthand for Macintosh
    {
      this.mbJavaCapable = true;  // May work
    }
    else
    {
      this.mbJavaCapable = false;  // Java doesn't work on IE for UNIX
    }
  }
  else if (this.mBrowser == 4)  // Shorthand for Mozilla
  {
    if (this.mPlatform == 1)  // Shorthand for Windows
    {
      this.mbJavaCapable = true;  // May work
    }
    else if (this.mPlatform == 2)  // Shorthand for Macintosh
    {
      this.mbJavaCapable = false;  // Hangs in Mozilla 1.2.1
    }
    else
    {
      this.mbJavaCapable = true;  // Java unreliable under UNIX (works?)
    }
  }
  else
  {
    this.mbJavaCapable = false;  // Assume JavaScript is safer
  }

  // Opera may spoof as just about anything
  //
  if (Agent.indexOf("opera") != -1)
  {
    // Opera has trouble with Java
    //
    this.mbJavaCapable = false;
  }

  // Determine if Java is enabled
  //
  if ((typeof(navigator) != "undefined") &&
      (navigator != null))
  {
    this.mbJavaEnabled = navigator.javaEnabled();
  }
}

function  WWHBrowser_NormalizeURL(ParamURL)
{
  var  URL = ParamURL;
  var  Parts;
  var  MaxIndex;
  var  Index;
  var  DrivePattern;
  var  DrivePatternMatch;


  // Unescape URL for most browsers
  //
  if (this.mbUnescapeHREFs)
  {
    URL = unescape(URL);
  }
  else  // IE unescapes everything automatically, except &
  {
    URL = WWHBrowserUtilities_SearchReplace(URL, "%26", "&");
  }

  // Standardize protocol case
  //
  if (URL.indexOf(":") != -1)
  {
    Parts = URL.split(":");

    URL = Parts[0].toLowerCase();
    for (MaxIndex = Parts.length, Index = 1 ; Index < MaxIndex ; Index++)
    {
      URL += ":" + Parts[Index];
    }
  }

  // Handle drive letters under Windows
  //
  if (this.mPlatform == 1)  // Shorthand for Windows
  {
    DrivePattern = new RegExp("^file:[/]+([a-zA-Z])[:\|][/](.*)$", "i");
    DrivePatternMatch = DrivePattern.exec(URL);
    if (DrivePatternMatch != null)
    {
      URL = "file:///" + DrivePatternMatch[1] + ":/" + DrivePatternMatch[2];
    }
  }

  return URL;
}

function  WWHBrowser_RestoreEscapedSpaces(ParamURL)
{
  // Workaround for stupid Netscape 4.x bug
  //
  var  StringWithSpace = "x x";
  var  EscapedURL = ParamURL;


  if (this.mbUnescapeHREFs)
  {
    EscapedURL = WWHBrowserUtilities_SearchReplace(EscapedURL, StringWithSpace.substring(1, 2), "%20");
  }

  return EscapedURL;
}

function  WWHBrowser_SetLocation(ParamFrameReference,
                                 ParamURL)
{
  var  EscapedURL;


  EscapedURL = WWHBrowserUtilities_EscapeURLForJavaScriptAnchor(ParamURL);
  setTimeout(ParamFrameReference + ".location = \"" + EscapedURL + "\";", 1);
}

function  WWHBrowser_ReplaceLocation(ParamFrameReference,
                                     ParamURL)
{
  var  EscapedURL;


  EscapedURL = WWHBrowserUtilities_EscapeURLForJavaScriptAnchor(ParamURL);
  setTimeout(ParamFrameReference + ".location.replace(\"" + EscapedURL + "\");", 1);
}

function  WWHBrowser_ReloadLocation(ParamFrameReference)
{
  var  VarFrame;


  VarFrame = eval(ParamFrameReference);
  this.fReplaceLocation(ParamFrameReference, VarFrame.location.href);
}

function  WWHBrowser_SetCookiePath(ParamURL)
{
  var  Pathname;
  var  WorkingURL;
  var  Parts;
  var  Index;
  var  Protocol = "";


  // Initialize return value
  //
  Pathname = "/";

  // Remove URL parameters
  //
  WorkingURL = ParamURL;
  if (WorkingURL.indexOf("?") != -1)
  {
    Parts = WorkingURL.split("?");
    WorkingURL = Parts[0];
  }

  // Remove last entry if path does not end with /
  //
  Index = WorkingURL.lastIndexOf("/");
  if ((Index + 1) < WorkingURL.length)
  {
    WorkingURL = WorkingURL.substring(0, Index);
  }

  // Remove protocol
  //
  Index = -1;
  if (WorkingURL.indexOf("http:/") == 0)
  {
    Index = WorkingURL.indexOf("/", 6);
    Protocol = "http";
  }
  else if (WorkingURL.indexOf("ftp:/") == 0)
  {
    Index = WorkingURL.indexOf("/", 5);
    Protocol = "ftp";
  }
  else if (WorkingURL.indexOf("file:///") == 0)
  {
    Index = 7;
    Protocol = "file";
  }

  // Set base URL pathname
  //
  if (Index != -1)
  {
    Pathname = WorkingURL.substring(Index, WorkingURL.length);

    // Clean up pathname
    //
    if (Protocol == "file")
    {
      if (this.mPlatform == 1)  // Shorthand for Windows
      {
        if (this.mBrowser == 2)  // Shorthand for IE
        {
          // file URLs must have slashes replaced with backslashes, except the first one
          //
          if (Pathname.length > 1)
          {
            Pathname = unescape(Pathname);
            Pathname = WWHBrowserUtilities_SearchReplace(Pathname, "/", "\\");
            if (Pathname.indexOf("\\") == 0)
            {
              Pathname = "/" + Pathname.substring(1, Pathname.length);
            }
          }
        }
      }
    }
    else
    {
      // Trim server info
      //
      Index = Pathname.indexOf("/", Index);
      if (Index != -1)
      {
        Pathname = Pathname.substring(Index, Pathname.length);
      }
      else
      {
        Pathname = "/";
      }
    }
  }

  // Set cookie path
  //
  this.mCookiePath = Pathname;
}

function  WWHBrowser_CookiesEnabled()
{
  // Cache result
  //
  if (this.mbCookiesEnabled == null)
  {
    // Default to disabled
    //
    this.mbCookiesEnabled = false;

    // Try setting a cookie
    //
    this.fSetCookie("WWHBrowser_CookiesEnabled", "True");

    // Retrieve the cookie
    //
    if (this.fGetCookie("WWHBrowser_CookiesEnabled") != null)
    {
      // Delete the test cookie
      //
      this.fDeleteCookie("WWHBrowser_CookiesEnabled");

      // Success!
      //
      this.mbCookiesEnabled = true;
    }
  }

  return this.mbCookiesEnabled;
}

function  WWHBrowser_SetCookie(ParamName,
                               ParamValue,
                               ParamExpiration)
{
  var  VarFormattedCookie;
  var  VarPath;
  var  VarExpirationDate;


  // Format the cookie
  //
  VarFormattedCookie = escape(ParamName) + "=" + escape(ParamValue);

  // Add path
  //
  VarFormattedCookie += "; path=" + this.mCookiePath;

  // Add expiration day, if specified
  //
  if ((typeof(ParamExpiration) != "undefined") &&
      (ParamExpiration != null) &&
      (ParamExpiration != 0))
  {
    VarExpirationDate = new Date();
    VarExpirationDate.setTime(VarExpirationDate.getTime() + (ParamExpiration * 1000 * 60 * 60 * 24));
    VarFormattedCookie += "; expires=" + VarExpirationDate.toGMTString();
  }

  // Set the cookie for the specified document
  //
  document.cookie = VarFormattedCookie
}

function  WWHBrowser_GetCookie(ParamName)
{
  var  VarValue;
  var  VarCookies;
  var  VarKey;
  var  VarStartIndex;
  var  VarEndIndex;


  // Initialize return value
  //
  VarValue = null;

  // Get document cookies
  //
  VarCookies = document.cookie;

  // Parse out requested cookie
  //

  // Try first position
  //
  VarKey = escape(ParamName) + "=";
  VarStartIndex = VarCookies.indexOf(VarKey);
  if (VarStartIndex != 0)
  {
    // Try any other position
    //
    VarKey = "; " + escape(ParamName) + "=";
    VarStartIndex = VarCookies.indexOf(VarKey);
  }

  // Match found?
  //
  if (VarStartIndex != -1)
  {
    // Advance past cookie key
    //
    VarStartIndex += VarKey.length;

    // Find end
    //
    VarEndIndex = VarCookies.indexOf(";", VarStartIndex);
    if (VarEndIndex == -1)
    {
      VarEndIndex = VarCookies.length;
    }
    VarValue = unescape(VarCookies.substring(VarStartIndex, VarEndIndex));
  }

  return VarValue;
}

function  WWHBrowser_DeleteCookie(ParamName)
{
  // Set cookie to expire yesterday
  //
  this.fSetCookie(ParamName, "", -1);
}

function  WWHBrowser_Focus(ParamFrameReference,
                           ParamAnchorName)
{
  var  VarFrame;
  var  VarAnchor;
  var  VarMaxIndex;
  var  VarIndex;


  if (this.mbSupportsFocus)
  {
    if (ParamFrameReference.length > 0)
    {
      // Access frame
      //
      VarFrame = eval(ParamFrameReference);

      // Focus frame
      //
      VarFrame.focus();

      // Focusing anchor?
      //
      if ((typeof(ParamAnchorName) != "undefined") &&
          (ParamAnchorName != null) &&
          (ParamAnchorName.length > 0))
      {
        // Focus anchor
        //
        VarAnchor = VarFrame.document.anchors[ParamAnchorName];
        if ((typeof(VarAnchor) != "undefined") &&
            (VarAnchor != null))
        {
          VarAnchor.focus();
        }
        else
        {
          VarAnchorArray = VarFrame.document.anchors;
          for (VarMaxIndex = VarFrame.document.anchors.length, VarIndex = 0 ; VarIndex < VarMaxIndex ; VarIndex++)
          {
            if (VarFrame.document.anchors[VarIndex].name == ParamAnchorName)
            {
              VarFrame.document.anchors[VarIndex].focus();

              // Exit loop
              //
              VarIndex = VarMaxIndex;
            }
          }
        }
      }
    }
  }
}
