:- module(travellers, [
    traveller_id/2,
    traveller_type/2,
    traveller_identity/2,
    traveller_reality_label/2,
    traveller_default_embodiment/2,
    traveller_profile/3
]).

traveller_id(traveller(Id, _, _, _, _, _), Id).
traveller_type(traveller(_, Type, _, _, _, _), Type).
traveller_identity(traveller(_, _, Identity, _, _, _), Identity).
traveller_reality_label(traveller(_, _, _, _, _, Label), Label).

traveller_default_embodiment(software_agent, software_runtime).
traveller_default_embodiment(robot, earth_lab_robot).
traveller_default_embodiment(avatar, software_runtime).
traveller_default_embodiment(fictional_character, software_runtime).
traveller_default_embodiment(abstract_mission_role, software_runtime).
traveller_default_embodiment(consenting_human_representation, human_representation_suite).

traveller_profile(Traveller, Embodiment, Requirements) :-
    Traveller = traveller(_, Type, _, CurrentState, _, _),
    traveller_default_embodiment(Type, DefaultEmbodiment),
    (   CurrentState = traveller_state(_, _, StateEmbodiment, _, _, _, _, _, _)
    ->  Embodiment = StateEmbodiment
    ;   Embodiment = DefaultEmbodiment
    ),
    default_requirements(Type, DefaultRequirements),
    (   CurrentState = state_profile(ProfileRequirements)
    ->  Requirements = ProfileRequirements
    ;   Requirements = DefaultRequirements
    ).

default_requirements(software_agent, [needs(software_runtime), protocol(relay)]).
default_requirements(robot, [power_source(grid), protocol(relay)]).
default_requirements(avatar, [needs(software_runtime), protocol(relay)]).
default_requirements(fictional_character, [needs(software_runtime), protocol(relay)]).
default_requirements(abstract_mission_role, [needs(software_runtime)]).
default_requirements(consenting_human_representation, [needs(human_representation_suite), protocol(relay)]).

