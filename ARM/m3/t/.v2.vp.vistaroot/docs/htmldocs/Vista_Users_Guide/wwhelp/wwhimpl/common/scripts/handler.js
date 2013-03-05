// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHHandler_Object()
{
  this.mbInitialized = false;

  this.fInit              = WWHHandler_Init;
  this.fFinalize          = WWHHandler_Finalize;
  this.fGetFrameReference = WWHHandler_GetFrameReference;
  this.fGetFrameName      = WWHHandler_GetFrameName;
  this.fIsReady           = WWHHandler_IsReady;
  this.fUpdate            = WWHHandler_Update;
  this.fSyncTOC           = WWHHandler_SyncTOC;
  this.fProcessAccessKey  = WWHHandler_ProcessAccessKey;
  this.fGetCurrentTab     = WWHHandler_GetCurrentTab;
}

function  WWHHandler_Init()
{
  this.mbInitialized = true;
  WWHFrame.WWHHelp.fHandlerInitialized();
}

function  WWHHandler_Finalize()
{
}

function  WWHHandler_GetFrameReference(ParamFrameName)
{
  var  VarFrameReference;


  // Nothing to do
  //

  return VarFrameReference;
}

function  WWHHandler_GetFrameName(ParamFrameName)
{
  var  VarName = null;


  // Nothing to do
  //

  return VarName;
}

function  WWHHandler_IsReady()
{
  var  bVarIsReady = true;


  return bVarIsReady;
}

function  WWHHandler_Update(ParamBookIndex,
                            ParamFileIndex)
{
}

function  WWHHandler_SyncTOC(ParamBookIndex,
                             ParamFileIndex,
                             ParamAnchor,
                             bParamReportError)
{
  setTimeout("WWHFrame.WWHControls.fSwitchToNavigation();", 1);
}

function  WWHHandler_ProcessAccessKey(ParamAccessKey)
{
  switch (ParamAccessKey)
  {
    case 1:
      WWHFrame.WWHControls.fSwitchToNavigation("contents");
      break;

    case 2:
      WWHFrame.WWHControls.fSwitchToNavigation("index");
      break;

    case 3:
      WWHFrame.WWHControls.fSwitchToNavigation("search");
      break;
    case 4:
      WWHFrame.WWHControls.fSwitchToNavigation("favorites");
      break;
    case 5:
      WWHFrame.WWHControls.fSwitchToNavigation("history");
      break;
  }
}

function  WWHHandler_GetCurrentTab()
{
  var  VarCurrentTab;


  // Initialize return value
  //
  VarCurrentTab = "";

  return VarCurrentTab;
}
