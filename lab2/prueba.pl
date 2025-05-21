% minimax(datosNodo, nivel, alfa, beta, turno) turno para saber si hay que maximinar o minimizar
% Datos nodo  a necesitar ----> jugador que inicio el minimax, tablero

% MINIMAX

% FALTA PASO BASE 
% paso base cuando nivel 0 y cuando el tablero representa un fin de juego?
% que heuristica vamos a usar o si vamos a usar

% paso base nivel 0
% minimax(Tablero, 0, _, _, Turno,JugadorInicio, Valor):-!.
minimax(_, 0, _, _, _,_, 0):-!.

% paso base fin de juego
% minimax(Tablero, _, _, _, Turno, JugadorInicio, Valor):-
%     fin_del_juego(Tablero, _, _, _),!.

% Paso base cuando no hay una jugada humano desde el tablero
minimax(Tablero, _, _, _, _, _, 0) :-
    \+ (jugada_humano(Tablero, _, _, _, _, _, _, _)), !.

minimax(Tablero, Nivel, Alfa, Beta, Turno, JugadorInicio, Valor) :-
    write('ENTRO MIMIMAX'),
    Turno = JugadorInicio,
    % busco todas las jugadas validas que se podrian hacer en el tablero 
    findall( [F,C,D,Tablero2,Turno2,Celdas], jugada_humano(Tablero, Turno, F, C, D, Tablero2, Turno2, Celdas), Jugadas),
    write(Jugadas),
    evaluar_max(Jugadas, Nivel, Alfa, Beta, JugadorInicio, -9999, Valor).

minimax(Tablero, Nivel, Alfa, Beta, Turno, JugadorInicio, Valor) :-
    Turno \= JugadorInicio,
    % busco todas las jugadas validas que se podrian hacer en el tablero 
    findall( [F,C,D,Tablero2,Turno2,Celdas], jugada_humano(Tablero, Turno, F, C, D, Tablero2, Turno2, Celdas), Jugadas),
    evaluar_min(Jugadas, Nivel, Alfa, Beta, JugadorInicio, 9999, Valor).

% MAXIMIZAR

% Paso base -> iguala el acumulador a lo que va a devolver cuando ya recorio todo
evaluar_max([], _, _, _, _, Acum, Acum).

% En este caso poda
evaluar_max([[F,C,D,Tablero2,Turno2,Celdas]|_], Nivel, Alfa, Beta, JugadorInicio, Acum, Valor) :-
    write('ENTRO EVALUAR MAX PODA'),
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta,Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    ValorConHijo is ValorHijo + N,
    MaxValor is max(Acum, ValorConHijo),
    NuevoAlfa is max(Alfa, MaxValor),
    NuevoAlfa >= Beta,
    Valor is MaxValor.

% Caso sin podar
evaluar_max([[F,C,D,Tablero2,Turno2,Celdas]|R], Nivel, Alfa, Beta, JugadorInicio, Acum, Valor) :-
    write('ENTRO EVALUAR MAX SIN PODA'),
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta,Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    % sumo la cantidad de celdas que cierra
    ValorConHijo is ValorHijo + N,
    MaxValor is max(Acum, ValorConHijo),
    NuevoAlfa is max(Alfa, MaxValor),
    NuevoAlfa < Beta,
    evaluar_max(R, Nivel, NuevoAlfa, Beta, JugadorInicio, MaxValor, Valor).

% MINIMIZAR 
evaluar_min([], _, _, _, _, Acum, Acum).

% En este caso poda
evaluar_min([[F,C,D,Tablero2,Turno2,Celdas]|_], Nivel, Alfa, Beta, JugadorInicio, Acum, Valor) :-
    write('ENTRO EVALUAR MIN PODA'),
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta, Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    % resto la cantidad de celdas que encierra el otro
    ValorConHijo is ValorHijo - N,
    MinValor is min(Acum, ValorConHijo),
    NuevoBeta is min(Beta, MinValor),
    NuevoBeta =< Alfa,
    Valor is MinValor.

% caso sin podar
evaluar_min([[F,C,D,Tablero2,Turno2,Celdas]|R], Nivel, Alfa, Beta, JugadorInicio, Acum, Valor) :-
    write('ENTRO EVALUAR MIN SIN PODA'),
    % llama a la recursion con el hijo
    Nivel2 is Nivel - 1,
    minimax(Tablero2, Nivel2, Alfa, Beta, Turno2, JugadorInicio, ValorHijo),
    length(Celdas, N),
    % resto la cantidad de celdas que encierra el otro
    ValorConHijo is ValorHijo - N,
    MinValor is min(Acum, ValorConHijo),
    NuevoBeta is min(Beta, MinValor),
    NuevoBeta > Alfa,
    evaluar_min(R, Nivel, Alfa, NuevoBeta, JugadorInicio, MinValor, Valor).

% COSAS PARA PROBAR

% Jugada que cierra la celda (0,0)
jugada_humano(
    m(f((c(1,1,0), c(1,0,0), c(-,0,-),
         c(0,1,0), c(0,0,0), c(-,0,-),
         c(-,-,-), c(-,-,-)))),
    1, 0, 0, h,
    m(f((c(1,1,1), c(1,0,0), c(-,0,-),
         c(0,1,0), c(0,0,0), c(-,0,-),
         c(-,-,-), c(-,-,-)))),
    1, [(0,0)]).

jugada_humano(
    m(f((c(1,1,0), c(1,0,0), c(-,0,-),
         c(0,1,0), c(0,0,0), c(-,0,-),
         c(-,-,-), c(-,-,-)))),
    1, 0, 0, h,
    m(f((c(1,1,0), c(1,0,0), c(-,0,-),
         c(0,1,0), c(0,0,0), c(-,1,-),
         c(-,-,-), c(-,-,-)))),
    1, [(0,0)]).
%Tablero = m(f((c(0,0,0),c(0,0,0),c(-,0,-)), f(c(0,0,0),c(0,0,0),c(-,0,-)), f(c(0,-,-),c(0,-,-)))), minimax(Tablero, 1, -9999, 9999, 1, 1, Valor).