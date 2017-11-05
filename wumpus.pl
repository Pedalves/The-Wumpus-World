Here(X,Y).
lugar_prox([X,Y], L, [New_X, Y]) :- New_X is X+1.
lugar_prox([X,Y], N, [X, New_Y]) :- New_Y is Y+1.
lugar_prox([X,Y], O, [New_X, Y]) :- New_x is X-1.
lugar_prox([X,Y], S, [X, New_Y]) :- New_Y is Y+1.
Location(col, lin).
Adjacente(X1,X2) :- lugar_prox(X1,_,X2).
