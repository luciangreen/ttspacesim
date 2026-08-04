:- module(schedules, [
    detect_schedule_conflicts/2
]).

:- use_module(coordinates).

detect_schedule_conflicts(Events, Diagnostics) :-
    findall(
        diagnostic(error, schedule_conflict, "Overlapping immovable mission events.", conflict(EventA, EventB), reschedule_required),
        conflicting_pair(Events, EventA, EventB),
        Diagnostics
    ).

conflicting_pair(Events, EventA, EventB) :-
    select(EventA, Events, Rest),
    member(EventB, Rest),
    EventA = scheduled_event(IdA, StartA, EndA, immovable, _),
    EventB = scheduled_event(IdB, StartB, EndB, immovable, _),
    IdA @< IdB,
    overlaps(StartA, EndA, StartB, EndB).

overlaps(StartA, EndA, StartB, EndB) :-
    coordinates:spacetime_order(StartA, EndB, (<)),
    coordinates:spacetime_order(StartB, EndA, (<)).

