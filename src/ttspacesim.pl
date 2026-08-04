:- module(ttspacesim, [
    new_simulation/2,
    step/4,
    run_demo/0,
    create_mission/2,
    create_mission/3,
    register_traveller/3,
    register_environment/3,
    create_hop/5,
    validate_hop/3,
    plan_hop/3,
    plan_hop/5,
    simulate_hop/3,
    simulate_hop/4,
    create_timeline/6,
    compare_timelines/4,
    create_checkpoint/3,
    restore_checkpoint/2,
    generate_memory_set/6,
    validate_memory_set/4,
    continuity_report/5,
    environment_compatible/3,
    save_simulation/2,
    load_simulation/2,
    explain_result/2,
    promote_to_real_action/3,
    create_universe/6,
    prepare_universe_reset/5,
    validate_universe_reset/3,
    execute_universe_reset/4,
    explain_universe_reset/2,
    register_bot_projector/4,
    plan_store_projection/5,
    execute_store_projection/4,
    project_simulant_backup/7,
    verify_projected_store/3,
    restore_simulant_from_stores/6,
    create_simulant_package/4,
    seal_simulant_package/2,
    store_package/5,
    replicate_package/5,
    compare_simulant_packages/3,
    hash_package/2,
    verify_package_hash/2,
    verify_package_provenance/2,
    plan_simulant_restore/6,
    validate_simulant_restore/3,
    execute_simulant_restore/4,
    detect_simulant_instances/3,
    simulate_store_failure/5,
    repair_projected_store/5,
    reconstruct_projected_store/5,
    project_store_across_universe/6,
    prepare_cycle_preservation/4,
    restore_cycle_survivors/4,
    run_projector_cycle/5,
    run_universe_cycles/6
]).

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(error)).
:- use_module(library(readutil)).
:- use_module(diagnostics).
:- use_module(reality_labels).
:- use_module(clocks).
:- use_module(coordinates).
:- use_module(celestial_catalogue).
:- use_module(environments).
:- use_module(travellers).
:- use_module(compatibility, []).
:- use_module(schedules).
:- use_module(routes).
:- use_module('../data/example_missions').

new_simulation(Id, Simulation) :-
    Simulation = simulation{
        id: Id,
        title: "TTSpaceSim",
        root_timeline: main,
        current_timeline: main,
        current_time: utime(2026, 1, 1, 0, 0, 0),
        reality_label: simulated,
        status: active,
        metadata: [seed(42)],
        travellers: _{},
        traveller_states: _{},
        environments: _{},
        missions: _{},
        timelines: _{main: timeline_state(main, none, root, [], simulated)},
        hops: _{},
        events: [],
        checkpoints: _{},
        memory_sets: _{},
        consents: _{},
        approvals: _{},
        projectors: _{},
        stores: _{},
        packages: _{},
        universes: _{},
        pending_resets: _{},
        pending_preservations: _{},
        counters: _{
            event: 0,
            hop: 0,
            checkpoint: 0,
            memory: 0,
            timeline: 0,
            reset: 0,
            cycle: 0,
            package: 0,
            store: 0,
            projection: 0,
            projector: 0,
            preservation: 0,
            restore: 0
        }
    }.

run_demo :-
    new_simulation(space_demo, Simulation),
    write_term(simulation_started(Simulation.id, Simulation.reality_label), [quoted(true)]),
    nl.

step(Simulation0, register_traveller(Traveller), Simulation, traveller_registered(TravellerId)) :-
    register_traveller(Simulation0, Traveller, Simulation),
    travellers:traveller_id(Traveller, TravellerId).
step(Simulation0, add_environment(EnvironmentSpec), Simulation, environment_registered(EnvironmentId)) :-
    register_environment(Simulation0, EnvironmentSpec, Simulation),
    environment_id_from_spec(EnvironmentSpec, EnvironmentId).
step(Simulation0, add_mission(Mission), Simulation, mission_registered(MissionId)) :-
    Mission = mission(MissionId, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, missions, MissionId, Mission, Simulation).
step(Simulation0, plan_hop(Request), Simulation, Result) :-
    plan_hop(Simulation0, Request, Plan),
    store_hop_plan(Simulation0, Plan, Simulation),
    plan_summary(Plan, Result).
step(Simulation0, simulate_hop(Plan), Simulation, Result) :-
    simulate_hop(Simulation0, Plan, Simulation, Result).
step(Simulation0, prepare_universe_reset(UniverseId, Target, Options), Simulation, reset_prepared(ResetId)) :-
    prepare_universe_reset(Simulation0, UniverseId, Target, Options, ResetPlan),
    ResetPlan = universe_reset_plan(ResetId, _, _, _, _, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, pending_resets, ResetId, ResetPlan, Simulation).
step(Simulation0, execute_universe_reset(ResetId), Simulation, Result) :-
    get_sim_dict(Simulation0, pending_resets, ResetId, ResetPlan),
    execute_universe_reset(Simulation0, ResetPlan, Simulation, Result).
step(Simulation0, run_universe_cycle(UniverseId, Policy), Simulation, Report) :-
    run_universe_cycles(Simulation0, UniverseId, Policy, [max_cycles(1)], Simulation, Report).
step(Simulation0, create_simulant_backup(SimulantId, Scope), Simulation, package_created(PackageId)) :-
    create_simulant_package(Simulation0, SimulantId, Scope, Package0),
    seal_simulant_package(Package0, Package),
    Package = simulant_package(PackageId, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, packages, PackageId, Package, Simulation).
step(Simulation0, register_bot_projector(Projector), Simulation, Result) :-
    register_bot_projector(Simulation0, Projector, Simulation, Result).
step(Simulation0, project_store(ProjectorId, Destination, Options), Simulation, Result) :-
    plan_store_projection(Simulation0, ProjectorId, Destination, Options, ProjectionPlan),
    execute_store_projection(Simulation0, ProjectionPlan, Simulation, Result).
step(Simulation0, project_backup(ProjectorId, SimulantId, Stores, Policy), Simulation, Result) :-
    project_simulant_backup(Simulation0, ProjectorId, SimulantId, Stores, Policy, Simulation, Result).
step(Simulation, verify_store(StoreId), Simulation, Verification) :-
    verify_projected_store(Simulation, StoreId, Verification).
step(Simulation0, repair_store(ProjectorId, StoreId, Policy), Simulation, Result) :-
    repair_projected_store(Simulation0, ProjectorId, StoreId, Policy, Simulation, Result).
step(Simulation0, restore_simulant(SimulantId, Stores, Destination, Options), Simulation, Result) :-
    restore_simulant_from_stores(Simulation0, SimulantId, Stores, Destination, Options, Simulation, Result).
step(Simulation0, prepare_cycle_preservation(UniverseId, ResetId), Simulation, preservation_prepared(PreservationId)) :-
    get_sim_dict(Simulation0, pending_resets, ResetId, ResetPlan),
    prepare_cycle_preservation(Simulation0, UniverseId, ResetPlan, PreservationPlan),
    PreservationPlan = cycle_preservation_plan(PreservationId, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, pending_preservations, PreservationId, PreservationPlan, Simulation).
step(Simulation0, restore_cycle_survivors(PreservationId), Simulation, Report) :-
    get_sim_dict(Simulation0, pending_preservations, PreservationId, PreservationPlan),
    restore_cycle_survivors(Simulation0, PreservationPlan, Simulation, Report).

create_mission(MissionId, Mission) :-
    (   data_example_missions:example_mission(MissionId, Mission)
    ->  true
    ;   create_mission(MissionId, [], Mission)
    ).

create_mission(MissionId, Options, mission(MissionId, Name, Objectives, Participants, Start, End, Schedule, Constraints, RealityLabel, draft)) :-
    option_or_default(name, Options, "Mission", Name),
    option_or_default(objectives, Options, [], Objectives),
    option_or_default(participants, Options, [], Participants),
    option_or_default(start, Options, spacetime(earth_lab, instant(2026, 1, 1, 0, 0)), Start),
    option_or_default(end, Options, Start, End),
    option_or_default(schedule, Options, [], Schedule),
    option_or_default(constraints, Options, [], Constraints),
    option_or_default(reality_label, Options, simulated, RawLabel),
    ensure_reality_label(RawLabel, RealityLabel).

register_environment(Simulation0, sample(EnvironmentId), Simulation) :-
    environments:sample_environment(EnvironmentId, Environment),
    put_sim_dict(Simulation0, environments, EnvironmentId, Environment, Simulation).
register_environment(Simulation0, Environment, Simulation) :-
    Environment = environment(EnvironmentId, _, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, environments, EnvironmentId, Environment, Simulation).

register_traveller(Simulation0, Traveller, Simulation) :-
    travellers:traveller_id(Traveller, TravellerId),
    \+ has_sim_key(Simulation0.travellers, TravellerId),
    put_sim_dict(Simulation0, travellers, TravellerId, Traveller, Simulation1),
    initial_traveller_state(Simulation1, Traveller, State),
    put_sim_dict(Simulation1, traveller_states, TravellerId, State, Simulation).

create_hop(TravellerId, Source, Destination, Options, hop_request(TravellerId, Source, Destination, Options)).

plan_hop(Simulation, TravellerId, Source, Destination, Plan) :-
    create_hop(TravellerId, Source, Destination, [], Request),
    plan_hop(Simulation, Request, Plan).

validate_hop(Simulation, hop_request(TravellerId, Source, Destination, Options), Validation) :-
    findall(
        Diagnostic,
        hop_diagnostic(Simulation, TravellerId, Source, Destination, Options, Diagnostic),
        Diagnostics
    ),
    (   Diagnostics = []
    ->  ok_validation(Validation)
    ;   error_validation(Diagnostics, Validation)
    ).

plan_hop(Simulation, Request, Plan) :-
    validate_hop(Simulation, Request, Validation),
    \+ validation_has_errors(Validation),
    Request = hop_request(TravellerId, Source0, Destination0, Options),
    current_timeline_name(Simulation, Timeline),
    canonical_spacetime(Source0, Timeline, Source),
    canonical_spacetime(Destination0, Timeline, DestinationBase),
    maybe_branch_destination(Simulation, Source, DestinationBase, Options, Destination, TimelineActions),
    get_traveller(Simulation, TravellerId, Traveller),
    destination_environment(Simulation, Destination, Environment),
    compatibility:environment_compatible(Traveller, Environment, Compatibility),
    next_id(Simulation, hop, HopId, _),
    travel_mode(Options, Mode),
    source0_location(Source, SourceLocation),
    destination0_location(Destination, DestinationLocation),
    routes:route_plan(SourceLocation, DestinationLocation, Mode, Duration, Resources),
    memory_policy(Options, MemoryPolicy),
    timeline_policy(Options, TimelinePolicy),
    reality_for_destination(Destination, RealityLabel),
    compatibility_adaptations(Compatibility, Adaptations),
    Plan = hop_plan(
        HopId,
        TravellerId,
        Source,
        Destination,
        Mode,
        TimelinePolicy,
        MemoryPolicy,
        Resources,
        Duration,
        Adaptations,
        TimelineActions,
        RealityLabel
    ).

simulate_hop(Simulation0, Plan, Result) :-
    simulate_hop(Simulation0, Plan, _, Result).

simulate_hop(Simulation0, hop_plan(HopId, TravellerId, Source, Destination, _Mode, _TimelinePolicy, MemoryPolicy, _Resources, _Duration, Adaptations, TimelineActions, RealityLabel), Simulation, Result) :-
    get_traveller_state(Simulation0, TravellerId, State0),
    State0 = traveller_state(TravellerId, _OldCoordinate, _OldEmbodiment, HealthModel, MissionRole, _ActiveMemories, Inventory, SubjectiveClock0, active),
    destination_environment(Simulation0, Destination, Environment),
    select_destination_embodiment(Environment, Adaptations, Embodiment),
    next_id(Simulation0, memory, MemorySetId, Simulation1),
    generate_memory_set(Simulation1, TravellerId, MemoryPolicy, [], Destination, MemorySet),
    MemorySet = memory_set(MemorySetId, _, _, Memories, _, _),
    update_subjective_clock(SubjectiveClock0, SubjectiveClock),
    State = traveller_state(TravellerId, Destination, Embodiment, HealthModel, MissionRole, Memories, Inventory, SubjectiveClock, active),
    put_sim_dict(Simulation1, traveller_states, TravellerId, State, Simulation2),
    apply_timeline_actions(Simulation2, TimelineActions, Simulation3),
    append_standard_hop_events(Simulation3, HopId, TravellerId, Source, Destination, RealityLabel, Simulation4),
    put_sim_dict(Simulation4, memory_sets, MemorySetId, MemorySet, Simulation),
    continuity_report(Simulation, TravellerId, Destination, MemorySet, Report),
    Result = hop_result(HopId, committed, Source, Destination, Adaptations, MemorySetId, Report, RealityLabel).

create_timeline(Simulation0, ParentTimeline, BranchPoint, NewTimelineId, Metadata, Simulation) :-
    TimelineState = timeline_state(NewTimelineId, ParentTimeline, BranchPoint, Metadata, simulated),
    put_sim_dict(Simulation0, timelines, NewTimelineId, TimelineState, Simulation).

compare_timelines(Simulation, TimelineA, TimelineB, timeline_comparison(TimelineA, TimelineB, OnlyA, OnlyB)) :-
    timeline_event_ids(Simulation.events, TimelineA, EventsA),
    timeline_event_ids(Simulation.events, TimelineB, EventsB),
    subtract(EventsA, EventsB, OnlyA),
    subtract(EventsB, EventsA, OnlyB).

create_checkpoint(Simulation, Label, Checkpoint) :-
    next_id(Simulation, checkpoint, CheckpointId, _),
    snapshot_simulation(Simulation, Snapshot),
    term_hash(Snapshot, Hash),
    Checkpoint = checkpoint(
        CheckpointId,
        Simulation.id,
        Label,
        Simulation.current_time,
        Hash,
        Snapshot,
        [timeline(Simulation.current_timeline)]
    ).

restore_checkpoint(checkpoint(_, _, _, _, _, Snapshot, _), Snapshot).

generate_memory_set(Simulation, TravellerId, Policy, SourceEvents, Destination, memory_set(MemorySetId, TravellerId, Policy, Memories, simulated, Validation)) :-
    next_id(Simulation, memory, MemorySetId, _),
    make_memories(TravellerId, Policy, SourceEvents, Destination, Memories),
    validate_memory_set(Simulation, memory_set(MemorySetId, TravellerId, Policy, Memories, simulated, pending), TravellerId, Validation).

validate_memory_set(_Simulation, memory_set(_, TravellerId, _Policy, Memories, RealityLabel, _), TravellerId, Validation) :-
    findall(
        Diagnostic,
        memory_diagnostic(Memories, RealityLabel, Diagnostic),
        Diagnostics
    ),
    (   Diagnostics = []
    ->  ok_validation(Validation)
    ;   error_validation(Diagnostics, Validation)
    ).

continuity_report(_Simulation, TravellerId, Destination, memory_set(MemorySetId, _, Policy, Memories, RealityLabel, _), continuity_report(TravellerId, Destination, MemorySetId, Policy, memory_count(Count), RealityLabel)) :-
    length(Memories, Count).

environment_compatible(Traveller, Environment, Result) :-
    compatibility:environment_compatible(Traveller, Environment, Result).

save_simulation(Simulation, File) :-
    snapshot_simulation(Simulation, Snapshot),
    term_hash(Snapshot, Hash),
    setup_call_cleanup(
        open(File, write, Stream, [encoding(utf8)]),
        write_term(Stream, ttspacesim_saved(v1, Hash, Snapshot), [quoted(true), fullstop(true), nl(true)]),
        close(Stream)
    ).

load_simulation(File, Simulation) :-
    setup_call_cleanup(
        open(File, read, Stream, [encoding(utf8)]),
        read_term(Stream, Term, [syntax_errors(error)]),
        close(Stream)
    ),
    Term = ttspacesim_saved(v1, Hash, Simulation),
    is_dict(Simulation),
    term_hash(Simulation, Hash).

explain_result(Result, Explanation) :-
    with_output_to(string(Explanation), portray_result(Result)).

promote_to_real_action(_Simulation, Proposal, scheduled_action(Proposal, scheduled, requires_manual_execution)).

create_universe(Simulation0, UniverseId, RootCheckpointId, Options, Simulation, Universe) :-
    checkpoint_from_target(Simulation0, RootCheckpointId, RootCheckpoint),
    option_or_default(reset_policy, Options, return_to_seed, ResetPolicy),
    option_or_default(carry_policy, Options, approved_simulant_backups, CarryPolicy),
    option_or_default(variation_policy, Options, identical_replay, VariationPolicy),
    Universe = universe(
        UniverseId,
        checkpoint(RootCheckpointId),
        cycle(0),
        timeline(main),
        Simulation0.current_time,
        [reset_policy(ResetPolicy), carry_policy(CarryPolicy), variation_policy(VariationPolicy)],
        simulated,
        active
    ),
    CycleRecord = cycle_record{
        id: 0,
        parent: none,
        start_checkpoint: RootCheckpointId,
        start_time: Simulation0.current_time,
        end_time: none,
        random_seed: 42,
        reset_policy: ResetPolicy,
        status: active,
        reality_label: simulated,
        archived_ledger: [],
        cycle_summary: cycle_summary(0, RootCheckpointId)
    },
    UniverseState = universe_state{
        universe: Universe,
        root_checkpoint: RootCheckpoint,
        current_cycle: 0,
        cycles: _{0: CycleRecord}
    },
    put_sim_dict(Simulation0, universes, UniverseId, UniverseState, Simulation).

prepare_universe_reset(Simulation, UniverseId, TargetCheckpointId, Options, universe_reset_plan(ResetId, UniverseId, SourceCycle, DestinationCycle, SourceState, checkpoint(TargetCheckpointId), TargetTime, PreservedStores, PreservedSimulants, ResetComponents, VariationPolicy, TimelinePolicy, ResourceLimits, simulated)) :-
    get_sim_dict(Simulation, universes, UniverseId, UniverseState),
    get_dict(current_cycle, UniverseState, SourceCycle),
    DestinationCycle is SourceCycle + 1,
    next_id(Simulation, reset, ResetId, _),
    checkpoint_from_target(Simulation, TargetCheckpointId, TargetCheckpoint),
    TargetCheckpoint = checkpoint(_, _, _, TargetTime, _, _, _),
    SourceState = current_state(Simulation.id, SourceCycle),
    option_or_default(preserved_stores, Options, [], PreservedStores),
    option_or_default(preserved_simulants, Options, [], PreservedSimulants),
    option_or_default(reset_components, Options, [celestial_state, environment_state, ordinary_events, local_inventories, temporary_agent_instances], ResetComponents),
    option_or_default(variation_policy, Options, identical_replay, VariationPolicy),
    option_or_default(timeline_policy, Options, branch_on_change, TimelinePolicy),
    option_or_default(resource_limits, Options, [max_cycles(1)], ResourceLimits).

validate_universe_reset(Simulation, ResetPlan, Validation) :-
    ResetPlan = universe_reset_plan(_, UniverseId, _, DestinationCycle, _, checkpoint(TargetCheckpointId), _, PreservedStores, PreservedSimulants, _, _, _, ResourceLimits, _),
    findall(
        Diagnostic,
        universe_reset_diagnostic(Simulation, UniverseId, DestinationCycle, TargetCheckpointId, PreservedStores, PreservedSimulants, ResourceLimits, Diagnostic),
        Diagnostics
    ),
    (   Diagnostics = []
    ->  ok_validation(Validation)
    ;   error_validation(Diagnostics, Validation)
    ).

execute_universe_reset(Simulation0, ResetPlan, Simulation, universe_reset_result(ResetId, UniverseId, SourceCycle, DestinationCycle, checkpoint(TargetCheckpointId), restored)) :-
    ResetPlan = universe_reset_plan(ResetId, UniverseId, SourceCycle, DestinationCycle, _, checkpoint(TargetCheckpointId), _, PreservedStores, PreservedSimulants, _, VariationPolicy, _, _, _),
    validate_universe_reset(Simulation0, ResetPlan, Validation),
    \+ validation_has_errors(Validation),
    get_sim_dict(Simulation0, universes, UniverseId, UniverseState0),
    checkpoint_from_target(Simulation0, TargetCheckpointId, checkpoint(_, _, _, _, _, Snapshot0, _)),
    snapshot_simulation(Snapshot0, RestoredBase0),
    preserve_cross_cycle_state(Simulation0, RestoredBase0, PreservedStores, PreservedSimulants, RestoredBase1),
    archive_cycle(Simulation0, UniverseState0, SourceCycle, ArchivedUniverseState0),
    universe_next_seed(VariationPolicy, ArchivedUniverseState0, NewSeed),
    create_destination_cycle(ArchivedUniverseState0, DestinationCycle, TargetCheckpointId, Simulation0.current_time, NewSeed, UniverseState1),
    put_sim_dict(RestoredBase1, universes, UniverseId, UniverseState1, Simulation1),
    append_universe_reset_event(Simulation1, ResetId, SourceCycle, DestinationCycle, checkpoint(TargetCheckpointId), Simulation2),
    put_dict(_{current_timeline: main, status: active}, Simulation2, Simulation).

explain_universe_reset(universe_reset_plan(ResetId, UniverseId, SourceCycle, DestinationCycle, _, checkpoint(TargetCheckpointId), _, PreservedStores, PreservedSimulants, _, VariationPolicy, _, _, _), Explanation) :-
    format(string(Explanation), "Reset ~w archives cycle ~w for universe ~w, restores checkpoint ~w into cycle ~w, preserves stores ~w and simulants ~w, and uses variation ~w.", [ResetId, SourceCycle, UniverseId, TargetCheckpointId, DestinationCycle, PreservedStores, PreservedSimulants, VariationPolicy]).

register_bot_projector(Simulation0, Projector, Simulation, projector_registered(ProjectorId)) :-
    Projector = bot_projector(ProjectorId, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, projectors, ProjectorId, Projector, Simulation).

plan_store_projection(Simulation, ProjectorId, Destination, StoreOptions, store_projection_plan(ProjectionId, ProjectorId, SourceCoordinate, DestinationCoordinate, Template, [], IndependenceModel, CommunicationModel, ActivationTime, ResourceCost, fail_closed, verify_hashes, simulated)) :-
    get_sim_dict(Simulation, projectors, ProjectorId, Projector),
    Projector = bot_projector(_, _, Capabilities, CurrentCoordinate, _, StoreTemplates, _, _, _, _),
    memberchk(project_store, Capabilities),
    next_id(Simulation, projection, ProjectionId, _),
    SourceCoordinate = CurrentCoordinate,
    destination_coordinate(Destination, Simulation.current_timeline, DestinationCoordinate),
    option_or_default(template, StoreOptions, archive_store, Template),
    (   memberchk(Template, StoreTemplates)
    ->  true
    ;   Template = archive_store
    ),
    option_or_default(independence_model, StoreOptions, independent, IndependenceModel),
    option_or_default(communication_model, StoreOptions, relay, CommunicationModel),
    ActivationTime = Simulation.current_time,
    option_or_default(resource_cost, StoreOptions, [resource(compute, 1)], ResourceCost).

execute_store_projection(Simulation0, store_projection_plan(ProjectionId, ProjectorId, SourceCoordinate, DestinationCoordinate, Template, _, IndependenceModel, _CommunicationModel, _ActivationTime, _ResourceCost, _FailurePolicy, _VerificationPlan, RealityLabel), Simulation, store_projected(StoreId, ProjectionId, RealityLabel)) :-
    next_id(Simulation0, store, StoreId, Simulation1),
    DestinationCoordinate = spacetime(Location, _UTime, LocalTime, _Timeline),
    Store = projected_store(
        StoreId,
        projector(ProjectorId),
        Location,
        LocalTime,
        none,
        cycle(0),
        Template,
        IndependenceModel,
        bytes(1000000),
        single_store,
        authorised_simulants_only,
        hash_and_signature,
        available,
        RealityLabel
    ),
    StoreState = store_state{
        store: Store,
        source_coordinate: SourceCoordinate,
        destination_coordinate: DestinationCoordinate,
        status: available,
        packages: [],
        mutable_state: _{writes: 0}
    },
    put_sim_dict(Simulation1, stores, StoreId, StoreState, Simulation2),
    append_store_event(Simulation2, store_projected, StoreId, Simulation).

project_simulant_backup(Simulation0, _ProjectorId, SimulantId, StoreIds, BackupPolicy, Simulation, backup_projected(SimulantId, PackageId, StoreIds, BackupPolicy)) :-
    create_simulant_package(Simulation0, SimulantId, continuity_minimum, Package0),
    seal_simulant_package(Package0, Package),
    Package = simulant_package(PackageId, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, packages, PackageId, Package, Simulation1),
    store_package_on_many(Simulation1, StoreIds, Package, Simulation2),
    verify_replication_policy(Simulation2, PackageId, BackupPolicy),
    Simulation = Simulation2.

verify_projected_store(Simulation, StoreId, Verification) :-
    get_sim_dict(Simulation, stores, StoreId, StoreState),
    get_dict(status, StoreState, Status),
    get_dict(packages, StoreState, PackageIds),
    findall(Result, (member(PackageId, PackageIds), get_sim_dict(Simulation, packages, PackageId, Package), verify_package_hash(Package, Result)), PackageResults),
    Verification = store_verification(StoreId, Status, PackageResults).

restore_simulant_from_stores(Simulation0, SimulantId, selection(AvailableStores, Options), Destination, Simulation, Result) :-
    !,
    restore_simulant_from_stores(Simulation0, SimulantId, AvailableStores, Destination, Options, Simulation, Result).
restore_simulant_from_stores(Simulation0, SimulantId, AvailableStores, Destination, Simulation, Result) :-
    restore_simulant_from_stores(Simulation0, SimulantId, AvailableStores, Destination, [], Simulation, Result).

restore_simulant_from_stores(Simulation0, SimulantId, AvailableStores, Destination, Options, Simulation, Result) :-
    plan_simulant_restore(Simulation0, SimulantId, AvailableStores, Destination, Options, RestorePlan),
    execute_simulant_restore(Simulation0, RestorePlan, Simulation, Result).

create_simulant_package(Simulation, SimulantId, Scope, simulant_package(PackageId, SimulantId, SimulantType, Simulation.current_time, UniverseId, CycleId, TimelineId, IdentityRecord, CognitiveState, MemoryRecords, MissionState, RelationshipState, EmbodimentProfile, Permissions, ConsentReferences, [simulated], Provenance, pending_hash, none, v1)) :-
    get_traveller(Simulation, SimulantId, Traveller),
    travellers:traveller_type(Traveller, SimulantType),
    travellers:traveller_identity(Traveller, IdentityRecord),
    get_traveller_state(Simulation, SimulantId, State),
    state_cognitive_state(State, Scope, CognitiveState),
    state_memory_records(State, Scope, MemoryRecords),
    state_mission(Simulation, SimulantId, MissionState),
    RelationshipState = relationships([]),
    state_embodiment(State, EmbodimentProfile),
    Permissions = permissions([scope(Scope)]),
    ConsentReferences = consent_refs([]),
    package_provenance(Simulation, SimulantId, Scope, Provenance),
    current_universe_cycle(Simulation, UniverseId, CycleId),
    TimelineId = Simulation.current_timeline,
    next_id(Simulation, package, PackageId, _).

seal_simulant_package(Package0, Package) :-
    hash_package(Package0, Hash),
    replace_package_hash(Package0, Hash, Package).

store_package(Simulation0, StoreId, Package, Simulation, package_stored(StoreId, PackageId)) :-
    Package = simulant_package(PackageId, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, packages, PackageId, Package, Simulation1),
    add_package_to_store(Simulation1, StoreId, PackageId, Simulation2),
    append_store_event(Simulation2, package_stored, StoreId, Simulation).

replicate_package(Simulation0, PackageId, DestinationStores, Simulation, package_replicated(PackageId, DestinationStores)) :-
    get_sim_dict(Simulation0, packages, PackageId, Package),
    store_package_on_many(Simulation0, DestinationStores, Package, Simulation).

compare_simulant_packages(PackageA, PackageB, identical) :-
    hash_package(PackageA, Hash),
    hash_package(PackageB, Hash),
    !.
compare_simulant_packages(simulant_package(_, SimulantId, _, _, _, _, TimelineA, Identity, _, MemoriesA, _, _, _, _, _, _, _, _, _, _),
    simulant_package(_, SimulantId, _, _, _, _, TimelineB, Identity, _, MemoriesB, _, _, _, _, _, _, _, _, _, _),
    timeline_divergence) :-
    TimelineA \= TimelineB,
    MemoriesA \= MemoriesB,
    !.
compare_simulant_packages(simulant_package(_, _, _, _, _, _, _, IdentityA, _, _, _, _, _, _, _, _, _, _, _, _),
    simulant_package(_, _, _, _, _, _, _, IdentityB, _, _, _, _, _, _, _, _, _, _, _, _),
    identity_conflict) :-
    IdentityA \= IdentityB,
    !.
compare_simulant_packages(simulant_package(_, _, _, _, _, _, _, _, _, MemoriesA, _, _, _, _, _, _, _, _, _, _),
    simulant_package(_, _, _, _, _, _, _, _, _, MemoriesB, _, _, _, _, _, _, _, _, _, _),
    memory_conflict) :-
    MemoriesA \= MemoriesB,
    !.
compare_simulant_packages(_, _, compatible_divergence).

hash_package(Package, Hash) :-
    normalise_package_for_hash(Package, HashInput),
    term_hash(HashInput, Hash).

verify_package_hash(Package, valid) :-
    Package = simulant_package(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, StoredHash, _, _),
    integer(StoredHash),
    replace_package_hash(Package, none, Hashless),
    term_hash(Hashless, ExpectedHash),
    StoredHash =:= ExpectedHash,
    !.
verify_package_hash(_, invalid).

verify_package_provenance(simulant_package(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Provenance, _, _, _), valid) :-
    Provenance \= [].
verify_package_provenance(_, invalid).

plan_simulant_restore(Simulation, SimulantId, AvailableStores, Destination, Options, simulant_restore_plan(RestoreId, SimulantId, SelectedPackages, AvailableStores, DestinationCoordinate, DestinationEmbodiment, ContinuityPolicy, ConflictPolicy, MemoryPolicy, permissions([]), simulated)) :-
    next_id(Simulation, restore, RestoreId, _),
    destination_coordinate(Destination, Simulation.current_timeline, DestinationCoordinate),
    destination_environment(Simulation, DestinationCoordinate, Environment),
    environments:available_embodiments(Environment, [DestinationEmbodiment | _]),
    packages_for_simulant(Simulation, SimulantId, AvailableStores, SelectedPackages),
    option_or_default(continuity_policy, Options, continued_from_checkpoint, ContinuityPolicy),
    option_or_default(conflict_policy, Options, reject_duplicate_active_instance, ConflictPolicy),
    option_or_default(memory_policy, Options, preserve, MemoryPolicy).

validate_simulant_restore(_Simulation, simulant_restore_plan(_, _SimulantId, SelectedPackages, _SourceStores, _DestinationCoordinate, _DestinationEmbodiment, _ContinuityPolicy, _ConflictPolicy, _MemoryPolicy, _, _), Validation) :-
    (   SelectedPackages = []
    ->  error_validation(diagnostic(error, projected_store_unavailable, "No verified packages are available for restoration.", restore, create_backup), Validation)
    ;   ok_validation(Validation)
    ).

execute_simulant_restore(Simulation0, RestorePlan, Simulation, simulant_restored(SimulantId, ContinuityClass)) :-
    RestorePlan = simulant_restore_plan(_RestoreId, SimulantId, [PackageId | _], _SourceStores, DestinationCoordinate, DestinationEmbodiment, ContinuityPolicy, ConflictPolicy, _MemoryPolicy, _, _),
    validate_simulant_restore(Simulation0, RestorePlan, Validation),
    \+ validation_has_errors(Validation),
    get_sim_dict(Simulation0, packages, PackageId, Package),
    restore_traveller_from_package(Simulation0, SimulantId, Package, DestinationCoordinate, DestinationEmbodiment, ConflictPolicy, ContinuityPolicy, Simulation, ContinuityClass).

detect_simulant_instances(Simulation, SimulantId, Instances) :-
    findall(
        instance(SimulantId, State),
        (get_sim_dict(Simulation, traveller_states, SimulantId, State), state_active(State)),
        Instances
    ).

simulate_store_failure(Simulation0, StoreId, Failure, Simulation, store_failed(StoreId, Failure)) :-
    update_store_status(Simulation0, StoreId, degraded, Simulation1),
    append_store_event(Simulation1, store_failed, StoreId, Simulation).

repair_projected_store(Simulation0, ProjectorId, StoreId, Policy, Simulation) :-
    repair_projected_store(Simulation0, ProjectorId, StoreId, Policy, Simulation, _).

repair_projected_store(Simulation0, _ProjectorId, StoreId, _Policy, Simulation, store_repaired(StoreId)) :-
    update_store_status(Simulation0, StoreId, available, Simulation1),
    append_store_event(Simulation1, store_repaired, StoreId, Simulation).

reconstruct_projected_store(Simulation0, ProjectorId, LostStoreId, SourceStoreIds, Simulation) :-
    reconstruct_projected_store(Simulation0, ProjectorId, LostStoreId, SourceStoreIds, Simulation, _).

reconstruct_projected_store(Simulation0, _ProjectorId, LostStoreId, SourceStoreIds, Simulation, store_reconstructed(NewStoreId, LostStoreId, SourceStoreIds)) :-
    next_id(Simulation0, store, NewStoreId, Simulation1),
    get_sim_dict(Simulation1, stores, LostStoreId, OldStoreState),
    get_dict(store, OldStoreState, projected_store(_, ProjectionOrigin, Location, ProjectedTime, UniverseId, CycleId, StorageModel, _IndependenceModel, Capacity, ReplicationPolicy, AccessPolicy, IntegrityPolicy, _Status, RealityLabel)),
    get_dict(packages, OldStoreState, Packages),
    NewStore = projected_store(NewStoreId, ProjectionOrigin, Location, ProjectedTime, UniverseId, CycleId, StorageModel, reconstructed, Capacity, ReplicationPolicy, AccessPolicy, IntegrityPolicy, reconstructed, RealityLabel),
    NewStoreState = store_state{
        store: NewStore,
        source_coordinate: reconstructed,
        destination_coordinate: reconstructed,
        status: reconstructed,
        packages: Packages,
        mutable_state: _{writes: 0, reconstructed_from: LostStoreId}
    },
    put_sim_dict(Simulation1, stores, NewStoreId, NewStoreState, Simulation2),
    append_store_event(Simulation2, store_reconstructed, NewStoreId, Simulation).

project_store_across_universe(Simulation0, ProjectorId, SourceUniverse, DestinationUniverse, StoreSpecification, Simulation) :-
    project_store_across_universe(Simulation0, ProjectorId, SourceUniverse, DestinationUniverse, StoreSpecification, Simulation, _).

project_store_across_universe(Simulation0, ProjectorId, SourceUniverse, DestinationUniverse, StoreSpecification, Simulation, cross_universe_projection(StoreId, SourceUniverse, DestinationUniverse)) :-
    plan_store_projection(Simulation0, ProjectorId, StoreSpecification, [template(archive_store)], Plan0),
    Plan0 = store_projection_plan(ProjectionId, ProjectorId, SourceCoordinate, DestinationCoordinate, Template, InitialContents, IndependenceModel, CommunicationModel, ActivationTime, ResourceCost, FailurePolicy, VerificationPlan, _),
    DestinationCoordinate = spacetime(Location, UTime, LocalTime, Timeline),
    DestinationCoordinate2 = spacetime(Location, UTime, LocalTime, timeline(Timeline)),
    Plan = store_projection_plan(ProjectionId, ProjectorId, SourceCoordinate, DestinationCoordinate2, Template, InitialContents, IndependenceModel, CommunicationModel, ActivationTime, ResourceCost, FailurePolicy, VerificationPlan, simulated),
    execute_store_projection(Simulation0, Plan, Simulation1, store_projected(StoreId, ProjectionId, simulated)),
    annotate_store_universes(Simulation1, StoreId, SourceUniverse, DestinationUniverse, Simulation).

prepare_cycle_preservation(Simulation, UniverseId, universe_reset_plan(_, _, SourceCycle, DestinationCycle, _, _, _, PreservedStores, PreservedSimulants, _, _, _, _, _), cycle_preservation_plan(PreservationId, UniverseId, SourceCycle, DestinationCycle, Packages, PreservedStores, replication_requirements(quorum(1, 1)), [verify_hashes], restore_survivors(PreservedSimulants), ready)) :-
    next_id(Simulation, preservation, PreservationId, _),
    findall(Package, (member(SimulantId, PreservedSimulants), create_simulant_package(Simulation, SimulantId, continuity_minimum, Package)), Packages).

restore_cycle_survivors(Simulation0, cycle_preservation_plan(_, _UniverseId, _SourceCycle, _DestinationCycle, Packages, StoreIds, _ReplicationRequirements, _VerificationActions, restore_survivors(SimulantIds), _Status), Simulation, restoration_report(SimulantIds, restored)) :-
    store_generated_packages(Simulation0, Packages, Simulation1),
    restore_packages_to_stores(Simulation1, Packages, StoreIds, Simulation2),
    restore_many_from_packages(Simulation2, Packages, Simulation).

run_projector_cycle(Simulation0, ProjectorId, _CurrentTime, Simulation, projector_actions(ProjectorId, Actions)) :-
    get_sim_dict(Simulation0, projectors, ProjectorId, bot_projector(_, _, _, _, _, _, _, _, _, _)),
    findall(verify(StoreId), (get_dict(StoreId, Simulation0.stores, _), store_owned_by(Simulation0, StoreId, ProjectorId)), Actions),
    Simulation = Simulation0.

run_universe_cycles(
    Simulation0,
    UniverseId,
    CyclePolicy,
    StoppingConditions,
    Simulation,
    universe_cycle_report(
        CompletedCycles,
        cycle(FinalCycle),
        FinalTime,
        PreservedPackages,
        StoreHealth,
        ResetEvents,
        StoppingReason,
        resume_token(UniverseId, FinalCycle)
    )
) :-
    finite_cycle_limit(StoppingConditions, MaxCycles),
    MaxCycles > 0,
    run_cycles_loop(Simulation0, UniverseId, CyclePolicy, MaxCycles, 0, [], Simulation, CompletedCycles, ResetEvents),
    get_sim_dict(Simulation, universes, UniverseId, UniverseState),
    FinalCycle = UniverseState.current_cycle,
    FinalTime = Simulation.current_time,
    findall(PackageId, get_dict(PackageId, Simulation.packages, _), PreservedPackages),
    findall(store_status(StoreId, Status), (get_dict(StoreId, Simulation.stores, StoreState), get_dict(status, StoreState, Status)), StoreHealth),
    StoppingReason = max_cycles_reached.

run_cycles_loop(Simulation, _UniverseId, _CyclePolicy, MaxCycles, MaxCycles, ResetEvents, Simulation, MaxCycles, ResetEvents) :-
    !.
run_cycles_loop(Simulation0, UniverseId, CyclePolicy, MaxCycles, Count0, ResetEvents0, Simulation, CompletedCycles, ResetEvents) :-
    run_single_cycle(Simulation0, UniverseId, CyclePolicy, Simulation1, ResetEvent),
    Count is Count0 + 1,
    run_cycles_loop(Simulation1, UniverseId, CyclePolicy, MaxCycles, Count, [ResetEvent | ResetEvents0], Simulation, CompletedCycles, ResetEvents).

run_single_cycle(Simulation0, UniverseId, CyclePolicy, Simulation, ResetEvent) :-
    cycle_reset_target(CyclePolicy, ResetTarget),
    findall(StoreId, get_dict(StoreId, Simulation0.stores, _), PreservedStores),
    create_checkpoint(Simulation0, cycle_end, Checkpoint),
    checkpoint_id(Checkpoint, CheckpointId),
    put_sim_dict(Simulation0, checkpoints, CheckpointId, Checkpoint, Simulation1),
    prepare_universe_reset(Simulation1, UniverseId, ResetTarget, [preserved_stores(PreservedStores), preserved_simulants([]), variation_policy(seed_increment)], ResetPlan),
    execute_universe_reset(Simulation1, ResetPlan, Simulation, ResetEvent).

hop_diagnostic(Simulation, TravellerId, _Source, _Destination, _Options, diagnostic(error, unknown_traveller, "Traveller does not exist.", traveller(TravellerId), register_traveller)) :-
    \+ has_sim_key(Simulation.travellers, TravellerId).
hop_diagnostic(Simulation, TravellerId, Source, _Destination, _Options, diagnostic(error, missing_source_state, "Source does not match the active traveller state.", source(Source), inspect_ledger)) :-
    get_traveller_state(Simulation, TravellerId, traveller_state(_, Current, _, _, _, _, _, _, _)),
    current_timeline_name(Simulation, Timeline),
    canonical_spacetime(Source, Timeline, CanonicalSource),
    Current \= CanonicalSource.
hop_diagnostic(_Simulation, _TravellerId, _Source, Destination, _Options, diagnostic(error, unknown_destination, "Destination is not in the celestial catalogue.", destination(Destination), add_environment)) :-
    Destination = spacetime(Location, _),
    \+ celestial_catalogue:known_location(Location, _, _, _).
hop_diagnostic(_Simulation, _TravellerId, _Source, Destination, _Options, diagnostic(warning, fictional_destination, "Destination is fictional and remains explicitly simulated.", destination(Destination), none)) :-
    Destination = spacetime(Location, _),
    celestial_catalogue:fictional_location(Location).
hop_diagnostic(Simulation, TravellerId, _Source, Destination, _Options, diagnostic(error, incompatible_destination, "Traveller is not compatible with the destination environment.", destination(Destination), adapt_or_replace_embodiment)) :-
    get_traveller(Simulation, TravellerId, Traveller),
    current_timeline_name(Simulation, Timeline),
    canonical_spacetime(Destination, Timeline, CanonicalDestination),
    destination_environment(Simulation, CanonicalDestination, Environment),
    compatibility:environment_compatible(Traveller, Environment, incompatible(_)).
hop_diagnostic(Simulation, TravellerId, _Source, _Destination, _Options, diagnostic(error, duplicate_agent, "Traveller already has an active instance.", traveller(TravellerId), create_branch_instance)) :-
    detect_simulant_instances(Simulation, TravellerId, Instances),
    length(Instances, Count),
    Count > 1.

memory_diagnostic(_Memories, RealityLabel, diagnostic(error, synthetic_label_required, "Synthetic memories must carry the synthetic reality label.", memory_set, apply_synthetic_label)) :-
    RealityLabel \= simulated.
memory_diagnostic(Memories, _RealityLabel, diagnostic(error, contradictory_memories, "Conflicting synthetic memories were generated.", memory_set, regenerate_memory_set)) :-
    contradictory_memories(Memories).

universe_reset_diagnostic(Simulation, UniverseId, _DestinationCycle, _TargetCheckpointId, _PreservedStores, _PreservedSimulants, _ResourceLimits, diagnostic(error, unknown_universe, "Universe does not exist.", universe(UniverseId), create_universe)) :-
    \+ has_sim_key(Simulation.universes, UniverseId).
universe_reset_diagnostic(Simulation, _UniverseId, _DestinationCycle, TargetCheckpointId, _PreservedStores, _PreservedSimulants, _ResourceLimits, diagnostic(error, invalid_root_checkpoint, "Target checkpoint does not exist.", checkpoint(TargetCheckpointId), create_checkpoint)) :-
    \+ has_sim_key(Simulation.checkpoints, TargetCheckpointId).
universe_reset_diagnostic(Simulation, UniverseId, DestinationCycle, _TargetCheckpointId, _PreservedStores, _PreservedSimulants, _ResourceLimits, diagnostic(error, cycle_identifier_conflict, "Destination cycle identifier already exists.", universe(UniverseId), choose_new_cycle_identifier)) :-
    get_sim_dict(Simulation, universes, UniverseId, UniverseState),
    has_sim_key(UniverseState.cycles, DestinationCycle).

portray_result(Result) :-
    write_term(Result, [quoted(true), numbervars(true)]).

environment_id_from_spec(sample(EnvironmentId), EnvironmentId).
environment_id_from_spec(environment(EnvironmentId, _, _, _, _, _, _, _, _, _, _), EnvironmentId).

option_or_default(Key, Options, Default, Value) :-
    Term =.. [Key, Value0],
    (   memberchk(Term, Options)
    ->  Value = Value0
    ;   Value = Default
    ).

current_timeline_name(Simulation, Timeline) :-
    Timeline = Simulation.current_timeline.

has_sim_key(Dict, Key) :-
    dict_key(Key, DictKey),
    get_dict(DictKey, Dict, _).

get_sim_dict(Simulation, Field, Key, Value) :-
    get_dict(Field, Simulation, Dict),
    dict_key(Key, DictKey),
    get_dict(DictKey, Dict, Value).

put_sim_dict(Simulation0, Field, Key, Value, Simulation) :-
    get_dict(Field, Simulation0, Dict0),
    dict_key(Key, DictKey),
    put_dict(DictKey, Dict0, Value, Dict),
    put_dict(Field, Simulation0, Dict, Simulation).

next_id(Simulation, Prefix, Id, Simulation) :-
    next_id_value(Simulation, Prefix, Value),
    atomic_list_concat([Prefix, Value], '_', Id).

store_hop_plan(Simulation0, Plan, Simulation) :-
    Plan = hop_plan(HopId, _, _, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, hops, HopId, Plan, Simulation).

plan_summary(hop_plan(HopId, _, _, _, _, _, MemoryPolicy, _, _, Adaptations, _, RealityLabel), hop_planned(HopId, RealityLabel, adaptations(Adaptations), memory_plan(MemoryPolicy), warnings([]))).

current_coordinate(Simulation, TravellerId, Coordinate) :-
    get_traveller_state(Simulation, TravellerId, traveller_state(_, Coordinate, _, _, _, _, _, _, _)).

get_traveller(Simulation, TravellerId, Traveller) :-
    get_sim_dict(Simulation, travellers, TravellerId, Traveller).

get_traveller_state(Simulation, TravellerId, State) :-
    get_sim_dict(Simulation, traveller_states, TravellerId, State).

initial_traveller_state(Simulation, Traveller, traveller_state(TravellerId, Coordinate, Embodiment, nominal, unassigned, [], [], subject_time(0), active)) :-
    travellers:traveller_id(Traveller, TravellerId),
    travellers:traveller_profile(Traveller, Embodiment, _),
    universal_to_local(earth, Simulation.current_time, LocalTime),
    Coordinate = spacetime(earth_lab, Simulation.current_time, LocalTime, timeline(Simulation.current_timeline)).

travel_mode(Options, Mode) :-
    option_or_default(travel_mode, Options, conventional, Mode).

memory_policy(Options, Policy) :-
    option_or_default(memory_policy, Options, causal_minimum, Policy).

timeline_policy(Options, Policy) :-
    option_or_default(timeline_policy, Options, continue_current, Policy).

maybe_branch_destination(_Simulation, Source, Destination, Options, Destination, []) :-
    timeline_policy(Options, continue_current),
    coordinates:spacetime_order(Source, Destination, (<)),
    !.
maybe_branch_destination(Simulation, Source, Destination0, Options, Destination, [create_timeline(NewTimeline, main, branch_from_past)]) :-
    (   timeline_policy(Options, branch_on_change)
    ;   coordinates:spacetime_order(Destination0, Source, (<))
    ),
    next_timeline_name(Simulation, NewTimeline),
    Destination0 = spacetime(Location, UTime, LocalTime, _),
    Destination = spacetime(Location, UTime, LocalTime, timeline(NewTimeline)).
maybe_branch_destination(_Simulation, _Source, Destination, _Options, Destination, []).

next_timeline_name(Simulation, NewTimeline) :-
    next_id(Simulation, timeline, TimelineId, _),
    NewTimeline = TimelineId.

destination_environment(Simulation, spacetime(Location, _, _, _), Environment) :-
    celestial_catalogue:location_environment(Location, EnvironmentId),
    (   has_sim_key(Simulation.environments, EnvironmentId)
    ->  get_sim_dict(Simulation, environments, EnvironmentId, Environment)
    ;   environments:sample_environment(EnvironmentId, Environment)
    ).

reality_for_destination(spacetime(Location, _, _, _), RealityLabel) :-
    celestial_catalogue:known_location(Location, _, _, RealityLabel),
    !.
reality_for_destination(_, simulated).

compatibility_adaptations(compatible, []).
compatibility_adaptations(adaptable(Adaptations), Adaptations).
compatibility_adaptations(incompatible(_), []).

source0_location(spacetime(Location, _, _, _), Location).
source0_location(spacetime(Location, _), Location).
destination0_location(spacetime(Location, _, _, _), Location).
destination0_location(spacetime(Location, _), Location).

select_destination_embodiment(_Environment, Adaptations, Embodiment) :-
    memberchk(embodiment_swap(Embodiment), Adaptations),
    !.
select_destination_embodiment(Environment, _Adaptations, Embodiment) :-
    environments:available_embodiments(Environment, [Embodiment | _]).

update_subjective_clock(subject_time(Value0), subject_time(Value)) :-
    Value is Value0 + 1.

apply_timeline_actions(Simulation0, [], Simulation0).
apply_timeline_actions(Simulation0, [create_timeline(NewTimeline, Parent, BranchPoint) | Rest], Simulation) :-
    create_timeline(Simulation0, Parent, BranchPoint, NewTimeline, [], Simulation1),
    put_dict(current_timeline, Simulation1, NewTimeline, Simulation2),
    apply_timeline_actions(Simulation2, Rest, Simulation).

append_standard_hop_events(Simulation0, HopId, TravellerId, Source, Destination, RealityLabel, Simulation) :-
    append_event(Simulation0, hop_departed, TravellerId, Source, [hop(HopId)], [destination(Destination)], RealityLabel, hop_departure(HopId), Simulation1),
    append_event(Simulation1, hop_arrived, TravellerId, Destination, [hop(HopId)], [source(Source)], RealityLabel, hop_arrival(HopId), Simulation).

append_event(Simulation0, Type, TravellerId, SpaceTime, Causes, Effects, RealityLabel, Details, Simulation) :-
    next_id(Simulation0, event, EventId, _),
    Event = event(EventId, Type, [TravellerId], SpaceTime, Causes, Effects, RealityLabel, Details, generated_by(ttspacesim)),
    Events = [Event | Simulation0.events],
    put_dict(events, Simulation0, Events, Simulation1),
    spacetime_utime(SpaceTime, UTime),
    put_dict(current_time, Simulation1, UTime, Simulation).

timeline_event_ids(Events, TimelineName, EventIds) :-
    findall(
        EventId,
        (member(event(EventId, _, _, spacetime(_, _, _, timeline(TimelineName)), _, _, _, _, _), Events)),
        EventIds
    ).

snapshot_simulation(Simulation0, Snapshot) :-
    put_dict(checkpoints, Simulation0, _{}, Simulation1),
    put_dict(pending_resets, Simulation1, _{}, Simulation2),
    put_dict(pending_preservations, Simulation2, _{}, Snapshot).

make_memories(TravellerId, Policy, SourceEvents, Destination, Memories) :-
    destination0_location(Destination, Location),
    synthetic_memory_label(Label),
    Memories = [
        synthetic_memory(memory_1, TravellerId, SourceEvents, summary(policy(Policy), arrival(Location)), Label, generated_by(ttspacesim))
    ].

contradictory_memories(Memories) :-
    member(synthetic_memory(_, _, _, summary(fact(Key, ValueA)), _, _), Memories),
    member(synthetic_memory(_, _, _, summary(fact(Key, ValueB)), _, _), Memories),
    ValueA \= ValueB.

checkpoint_from_target(Simulation, checkpoint(TargetId), Checkpoint) :-
    !,
    checkpoint_from_target(Simulation, TargetId, Checkpoint).
checkpoint_from_target(Simulation, TargetId, Checkpoint) :-
    get_sim_dict(Simulation, checkpoints, TargetId, Checkpoint).

preserve_cross_cycle_state(Simulation0, RestoredBase0, PreservedStores, PreservedSimulants, Simulation) :-
    keep_selected_dict_entries(Simulation0.stores, PreservedStores, Stores),
    keep_selected_simulants(Simulation0, PreservedSimulants, Travellers, TravellerStates),
    put_dict(stores, RestoredBase0, Stores, RestoredBase1),
    put_dict(travellers, RestoredBase1, Travellers, RestoredBase2),
    put_dict(traveller_states, RestoredBase2, TravellerStates, RestoredBase3),
    put_dict(packages, RestoredBase3, Simulation0.packages, RestoredBase4),
    put_dict(projectors, RestoredBase4, Simulation0.projectors, Simulation).

keep_selected_dict_entries(_Dict, [], _{}).
keep_selected_dict_entries(Dict, [Key | Keys], Result) :-
    keep_selected_dict_entries(Dict, Keys, Partial),
    (   get_dict(Key, Dict, Value)
    ->  put_dict(Key, Partial, Value, Result)
    ;   Result = Partial
    ).

keep_selected_simulants(_Simulation, [], _{}, _{}).
keep_selected_simulants(Simulation, [SimulantId | Rest], Travellers, TravellerStates) :-
    keep_selected_simulants(Simulation, Rest, PartialTravellers, PartialStates),
    get_sim_dict(Simulation, travellers, SimulantId, Traveller),
    get_sim_dict(Simulation, traveller_states, SimulantId, State),
    dict_key(SimulantId, DictKey),
    put_dict(DictKey, PartialTravellers, Traveller, Travellers),
    put_dict(DictKey, PartialStates, State, TravellerStates).

archive_cycle(Simulation, UniverseState0, SourceCycle, UniverseState) :-
    get_dict(SourceCycle, UniverseState0.cycles, CycleRecord0),
    put_dict(_{end_time: Simulation.current_time, status: archived, archived_ledger: Simulation.events}, CycleRecord0, CycleRecord),
    put_dict(SourceCycle, UniverseState0.cycles, CycleRecord, Cycles),
    put_dict(_{cycles: Cycles, current_cycle: SourceCycle}, UniverseState0, UniverseState).

universe_next_seed(seed_increment, UniverseState, Seed) :-
    Seed is UniverseState.current_cycle + 43.
universe_next_seed(new_random_seed, UniverseState, Seed) :-
    Seed is UniverseState.current_cycle + 99.
universe_next_seed(_, UniverseState, Seed) :-
    Seed is UniverseState.current_cycle + 42.

create_destination_cycle(UniverseState0, DestinationCycle, TargetCheckpointId, TargetTime, NewSeed, UniverseState) :-
    CycleRecord = cycle_record{
        id: DestinationCycle,
        parent: UniverseState0.current_cycle,
        start_checkpoint: TargetCheckpointId,
        start_time: TargetTime,
        end_time: none,
        random_seed: NewSeed,
        reset_policy: return_to_seed,
        status: active,
        reality_label: simulated,
        archived_ledger: [],
        cycle_summary: cycle_summary(DestinationCycle, TargetCheckpointId)
    },
    put_dict(DestinationCycle, UniverseState0.cycles, CycleRecord, Cycles),
    Universe = UniverseState0.universe,
    universe_update_cycle(Universe, DestinationCycle, TargetTime, Universe1),
    put_dict(_{cycles: Cycles, current_cycle: DestinationCycle, universe: Universe1}, UniverseState0, UniverseState).

universe_update_cycle(universe(UniverseId, RootCheckpoint, _OldCycle, _OldTimeline, _OldTime, Config, RealityLabel, Status), DestinationCycle, TargetTime,
    universe(UniverseId, RootCheckpoint, cycle(DestinationCycle), timeline(main), TargetTime, Config, RealityLabel, Status)).

append_universe_reset_event(Simulation0, ResetId, SourceCycle, DestinationCycle, checkpoint(TargetCheckpointId), Simulation) :-
    SpaceTime = spacetime(earth_lab, Simulation0.current_time, local_time(earth, instant(2026, 1, 1, 0, 0, 0)), timeline(main)),
    append_event(Simulation0, universe_reset, system, SpaceTime, [source_cycle(SourceCycle), target_checkpoint(TargetCheckpointId)], [created_cycle(DestinationCycle)], simulated, reset_report(ResetId), Simulation).

append_store_event(Simulation0, EventType, StoreId, Simulation) :-
    SpaceTime = spacetime(earth_lab, Simulation0.current_time, local_time(earth, instant(2026, 1, 1, 0, 0, 0)), timeline(Simulation0.current_timeline)),
    append_event(Simulation0, EventType, StoreId, SpaceTime, [], [store(StoreId)], simulated, store_event(StoreId), Simulation).

store_package_on_many(Simulation, [], _Package, Simulation).
store_package_on_many(Simulation0, [StoreId | Rest], Package, Simulation) :-
    store_package(Simulation0, StoreId, Package, Simulation1, _),
    store_package_on_many(Simulation1, Rest, Package, Simulation).

add_package_to_store(Simulation0, StoreId, PackageId, Simulation) :-
    get_sim_dict(Simulation0, stores, StoreId, StoreState0),
    get_dict(packages, StoreState0, Packages0),
    (   memberchk(PackageId, Packages0)
    ->  Packages = Packages0
    ;   Packages = [PackageId | Packages0]
    ),
    put_dict(_{packages: Packages}, StoreState0, StoreState),
    put_sim_dict(Simulation0, stores, StoreId, StoreState, Simulation).

verify_replication_policy(Simulation, PackageId, quorum(Required, _Total)) :-
    findall(
        StoreId,
        (get_dict(StoreId, Simulation.stores, StoreState), get_dict(packages, StoreState, PackageIds), memberchk(PackageId, PackageIds)),
        StoreIds
    ),
    length(StoreIds, Count),
    Count >= Required.
verify_replication_policy(_Simulation, _PackageId, minimum_copies(_)).
verify_replication_policy(_Simulation, _PackageId, _).

state_cognitive_state(traveller_state(_, _, _, _, _, Memories, _, _, _), continuity_minimum, cognition(summary, memory_count(Count))) :-
    length(Memories, Count).
state_cognitive_state(traveller_state(_, _, _, _, _, Memories, _, _, _), complete_simulant_state, cognition(complete, Memories)).
state_cognitive_state(_, _, cognition(summary, memory_count(0))).

state_memory_records(traveller_state(_, _, _, _, _, Memories, _, _, _), complete_simulant_state, Memories).
state_memory_records(traveller_state(_, _, _, _, _, Memories, _, _, _), continuity_minimum, Minimal) :-
    take(1, Memories, Minimal).
state_memory_records(_, _, []).

state_mission(Simulation, SimulantId, mission_state(MissionIds)) :-
    findall(MissionId, mission_includes_traveller(Simulation.missions, MissionId, SimulantId), MissionIds).

mission_includes_traveller(Missions, MissionId, SimulantId) :-
    get_dict(MissionId, Missions, mission(_, _, _, Participants, _, _, _, _, _, _)),
    memberchk(SimulantId, Participants).

state_embodiment(traveller_state(_, _, Embodiment, _, _, _, _, _, _), embodiment(Embodiment)).

package_provenance(Simulation, SimulantId, Scope, [simulation(Simulation.id), simulant(SimulantId), scope(Scope), timeline(Simulation.current_timeline)]).

current_universe_cycle(Simulation, UniverseId, CycleId) :-
    get_dict(UniverseId, Simulation.universes, UniverseState),
    CycleId = UniverseState.current_cycle,
    !.
current_universe_cycle(_Simulation, none, 0).

replace_package_hash(simulant_package(PackageId, SimulantId, SimulantType, SnapshotTime, UniverseId, CycleId, TimelineId, IdentityRecord, CognitiveState, MemoryRecords, MissionState, RelationshipState, EmbodimentProfile, Permissions, ConsentReferences, RealityLabels, Provenance, _OldHash, Signature, Version),
    Hash,
    simulant_package(PackageId, SimulantId, SimulantType, SnapshotTime, UniverseId, CycleId, TimelineId, IdentityRecord, CognitiveState, MemoryRecords, MissionState, RelationshipState, EmbodimentProfile, Permissions, ConsentReferences, RealityLabels, Provenance, Hash, Signature, Version)).

normalise_package_for_hash(Package, HashInput) :-
    replace_package_hash(Package, none, HashInput).

packages_for_simulant(Simulation, SimulantId, AvailableStores, SelectedPackages) :-
    findall(
        PackageId,
        (
            member(StoreId, AvailableStores),
            get_sim_dict(Simulation, stores, StoreId, StoreState),
            get_dict(status, StoreState, Status),
            get_dict(packages, StoreState, PackageIds),
            memberchk(Status, [available, reconstructed]),
            member(PackageId, PackageIds),
            get_sim_dict(Simulation, packages, PackageId, simulant_package(_, SimulantId, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _))
        ),
        SelectedPackages
    ).

package_traveller(Simulation, SimulantId, Traveller) :-
    (   get_sim_dict(Simulation, travellers, SimulantId, Traveller)
    ->  true
    ;   Traveller = traveller(SimulantId, software_agent, SimulantId, initial, consent_not_applicable, simulated)
    ).

restore_traveller_from_package(Simulation0, SimulantId, Package, DestinationCoordinate, DestinationEmbodiment, ConflictPolicy, ContinuityPolicy, Simulation, ContinuityClass) :-
    Package = simulant_package(_, SimulantId, SimulantType, _, _, _, _, IdentityRecord, _CognitiveState, MemoryRecords, _MissionState, _RelationshipState, _EmbodimentProfile, _Permissions, _ConsentReferences, _RealityLabels, Provenance, _, _, _),
    resolve_restore_conflict(Simulation0, SimulantId, ConflictPolicy, Simulation1, ContinuityClass0),
    Traveller = traveller(SimulantId, SimulantType, IdentityRecord, initial, consent_not_applicable, simulated),
    (   has_sim_key(Simulation1.travellers, SimulantId)
    ->  Simulation2 = Simulation1
    ;   put_sim_dict(Simulation1, travellers, SimulantId, Traveller, Simulation2)
    ),
    State = traveller_state(SimulantId, DestinationCoordinate, DestinationEmbodiment, nominal, restored_from(Provenance), MemoryRecords, [], subject_time(0), active),
    put_sim_dict(Simulation2, traveller_states, SimulantId, State, Simulation),
    continuity_class(ContinuityPolicy, ContinuityClass0, ContinuityClass).

resolve_restore_conflict(Simulation, _SimulantId, create_branch_instance, Simulation, branch_instance_created).
resolve_restore_conflict(Simulation0, SimulantId, deactivate_previous_instance, Simulation, continued_from_checkpoint) :-
    get_traveller_state(Simulation0, SimulantId, State0),
    State0 = traveller_state(SimulantId, Coordinate, Embodiment, HealthModel, MissionRole, Memories, Inventory, SubjectiveClock, _),
    State = traveller_state(SimulantId, Coordinate, Embodiment, HealthModel, MissionRole, Memories, Inventory, SubjectiveClock, archived),
    put_sim_dict(Simulation0, traveller_states, SimulantId, State, Simulation).
resolve_restore_conflict(Simulation, _SimulantId, reject_duplicate_active_instance, Simulation, same_simulated_instance).
resolve_restore_conflict(Simulation, _SimulantId, _, Simulation, same_simulated_instance).

continuity_class(branch_instance, _, branch_instance).
continuity_class(continued_from_checkpoint, _, continued_from_checkpoint).
continuity_class(restored_copy, _, restored_copy).
continuity_class(_, ContinuityClass, ContinuityClass).

state_active(traveller_state(_, _, _, _, _, _, _, _, active)).

update_store_status(Simulation0, StoreId, Status, Simulation) :-
    get_sim_dict(Simulation0, stores, StoreId, StoreState0),
    put_dict(_{status: Status}, StoreState0, StoreState),
    put_sim_dict(Simulation0, stores, StoreId, StoreState, Simulation).

annotate_store_universes(Simulation0, StoreId, SourceUniverse, DestinationUniverse, Simulation) :-
    get_sim_dict(Simulation0, stores, StoreId, StoreState0),
    put_dict(_{mutable_state: _{source_universe: SourceUniverse, destination_universe: DestinationUniverse}}, StoreState0, StoreState),
    put_sim_dict(Simulation0, stores, StoreId, StoreState, Simulation).

store_generated_packages(Simulation, [], Simulation).
store_generated_packages(Simulation0, [Package | Rest], Simulation) :-
    Package = simulant_package(PackageId, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
    put_sim_dict(Simulation0, packages, PackageId, Package, Simulation1),
    store_generated_packages(Simulation1, Rest, Simulation).

restore_packages_to_stores(Simulation, _Packages, [], Simulation).
restore_packages_to_stores(Simulation0, Packages, [StoreId | Rest], Simulation) :-
    findall(PackageId, member(simulant_package(PackageId, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _), Packages), PackageIds),
    get_sim_dict(Simulation0, stores, StoreId, StoreState0),
    put_dict(_{packages: PackageIds}, StoreState0, StoreState),
    put_sim_dict(Simulation0, stores, StoreId, StoreState, Simulation1),
    restore_packages_to_stores(Simulation1, Packages, Rest, Simulation).

restore_many_from_packages(Simulation, [], Simulation).
restore_many_from_packages(Simulation0, [simulant_package(_, SimulantId, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _) | Rest], Simulation) :-
    plan_simulant_restore(Simulation0, SimulantId, [], spacetime(earth_lab, instant(2026, 1, 1, 0, 0)), [conflict_policy(create_branch_instance)], RestorePlan),
    execute_simulant_restore(Simulation0, RestorePlan, Simulation1, _),
    restore_many_from_packages(Simulation1, Rest, Simulation).

store_owned_by(Simulation, StoreId, ProjectorId) :-
    get_sim_dict(Simulation, stores, StoreId, StoreState),
    get_dict(store, StoreState, projected_store(_, projector(ProjectorId), _, _, _, _, _, _, _, _, _, _, _, _)).

finite_cycle_limit(StoppingConditions, MaxCycles) :-
    memberchk(max_cycles(MaxCycles), StoppingConditions),
    integer(MaxCycles),
    MaxCycles > 0.

cycle_reset_target(CyclePolicy, TargetCheckpointId) :-
    memberchk(reset_to(checkpoint(TargetCheckpointId)), CyclePolicy),
    !.
cycle_reset_target(_CyclePolicy, origin_seed).

destination_coordinate(spacetime(Location, Instant), Timeline, Coordinate) :-
    canonical_spacetime(spacetime(Location, Instant), Timeline, Coordinate).
destination_coordinate(Coordinate, _Timeline, Coordinate) :-
    Coordinate = spacetime(_, _, _, _).

checkpoint_id(checkpoint(CheckpointId, _, _, _, _, _, _), CheckpointId).

take(_, [], []).
take(0, _, []) :- !.
take(N, [Item | Rest], [Item | Taken]) :-
    N > 0,
    N1 is N - 1,
    take(N1, Rest, Taken).

dict_key(Key, DictKey) :-
    (   var(Key)
    ->  DictKey = Key
    ;   atomic(Key)
    ->  DictKey = Key
    ;   term_to_atom(Key, DictKey)
    ).

next_id_value(Simulation, event, Value) :-
    length(Simulation.events, Count),
    Value is Count + 1.
next_id_value(Simulation, hop, Value) :-
    dict_size(Simulation.hops, Count),
    Value is Count + 1.
next_id_value(Simulation, checkpoint, Value) :-
    dict_size(Simulation.checkpoints, Count),
    Value is Count + 1.
next_id_value(Simulation, memory, Value) :-
    dict_size(Simulation.memory_sets, Count),
    Value is Count + 1.
next_id_value(Simulation, timeline, Value) :-
    dict_size(Simulation.timelines, Count),
    Value is Count + 1.
next_id_value(Simulation, reset, Value) :-
    dict_size(Simulation.pending_resets, Count),
    Value is Count + 1.
next_id_value(Simulation, cycle, Value) :-
    count_total_cycles(Simulation.universes, Count),
    Value is Count + 1.
next_id_value(Simulation, package, Value) :-
    dict_size(Simulation.packages, Count),
    Value is Count + 1.
next_id_value(Simulation, store, Value) :-
    dict_size(Simulation.stores, Count),
    Value is Count + 1.
next_id_value(Simulation, projection, Value) :-
    dict_size(Simulation.stores, Count),
    Value is Count + 1.
next_id_value(Simulation, projector, Value) :-
    dict_size(Simulation.projectors, Count),
    Value is Count + 1.
next_id_value(Simulation, preservation, Value) :-
    dict_size(Simulation.pending_preservations, Count),
    Value is Count + 1.
next_id_value(Simulation, restore, Value) :-
    dict_size(Simulation.traveller_states, Count),
    Value is Count + 1.

spacetime_utime(spacetime(_, UTime, _, _), UTime).

count_total_cycles(Universes, Count) :-
    findall(
        CycleId,
        (
            get_dict(_, Universes, UniverseState),
            get_dict(CycleId, UniverseState.cycles, _)
        ),
        CycleIds
    ),
    length(CycleIds, Count).
