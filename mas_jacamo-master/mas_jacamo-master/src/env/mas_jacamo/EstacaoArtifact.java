package mas_jacamo;

import cartago.*;

public class EstacaoArtifact extends Artifact {

    private double precoBase;

    void init(int vagasTotais, double precoBase) {
        defineObsProperty("vagas_totais", vagasTotais);
        defineObsProperty("vagas_ocupadas", 0);
        defineObsProperty("preco_base", precoBase);
        this.precoBase = precoBase;
    }

    @OPERATION
    void reservarVaga(OpFeedbackParam<Boolean> sucesso) {
        int ocupadas = getObsProperty("vagas_ocupadas").intValue();
        int totais = getObsProperty("vagas_totais").intValue();

        if (ocupadas < totais) {
            getObsProperty("vagas_ocupadas").updateValue(ocupadas + 1);
            sucesso.set(true);
            signal("vaga_ocupada");
        } else {
            sucesso.set(false);
        }
    }

    @OPERATION
    void liberarVaga() {
        int ocupadas = getObsProperty("vagas_ocupadas").intValue();
        if (ocupadas > 0) {
            getObsProperty("vagas_ocupadas").updateValue(ocupadas - 1);
            signal("vaga_liberada");
        }
    }
    
    @OPERATION
    void atualizarPrecoBase(double novoPreco) {
        this.precoBase = novoPreco;
        getObsProperty("preco_base").updateValue(novoPreco);
    }
}