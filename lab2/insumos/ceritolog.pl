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
 
% jugada_humano/8, % jugada_humano(+Tablero,+Turno,+F,+C,+D,?Tablero2,?Turno2,?Celdas)
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



% tablero(_,[]).

fin_del_juego(_,_,_,_):-fail.

% ------ jugada humano
% jugada_humano(+Tablero,+Turno,+F,+C,+D,?Tablero2,?Turno2,?Celdas)
cambiar_turno(1, 2).
cambiar_turno(2, 1).

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso ya pintada arista, falla
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    F =:= 1,
    D =:= "H",
    obtener_datos_celda(Tablero, F, C, Sup, _,_,_),
    Sup =:= 1, fail.

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y pero no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F =:= 1,
    D =:= "H",
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Sup =:= 0, 
    Izq + Der + Inf =\= 3,
    set_datos_celda(Tablero, F, C, 1, Izq),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.

    
% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :- 
    F =:= 1,
    D =:= "H",
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
    C == 1,
    D == 'V',
    obtener_datos_celda(Tablero, F, C, _, Izq, _,_),
    Izq =:= 1, fail.

% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista pero no celda.
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C == 1,
    D == 'V',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Izq =:= 0,
    Sup + Der + Inf =\= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista y celda.
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C == 1,
    D == 'V',
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
    C =:= 1,
    D == 'V',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, _,_,_,_,_,_),
    Med =:= 0, fail.

% Caso general vertical pinta arista, no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C =:= 1,
    D == 'V',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, _, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq =:= 3,
    set_datos_celda(Tablero, F, C, Izq, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general vertical pinta arista, una celda derecha
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C =:= 1,
    D == 'V',
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
    C =:= 1,
    D == 'V',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, _, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq == 3,
    set_datos_celda(Tablero, F, C, Izq, 1),
    set_jugador(Tablero, F, C-1, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C-1]].

% Caso general vertical pinta arista, dos celdas
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C =:= 1,
    D == 'V',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, _, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    SupDer + Der + InfDer == 3,
    SupIzq + Izq + InfIzq == 3,
    set_datos_celda(Tablero, F, C, Izq, 1),
    set_jugador(Tablero, F, C-1, Turno),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C-1],[F,C]].


% Caso general horizontal falla, arista ya pintada
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    F =:= 1,
    D == 'H',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, _,_,_,_,_,_),
    Med =:= 0, fail.

% Caso general horizonal pinta arista, no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F =:= 1,
    D == 'H',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, _, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Sup + IzqSup + DerSup =:= 3,
    Inf + IzqInf + DerInf =:= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general horizontal pinta arista, una celda inferior
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F =:= 1,
    D == 'H',
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
    F =:= 1,
    D == 'H',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, _, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Sup + IzqSup + DerSup == 3,
    Inf + IzqInf + DerInf =:= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    set_jugador(Tablero, F-1, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F-1,C]].

% Caso general horizonal pinta arista, dos celdas
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F =:= 1,
    D == 'H',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, _, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Sup + IzqSup + DerSup == 3,
    Inf + IzqInf + DerInf == 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    set_jugador(Tablero, F, C, Turno),
    set_jugador(Tablero, F-1, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F-1,C],[F,C]].



obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq) :-
    compound(Tablero),
    D == 'V',
    obtener_datos_celda(Tablero, F,   C, SupDer, Med, InfDer, Der),
    obtener_datos_celda(Tablero, F, C-1, SupIzq, Izq, InfIzq,   _).

obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup) :-
    compound(Tablero),
    D == 'H',
    obtener_datos_celda(Tablero, F,   C,       Med,    IzqInf,    Inf, DerInf),
    obtener_datos_celda(Tablero, F-1, C, Sup, IzqSup, _, DerSup).

% obtener_datos_celda(+Tablero, +F, +C, ?Sup, ?Izq, ?Inf, ?Der) me da las 4 aristas de una celda
obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der) :-
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    arg(1, Celda, Sup),
    arg(2, Celda, Izq),
    arg(F+1, Tablero, FilaInf),
    arg(C, FilaInf,CeldaInf),
    arg(1, CeldaInf, Inf),
    arg(C+1, Fila,CeldaDer),
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
