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

%predicado que extrae la primera columna
columna([], [], []).
columna([[H|T]|Filas], [H|Columna], [T|Resto]) :- columna(Filas, Columna, Resto).

%transpuesta de una matriz
transpuesta([[]|_],[]).
transpuesta(M, [C|T]) :- columna(M, C, R), transpuesta(R, T).

columnas([],_).
columnas([X|Filas],N):-
    length(X,N),
    columnas(Filas,N).

%genera matriz de tamaño NxN vacia
matriz(N,X):- length(X, N), columnas(X, N).

%genera la matriz NxN con palabras validas en sus filas y columnas
cruzadas(N, T) :-
    matriz(N, T),
    cargar_palabras(T, T),
    transpuesta(T,Tansp),
    todas_las_filas_validas(Tansp).

%carga las palabras validas en las filas de la matriz
cargar_palabras([], []).
cargar_palabras([P|RestoFilas], [P|RestoFilasCargadas]) :-
    palabra(P),
    cargar_palabras(RestoFilas, RestoFilasCargadas).

%chequea que las filas sean validas
todas_las_filas_validas([]).
todas_las_filas_validas([P|Resto]) :-
    palabra(P),
    todas_las_filas_validas(Resto).

%devuelve una lista con las filas de M y MT intercaladas
intercaladas([], [], []).
intercaladas([F1|R1], [F2|R2], [F1, F2 | R]) :-
    intercaladas(R1, R2, R).

%genera la matriz NxN con palabras validas en sus filas y columnas
cruzadas2(N, T) :-
    matriz(N, T),
    transpuesta(T, T2),             
    intercaladas(T, T2, Inter),     
    cargar_palabras(Inter, Inter). 
