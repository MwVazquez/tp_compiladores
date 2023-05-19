package lyc.compiler.files;

import lyc.compiler.tablaSimbolos.TablaSimbolos;

import java.io.FileWriter;
import java.io.IOException;

public class SymbolTableGenerator implements FileGenerator{
    //public TablaSimbolos tabla;
    public SymbolTableGenerator(){
        System.out.println("Se crea tabla de simbolos");
      //  tabla = new TablaSimbolos();
    }

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        fileWriter.write("TODO");
    }
}
