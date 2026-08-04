:- module(synthetic_crew_history_example, [run/0]).

:- use_module('../src/ttspacesim').

run :-
    new_simulation(memory_demo, S0),
    register_environment(S0, sample(earth_lab_env), S1),
    Traveller = traveller(bot(crew_ada), software_agent, crew_ada, initial, consent_not_applicable, simulated),
    register_traveller(S1, Traveller, S2),
    generate_memory_set(
        S2,
        bot(crew_ada),
        social_continuity,
        [event(check_in), event(handover)],
        spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
        MemorySet
    ),
    writeln(MemorySet).

