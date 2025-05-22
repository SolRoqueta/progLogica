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
