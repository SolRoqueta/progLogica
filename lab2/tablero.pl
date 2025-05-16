% Crear una fila de N columnas, todas con c(no, no, ninguno)
crear_fila(0, []) :- !.
crear_fila(1, [c(-, 0, 0) | Resto]) :-
    crear_fila(0, Resto), !.
crear_fila(N, [c(0, 0, 0) | Resto]) :-
    N1 is N - 1,
    crear_fila(N1, Resto).

crear_ulimta_fila(0, []) :- !.
crear_ulimta_fila(1, []) :- !.
crear_ulimta_fila(N, [c(0, -, 0) | Resto]) :-
    N1 is N - 1,
    crear_ulimta_fila(N1, Resto). 

% Crear N filas iguales
crear_filas(0, _, []) :- !.
crear_filas(1, C, [Fila | Resto]) :-
    crear_ulimta_fila(C, Lista),
    Fila =.. [f | Lista],
    crear_filas(0, C, Resto), !.
crear_filas(N, C, [Fila | Resto]) :-
    crear_fila(C, Lista),
    Fila =.. [f | Lista],
    N1 is N - 1,
    crear_filas(N1, C, Resto).

% Predicado principal: crea un tablero N x N con celdas inicializadas
tablero(N, Tablero) :-
    crear_filas(N+1, N+1, Filas),
    Tablero =.. [m | Filas].



