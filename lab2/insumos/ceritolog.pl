:- module(ceritolog,
[
tablero/2, % tablero(+N,?Tablero)
% Devuelve un tablero de tamaño N vacío, o sea una matriz que representa un
% tablero vacío de juego como la descrita en la letra del laboratorio.

fin_del_juego/4, % fin_del_juego(+Tablero,?P1,?P2,?Ganador)
% Dado un tablero, el predicado es verdadero si el tablero representa un juego
% finalizado, y devuelve % la cantidad de puntos del jugador 1 en P1, la
% cantidad de puntos del jugador 2 en P2, y un string % que indica si alguno
% ganó, en el formato: “Gana el jugador 1”, “Gana el jugador 2”, o “Empate”.
% En caso de que no sea el fin del juego, el predicado falla.
 
jugada_humano/8, % jugada_humano(+Tablero,+Turno,+F,+C,+D,?Tablero2,?Turno2,?Celdas)
% Se le envía un tablero, de quién es el turno (1 o 2) y la línea elegida por el
% jugador humano con las variables F-C-D, y devuelve: el tablero modificado con
% la línea marcada (y celdas marcadas en caso de que sea necesario), de quién es
% el siguiente turno (Turno2), y una lista de celdas que se capturaron con esta
% acción en formato [Fila,Columna]. Por ejemplo: [[1,2],[1,3]]

jugada_maquina/9, % jugada_maquina(+Tablero,+Turno,+Nivel,?F,?C,?D,?Tablero2,?Turno2,?Celdas)
% Se le envía un tablero, de quién es el turno (1 o 2) y el Nivel de minimax,
% debe elegir una jugada a realizar por el jugador controlado por la computadora.
% El predicado devuelve: el tablero modificado luego de la jugada, de quién es
% el siguiente turno (Turno2), y una lista de celdas que se cerraron con esta
% acción en formato [Fila,Columna], de la misma forma que en el predicado anterior.

sugerencia_jugada/6 % sugerencia_jugada(+Tablero,+Turno,+Nivel,?F,?C,?D)
% Utiliza la estrategia de minimax para calcular una buena jugada para sugerirle
% a un jugador humano.
]).

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
    crear_filas(N, N, Filas),
    Tablero =.. [m | Filas].



% --- fin de juego
fin_del_juego(_,_,_,_):-fail.

comparar(P1, P2, "Empate") :- P1 =:= P2, !.
comparar(P1, P2, "Gana el jugador 1") :- P1 > P2, !.
comparar(P1, P2, "Gana el jugador 2") :- P2 > P1, !.


% 
contar_celdas_fila([], 0, 0).

contar_celdas_fila([c(H, V, 0) | _], _, _) :-
    H \== (-), V \== (-), !, fail.

contar_celdas_fila([c(H, V, 1) | Resto], P1, P2) :-
    H \== (-), V \== (-),
    contar_celdas_fila(Resto, P1R, P2),
    P1 is P1R + 1.

contar_celdas_fila([c(H, V, 2) | Resto], P1, P2) :-
    H \== (-), V \== (-),
    contar_celdas_fila(Resto, P1, P2R),
    P2 is P2R + 1.

contar_celdas_fila([_ | Resto], P1, P2) :-
    contar_celdas_fila(Resto, P1, P2).


% suma las celdas capturadas por cada jugador
contar_celdas([], 0, 0).
contar_celdas([Fila | Resto], P1, P2) :-
    Fila =.. [f | Celdas], %descompone para tener lista de celdas
    contar_celdas_fila(Celdas, PF1, PF2), %contar puntos de cada celda
    contar_celdas(Resto, PR1, PR2), %recursion
    P1 is PF1 + PR1,
    P2 is PF2 + PR2.

finalizar_juego(Tablero, P1, P2, Ganador) :-
    Tablero =.. [m | Filas],      % descompone el término Tablero en lista de filas
    contar_celdas(Filas, P1, P2), % suma los puntos
    comparar(P1, P2, Ganador),    % determina quién ganó
    !.                            % <-- corte: evita más soluciones


% ----- fin de juego
% ------ jugada humano
% jugada_humano(+Tablero,+Turno,+F,+C,+D,?Tablero2,?Turno2,?Celdas)
% jugada_humano(+Tablero,+Turno,+F,+C,+D,?Tablero2,?Turno2,?Celdas)
cambiar_turno(1, 2).
cambiar_turno(2, 1).

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso ya pintada arista, falla
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("jugada humano 1"),
    F =:= 1,
    D == "h",
    obtener_datos_celda(Tablero, F, C, Sup, _,_,_),
    Sup =:= 1, fail.

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y pero no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 2"),
    F =:= 1,
    D == "h",
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Sup =:= 0, 
    Izq + Der + Inf =\= 3,
    set_datos_celda(Tablero, F, C, 1, Izq),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.

    
% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :- 
    write("jugada humano 3"),
    F =:= 1,
    F =:= 1,
    D == "h",
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Sup =:= 0, 
    Izq + Der + Inf  =:= 3,
    set_datos_celda(Tablero, F, C, 1, Izq),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F, C]].



% Caso primer Columna, jugada vertical (no chequear celda derecha) caso ya pintada arista, falla
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("jugada humano 4"),
    C == 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, _, Izq, _,_),
    Izq =:= 1, fail.

% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista pero no celda.
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 5"),
    C == 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Izq =:= 0,
    Sup + Der + Inf =\= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista y celda.
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 6"),
    C == 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Izq =:= 0,
    Sup + Der + Inf =:= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F, C]].

% Caso general vertical falla, arista ya pintada
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("jugada humano 7"),
    C =:= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, _,_,_,_,_,_),
    Med =:= 0, fail.

% Caso general vertical pinta arista, no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 8"),
    C =:= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, _, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq =:= 3,
    set_datos_celda(Tablero, F, C, Izq, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general vertical pinta arista, una celda derecha
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 9"),
    C =:= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, _, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    SupDer + Der + InfDer == 3,
    SupIzq + Izq + InfIzq =:= 3,
    set_datos_celda(Tablero, F, C, Izq, 1),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C]].


% Caso general vertical pinta arista, una celda izquierda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 10"),
    C =:= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, _, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq == 3,
    set_datos_celda(Tablero, F, C, Izq, 1),
    C1 is C - 1,
    set_jugador(Tablero, F, C1, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C1]].

% Caso general vertical pinta arista, dos celdas
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 11"),
    C =:= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, _, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    SupDer + Der + InfDer == 3,
    SupIzq + Izq + InfIzq == 3,
    set_datos_celda(Tablero, F, C, Izq, 1),
    C1 is C - 1,
    set_jugador(Tablero, F, C1, Turno),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C1],[F,C]].


% Caso general horizontal falla, arista ya pintada
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("jugada humano 12"),
    F =:= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, _,_,_,_,_,_),
    Med =:= 0, fail.

% Caso general horizonal pinta arista, no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 13"),
    F =:= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, _, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Sup + IzqSup + DerSup =:= 3,
    Inf + IzqInf + DerInf =:= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general horizontal pinta arista, una celda inferior
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 14"),
    F =:= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, _, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Sup + IzqSup + DerSup =:= 3,
    Inf + IzqInf + DerInf == 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C]].


% Caso general horizontal pinta arista, una celda superior
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 15"),
    F =:= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, _, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Sup + IzqSup + DerSup == 3,
    Inf + IzqInf + DerInf =:= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    F1 is F - 1,
    set_jugador(Tablero, F1, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F1,C]].

% Caso general horizonal pinta arista, dos celdas
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("jugada humano 16"),
    F =:= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, _, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Sup + IzqSup + DerSup == 3,
    Inf + IzqInf + DerInf == 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    set_jugador(Tablero, F, C, Turno),
    F1 is F - 1,
    set_jugador(Tablero, F1, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F1,C],[F,C]].



obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq) :-
    compound(Tablero),
    D == 'v',
    C1 is C - 1,
    obtener_datos_celda(Tablero, F,   C, SupDer, Med, InfDer, Der),
    obtener_datos_celda(Tablero, F, C1, SupIzq, Izq, InfIzq,   _).

obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup) :-
    compound(Tablero),
    D == 'h',
    F1 is F - 1,
    obtener_datos_celda(Tablero, F,   C,       Med,    IzqInf,    Inf, DerInf),
    obtener_datos_celda(Tablero, F1, C, Sup, IzqSup, _, DerSup).

% obtener_datos_celda(+Tablero, +F, +C, ?Sup, ?Izq, ?Inf, ?Der) me da las 4 aristas de una celda
obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der) :-
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    arg(1, Celda, Sup),
    arg(2, Celda, Izq),
    F1 is F + 1,
    arg(F1, Tablero, FilaInf),
    arg(C, FilaInf,CeldaInf),
    arg(1, CeldaInf, Inf),
    C1 is C + 1,
    arg(C1, Fila,CeldaDer),
    arg(2, CeldaDer, Der).

set_datos_celda(Tablero, F, C, Sup, Izq) :-
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    setarg(1, Celda, Sup),
    setarg(2, Celda, Izq).

set_jugador(Tablero, F, C, Turno) :-
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    setarg(3, Celda, Turno).
% --------






jugada_maquina(_,_,_,_,_,_,_,_,_):-fail.

sugerencia_jugada(_,_,_,_,_,_):-fail.


