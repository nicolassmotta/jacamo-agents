{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$jacamo/templates/org-obedient.asl") }

!setup.

+!setup
   <- .print("Estacao online.");
      .my_name(Me);
      if (Me == estacao_norte) {
          +vagas_totais(20);
          +preco_base(1.0);
      } 
      else { 
          if (Me == estacao_sul) {
              +vagas_totais(10);
              +preco_base(0.8);
          } else {
              +vagas_totais(5);
              +preco_base(1.0);
          }
      };
      ?vagas_totais(T);
      ?preco_base(P);
      .df_register("servico_recarga");
      .concat("catraca_", Me, NomeArt);
      makeArtifact(NomeArt, "mas_jacamo.EstacaoArtifact", [T, P], ArtId);
      focus(ArtId).

+!cfp_recarga[source(Veiculo)] 
    : vagas_ocupadas(O) & vagas_totais(T) & O < T
    <- calcularPreco(Preco); 
       .send(Veiculo, achieve, proposta(Preco)). 

+!cfp_recarga[source(Veiculo)]
    <- .send(Veiculo, achieve, recusa_lotado).

+!contra_oferta(Valor)[source(Veiculo)] 
    : preco_base(PB) & Valor >= PB
    <- .print("Aceito oferta de ", Veiculo, ": $", Valor);
       .send(Veiculo, achieve, aceite_proposta).

+!contra_oferta(Valor)[source(Veiculo)]
    <- .send(Veiculo, achieve, rejeita_contra_oferta).

+!aceite_final[source(Veiculo)]
    <- reservarVaga(Sucesso);
       if (Sucesso) {
           .send(Veiculo, achieve, confirma_recarga);
       } else {
           .send(Veiculo, achieve, falha_recarga("Perdeu a vaga no ultimo segundo"));
       }.

+!liberar_vaga[source(Veiculo)]
    <- liberarVaga.

+!atualizar_tarifa(P) 
   <- .print("Regulador ordenou novo preco base: ", P);
      atualizarPrecoBase(P);
      -+preco_base(P).