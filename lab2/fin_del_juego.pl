comparar(P1, P2, "Empate") :- P1 =:= P2, !.
comparar(P1, P2, "Gana el jugador 1") :- P1 > P2, !.
comparar(P1, P2, "Gana el jugador 2") :- P2 > P1, !.


% contar_celdas_fila(+ListaCeldas, -P1, -P2)
contar_celdas_fila([], 0, 0).
contar_celdas_fila([c(H, V, J) | Resto], P1, P2) :-
    ( J == 0 ->
        fail  % celda sin capturar, el juego no finalizó
    ; J == 1, H \== (-), V \== (-) ->
        contar_celdas_fila(Resto, P1R, P2),
        P1 is P1R + 1
    ; J == 2, H \== (-), V \== (-) ->
        contar_celdas_fila(Resto, P1, P2R),
        P2 is P2R + 1
    ; contar_celdas_fila(Resto, P1, P2)  % no contable (por ser borde)
    ).


% contar_celdas(+Filas, -P1, -P2): suma las celdas capturadas por cada jugador
contar_celdas([], 0, 0).
contar_celdas([Fila | Resto], P1, P2) :-
    Fila =.. [f | Celdas], %descompone para tener lista de celdas
    contar_celdas_fila(Celdas, PF1, PF2), %contar puntos de cada celda
    contar_celdas(Resto, PR1, PR2), %recursion
    P1 is PF1 + PR1,
    P2 is PF2 + PR2.

% finalizar_juego(+Tablero, -P1, -P2, -Ganador)
finalizar_juego(Tablero, P1, P2, Ganador) :-
    Tablero =.. [m | Filas], %descompone el término Tablero para separar las filas en una lista 
    contar_celdas(Filas, P1, P2), % recorre todas las filas y suma cuántas celdas tiene cada jugador 
    comparar(P1, P2, Ganador). %decir quien gano, o si hay empate

