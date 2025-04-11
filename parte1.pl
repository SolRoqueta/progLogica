es_par(N) :- N mod 2 =:= 0.
es_impar(N) :- N mod 2 =\= 0.

pares_impares_acc([], AcP, AcP, AcI, AcI).
pares_impares_acc([X|L], AcP, [X|R], AcI, R2) :- es_par(X), pares_impares_acc(L, AcP, R, AcI, R2).
pares_impares_acc([X|L], AcP, R, AcI, [X|R2]) :- es_impar(X), pares_impares_acc(L, AcP, R, AcI, R2).

pares_impares(L1, L2, L3) :- pares_impares_acc(L1, [], L2, [], L3).

no_pertenece(_,[]).
no_pertenece(X,[Y|L]) :- X \= Y, no_pertenece(X,L).

unico(X, L) :- select(X, L, R), no_pertenece(X,R).

columna([], [], []).
columna([[H|T]|Filas], [H|Columna], [T|Resto]) :- columna(Filas, Columna, Resto).s