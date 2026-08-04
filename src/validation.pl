:- module(validation, [
    check_invariants/2
]).

:- use_module(library(lists)).
:- use_module(diagnostics).
:- use_module(event_ledger).
:- use_module(ttspacesim, [verify_package_hash/2]).

check_invariants(Simulation, Validation) :-
    findall(Diagnostic, invariant_violation(Simulation, Diagnostic), Diagnostics),
    (   Diagnostics = []
    ->  ok_validation(Validation)
    ;   error_validation(Diagnostics, Validation)
    ).

invariant_violation(Simulation, diagnostic(error, unique_event_ids, "Event identifiers must be unique.", events, deduplicate_events)) :-
    event_ledger:event_ids(Simulation.events, EventIds),
    sort(EventIds, Unique),
    length(EventIds, Count),
    length(Unique, UniqueCount),
    Count =\= UniqueCount.
invariant_violation(Simulation, diagnostic(error, restored_instances_uniquely_identified, "Active traveller states must be unique per simulant.", travellers, branch_instance)) :-
    findall(Id, get_dict(Id, Simulation.traveller_states, traveller_state(Id, _, _, _, _, _, _, _, active)), Ids),
    sort(Ids, Unique),
    length(Ids, Count),
    length(Unique, UniqueCount),
    Count =\= UniqueCount.
invariant_violation(Simulation, diagnostic(error, package_hashes_valid, "All stored packages must have valid hashes.", packages, reseal_package)) :-
    get_dict(_, Simulation.packages, Package),
    verify_package_hash(Package, Result),
    Result == invalid.
