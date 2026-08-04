:- begin_tests(consent).

:- use_module('../src/consent').

test(valid_consent) :-
    Consent = consent(ada, simulation, utime(2026, 1, 1, 0, 0, 0), utime(2026, 12, 31, 23, 59, 59), active, simulated),
    consent_record_valid(Consent, utime(2026, 8, 4, 9, 0, 0)),
    consent_allows(Consent, simulation, true).

test(revoked_consent) :-
    Consent = consent(ada, simulation, utime(2026, 1, 1, 0, 0, 0), utime(2026, 12, 31, 23, 59, 59), revoked, simulated),
    consent_allows(Consent, simulation, false).

test(fictional_replacement) :-
    fictional_replacement(ada, fictional_subject(ada)).

:- end_tests(consent).

