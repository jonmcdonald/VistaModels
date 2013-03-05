// Copyright (c) 2002-2003 Quadralay Corporation.  All rights reserved.
//

function  WebWorks_WriteAnchorOpen(ParamID, bParamExpanded)
{
  if ((WWHFrame != null) &&
      ( ! WWHFrame.WWHHelp.mbAccessible) &&
      ((typeof(document.all) != "undefined") ||
       (typeof(document.getElementById) != "undefined")))
  {
    document.write("<a href=\"javascript:WebWorks_ToggleDIV('" + ParamID + "');\">");
  }
}

function  WebWorks_WriteAnchorClose(ParamID, bParamExpanded)
{
  var  VarIMGSrc;
  if ((WWHFrame != null) &&
      ( ! WWHFrame.WWHHelp.mbAccessible) &&
      ((typeof(document.all) != "undefined") ||
       (typeof(document.getElementById) != "undefined")))
  {
    if (bParamExpanded)
    {
      VarIMGSrc = "images/expanded.gif";
    }
    else
    {
      VarIMGSrc = "images/collapse.gif";
    }
    document.write(" <img id=\"" + ParamID + "_arrow\" src=\"" + VarIMGSrc + "\" border=\"0\">");
    document.write("</a>");
  }
}

function  WebWorks_WriteDIVOpen(ParamID, bParamExpanded)
{
  if ((WWHFrame != null) &&
      ( ! WWHFrame.WWHHelp.mbAccessible) &&
      ((typeof(document.all) != "undefined") ||
       (typeof(document.getElementById) != "undefined")))
  {
    if (bParamExpanded)
    {
      document.write("<div id=\"" + ParamID + "\" style=\"visibility: visible; display: block;\">");
    }
    else
    {
      document.write("<div id=\"" + ParamID + "\" style=\"visibility: hidden; display: none;\">");
    }
  }
}

function  WebWorks_WriteDIVClose(ParamID)
{
  if ((WWHFrame != null) &&
      ( ! WWHFrame.WWHHelp.mbAccessible) &&
      ((typeof(document.all) != "undefined") ||
       (typeof(document.getElementById) != "undefined")))
  {
    document.write("</div>");
  }
}

function  WebWorks_ToggleDIV(ParamID)
{
  var  VarImageID;
  var  VarIMG;
  var  VarDIV;

  VarImageID = ParamID + "_arrow";

  if (typeof(document.all) != "undefined")
  {
    // Reference image
    //
    VarIMG = document.all[VarImageID];
    if ((typeof(VarIMG) != "undefined") &&
        (VarIMG != null))
    {
      // Nothing to do
    }
    else
    {
      VarIMG = null;
    }
    // Reference DIV tag
    //
    VarDIV = document.all[ParamID];
    if ((typeof(VarDIV) != "undefined") &&
        (VarDIV != null))
    {
      if (VarDIV.style.display == "block")
      {
        if (VarIMG != null)
        {
          VarIMG.src = "images/collapse.gif";
        }

        VarDIV.style.visibility = "hidden";
        VarDIV.style.display = "none";
      }
      else
      {
        if (VarIMG != null)
        {
          VarIMG.src = "images/expanded.gif";
        }

        VarDIV.style.visibility = "visible";
        VarDIV.style.display = "block";
      }
    }
  }
  else if (typeof(document.getElementById) != "undefined")
  {
    // Reference image
    //
    VarIMG = document[VarImageID];
    if ((typeof(VarIMG) != "undefined") &&
        (VarIMG != null))
    {
      // Nothing to do
    }
    else
    {
      VarIMG = null;
    }

    // Reference DIV tag
    //
    VarDIV = document.getElementById(ParamID);
    if ((typeof(VarDIV) != "undefined") &&
        (VarDIV != null))
    {
      if (VarDIV.style.display == "block")
      {
        if (VarIMG != null)
        {
          VarIMG.src = "images/collapse.gif";
        }
        VarDIV.style.visibility = "hidden";
        VarDIV.style.display = "none";
      }
      else
      {
        if (VarIMG != null)
        {
          VarIMG.src = "images/expanded.gif";
        }
        VarDIV.style.visibility = "visible";
        VarDIV.style.display = "block";
      }
    }
  }
}
