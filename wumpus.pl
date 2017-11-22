--%declaracao_das_variaveis_dinamicas.
:- dynamic(
            [agent_location/1],
			[agent_last_location/1],
			[agent_next_action/1],
			[agent_next_location/1],
			[agent_best_move/1],
            [agent_health/1],
            [agent_points/1],
            [agent_rotation/1],
            [agent_path/2],
            [agent_steps/1],
			[agent_map/3],
            [agent_collected/1],
            [agent_back/1],
            [pit_location/1],
            [gold/1],
            [wumpus20_location/1],
            [wumpus50_location/1],
            [wumpus20_health/2],
            [wumpus50_health/2],
            [assume/1],
            [gameRunning/1],
            [ammo/1] ).
start :-
    init_agent.

derrota :-
    format("\nO aventureiro encontrou um fim inesperado.\n\n Placar final\n"),
    retractall(gameRunning(_)),
    assert(gameRunning(false)),
    show.

fim :-
    format("\nO aventureiro saiu da caverna.\n\n Placar final\n"),
    retractall(gameRunning(_)),
    assert(gameRunning(false)),
    show.

init_agent :-
    retractall(agent_location(_)),
	retractall(agent_last_location(_)),
	retractall(agent_next_action(_)),
	retractall(agent_next_location(_)),
	retractall(agent_best_move(_)),
    retractall(agent_health(_)),
    retractall(agent_points(_)),
    retractall(agent_rotation(_)),
    retractall(agent_path(_)),
    retractall(agent_steps(_)),
    retractall(agent_collected(_)),
    retractall(agent_back(_)),
    retractall(ammo(_)),
	retractall(agent_map(_,_,_)),
    retractall(gameRunning(_)),
    assert(gameRunning(true)),
    assert(agent_location([0,0])),
	assert(agent_last_location([0,0])),
	assert(agent_next_action(none)),
	assert(agent_next_location([0,0])),
    assert(agent_health([100])),
    assert(agent_points([0])),
    assert(agent_rotation([1])),
    assert(agent_path([0,0],0)),
    assert(agent_steps([0])),
    assert(agent_collected([0])),
    assert(agent_back(false)),
	update_agent_map([0,0]),
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
    assert(wumpus20_location([11, 10])),
    assert(wumpus50_location([4,3])),
    assert(wumpus50_location([11,1])),
    assert(wumpus20_health([100], [3,1])),
    assert(wumpus20_health([100], [11,10])),
    assert(wumpus50_health([100], [4,3])),
    assert(wumpus50_health([100], [11,1])).


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
    agent_steps([S]),
    S1 is S + 1,
    retractall( agent_location(_) ),
    assert( agent_location([X1,Y1]) ),
    (
    	agent_back(Back),
		(
			not(Back)->
			(
			    assert( agent_path([X1,Y1], S1) ),
			    retractall(agent_steps(_)),
			    assert(agent_steps([S1]))
			);
			true
		)
    ),
	agent_last_location([Xo,Yo]),
    retractall( agent_last_location(_) ),
    assert( agent_last_location([X,Y]) ),

    ((is_vento([X1,Y1]))->format("\nQue ventania!");
    format("\nNao sinto vento nenhum")),
    ((is_fedor([X1,Y1]))->format("AH! Wumpus, o terrivel, esta proximo!");
    format("\nNenhum sinal da besta por aqui...")),
    ((is_brilho([X1,Y1]))->format("\nNem tudo que reluz e ouro... mas essa luz com certeza deve ser!\n");
    format("\nO ouro nao parece estar aqui perto.")),
	
	update_agent_map([X1,Y1]).

	
% talvezBuraco, buraco, talvezWumpus, wumpus, ouro, seguro, misterio
	
update_agent_map([X,Y]) :- 
	agent_location([X,Y]),
	X1 is X+1,
	Y1 is Y+1,
	X2 is X-1,
	Y2 is Y-1,
	(
		(agent_map([X,Y],Status,Visited)) -> (
			
			not(Visited) -> (

				retractall(agent_map([X,Y],Status,Visited)),
				assert(agent_map([X,Y],seguro,true)),
				
				((is_wumpus20([X,Y]); is_wumpus50([X,Y])) -> (
					retractall(agent_map([X,Y],Status,Visited)),
					assert(agent_map([X,Y],wumpus,true))
				);
				true),
				
				((is_fedor([X,Y])) -> (
					
					(agent_map([X1,Y],StatusF1,VisitedF1),
					(
						(StatusF1 == talvezWumpus) -> (
							retractall(agent_map([X1,Y],StatusF1,VisitedF1)),
							assert(agent_map([X1,Y],wumpus,VisitedF1))
						);
						(not(VisitedF1), (StatusF1 == misterio)) -> (
							retractall(agent_map([X1,Y],StatusF1,VisitedF1)),
							assert(agent_map([X1,Y],talvezWumpus,VisitedF1))
						);
						true
					);
					true),
					
					(agent_map([X2,Y],StatusF2,VisitedF2),
					(
						(StatusF2 == talvezWumpus) -> (
							retractall(agent_map([X2,Y],StatusF2,VisitedF2)),
							assert(agent_map([X2,Y],wumpus,VisitedF2))
						);
						(not(VisitedF2), (StatusF2 == misterio)) -> (
							retractall(agent_map([X2,Y],StatusF2,VisitedF2)),
							assert(agent_map([X2,Y],talvezWumpus,VisitedF2))
						);
						true
					);
					true),
					
					(agent_map([X,Y1],StatusF3,VisitedF3),
					(
						(StatusF3 == talvezWumpus) -> (
							retractall(agent_map([X,Y1],StatusF3,VisitedF3)),
							assert(agent_map([X,Y1],wumpus,VisitedF3))
						);
						(not(VisitedF3), (StatusF3 == misterio)) -> (
							retractall(agent_map([X,Y1],StatusF3,VisitedF3)),
							assert(agent_map([X,Y1],talvezWumpus,VisitedF3))
						);
						true
					);
					true),
					
					(agent_map([X,Y2],StatusF4,VisitedF4),
					(
						(StatusF4 == talvezWumpus) -> (
							retractall(agent_map([X,Y2],StatusF4,VisitedF4)),
							assert(agent_map([X,Y2],wumpus,VisitedF4))
						);
						(not(VisitedF4), (StatusF4 == misterio)) -> (
							retractall(agent_map([X,Y2],StatusF4,VisitedF4)),
							assert(agent_map([X,Y2],talvezWumpus,VisitedF4))
						);
						true
					);
					true)
					
				);
				true),
				
				((is_safe([X,Y])) -> (
					
					(agent_map([X1,Y],StatusS1,VisitedS1),
					(
						not(VisitedS1) -> (
							retractall(agent_map([X1,Y],StatusS1,VisitedS1)),
							assert(agent_map([X1,Y],seguro,VisitedS1))
						);
						true
					);
					true),
					
					(agent_map([X2,Y],StatusS2,VisitedS2),
					(
						not(VisitedS2) -> (
							retractall(agent_map([X2,Y],StatusS2,VisitedS2)),
							assert(agent_map([X2,Y],seguro,VisitedS2))
						);
						true
					);
					true),
					
					(agent_map([X,Y1],StatusS3,VisitedS3),
					(
						not(VisitedS3) -> (
							retractall(agent_map([X,Y1],StatusS3,VisitedS3)),
							assert(agent_map([X,Y1],seguro,VisitedS3))
						);
						true
					);
					true),
					
					(agent_map([X,Y2],StatusS4,VisitedS4),
					(
						not(VisitedS4) -> (
							retractall(agent_map([X,Y2],StatusS4,VisitedS4)),
							assert(agent_map([X,Y2],seguro,VisitedS4))
						);
						true
					);
					true)
				);
				true),
				
				((is_vento([X,Y])) -> (
					
					(agent_map([X1,Y],StatusV1,VisitedV1),
					(
						(StatusV1 == talvezBuraco) -> (
							retractall(agent_map([X1,Y],StatusV1,VisitedV1)),
							assert(agent_map([X1,Y],buraco,VisitedV1))
						);
						(not(VisitedV1), (StatusV1 == misterio))-> (
							retractall(agent_map([X1,Y],StatusV1,VisitedV1)),
							assert(agent_map([X1,Y],talvezBuraco,VisitedV1))
						);
						true
					);
					true),
					
					(agent_map([X2,Y],StatusV2,VisitedV2),
					(
						(StatusV2 == talvezBuraco) -> (
							retractall(agent_map([X2,Y],StatusV2,VisitedV2)),
							assert(agent_map([X2,Y],buraco,VisitedV2))
						);
						(not(VisitedV2), (StatusV2 == misterio)) -> (
							retractall(agent_map([X2,Y],StatusV2,VisitedV2)),
							assert(agent_map([X2,Y],talvezBuraco,VisitedV2))
						);
						true
					);
					true),
					
					(agent_map([X,Y1],StatusV3,VisitedV3),
					(
						(StatusV3 == talvezBuraco) -> (
							retractall(agent_map([X,Y1],StatusV3,VisitedV3)),
							assert(agent_map([X,Y1],buraco,VisitedV3))
						);
						(not(VisitedV3), (StatusV3 == misterio)) -> (
							retractall(agent_map([X,Y1],StatusV3,VisitedV3)),
							assert(agent_map([X,Y1],talvezBuraco,VisitedV3))
						);
						true
					);
					true),
					
					(agent_map([X,Y2],StatusV4,VisitedV4),
					(
						(StatusV4 == talvezBuraco) -> (
							retractall(agent_map([X,Y2],StatusV4,VisitedV4)),
							assert(agent_map([X,Y2],buraco,VisitedV4))
						);
						(not(VisitedV4), (StatusV4 == misterio)) -> (
							retractall(agent_map([X,Y2],StatusV4,VisitedV4)),
							assert(agent_map([X,Y2],talvezBuraco,VisitedV4))
						);
						true
					);
					true)
					
				);	
				true),
				
				(
					(not(agent_map([X1,Y],_,_)) -> (

						(is_fedor([X,Y])) -> (
							assert(agent_map([X1,Y],talvezWumpus,false))
						);
						
						(is_vento([X,Y])) -> (
							assert(agent_map([X1,Y],talvezBuraco,false))
						);
						assert(agent_map([X1,Y],misterio,false))
					);
					true),
					
					(not(agent_map([X2,Y],_,_)) -> (
					
						(is_fedor([X,Y])) -> (
							assert(agent_map([X2,Y],talvezWumpus,false))
						);
						
						(is_vento([X,Y])) -> (
							assert(agent_map([X2,Y],talvezBuraco,false))
						);
						assert(agent_map([X2,Y],misterio,false))
					);
					true),
					
					(not(agent_map([X,Y1],_,_)) -> (
				
						(is_fedor([X,Y])) -> (
							assert(agent_map([X,Y1],talvezWumpus,false))
						);
						
						(is_vento([X,Y])) -> (
							assert(agent_map([X,Y1],talvezBuraco,false))
						);
						assert(agent_map([X,Y1],misterio,false))
					);
					true),

					(not(agent_map([X,Y2],_,_)) -> (
						
						(is_fedor([X,Y])) -> (
							assert(agent_map([X,Y2],talvezWumpus,false))
						);
						
						(is_vento([X,Y])) -> (
							assert(agent_map([X,Y2],talvezBuraco,false))
						);
						assert(agent_map([X,Y2],misterio,false))
						
					);
					true),
					true
					
				)
				
			);
			true
		);
		
		(
			assert(agent_map([X,Y],seguro,true)),
			
			(
				(is_fedor([X,Y])) -> (
				
					assert(agent_map([X1,Y],talvezWumpus,false)),
					
					assert(agent_map([X2,Y],talvezWumpus,false)),
				
					assert(agent_map([X,Y1],talvezWumpus,false)),

					assert(agent_map([X,Y2],talvezWumpus,false))
				);
				
				(is_vento([X,Y])) -> (
				
					assert(agent_map([X1,Y],talvezBuraco,false)),
					
					assert(agent_map([X2,Y],talvezBuraco,false)),
				
					assert(agent_map([X,Y1],talvezBuraco,false)),

					assert(agent_map([X,Y2],talvezBuraco,false))
				);
				
				(
					assert(agent_map([X1,Y],misterio,false)),
					
					assert(agent_map([X2,Y],misterio,false)),
				
					assert(agent_map([X,Y1],misterio,false)),

					assert(agent_map([X,Y2],misterio,false))
				)
			)
		)

	),
	!.
	
	
update_agent_rotation([X1]) :-
    agent_rotation([X]),
    retractall( agent_rotation(_) ),
    assert( agent_rotation([X1]) ),
    (
    	(X1 == 0) ->
    	(
    		format("\nEstou olhando para o leste\n")
    	);
    	(X1 == 1) ->
    	(
    		format("\nEstou olhando para o norte\n")
    	);
    	(X1 == 2) ->
    	(
    		format("\nEstou olhando para o oeste\n")
    	);
    	(X1 == 3) ->
    	(
    		format("\nEstou olhando para o sul\n")
    	);
    	true
    ).

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

update_wumpus20_health([D],[X,Y]) :-
    wumpus20_health([V],[X,Y]),
    NV is V+D,
    retractall(wumpus20_health([V],[X,Y])),
    assert(wumpus20_health([NV],[X,Y])),
    (
    	(is_wumpus20_dead([NV]))->
    	(
    		retract(wumpus20_location([X,Y])),
    		format("\nE com esse grito horrendo, a tao temida besta esta morta!\n"),
    		agent_map([X,Y],Status,Visited),
    		assert(agent_map([X,Y],seguro,Visited))
    	);
    	format("\nConsegui atingir a fera, mas o monstro ainda respira e parece irritado! ~p de dano causado, deixando o wumpus com ~p de vida\n ", [D,NV])
    ).

update_wumpus50_health([D],[X,Y]) :-
    wumpus50_health([V],[X,Y]),
    NV is V+D,
    retractall(wumpus50_health([V],[X,Y])),
    assert(wumpus50_health([NV],[X,Y])),
    (
    	(is_wumpus50_dead([NV]))->
    	(
    		retract(wumpus50_location([X,Y])),
    		format("\nE com esse grito horrendo, a tao temida besta esta morta!\n"),
    		agent_map([X,Y],Status,Visited),
    		assert(agent_map([X,Y],seguro,Visited))
    	);
    	format("\nConsegui atingir a fera, mas o monstro ainda respira e parece irritado! ~p de dano causado, deixando o wumpus com ~p de vida\n ", [D,NV])
    ).

update_action(action) :-
	assert(agent_next_action(action)).

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
    is_gold([X,Y])->format("\nUm dos tesouros do Wumpus! Estou rico!\n");
    format("\n\nNada aqui\n\n")))),
    show.

%movimentaçao

lugar_prox([X,Y], 0, [X2, Y]) :- X2 is X+1.
lugar_prox([X,Y], 1, [X, Y2]) :- Y2 is Y+1.
lugar_prox([X,Y], 2, [X2, Y]) :- X2 is X-1.
lugar_prox([X,Y], 3, [X, Y2]) :- Y2 is Y-1.

adjacente([X,Y], [X1,Y1]) :-
    lugar_prox([X,Y],_,[X1,Y1]).

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

climb :-
    agent_location([X,Y]),
    (X == 0, Y == 0)->
    fim;
    false.

move_up :- 
	agent_rotation([R1]),
	(	
		(R1 == 3) -> (
			turn_right,
			turn_right
		); 
		(R1 == 2) -> (
			turn_right
		);
		(R1 == 0)-> (
			turn_left
		);
		true
	),
    move.
	
move_down :- 
	agent_rotation([R1]),
	(	
		(R1 == 1) -> (
			turn_left,
			turn_left
		); 
		(R1 == 2) -> (
			turn_left
		);
		(R1 == 0)-> (
			turn_right
		);
		true
	),
    move.
	
move_right :- 
	agent_rotation([R1]),
	(	
		(R1 == 1) -> (
			turn_right
		); 
		(R1 == 2) -> (
			turn_right,
			turn_right
		);
		(R1 == 3)-> (
			turn_left
		);
		true
	),
    move.
	
move_left :- 
	agent_rotation([R1]),
	(	
		(R1 == 2) -> (
			turn_right
		); 
		(R1 == 0) -> (
			turn_right,
			turn_right
		);
		(R1 == 3)-> (
			turn_left
		);
		true
	),
    move.
	
	
next_move :-
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
    retractall(agent_next_location(_)),
	assert(agent_next_location([X1,Y1])).
	
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

adjust_rotation :- 
	agent_location([X,Y]),
    agent_rotation([R]),
    (
		(R == 0)->(
			(X+1 > 11)->(
				turn_right,
				turn_right
			);
			true
		);
    
		(R == 1)->(
			(Y+1 > 11)->(
				turn_right,
				turn_right
			);
			true
		);
		
		(R == 2)->(
			(X-1 < 0)->(
				turn_right,
				turn_right
			);
			true
		);
		
		(R == 3)->(
			(Y-1 < 0)->(
				turn_right,
				turn_right
			);
			true
		);
    
		true
	).
	
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
    agent_collected([G]),
    G1 is G+1,
    retractall(agent_collected(_)),
    assert(agent_collected([G1])),
    (
    	(G1 > 0) ->
    	(
    		retractall(agent_back(_)),
    		assert(agent_back(true))
    	);
    	true
    ),
    retractall(gold([X,Y])).


disparar :-
    agent_location([X,Y]),
    agent_rotation([R]),
    lugar_prox([X,Y], R, [X1,Y1]),
    ammo([M]),
    ((M==0)->format("\nParece que as balas acabaram...\n");
    M1 is M-1,
    retractall(ammo(_)),
    assert(ammo([M1])),
    random_between(20,50,D),
    ((is_wumpus20([X1,Y1]))->update_wumpus20_health([-D],[X1,Y1]);
    ((is_wumpus50([X1,Y1]))->update_wumpus50_healtn([-D],[X1,Y1]);
    format("\nO disparo atingiu uma pedra, parece que o wumpus nao estava aqui afinal de contas.\n")))).
    



%Agent Perceptions / unity feedback   

is_vento([X,Y]) :-
    pit_location([X1,Y1]),
    adjacente([X,Y],[X1,Y1]).

is_fedor([X,Y]) :-
    wumpus20_location([X1,Y1]),
    wumpus50_location([X2,Y2]),
    (adjacente([X,Y],[X1,Y1]);
    adjacente([X,Y],[X2,Y2])).

is_brilho([X,Y]) :-
    gold([X,Y]).
    
is_safe([X,Y]) :-
	not(is_vento([X,Y])),
	not(is_fedor([X,Y])).
	
vento :-
	agent_location([X,Y]),
	X1 is X+1,
	Y1 is Y+1,
	X2 is X-1,
	Y2 is Y-1,
    (agent_map([X1,Y],StatusV1,VisitedV1)) ->
	(
		(not(VisitedV1), (StatusV1 \== seguro))-> 
		(
			retractall(agent_map([X1,Y],StatusV1,VisitedV1)),
			assert(agent_map([X1,Y],talvezBuraco,VisitedV1))
		);
		true
	);
    (
		assert(agent_map([X1,Y],talvezBuraco,false))
    ),

    (agent_map([X,Y1],StatusV2,VisitedV2)) ->
	(
		(not(VisitedV2), (StatusV2 \== seguro))-> 
		(
			retractall(agent_map([X,Y1],StatusV2,VisitedV2)),
			assert(agent_map([X,Y1],talvezBuraco,VisitedV2))
		);
		true
	);
    (
		assert(agent_map([X,Y1],talvezBuraco,false))
    ),

    (agent_map([X2,Y],StatusV3,VisitedV3)) ->
	(
		(not(VisitedV3), (StatusV3 \== seguro))-> 
		(
			retractall(agent_map([X2,Y],StatusV3,VisitedV3)),
			assert(agent_map([X2,Y],talvezBuraco,VisitedV3))
		);
		true
	);
    (
		assert(agent_map([X2,Y],talvezBuraco,false))
    ),

    (agent_map([X,Y2],StatusV4,VisitedV4)) ->
	(
		(not(VisitedV4), (StatusV4 \== seguro))-> 
		(
			retractall(agent_map([X,Y2],StatusV4,VisitedV4)),
			assert(agent_map([X,Y2],talvezBuraco,VisitedV4))
		);
		true
	);
    (
		assert(agent_map([X,Y2],talvezBuraco,false))
    ).
	


fedor :-
    agent_next_location([X,Y]),
	X1 is X+1,
	Y1 is Y+1,
	X2 is X-1,
	Y2 is Y-1,
    (agent_map([X1,Y],StatusV1,VisitedV1)) ->
	(
		(not(VisitedV1), (StatusV1 \== seguro))-> 
		(
			retractall(agent_map([X1,Y],StatusV1,VisitedV1)),
			assert(agent_map([X1,Y],talvezWumpus,VisitedV1))
		);
		true
	);
    (
		assert(agent_map([X1,Y],talvezWumpus,false))
    ),

    (agent_map([X,Y1],StatusV2,VisitedV2)) ->
	(
		(not(VisitedV2), (StatusV2 \== seguro))-> 
		(
			retractall(agent_map([X,Y1],StatusV2,VisitedV2)),
			assert(agent_map([X,Y1],talvezWumpus,VisitedV2))
		);
		true
	);
    (
		assert(agent_map([X,Y1],talvezWumpus,false))
    ),

    (agent_map([X2,Y],StatusV3,VisitedV3)) ->
	(
		(not(VisitedV3), (StatusV3 \== seguro))-> 
		(
			retractall(agent_map([X2,Y],StatusV3,VisitedV3)),
			assert(agent_map([X2,Y],talvezWumpus,VisitedV3))
		);
		true
	);
    (
		assert(agent_map([X2,Y],talvezWumpus,false))
    ),

    (agent_map([X,Y2],StatusV4,VisitedV4)) ->
	(
		(not(VisitedV4), (StatusV4 \== seguro))-> 
		(
			retractall(agent_map([X,Y2],StatusV4,VisitedV4)),
			assert(agent_map([X,Y2],talvezWumpus,VisitedV4))
		);
		true
	);
    (
		assert(agent_map([X,Y2],talvezWumpus,false))
    ).

brilho :-
	agent_next_location([X,Y]),
	assert(gold([X,Y])).

wumpus20 :-
	agent_next_location([X,Y]),
    assert(wumpus20_location([X,Y])),
    assert(wumpus20_health([100], [X,Y])).

wumpus50 :-
	agent_next_location([X,Y]),
    assert(wumpus50_location([X,Y])),
    assert(wumpus50_health([100], [X,Y])).

buraco :-
	agent_next_location([X,Y]),
	assert(pit_location([X,Y])).


%Agent IA

ready_next_action :-
	retractall(agent_next_action(_)),
	
	agent_location([X,Y]),
	agent_rotation([R]),
	X1 is X+1,
	Y1 is Y+1,
	X2 is X-1,
	Y2 is Y-1,
	gameRunning(GM),
	(GM)->
	(
		is_brilho([X,Y]) -> 
		(
			retractall(agent_best_move(_)),
			assert(agent_next_action(grab))
		);
		%se ja calculou a melhor casa
		(agent_best_move([I,J])) -> 
		(
			agent_map([I, J], StatusB, VisitedB),
			(
				(R == 0,I == X1,J==Y) -> 
				(
    				ammo([M]),
					(StatusB == wumpus, M > 0)-> 
                    (
                        assert(agent_next_action(shoot))
                    );
                    (
						retractall(agent_best_move(_)),
						next_move,
						assert(agent_next_action(move))
                    )
				);
				(R == 1,I == X,J==Y1) -> 
				(
    				ammo([M]),
					(StatusB == wumpus, M > 0)-> 
                    (
                        assert(agent_next_action(shoot))
                    );
                    (
						retractall(agent_best_move(_)),
						next_move,
						assert(agent_next_action(move))
                    )
				);
				(R == 2,I == X2,J==Y) -> 
				(
    				ammo([M]),
					(StatusB == wumpus, M > 0)->
                    (
                        assert(agent_next_action(shoot))
                    );
                    (
						retractall(agent_best_move(_)),
						next_move,
						assert(agent_next_action(move))
                    )
				);
				(R == 3,I == X,J==Y2) -> 
				(
    				ammo([M]),
					(StatusB == wumpus, M > 0)->
                    (
                        assert(agent_next_action(shoot))
                    );
                    (
						retractall(agent_best_move(_)),
						next_move,
						assert(agent_next_action(move))
                    )
				)
			);
			(
				(R == 0,I == X2) -> 
				(
					assert(agent_next_action(turnRight))
				);
				(R == 0,J == Y1) -> 
				(
					assert(agent_next_action(turnLeft))
				);
				(R == 0,J == Y2) -> 
				(
					assert(agent_next_action(turnRight))
				);

				(R == 1,J == Y2) -> 
				(
					assert(agent_next_action(turnRight))
				);
				(R == 1,I == X2) -> 
				(
					assert(agent_next_action(turnLeft))
				);
				(R == 1,I == X1) -> 
				(
					assert(agent_next_action(turnRight))
				);

				(R == 2,I == X1) -> 
				(
					assert(agent_next_action(turnRight))
				);
				(R == 2,J == Y1) -> 
				(
					assert(agent_next_action(turnRight))
				);
				(R == 2,J == Y2) -> 
				(
					assert(agent_next_action(turnLeft))
				);

				(R == 3,J == Y1) -> 
				(
					assert(agent_next_action(turnRight))
				);
				(R == 3,I == X2) -> 
				(
					assert(agent_next_action(turnRight))
				);
				(R == 3,I == X1) -> 
				(
					assert(agent_next_action(turnLeft))
				);
				true
			)
		);
		
		%calcula a melhor casa
		
		(
			agent_back(Back),
			(
				(Back)->
				(
					(X == 0, Y == 0)->
					(
						assert(agent_next_action(climb))
					);
					(
						agent_steps([S]),
						Step is S-1,
						retractall(agent_steps(_)),
						assert(agent_steps([Step])),
						agent_path([Px,Py], Step),
						retractall(agent_path([Px,Py], Step)),
						assert(agent_best_move([Px,Py])),

						(
							(R == 0,Px == X1,Py==Y) -> 
							(
								retractall(agent_best_move(_)),
								next_move,
								assert(agent_next_action(move))
							);
							(R == 1,Px == X,Py==Y1) -> 
							(
								retractall(agent_best_move(_)),
								next_move,
								assert(agent_next_action(move))
							);
							(R == 2,Px == X2,Py==Y) -> 
							(
								retractall(agent_best_move(_)),
								next_move,
								assert(agent_next_action(move))
							);
							(R == 3,Px == X,Py==Y2) -> 
							(
								retractall(agent_best_move(_)),
								next_move,
								assert(agent_next_action(move))
							)
						);
						(
							(R == 0,Px == X2) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 0,Py == Y1) -> 
							(
								assert(agent_next_action(turnLeft))
							);
							(R == 0,Py == Y2) -> 
							(
								assert(agent_next_action(turnRight))
							);

							(R == 1,Py == Y2) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 1,Px == X2) -> 
							(
								assert(agent_next_action(turnLeft))
							);
							(R == 1,Px == X1) -> 
							(
								assert(agent_next_action(turnRight))
							);

							(R == 2,Px == X1) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 2,Py == Y1) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 2,Py == Y2) -> 
							(
								assert(agent_next_action(turnLeft))
							);

							(R == 3,Py == Y1) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 3,Px == X2) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 3,Px == X1) -> 
							(
								assert(agent_next_action(turnLeft))
							);
							true
						)
					)
				);
				(
					agent_map([X1, Y], Status1, Visited1),
					agent_map([X2, Y], Status2, Visited2),
					agent_map([X, Y1], Status3, Visited3),
					agent_map([X, Y2], Status4, Visited4),
					(
						(Status1 == misterio, X1 =< 11, not(Visited1))-> (
							assert(agent_best_move([X1,Y]))
						);
						(Status2 == misterio, X2 >= 0, not(Visited2))-> (
							assert(agent_best_move([X2,Y]))
						);
						(Status3 == misterio, Y1 =< 11, not(Visited3))-> (
							assert(agent_best_move([X,Y1]))
						);
						(Status4 == misterio, Y2 >= 0, not(Visited4))-> (
							assert(agent_best_move([X,Y2]))
						);						
						(Status1 == seguro, X1 =< 11, not(Visited1))-> (
							assert(agent_best_move([X1,Y]))
						);
						(Status2 == seguro, X2 >= 0, not(Visited2))-> (
							assert(agent_best_move([X2,Y]))
						);
						(Status3 == seguro, Y1 =< 11, not(Visited3))-> (
							assert(agent_best_move([X,Y1]))
						);
						(Status4 == seguro, Y2 >= 0, not(Visited4))-> (
							assert(agent_best_move([X,Y2]))
						);
						
											
						(
    						random_between(0,10,Rand),
    						(
    							(Rand == 0, not(Status1 == buraco)) ->
    							(
    								assert(agent_best_move([X1,Y]))
    							);
    							(Rand == 1, not(Status2 == buraco)) ->
    							(
    								assert(agent_best_move([X2,Y]))
    							);
    							(Rand == 2, not(Status3 == buraco)) ->
    							(
    								assert(agent_best_move([X,Y1]))
    							);
    							(Rand == 3, not(Status4 == buraco)) ->
    							(
    								assert(agent_best_move([X,Y2]))
    							);
								false
    						)
						);
						
						(Status1 == seguro, X1 =< 11, Visited1)-> (
							assert(agent_best_move([X1,Y]))
						);
						(Status2 == seguro, X2 >= 0, Visited2)-> (
							assert(agent_best_move([X2,Y]))
						);
						(Status3 == seguro, Y1 =< 11, Visited3)-> (
							assert(agent_best_move([X,Y1]))
						);
						(Status4 == seguro, Y2 >= 0, Visited4)-> (
							assert(agent_best_move([X,Y2]))
						);
						
						
						(Status1 == talvezWumpus, X1 =< 11, not(Visited1))-> (
							assert(agent_best_move([X1,Y]))
						);
						(Status2 == talvezWumpus, X2 >= 0, not(Visited2))-> (
							assert(agent_best_move([X2,Y]))
						);
						(Status3 == talvezWumpus, Y1 =< 11, not(Visited3))-> (
							assert(agent_best_move([X,Y1]))
						);
						(Status4 == talvezWumpus, Y2 >= 0, not(Visited4))-> (
							assert(agent_best_move([X,Y2]))
						);
						(Status1 == Wumpus, X1 =< 11, not(Visited1))-> (
		                    assert(agent_best_move([X1,Y]))
		                );
		                (Status2 == Wumpus, X2 >= 0, not(Visited2))-> (
		                    assert(agent_best_move([X2,Y]))
		                );
		                (Status3 == Wumpus, Y1 =< 11, not(Visited3))-> (
		                    assert(agent_best_move([X,Y1]))
		                );
		                (Status4 == Wumpus, Y2 >= 0, not(Visited4))-> (
		                    assert(agent_best_move([X,Y2]))
		                );
						(Status1 == talvezBuraco, X1 =< 11, not(Visited1))-> (
							assert(agent_best_move([X1,Y]))
						);
						(Status2 == talvezBuraco, X2 >= 0, not(Visited2))-> (
							assert(agent_best_move([X2,Y]))
						);
						(Status3 == talvezBuraco, Y1 =< 11, not(Visited3))-> (
							assert(agent_best_move([X,Y1]))
						);
						(Status4 == talvezBuraco, Y2 >= 0, not(Visited4))-> (
							assert(agent_best_move([X,Y2]))
						);
						(Status1 == talvezWumpus, X1 =< 11, Visited1)-> (
							assert(agent_best_move([X1,Y]))
						);
						(Status2 == talvezWumpus, X2 >= 0, Visited2)-> (
							assert(agent_best_move([X2,Y]))
						);
						(Status3 == talvezWumpus, Y1 =< 11, Visited3)-> (
							assert(agent_best_move([X,Y1]))
						);
						(Status4 == talvezWumpus, Y2 >= 0, Visited4)-> (
							assert(agent_best_move([X,Y2]))
						);
						(Status1 == Wumpus, X1 =< 11, Visited1)-> (
		                    assert(agent_best_move([X1,Y]))
		                );
		                (Status2 == Wumpus, X2 >= 0, Visited2)-> (
		                    assert(agent_best_move([X2,Y]))
		                );
		                (Status3 == Wumpus, Y1 =< 11, Visited3)-> (
		                    assert(agent_best_move([X,Y1]))
		                );
		                (Status4 == Wumpus, Y2 >= 0, Visited4)-> (
		                    assert(agent_best_move([X,Y2]))
		                );
						(Status1 == talvezBuraco, X1 =< 11, Visited1)-> (
							assert(agent_best_move([X1,Y]))
						);
						(Status2 == talvezBuraco, X2 >= 0, Visited2)-> (
							assert(agent_best_move([X2,Y]))
						);
						(Status3 == talvezBuraco, Y1 =< 11, Visited3)-> (
							assert(agent_best_move([X,Y1]))
						);
						(Status4 == talvezBuraco, Y2 >= 0, Visited4)-> (
							assert(agent_best_move([X,Y2]))
						);
						true
					),

					(agent_best_move([I2,J2])) -> 
					(
						(
							(R == 0,I2 == X1,J2==Y) -> 
							(
			    				ammo([M1]),
								(Status1 == wumpus, M1 > 0)-> 
		                        (
		                            assert(agent_next_action(shoot))
		                        );
		                        (
									retractall(agent_best_move(_)),
									next_move,
									assert(agent_next_action(move))
		                        )
							);
							(R == 1,I2 == X,J2==Y1) -> 
							(
			    				ammo([M1]),
								(Status3 == wumpus, M1 > 0)-> 
								(
                            		assert(agent_next_action(shoot))
                        		);
		                        (
									retractall(agent_best_move(_)),
									next_move,
									assert(agent_next_action(move))
		                        )
							);
							(R == 2,I2 == X2,J2==Y) -> 
							(
			    				ammo([M1]),
								(Status2 == wumpus, M1 > 0)->
		                        (
		                            assert(agent_next_action(shoot))
		                        );
		                        (
									retractall(agent_best_move(_)),
									next_move,
									assert(agent_next_action(move))
		                        )
							);
							(R == 3,I2 == X,J2==Y2) -> 
							(
			    				ammo([M1]),
								(Status4 == wumpus, M1 > 0)-> 
		                        (
		                            assert(agent_next_action(shoot))
		                        );
		                        (
									retractall(agent_best_move(_)),
									next_move,
									assert(agent_next_action(move))
		                        )
							)
						);
						(
							(R == 0,I2 == X2) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 0,J2 == Y1) -> 
							(
								assert(agent_next_action(turnLeft))
							);
							(R == 0,J2 == Y2) -> 
							(
								assert(agent_next_action(turnRight))
							);

							(R == 1,J2 == Y2) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 1,I2 == X2) -> 
							(
								assert(agent_next_action(turnLeft))
							);
							(R == 1,I2 == X1) -> 
							(
								assert(agent_next_action(turnRight))
							);

							(R == 2,I2 == X1) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 2,J2 == Y1) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 2,J2 == Y2) -> 
							(
								assert(agent_next_action(turnLeft))
							);

							(R == 3,J2 == Y1) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 3,I2 == X2) -> 
							(
								assert(agent_next_action(turnRight))
							);
							(R == 3,I2 == X1) -> 
							(
								assert(agent_next_action(turnLeft))
							);
							true
						)
					)
				)
			)
		
		)
	),
	!.
	

execute_current_action :-
	agent_next_action(Action),
	(	 
		(Action == move) -> (
            move
        ); 
		(Action == turnRight) -> (
			turn_right
		); 
		(Action == turnLeft) -> (
			turn_left
		); 
		(Action == climb) -> (
			climb
		); 
		(Action == grab) -> (
			pegar
		); 
		(Action == shoot) -> (
			disparar
		); 
		(Action == back) -> (
			move_back
		); 
		false
	),
	format(Action),
	retractall(agent_next_action(_)).
