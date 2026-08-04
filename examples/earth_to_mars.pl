:- module(earth_to_mars_example, [run/0]).

:- use_module('../src/ttspacesim').

run :-
    new_simulation(earth_to_mars_demo, S0),
    put_dict(current_time, S0, utime(2026, 8, 4, 9, 0, 0), S00),
    register_environment(S00, sample(earth_lab_env), S1),
    register_environment(S1, sample(mars_habitat_env), S2),
    create_mission(mars_research_01, Mission),
    step(S2, add_mission(Mission), S3, _),
    Traveller = traveller(bot(ada), software_agent, ada, initial, consent_not_applicable, simulated),
    register_traveller(S3, Traveller, S4),
    create_hop(
        bot(ada),
        spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
        spacetime(mars_habitat, instant(2032, 3, 17, 14, 30)),
        [travel_mode(compressed), memory_policy(causal_minimum), timeline_policy(branch_on_change)],
        Request
    ),
    plan_hop(S4, Request, Plan),
    generate_memory_set(S4, bot(ada), causal_minimum, [], spacetime(mars_habitat, instant(2032, 3, 17, 14, 30)), MemorySet),
    simulate_hop(S4, Plan, S5, Result),
    continuity_report(S5, bot(ada), spacetime(mars_habitat, instant(2032, 3, 17, 14, 30)), MemorySet, Report),
    writeln(Mission),
    writeln(Plan),
    writeln(Result),
    writeln(Report),
    writeln('Reality: simulated').

