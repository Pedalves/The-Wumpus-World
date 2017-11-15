%declaracao_das_variaveis_dinamicas.
:- dynamic(
            [agent_location/1],
            [agent_health/1],
            [agent_points/1],
            [agent_rotation/1],
            [pit_location/1],
            [gold/1],
            [wumpus_location/1],
            [assume/1],
            [ammo/1] ).
start :-
    init_agent,
    init_world.

derrota :-
    format("\n O aventureiro encontrou um fim inesperado.").


init_agent :-
    retractall(agent_location(_)),
    retractall(agent_health(_)),
    retractall(agent_points(_)),
    retractall(agent_rotation(_)),
    retractall(ammo(_)),
    assert(agent_location([0,0])),
    assert(agent_health([100])),
    assert(agent_points([100])),
    assert(agent_rotation([1])),
    assert(ammo([5])).

init_world :-
    retractall(pit_location(_)),
    retractall(gold(_)),
    assert(pit_location([1,0])),
    assert(pit_location([0,1])),
    assert(gold([0,3])).


is_pit(yes, [X,Y]) :- pit_location([X,Y]).
is_pit(no, [X,Y]).

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
    ((is_vento([X1,Y1]))->format("Que ventania!\n");
    format("\n nao sinto vento nenhum")),
    ((is_fedor([X1,Y1]))->format("AH! O terrivel Wumpus!\n");
    format("\n nenhum sinal da besta por aqui...")),
    ((is_brilho([X1,Y1]))->format("Nem tudo que reluz é ouro... mas essa luz com certeza deve ser!\n");
    format("\n O ouro nao parece estar aqui perto.")),
    format("\nEstou na coluna ~p e na linha ~p\n", [X1, Y1]).

update_agent_rotation([X1]) :-
    agent_rotation([X]),
    retractall( agent_rotation(_) ),
    assert( agent_location([X1]) ),
    format("\nEstou olhando para ~p\n", [X1]).

update_health([H]) :-
    agent_health([V]),
    NH is V+H,
    retractall(agent_health(_)),
    assert( agent_health([NH])),
    format("\nNosso aventureiro esta com ~p pontos de vida!\n", [NH]).

teste :-
    agent_location([X,Y]),
    ((is_pit(yes, [X,Y]))->format("caiu no buraco!\n"),
    update_health([-100]);
    format("que")).


%movimentaçao

lugar_prox([X,Y], 0, [X2, Y]) :- X2 is X+1.
lugar_prox([X,Y], 1, [X, Y2]) :- Y2 is Y+1.
lugar_prox([X,Y], 2, [X2, Y]) :- X2 is X-1.
lugar_prox([X,Y], 3, [X, Y2]) :- Y2 is Y-1.

adjacente([X,Y], [X1,Y1]) :-
lugar_prox([X,Y],_,[X1,Y1]).

move_up :-
    agent_location([X,Y]),
    Y1 is Y+1,
    update_agent_location([X,Y1]),
    teste.

move_down :-
    agent_location([X,Y]),
    Y1 is Y-1,
    update_agent_location([X,Y1]),
    teste.

move_left :-
    agent_location([X,Y]),
    X1 is X-1,
    update_agent_location([X1,Y]),
    teste.

move_right :-
    agent_location([X,Y]),
    X1 is X+1,
    update_agent_location([X1,Y]),
    teste.

move :-
    agent_location([X,Y]),
    agent_rotation([R]),
    ((R == 0)->(X1 is X+1),Y1 is Y;
    (R == 1)->(X1 is X),Y1 is Y+1;
    (R == 2)->(X1 is X-1),Y1 is Y;
    (R == 3)->(X1 is X),Y1 is Y-1;
    true),
    update_agent_location([X1,Y1]),
    teste.

turn_left :-
    agent_rotation([X]),
    X1 is X+1,
    ((X1 == 4)->(X1 is 0);true),
    update_agent_rotation([X1]).

turn_right :-
    agent_rotation([X]),
    X1 is X-1,
    ((X1 == -1)->(X1 is 3);true),
    update_agent_rotation([X1]).


is_vento([X,Y]) :-
    pit_location([X1,Y1]),
    adjacente([X,Y],[X1,Y1]).

is_fedor([X,Y]) :-
    wumpus_location([X1,Y1]),
    adjacente([X,Y],[X1,Y1]).

is_brilho([X,Y]) :-
    gold([X1,Y1]),
    adjacente([X,Y],[X1,Y1]).


%Agent Perceptions


vento :-
    agent_location([X,Y]),
    talvez_buraco([X-1,Y]),
    talvez_buraco([X,Y+1]),
    talvez_buraco([X,Y-1]).


fedor :-
    agent_location([X,Y]),
    talvez_wumpus([X-1,Y]),
    talvez_wumpus([X,Y+1]),
    talvez_wumpus([X,Y-1]).

brilho :-
    agent_location([X,Y]),
    talvez_ouro([X-1,Y]),
    talvez_ouro([X,Y+1]),
    talvez_ouro([X,Y-1]).

%Adjacente(X1,X2) :- lugar_prox(X1,0,X2).
