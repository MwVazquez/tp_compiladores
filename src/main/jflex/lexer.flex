package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;
import static lyc.compiler.constants.Constants.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}


%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}


LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]

Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"
Backslash = "\\"
Assig = "="
OpenBracket = "("
CloseBracket = ")"
Int = "Int"
Char = "Char"
Float = "Float"
Letter = [a-zA-Z]
Digit = [0-9]
Guion = "-"
Caracter = [a-z|A-Z|0-9|=|>|<|!|:|+|-|*|/|\"|?|¿|!|¡|@|%|#|&|°|´|\^|`|~|/|\\|_|.|,|;|¬||| ]
Init = "init"

Comentario = {Mult}{Guion} {Caracter}* {Guion}{Mult}
WhiteSpace = {LineTerminator} | {Identation}
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}+


%%


/* keywords */

<YYINITIAL> {

  /* reserved words */
      /*Types*/
      {Int}                                     { return symbol(ParserSym.INT); }
      {Char}                                    { return symbol(ParserSym.CHAR); }
      {Float}                                   { return symbol(ParserSym.FLOAT); }
  {Init}                                    { return symbol(ParserSym.INIT); }

  /* identifiers */
  {Identifier}                             { System.out.println("Identifier: "+ yytext());
                                            return symbol(ParserSym.IDENTIFIER, yytext()); }
  /* Constants */
  {IntegerConstant}                        { return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }
  /* Comments */
  {Comentario}                             { System.out.println("Comentario");/* ignore */ }





  /* operators */
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {Backslash}                               { return symbol(ParserSym.BACKSLASH); }
  {Assig}                                   { return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }


  /* whitespace */
  {WhiteSpace}                               { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext() + yyline); }
