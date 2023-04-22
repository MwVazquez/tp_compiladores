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
String = "String"
Letter = [a-zA-Z]
Digit = [0-9]
Guion = "-"
Caracter = [a-z|A-Z|0-9|=|>|<|!|:|+|-|*|/|\"|?|¿|!|¡|@|%|#|&|°|´|\^|`|~|/|\\|_|.|,|;|¬||| ]
CteCadena1 = \"([^\"\\]|\\.)*\"
CteCadena2 = \“([^\"\\]|\\.)*\”
Init = "init"
TwoPoints = ":"
PuntoYcoma = ";"
Coma = ","
LlaveAbre = "{"
LlaveCierra = "}"
And = "&"
Or = "||"
Not = "not"
Mayor = ">"
MayorIgual = ">="
Menor = "<"
MenorIgual = "<="
Igual = "=="
Distinto = "<>"
If = "if"
Else = "else"
Ciclo = "ciclo"

Write = "write"

CteCadena = {CteCadena1} | {CteCadena2}
Comentario = {Mult}{Guion} {Caracter}* {Guion}{Mult}
WhiteSpace = {LineTerminator} | {Identation}
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}+


%%


/* keywords */

<YYINITIAL> {
  /*Types*/
  {Int}                                     { return symbol(ParserSym.INT); }
  {Char}                                    { return symbol(ParserSym.CHAR); }
  {Float}                                   { System.out.println("Float"); return symbol(ParserSym.FLOAT); }
  {String}                                  { return symbol(ParserSym.STRING); }

  /* reserved words */
  {Init}                                    { System.out.println("Init");return symbol(ParserSym.INIT); }
  {Ciclo}                                   { System.out.println("Ciclo");return symbol(ParserSym.CICLO); }
  {If}                                      { return symbol(ParserSym.IF); }
  {Else}                                    { return symbol(ParserSym.ELSE); }
  {Write}                                   { return symbol(ParserSym.WRITE); }

  /* Constants */
  {CteCadena}                               { return symbol(ParserSym.CTE_CADENA, yytext()); }
  {IntegerConstant}                         { return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }
  /* Comments */
  {Comentario}                              { System.out.println("Comentario");/* ignore */ }





  /* operators */
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {And}                                     { return symbol(ParserSym.AND); }
  {Not}                                     { return symbol(ParserSym.NOT); }
  {Or}                                      { return symbol(ParserSym.OR); }

  {Mayor}                                  { return symbol(ParserSym.MAYOR); }
  {MayorIgual}                             { return symbol(ParserSym.MAYOR_IGUAL); }
  {Menor}                                  { return symbol(ParserSym.MENOR); }
  {MenorIgual}                             { return symbol(ParserSym.MENOR_IGUAL); }
  {Igual}                                  { return symbol(ParserSym.IGUAL); }
  {Distinto}                               { return symbol(ParserSym.DISTINTO); }








  /* simbols */
  {Assig}                                   { return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }
  {TwoPoints}                               { System.out.println("dos puntos"); return symbol(ParserSym.TWOPOINTS); }
  {PuntoYcoma}                              { return symbol(ParserSym.P_COMA); }
  {Coma}                                    { System.out.println("coma"); return symbol(ParserSym.COMA); }
  {LlaveAbre}                               { return symbol(ParserSym.LLAVEABRE); }
  {LlaveCierra}                             { System.out.println("}");return symbol(ParserSym.LLAVECIERRA); }

  /* identifiers */
    {Identifier}                             { System.out.println("Identifier: "+ yytext());
                                              return symbol(ParserSym.IDENTIFIER, yytext()); }

  /* whitespace */
  {WhiteSpace}                               { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext() + yyline); }
