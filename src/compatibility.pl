:- module(compatibility, [
    environment_compatible/3
]).

:- use_module(travellers).
:- use_module(environments).

environment_compatible(Traveller, Environment, compatible) :-
    traveller_profile(Traveller, Embodiment, Requirements),
    available_embodiments(Environment, Embodiments),
    memberchk(Embodiment, Embodiments),
    requirements_satisfied(Requirements, Environment),
    !.
environment_compatible(Traveller, Environment, adaptable(Adaptations)) :-
    traveller_profile(Traveller, Embodiment, Requirements),
    available_embodiments(Environment, Embodiments),
    Embodiment \= software_runtime,
    memberchk(software_runtime, Embodiments),
    requirements_satisfied(Requirements, Environment),
    Adaptations = [embodiment_swap(software_runtime)],
    !.
environment_compatible(Traveller, Environment, adaptable(Adaptations)) :-
    traveller_profile(Traveller, Embodiment, _),
    available_embodiments(Environment, Embodiments),
    Embodiment \= software_runtime,
    member(Replacement, Embodiments),
    Replacement \= Embodiment,
    Adaptations = [embodiment_swap(Replacement)],
    !.
environment_compatible(Traveller, Environment, incompatible(Diagnostics)) :-
    traveller_profile(Traveller, Embodiment, Requirements),
    available_embodiments(Environment, Embodiments),
    environment_capabilities(Environment, Capabilities),
    findall(Reason, incompatibility_reason(Embodiment, Requirements, Embodiments, Capabilities, Reason), Diagnostics),
    Diagnostics \= [].

requirements_satisfied([], _).
requirements_satisfied([Requirement | Rest], Environment) :-
    requirement_satisfied(Requirement, Environment),
    requirements_satisfied(Rest, Environment).

requirement_satisfied(needs(software_runtime), Environment) :-
    environment_capabilities(Environment, Capabilities),
    memberchk(software_runtime, Capabilities).
requirement_satisfied(needs(human_representation_suite), Environment) :-
    available_embodiments(Environment, Embodiments),
    memberchk(human_representation_suite, Embodiments).
requirement_satisfied(protocol(Protocol), Environment) :-
    environment_capabilities(Environment, Capabilities),
    memberchk(protocol(Protocol), Capabilities).
requirement_satisfied(power_source(Source), Environment) :-
    environment_capabilities(Environment, Capabilities),
    memberchk(power_source(Source), Capabilities).

incompatibility_reason(Embodiment, _, Embodiments, _, unsupported_embodiment(Embodiment)) :-
    \+ memberchk(Embodiment, Embodiments),
    \+ memberchk(software_runtime, Embodiments).
incompatibility_reason(_, Requirements, _, Capabilities, missing_capability(Requirement)) :-
    member(Requirement, Requirements),
    \+ capability_matches_requirement(Capabilities, Requirement).

capability_matches_requirement(Capabilities, needs(software_runtime)) :-
    memberchk(software_runtime, Capabilities).
capability_matches_requirement(Capabilities, protocol(Protocol)) :-
    memberchk(protocol(Protocol), Capabilities).
capability_matches_requirement(Capabilities, power_source(Source)) :-
    memberchk(power_source(Source), Capabilities).
capability_matches_requirement(_, needs(human_representation_suite)) :-
    fail.

