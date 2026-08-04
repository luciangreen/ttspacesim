:- module(consent, [
    consent_record_valid/2,
    consent_allows/3,
    fictional_replacement/2
]).

:- use_module(clocks).

consent_record_valid(consent(_Subject, _Purpose, From, To, active, _RealityLabel), AtTime) :-
    compare_utime(From, AtTime, Ordering1),
    memberchk(Ordering1, [<, =]),
    compare_utime(AtTime, To, Ordering2),
    memberchk(Ordering2, [<, =]).

consent_allows(consent(_Subject, Purpose, _From, _To, active, _RealityLabel), Purpose, true).
consent_allows(consent(_Subject, _Purpose, _From, _To, revoked, _RealityLabel), _RequestedPurpose, false).
consent_allows(_, _, false).

fictional_replacement(Subject, fictional_subject(Subject)).
