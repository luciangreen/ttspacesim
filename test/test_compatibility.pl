:- begin_tests(compatibility).

:- use_module('../src/compatibility').
:- use_module('../src/environments').

test(compatible_software_agent) :-
    Traveller = traveller(bot(ada), software_agent, ada, initial, consent_not_applicable, simulated),
    sample_environment(mars_habitat_env, Environment),
    environment_compatible(Traveller, Environment, compatible).

test(adaptation_required) :-
    Traveller = traveller(bot(rover), robot, rover, initial, consent_not_applicable, simulated),
    sample_environment(mars_habitat_env, Environment),
    environment_compatible(Traveller, Environment, adaptable([embodiment_swap(_)])).

test(incompatible_embodiment) :-
    Traveller = traveller(bot(ada), software_agent, ada, initial, consent_not_applicable, simulated),
    Environment = environment(mars_habitat_env, mars_habitat, vacuum, gravity(martian), celsius(-50, -10), radiation(high), pressure(low), [], [], [], simulated),
    environment_compatible(Traveller, Environment, incompatible([_|_])).

:- end_tests(compatibility).

