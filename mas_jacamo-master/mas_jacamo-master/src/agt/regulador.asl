!inicio.

+!inicio
    <- .print("Iniciando Regulador...");
       !ciclo.

+!ciclo
    <- .wait(10000);
       .print(">>> TARIFA ALTA <<<");
       .df_search("servico_recarga", L);
       .send(L, achieve, atualizar_tarifa(1.5));
       .wait(10000);
       .print(">>> TARIFA BAIXA <<<");
       .send(L, achieve, atualizar_tarifa(0.5));
       !ciclo.