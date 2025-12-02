{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$jacamo/templates/org-obedient.asl") }

bateria(100).
limite(60). 

!start.

+!start 
    <- .print("Iniciando veiculo...");
       .wait(2000); 
       !conectar_infra;
       !viver.

+!conectar_infra
    <- !conectar_logger;
       !conectar_estacoes;
       .print("Infraestrutura conectada!").

+!conectar_logger
    <- lookupArtifact("logger", LogId)[wsp("mercado")]; 
       focus(LogId)[wsp("mercado")].

-!conectar_logger
    <- .wait(1000);
       .print("Aguardando Logger (mercado)...");
       !conectar_logger.

+!conectar_estacoes
    <- lookupArtifact("catraca_estacao_norte", ArtN)[wsp("mercado")]; focus(ArtN)[wsp("mercado")];
       lookupArtifact("catraca_estacao_sul",   ArtS)[wsp("mercado")]; focus(ArtS)[wsp("mercado")];
       lookupArtifact("catraca_estacao_leste", ArtL)[wsp("mercado")]; focus(ArtL)[wsp("mercado")];
       lookupArtifact("catraca_estacao_oeste", ArtO)[wsp("mercado")]; focus(ArtO)[wsp("mercado")].

-!conectar_estacoes
    <- .wait(1000);
       .print("Aguardando estacoes (mercado)...");
       !conectar_estacoes.

+!viver : bateria(B) & B > 0 & not recarregando
    <- .wait(200);
       NB = B - 1;
       -+bateria(NB);
       !verificar_bateria;
       !viver.

+!viver : recarregando
    <- .wait(100); !viver.

+!viver <- .print("Bateria acabou. Fim.").

+!verificar_bateria : bateria(B) & limite(L) & B <= L & not negociando & not recarregando
    <- .print("ALERTA: Bateria (",B,"%). Buscando...");
       +negociando;
       .my_name(Me); 
       .concat("Nivel: ", B, Msg);
       logData(Me, "Bateria_Baixa", Msg)[wsp("mercado")];
       !buscar_estacao.
+!verificar_bateria.

+!buscar_estacao
    <- .df_search("servico_recarga", Lista);
       if (.empty(Lista)) {
           .print("ERRO: Nenhuma estacao encontrada. Tentando em breve...");
           .wait(2000); 
           -negociando; 
       } else {
           .print("Encontrei: ", Lista);
           .send(Lista, achieve, cfp_recarga);
           !watchdog_negociacao;
       } .

+!watchdog_negociacao
    <- .wait(5000);
       if (negociando & not recarregando) {
           .print("TIMEOUT: Nenhuma oferta aceita. Resetando.");
           -negociando;
           -aceitou_proposta;
           .wait(1000); 
       }.

+!recusa_lotado[source(Est)] 
    <- .print(Est, " esta LOTADA.").

+!proposta(Preco)[source(Est)] : negociando
    <- !avaliar(Est, Preco).

+!avaliar(Est, P) : P > 2.0 & not aceitou_proposta 
    <- .print("Caro ($",P,") em ", Est, ". Negociando...");
       NovaOferta = P * 0.9; 
       .my_name(Me);
       .concat("Contra-oferta para ", Est, Msg);
       logData(Me, "Negociacao", Msg)[wsp("mercado")];
       .send(Est, achieve, contra_oferta(NovaOferta)).

+!avaliar(Est, P) : not aceitou_proposta
    <- +aceitou_proposta;
       .print("Aceito ", Est, " ($", P, ")");
       .send(Est, achieve, aceite_final).

+!avaliar(Est, P).

+!confirma_recarga[source(Est)]
    <- .print(">>> CARREGANDO em ", Est, " <<<");
       +recarregando;
       .my_name(Me); 
       .concat("Estacao: ", Est, Msg);
       logData(Me, "Recarga_Inicio", Msg)[wsp("mercado")];
       .wait(3000); 
       -+bateria(100);
       -recarregando;
       -negociando;
       -aceitou_proposta;
       .send(Est, achieve, liberar_vaga);
       logData(Me, "Recarga_Fim", "Bateria 100%")[wsp("mercado")];
       .print("Bateria cheia!").

+!falha_recarga(M)[source(Est)]
    <- .print("FALHA em ", Est, ": ", M);
       -aceitou_proposta; 
       .wait(1000).

+!rejeita_contra_oferta[source(Est)] : not aceitou_proposta 
    <- .print(Est, " rejeitou oferta. Aceitando preco cheio.");
       +aceitou_proposta;
       .send(Est, achieve, aceite_final).

+!rejeita_contra_oferta[source(Est)].

+!aceite_proposta[source(Est)] : negociando
    <- .print("Sucesso! A estacao ", Est, " aceitou minha oferta.");
       +aceitou_proposta;
       .send(Est, achieve, aceite_final).