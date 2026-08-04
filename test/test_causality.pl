:- begin_tests(causality).

:- use_module('../src/causality').

test(causal_path) :-
    Events = [
        event(e3, arrived, [], nowhere, [cause(e2)], [], simulated, none, generated_by(ttspacesim)),
        event(e2, launched, [], nowhere, [cause(e1)], [], simulated, none, generated_by(ttspacesim)),
        event(e1, prepared, [], nowhere, [], [], simulated, none, generated_by(ttspacesim))
    ],
    causal_path(Events, e1, e3, [e1, e2, e3]).

test(missing_dependency) :-
    Events = [
        event(e2, launched, [], nowhere, [cause(e_missing)], [], simulated, none, generated_by(ttspacesim))
    ],
    validate_causal_graph(Events, validation(error, Diagnostics)),
    member(diagnostic(error, missing_dependency, _, _, _), Diagnostics).

test(cycle_detection) :-
    Events = [
        event(e1, a, [], nowhere, [cause(e2)], [], simulated, none, generated_by(ttspacesim)),
        event(e2, b, [], nowhere, [cause(e1)], [], simulated, none, generated_by(ttspacesim))
    ],
    validate_causal_graph(Events, validation(error, Diagnostics)),
    member(diagnostic(error, causal_cycle, _, _, _), Diagnostics).

:- end_tests(causality).

