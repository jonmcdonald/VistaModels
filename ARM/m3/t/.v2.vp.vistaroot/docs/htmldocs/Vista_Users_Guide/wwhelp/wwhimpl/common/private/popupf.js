// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHPopupFormat_Translate(ParamText)
{
  return ParamText;
}

function  WWHPopupFormat_Format(ParamWidth,
                                ParamTextID,
                                ParamText)
{
  var  FormattedText   = "";
  var  BackgroundColor = WWHFrame.WWHHelp.mSettings.mPopup.mBackgroundColor;
  var  BorderColor     = WWHFrame.WWHHelp.mSettings.mPopup.mBorderColor;
  var  ImageDir        = WWHFrame.WWHHelp.mHelpURLPrefix + "wwhelp/wwhimpl/common/images";
  var  ReqSpacer1w2h   = "<img src=\"" + ImageDir + "/spc1w2h.gif\" width=1 height=2>";
  var  ReqSpacer2w1h   = "<img src=\"" + ImageDir + "/spc2w1h.gif\" width=2 height=1>";
  var  ReqSpacer1w7h   = "<img src=\"" + ImageDir + "/spc1w7h.gif\" width=1 height=7>";
  var  ReqSpacer5w1h   = "<img src=\"" + ImageDir + "/spc5w1h.gif\" width=5 height=1>";
  var  Spacer1w2h      = ReqSpacer1w2h;
  var  Spacer2w1h      = ReqSpacer2w1h;
  var  Spacer1w7h      = ReqSpacer1w7h;
  var  Spacer5w1h      = ReqSpacer5w1h;


  // Netscape 6.x (Mozilla) renders table cells with graphics
  // incorrectly inside of <div> tags that are rewritten on the fly
  //
  if (WWHFrame.WWHBrowser.mBrowser == 4)  // Shorthand for Netscape 6.x (Mozilla)
  {
    Spacer1w2h = "";
    Spacer2w1h = "";
    Spacer1w7h = "";
    Spacer5w1h = "";
  }

  FormattedText += "<table width=\"" + ParamWidth + "\" border=0 cellspacing=0 cellpadding=0 bgcolor=\"" + BackgroundColor + "\">";
  FormattedText += " <tr>";
  FormattedText += "  <td height=2 colspan=5 bgcolor=\"" + BorderColor + "\">" + Spacer1w2h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += "  <td height=7 colspan=3>" + Spacer1w7h + "</td>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td bgcolor=\"" + BorderColor + "\">" + ReqSpacer2w1h + "</td>";
  FormattedText += "  <td>" + ReqSpacer5w1h + "</td>";
  FormattedText += "  <td width=\"100%\" id=\"" + ParamTextID + "\">" + ParamText + "</td>";
  FormattedText += "  <td>" + ReqSpacer5w1h + "</td>";
  FormattedText += "  <td bgcolor=\"" + BorderColor + "\">" + ReqSpacer2w1h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += "  <td height=7 colspan=3>" + Spacer1w7h + "</td>";
  FormattedText += "  <td height=7 bgcolor=\"" + BorderColor + "\">" + Spacer2w1h + "</td>";
  FormattedText += " </tr>";

  FormattedText += " <tr>";
  FormattedText += "  <td height=2 colspan=5 bgcolor=\"" + BorderColor + "\">" + Spacer1w2h + "</td>";
  FormattedText += " </tr>";
  FormattedText += "</table>";

  return FormattedText;
}
