// Copyright 2005 Mentor Graphics Corporation.  All rights reserved.
//


function  WWHBookGroups_Books(ParamTop)
{
   switch (WWHFrame.MySearchPrefs)
   {
      case "LIB": MyList = WWHFrame.mLibraryList; break;
      case "MYDOCS": MyList = WWHFrame.mMyDocsList; break;
      case "SNet": MyList = WWHFrame.mLibraryList; break;
      case "IHUB": MyList = WWHFrame.mLibraryList; break;
      case "DOC": MyList = WWHFrame.mLibraryList; break;
      default: MyList = WWHFrame.mLibraryList;
   }
   for (Mx = MyList.length, Ix = 0; Ix < Mx ; Ix++)
   {
   if (MyList[Ix][1] != "zzZZzz")
      {
         ParamTop.fAddDirectory(MyList[Ix][1], null, null, null, null);
      }
   }
}

function  WWHBookGroups_ShowBooks()
{
  return true;
}

function  WWHBookGroups_ExpandAllAtTop()
{
  return false;
}
function MGCLoadAlternateBookData()
{
   return;
}