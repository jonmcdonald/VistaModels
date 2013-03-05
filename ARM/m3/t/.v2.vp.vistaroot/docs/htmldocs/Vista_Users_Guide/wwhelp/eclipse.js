// Copyright (c) 2006-2007 Mentor Graphics Corporation.  All rights reserved.
//

//MGCRK - added new function to support style sheet
//
function MGCGetInternalStyleSheet(level)
{
// Do nothing for eclipse
return " ";
}
function MGCGetDocumentStyleSheet(level)
{
// Do nothing for eclipse
return " ";
}

function MGCGetPGFStyleSheet(level)
{
   var catalog = "catalog.css";
   var hier = "";
//   if (operatingsystem == "Unix") { catalog = "catalogU.css"};
//   if (operatingsystem == "Mac") { catalog = "catalog.css"};
//   if (operatingsystem == "Windows") { catalog = "catalog.css"};
//   if (operatingsystem == "Linux") { catalog = "catalogU.css"};
   return MGCGenerateBodyStyle() + "<link rel=\"stylesheet\" href=\"" + hier + catalog + "\" type=\"text/css\" />\n<link rel=\"stylesheet\" href=\"" + hier + "document.css\" type=\"text/css\" />";
}

function  MGCGenerateBodyStyle()
{
  BaseBodyFontSize = 15;
//  if (operatingsystem == "Unix") { BaseBodyFontSize = 17;};
//  if (operatingsystem == "Mac") { BaseBodyFontSize = 13;};
//  if (operatingsystem == "Windows") { BaseBodyFontSize = 13;};
//  if (operatingsystem == "Linux") { BaseBodyFontSize = 13;};
  var  BodyHTML = "";
  BodyHTML += "<style type=\"text/css\">\n";
  BodyHTML += " <!--\n";
  BodyHTML += " body {\n";
  BodyHTML += "   background-color: #FFFFFF;\n";
  BodyHTML += "   color: Black;\n";
  BodyHTML += "   font-family: Verdana, Arial, Helvetica, sans-serif;\n";
  BodyHTML += "   font-size: " + BaseBodyFontSize + "px;\n";
  BodyHTML += "   font-variant: normal;\n";
  BodyHTML += "   font-style: normal;\n";
  BodyHTML += "   font-weight: normal;\n";
  BodyHTML += "   text-decoration: none;\n";
  BodyHTML += "   text-indent: 0px;\n";
  BodyHTML += "   text-transform: none;\n";
  BodyHTML += "   text-align: left;\n";
  BodyHTML += "   margin-left: 10px;\n";
  BodyHTML += "   margin-right: 10px;\n";
  BodyHTML += " }\n";
  BodyHTML += " // -->\n";
  BodyHTML += "</style>\n";
  return BodyHTML;
}

function DetectBrowser()
{
return;
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
   	else OS = "";
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
