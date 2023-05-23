package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.factories.ParserFactory;
import org.apache.commons.io.IOUtils;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import javax.management.PersistentMBean;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import static com.google.common.truth.Truth.assertThat;
import static lyc.compiler.Constants.EXAMPLES_ROOT_DIRECTORY;
import static org.junit.jupiter.api.Assertions.assertThrows;

@Disabled
public class ParserTest {

    // Agregadas
    @Test
    public void EstaContenido() throws Exception {
        compilationSuccessful("EstaContenido(\"Homplato\", \"plato\")");
    }
    @Test
    public void ifEstaContenido() throws Exception {
        compilationSuccessful("if(EstaContenido(\"Homplato\", \"plato\")){ a=h}");
    }
    @Test
    public void cicloEstaContenido() throws Exception {
        compilationSuccessful("ciclo (EstaContenido(\"Homplato\", \"plato\") ) {a = a + 1}");
    }
    @Test
    public void cicloEstaContenidoYcondicion() throws Exception {
        compilationSuccessful("ciclo (EstaContenido(\"Homplato\", \"plato\") || a<b) {a = a + 1}");
    }
    //

    @Test
    public void assignmentWithExpression() throws Exception {
        compilationSuccessful("c=d*(e-21)/4");
    }

    @Test
    public void syntaxError() {
        compilationError("1234");
    }

    @Test
    void assignments() throws Exception {
        compilationSuccessful(readFromFile("assignments.txt"));
    }

    @Test
    void write() throws Exception {
        compilationSuccessful(readFromFile("write.txt"));
    }

    @Test
    void write2() throws Exception {
        compilationSuccessful("write(\"a es mas grande que b\")");
    }
    @Test
    void write3() throws Exception {
        compilationSuccessful(" write(“ewr”)");
    }
    @Test
    void write4() throws Exception {
        compilationSuccessful(" write(var1)");
    }

    @Test
    void read() throws Exception {
        compilationSuccessful(readFromFile("read.txt"));
    }

    @Test
    public void read2() throws Exception {
        compilationSuccessful("read(base)");
    }

    @Test
    void comment() throws Exception {
        compilationSuccessful(readFromFile("comment.txt"));
    }

    @Test
    void init() throws Exception {
        compilationSuccessful(readFromFile("init.txt"));
    }
    /*
    @Test
    void and() throws Exception {
        compilationSuccessful(readFromFile("and.txt"));
    }

    @Test
    void or() throws Exception {
        compilationSuccessful(readFromFile("or.txt"));
    }
    */
    @Test
    void not() throws Exception {
        compilationSuccessful(readFromFile("not.txt"));
    }

    @Test
    void ifStatement() throws Exception {
        compilationSuccessful(readFromFile("if.txt"));
    }

    @Test
    void whileStatement() throws Exception {
        compilationSuccessful(readFromFile("while.txt"));
    }
    @Test
    void ifSinElse() throws Exception {
        compilationSuccessful("if(temp<10){\n" +
                "            mensaje = \"Hace mucho frío.\"\n" +
                "        }");
    }
    @Test
    void ifConElse() throws Exception {
        compilationSuccessful("if(temp<10){\n" +
                "            mensaje = \"Hace mucho frío.\"\n" +
                "        }\n" +
                "        else{\n" +
                "                mensaje = \"Hace poco frío.\"\n" +
                "            }");
    }
    @Test
    void elseIf() throws Exception {
        compilationSuccessful("if(temp<10){\n" +
                "            mensaje = \"Hace mucho frío.\"\n" +
                "\t}     \n" +
                "else{\n" +
                "    if(temp<15){\n" +
                "                mensaje = \"Hace poco frío.\"\n" +
                "              }\n" +
                "     else{\n" +
                "           if(temp<25){\n" +
                "                       mensaje = \"Hace una temperatura normal.\"\n" +
                "                      }\n" +
                "\t  }\n" +
                "     }");


    }


    @Test
    void ifAnidado() throws Exception {
        compilationSuccessful("if(temp<10){\n" +
                "            mensaje = \"Hace mucho frío.\"\n" +
                "        }\n" +
                "        else{\n" +
                "            if(temp<15){\n" +
                "                mensaje = \"Hace poco frío.\"\n" +
                "            }\n" +
                "            else{\n" +
                "                if(temp<25){\n" +
                "                    mensaje = \"Hace una temperatura normal.\"\n" +
                "                }\n" +
                "                else{\n" +
                "                    if(temp<30){\n" +
                "                        mensaje = \"Hace poco calor.\"\n" +
                "                    }\n" +
                "                    else{\n" +
                "                        mensaje = \"Hace mucho calor.\"\n" +
                "                    }\n" +
                "                }\n" +
                "            }\n" +
                "        }");
    }

    @Test
    public void notCondicion() throws Exception {
        compilationSuccessful("if (not a <b) {a=b}");
    }

    @Test
    public void notCondicionParentesis() throws Exception {
        compilationSuccessful("if (not (a <b)) {a=b}");
    }
    private void compilationSuccessful(String input) throws Exception {
        assertThat(scan(input).sym).isEqualTo(ParserSym.EOF);
    }

    private void compilationError(String input){
        assertThrows(Exception.class, () -> scan(input));
    }

    private Symbol scan(String input) throws Exception {
        return ParserFactory.create(input).parse();
    }

    private String readFromFile(String fileName) throws IOException {
        URL url = new URL(EXAMPLES_ROOT_DIRECTORY + "/%s".formatted(fileName));
        assertThat(url).isNotNull();
        return IOUtils.toString(url.openStream(), StandardCharsets.UTF_8);
    }


}
