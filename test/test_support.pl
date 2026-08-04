:- module(test_support, [
    base_simulation/1,
    registered_traveller_simulation/2,
    earth_to_mars_plan/3,
    store_checkpoint/3,
    universe_ready_simulation/4
]).

:- use_module('../src/ttspacesim').

base_simulation(Simulation) :-
    new_simulation(test_simulation, S0),
    put_dict(current_time, S0, utime(2026, 8, 4, 9, 0, 0), S00),
    register_environment(S00, sample(earth_lab_env), S1),
    register_environment(S1, sample(mars_habitat_env), S2),
    register_environment(S2, sample(lunar_base_env), S3),
    register_environment(S3, sample(mars_archive_env), S4),
    register_environment(S4, sample(interstellar_archive_env), Simulation).

registered_traveller_simulation(TravellerId, Simulation) :-
    base_simulation(S0),
    Traveller = traveller(TravellerId, software_agent, TravellerId, initial, consent_not_applicable, simulated),
    register_traveller(S0, Traveller, Simulation).

earth_to_mars_plan(Simulation, Request, Plan) :-
    registered_traveller_simulation(bot(ada), Simulation),
    create_hop(
        bot(ada),
        spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
        spacetime(mars_habitat, instant(2032, 3, 17, 14, 30)),
        [travel_mode(compressed), memory_policy(causal_minimum), timeline_policy(branch_on_change)],
        Request
    ),
    plan_hop(Simulation, Request, Plan).

store_checkpoint(Simulation0, Checkpoint, Simulation) :-
    Checkpoint = checkpoint(CheckpointId, _, _, _, _, _, _),
    put_dict(CheckpointId, Simulation0.checkpoints, Checkpoint, Checkpoints),
    put_dict(checkpoints, Simulation0, Checkpoints, Simulation).

universe_ready_simulation(Simulation, UniverseId, RootCheckpointId, StoreIds) :-
    registered_traveller_simulation(bot(ada), S0),
    TravellerB = traveller(bot(turing), software_agent, turing, initial, consent_not_applicable, simulated),
    register_traveller(S0, TravellerB, S1),
    create_checkpoint(S1, origin_seed, Checkpoint),
    store_checkpoint(S1, Checkpoint, S2),
    Checkpoint = checkpoint(RootCheckpointId, _, _, _, _, _, _),
    UniverseId = universe_alpha,
    create_universe(S2, UniverseId, RootCheckpointId, [], S3, _),
    Projectors = [
        bot_projector(projector_earth, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), near_system, [archive_store], standard, budget(normal), active, simulated),
        bot_projector(projector_mars, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), near_system, [archive_store], standard, budget(normal), active, simulated),
        bot_projector(projector_luna, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), near_system, [archive_store], standard, budget(normal), active, simulated)
    ],
    register_projector_terms(S3, Projectors, S4),
    project_three_stores(S4, Simulation, StoreIds).

register_projector_terms(Simulation, [], Simulation).
register_projector_terms(Simulation0, [Projector | Rest], Simulation) :-
    register_bot_projector(Simulation0, Projector, Simulation1, _),
    register_projector_terms(Simulation1, Rest, Simulation).

project_three_stores(Simulation0, Simulation, [StoreEarth, StoreMars, StoreLuna]) :-
    plan_store_projection(Simulation0, projector_earth, spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), [template(archive_store)], PlanEarth),
    execute_store_projection(Simulation0, PlanEarth, S1, store_projected(StoreEarth, _, _)),
    plan_store_projection(S1, projector_mars, spacetime(mars_archive, instant(2032, 3, 17, 14, 30)), [template(archive_store)], PlanMars),
    execute_store_projection(S1, PlanMars, S2, store_projected(StoreMars, _, _)),
    plan_store_projection(S2, projector_luna, spacetime(lunar_base, instant(2026, 8, 4, 12, 0)), [template(archive_store)], PlanLuna),
    execute_store_projection(S2, PlanLuna, Simulation, store_projected(StoreLuna, _, _)).
