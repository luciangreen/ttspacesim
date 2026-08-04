:- module(causality, [
    validate_causal_graph/2,
    causal_path/4,
    affected_events/3,
    stable_event_order/2
]).

:- use_module(library(lists)).
:- use_module(diagnostics).

validate_causal_graph(Events, Validation) :-
    findall(
        Diagnostic,
        causal_diagnostic(Events, Diagnostic),
        Diagnostics
    ),
    (   Diagnostics = []
    ->  ok_validation(Validation)
    ;   error_validation(Diagnostics, Validation)
    ).

causal_path(Events, From, To, Path) :-
    causal_edges(Events, Edges),
    path(Edges, From, To, [From], ReversePath),
    reverse(ReversePath, Path).

affected_events(Events, EventId, Affected) :-
    causal_edges(Events, Edges),
    findall(Target, reachable(Edges, EventId, Target), Targets),
    sort(Targets, Affected).

stable_event_order(Events, OrderedIds) :-
    findall(EventId, member(event(EventId, _, _, _, _, _, _, _, _), Events), EventIds),
    sort(EventIds, OrderedIds).

causal_diagnostic(Events, diagnostic(error, missing_dependency, "An event references a missing dependency.", event(EventId), add_dependency)) :-
    member(event(EventId, _, _, _, Causes, _, _, _, _), Events),
    member(cause(DependencyId), Causes),
    \+ member(event(DependencyId, _, _, _, _, _, _, _, _), Events).
causal_diagnostic(Events, diagnostic(error, causal_cycle, "The causal graph contains a cycle.", ledger, branch_timeline)) :-
    causal_edges(Events, Edges),
    member(Source-Target, Edges),
    path(Edges, Target, Source, [Target], _).

causal_edges(Events, Edges) :-
    findall(
        DependencyId-EventId,
        (
            member(event(EventId, _, _, _, Causes, _, _, _, _), Events),
            member(cause(DependencyId), Causes)
        ),
        Edges
    ).

reachable(Edges, Source, Target) :-
    path(Edges, Source, Target, [Source], _),
    Source \= Target.

path(_Edges, Node, Node, Visited, Visited).
path(Edges, From, To, Visited0, Path) :-
    member(From-Next, Edges),
    \+ memberchk(Next, Visited0),
    path(Edges, Next, To, [Next | Visited0], Path).

