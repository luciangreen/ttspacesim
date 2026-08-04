:- module(celestial_catalogue, [
    celestial_body/3,
    known_location/4,
    location_world/2,
    location_environment/2,
    fictional_location/1,
    route_duration/4
]).

:- use_module('../data/celestial_bodies', [
    location_fact/5,
    route_fact/4
]).

celestial_body(Name, Type, RealityLabel) :-
    data_celestial_bodies:celestial_body(Name, Type, RealityLabel).

known_location(Location, Shape, World, RealityLabel) :-
    data_celestial_bodies:location_fact(Location, Shape, World, _, RealityLabel).

location_world(Location, World) :-
    data_celestial_bodies:location_fact(Location, _, World, _, _).

location_environment(Location, EnvironmentId) :-
    data_celestial_bodies:location_fact(Location, _, _, EnvironmentId, _).

fictional_location(Location) :-
    data_celestial_bodies:location_fact(Location, _, _, _, fictional).

route_duration(Source, Destination, Mode, Duration) :-
    data_celestial_bodies:route_fact(Source, Destination, Mode, Duration),
    !.
route_duration(Source, Destination, conventional, seconds(600)) :-
    known_location(Source, _, _, _),
    known_location(Destination, _, _, _).
