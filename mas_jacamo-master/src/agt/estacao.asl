{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$jacamo/templates/org-obedient.asl") }

!setup.

+!setup
   <- .print("Estacao online. Conectando infra...");
      !conectar_logger;
      !configurar_vagas;
      !criar_catraca.

+!conectar_logger
    <- lookupArtifact("logger", LogId)[wsp("mercado")];
       focus(LogId)[wsp("mercado")].

-!conectar_logger
    <- .wait(500);
       .print("Tentando conectar ao logger (mercado)...");
       !conectar_logger.

+!configurar_vagas
    <- .my_name(Me);
       if (Me == estacao_norte) {
           +vagas_totais(20); +preco_base(1.0);
       } else { 
           if (Me == estacao_sul) {
               +vagas_totais(10); +preco_base(0.8);
           } else {
               if (Me == estacao_leste) {
                   +vagas_totais(15); +preco_base(1.2); 
               } else {
                   if (Me == estacao_oeste) {
                        +vagas_totais(8); +preco_base(0.9);
                   } else {
                        +vagas_totais(5); +preco_base(1.0);
                   }
               }
           }
       }.

+!criar_catraca
    <- ?vagas_totais(T);
       ?preco_base(P);
       .my_name(Me);
       .df_register("servico_recarga");
       .concat("catraca_", Me, NomeArt);
       makeArtifact(NomeArt, "mas_jacamo.EstacaoArtifact", [T, P], ArtId)[wsp("mercado")];
       focus(ArtId)[wsp("mercado")];
       .concat("Iniciado com ", T, " vagas", Msg);
       logData(Me, "Setup", Msg)[wsp("mercado")].

+!cfp_recarga[source(Veiculo)] 
    : vagas_ocupadas(O) & vagas_totais(T) & O < T
    <- calcularPreco(Preco)[wsp("mercado")]; 
       .send(Veiculo, achieve, proposta(Preco)). 

+!cfp_recarga[source(Veiculo)]
    <- .my_name(Me); 
       .concat("Recusou ", Veiculo, Msg);
       logData(Me, "Lotacao", Msg)[wsp("mercado")];
       .send(Veiculo, achieve, recusa_lotado).

+!contra_oferta(Valor)[source(Veiculo)] 
    : preco_base(PB) & Valor >= PB
    <- .print("Aceito oferta de ", Veiculo, ": $", Valor);
       .send(Veiculo, achieve, aceite_proposta).

+!contra_oferta(Valor)[source(Veiculo)]
    <- .send(Veiculo, achieve, rejeita_contra_oferta).

+!aceite_final[source(Veiculo)]
    <- .my_name(Me); 
       reservarVaga(Sucesso)[wsp("mercado")];
       if (Sucesso) {
           .concat("Reserva confirmada para ", Veiculo, Msg);
           logData(Me, "Venda", Msg)[wsp("mercado")];
           .send(Veiculo, achieve, confirma_recarga);
       } else {
           .concat("Concorrencia: Vaga perdida para ", Veiculo, Msg);
           logData(Me, "Erro", Msg)[wsp("mercado")];
           .send(Veiculo, achieve, falha_recarga("Perdeu a vaga no ultimo segundo"));
       }.

+!liberar_vaga[source(Veiculo)]
    <- .my_name(Me); 
       liberarVaga[wsp("mercado")];
       .concat("Vaga liberada por ", Veiculo, Msg);
       logData(Me, "Saida", Msg)[wsp("mercado")].

+!atualizar_tarifa(P) 
   <- .my_name(Me); 
      .print("Regulador ordenou novo preco base: ", P);
      atualizarPrecoBase(P)[wsp("mercado")];
      -+preco_base(P);
      .concat("Novo preco base: ", P, Msg);
      logData(Me, "Regulacao", Msg)[wsp("mercado")].