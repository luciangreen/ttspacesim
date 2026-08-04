:- module(lunar_time_branch_example, [run/0]).

:- use_module('../src/ttspacesim').

run :-
    new_simulation(lunar_branch_demo, S0),
    put_dict(current_time, S0, utime(2026, 8, 4, 9, 0, 0), S00),
    register_environment(S00, sample(lunar_base_env), S1),
    Traveller = traveller(bot(selene), software_agent, selene, initial, consent_not_applicable, simulated),
    register_traveller(S1, Traveller, S2),
    create_hop(
        bot(selene),
        spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
        spacetime(lunar_base, instant(2026, 8, 4, 7, 0)),
        [travel_mode(historical_replay), timeline_policy(branch_on_change)],
        Request
    ),
    plan_hop(S2, Request, Plan),
    simulate_hop(S2, Plan, S3, Result),
    compare_timelines(S3, main, timeline_2, Comparison),
    writeln(Result),
    writeln(Comparison).

