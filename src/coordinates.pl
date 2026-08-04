:- module(coordinates, [
    canonical_spacetime/3,
    spacetime_order/3
]).

:- use_module(clocks).
:- use_module(celestial_catalogue).

canonical_spacetime(spacetime(Location, instant(Year, Month, Day, Hour, Minute)), Timeline, spacetime(Location, UTime, LocalTime, timeline(Timeline))) :-
    !,
    instant_to_utime(instant(Year, Month, Day, Hour, Minute), UTime),
    celestial_catalogue:location_world(Location, World),
    universal_to_local(World, UTime, LocalTime).
canonical_spacetime(spacetime(Location, instant(Year, Month, Day, Hour, Minute, Second)), Timeline, spacetime(Location, UTime, LocalTime, timeline(Timeline))) :-
    !,
    instant_to_utime(instant(Year, Month, Day, Hour, Minute, Second), UTime),
    celestial_catalogue:location_world(Location, World),
    universal_to_local(World, UTime, LocalTime).
canonical_spacetime(spacetime(Location, UTime, LocalTime, timeline(Timeline)), _, spacetime(Location, UTime, LocalTime, timeline(Timeline))) :-
    !.
canonical_spacetime(spacetime(Location, UTime, LocalTime, Timeline), _, spacetime(Location, UTime, LocalTime, Timeline)) :-
    Timeline = timeline(_),
    !.

spacetime_order(Left, Right, Ordering) :-
    Left = spacetime(_, LUTime, _, _),
    Right = spacetime(_, RUTime, _, _),
    compare_utime(LUTime, RUTime, Ordering).

