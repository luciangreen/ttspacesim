:- module(cyclic_universe_archive_example, [run/0]).

:- use_module('../src/ttspacesim').

store_checkpoint(Simulation0, Checkpoint, Simulation) :-
    Checkpoint = checkpoint(CheckpointId, _, _, _, _, _, _),
    put_dict(CheckpointId, Simulation0.checkpoints, Checkpoint, Checkpoints),
    put_dict(checkpoints, Simulation0, Checkpoints, Simulation).

register_projectors(Simulation0, [], Simulation0, []).
register_projectors(Simulation0, [Projector | Rest], Simulation, [ProjectorId | ProjectorIds]) :-
    Projector = bot_projector(ProjectorId, _, _, _, _, _, _, _, _, _),
    register_bot_projector(Simulation0, Projector, Simulation1, _),
    register_projectors(Simulation1, Rest, Simulation, ProjectorIds).

project_many_stores(Simulation0, _ProjectorIds, [], Simulation0, []).
project_many_stores(Simulation0, [ProjectorId | ProjectorIds], [Destination | Rest], Simulation, [StoreId | StoreIds]) :-
    plan_store_projection(Simulation0, ProjectorId, Destination, [template(archive_store)], Plan),
    execute_store_projection(Simulation0, Plan, Simulation1, store_projected(StoreId, _, _)),
    project_many_stores(Simulation1, ProjectorIds, Rest, Simulation, StoreIds).

run :-
    new_simulation(cycle_demo, S0),
    put_dict(current_time, S0, utime(2026, 8, 4, 9, 0, 0), S00),
    register_environment(S00, sample(earth_lab_env), S1),
    register_environment(S1, sample(mars_archive_env), S2),
    register_environment(S2, sample(lunar_base_env), S3),
    register_environment(S3, sample(asteroid_archive_env), S4),
    register_environment(S4, sample(interstellar_archive_env), S5),
    TravellerA = traveller(bot(ada), software_agent, ada, initial, consent_not_applicable, simulated),
    TravellerB = traveller(bot(turing), software_agent, turing, initial, consent_not_applicable, simulated),
    register_traveller(S5, TravellerA, S6),
    register_traveller(S6, TravellerB, S7),
    create_checkpoint(S7, origin_seed, RootCheckpoint),
    store_checkpoint(S7, RootCheckpoint, S8),
    RootCheckpoint = checkpoint(RootCheckpointId, _, _, _, _, _, _),
    create_universe(S8, universe_alpha, RootCheckpointId, [], S9, _Universe),
    Projectors = [
        bot_projector(projector_earth, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), near_system, [archive_store], standard, budget(normal), active, simulated),
        bot_projector(projector_mars, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), near_system, [archive_store], standard, budget(normal), active, simulated),
        bot_projector(projector_luna, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), near_system, [archive_store], standard, budget(normal), active, simulated),
        bot_projector(projector_asteroid, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), deep_archive, [archive_store], standard, budget(normal), active, simulated),
        bot_projector(projector_interstellar, controller(system), [project_store, verify_store, repair_store, reconstruct_store], spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), fictional_relay, [archive_store], standard, budget(normal), active, simulated)
    ],
    register_projectors(S9, Projectors, S10, ProjectorIds),
    Destinations = [
        spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
        spacetime(mars_archive, instant(2032, 3, 17, 14, 30)),
        spacetime(lunar_base, instant(2026, 8, 4, 12, 0)),
        spacetime(asteroid_archive, instant(2032, 3, 18, 12, 0)),
        spacetime(interstellar_archive, instant(2032, 3, 19, 12, 0))
    ],
    project_many_stores(S10, ProjectorIds, Destinations, S11, StoreIds),
    project_simulant_backup(S11, projector_earth, bot(ada), StoreIds, quorum(3, 5), S12, _),
    project_simulant_backup(S12, projector_earth, bot(turing), StoreIds, quorum(3, 5), S13, _),
    run_universe_cycles(S13, universe_alpha, [reset_to(checkpoint(RootCheckpointId))], [max_cycles(1)], S14, CycleReport),
    StoreIds = [FirstStore | _],
    simulate_store_failure(S14, FirstStore, communication_loss, S15, _),
    verify_projected_store(S15, FirstStore, Verification),
    restore_simulant_from_stores(S15, bot(ada), StoreIds, spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), S16, RestoreAda),
    restore_simulant_from_stores(S16, bot(turing), StoreIds, spacetime(earth_lab, instant(2026, 8, 4, 9, 0)), _S17, RestoreTuring),
    writeln(CycleReport),
    writeln(Verification),
    writeln(RestoreAda),
    writeln(RestoreTuring),
    writeln('Universe cycling is simulated through repeated finite checkpoints.'),
    writeln('Projected stores are independent simulation objects.'),
    writeln('No physical universe reset, literal infinity, consciousness transfer,'),
    writeln('or real interstellar data projection is claimed.').
