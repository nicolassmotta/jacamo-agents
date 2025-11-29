!setup.

+!setup
   <- .print("Estacao online.");
      .df_register("servico_recarga");
      .my_name(Me);
      .concat("catraca_", Me, NomeArt);
      // Cria o artefato Java usando o pacote mas_jacamo
      makeArtifact(NomeArt, "mas_jacamo.EstacaoArtifact", [3, 0.50], ArtId);
      focus(ArtId).

+cfp_recarga[source(Veiculo)] 
    : vagas_ocupadas(O) & vagas_totais(T) & O < T
    <- ?preco_base(PB);
       Preco = PB * (1 + (O / T)); 
       .send(Veiculo, tell, proposta(Preco)).

+cfp_recarga[source(Veiculo)]
    <- .send(Veiculo, tell, recusa_lotado).

// Negociação: Contra-Oferta
+contra_oferta(Valor)[source(Veiculo)] 
    : preco_base(PB) & Valor >= PB
    <- .print("Aceito oferta de ", Veiculo, ": $", Valor);
       .send(Veiculo, tell, aceite_proposta).

+contra_oferta(Valor)[source(Veiculo)]
    <- .send(Veiculo, tell, rejeita_contra_oferta).

+aceite_final[source(Veiculo)]
    <- reservarVaga(Sucesso); 
       if (Sucesso) {
           .send(Veiculo, tell, confirma_recarga);
       } else {
           .send(Veiculo, tell, falha_recarga("Perdeu a vaga"));
       }.

+liberar_vaga[source(Veiculo)]
    <- liberarVaga.

+!atualizar_tarifa(P) <- atualizarPrecoBase(P).