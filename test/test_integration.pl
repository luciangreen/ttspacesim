:- begin_tests(integration).

:- use_module('../src/ttspacesim').
:- use_module('../src/validation').
:- use_module(test_support).

test(earth_to_mars_compressed_journey) :-
    earth_to_mars_plan(Simulation, _Request, Plan),
    simulate_hop(Simulation, Plan, Simulation1, hop_result(_, committed, _, _, _, _, _, simulated)),
    check_invariants(Simulation1, validation(ok, [])).

test(fictional_interstellar_hop) :-
    registered_traveller_simulation(bot(archive), Simulation),
    register_environment(Simulation, sample(fictional_exoplanet_env), Simulation1),
    create_hop(bot(archive), spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), spacetime(fictional_exoplanet, instant(2032, 3, 17, 14, 30)), [travel_mode(interstellar)], Request),
    validate_hop(Simulation1, Request, validation(error, Diagnostics)),
    member(diagnostic(warning, fictional_destination, _, _, _), Diagnostics).

test(universe_cycle_and_restore) :-
    universe_ready_simulation(Simulation, UniverseId, RootCheckpointId, StoreIds),
    project_simulant_backup(Simulation, projector_earth, bot(ada), StoreIds, quorum(1, 1), Simulation1, _),
    run_universe_cycles(Simulation1, UniverseId, [reset_to(checkpoint(RootCheckpointId))], [max_cycles(1)], Simulation2, universe_cycle_report(1, cycle(1), _, _, _, [_|_], max_cycles_reached, _)),
    restore_simulant_from_stores(Simulation2, bot(ada), StoreIds, spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), Simulation3, simulant_restored(bot(ada), _)),
    check_invariants(Simulation3, validation(ok, [])).

:- end_tests(integration).
