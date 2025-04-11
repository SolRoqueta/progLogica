columna([], [], []).
columna([[H|T]|Filas], [H|Columna], [T|Resto]) :- columna(Filas, Columna, Resto).

transpuesta([[]|_],[]).
transpuesta(M, [C|T]) :- columna(M, C, R), transpuesta(R, T).