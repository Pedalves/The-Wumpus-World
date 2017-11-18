%declaracao_das_variaveis_dinamicas.
:- dynamic(
            [agent_location/1],
			[agent_last_location/1],
            [agent_health/1],
            [agent_points/1],
            [agent_rotation/1],
            [pit_location/1],
            [gold/1],
            [wumpus20_location/1],
            [wumpus50_location/1],
            [wumpus20_health/1],
            [wumpus50_health/1],
            [assume/1],
            [ammo/1] ).
start :-
    init_agent,
    init_world_teste.

derrota :-
    format("\nO aventureiro encontrou um fim inesperado.\n\n Placar final\n"),
    show.

init_agent :-
    retractall(agent_location(_)),
	retractall(agent_last_location(_)),
    retractall(agent_health(_)),
    retractall(agent_points(_)),
    retractall(agent_rotation(_)),
    retractall(ammo(_)),
    assert(agent_location([0,0])),
	assert(agent_last_location([0,0])),
    assert(agent_health([100])),
    assert(agent_points([0])),
    assert(agent_rotation([1])),
    assert(ammo([5])).

init_world_teste :-
    retractall(pit_location(_)),
    retractall(gold(_)),
    retractall(wumpus20_location(_)),
    retractall(wumpus50_location(_)),
    retractall(wumpus20_health(_)),
    retractall(wumpus50_health(_)),
    assert(pit_location([0,2])),
    assert(pit_location([7,1])),
    assert(pit_location([5,1])),
    assert(pit_location([9,9])),
    assert(pit_location([3,3])),
    assert(pit_location([2,1])),
    assert(pit_location([2,8])),
    assert(pit_location([0,7])),
    assert(gold([5,5])),
    assert(gold([1,1])),
    assert(gold([8,1])),
    assert(wumpus20_location([3,1])),
    assert(wumpus50_location([4,3])),
    assert(wumpus20_health([100])),
    assert(wumpus50_health([100])).


%verificaçao dos acontecimentos ou mortes.

is_pit([X,Y]) :- pit_location([X,Y]).
is_gold([X,Y]) :- gold([X,Y]).
is_wumpus20([X,Y]):- wumpus20_location([X,Y]).
is_wumpus50([X,Y]):- wumpus20_location([X,Y]).
is_wumpus20_dead([H]) :-
    H < 1.
is_wumpus50_dead([H]) :-
    H < 1.
is_hero_dead([H]) :-
    H < 1.


show :-
    agent_location([X,Y]),
    agent_health([H]),
    agent_points([P]),
    format("\nSaude: ~p , Pontuacao: ~p\n", [H,P]),
    format("\nPosicao: coluna ~p e linha ~p\n", [X,Y]).

update_agent_location([X1,Y1]) :-
    agent_location([X,Y]),
    retractall( agent_location(_) ),
    assert( agent_location([X1,Y1]) ),
	agent_last_location([Xo,Yo]),
    retractall( agent_last_location(_) ),
    assert( agent_last_location([X,Y]) ),
    ((is_vento([X1,Y1]))->format("\nQue ventania!");
    format("\nNao sinto vento nenhum")),
    ((is_fedor([X1,Y1]))->format("AH! Wumpus, o terrivel, esta proximo!");
    format("\nNenhum sinal da besta por aqui...")),
    ((is_brilho([X1,Y1]))->format("\nNem tudo que reluz e ouro... mas essa luz com certeza deve ser!\n");
    format("\nO ouro nao parece estar aqui perto.")).

update_agent_rotation([X1]) :-
    agent_rotation([X]),
    retractall( agent_rotation(_) ),
    assert( agent_rotation([X1]) ),
    format("\nEstou olhando para ~p\n", [X1]).

update_health([H]) :-
    agent_health([V]),
    NH is V+H,
    retractall(agent_health(_)),
    assert( agent_health([NH])),
    format("\nNosso aventureiro perdeu ~p pontos de vida!\n", [H]),
    ((is_hero_dead([NH]))->derrota;
    format(" ")).

update_points([P]) :-
    agent_points([S]),
    NP is P+S,
    retractall(agent_points(_)),
    assert(agent_points([NP])).

update_wumpus20_health([D]) :-
    wumpus20_location([X,Y]),
    wumpus20_health([V]),
    NV is V+D,
    retractall(wumpus20_health(_)),
    assert(wumpus20_health([NV])),
    ((is_wumpus20_dead([NV]))->retract(wumpus20_location([X,Y])),
    format("\nE com esse grito horrendo, a tao temida besta esta morta!\n");
    format("\nConsegui atingir a fera, mas o monstro ainda respira e parece irritado!\n ")).

update_wumpus50_health([D]) :-
    wumpus50_location([X,Y]),
    wumpus50_health([V]),
    NV is V+D,
    retractall(wumpus50_health(_)),
    assert(wumpus50_health([NV])),
    ((is_wumpus50_dead([NV]))->retract(wumpus50_location([X,Y])),
    format("\nE com esse grito horrendo, a tao temida besta esta morta!\n");
    format("\nConsegui atingir a fera, mas o monstro ainda respira e parece irritado!\n ")).

teste :-
    agent_location([X,Y]),
    agent_health([H]),
    ((is_pit([X,Y]))->format("\nCaiu no buraco!\n"),
    update_health([-100]),
    update_points([-1000]);
    (is_wumpus20([X,Y])->format("\nAtacado pelo Wumpus!\n"),
    update_health([-20]),
    update_points([-20]);
    (is_wumpus50([X,Y])->format("\nAtacado pelo Wumpus!\n"),
    update_health([-50]),
    update_points([-50]);
    is_gold([X,Y])->format("\nUm dos tesouros do Wumpus! Estou rico!\n"),
    pegar;
    format("\n\nNada aqui\n\n")))),
    show.

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
    (
		(R == 0)->(
			(X+1 < 12)->(
				(X1 is X+1),Y1 is Y
			);
			false
		);
    
		(R == 1)->(
			(Y+1 < 12)->(
				(X1 is X),Y1 is Y+1
			);
			false
		);
		
		(R == 2)->(
			(X-1 > -1)->(
				(X1 is X-1),Y1 is Y
			);
			false
		);
		
		(R == 3)->(
			(Y-1 > -1)->(
				(X1 is X),Y1 is Y-1
			);
			false
		);
    
		true
	),
    update_points([-1]),
    update_agent_location([X1,Y1]),
    teste.
	
move_back :-
	agent_rotation([R1]),
	(	
		(R1 == 3; R1 == 2) -> (
			turn_right,
			turn_right
		); 
		(R1 == 1; R1 == 0 )-> (
			turn_left,
			turn_left
		)
	),
    move.

turn_left :-
    agent_rotation([X]),
    X1 is X+1,
    ((X1 == 4)->X2 is 0;X2 is X1),
    update_points([-1]),
    update_agent_rotation([X2]).

turn_right :-
    agent_rotation([X]),
    X1 is X-1,
    ((X1 == -1)->X2 is 3;X2 is X1),
    update_points([-1]),
    update_agent_rotation([X2]).

pegar :-
    agent_location([X,Y]),
    update_points([999]),
    retract(gold([X,Y])).


disparar :-
    agent_location([X,Y]),
    agent_rotation([R]),
    lugar_prox([X,Y], R, [X1,Y1]),
    ammo([M]),
    ((M==0)->format("\nParece que as balas acabaram...\n");
    M1 is M-1,
    retractall(ammo(_)),
    assert(ammo([M1])),
    ((is_wumpus20([X1,Y1]))->update_wumpus20_health([-30]);
    ((is_wumpus50([X1,Y1]))->update_wumpus50_healtn([-30]);
    format("\nO disparo atingiu uma pedra, parece que o wumpus nao estava aqui afinal de contas.\n")))).
    



%Agent Perceptions    

is_vento([X,Y]) :-
    pit_location([X1,Y1]),
    adjacente([X,Y],[X1,Y1]).

is_fedor([X,Y]) :-
    wumpus20_location([X1,Y1]),
    wumpus50_location([X2,Y2]),
    (adjacente([X,Y],[X1,Y1]);
    adjacente([X,Y],[X2,Y2])).

is_brilho([X,Y]) :-
    gold([X1,Y1]),
    adjacente([X,Y],[X1,Y1]).


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

