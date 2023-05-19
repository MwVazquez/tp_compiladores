package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;
import lyc.compiler.tablaSimbolos.TablaSimbolos;
import lyc.compiler.tablaSimbolos.Simbolo;


import static lyc.compiler.constants.Constants.*;
import java.util.ArrayList;

%%
%{
    private static final int MAX_CADENA = 40;
    private static final int MAX_INT = 32767;
    private static final int MIN_INT = -32768;



    public int validarCteCadena(String cadena) throws InvalidLengthException {
          if(cadena.length() > MAX_CADENA)
            throw new InvalidLengthException(cadena + ": es demasiado larga");

          return 1;
    }

     public int validarCteInteger(String cadena) throws InvalidIntegerException{
        int number;
        try{
            number = Integer.parseInt(cadena);
           }
        catch (NumberFormatException ex){
                throw new InvalidIntegerException ("el valor es mayor a :" + MAX_INT );
            }
        if(number < MIN_INT || number > MAX_INT)
            throw new InvalidIntegerException ("el valor es mayor a :" + MAX_INT );
        return 1 ;
     }




%}

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException , InvalidLengthException
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
CteCadena2 = \“([^\“\\]|\\.)*\”
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
Read = "read"
EstaContenido = "EstaContenido"

CteCadena = {CteCadena1} | {CteCadena2}
Comentario = {Mult}{Guion} {Caracter}* {Guion}{Mult}
WhiteSpace = {LineTerminator} | {Identation}
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}+
FloatConstant = ({Digit}*\.{Digit}+) | ({Digit}+\.{Digit}*)


%%

/* keywords */

<YYINITIAL> {
  /*Types*/
  {Int}                                     { return symbol(ParserSym.INT); }
  {Char}                                    { return symbol(ParserSym.CHAR); }
  {Float}                                   { return symbol(ParserSym.FLOAT); }
  {String}                                  { return symbol(ParserSym.STRING); }

  /* reserved words */
  {Init}                                    { return symbol(ParserSym.INIT); }
  {Ciclo}                                   { return symbol(ParserSym.CICLO); }
  {If}                                      { return symbol(ParserSym.IF); }
  {Else}                                    { return symbol(ParserSym.ELSE); }
  {Write}                                   { return symbol(ParserSym.WRITE); }
  {Read}                                    { return symbol(ParserSym.READ); }
  {EstaContenido}                           { return symbol(ParserSym.ESTACONTENIDO); }


/* Constants */
   {CteCadena}                               { validarCteCadena(yytext());return symbol(ParserSym.CTE_CADENA, yytext()); }
   {IntegerConstant}                         { validarCteInteger(yytext());return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }
   {FloatConstant}                           { return symbol(ParserSym.FLOAT_CONSTANT, yytext()); }
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
  {TwoPoints}                               { return symbol(ParserSym.TWOPOINTS); }
  {PuntoYcoma}                              { return symbol(ParserSym.P_COMA); }
  {Coma}                                    { return symbol(ParserSym.COMA); }
  {LlaveAbre}                               { return symbol(ParserSym.LLAVEABRE); }
  {LlaveCierra}                             { return symbol(ParserSym.LLAVECIERRA); }

  /* identifiers */
    {Identifier}                             { Simbolo s = new Simbolo(yytext(), 0);
                                                TablaSimbolos.t.put(yytext(), s);
                                                System.out.println(TablaSimbolos.t.get(yytext()).getNombre() +"....");
                                               // TablaSimbolos.t.get(yytext());

                                                //TablaSimbolos.t.insertar(yytext());
                                                //System.out.println(TablaSimbolos.t.);
                                                return symbol(ParserSym.IDENTIFIER, yytext()); }

  /* whitespace */
  {WhiteSpace}                               { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }
