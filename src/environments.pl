:- module(environments, [
    sample_environment/2,
    environment_by_location/2,
    available_embodiments/2,
    environment_capabilities/2,
    environment_resources/2
]).

:- use_module('../data/environments').

sample_environment(EnvironmentId, Environment) :-
    data_environments:sample_environment(Environment),
    Environment = environment(EnvironmentId, _, _, _, _, _, _, _, _, _, _).

environment_by_location(Location, Environment) :-
    data_environments:sample_environment(Environment),
    Environment = environment(_, Location, _, _, _, _, _, _, _, _, _),
    !.

available_embodiments(environment(_, _, _, _, _, _, _, Embodiments, _, _, _), Embodiments).
environment_capabilities(environment(_, _, _, _, _, _, _, _, _, Capabilities, _), Capabilities).
environment_resources(environment(_, _, _, _, _, _, _, _, Resources, _, _), Resources).

