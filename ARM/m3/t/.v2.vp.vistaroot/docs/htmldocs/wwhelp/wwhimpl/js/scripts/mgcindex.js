// Copyright (c) 2004 Mentor Graphics Corporation.  All rights reserved.
//
function  MGCInsertIndexTitleInfo()
{
   var WWHFrame = eval("parent.parent.parent");
   var  VarHTML = new WWHStringBuffer_Object();
   var Font = "<font size=\"" + WWHFrame.BaseNavFontSize + "px;\""  + WWHFrame.BaseFontFamily + ">";
   VarHTML.fAppend("<script type=\"text/javascript\" language=\"JavaScript1.2\">");
   VarHTML.fAppend("<!--");

   VarHTML.fAppend("   function LibraryTitle()");
   VarHTML.fAppend("   {");
   VarHTML.fAppend("      return ");
   VarHTML.fAppend("   }");
   VarHTML.fAppend("   function LibraryTitle()");
   VarHTML.fAppend("   {");
   VarHTML.fAppend("      return ");
   VarHTML.fAppend("   }");
   VarHTML.fAppend("");
   VarHTML.fAppend("   function GotoGlobalIndex()");
   VarHTML.fAppend("   {");
   VarHTML.fAppend("      var WWHFrame = eval(\"parent.parent.parent\");");
   VarHTML.fAppend("      var DocLocation = WWHFrame.MGCContent.MGCDocContent.location;");
   VarHTML.fAppend("      WWHFrame.MGCNavigate.MGCIndex.location = \"../../../wwhelp/Index/Index.html\";");
   VarHTML.fAppend("   }");
   VarHTML.fAppend("   " + Font + "<b>Index\:</b>");
   VarHTML.fAppend("   <br>\&nbsp\;\&nbsp\;<img src=\"../wwhimpl/common/images/ckmark.gif\"/>" + GetDocumentTitle());
   VarHTML.fAppend("   <br>\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<a href=\"javascript\:GotoGlobalIndex()\;\">\&nbsp\;" + LibraryTitle() + " Library</a><hr width=\"96%\"></font>");
   VarHTML.fAppend("
   VarHTML.fAppend("//-->");
   VarHTML.fAppend("</script>");
   return VarHTML.fGetBuffer();
}
