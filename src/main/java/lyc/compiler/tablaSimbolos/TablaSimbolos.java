package lyc.compiler.tablaSimbolos;
import java.util.*;
public class TablaSimbolos {
    public static Map<String, Simbolo> t;
    public TablaSimbolos(){
        System.out.println("Se creo la tabla de simbolos");
        t = new HashMap<>();
    }
    // ver como incluir el metodo o como implementarlo desde lexer.flex
    public Simbolo insertar(String nombre){
        System.out.println("Se inserta en tabla");
        Simbolo s = new Simbolo(nombre, 0);
        t.put(nombre, s);
        return s;
    }
    public static Simbolo buscar(String nombre){
        return (t.get(nombre));
    }
    public void imprimir(){
        Iterator it = t.values().iterator();
        while(it.hasNext()){
            Simbolo s = (Simbolo)it.next();
            System.out.println(s.nombre + ": "+ s.valor);
        }
    }

}
