% Vers�o preparada para lidar com regras que contenham nega��o (nao)
% Metaconhecimento
% Usar base de conhecimento veIculos2.txt
% Explica��es como?(how?) e porque n�o?(whynot?)

:-op(220,xfx,entao).
:-op(35,xfy,se).
:-op(240,fx,regra).
:-op(500,fy,nao).
:-op(600,xfy,e).

:-dynamic justifica/3, ratio/2.


carrega_bc:-
		write('KNOWLEDGE BASE NAME (end with .)-> '),
		read(NBC),
		consult(NBC).

%%%%%%%%%%%%%%%%%%[Individual]%%%%%%%%%%%%%%%%%%%%

individual:-
	retract(facto(F,(usertype(_,_)))),
	assert(facto(F,(usertype(this_period,individual)))),
	calculos. 

calculos:- cria_facto_consumo,
			calcular_ratio,
			ask_actual_price,
			ask_predicted_scarcity,
			ask_wants_to_shift_load,
			check_expensive_hour,
			calcular_excess,
			calcular_deficit,
			shift_load,
			shift_load_deficit(I),
			check_r_improvement(I).

cria_facto_consumo:-findall(X,facto(_,device(_,X)),LR),!,calcula_consumo(LR,T),
	((call(facto(_,(facto_total_consumo(this_period,T)))),!);
	(call(facto(F,(facto_total_consumo(this_period,_)))),
	retract(facto(F,(facto_total_consumo(this_period,_)))),
	assert(facto(F,(facto_total_consumo(this_period,T)))),!);(
	retract(ultimo_facto(N1)),N is N1+1,
	asserta(ultimo_facto(N)),assertz(facto(N,(facto_total_consumo(this_period,T)))))).

calcula_consumo([],0):-!.
calcula_consumo([H|T],R):-calcula_consumo(T,R1), R is H + R1.

ask_actual_price:-
	write('ACTUAL ENERGY PRICE eur/kWh (end with .)-> '),
	read(PA),
	((call(facto(_,(preco_atual(this_period,PA)))),!);
	(call(facto(F,(preco_atual(this_period,_)))),
	retract(facto(F,(preco_atual(this_period,_)))),
	assert(facto(F,(preco_atual(this_period,PA)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,preco_atual(this_period,PA))))).

ask_predicted_scarcity:-
	write('PREDICTED ENERGY SCARCITY? 1-YES/ 0-NO (end with .)-> '),
	read(PS),
	((call(facto(_,(predicted_scarcity(this_period,PS)))),!);
	(call(facto(F,(predicted_scarcity(this_period,_)))),
	retract(facto(F,(predicted_scarcity(this_period,_)))),
	assert(facto(F,(predicted_scarcity(this_period,PS)))),!);
	(retract(ultimo_facto(X1)), X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,predicted_scarcity(this_period,PS))))).
	
ask_wants_to_shift_load:-
	write('WILL YOU WANT TO SHIFT LOAD? 1-YES/ 0-NO (end with .)-> '),
	read(SL),
	((call(facto(_,(want_shift_load(this_period,SL)))),!);
	(call(facto(F,(want_shift_load(this_period,_)))),
	retract(facto(F,(want_shift_load(this_period,_)))),
	assert(facto(F,(want_shift_load(this_period,SL)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,want_shift_load(this_period,SL))))).
	

check_expensive_hour:-	
	facto(_,preco_atual(_,PA)),
	facto(_,preco_medio(_,PM)),
	((call(facto(F,(expensive_hour(this_period,_)))),
	retract(facto(F,(expensive_hour(this_period,_)))),
	((PA >= PM ->
	assert(facto(F,(expensive_hour(this_period,1)))))
	; (PA < PM ->
	assert(facto(F,(expensive_hour(this_period,0))))
	)));
	(retract(ultimo_facto(X1)),
	((PA >= PM ->X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(expensive_hour(this_period,1)))))
	; (PA < PM -> X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(expensive_hour(this_period,0)))))))). 

calcular_excess:-
	facto(_,production(_,Prod)),
	facto(_,facto_total_consumo(_,TotalConsum)),
	Excess is Prod - TotalConsum,
	Excess > 0,
	((call(facto(_,(excess(this_period,Excess)))),!);
	(call(facto(F,(excess(this_period,_)))),
	retract(facto(F,(excess(this_period,_)))),
	assert(facto(F,(excess(this_period,Excess)))),!);(
	retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(excess(this_period,Excess)))))).
	
calcular_excess:-
    facto(_,production(_,Prod)),
	facto(_,facto_total_consumo(_,TotalConsum)),
	Excess is Prod - TotalConsum,
    Excess =<0,
	((call(facto(_,(excess(this_period,0)))),!);
	(call(facto(F,(excess(this_period,_)))),
	retract(facto(F,(excess(this_period,_)))),
	assert(facto(F,(excess(this_period,0)))),!);(
	retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(excess(this_period,0)))))).

calcular_deficit:-
	facto(_,production(_,Prod)),
	facto(_,facto_total_consumo(_,TotalConsum)),
	Deficit is Prod - TotalConsum,
	((Deficit < 0,
	((call(facto(_,(deficit(this_period,Deficit)))),!);
	(call(facto(F,(deficit(this_period,_)))),
	retract(facto(F,(deficit(this_period,_)))),
	assert(facto(F,(deficit(this_period,Deficit)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(deficit(this_period,Deficit)))))));
	(Deficit >= 0,
	((call(facto(_,(deficit(this_period,0)))),!);
	(call(facto(F,(deficit(this_period,_)))),
	retract(facto(F,(deficit(this_period,_)))),
	assert(facto(F,(deficit(this_period,0)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(deficit(this_period,0)))))))).
	
calcular_ratio:-
	facto(_,production(_,Prod)),
	facto(_,facto_total_consumo(_,TotalConsum)),
	((TotalConsum==0, Ratio is 0,!);(
	Ratio is Prod / TotalConsum)),
	((call(facto(_,(ratio(this_period,Ratio)))),!);
	(call(facto(F,(ratio(this_period,_)))),
	retract(facto(F,(ratio(this_period,_)))),
	assert(facto(F,(ratio(this_period,Ratio)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(ratio(this_period,Ratio)))))).

%%%%%%%%%%%%%%%%[INDIVIDUAL - Disconnect Devices using all production]%%%%%%%%%%%%%%%%%%%%
combine(E, LR1):-findall(device(N,C),(facto(_,device(N,C)), facto(_,connected(N,0))),D),makecombinations(D,E,LR),devices(E,D1),checkOneOne(LR,D1,LR1),!.

makecombinations([], _,[]).
makecombinations([H|T], E,[R|X]):-E1 is E, combinations([H|T],E1,R), makecombinations(T,E,X).
combinations(_,0, []):-!.
combinations([],_, []):-!.
combinations([device(_,X)|T],E, R):-E>0, E1 is E-X, E1<0, combinations(T,E1,R).
combinations([device(N,X)|T],E, [device(N,X)|R]):-E>0, E1 is E-X, E1>=0, combinations(T,E1,R).
checkOneOne(LR,[], LR):-!.
checkOneOne(LR,[H|T],L):-member(H,LR),checkOneOne(LR,T,L).
checkOneOne(LR,[H|T], [H|L]):-checkOneOne(LR,T,L).
devices(E,D):-findall([device(N,C)],(facto(_,device(N,C)), facto(_,connected(N,0)), C=<E),D).



shift_load:-
	facto(_,(excess(this_period,E))),
	E>0,
	combine(E,L1),flatten(L1,L),
	((call(facto(_,(options(this_period,L)))),!);
	(call(facto(F,(options(this_period,_)))),
	retract(facto(F,(options(this_period,_)))),
	assert(facto(F,(options(this_period,L)))),!);
	(retract(ultimo_facto(N1)),
	N is N1+1,
	asserta(ultimo_facto(N)),
	assertz(facto(N,(options(this_period,L)))))).

shift_load:-
	facto(_,(excess(this_period,E))),
	E=0.



%%%%%%%%%%%%%%%%[INDIVIDUAL - Essentials]%%%%%%%%%%%%%%%%%%%%
shift_load_deficit(I):-
	facto(_,(deficit(this_period,E))),
	E<0,
	combineEssentials(E,L1,I), flatten(L1,L), 
	((call(facto(_,(load_essential(this_period,L)))),!);
	(call(facto(F,(load_essential(this_period,_)))),
	retract(facto(F,(load_essential(this_period,_)))),
	assert(facto(F,(load_essential(this_period,L)))),!);
	(retract(ultimo_facto(N1)),
	N is N1+1,
	asserta(ultimo_facto(N)),
	assertz(facto(N,(load_essential(this_period,L)))))).

shift_load_deficit(I):-
	facto(_,(deficit(this_period,E))),
	E=0, I is 0.

combineEssentials(E, LR1,I):-findall(device(N,C),(facto(_,device(N,C)), facto(_,connected(N,1)),facto(_,essential(N,0))),D),makecombinationsEssentials(D,E,LR,I),not_essentials_devices(D1),checkOneOneEssential(LR,D1,LR1).
makecombinationsEssentials([], _,[],0).
makecombinationsEssentials([H|T], E,[R|X],I):-E1 is E, combinationsE([H|T],E1,R,I1), makecombinationsEssentials(T,E,X,I2),I is I1+I2.
combinationsE(_,0, [],1):-!.
combinationsE([],_, [],0):-!.
combinationsE([device(N,X)|T],E, [device(N,X)|R],I):-E<0, E1 is E+X, E1=<0, combinationsE(T,E1,R,I).
checkOneOneEssential(LR,[], LR):-!.
checkOneOneEssential(LR,[H|T],L):-member(H,LR),checkOneOneEssential(LR,T,L).
checkOneOneEssential(LR,[H|T], [H|L]):-checkOneOneEssential(LR,T,L).

not_essentials_devices(D):-findall([device(N,C)],(facto(_,device(N,C)), facto(_,connected(N,1)), facto(_,essential(N,0))),D).

check_r_improvement(I):-I>0,
	((call(facto(_,(can_improve_r(this_period,1)))),!);
	(call(facto(F,(can_improve_r(this_period,_)))),
	retract(facto(F,(can_improve_r(this_period,_)))),
	assert(facto(F,(can_improve_r(this_period,1)))),!);
	(retract(ultimo_facto(N1)),N is N1+1,
	asserta(ultimo_facto(N)),
	assertz(facto(N,(can_improve_r(this_period,1)))))).

check_r_improvement(I):-I=0,
	((call(facto(_,(can_improve_r(this_period,0)))),!);
	(call(facto(F,(can_improve_r(this_period,_)))),
	retract(facto(F,(can_improve_r(this_period,_)))),
	assert(facto(F,(can_improve_r(this_period,0)))),!);
	(retract(ultimo_facto(N1)),N is N1+1,
	asserta(ultimo_facto(N)),
	assertz(facto(N,(can_improve_r(this_period,0)))))).


print_options(OP):-write('These are your options to shift load:\n'), write(OP).

print_no_operation:-write('No operations is required.\n').

print_shift_load_to_essential_consumption:-
	facto(_,load_essential(_,L)),
	write('These are your options to shift load and reduce your deficit:\n'), write(L).

print_improvements:-
	facto(_,load_essential(_,L)),
	write('These are your options to improve the ratio:\n'), write(L).


%%%%%%%%%%%%%%%%%%[Community]%%%%%%%%%%%%%%%%%%%%

community:-
	retract(facto(F,(usertype(_,_)))),
	assert(facto(F,(usertype(this_period,community)))),
	community_system.
	
community_system:-predicted_scarcity_community,
				calculate_current_energy_scarcity,
				calcular_ratio_community,
				ask_participants_surplus,
				ask_community_demand,
				ask_external_market_demand,
				ask_expensive_hour.


predicted_scarcity_community:-
	write('PREDICTED ENERGY SCARCITY IN THE COMMUNITY? 1-YES/ 0-NO (end with .)-> '),
	read(PS),
	((call(facto(_,(community_predicted_scarcity(this_period,PS)))),!);
	(call(facto(F,(community_predicted_scarcity(this_period,_)))),
	retract(facto(F,(community_predicted_scarcity(this_period,_)))),
	assert(facto(F,(community_predicted_scarcity(this_period,PS)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,community_predicted_scarcity(this_period,PS))))).

calculate_current_energy_scarcity:-
	facto(_, solar_radiation(_,SR)),
	facto(_, temperature(_,T)),
	facto(_,wind_speed(_,W)),
	checkCurrentScarcity(SR,W,T,R),
	((call(facto(_,(current_energy_scarcity(this_period,R)))),!);
	(call(facto(F,(current_energy_scarcity(this_period,_)))),
	retract(facto(F,(current_energy_scarcity(this_period,_)))),
	assert(facto(F,(current_energy_scarcity(this_period,R)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,current_energy_scarcity(this_period,R))))).

checkCurrentScarcity(SR,W,T,R):-
	SR>=100, SR<200, W>=12, T>=15, R is 1.
checkCurrentScarcity(SR,W,T,R):-
	((SR>=100, SR<200);W>=12), T>=15, R is 1.
checkCurrentScarcity(SR,W,T,R):-
	R is 0.

ask_community_demand:-
	write('ANY COMMUNITY DEMAND? 1-YES/ 0-NO (end with .)-> '),
	read(CD),
	((call(facto(_,(community_demand(this_period,CD)))),!);
	(call(facto(F,(community_demand(this_period,_)))),
	retract(facto(F,(community_demand(this_period,_)))),
	assert(facto(F,(community_demand(this_period,CD)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,community_demand(this_period,CD))))).


calcular_ratio_community:-

	facto(_,production_community(_,Prod)),
	facto(_,total_consumo_community(_,TotalConsum)),
	((TotalConsum==0, Ratio is 0,!);(
	Ratio is Prod / TotalConsum)),
	((call(facto(_,(community_ratio(this_period,Ratio)))),!);
	(call(facto(F,(community_ratio(this_period,_)))),
	retract(facto(F,(community_ratio(this_period,_)))),
	assert(facto(F,(community_ratio(this_period,Ratio)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,(ratio(community_ratio,Ratio)))))).

ask_expensive_hour:-
	write('ARE WE IN THE EXPENSIVE HOUR? 1-YES/ 0-NO (end with .)-> '),
	read(EH),
	((call(facto(_,(community_expensive_hour(this_period,EH)))),!);
	(call(facto(F,(community_expensive_hour(this_period,_)))),
	retract(facto(F,(community_expensive_hour(this_period,_)))),
	assert(facto(F,(community_expensive_hour(this_period,EH)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X,community_expensive_hour(this_period,EH))))).


ask_external_market_demand:-
	write('ANY EXTERNAL MARKET DEMAND? 1-YES/ 0-NO (end with .)-> '),
	read(EM),
	((call(facto(_,(external_market_demand(this_period,EM)))),!);
	(call(facto(F,(external_market_demand(this_period,_)))),
	retract(facto(F,(external_market_demand(this_period,_)))),
	assert(facto(F,(external_market_demand(this_period,EM)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X)),
	assertz(facto(X,external_market_demand(this_period,EM))))).

ask_participants_surplus:-
	write('ANY PARTICIPANT WITH SURPLUS? 1-YES/ 0-NO (end with .)-> '),
	read(PS),
	((call(facto(_,(participant_with_surplus(this_period,PS)))),!);
	(call(facto(F,(participant_with_surplus(this_period,_)))),
	retract(facto(F,(participant_with_surplus(this_period,_)))),
	assert(facto(F,(participant_with_surplus(this_period,PS)))),!);
	(retract(ultimo_facto(X1)),
	X is X1+1,
	asserta(ultimo_facto(X)),
	assertz(facto(X)),
	assertz(facto(X,participant_with_surplus(this_period,PS))))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%[MOTOR-🚗]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arranca_motor:-
	facto(N,Facto),
		facto_dispara_regras1(Facto, LRegras),
		dispara_regras(N, Facto, LRegras),
		ultimo_facto(N).

facto_dispara_regras1(Facto, LRegras):-
	facto_dispara_regras(Facto, LRegras),!.
facto_dispara_regras1(_, []).
% Caso em que o facto n�o origina o disparo de qualquer regra.

dispara_regras(N, Facto, [ID|LRegras]):-
	regra ID se LHS entao RHS,
	facto_esta_numa_condicao(Facto,LHS),
	% Instancia Facto em LHS
	verifica_condicoes(LHS, LFactos),
	member(N,LFactos),
	concluir(RHS,ID,LFactos),
	!,
	dispara_regras(N, Facto, LRegras).

dispara_regras(N, Facto, [_|LRegras]):-
	dispara_regras(N, Facto, LRegras).

dispara_regras(_, _, []).


facto_esta_numa_condicao(F,[F  e _]).

facto_esta_numa_condicao(F,[avalia(F1)  e _]):- F=..[H,H1|_],F1=..[H,H1|_].

facto_esta_numa_condicao(F,[_ e Fs]):- facto_esta_numa_condicao(F,[Fs]).

facto_esta_numa_condicao(F,[F]).

facto_esta_numa_condicao(F,[avalia(F1)]):-F=..[H,H1|_],F1=..[H,H1|_].


verifica_condicoes([nao avalia(X) e Y],[nao X|LF]):- !,
	\+ avalia(_,X),
	verifica_condicoes([Y],LF).
verifica_condicoes([avalia(X) e Y],[N|LF]):- !,
	avalia(N,X),
	verifica_condicoes([Y],LF).

verifica_condicoes([nao avalia(X)],[nao X]):- !, \+ avalia(_,X).
verifica_condicoes([avalia(X)],[N]):- !, avalia(N,X).

verifica_condicoes([nao X e Y],[nao X|LF]):- !,
	\+ facto(_,X),
	verifica_condicoes([Y],LF).
verifica_condicoes([X e Y],[N|LF]):- !,
	facto(N,X),
	verifica_condicoes([Y],LF).

verifica_condicoes([nao X],[nao X]):- !, \+ facto(_,X).
verifica_condicoes([X],[N]):- facto(N,X).



concluir([cria_facto(F)|Y],ID,LFactos):-
	!,
	cria_facto(F,ID,LFactos),
	concluir(Y,ID,LFactos).

concluir([],_,_):-!.



cria_facto(F,_,_):-
	facto(_,F),!.

cria_facto(F,ID,LFactos):-
	retract(ultimo_facto(N1)),
	N is N1+1,
	asserta(ultimo_facto(N)),
	assertz(justifica(N,ID,LFactos)),
	assertz(facto(N,F)),
	write('Following fact was concluded  '),write(N),write(' -> '),write(F),get0(_),!.



avalia(N,P):-	P=..[Functor,Entidade,Operando,Valor],
		P1=..[Functor,Entidade,Valor1],
		facto(N,P1),
		compara(Valor1,Operando,Valor).

compara(V1,==,V):- V1==V.
compara(V1,\==,V):- V1\==V.
compara(V1,>,V):-V1>V.
compara(V1,<,V):-V1<V.
compara(V1,>=,V):-V1>=V.
compara(V1,=<,V):-V1=<V.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualiza��o da base de factos

mostra_factos:-
	findall(N, facto(N, _), LFactos),
	escreve_factos(LFactos).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gera��o de explica��es do tipo "Como"

como(N):-ultimo_facto(Last),Last<N,!,
	write('This conclusion wasnt reached'),nl,nl.
como(N):-justifica(N,ID,LFactos),!,
	facto(N,F),
	write('Concludes the fact number '),write(N),write(' -> '),write(F),nl,
	write('by rule '),write(ID),nl,
	write('because it verified that '),nl,
	escreve_factos(LFactos),
	write('********************************************************'),nl,
	explica(LFactos).
como(N):-facto(N,F),
	write('Fact number '),write(N),write(' -> '),write(F),nl,
	write('was initially known'),nl,
	write('********************************************************'),nl.


escreve_factos([I|R]):-facto(I,F), !,
	write('Fact number '),write(I),write(' -> '),write(F),write(' is true'),nl,
	escreve_factos(R).
escreve_factos([I|R]):-
	write('The condition '),write(I),write(' is true'),nl,
	escreve_factos(R).
escreve_factos([]).

explica([I|R]):- \+ integer(I),!,explica(R).
explica([I|R]):-como(I),
		explica(R).
explica([]):-	write('********************************************************'),nl.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gera��o de explica��es do tipo "Porque nao"
% Exemplo: ?- whynot(classe(meu_ve�culo,ligeiro)).

whynot(Facto):-
	whynot(Facto,1).

whynot(Facto,_):-
	facto(_, Facto),
	!,
	write('The fact '),write(Facto),write(' is not false!'),nl.
whynot(Facto,Nivel):-
	encontra_regras_whynot(Facto,LLPF),
	whynot1(LLPF,Nivel).
whynot(nao Facto,Nivel):-
	formata(Nivel),write('Because:'),write(' The fact '),write(Facto),
	write(' is true'),nl.
whynot(Facto,Nivel):-
	formata(Nivel),write('Because:'),write(' The fact '),write(Facto),
	write(' isnt defined in the knowledge base'),nl.

%  As explica��es do whynot(Facto) devem considerar todas as regras que poderiam dar origem a conclus�o relativa ao facto Facto

encontra_regras_whynot(Facto,LLPF):-
	findall((ID,LPF),
		(
		regra ID se LHS entao RHS,
		member(cria_facto(Facto),RHS),
		encontra_premissas_falsas(LHS,LPF),
		LPF \== []
		),
		LLPF).

whynot1([],_).
whynot1([(ID,LPF)|LLPF],Nivel):-
	formata(Nivel),write('Because by the rule '),write(ID),write(':'),nl,
	Nivel1 is Nivel+1,
	explica_porque_nao(LPF,Nivel1),
	whynot1(LLPF,Nivel).

encontra_premissas_falsas([nao X e Y], LPF):-
	verifica_condicoes([nao X], _),
	!,
	encontra_premissas_falsas([Y], LPF).
encontra_premissas_falsas([X e Y], LPF):-
	verifica_condicoes([X], _),
	!,
	encontra_premissas_falsas([Y], LPF).
encontra_premissas_falsas([nao X], []):-
	verifica_condicoes([nao X], _),
	!.
encontra_premissas_falsas([X], []):-
	verifica_condicoes([X], _),
	!.
encontra_premissas_falsas([nao X e Y], [nao X|LPF]):-
	!,
	encontra_premissas_falsas([Y], LPF).
encontra_premissas_falsas([X e Y], [X|LPF]):-
	!,
	encontra_premissas_falsas([Y], LPF).
encontra_premissas_falsas([nao X], [nao X]):-!.
encontra_premissas_falsas([X], [X]).
encontra_premissas_falsas([]).

explica_porque_nao([],_).
explica_porque_nao([nao avalia(X)|LPF],Nivel):-
	!,
	formata(Nivel),write('The condition is '),write(X),write(' not false'),nl,
	explica_porque_nao(LPF,Nivel).
explica_porque_nao([avalia(X)|LPF],Nivel):-
	!,
	formata(Nivel),write('The condition '),write(X),write(' is  false'),nl,
	explica_porque_nao(LPF,Nivel).
explica_porque_nao([P|LPF],Nivel):-
	formata(Nivel),write('The premise '),write(P),write(' is false'),nl,
	Nivel1 is Nivel+1,
	whynot(P,Nivel1),
	explica_porque_nao(LPF,Nivel).

formata(Nivel):-
	Esp is (Nivel-1)*5, tab(Esp).
