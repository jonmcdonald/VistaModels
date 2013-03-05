Xoffset=20;    // modify these values to ...
Yoffset= -40;    // change the popup position.
var old,skn,iex=(document.all),yyy=-1000;

var ns4=document.layers
var ns6=document.getElementById&&!document.all
var ns7=document.getElementById&&!document.all
var ie4=document.all
var ie5=document.all
var ie6=document.all

if (ns4)
skn=document.dek
else if (ns6)
skn=document.getElementById("dek").style
else if (ie4)
skn=document.all.dek.style
if(ns4)document.captureEvents(Event.MOUSEMOVE);
else{
skn.visibility="visible"
skn.display="none"
}
document.onmousemove=get_mouse;

function popup(msg,bak){
if (ns4){textsize=2;}
if (ns6){textsize=2;}
if (ns7){textsize=2;}
if (ie4){textsize=1;}
if (ie6){textsize=1;}
var content="<TABLE width=\"100%\" BORDER=1 BORDERCOLOR=#cccc99 CELLPADDING=2 CELLSPACING=0 "+
"BGCOLOR="+bak+"><TD ALIGN=left><FONT FACE='Verdana, Arial, Helvetica, sans-serif' COLOR=black SIZE="+textsize+">"+msg+"</FONT></TD></TABLE>";
yyy=Yoffset;
 if(ns4){skn.document.write(content);skn.document.close();skn.visibility="visible"}
 if(ns6){document.getElementById("dek").innerHTML=content;skn.display=''}
 if(ie4){document.all("dek").innerHTML=content;skn.display=''}
}

function get_mouse(e){
var x=(ns4||ns6||ns7)?e.pageX:event.x+document.body.scrollLeft;
skn.left=x+Xoffset;
var y=(ns4||ns6||ns7)?e.pageY:event.y+document.body.scrollTop;
skn.top=y+yyy;
}

function kill(){
yyy=-1000;
if(ns4){skn.visibility="hidden";}
else if (ns6||ie4)
skn.display="none"
}