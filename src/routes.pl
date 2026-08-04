:- module(routes, [
    route_plan/5
]).

:- use_module(celestial_catalogue).

route_plan(Source, Destination, Mode, Duration, Resources) :-
    route_duration_for(Source, Destination, Mode, Duration),
    base_resources(Mode, Resources).

base_resources(conventional, [resource(fuel, 50), resource(compute, 5)]).
base_resources(compressed, [resource(fuel, 10), resource(compute, 10)]).
base_resources(checkpoint, [resource(storage, 5), resource(compute, 5)]).
base_resources(projected_future, [resource(compute, 8)]).
base_resources(historical_replay, [resource(compute, 4)]).
base_resources(timeline_branch, [resource(storage, 6), resource(compute, 6)]).
base_resources(branch_on_change, [resource(storage, 6), resource(compute, 6)]).
base_resources(narrative_instant, [resource(compute, 2)]).
base_resources(interstellar, [resource(compute, 20), resource(archive, 10)]).

route_duration_for(Source, Destination, Mode, Duration) :-
    celestial_catalogue:route_duration(Source, Destination, Mode, Duration),
    !.
route_duration_for(Source, Destination, Mode, seconds(600)) :-
    Mode \= conventional,
    celestial_catalogue:known_location(Source, _, _, _),
    celestial_catalogue:known_location(Destination, _, _, _).
