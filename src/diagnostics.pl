:- module(diagnostics, [
    diagnostic/5,
    ok_validation/1,
    warning_validation/2,
    error_validation/2,
    validation_diagnostics/2,
    validation_has_errors/1,
    diagnostics_summary/2
]).

diagnostic(Level, Code, Message, Context, Suggestion) :-
    nonvar(Level),
    nonvar(Code),
    nonvar(Message),
    nonvar(Context),
    nonvar(Suggestion).

ok_validation(validation(ok, [])).

warning_validation(Diagnostic, validation(ok, [Diagnostic])).

error_validation(Diagnostics, validation(error, Normalised)) :-
    (   is_list(Diagnostics)
    ->  Normalised = Diagnostics
    ;   Normalised = [Diagnostics]
    ).

validation_diagnostics(validation(_, Diagnostics), Diagnostics).

validation_has_errors(validation(error, Diagnostics)) :-
    Diagnostics \= [].

diagnostics_summary(Diagnostics, Summary) :-
    maplist(diagnostic_code, Diagnostics, Codes),
    Summary = diagnostics_summary(Codes).

diagnostic_code(diagnostic(_, Code, _, _, _), Code).
