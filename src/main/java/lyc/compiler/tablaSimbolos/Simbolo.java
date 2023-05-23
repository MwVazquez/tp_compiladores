package lyc.compiler.tablaSimbolos;

public class Simbolo {
     String nombre,valor,tipoDato;
     int longitud;


    public Simbolo(String nombre, String valor,String tipoDato,int longitud) {
        this.nombre = nombre;
        this.valor = valor;
        this.tipoDato = tipoDato;
        this.longitud= longitud;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getValor() {
        return valor;
    }

    public void setValor(String valor) {
        this.valor = valor;
    }

    public String getTipoDato() {
        return tipoDato;
    }

    public void setTipoDato(String tipoDato) {
        this.tipoDato = tipoDato;
    }

    public int getLongitud() {
        return longitud;
    }

    public void setLongitud(int longitud) {
        this.longitud = longitud;
    }



}
