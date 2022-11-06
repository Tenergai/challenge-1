:-dynamic facto/2, ultimo_facto/1, ratio/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Metaconhecimento
facto_dispara_regras(usertype(this_period,individual), [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]).
facto_dispara_regras(ratio(this_period,_), [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]).
facto_dispara_regras(predicted_scarcity(this_period,_), [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,16,18,22,23,24]).
facto_dispara_regras(want_shift_load(this_period,_), [4,5,6,7,8]).
facto_dispara_regras(has_EV(this_period,_), [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,19,20,21,22,23,24]).
facto_dispara_regras(excess(this_period,_), [1,2,5,6,7]).
facto_dispara_regras(battery_ev(this_period,_), [2,3,6,7,8,9,10,11,12,21,22,23,24]).
facto_dispara_regras(expensive_hour(this_period,_), [7,8,19,20,22,24]).
facto_dispara_regras(options(this_period,_), [4]).
facto_dispara_regras(can_improve_r(this_period,_), [10,11,12,13,14,15,16,17,18]).
facto_dispara_regras(usertype(this_period,community), [25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42]).
facto_dispara_regras(community_ratio(this_period,_),[25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42]).
facto_dispara_regras(community_predicted_scarcity(this_period,_),[25,26,27,28,29,30,31,34,37,39,40,41,42]).
facto_dispara_regras(community_battery(this_period,_),[25,26,27,28,32,33,34,35,36,37,41,42]).
facto_dispara_regras(community_demand(this_period,_),[26,27,28,29,30,31]).
facto_dispara_regras(external_market_demand(this_period,_),[27,28,30,31]).
facto_dispara_regras(current_energy_scarcity(this_period,_),[32,33,34,35,36,37,38,39,40,41,42]).
facto_dispara_regras(participant_with_surplus(this_period,_),[33,34,35,36,37,38,39,40,41,42]).
facto_dispara_regras(community_expensive_hour(this_period,_),[35,36,37,40,41,42]).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ultimo_facto(41).
ultima_regra(42).

%%%%%%%%%%%%%%%%%%Individual%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%[R>1]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
regra 1
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,1) e has_EV(this_period,0) e excess(this_period,E)]
	entao [cria_facto(should_sell(this_period,E))].

regra 2
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,1) e has_EV(this_period,1) e excess(this_period,E) e avalia(battery_ev(this_period,>=,50))]
	entao [cria_facto(should_sell(this_period,E))].	
	
regra 3
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,1) e has_EV(this_period,1) e avalia(battery_ev(this_period,<,50))]
	entao [cria_facto(charge_battery(this_period,1))].

regra 4
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,0) e want_shift_load(this_period,1) e options(this_period,OP)]
	entao [cria_facto(options_to_shift_load(this_period,OP))].
	
regra 5
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,0) e want_shift_load(this_period,0) e has_EV(this_period,0) e excess(this_period,E)]
	entao [cria_facto(should_sell(this_period,E))].

regra 6
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,0) e want_shift_load(this_period,0) e has_EV(this_period,1) e avalia(battery_ev(this_period,>=,50)) e excess(this_period,E)]
	entao [cria_facto(should_sell(this_period,E))].

regra 7
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,0) e want_shift_load(this_period,0) e has_EV(this_period,1) e avalia(battery_ev(this_period,<,50)) e expensive_hour(this_period,1) e excess(this_period,E)]
	entao [cria_facto(should_sell(this_period,E))].

regra 8
	se [usertype(this_period,individual) e avalia(ratio(this_period,>,1)) e predicted_scarcity(this_period,0) e want_shift_load(this_period,0) e has_EV(this_period,1) e avalia(battery_ev(this_period,<,50)) e expensive_hour(this_period,0)]
	entao [cria_facto(charge_battery(this_period,1))].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%[1>=R>0]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
regra 9
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,1) e has_EV(this_period,1) e avalia(battery_ev(this_period,<,50))]
	entao [cria_facto(charge_battery(this_period,1))].
	
regra 10
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,1) e has_EV(this_period,1) e avalia(battery_ev(this_period,>=,50)) e can_improve_r(this_period,1)]
	entao [cria_facto(run_improvement(this_period,print_improvements))].

regra 11
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,1) e has_EV(this_period,1) e avalia(battery_ev(this_period,>=,50)) e can_improve_r(this_period,0) e avalia(ratio(this_period,==,1))]
	entao [cria_facto(run_no_operation(this_period,print_no_operation))].
	
regra 12
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,1) e has_EV(this_period,1) e avalia(battery_ev(this_period,>=,50)) e can_improve_r(this_period,0) e avalia(ratio(this_period,\==,1))]
	entao [cria_facto(buy_from_cheapest_market(this_period,1))].
	
regra 13
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,1) e has_EV(this_period,0) e can_improve_r(this_period,1)]
	entao [cria_facto(run_improvement(this_period,print_improvements))].
	
regra 14 
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,1) e has_EV(this_period,0) e can_improve_r(this_period,0) e avalia(ratio(this_period,==,1))]
	entao [cria_facto(run_no_operation(this_period,print_no_operation))].
	
regra 15
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,1) e has_EV(this_period,0) e can_improve_r(this_period,0) e avalia(ratio(this_period,\==,1))]
	entao [cria_facto(buy_from_cheapest_market(this_period,1))].

regra 16
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,0) e can_improve_r(this_period,1)]
	entao [cria_facto(run_improvement(this_period,print_improvements))].

regra 17
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,0) e can_improve_r(this_period,0) e avalia(ratio(this_period,==,1))]
	entao [cria_facto(run_no_operation(this_period,print_no_operation))].
	
regra 18
	se [usertype(this_period,individual) e avalia(ratio(this_period,=<,1)) e avalia(ratio(this_period,>,0)) e predicted_scarcity(this_period,0) e can_improve_r(this_period,0) e avalia(ratio(this_period,\==,1))]
	entao [cria_facto(buy_from_cheapest_market(this_period,1))].	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%[R=0]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

regra 19
	se [usertype(this_period,individual) e avalia(ratio(this_period,==,0)) e has_EV(this_period,0) e expensive_hour(this_period,0)]
	entao [cria_facto(keep_buying(this_period,1))].	
	
regra 20
	se [usertype(this_period,individual) e avalia(ratio(this_period,==,0)) e has_EV(this_period,0) e expensive_hour(this_period,1)]
	entao [print_shift_load_to_essential_consumption].

regra 21
	se [usertype(this_period,individual) e avalia(ratio(this_period,==,0)) e has_EV(this_period,1) e avalia(battery_ev(this_period,<,50))]
	entao [cria_facto(charge_battery(this_period,1))].

regra 22
	se [usertype(this_period,individual) e avalia(ratio(this_period,==,0)) e has_EV(this_period,1) e avalia(battery_ev(this_period,>=,50)) e predicted_scarcity(this_period,1)]
	entao [cria_facto(use_battery(this_period,1))].

regra 23
	se [usertype(this_period,individual) e avalia(ratio(this_period,==,0)) e has_EV(this_period,1) e avalia(battery_ev(this_period,>=,50)) e predicted_scarcity(this_period,0) e expensive_hour(this_period,0)]
	entao [cria_facto(keep_buying(this_period,1))].

regra 24
	se [usertype(this_period,individual) e avalia(ratio(this_period,==,0)) e has_EV(this_period,1) e avalia(battery_ev(this_period,>=,50)) e predicted_scarcity(this_period,0) e expensive_hour(this_period,1)]
	entao [print_shift_load_to_essential_consumption].

%%%%%%%%%%%%Community%%%%%%%%%%%%%%%%%%%%

regra 25
    se [usertype(this_period,community) e avalia(community_ratio(this_period,>,1)) e community_predicted_scarcity(this_period,1) e avalia(community_battery(this_period,<,50))]
	entao [cria_facto(charge_community_battery(this_period,1))].

regra 26
    se [usertype(this_period,community) e avalia(community_ratio(this_period,>,1)) e community_predicted_scarcity(this_period,1) e avalia(community_battery(this_period,>=,50)) e community_demand(this_period,1)]
	entao [cria_facto(sell_to_local_community_market(this_period,1))].
	
regra 27
    se [usertype(this_period,community) e avalia(community_ratio(this_period,>,1)) e community_predicted_scarcity(this_period,1) e avalia(community_battery(this_period,>=,50)) e community_demand(this_period,0) e external_market_demand(this_period,1)]
	entao [cria_facto(sell_to_external_market(this_period,1))].
	
regra 28
    se [usertype(this_period,community) e avalia(community_ratio(this_period,>,1)) e community_predicted_scarcity(this_period,1) e avalia(community_battery(this_period,>=,50)) e community_demand(this_period,0) e external_market_demand(this_period,0)]
	entao [cria_facto(send_to_the_grid(this_period,1))].
	
regra 29
    se [usertype(this_period,community) e avalia(community_ratio(this_period,>,1)) e community_predicted_scarcity(this_period,0) e community_demand(this_period,1)]
	entao [cria_facto(sell_to_local_community_market(this_period,1))].
	
regra 30
    se [usertype(this_period,community) e avalia(community_ratio(this_period,>,1)) e community_predicted_scarcity(this_period,0) e community_demand(this_period,0) e external_market_demand(this_period,1)]
	entao [cria_facto(sell_to_external_market(this_period,1))].
	
regra 31
    se [usertype(this_period,community) e avalia(community_ratio(this_period,>,1)) e community_predicted_scarcity(this_period,0) e community_demand(this_period,0) e external_market_demand(this_period,0)]
	entao [cria_facto(send_to_the_grid(this_period,1))].
	
regra 32
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,1) e avalia(community_battery(this_period,>=,80))]
	entao [cria_facto(use_community_battery_energy(this_period,1))].

regra 33 
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,1) e avalia(community_battery(this_period,<,80)) e participant_with_surplus(this_period,1)]
	entao [cria_facto(should_exchange_energy_between_community_members(this_period,1))].

regra 34 
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,1) e avalia(community_battery(this_period,<,80)) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,1)]
	entao [cria_facto(buy_from_external_market(this_period,1))].

regra 35 
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,1) e avalia(community_battery(this_period,<,80)) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,0) e community_expensive_hour(this_period,0)]
	entao [cria_facto(buy_from_external_market(this_period,1))].
	
regra 36 
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,1) e avalia(community_battery(this_period,<,80)) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,0) e community_expensive_hour(this_period,1) e avalia(community_battery(this_period,>=,50))]
	entao [cria_facto(use_community_battery_energy(this_period,1))].

regra 37 
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,1) e avalia(community_battery(this_period,<,80)) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,0) e community_expensive_hour(this_period,1) e avalia(community_battery(this_period,<,50))]
	entao [cria_facto(buy_from_external_market(this_period,1))].
	
regra 38
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,0) e participant_with_surplus(this_period,1)]
	entao [cria_facto(should_exchange_energy_between_community_members(this_period,1))].
	
regra 39
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,0) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,1)]
	entao [cria_facto(buy_from_external_market(this_period,1))].

regra 40
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,0) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,0) e community_expensive_hour(this_period,0)]
	entao [cria_facto(buy_from_external_market(this_period,1))].

regra 41
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,0) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,0) e community_expensive_hour(this_period,1) e avalia(community_battery(this_period,>=,50))]
	entao [cria_facto(use_community_battery_energy(this_period,1))].

regra 42
	se [usertype(this_period,community) e avalia(community_ratio(this_period,=<,1)) e current_energy_scarcity(this_period,0) e participant_with_surplus(this_period,0) e community_predicted_scarcity(this_period,0) e community_expensive_hour(this_period,1) e avalia(community_battery(this_period,<,50))]
	entao [cria_facto(buy_from_external_market(this_period,1))].



facto(1,solar_radiation(this_period,112)).
facto(2,temperature(this_period,6)).
facto(3,wind_speed(this_period,15)).


%production
facto(4,production(this_period,2000)).

%devices
facto(5,device(ac,200)).
facto(6,connected(ac,1)).
facto(7,essential(ac,1)).

facto(8,device(washing_machine,400)).
facto(9,connected(washing_machine,1)).
facto(10,essential(washing_machine,0)).

facto(11,device(dryer,100)).
facto(12,connected(dryer,0)).
facto(13,essential(dryer,0)).

facto(14,device(roomba,500)).
facto(15,connected(roomba,0)).
facto(16,essential(roomba,1)).

facto(17,device(microwave,100)).
facto(18,connected(microwave,1)).
facto(19,essential(microwave,1)).

facto(20,energy_price(this_period,0.005)).
facto(21,usertype(this_period,individual)).
facto(22,device(ev,150)).
facto(23,has_EV(this_period,1)).
facto(24,predicted_scarcity(this_period,0)).
facto(25,want_shift_load(this_period,0)).
facto(26,battery_ev(this_period,70)).
facto(27,preco_medio(this_period,0.12)).
facto(28,production_community(this_period,6000)).
facto(29,total_consumo_community(this_period,4000)).
facto(30,community_battery(this_period,30)).

facto(31,facto_total_consumo(this_period,1450)).
facto(32,ratio(this_period,1.3793103448275863)).
facto(33,preco_atual(this_period,0.03)).
facto(34,expensive_hour(this_period,0)).

facto(35,community_predicted_scarcity(this_period,0)).
facto(36,current_energy_scarcity(this_period,0)).
facto(37,community_ratio(this_period,1.5)).
facto(38,participant_with_surplus(this_period,1)).
facto(39,community_demand(this_period,1)).
facto(40,external_market_demand(this_period,0)).
facto(41,community_expensive_hour(this_period,1)).


% facto(28, usertype(this_period,community))

%%%%%%%%%%%%%%%%%%Community%%%%%%%%%%%%%%%%%%%%






	

	
	
	














