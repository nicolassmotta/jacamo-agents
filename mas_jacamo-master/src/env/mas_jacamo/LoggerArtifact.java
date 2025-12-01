package mas_jacamo;

import cartago.*;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

public class LoggerArtifact extends Artifact {

    private PrintWriter writer;

    void init() {
        try {
            String filename = "simulacao_log_" + System.currentTimeMillis() + ".csv";
            writer = new PrintWriter(new FileWriter(filename, true));
            writer.println("Tempo;Agente;Evento;Detalhe");
            writer.flush();
            System.out.println("Logger criado: " + filename);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @OPERATION
    void log(Object agente, Object evento, Object detalhe) { 
        if (writer != null) {
            String time = LocalDateTime.now().toString();
            String linha = time + ";" + agente.toString() + ";" + evento.toString() + ";" + detalhe.toString();
            
            writer.println(linha);
            writer.flush();
        }
    }
}