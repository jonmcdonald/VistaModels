// Copyright 2006 Mentor Graphics Corporation
//
function MGCHighlight(uBodyText, searchTerm) 
{

//   HighlightBegin = "<font style='color:blue; background-color:yellow;'>";
//   HighlightEnd = "</font>";
   HighlightEnd = "</span>";
  
   // locate the search term in the body of the page and add highlight span tags.
   // ignore all HTML tags
   var newText = "";
   var i = -1;
   var HCount = 1;
   var Term = searchTerm.toLowerCase().replace("\*","").replace("\*","").replace("\*","");
   var lcaseTerm = Term;
   var lcaseBodyText = uBodyText.toLowerCase();
   while (uBodyText.length > 0) {
     i = lcaseBodyText.indexOf(lcaseTerm, i+1);
     if (i < 0) {
       newText += uBodyText;
       uBodyText = "";
     } else {
     //<span class="cLink">
//       if (HCount == 1) { Anchor = "<a name\=SString1" + "><\/a>"; } else { Anchor = ""; }
       HighlightBegin = "<span id=\"SString" + HCount + "\" style=\"background-color:yellow;\">";
       // skip anything inside an HTML tag
       if (uBodyText.lastIndexOf(">", i) >= uBodyText.lastIndexOf("<", i)) {
         // don't highlight content isnside a <script> block
         if (lcaseBodyText.lastIndexOf("/script>", i) >= lcaseBodyText.lastIndexOf("<script", i)) {
//           newText += uBodyText.substring(0, i) + HighlightBegin + uBodyText.substr(i, searchTerm.length) + HighlightEnd + Anchor;
           newText += uBodyText.substring(0, i) + HighlightBegin + uBodyText.substr(i, lcaseTerm.length) + HighlightEnd;
           HCount ++;
           uBodyText = uBodyText.substr(i + lcaseTerm.length);
           lcaseBodyText = uBodyText.toLowerCase();
           i = -1;
         }
       }
     }
   }
   WWHFrame.PageHits = HCount - 1;
   return newText;
}


function MGCHighlightSearchTerms(searchText, PhraseSearch)
{
   //  if the PhraseSearch parameter is true, search for the entire phrase that was entered;
   //  otherwise, split the search string and highlight individual words
   //  For now, always highlight individual words - reserve phrase for future
  
   if ((PhraseSearch) || (typeof(PhraseSearch) == "undefined"))
   {
      searchArray = [searchText];
   }
   else
   {
      searchArray = searchText.split(" ");
   }
   if (!WWHFrame.MGCContent.MGCDocContent.document.body || typeof(WWHFrame.MGCContent.MGCDocContent.document.body.innerHTML) == "undefined") {
//      alert("Warning: Body text not available.");
      return false;
   }
   BeginHString = "--EnDhEaDeR--";
   EndHString = "PDFLinkTitle";
   var BodyText = WWHFrame.MGCContent.MGCDocContent.document.body.innerHTML.replace("--EnDhEaDeR-->","--EnDhEaDeR-->     ") ;
   HStartIx = BodyText.indexOf(BeginHString);
   HEndIx = BodyText.indexOf(EndHString);
   header = BodyText.slice(0,(HStartIx+16));
   footer = BodyText.slice(HEndIx,BodyText.length-1);
   OnlyBodyText = BodyText.slice(HStartIx+16,HEndIx);
   Text = OnlyBodyText;
   for (var i = 0; i < searchArray.length; i++)
   {
      Text = WWHFrame.MGCHighlight(Text, searchArray[i]);
   }
   WWHFrame.MGCContent.MGCDocContent.document.body.innerHTML = header + Text + footer;
   return true;
}
