// Copyright (c) 2000-2001 Quadralay Corporation.  All rights reserved.
//

function  WWHBrowserInfo_Object()
{
  var  Agent;
  var  MajorVersion = 0;
  var  VersionString;
  var  Version = 0.0;


  // Initialize values
  //
  this.mPlatform       = 0;      // Shorthand for Unknown
  this.mBrowser        = 0;      // Shorthand for Unknown
  this.mbWindowIE40    = false;  // Needed for special case handling
  this.mbMacIE45       = false;  // Needed for special case handling
  this.mbMacIE50       = false;  // Needed for special case handling
  this.mbIEWindowsXP   = false;  // Needed for special case handling
  this.mbUnescapeHREFs = true;   // Needed for special case handling
  this.mbWindowsIE60   = false;  // Needed for special case handling
  this.mbUnsupported   = false;

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
    }
  }
  else if (Agent.indexOf("msie") != -1)
  {
    MajorVersion = parseInt(navigator.appVersion)
    if (MajorVersion >= 4)
    {
      this.mBrowser = 2;  // Shorthand for IE

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

    // See if we are running IE under Windows XP
    //
    if (Agent.indexOf("windows nt ") != -1)
    {
      if (parseFloat(Agent.substring(Agent.indexOf("windows nt ") + 11,Agent.length)) > 5)
      {
        this.mbIEWindowsXP = true;
      }
    }
  }
  else if (Agent.indexOf("icab") != -1)
  {
    this.mBrowser = 3;  // Shorthand for iCab
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
}
