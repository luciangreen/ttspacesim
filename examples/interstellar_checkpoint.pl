:- module(interstellar_checkpoint_example, [run/0]).

:- use_module('../src/ttspacesim').

run :-
    new_simulation(interstellar_demo, S0),
    put_dict(current_time, S0, utime(2026, 8, 4, 9, 0, 0), S00),
    register_environment(S00, sample(earth_lab_env), S1),
    register_environment(S1, sample(fictional_exoplanet_env), S2),
    Traveller = traveller(bot(archive), software_agent, archive, initial, consent_not_applicable, simulated),
    register_traveller(S2, Traveller, S3),
    create_hop(
        bot(archive),
        spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
        spacetime(fictional_exoplanet, instant(2032, 3, 17, 14, 30)),
        [travel_mode(interstellar), memory_policy(causal_minimum)],
        Request
    ),
    validate_hop(S3, Request, Validation),
    writeln(Validation),
    (   plan_hop(S3, Request, Plan)
    ->  writeln(Plan)
    ;   writeln(plan_unavailable)
    ),
    writeln('Reality: fictional simulation'),
    writeln('No claim of real interstellar travel is made.').
