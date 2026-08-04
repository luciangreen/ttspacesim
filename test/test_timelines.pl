:- begin_tests(timelines).

:- use_module('../src/ttspacesim').
:- use_module(test_support).

test(branch_creation_and_comparison) :-
    earth_to_mars_plan(Simulation, _Request, Plan),
    simulate_hop(Simulation, Plan, Simulation1, _),
    compare_timelines(Simulation1, main, timeline_2, timeline_comparison(main, timeline_2, [_|_], [_|_])).

:- end_tests(timelines).
