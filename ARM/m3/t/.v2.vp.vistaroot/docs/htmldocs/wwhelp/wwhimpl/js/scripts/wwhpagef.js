// Copyright (c) 2006 Mentor Graphics Corporation.  All rights reserved.
//

//MGCRK - added new function to update navigation pane
//        if in a different manual than the last one to
//        ensure that the doc title is updated
//
function MGCUpdateNavPane()
{
   var DocumentFramePath;
   if (WWHFrame.HighlightSearchTerms)
   {
      WWHFrame.MGCHighlightSearchTerms(WWHFrame.WWHSearch.mSavedSearchWords,false);
   }
   WWHFrame.HighlightSearchTerms = false;
   if (WWHFrame.popup != "YES")
   {
      if (!WWHFrame.WWHHelp.fSingleTopic())
      {
         if (WWHFrame.WWHJavaScript.mCurrentTab == 1)
         {
            WWHFrame.UpdateIndexScope();
         }
         if (WWHFrame.WWHJavaScript.mCurrentTab == 2)
         {
            WWHFrame.UpdateSearchScope();
         }
         if (WWHFrame.WWHJavaScript.mCurrentTab == 3)
         {
            WWHFrame.MGCNavigate.MGCIndex.location.reload(true);
         }
      }
   }
}
function MGCWWGetLevel(level)
{
   var hier = "";
   for (MaxIndex = level, Index = 0 ; Index < MaxIndex-1 ; Index++)
   {
      hier += "../";
   }
//   alert("Level is " + level);
   return hier;
}
function MGCWWGetDocumentStyleSheet(level)
{
   return "<link rel=\"stylesheet\" href=\"" + MGCWWGetLevel(level) + "document.css\" type=\"text/css\" />";
}
function MGCWWGetPGFStyleSheet(level)
{
   var catalog = "catalog.css";
   return "<link rel=\"stylesheet\" href=\"" + MGCWWGetLevel(level) + catalog + "\" type=\"text/css\" />";
}
function MGCWWGetInternalStyleSheet(level)
{
   return MGCWWGenerateBodyStyle() + "\n<link rel=\"stylesheet\" href=\"" + MGCWWGetLevel(level) + "internal.css\" type=\"text/css\" />";
}

function  MGCWWGenerateBodyStyle()
{
  var  BodyHTML = "";
  BodyHTML += "<style type=\"text/css\">\n";
  BodyHTML += " <!--\n";
  BodyHTML += " body {\n";
  BodyHTML += "   background-color: #FFFFFF;\n";
  BodyHTML += "   color: Black;\n";
  BodyHTML += "   font-family: Verdana, Arial, Helvetica, sans-serif;\n";
  BodyHTML += "   font-size: " + WWHFrame.BaseBodyFontSize + "px;\n";
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
function  MGCWWGenerateNavStyle()
{
  var  BodyHTML = "";
  BodyHTML += "<style type=\"text/css\">\n";
  BodyHTML += " <!--\n";
  BodyHTML += " body {\n";
  BodyHTML += "   background-color: #FFFFFF;\n";
  BodyHTML += "   color: Black;\n";
  BodyHTML += "   font-family: Verdana, Arial, Helvetica, sans-serif;\n";
  BodyHTML += "   font-size: " + WWHFrame.BaseNavFontSize + "px;\n";
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

