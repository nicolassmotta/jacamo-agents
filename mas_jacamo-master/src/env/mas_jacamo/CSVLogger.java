package mas_jacamo;

import cartago.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CSVLogger extends Artifact {

    private PrintWriter writer;
    private String fileName;

    void init() {
        try {
            String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            fileName = "log/simulacao_" + timeStamp + ".csv";
            File logDir = new File("log");

            if (!logDir.exists()) logDir.mkdir();

            FileWriter fw = new FileWriter(fileName, true);
            BufferedWriter bw = new BufferedWriter(fw);
            writer = new PrintWriter(bw);
            writer.println("Timestamp;Agente;Evento;Detalhes");
            writer.flush();
            
            System.out.println("[CSVLogger] Log iniciado em: " + fileName);

        } catch (IOException e) {
            e.printStackTrace();
            failed("Erro ao criar arquivo de log: " + e.getMessage());
        }
    }

    @OPERATION
    void logData(String agente, String evento, String detalhes) {
        synchronized (this) {
            if (writer != null) {
                String time = new SimpleDateFormat("HH:mm:ss.SSS").format(new Date());
                String safeDetalhes = detalhes != null ? detalhes.replace(";", ",") : "";
                writer.println(time + ";" + agente + ";" + evento + ";" + safeDetalhes);
                writer.flush(); 
            }
        }
    }

    @Override
    protected void dispose() {
        if (writer != null) {
            System.out.println("[CSVLogger] Fechando arquivo de log.");
            writer.close();
        }
    }
}