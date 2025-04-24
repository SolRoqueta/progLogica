%predicados auxiliares
es_par(N) :- N mod 2 =:= 0. %predicado para saber si un numero es par
es_impar(N) :- N mod 2 =\= 0. %predicado para saber si un numero es par

%predicado auxiliar no pertenece
no_pertenece(_,[]).
no_pertenece(X,[Y|L]) :- X \= Y, no_pertenece(X,L).

%PARTE 1

%predicado que retorna si un elemento pertenece a una lista
pertenece(X,[X|_]).
pertenece(X,[_|L]) :- pertenece(X,L).

%predicado que se fija si un elemento aparece una unica vez
unico(X, L) :- select(X, L, R), no_pertenece(X,R).

%Predicado elegir primer elemento
elegir_primero(X, L, Res) :- elegir_primero_acum(X, L, [], Res).
    
elegir_primero_acum(_, [], Acc, Acc).
elegir_primero_acum(X, [X|T], Acc, Res) :- append(Acc, T, Res).
elegir_primero_acum(X, [H|T], Acc, Res) :-
    H \= X,
    append(Acc, [H], Acc1),
    elegir_primero_acum(X, T, Acc1, Res).

%predicado si un elemento esta repetido en una lista
repetido(X, [X|R]) :- pertenece(X, R).
repetido(X, [_|R]) :- repetido(X, R).

%predicado que devuelve la cantidad de ocurrencias de un elemento en una lista
pertenece_veces(X, Lista, Veces) :- pertenece_veces_aux(X, Lista, 0, Veces).

pertenece_veces_aux(_, [], Acumulador, Acumulador).
pertenece_veces_aux(X, [X|T], Acumulador, Veces) :-
    NuevoAcum is Acumulador + 1,
    pertenece_veces_aux(X, T, NuevoAcum, Veces).
pertenece_veces_aux(X, [Y|T], Acumulador, Veces) :-
    Y \= X,
    pertenece_veces_aux(X, T, Acumulador, Veces).

%Predicado pares
pares(L, Res) :- pares_acum(L, [], Res).

pares_acum([], Acc, Acc).
pares_acum([H|T], Acc, Res) :-
    H mod 2 =:= 0,
    append(Acc, [H], Acc1),
    pares_acum(T, Acc1, Res).
pares_acum([H|T], Acc, Res) :-
    H mod 2 =\= 0,
    pares_acum(T, Acc, Res).

%predicado que retorna una lista con los pares y otra con los impares
pares_impares_acc([], AcP, AcP, AcI, AcI).
pares_impares_acc([X|L], AcP, [X|R], AcI, R2) :- es_par(X), pares_impares_acc(L, AcP, R, AcI, R2).
pares_impares_acc([X|L], AcP, R, AcI, [X|R2]) :- es_impar(X), pares_impares_acc(L, AcP, R, AcI, R2).

pares_impares(L1, L2, L3) :- pares_impares_acc(L1, [], L2, [], L3).

%predicado que devuelve la lista ordenada de menor a mayor
ordenada([], []).  
ordenada(L1, L2) :- seleccion(L1, L2).

%predicado auxiliar para ordenada
seleccion(L, [Min|Ordenada]) :- minimoEf(L, Min), eliminar(Min, L, RestoSinMin), ordenada(RestoSinMin, Ordenada).  

%encuentra el minimo de lo que va quedando de lista
minimo_ac([],Ac,Ac). 
minimo_ac([X|L],Ac, M) :- X < Ac, minimo_ac(L,X,M).
minimo_ac([X|L],Ac,M) :- X >= Ac, minimo_ac(L,Ac,M).

minimoEf([X|L],M) :- minimo_ac(L,X,M).

%elimina el minimo de la lista
eliminar(_, [], []). 
eliminar(X, [X|L], L). 
eliminar(X, [Y|L], [Y|LRestante]) :- X \= Y, eliminar(X, L, LRestante).  

%PARTE 2

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

/*PARTE 2.3
Luego de realizar pruebas, se pudo observar que cruzadas2 es mas eficiente que cruzadas.
Utilizamos el diccionario grande para los siguientes ejemplos.
Para N=3 cruzadas tardo 423135 inferencias y 51.395 segundos en dar una respuesta cuando cruzadas2 tardo 48 inferencias y 0.002 segundos
Esto se debe a que cruzadas2 al cargar palabras ya validas en la lista intercalada que contiene las filas y las columnas de la matriz,
no es necesario trasponer esta y verificar que sus filas contengan una palabra valida, proceso que si realiza cruzadas ya que
las palabras validas son cargadas unicamente en sus filas y luego se verifican las columnas.*/