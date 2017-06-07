import java.util.ArrayList;

public class TS_entry {
    private String id;
    private ClasseID classe;  
    private String escopo;
    private TS_entry tipo;
    private int nElem;
    private TS_entry tipoBase;
    private TabSimb locais;

    public TS_entry(String umId, TS_entry umTipo,  int ne, TS_entry umTBase, String umEscopo, ClasseID umaClasse) {
        id = umId;
        tipo = umTipo;
        escopo = umEscopo;
        nElem = ne;
        tipoBase = umTBase;
        classe = umaClasse;
        locais = new TabSimb();
    }

    public TS_entry(String umId, TS_entry umTipo, String escopo, ClasseID classe) {
        this(umId, umTipo, -1, null, escopo, classe);
    }


    public String getId() {
        return id;
    }

    public TS_entry getTipo() {
        return tipo;
    }

    public String getTipoStr() {
        return tipo2str(this);
    }

    public int getNumElem() {
        return nElem;
    }

    public TS_entry getTipoBase() {
        return tipoBase;
    }


    public String toString() {
        StringBuilder aux = new StringBuilder("");

        aux.append("Id: ");
        aux.append(String.format("%-10s", id));
        aux.append("\tClasse: ");
        aux.append(classe);
        aux.append("\tEscopo: ");
        aux.append(String.format("%-4s", escopo));
        aux.append("\tTipo: "); 
        aux.append(tipo2str(this.tipo)); 

        if (this.tipo == Parser.Tp_ARRAY) {
            aux.append(" (ne: ");
            aux.append(nElem);
            aux.append(", tBase: ");
            aux.append(tipo2str(this.tipoBase));
            aux.append(")");
        }

        ArrayList<TS_entry> lista = locais.getLista();
        for (TS_entry t : lista) {
            aux.append("\n\t");
            aux.append(t.toString());
        }

        return aux.toString();
    }

    public String tipo2str(TS_entry tipo) {
        if (tipo == null)
            return "null"; 
        else if (tipo==Parser.Tp_INT)
            return "int"; 
        else if (tipo==Parser.Tp_BOOL)
            return "boolean"; 
        else if (tipo==Parser.Tp_ARRAY)
            return "array";
        else if (tipo==Parser.Tp_ERRO)
            return  "_erro_";
        else
            return "erro/tp";
    }
}
