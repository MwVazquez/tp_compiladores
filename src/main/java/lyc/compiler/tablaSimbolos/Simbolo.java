package lyc.compiler.tablaSimbolos;

public class Simbolo {
     String nombre;
     int valor;
    public Simbolo(String nombre, int valor){
        this.nombre = nombre;
        this.valor = valor;
    }

    public String getNombre() {
        return nombre;
    }

    public int getValor() {
        return valor;
    }
}
