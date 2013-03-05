// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHPopupHashEmpty_Object()
{
}

function  WWHPopupHash_Object()
{
  this.mPopupHash = new WWHPopupHashEmpty_Object();

  this.fAddPopup         = WWHPopupHash_AddPopup;
  this.fA                = WWHPopupHash_AddPopup;
  this.fIsPopupClickable = WWHPopupHash_IsPopupClickable;
  this.fGetPopupHTML     = WWHPopupHash_GetPopupHTML;
}

function  WWHPopupHash_AddPopup(ParamHREF,
                                bParamClickable,
                                ParamHTML)
{
  this.mPopupHash[ParamHREF + "~"] = new WWHPopupHash_Entry_Object(bParamClickable, ParamHTML);
}

function  WWHPopupHash_IsPopupClickable(ParamHREF)
{
  var  bClickable = true;


  // Popups also are used to link between books in a multivolume
  // help set, so a popup may not be defined
  //
  if (typeof(this.mPopupHash[ParamHREF + "~"]) != "undefined")
  {
    bClickable = this.mPopupHash[ParamHREF + "~"].mbClickable;
  }

  return bClickable;
}

function  WWHPopupHash_GetPopupHTML(ParamHREF)
{
  var  HTML = null;


  if (typeof(this.mPopupHash[ParamHREF + "~"]) != "undefined")
  {
    HTML = this.mPopupHash[ParamHREF + "~"].mHTML;
  }

  return HTML;
}

function  WWHPopupHash_Entry_Object(bParamClickable,
                                    ParamHTML)
{
  this.mbClickable = bParamClickable;
  this.mHTML       = ParamHTML;
}
