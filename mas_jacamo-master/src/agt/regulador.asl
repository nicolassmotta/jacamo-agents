{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$jacamo/templates/org-obedient.asl") }

!inicio.

+!inicio
    <- .print("Iniciando Regulador...");
       !conectar_logger;
       !ciclo.

+!conectar_logger
    <- lookupArtifact("logger", LogId)[wsp("mercado")];
       focus(LogId)[wsp("mercado")].

-!conectar_logger
    <- .wait(1000);
       .print("Regulador aguardando logger (mercado)...");
       !conectar_logger.

+!ciclo
    <- .wait(15000); 
       .print(">>> TARIFA ALTA <<<");
       logData("Regulador", "Tarifa", "Subindo para 1.5")[wsp("mercado")];
       .df_search("servico_recarga", L);
       .send(L, achieve, atualizar_tarifa(1.5));
       
       .wait(15000);
       .print(">>> TARIFA BAIXA <<<");
       logData("Regulador", "Tarifa", "Baixando para 0.5")[wsp("mercado")];
       .send(L, achieve, atualizar_tarifa(0.5));
       !ciclo.