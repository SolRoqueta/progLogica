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
crear_fila(1, [c(-1, 0, -1) | Resto]) :-
    crear_fila(0, Resto), !.
crear_fila(N, [c(0, 0, 0) | Resto]) :-
    N1 is N - 1,
    crear_fila(N1, Resto).

crear_ulimta_fila(0, []) :- !.
crear_ulimta_fila(1, [c(-1, -1, -1)]) :- !.
crear_ulimta_fila(N, [c(0, -1, -1) | Resto]) :-
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
comparar(P1, P2, "Empate") :- P1 =:= P2, !.
comparar(P1, P2, "Gana el jugador 1") :- P1 > P2, !.
comparar(P1, P2, "Gana el jugador 2") :- P2 > P1, !.


% 
contar_celdas_fila([], 0, 0).

contar_celdas_fila([c(H, V, 0) | _], _, _) :-
    H =\= (-1), V =\= (-1), !, fail.

contar_celdas_fila([c(H, V, 1) | Resto], P1, P2) :-
    H =\= (-1), V =\= (-1),
    contar_celdas_fila(Resto, P1R, P2),
    P1 is P1R + 1.

contar_celdas_fila([c(H, V, 2) | Resto], P1, P2) :-
    H =\= (-1), V =\= (-1),
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

fin_del_juego(Tablero, P1, P2, Ganador) :-
    Tablero =.. [m | Filas],      % descompone el término Tablero en lista de filas
    contar_celdas(Filas, P1, P2), % suma los puntos
    comparar(P1, P2, Ganador),    % determina quién ganó
    !.                            % <-- corte: evita más soluciones





% ----- fin de juego
% ------ jugada humano
% jugada_humano(+Tablero,+Turno,+F,+C,+D,?Tablero2,?Turno2,?Celdas)
cambiar_turno(1, 2).
cambiar_turno(2, 1).

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso ya pintada arista, falla
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    F == 1,
    D == 'h',
    obtener_datos_celda(Tablero, F, C, Sup, _,_,_),
    Sup =:= 1, !,
    fail.

% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y pero no celda
% Caso 1
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F == 1,
    D == 'h',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Sup =:= 0, 
    Izq + Der + Inf =\= 3, !,
    set_datos_celda(Tablero, F, C, 1, Izq),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.

    
% Caso primer Fila, jugada horizontal (no chequear celda superior) caso OK, pinta arista y celda
% Caso 2
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-  
    F == 1,
    D == 'h',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Sup =:= 0, 
    Izq + Der + Inf  =:= 3, !,
    set_datos_celda(Tablero, F, C, 1, Izq),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F, C]].



% Caso primer Columna, jugada vertical (no chequear celda derecha) caso ya pintada arista, falla
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    C == 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, _, Izq, _,_),
    Izq =:= 1, !,
    fail.

% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista pero no celda.
% Caso 3
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C == 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Izq =:= 0,
    Sup + Der + Inf =\= 3, !,
    set_datos_celda(Tablero, F, C, Sup, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


% Caso primer Columna, jugada vertical (no chequear celda derecha) caso OK, pinta arista y celda.
% Caso 4
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C == 1,
    D == 'v',
    obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der),
    Izq =:= 0,
    Sup + Der + Inf =:= 3, !,
    set_datos_celda(Tablero, F, C, Sup, 1),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F, C]].

% Caso general vertical falla, arista ya pintada
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    C \== 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, _,_,_,_,_,_),
    Med =:= 1, !,
    fail.

% Caso general vertical pinta arista, no celda
% Caso 5
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C \== 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    Med =\= 1,
    Med =\= -1,
    SupDer + Der + InfDer =\= 3,
    SupIzq + Izq + InfIzq =\= 3, !,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general vertical pinta arista, una celda derecha
% Caso 6
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C \== 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    Med =\= 1,
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq =\= 3,!,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C]].


% Caso general vertical pinta arista, una celda izquierda
% Caso 7
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C \== 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    Med =\= 1,
    SupDer + Der + InfDer =\= 3,
    SupIzq + Izq + InfIzq =:= 3,!,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    C1 is C - 1,
    set_jugador(Tablero, F, C1, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C1]].

% Caso general vertical pinta arista, dos celdas
% Caso 8
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    C \== 1,
    D == 'v',
    obtener_datos_celdas_jugada_completa_vertical(Tablero, F, C, D, Med, SupIzq, SupDer, Der, InfDer, InfIzq, Izq),
    Med =\= 1,
    SupDer + Der + InfDer =:= 3,
    SupIzq + Izq + InfIzq =:= 3, !,
    set_datos_celda(Tablero, F, C, SupDer, 1),
    C1 is C - 1,
    set_jugador(Tablero, F, C1, Turno),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C1],[F,C]].


% Caso general horizontal falla, arista ya pintada
jugada_humano(Tablero,_,F,C,D,_,_,_) :-
    F \== 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, _,_,_,_,_,_),
    Med =:= 1, !,
    fail.

% Caso general horizonal pinta arista, no celda
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F \== 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Med =\= 1,
    Med =\= -1,
    Sup + IzqSup + DerSup =\= 3,
    Inf + IzqInf + DerInf =\= 3, !,
    set_datos_celda(Tablero, F, C, 1, IzqInf),
    cambiar_turno(Turno, Turno2),
    Celdas = [],
    Tablero2 = Tablero.


   
% Caso general horizontal pinta arista, una celda inferior
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F \== 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Med =\= 1,
    Sup + IzqSup + DerSup =\= 3,
    Inf + IzqInf + DerInf =:= 3, !,
    set_datos_celda(Tablero,F,C,1,IzqInf),
    set_jugador(Tablero, F, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F,C]].


% Caso general horizontal pinta arista, una celda superior
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F \== 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Med =\= 1,
    Sup + IzqSup + DerSup =:= 3,
    Inf + IzqInf + DerInf =\= 3, !,
    set_datos_celda(Tablero, F, C, 1, IzqInf),
    F1 is F - 1,
    set_jugador(Tablero, F1, C, Turno),
    Tablero2 = Tablero,
    Turno2 = Turno,
    Celdas = [[F1,C]].

% Caso general horizonal pinta arista, dos celdas
jugada_humano(Tablero,Turno,F,C,D,Tablero2,Turno2,Celdas) :-
    F \== 1,
    D == 'h',
    obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup),
    Med =\= 1,
    Sup + IzqSup + DerSup =:= 3,
    Inf + IzqInf + DerInf =:= 3, !,
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
    obtener_datos_celda(Tablero, F, C1, SupIzq, Izq, InfIzq,   _).

obtener_datos_celdas_jugada_completa_horizontal(Tablero, F, C, D, Med, IzqInf, Inf, DerInf, IzqSup, Sup, DerSup) :-
    compound(Tablero),
    D == 'h',
    F1 is F - 1,
    obtener_datos_celda(Tablero, F1, C, Sup, IzqSup, _, DerSup),
    obtener_datos_celda(Tablero, F,   C,       Med,    IzqInf,    Inf, DerInf).

% obtener_datos_celda(+Tablero, +F, +C, ?Sup, ?Izq, ?Inf, ?Der) me da las 4 aristas de una celda
obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der) :-
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
    arg(2, CeldaDer, Der).

obtener_datos_celda(Tablero, F, C, Sup, Izq, Inf, Der) :-
    compound(Tablero),
    arg(F, Tablero, Fila),
    arg(C, Fila,Celda),
    arg(1, Celda, Sup),
    arg(2, Celda, Izq),
    Sup =:= -1,
    Izq =\= -1,
    Inf is -1,
    Der is -1.

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
    Der is -1.

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

% PREDICADOS AUXILIARES

tamano_tablero(Tablero, N) :- Tablero =.. [m|Filas], length(Filas,N).

direccion(h).
direccion(v).

% MINIMAX
minimax(_, 0, _, _, _,_, 0):-!.

% paso base fin de juego
minimax(Tablero, _, _, _, _, _, 0):- fin_del_juego(Tablero, _, _, _),!.

minimax(Tablero, Nivel, Alfa, Beta, Turno, JugadorInicio, Valor) :-
    Turno = JugadorInicio,!,
    tamano_tablero(Tablero, N),
    % busco todas las jugadas validas que se podrian hacer en el tablero 
    findall( [F,C,D,Tablero2,Turno2,Celdas], (
            between(1,N,F),
            between(1,N,C),
            direccion(D),
            jugada_humano(Tablero, Turno, F, C, D, Tablero2, Turno2, Celdas)), Jugadas),
    evaluar_max(Jugadas, Nivel, Alfa, Beta, JugadorInicio, -9999, Valor).

minimax(Tablero, Nivel, Alfa, Beta, Turno, JugadorInicio, Valor) :-
    Turno \= JugadorInicio,
    tamano_tablero(Tablero, N),
    % busco todas las jugadas validas que se podrian hacer en el tablero 
    findall( [F,C,D,Tablero2,Turno2,Celdas], (
            between(1,N,F),
            between(1,N,C),
            direccion(D),
            jugada_humano(Tablero, Turno, F, C, D, Tablero2, Turno2, Celdas)), Jugadas),
    evaluar_min(Jugadas, Nivel, Alfa, Beta, JugadorInicio, 9999, Valor).

% MAXIMIZAR

% Paso base -> iguala el acumulador a lo que va a devolver cuando ya recorio todo
evaluar_max([], _, _, _, _, Acum, Acum).

% En este caso poda
evaluar_max([[_,_,_,Tablero2,Turno2,Celdas]|_], Nivel, Alfa, Beta, JugadorInicio, Acum, Valor) :-
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta,Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    ValorConHijo is ValorHijo + N,
    MaxValor is max(Acum, ValorConHijo),
    NuevoAlfa is max(Alfa, MaxValor),
    NuevoAlfa >= Beta, !,
    Valor = MaxValor.

% Caso sin podar
evaluar_max([[_,_,_,Tablero2,Turno2,Celdas]|R], Nivel, Alfa, Beta, JugadorInicio, Acum, ValorFinal) :-
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta,Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    % sumo la cantidad de celdas que cierra
    ValorConHijo is ValorHijo + N,
    NuevoAcum is max(Acum, ValorConHijo),
    NuevoAlfa is max(Alfa, NuevoAcum),
    evaluar_max(R, Nivel, NuevoAlfa, Beta, JugadorInicio, NuevoAcum, ValorFinal).

% MINIMIZAR 
evaluar_min([], _, _, _, _, Acum, Acum).

% En este caso poda
evaluar_min([[_,_,_,Tablero2,Turno2,Celdas]|_], Nivel, Alfa, Beta, JugadorInicio, Acum, Valor) :-
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta, Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    % resto la cantidad de celdas que encierra el otro
    ValorConHijo is ValorHijo - N,
    MinValor is min(Acum, ValorConHijo),
    NuevoBeta is min(Beta, MinValor),
    NuevoBeta =< Alfa, !,
    Valor = MinValor.

% caso sin podar
evaluar_min([[_,_,_,Tablero2,Turno2,Celdas]|R], Nivel, Alfa, Beta, JugadorInicio, Acum, ValorFinal) :-
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta, Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    % resto la cantidad de celdas que encierra el otro
    ValorConHijo is ValorHijo - N,
    NuevoAcum is min(Acum, ValorConHijo),
    NuevoBeta is min(Beta, NuevoAcum),
    evaluar_min(R, Nivel, Alfa, NuevoBeta, JugadorInicio, NuevoAcum, ValorFinal).

% JUGADA MAQUINA

jugada_maquina(Tablero, Turno, Nivel, F, C, D, Tablero2, Turno2, Celdas) :-
    tamano_tablero(Tablero, N),
    findall([F1,C1,D1,T2,Turno1,Celdas1],(
            between(1,N,F1),
            between(1,N,C1),
            direccion(D1),
            jugada_humano(Tablero, Turno, F1, C1, D1, T2, Turno1, Celdas1)
        ), Jugadas),
    mejor_jugada(Jugadas, Turno, Nivel, [F, C, D, Tablero2, Turno2, Celdas]).

% Punto de entrada
mejor_jugada(Jugadas, Turno, Nivel, Mejor) :-
    Jugadas = [[F1, C1, D1, Tablero1, Turno1, Celdas1] | Resto],
    Nivel1 is Nivel - 1,
    minimax(Tablero1, Nivel1, -100, 100, Turno1, Turno1, Valor),
    length(Celdas1, N),
    ValorJugada is Valor + N,
    mejor_jugada_acum(Resto, Turno, Nivel, ValorJugada, [F1, C1, D1, Tablero1, Turno1, Celdas1], Mejor).

% Caso base 
mejor_jugada_acum([], _, _, _, MejorAcum, MejorAcum).

% Si la jugada actual es mejor que el acumulado
mejor_jugada_acum([[F1, C1, D1, Tablero1, Turno1, Celdas1] | Resto], Turno, Nivel, ValorAcum, _, Mejor) :-
    Nivel1 is Nivel - 1,
    minimax(Tablero1, Nivel1, -100, 100, Turno1, Turno1, Valor),
    length(Celdas1, N),
    ValorJugada is Valor + N,
    ValorJugada > ValorAcum,!,
    mejor_jugada_acum(Resto, Turno, Nivel, ValorJugada, [F1, C1, D1, Tablero1, Turno1, Celdas1], Mejor).

% Si la jugada actual no mejora
mejor_jugada_acum([[_, _, _, Tablero1, Turno1, Celdas1] | Resto], Turno, Nivel, ValorAcum, MejorAcum, Mejor) :-
    Nivel1 is Nivel - 1,
    minimax(Tablero1, Nivel1, -100, 100, Turno1, Turno1, Valor),
    length(Celdas1, N),
    ValorJugada is Valor + N,
    ValorJugada =< ValorAcum, !,
    mejor_jugada_acum(Resto, Turno, Nivel, ValorAcum, MejorAcum, Mejor).


sugerencia_jugada(_,_,_,_,_,_):-fail.


