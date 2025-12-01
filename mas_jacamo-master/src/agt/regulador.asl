{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$jacamo/templates/org-obedient.asl") }

!inicio.

+!inicio
    <- .print("Iniciando Regulador...");
       makeArtifact("logger", "mas_jacamo.LoggerArtifact", [], ArtId);
       .print("Logger iniciado.");
       !ciclo.

+!ciclo
    <- .wait(15000); 
       .print(">>> TARIFA ALTA <<<");
       .df_search("servico_recarga", L);
       .send(L, achieve, atualizar_tarifa(1.5));
       .wait(15000);
       .print(">>> TARIFA BAIXA <<<");
       .send(L, achieve, atualizar_tarifa(0.5));
       !ciclo.