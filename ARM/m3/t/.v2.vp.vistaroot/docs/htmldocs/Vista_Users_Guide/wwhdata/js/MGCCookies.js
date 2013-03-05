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
   var eValue = escape(Value);
   var exp=new Date();
   var oneYearFromNow = exp.getTime() + (365*24*60*60*1000);
   exp.setTime(oneYearFromNow);
   document.cookie=Name + "\=" + eValue + "\;path=/" + "\;expires=" + exp.toGMTString() ;
}
