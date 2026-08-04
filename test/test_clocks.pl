:- begin_tests(clocks).

:- use_module('../src/clocks').

test(add_seconds) :-
    add_seconds(utime(2026, 8, 4, 9, 0, 0), 60, utime(2026, 8, 4, 9, 1, 0)).

test(utime_to_instant) :-
    utime_to_instant(utime(2026, 8, 4, 9, 0, 0), instant(2026, 8, 4, 9, 0, 0)).

:- end_tests(clocks).

