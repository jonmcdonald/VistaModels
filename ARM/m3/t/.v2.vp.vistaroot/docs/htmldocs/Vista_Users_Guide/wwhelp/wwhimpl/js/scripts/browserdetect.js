function DetectBrowser()
{
   var WWHFrame = eval("parent");
   OS = "";
   browser = "";
   version = "";
   thestring = "";
   detect = navigator.userAgent.toLowerCase();
   WWHFrame.detectraw = detect;
   var useVersion = true;
   if (checkIt('konqueror'))
   {
   	browser = "Konqueror";
	OS = "Linux";
   }
   else if (checkIt('safari'))
   {
   	browser = "Safari";
   	version = "";
   	useVersion = false;
   } else if (checkIt('omniweb')) browser = "OmniWeb";
   else if (checkIt('opera')) browser = "Opera";
   else if (checkIt('webtv')) browser = "WebTV";
   else if (checkIt('icab')) browser = "iCab";
   else if (checkIt('msie')) browser = "Internet Explorer";
   else if (!checkIt('compatible'))
   {
   	browser = "Netscape Navigator";
   	version = detect.substring(8,12);
   }
   else browser = "";
   if ((!version) && (useVersion))
   {
   	version = detect.substring(8,12);
   }
   if (!OS)
   {
   	if (checkIt('linux')) OS = "Linux";
   	else if (checkIt('x11')) OS = "Unix";
   	else if (checkIt('mac')) OS = "Mac";
   	else if (checkIt('win')) OS = "Windows";
   	else OS = "Windows";
   }
   WWHFrame.browsername = browser;
   WWHFrame.browserversion = version;
   WWHFrame.operatingsystem = OS;
}

function checkIt(string)
{
	place = detect.indexOf(string) + 1;
	thestring = string;
	return place;
}
