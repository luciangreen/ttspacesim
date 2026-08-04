:- begin_tests(coordinates).

:- use_module('../src/clocks').
:- use_module('../src/coordinates').

test(valid_earth_date) :-
    valid_instant(instant(2026, 8, 4, 9, 0)).

test(invalid_date, [fail]) :-
    valid_instant(instant(2026, 2, 30, 9, 0)).

test(local_universal_round_trip_earth) :-
    instant_to_utime(instant(2026, 8, 4, 9, 0), UTime),
    universal_to_local(earth, UTime, local_time(earth, instant(2026, 8, 4, 9, 0, 0))).

test(mars_local_conversion_is_deterministic) :-
    local_to_universal(mars, local_time(mars, mars_date(2026, 10, 8, 30, 0)), UTime),
    universal_to_local(mars, UTime, LocalTime),
    LocalTime = local_time(mars, mars_date(_, _, _, _, _)).

test(time_ordering) :-
    canonical_spacetime(spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), main, Left),
    canonical_spacetime(spacetime(earth_lab, instant(2026, 8, 4, 10, 0)), main, Right),
    spacetime_order(Left, Right, (<)).

:- end_tests(coordinates).

