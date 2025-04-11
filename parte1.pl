es_par(N) :- N mod 2 =:= 0. %predicado para saber si un numero es par
es_impar(N) :- N mod 2 =\= 0. %predicado para saber si un numero es par

%predicado que retirna una lista con los lares y otra con los impares
pares_impares_acc([], AcP, AcP, AcI, AcI).
pares_impares_acc([X|L], AcP, [X|R], AcI, R2) :- es_par(X), pares_impares_acc(L, AcP, R, AcI, R2).
pares_impares_acc([X|L], AcP, R, AcI, [X|R2]) :- es_impar(X), pares_impares_acc(L, AcP, R, AcI, R2).

pares_impares(L1, L2, L3) :- pares_impares_acc(L1, [], L2, [], L3).

%predicado auxiliar no pertenece
no_pertenece(_,[]).
no_pertenece(X,[Y|L]) :- X \= Y, no_pertenece(X,L).

%predicado que se fija si un elemento aparece una unica vez
unico(X, L) :- select(X, L, R), no_pertenece(X,R).

%Predicado elegir primer elemento
elegir_primero(X, L, Res) :-
    elegir_primero_acum(X, L, [], Res).
    
elegir_primero_acum(_, [], Acc, Acc).

elegir_primero_acum(X, [X|T], Acc, Res) :-

    append(Acc, T, Res).

elegir_primero_acum(X, [H|T], Acc, Res) :-
    H \= X,
    append(Acc, [H], Acc1),
    elegir_primero_acum(X, T, Acc1, Res).


%Predicado pares
pares(L, Res) :-
    pares_acum(L, [], Res).

pares_acum([], Acc, Acc).

pares_acum([H|T], Acc, Res) :-
    H mod 2 =:= 0,
    append(Acc, [H], Acc1),
    pares_acum(T, Acc1, Res).

pares_acum([H|T], Acc, Res) :-
    H mod 2 =\= 0,
    pares_acum(T, Acc, Res).


% borrar luego

% pertenece_veces(_, [], 0).
% pertenece_veces(X, [X|R], N) :-
%     pertenece_veces(X, R, N1),
%     N is N1 + 1.
% pertenece_veces(X, [_|R], N) :-
%     pertenece_veces(X, R, N).

pertenece_veces(X, Lista, Veces) :-
    pertenece_veces_aux(X, Lista, 0, Veces).


pertenece_veces_aux(_, [], Acumulador, Acumulador).
pertenece_veces_aux(X, [X|T], Acumulador, Veces) :-
    NuevoAcum is Acumulador + 1,
    pertenece_veces_aux(X, T, NuevoAcum, Veces).
pertenece_veces_aux(X, [_|T], Acumulador, Veces) :-
    pertenece_veces_aux(X, T, Acumulador, Veces).
% hasta aca


ordenada([], []).  
ordenada(L1, L2) :- seleccion(L1, L2).

seleccion(L, [Min|Ordenada]) :- minimoEf(L, Min), eliminar(Min, L, RestoSinMin), ordenada(RestoSinMin, Ordenada).  

minimo_ac([],Ac,Ac). 
minimo_ac([X|L],Ac, M) :- X < Ac, minimo_ac(L,X,M).
minimo_ac([X|L],Ac,M) :- X >= Ac, minimo_ac(L,Ac,M).

minimoEf([X|L],M) :- minimo_ac(L,X,M).


eliminar(_, [], []). 
eliminar(X, [X|L], L). 
eliminar(X, [Y|L], [Y|LRestante]) :- X \= Y, eliminar(X, L, LRestante).  

pertenece(X,[X|_]).
pertenece(X,[_|L]) :- pertenece(X,L).
