package lyc.compiler;

import lyc.compiler.factories.LexerFactory;
import lyc.compiler.model.CompilerException;
import lyc.compiler.model.InvalidIntegerException;
import lyc.compiler.model.InvalidLengthException;
import lyc.compiler.model.UnknownCharacterException;
import org.apache.commons.text.CharacterPredicates;
import org.apache.commons.text.RandomStringGenerator;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static com.google.common.truth.Truth.assertThat;
import static lyc.compiler.constants.Constants.MAX_LENGTH;
import static org.junit.jupiter.api.Assertions.assertThrows;


@Disabled
public class LexerTest {

  private Lexer lexer;



  @Test
  public void comment() throws Exception{
    scan("*-This is a comment-*");
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }

  @Test
  public void invalidStringConstantLength() {
    getRandomString2();
    assertThrows(InvalidLengthException.class, () -> {
      scan("\"%s\"".formatted(getRandomString()));
      nextToken();
    });
  }

  @Test
  public void invalidIdLength() {
    String cadena= getRandomString();
    System.out.println(cadena);
    assertThrows(InvalidLengthException.class, () -> {
      scan(cadena);
      nextToken();
    });
  }

  @Test
  public void invalidPositiveIntegerConstantValue() {
    assertThrows(InvalidIntegerException.class, () -> {
      scan("%d".formatted(9223372036854775807L));
      System.out.println("%d".formatted(9223372036854775807L));
      nextToken();
    });
  }
 /* No valida negativos
  @Test
  public void invalidNegativeIntegerConstantValue() {
    assertThrows(InvalidIntegerException.class, () -> {
      scan("%d".formatted(-9223372036854775807L));
      System.out.println("%d".formatted(-9223372036854775807L));
      nextToken();
    });
  }
*/


  @Test
  public void assignmentWithExpressions() throws Exception {
    scan("c=d*(e-21)/4");
    assertThat(nextToken()).isEqualTo(ParserSym.IDENTIFIER);
    assertThat(nextToken()).isEqualTo(ParserSym.ASSIG);
    assertThat(nextToken()).isEqualTo(ParserSym.IDENTIFIER);
    assertThat(nextToken()).isEqualTo(ParserSym.MULT);
    assertThat(nextToken()).isEqualTo(ParserSym.OPEN_BRACKET);
    assertThat(nextToken()).isEqualTo(ParserSym.IDENTIFIER);
    assertThat(nextToken()).isEqualTo(ParserSym.SUB);
    assertThat(nextToken()).isEqualTo(ParserSym.INTEGER_CONSTANT);
    assertThat(nextToken()).isEqualTo(ParserSym.CLOSE_BRACKET);
    assertThat(nextToken()).isEqualTo(ParserSym.DIV);
    assertThat(nextToken()).isEqualTo(ParserSym.INTEGER_CONSTANT);
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }

  @Test
  public void unknownCharacter() {
    assertThrows(UnknownCharacterException.class, () -> {
      scan("#");
      nextToken();
    });
  }
  // Agregados
  @Test
  public void invalidCteFloat() {
    assertThrows(Exception.class, () -> {
      scan("350000000000000000000111111111111111111.000000000089900000");
      nextToken();
    });
  }
  @Test
  public void invalidCteFloat2() {
    assertThrows(Exception.class, () -> {
      scan("0.00000000000000000000000000000000000000000000035");
      nextToken();
    });
  }


  @AfterEach
  public void resetLexer() {
    lexer = null;
  }

  private void scan(String input) {
    lexer = LexerFactory.create(input);
  }

  private int nextToken() throws IOException, CompilerException , Exception {
    return lexer.next_token().sym;
  }

  private static String getRandomString() {
    return new RandomStringGenerator.Builder()
            .filteredBy(CharacterPredicates.LETTERS)
            .withinRange('a', 'z')
            .build().generate(MAX_LENGTH * 2);
  }

  private static void getRandomString2() {
    System.out.println(new RandomStringGenerator.Builder()
            .filteredBy(CharacterPredicates.LETTERS)
            .withinRange('a', 'z')
            .build().generate(MAX_LENGTH * 2));
  }
}
