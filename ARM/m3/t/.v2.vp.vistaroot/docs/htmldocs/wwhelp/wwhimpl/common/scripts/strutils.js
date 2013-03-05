// Copyright (c) 2000-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHStringUtilities_GetBaseURL(ParamURL)
{
  var  BaseURL;
  var  Parts;


  // Remove URL parameters
  //
  BaseURL = ParamURL;
  if (BaseURL.indexOf("?") != -1)
  {
    Parts = BaseURL.split("?");
    BaseURL = Parts[0];
  }

  // Trim down to last referenced directory
  //
  BaseURL = ParamURL.substring(0, ParamURL.lastIndexOf("/"));

  // Attempt to match known WWHelp directories
  //
  Parts = BaseURL.split("/wwhelp/wwhimpl/common/html");
  if (Parts[0] == BaseURL)
  {
    Parts = BaseURL.split("/wwhelp/wwhimpl/java/html");
  }
  if (Parts[0] == BaseURL)
  {
    Parts = BaseURL.split("/wwhelp/wwhimpl/js/html");
  }

  // Append trailing slash for this directory
  //
  BaseURL = Parts[0] + "/";

  return BaseURL;
}

function  WWHStringUtilities_SearchReplace(ParamString,
                                           ParamSearchString,
                                           ParamReplaceString)
{
  var  ResultString;
  var  Index;


  ResultString = ParamString;

  if ((ParamSearchString.length > 0) &&
      (ResultString.length > 0))
  {
    Index = 0;
    while ((Index = ResultString.indexOf(ParamSearchString, Index)) != -1)
    {
      ResultString = ResultString.substring(0, Index) + ParamReplaceString + ResultString.substring(Index + ParamSearchString.length, ResultString.length);
      Index += ParamReplaceString.length;
    }
  }

  return ResultString;
}

function  WWHStringUtilities_FormatMessage(ParamMessage,
                                           ParamReplacement1,
                                           ParamReplacement2,
                                           ParamReplacement3,
                                           ParamReplacement4)
{
  var  VarFormattedMessage;
  var  VarSearchString;
  var  VarReplacementStringIndex;
  var  VarIndex;
  var  VarReplacementString;


  VarFormattedMessage = ParamMessage;
  if (VarFormattedMessage.length > 0)
  {
    VarSearchString = "%s";
    VarReplacementStringIndex = 1;
    VarIndex = 0;
    while ((VarIndex = VarFormattedMessage.indexOf(VarSearchString, VarIndex)) != -1)
    {
      VarReplacementString = null;
      if (VarReplacementStringIndex <= 4)
      {
        VarReplacementString = eval("ParamReplacement" + VarReplacementStringIndex);
      }

      if ((typeof(VarReplacementString) != "undefined") &&
          (VarReplacementString != null))
      {
        VarFormattedMessage = VarFormattedMessage.substring(0, VarIndex) + VarReplacementString + VarFormattedMessage.substring(VarIndex + VarSearchString.length, VarFormattedMessage.length);

        VarIndex += VarReplacementString.length;
      }
      else
      {
        VarIndex += VarSearchString.length;
      }

      VarReplacementStringIndex += 1;
    }
  }

  return VarFormattedMessage;
}

function  WWHStringUtilities_EscapeHTML(ParamHTML)
{
  var  EscapedHTML = ParamHTML;


  // Escape problematic characters
  // & < > "
  //
  EscapedHTML = WWHStringUtilities_SearchReplace(EscapedHTML, "&", "&amp;");
  EscapedHTML = WWHStringUtilities_SearchReplace(EscapedHTML, "<", "&lt;");
  EscapedHTML = WWHStringUtilities_SearchReplace(EscapedHTML, ">", "&gt;");
  EscapedHTML = WWHStringUtilities_SearchReplace(EscapedHTML, "\"", "&quot;");

  return EscapedHTML;
}

function  WWHStringUtilities_UnescapeHTML(ParamHTML)
{
  var  Text = ParamHTML;
  var  EscapedExpression;
  var  EscapedCharacterMatches;
  var  EscapeSequence;
  var  CharacterCode;
  var  JavaScriptCharacter;


  // Unescape problematic characters
  //
  // & < > "
  //
  Text = WWHStringUtilities_SearchReplace(Text, "&amp;", "&");
  Text = WWHStringUtilities_SearchReplace(Text, "&lt;", "<");
  Text = WWHStringUtilities_SearchReplace(Text, "&gt;", ">");
  Text = WWHStringUtilities_SearchReplace(Text, "&quot;", "\"");

  // If any still exist, replace them with normal character
  //
  if (Text.indexOf("&#") != -1)
  {
    EscapedExpression = new RegExp("&#([0-9]+);");
    EscapedCharacterMatches = EscapedExpression.exec(Text)
    while (EscapedCharacterMatches != null)
    {
      EscapeSequence = EscapedCharacterMatches[0];
      CharacterCode = parseInt(EscapedCharacterMatches[1]);

      // Turn character code into escaped JavaScript character
      //
      JavaScriptCharacter = String.fromCharCode(CharacterCode);

      // Replace in string
      //
      Text = WWHStringUtilities_SearchReplace(Text, EscapeSequence, JavaScriptCharacter);

      // Find more matches
      //
      EscapedCharacterMatches = EscapedExpression.exec(Text)
    }
  }

  return Text;
}

function  WWHStringUtilities_DecimalToHex(ParamNumber)
{
  var  HexNumber = "";


  HexNumber += WWHStringUtilities_HexDigit(ParamNumber >> 12);
  HexNumber += WWHStringUtilities_HexDigit(ParamNumber >>  8);
  HexNumber += WWHStringUtilities_HexDigit(ParamNumber >>  4);
  HexNumber += WWHStringUtilities_HexDigit(ParamNumber >>  0);

  return HexNumber;
}

function  WWHStringUtilities_HexDigit(ParamDigit)
{
  var  HexDigit;
  var  MaskedDigit = ParamDigit & 0x0F;


  // Translate to hex characters 'a' - 'f' if necessary
  //
  if (MaskedDigit == 10)
  {
    HexDigit = "a";
  }
  else if (MaskedDigit == 11)
  {
    HexDigit = "b";
  }
  else if (MaskedDigit == 12)
  {
    HexDigit = "c";
  }
  else if (MaskedDigit == 13)
  {
    HexDigit = "d";
  }
  else if (MaskedDigit == 14)
  {
    HexDigit = "e";
  }
  else if (MaskedDigit == 15)
  {
    HexDigit = "f";
  }
  else
  {
    HexDigit = MaskedDigit;
  }

  return HexDigit;
}

function  WWHStringUtilities_GetURLFilePathOnly(ParamURL)
{
  var  VarFilePathOnly;
  var  VarIndex;


  VarFilePathOnly = ParamURL;

  // Trim off any parameters
  //
  VarIndex = VarFilePathOnly.indexOf("?");
  if (VarIndex != -1)
  {
    VarFilePathOnly = VarFilePathOnly.substring(0, VarIndex);
  }

  // Trim off named anchor
  //
  VarIndex = VarFilePathOnly.indexOf("#");
  if (VarIndex != -1)
  {
    VarFilePathOnly = VarFilePathOnly.substring(0, VarIndex);
  }

  return VarFilePathOnly;
}

function  WWHStringUtilities_EscapeURLForJavaScriptAnchor(ParamURL)
{
  var  EscapedURL = ParamURL;


  // Escape problematic characters
  // \ " ' < >
  //
  EscapedURL = WWHStringUtilities_SearchReplace(EscapedURL, "\\", "\\\\");
  EscapedURL = WWHStringUtilities_SearchReplace(EscapedURL, "\"", "\\u0022");
  EscapedURL = WWHStringUtilities_SearchReplace(EscapedURL, "'", "\\u0027");
  EscapedURL = WWHStringUtilities_SearchReplace(EscapedURL, "<", "\\u003c");
  EscapedURL = WWHStringUtilities_SearchReplace(EscapedURL, ">", "\\u003e");

  return EscapedURL;
}

function  WWHStringUtilities_EscapeForJavaScript(ParamString)
{
  var  EscapedString = ParamString;


  // Escape problematic characters
  // \ " '
  //
  EscapedString = WWHStringUtilities_SearchReplace(EscapedString, "\\", "\\\\");
  EscapedString = WWHStringUtilities_SearchReplace(EscapedString, "\"", "\\u0022");
  EscapedString = WWHStringUtilities_SearchReplace(EscapedString, "'", "\\u0027");
  EscapedString = WWHStringUtilities_SearchReplace(EscapedString, "\n", "\\u000a");
  EscapedString = WWHStringUtilities_SearchReplace(EscapedString, "\r", "\\u000d");

  return EscapedString;
}

function  WWHStringUtilities_EscapeRegExp(ParamWord)
{
  var  WordRegExpPattern = ParamWord;


  // Escape special characters
  // \ ( ) [ ] . ? + ^ $
  //
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "\\", "\\\\");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, ".", "\\.");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "?", "\\?");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "+", "\\+");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "|", "\\|");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "^", "\\^");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "$", "\\$");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "(", "\\(");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, ")", "\\)");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "{", "\\{");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "}", "\\}");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "[", "\\[");
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "]", "\\]");

  // Windows IE 4.0 is brain dead
  //
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "/", "[/]");

  // Convert * to .*
  //
  WordRegExpPattern = WWHStringUtilities_SearchReplace(WordRegExpPattern, "*", ".*");

  return WordRegExpPattern;
}

function  WWHStringUtilities_WordToRegExpPattern(ParamWord)
{
  var  WordRegExpPattern;


  // Escape special characters
  // Convert * to .*
  //
  WordRegExpPattern = WWHStringUtilities_EscapeRegExp(ParamWord);

  // Add ^ and $ to force whole string match
  //
  WordRegExpPattern = "^" + WordRegExpPattern + "$";

  return WordRegExpPattern;
}

function  WWHStringUtilities_WordToRegExpWithSpacePattern(ParamWord)
{
  var  WordRegExpPattern;


  // Escape special characters
  // Convert * to .*
  //
  WordRegExpPattern = WWHStringUtilities_EscapeRegExp(ParamWord);

  // Add ^ and $ to force whole string match
  // Allow trailing whitespace
  //
  WordRegExpPattern = "^" + WordRegExpPattern + " *$";

  return WordRegExpPattern;
}

function  WWHStringUtilities_ExtractStyleAttribute(ParamAttribute,
                                                   ParamFontStyle)
{
  var  Attribute = "";
  var  AttributeIndex;
  var  AttributeStart;


  AttributeIndex = ParamFontStyle.indexOf(ParamAttribute, 0);
  if (AttributeIndex != -1)
  {
    AttributeStart = ParamFontStyle.indexOf(":", AttributeIndex);

    if (AttributeStart != -1)
    {
      AttributeStart += 1;

      AttributeEnd = ParamFontStyle.indexOf(";", AttributeStart);
      if (AttributeEnd == -1)
      {
        AttributeEnd = ParamFontStyle.length;
      }

      Attribute = ParamFontStyle.substring(AttributeStart + 1, AttributeEnd);
    }
  }

  return Attribute;
}

function  WWHStringBuffer_Object()
{
  this.mStringList        = new Array();
  this.mStringListEntries = 0;
  this.mSize              = 0;

  this.fSize      = WWHStringBuffer_Size;
  this.fReset     = WWHStringBuffer_Reset;
  this.fAppend    = WWHStringBuffer_Append;
  this.fGetBuffer = WWHStringBuffer_GetBuffer;
}

function  WWHStringBuffer_Size()
{
  return this.mSize;
}

function  WWHStringBuffer_Reset()
{
  this.mStringListEntries = 0;
  this.mSize              = 0;
}

function  WWHStringBuffer_Append(ParamString)
{
  this.mSize += ParamString.length;
  this.mStringList[this.mStringListEntries] = ParamString;
  this.mStringListEntries++;
}

function  WWHStringBuffer_GetBuffer()
{
  this.mStringList.length = this.mStringListEntries;

  return this.mStringList.join("");
}
