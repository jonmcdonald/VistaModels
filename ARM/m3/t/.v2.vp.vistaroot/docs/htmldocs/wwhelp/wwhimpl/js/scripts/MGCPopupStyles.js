function popup(msg,bak)
{
   if (WWHFrame.IndexPopups != "YES")
   {
      return
   }
   textsize=1;
   if (WWHFrame.operatingsystem == "Unix"){textsize=2;}
   var content="<TABLE BORDER=2 BORDERCOLOR=#cccc99 CELLPADDING=2 CELLSPACING=0 "+
"BGCOLOR=\"\#f6f6dc\"><TD ALIGN=left><FONT FACE='Verdana, Arial, Helvetica, sans-serif' COLOR=black SIZE="+textsize+">"+msg+"</FONT></TD></TABLE>";
   yyy=Yoffset;
   if(ns4){skn.document.write(content);skn.document.close();skn.visibility="visible"}
   if(ns6){document.getElementById("dek").innerHTML=content;skn.display=''}
   if(ie4){document.all("dek").innerHTML=content;skn.display=''}
}

function get_mouse(e)
{
   var  WWHFrame = eval("parent.parent.parent");
   IndexWindow = WWHFrame.MGCNavigate.MGCIndex.MGCIndexContent;
   var x=(ns4||ns6||ns7)?e.pageX:event.x+IndexWindow.document.body.scrollLeft;
   skn.left=x+Xoffset;
   var y=(ns4||ns6||ns7)?e.pageY:event.y+IndexWindow.document.body.scrollTop;
   skn.top=y+yyy;
}

function kill()
{
   yyy=-1000;
   if(ns4){skn.visibility="hidden";}
   else if (ns6||ie4)
   skn.display="none"
}

function MGCPopupSetup()
{
// Window must contain the following div:
// <div ID="dek"></div>
   WWHFrame = eval("parent.parent.parent");
   // determine window hierarchy:
   MyWindow = window.name;
   MyWindow = WWHFrame.MGCNavigate.MGCIndex.MGCIndexContent;
   Xoffset=20;    // modify these values to ...
   Yoffset= -40;    // change the popup position.
   var old,skn,iex=(IndexWindow.document.all),yyy=-1000;
   var ns4=IndexWindow.document.layers
   var ns6=IndexWindow.document.getElementById&&!document.all
   var ns7=IndexWindow.document.getElementById&&!document.all
   var ie4=IndexWindow.document.all
   var ie5=IndexWindow.document.all
   var ie6=IndexWindow.document.all
   if (ns4)
      skn=IndexWindow.document.dek
   else if (ns6)
      skn=IndexWindow.document.getElementById("dek").style
   else if (ie4)
      skn=IndexWindow.document.all.dek.style
   if(ns4)IndexWindow.document.captureEvents(Event.MOUSEMOVE);
   else
   {
      skn.visibility="visible"
      skn.display="none"
   }
   IndexWindow.document.onmousemove=get_mouse;
   document.writeln("<span style=\"font-family: Verdana, Helvetica, Arial, sans-serif; font-size: " + WWHFrame.IndexFontSize + "px\">");
}





function MGCLoadPopupStyles()
{
  var HTML;
  HTML += "<style type=\"text/css\">\n";
  HTML += " <!--\n";
  HTML += "  div\.mPercent\n";
  HTML += "  {\n";
  if (WWHFrame.operatingsystem == "Unix")
     {  HTML += "    font-size: 13px;\n"; }
  else
     {  HTML += "    font-size: 11px;\n"; }
  HTML += "    visibility: hidden;\n";
  HTML += "    position: absolute;\n";
  HTML += "    left:0px;\n";
  HTML += "    bottom:0px;\n";
  HTML += "    background-color:#99FFFF;\n";
  HTML += "    border: 2px solid #000000;\n";
  HTML += "    border-top-width: 2px;\n";
  HTML += "    border-top-color: grey;\n";
  HTML += "    border-left-width: 2px;\n";
  HTML += "    border-left-color: grey;\n";
  HTML += "    border-right-width: 4px;\n";
  HTML += "    border-right-color: #000000;\n";
  HTML += "    font-family: Verdana, Arial, Helvetica, sans-serif;\n";
  HTML += "    margin-top: 1pt;\n";
  HTML += "    margin-top: 1pt;\n";
  HTML += "    margin-bottom: 1pt;\n";
  HTML += "    margin-left: 0pt;\n";
  HTML += "    text-indent: 0pt;\n";
  HTML += "    text-align: left;\n"; 
  HTML += "  }\n";
  HTML += " -->\n";
  HTML += "</style>\n";
  HTML += "<script type=\"text/javascript\" language=\"JavaScript1.2\">\n";
  HTML += " <!--\n";
  HTML += "function SHPercentMenu(szDivID, iState) // 1 visible, 0 hidden\n";
  HTML += "{\n";
  HTML += "    if(document.layers)	   //NN4+\n";
  HTML += "    {\n";
  HTML += "       document.layers[szDivID].visibility = iState ? \"show\" : \"hide\";\n";
  HTML += "       document.layers[szDivID].display = iState ? \"block\" : \"none\";\n";
  HTML += "    }\n";
  HTML += "    else if(document.getElementById)	  //gecko(NN6) + IE 5+\n";
  HTML += "    {\n";
  HTML += "        var obj = document.getElementById(szDivID);\n";
  HTML += "        obj.style.visibility = iState ? \"visible\" : \"hidden\";\n";
  HTML += "        obj.style.display = iState ? \"block\" : \"none\";\n";
  HTML += "    }\n";
  HTML += "    else if(document.all)	// IE 4\n";
  HTML += "    {\n";
  HTML += "        document.all[szDivID].style.visibility = iState ? \"visible\" : \"hidden\";\n";
  HTML += "        document.all[szDivID].style.display = iState ? \"block\" : \"none\";\n";
  HTML += "    }\n";
  HTML += "}\n";
  HTML += " // -->\n";
  HTML += "</script>\n";
  return HTML;
}
