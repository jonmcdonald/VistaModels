// Copyright 2006 Mentor Graphics Corp.
//

function  MGCCookiesEnabled()
{
    CookiesEnabled = false;

    // Try setting a cookie
    //
    MGCSetCookie("MGCCookiesEnabled", "True");

    // Retrieve the cookie
    //
    if (MGCGetCookie("MGCCookiesEnabled") != null)
    {
      // Delete the test cookie
      //
      MGCDeleteCookie("MGCCookiesEnabled");

      // Success!
      //
      CookiesEnabled = true;
    }
  return CookiesEnabled;
}

function MGCGetCookie(name)
{
   var nameEQ = name + "=";
   var ca = document.cookie.split(';');
   for(var i=0;i < ca.length;i++)
   {
      var c = ca[i];
      while (c.charAt(0)==' ') c = c.substring(1,c.length);
      if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
   }
   return null;
}

function  MGCDeleteCookie(ParamName)
{
  // Set cookie to expire yesterday
  //
  MGCSetCookie(ParamName, "", -1);
}

function MGCSetCookie(Name,Value)
{
   path = "/";
   if (Name == "MGCFavorites")
      { path = WWHFrame.mCookiePath; }
   var eValue = escape(Value);
   var exp=new Date();
   var oneYearFromNow = exp.getTime() + (365*24*60*60*1000);
   exp.setTime(oneYearFromNow);
   document.cookie=Name + "\=" + eValue + "\;path=" + path +"\;expires=" + exp.toGMTString() ;
}

function MGCSetCookiePath(URL)
{
	var  Pathname;
	var  WorkingURL;
	var  Parts;
	var  Index;
	var  Protocol = "";
	
//	if ( WWHFrame.mCookiePath.length > 0 ) {
//	    return;
//	}

	// Initialize return value
	Pathname = "/";
	
	// Remove URL parameters
	WorkingURL = URL;
	if (WorkingURL.indexOf("?") != -1)
	{
	  Parts = WorkingURL.split("?");
	  WorkingURL = Parts[0];
	}
	
	// Remove last entry if path does not end with /
	Index = WorkingURL.lastIndexOf("/");
	if ((Index + 1) < WorkingURL.length)
	{
	  WorkingURL = WorkingURL.substring(0, Index);
	}
	
	// Remove protocol
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
	if (Index != -1)
	{
	  Pathname = WorkingURL.substring(Index, WorkingURL.length);
	
	  // Clean up pathname
	  if (Protocol == "file")
	  {
	    if (IsWinIE())  // Shorthand for Windows
	    {
	      // file URLs must have slashes replaced with backslashes, except the first one
	      if (Pathname.length > 1)
	      {
	        Pathname = unescape(Pathname);
	        Pathname = Pathname.split("/").join("\\");
	        if (Pathname.indexOf("\\") == 0)
	        {
	          Pathname = "/" + Pathname.substring(1, Pathname.length);
	        }
	      }
	    }
	  }
	  else
	  {
	    // Trim server info
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
	WWHFrame.mCookiePath = Pathname;
}
