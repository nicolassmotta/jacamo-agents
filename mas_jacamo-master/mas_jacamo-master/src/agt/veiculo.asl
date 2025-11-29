bateria(100).
limite(20).

!viver.

/* --- CICLO DE VIDA --- */
+!viver : bateria(B) & B > 0 & not recarregando
    <- .wait(500);
       NB = B - 5;
       -+bateria(NB);
       !verificar_bateria;
       !viver.

+!viver : recarregando
    <- .wait(100);
       !viver.

+!viver <- .print("Bateria acabou. Fim.").

/* --- MONITORAMENTO --- */
+!verificar_bateria : bateria(B) & limite(L) & B <= L & not negociando & not recarregando
    <- .print("ALERTA: Bateria critica (",B,"%). Buscando estacao...");
       +negociando;
       !buscar_estacao.
+!verificar_bateria.

/* --- BUSCA --- */
+!buscar_estacao
    <- .df_search("servico_recarga", Lista);
       .send(Lista, tell, cfp_recarga).

/* --- NEGOCIAÇÃO --- */

// Recebe proposta. Se já aceitou alguma, ignora silenciosamente.
+proposta(Preco)[source(Est)] 
    : negociando
    <- !avaliar(Est, Preco).

// Avalia e Tenta Contra-Oferta
+!avaliar(Est, P) 
    : P > 1.0 & not aceitou_proposta
    <- .print("Caro! Tentando negociar com ", Est);
       NovaOferta = P * 0.8;
       .send(Est, tell, contra_oferta(NovaOferta)).

// Aceita a proposta (BLINDAGEM CONTRA DUPLA RESERVA)
+!avaliar(Est, P)
    : not aceitou_proposta // Só entra se ainda não aceitou NENHUMA
    <- +aceitou_proposta;  // Marca imediatamente
       .print("Aceitando proposta de ", Est, " ($", P, ")");
       .send(Est, tell, aceite_final).

// Se cair aqui, é porque já aceitou outra (descarta esta)
+!avaliar(Est, P)
    <- .print("Ja tenho acordo. Rejeitando oferta extra de ", Est).

/* --- RESPOSTAS --- */

+confirma_recarga[source(Est)]
    <- .print(">>> SUCESSO: Recarregando em ", Est, " <<<");
       +recarregando;
       .wait(2000); // Tempo de carga
       
       -+bateria(100);
       -recarregando;
       -negociando;       
       -aceitou_proposta; 
       
       .send(Est, tell, liberar_vaga);
       .print("Bateria cheia! Voltando para a estrada.").

// Resiliência: Tenta de novo se falhar
+falha_recarga(Motivo)[source(Est)]
    <- .print("FALHA em ", Est, ": ", Motivo, ". Tentando de novo...");
       -aceitou_proposta; 
       -negociando;       // Remove flag para buscar novamente
       .wait(1000).

+rejeita_contra_oferta[source(Est)]
    : not aceitou_proposta 
    <- .print(Est, " nao deu desconto. Aceitando preco cheio...");
       +aceitou_proposta;
       .send(Est, tell, aceite_final).

+rejeita_contra_oferta[source(Est)].