import java.util.ArrayList;
import java.util.Iterator;


public class TabSimb
{
    private ArrayList<TS_entry> lista;
    
    public TabSimb( )
    {
        lista = new ArrayList<TS_entry>();
    }
    
     public void insert( TS_entry nodo ) {
      lista.add(nodo);
    }    
    
    public void listar() {
      int cont = 0;  
      System.out.println("\n\nListagem da tabela de simbolos:\n");
      for (TS_entry nodo : lista) {
          System.out.println(nodo);
      }
    }

    public boolean isResolved(String tipo){
      for (TS_entry nodo : lista)
          if (nodo.getId().equals(tipo))
              return true;
      return false;
    }

    public void resolveType(String tipo){
        for(TS_entry nodo : lista){
            if(nodo.getTipo() instanceof TS_entry)
                if(nodo.getTipo().getId().equals(tipo))
                    nodo.resolveType();
        }
    }

    public TS_entry pesquisa(String umId) {
      for (TS_entry nodo : lista) {
          if (nodo.getId().equals(umId)) {
	      return nodo;
            }
      }
      return null;
    }

    public  ArrayList<TS_entry> getLista() {return lista;}
}



