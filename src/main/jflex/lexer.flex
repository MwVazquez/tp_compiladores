package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;
import lyc.compiler.tablaSimbolos.TablaSimbolos;
import lyc.compiler.tablaSimbolos.Simbolo;
import java.lang.Float;


import static lyc.compiler.constants.Constants.*;
import java.util.ArrayList;

%%
%{
    private static final int MAX_CADENA = 40;
    private static final int MAX_INT = 32767;
    private static final int MIN_INT = -32768;
    TablaSimbolos tablaSimbolos= new TablaSimbolos();



    public int validarCteCadena(String cadena) throws InvalidLengthException {
          if(cadena.length() > MAX_CADENA)
            throw new InvalidLengthException(cadena + ": es demasiado larga");

          return 1;
    }
    public int validarCteInteger(String cadena) throws InvalidIntegerException{
        System.out.println("Validar Integer");
        int number=0;
        try{
            number = Integer.parseInt(cadena);
           }
        catch (NumberFormatException ex){
               throw new InvalidIntegerException ("el valor " + cadena + " esta fuera de rango [" + MIN_INT + " : " + MAX_INT );
            }
        if(number < MIN_INT || number > MAX_INT)
            throw new InvalidIntegerException ("el valor " + cadena + " esta fuera de rango [" + MIN_INT + " : " + MAX_INT);
        return 1 ;
    }

    public int validarCteFloat(String cadena) throws Exception{
        System.out.println("Validar Float");
        float number=0;
        try{
            number = Float.parseFloat(cadena);
             System.out.println(number);
        }
        catch (NumberFormatException ex){
             System.out.println("Error: " + ex.getMessage());
        }
        if(number < Float.MIN_VALUE || number > Float.MAX_VALUE)
            throw new Exception ("el valor esta fuera de rango" + Float.MIN_VALUE +":" + Float.MAX_VALUE);
        return 1 ;
    }

%}

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException , InvalidLengthException , Exception
%eofval{
  tablaSimbolos.escribir();
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
Caracter = [a-zA-ZÀ-ÿ\u00f1\u00d1|0-9|=|>|<|!|:|+|-|*|/|\"|?|¿|!|¡|@|%|#|&|°|´|\^|`|~|/|\\|_|.|,|;|¬||||“|” ]
Caracter2 = [a-z|A-Z|0-9|=|>|<|!|:|+|-|*|/|\"|?|¿|!|¡|@|%|#|&|°|´|\^|`|~|/|\\|_|.|,|;|¬||||“|” ]
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
   {CteCadena}                               { Simbolo s = new Simbolo(yytext(), yytext(),"CTE_String",yylength());
                                               tablaSimbolos.insertar(s);validarCteCadena(yytext());return symbol(ParserSym.CTE_CADENA, yytext()); }
   {IntegerConstant}                         { Simbolo s = new Simbolo(yytext(), yytext(),"CTE_Int",yylength());
                                                tablaSimbolos.insertar(s);
                                                System.out.println("return Integer");
                                                validarCteInteger(yytext());

                                                return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }


   {FloatConstant}                           { System.out.println("FLOAT");
                                                Simbolo s = new Simbolo(yytext(), yytext(),"CTE_Float",yylength());
                                                System.out.println("return Float");
                                                validarCteFloat(yytext());
                                               tablaSimbolos.insertar(s);
                                               return symbol(ParserSym.FLOAT_CONSTANT, yytext()); }
    /* Comments */
   {Comentario}                              { System.out.println("Comentario");/* ignore */ }


  /* operators */
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {And}                                     { return symbol(ParserSym.AND); }
  {Not}                                     { System.out.println("NOT");return symbol(ParserSym.NOT); }
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
    {Identifier}                             { Simbolo s = new Simbolo(yytext(), yytext(),"",yylength());
                                                validarCteCadena(yytext());
                                               tablaSimbolos.insertar(s);
                                               return symbol(ParserSym.IDENTIFIER, yytext()); }

  /* whitespace */
  {WhiteSpace}                               { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }
