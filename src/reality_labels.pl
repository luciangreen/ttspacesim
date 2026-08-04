:- module(reality_labels, [
    valid_reality_label/1,
    ensure_reality_label/2,
    synthetic_memory_label/1
]).

valid_reality_label(real).
valid_reality_label(scheduled).
valid_reality_label(simulated).
valid_reality_label(fictional).
valid_reality_label(projected).
valid_reality_label(provisional).
valid_reality_label(synthetic).
valid_reality_label(archived).
valid_reality_label(counterfactual).

ensure_reality_label(Label, Label) :-
    valid_reality_label(Label),
    !.
ensure_reality_label(_, simulated).

synthetic_memory_label(memory_reality(synthetic)).

