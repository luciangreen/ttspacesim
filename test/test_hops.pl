:- begin_tests(hops).

:- use_module('../src/ttspacesim').
:- use_module(test_support).

test(compressed_earth_to_mars_plan) :-
    earth_to_mars_plan(Simulation, Request, Plan),
    validate_hop(Simulation, Request, validation(ok, [])),
    Plan = hop_plan(_, bot(ada), _, _, compressed, _, _, _, seconds(120), _, _, simulated).

test(past_time_branch_plan) :-
    registered_traveller_simulation(bot(selene), Simulation),
    create_hop(
        bot(selene),
        spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
        spacetime(lunar_base, instant(2026, 8, 4, 7, 0)),
        [travel_mode(historical_replay), timeline_policy(branch_on_change)],
        Request
    ),
    plan_hop(Simulation, Request, hop_plan(_, _, _, spacetime(_, _, _, timeline(timeline_2)), _, branch_on_change, _, _, _, _, [create_timeline(timeline_2, main, branch_from_past)], _)).

test(unknown_destination_validation) :-
    registered_traveller_simulation(bot(ada), Simulation),
    create_hop(bot(ada), spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), spacetime(unknown_place, instant(2032, 3, 17, 14, 30)), [], Request),
    validate_hop(Simulation, Request, validation(error, Diagnostics)),
    member(diagnostic(error, unknown_destination, _, _, _), Diagnostics).

test(incompatible_destination_validation) :-
    new_simulation(test_incompatible, S0),
    put_dict(current_time, S0, utime(2026, 8, 4, 9, 0, 0), S00),
    BadMars = environment(mars_habitat_env, mars_habitat, vacuum, gravity(martian), celsius(-50, -10), radiation(high), pressure(low), [], [], [], simulated),
    register_environment(S00, BadMars, S1),
    register_environment(S1, sample(earth_lab_env), S2),
    Traveller = traveller(bot(ada), software_agent, ada, initial, consent_not_applicable, simulated),
    register_traveller(S2, Traveller, S3),
    create_hop(bot(ada), spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), spacetime(mars_habitat, instant(2032, 3, 17, 14, 30)), [], Request),
    validate_hop(S3, Request, validation(error, Diagnostics)),
    member(diagnostic(error, incompatible_destination, _, _, _), Diagnostics).

test(simulate_hop_commits) :-
    earth_to_mars_plan(Simulation, _Request, Plan),
    simulate_hop(Simulation, Plan, Simulation1, hop_result(_, committed, _, spacetime(mars_habitat, _, _, timeline(timeline_2)), _, _, _, simulated)),
    Simulation1.current_timeline = timeline_2.

:- end_tests(hops).

