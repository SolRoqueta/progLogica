es_par(N) :- N mod 2 =:= 0.
es_impar(N) :- N mod 2 =\= 0.

pares_impares_acc([], AcP, AcP, AcI, AcI).
pares_impares_acc([X|L], AcP, [X|R], AcI, R2) :- es_par(X), pares_impares_acc(L, AcP, R, AcI, R2).
pares_impares_acc([X|L], AcP, R, AcI, [X|R2]) :- es_impar(X), pares_impares_acc(L, AcP, R, AcI, R2).

pares_impares(L1, L2, L3) :- pares_impares_acc(L1, [], L2, [], L3).

no_pertenece(_,[]).
no_pertenece(X,[Y|L]) :- X \= Y, no_pertenece(X,L).

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