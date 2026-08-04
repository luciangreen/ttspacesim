:- module(event_ledger, [
    event_ids/2
]).

event_ids(Events, EventIds) :-
    findall(EventId, member(event(EventId, _, _, _, _, _, _, _, _), Events), EventIds).

