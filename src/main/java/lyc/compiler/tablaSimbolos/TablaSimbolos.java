package lyc.compiler.tablaSimbolos;
import java.util.*;
import java.io.File;
import java.io.FileWriter;
import java.io.BufferedWriter;



public class TablaSimbolos {
    private Map<String, Simbolo> t;
    public TablaSimbolos(){
        System.out.println("Se creo la tabla de simbolos");
        t = new HashMap<String, Simbolo>();
    }
    public void insertar(Simbolo simbolo){
        System.out.println("Se inserta en tabla");
        t.put(simbolo.getNombre(), simbolo);
    }
    public  Simbolo buscar(String nombre){
        return (t.get(nombre));
    }
    public void imprimir(){
        Iterator it = t.values().iterator();
        while(it.hasNext()){
            Simbolo s = (Simbolo)it.next();
            System.out.println(s.nombre + ": "+ s.valor);
        }
    }
    public void escribir(){

        try {
            String ruta = "./Tabla_de_simbolos.txt";
            File file = new File(ruta);
            if (!file.exists()) {
                file.createNewFile();
            }
            FileWriter fw = new FileWriter(file);
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write(String.format("%-40s", "Nombre")+"|" + String.format("%-40s", "Tipo")+"|" +
                    String.format("%-40s", "Valor")+ "|" + String.format("%-10s", "Longitud")+"\n");
            bw.write(String.format("%-130s", "-").replace(' ','-')+"\n");


            Iterator it = t.values().iterator();
            while(it.hasNext()){
                Simbolo s = (Simbolo)it.next();
                bw.write(String.format("%-40s", s.getNombre()) + "|" + String.format("%-40s",s.getTipoDato()) +
                        "|" + String.format("%-40s",s.getValor() )+ "|" +String.format("%-10s",s.getLongitud() )+"\n");
                bw.write(String.format("%-130s", "_").replace(' ','_')+"\n");

            }
            bw.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

}
