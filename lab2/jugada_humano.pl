% jugada_humano(+Tablero,+Turno,+F,+C,+D,?Tablero2,?Turno2,?Celdas)
cambiar_turno(1, 2).
cambiar_turno(2, 1).

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso ya pintada arista, falla
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("Caso error 1"),nl,
    F =:= 1,
    D == 'h',
    obtener_datos_celda(Tablero, F, C, Sup, _,_,_),
    Sup =:= 1, 
    write("Caso error 1"),nl,
    fail.

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y pero no celda
% Caso 1
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 1"), nl,
    F =:= 1,
    D == 'h',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    format(
      'DEBUG jugada_humano Caso1 → Turno=~w, F=~w, C=~w, D=~w, Sup=~w, Izq=~w, Inf=~w, Der=~w~n',
      [Turno, F, C, D, Sup, Izq, Inf, Der]
    ),
    Sup =:= 0, 
    Izq + Der + Inf =\= 3,
    set_datos_celda(Tablero, F, C, 1, Izq),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.

    
% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y celda
% Caso 2
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :- 
    write("Caso 2"), nl, 
    F =:= 1,
    D == 'h',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    format(
      'DEBUG jugada_humano Caso2 → Turno=~w, F=~w, C=~w, D=~w, Sup=~w, Izq=~w, Inf=~w, Der=~w~n',
      [Turno, F, C, D, Sup, Izq, Inf, Der]
    ),
    Sup =:= 0, 
    Izq + Der + Inf  =:= 3,
    set_datos_celda(Tablero, F, C, 1, Izq),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F, C]].



% Caso primer Columna, jugada vertical (no chequear celda derecha) caso ya pintada arista, falla
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("Caso error 2"), nl,
    C =:= 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, _, Izq, _,_),
    Izq =:= 1,
    write("Caso error 2"), nl,
    fail.

% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista pero no celda.
% Caso 3
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 3"), nl,
    C =:= 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    format(
      'DEBUG jugada_humano Caso3 → Turno=~w, F=~w, C=~w, D=~w, Sup=~w, Izq=~w, Inf=~w, Der=~w~n',
      [Turno, F, C, D, Sup, Izq, Inf, Der]
    ),
    Izq =:= 0,
    Sup + Der + Inf =\= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista y celda.
% Caso 4
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 4"), nl,
    C == 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    format(
      'DEBUG jugada_humano Caso4 → Turno=~w, F=~w, C=~w, D=~w, Sup=~w, Izq=~w, Inf=~w, Der=~w~n',
      [Turno, F, C, D, Sup, Izq, Inf, Der]
    ),
    Izq =:= 0,
    Sup + Der + Inf =:= 3,
    set_datos_celda(Tablero, F, C, Sup, 1),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F, C]].

% Caso general vertical falla, arista ya pintada
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("Caso error 3"), nl,
    C =\= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, _,_,_,_,_,_),
    format(
      'DEBUG jugada_humano Caso error 3 → F=~w, C=~w, D=~w, Med=~w~n',
      [F,   C,   D, Med]
    ),
    Med =:= 1,
    write("Caso error 3"), nl,
    fail, !.

% Caso general vertical pinta arista, no celda
% Caso 5
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 5"), nl,
    C =\= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    format(
      'DEBUG jugada_humano Caso5 → Turno=~w, F=~w, C=~w, D=~w, Med=~w \
SupIzq=~w, SupDer=~w, Der=~w, InfDer=~w, InfIzq=~w, Izq=~w~n',
      [Turno,  F,   C,   D, Med,
       SupIzq, SupDer, Der,
       InfDer, InfIzq, Izq]
    ),
    Med =\= 1,
    SupDer + Der + InfDer =\= 3,
    SupIzq + Izq + InfIzq =\= 3,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general vertical pinta arista, una celda derecha
% Caso 6
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 6"), nl,
    C =\= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    format(
      'DEBUG jugada_humano Caso6 → Turno=~w, F=~w, C=~w, D=~w, Med=~w \
SupIzq=~w, SupDer=~w, Der=~w, InfDer=~w, InfIzq=~w, Izq=~w~n',
      [Turno,  F,   C,   D, Med,
       SupIzq, SupDer, Der,
       InfDer, InfIzq, Izq]
    ),
    Med =\= 1,
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq =\= 3,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C]].


% Caso general vertical pinta arista, una celda izquierda
% Caso 7
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 7"), nl,
    C =\= 1,
    D == 'v',
    format(
      'DEBUG jugada_humano Caso7: ~n Tablero=~w~n, Turno=~w, F=~w, C=~w, D=~w',
      [Tablero, Turno,  F,   C,   D]
    ),
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    format(
      'DEBUG jugada_humano Caso7 → Turno=~w, F=~w, C=~w, D=~w, Med=~w\
SupIzq=~w, SupDer=~w, Der=~w, InfDer=~w, InfIzq=~w, Izq=~w~n',
      [Turno,  F,   C,   D, Med,
       SupIzq, SupDer, Der,
       InfDer, InfIzq, Izq]
    ),
    Med =\= 1,
    SupDer + Der + InfDer =\= 3,
    SupIzq + Izq + InfIzq =:= 3,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    C1 is C - 1,
    set_jugador(Tablero, F, C1, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C1]].

% Caso general vertical pinta arista, dos celdas
% Caso 8
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 8"), nl,
    C =\= 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    format(
    'DEBUG jugada_humano Caso8 → Turno=~w, F=~w, C=~w, D=~w, Med=~w\
SupIzq=~w, SupDer=~w, Der=~w, InfDer=~w, InfIzq=~w, Izq=~w~n',
      [Turno,  F,   C,   D, Med,
       SupIzq, SupDer, Der,
       InfDer, InfIzq, Izq]
    ),
    Med =\= 1,
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq =:= 3,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    C1 is C - 1,
    set_jugador(Tablero, F, C1, Turno),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C1],[F,C]].


% Caso general horizontal falla, arista ya pintada
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    write("Caso error 4"), nl,
    F =\= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, _,_,_,_,_,_),
    format(
      'DEBUG jugada_humano caso error 4 → F=~w, C=~w, D=~w Med=~w~n',
      [F,   C,   D, Med]
    ),
    Med =:= 1, 
    write("Caso error 4"), nl,
    fail.

% Caso general horizonal pinta arista, no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 9"), nl,
    F =\= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    format(
    'DEBUG jugada_humano caso 9 → Turno=~w, F=~w, C=~w, D=~w, Med=~w\
IzqInf=~w, Inf=~w, DerInf=~w, IzqSup=~w, Sup=~w, DerSup=~w~n',
      [Turno,  F,   C,   D, Med,
       IzqInf, Inf, DerInf,
       IzqSup, Sup, DerSup]
    ),
    Med =\= 1,
    Sup + IzqSup + DerSup =\= 3,
    Inf + IzqInf + DerInf =\= 3,
    write("Caso 9"), nl,
    set_datos_celda(Tablero, F, C, 1, IzqInf),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general horizontal pinta arista, una celda inferior
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 10"), nl,
    F =\= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    format(
      'DEBUG jugada_humano caso 10 → Turno=~w, F=~w, C=~w, D=~w, Med=~w \
IzqInf=~w, Inf=~w, DerInf=~w, IzqSup=~w, Sup=~w, DerSup=~w~n',
      [Turno,  F,   C,   D, Med,
       IzqInf, Inf, DerInf,
       IzqSup, Sup, DerSup]
    ),
    Med =\= 1,
    Sup + IzqSup + DerSup =\= 3,
    Inf + IzqInf + DerInf =:= 3,
    write("Caso 10"), nl,
    set_datos_celda(Tablero,F,C,1,IzqInf),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C]].


% Caso general horizontal pinta arista, una celda superior
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 11"), nl,
    F =\= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    format(
      'DEBUG jugada_humano caso 11 → Turno=~w, F=~w, C=~w, D=~w, Med=~w \
IzqInf=~w, Inf=~w, DerInf=~w, IzqSup=~w, Sup=~w, DerSup=~w~n',
      [Turno,  F,   C,   D, Med,
       IzqInf, Inf, DerInf,
       IzqSup, Sup, DerSup]
    ),
    Med =\= 1,
    Sup + IzqSup + DerSup =:= 3,
    Inf + IzqInf + DerInf =\= 3,
    write("Caso 11"), nl,
    set_datos_celda(Tablero, F, C, 1, IzqInf),
    F1 is F - 1,
    set_jugador(Tablero, F1, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F1,C]].

% Caso general horizonal pinta arista, dos celdas
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    write("Caso 12"), nl,
    F =\= 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    format(
      'DEBUG jugada_humano caso 12 → Turno=~w, F=~w, C=~w, D=~w, Med=~w \
IzqInf=~w, Inf=~w, DerInf=~w, IzqSup=~w, Sup=~w, DerSup=~w~n',
      [Turno,  F,   C,   D, Med,
       IzqInf, Inf, DerInf,
       IzqSup, Sup, DerSup]
    ),
    Med =\= 1,
    Sup + IzqSup + DerSup =:= 3,
    Inf + IzqInf + DerInf =:= 3,
    set_datos_celda(Tablero, F, C, 1, IzqInf),
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
    obtener_datos_celda(Tablero, F, C1, SupIzq, Izq, InfIzq,   _),
    format(
      'DEBUG completa vertical: Med=~w, SupIzq=~w, SupDer=~w, Der=~w, InfDer=~w, InfIzq=~w, Izq=~w~n',
      [Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq]
    ).

obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup) :-
    compound(Tablero),
    D == 'h',
    F1 is F - 1,
    obtener_datos_celda(Tablero, F1, C, Sup, IzqSup, _, DerSup),
    obtener_datos_celda(Tablero, F,   C,       Med,    IzqInf,    Inf, DerInf),
    format(
      'DEBUG completa horizontal: Med=~w, IzqInf=~w, Inf=~w, DerInf=~w, IzqSup=~w, Sup=~w, DerSup=~w~n',
      [Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup]
    ).

% obtener_datos_celda(+Tablero, +F, +C, ?Sup, ?Izq, ?Inf, ?Der) me da las 4 aristas de una celda
obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der) :-
    write("obtener datos celda"),
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    arg(1, Celda, Sup),
    arg(2, Celda, Izq),
    Sup =\= -1,
    Izq =\= -1,
    F1 is F + 1,
    arg(F1, Tablero, FilaInf),
    arg(C, FilaInf,CeldaInf),
    arg(1, CeldaInf, Inf),
    C1 is C + 1,
    arg(C1, Fila,CeldaDer),
    arg(2, CeldaDer, Der),
    format(
      'DEBUG celda: celda(F=~w, C=~w) -> Sup=~w, Izq=~w, Inf=~w, Der=~w~n',
      [F, C, Sup, Izq, Inf, Der]
    ).

obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der) :-
    % write("obtener datos celda"),
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    arg(1, Celda, Sup),
    arg(2, Celda, Izq),
    Sup =:= -1,
    Izq =\= -1,
    Inf is -1,
    Der is -1,
    format(
      'DEBUG celda: celda(F=~w, C=~w) -> Sup=~w, Izq=~w, Inf=~w, Der=~w~n',
      [F, C, Sup, Izq, Inf, Der]
    ).

obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der) :-
    % write("obtener datos celda"),
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    arg(1, Celda, Sup),
    arg(2, Celda, Izq),
    Sup =\= -1,
    Izq =:= -1,
    Inf is -1,
    Der is -1,
    format(
      'DEBUG celda: celda(F=~w, C=~w) -> Sup=~w, Izq=~w, Inf=~w, Der=~w~n',
      [F, C, Sup, Izq, Inf, Der]
    ).

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
