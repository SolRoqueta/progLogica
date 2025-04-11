palabra([a,l]).		
palabra([l,o]).		
palabra([a,s]).		
palabra([s,i]).
palabra([l,a]).		
palabra([l,e]).		
palabra([s,e]).
palabra([a,l,a]).	
palabra([c,a,n]).	
palabra([a,s,a]).	
palabra([a,c,a]).
palabra([a,m,a]).	
palabra([c,a,l]).	
palabra([m,a,l]).	
palabra([m,a,s]).
palabra([l,a,s]).	
palabra([a,n,a]).	
palabra([m,e,s,a]).	
palabra([o,s,a,s]).
palabra([r,a,n,a]).	
palabra([a,s,e,s]).	
palabra([m,e,r,a]).	
palabra([e,s,a,s]).
palabra([s,a,n,e]).	
palabra([a,s,a,s]).	
palabra([c,a,s,a]).	
palabra([m,o,r,a]).

columna([], [], []).
columna([[H|T]|Filas], [H|Columna], [T|Resto]) :- columna(Filas, Columna, Resto).

transpuesta([[]|_],[]).
transpuesta(M, [C|T]) :- columna(M, C, R), transpuesta(R, T).

columnas([],_).
columnas([X|Filas],N):-
    length(X,N),
    columnas(Filas,N).

matriz(N,X):- length(X, N), columnas(X, N).

cruzadas(N, T) :- matriz(N, T),
    todas_palabras_validas(N, Palabras),
    asignar(T, Palabras),
    transpuesta(T, Traspuesta),
    asignar(Traspuesta, Palabras). 

asignar([], _).
asignar([X|Resto], Palabras) :- member(X, Palabras), asignar(Resto, Palabras).

palabras_de_largo(N, Palabra) :- palabra(Palabra), length(Palabra, N).

todas_palabras_validas(N, Lista) :- findall(P, palabras_de_largo(N, P), Lista).