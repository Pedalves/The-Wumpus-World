%declaracao_das_variaveis_dinamicas.
:- dynamic(
            [agent_location/1],
            [agent_health/1],
            [agent_points/1],
            [pit/1],
            [caiu/2],
            [assume/1] ).
start :-
    init_agent,
    init_world.

derrota :-
    format("\n O aventureiro encontrou um fim inesperado.").
    

init_agent :-
    retractall(agent_location(_)),
    retractall(agent_health(_)),
    retractall(agent_points(_)),
    assert(agent_location([0,0])),
    assert(agent_health([100])),
    assert(agent_points([100])).

init_world :-
    retractall(pit(_)),
    retractall(gold(_)),
    assert(pit([1,0])),
    assert(gold([0,1])),


    
show :- 
    agent_location([X,Y]),
    agent_health([H]),
    agent_points([P]),
    format("\nSaude: ~p \n", [H]),
    format("Posicao: coluna ~p e linha ~p", [X,Y]),
    format("\nPontuacao: ~p", [P]).

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

