{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$jacamo/templates/org-obedient.asl") }

bateria(100).
limite(20).

!viver.

+!viver : bateria(B) & B > 0 & not recarregando
    <- .wait(500); 
       NB = B - 5;
       -+bateria(NB);
       !verificar_bateria;
       !viver.

+!viver : recarregando
    <- .wait(100); !viver.
    
+!viver <- .print("Bateria acabou. Fim.").

+!verificar_bateria : bateria(B) & limite(L) & B <= L & not negociando & not recarregando
    <- .print("ALERTA: Bateria (",B,"%). Buscando estacao...");
       +negociando;
       !buscar_estacao.
+!verificar_bateria.

+!buscar_estacao
    <- .df_search("servico_recarga", Lista);
       .print("Encontrei estacoes: ", Lista);
       .send(Lista, tell, cfp_recarga).

+proposta(Preco)[source(Est)] : negociando
    <- !avaliar(Est, Preco).

+!avaliar(Est, P) : P > 2.0 & not aceitou_proposta 
    <- .print("Muito caro! Tentando negociar com ", Est);
       NovaOferta = P * 0.9; 
       .send(Est, tell, contra_oferta(NovaOferta)).

+!avaliar(Est, P) : not aceitou_proposta
    <- +aceitou_proposta;
       .print("Aceitando proposta de ", Est, " ($", P, ")");
       .send(Est, tell, aceite_final).

+!avaliar(Est, P) <- .print("Ja fechei com outro. Ignorando ", Est).

+confirma_recarga[source(Est)]
    <- .print(">>> CARREGANDO em ", Est, " <<<");
       +recarregando;
       .wait(2000); 
       -+bateria(100);
       -recarregando;
       -negociando;
       -aceitou_proposta;
       .send(Est, tell, liberar_vaga);
       .print("Bateria cheia! Voltando.").

+falha_recarga(M)[source(Est)]
    <- .print("FALHA em ", Est, ": ", M);
       -aceitou_proposta;
       .wait(1000);
       if (negociando) { !buscar_estacao }.

+rejeita_contra_oferta[source(Est)] : not aceitou_proposta 
    <- .print(Est, " nao negociou. Aceitando preco cheio...");
       +aceitou_proposta;
       .send(Est, tell, aceite_final).
+rejeita_contra_oferta[source(Est)].