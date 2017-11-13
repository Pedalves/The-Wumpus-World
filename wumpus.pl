start_pos(1/1).

:- dynamic([agent_location/1]).

init_agent :-
    retractall(agent_location(_)),
    assert(agent_location([1,1])).
    
show :- 
    agent_location([X,Y]),
    format("coluna ~p e linha ~p", [X,Y]).

update_agent_location([X1,Y1]) :-
    agent_location([X,Y]),
    retractall( agent_location(_) ),
    assert( agent_location([X1,Y1]) ),
    format("Estou na coluna ~p e na linha ~p", [X1, Y1]).

lugar_prox([X,Y], 0, [X2, Y]) :- X2 is X+1.
lugar_prox([X,Y], 1, [X, Y2]) :- Y2 is Y+1.
lugar_prox([X,Y], 2, [X2, Y]) :- X2 is X-1.
lugar_prox([X,Y], 3, [X, Y2]) :- Y2 is Y+1.

move_up :-
    agent_location([X,Y]),
    Y1 is Y+1,
    update_agent_location([X,Y1]).

move_down :-
    agent_location([X,Y]),
    Y1 is Y-1,
    update_agent_location([X,Y1]).

move_left :-
    agent_location([X,Y]),
    X1 is X-1,
    update_agent_location([X1,Y]).

move_right :-
    agent_location([X,Y]),
    X1 is X+1,
    update_agent_location([X1,Y]).

%Adjacente(X1,X2) :- lugar_prox(X1,0,X2).

