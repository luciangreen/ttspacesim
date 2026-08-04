Below is a complete PROGRAM_REQUIREMENTS.md specification for a new TTSpaceSim project derived from ttsim.

The existing repository describes an SWI-Prolog framework for replaying and branching schedules while preserving chronology, consent, ethical boundaries, and explicit reality labels. It also requires approval before any simulated proposal becomes a real-world action.

TTSpaceSim — GitHub Copilot Agent Prolog Program Requirements

1. Project title

TTSpaceSim: Space-Time Travel Simulation

Suggested repository name:

ttspacesim

TTSpaceSim extends the ttsim Real Time Travel Simulation into a deterministic SWI-Prolog simulation framework for:

* travelling between simulated planets, moons, spacecraft, stations and habitats;
* hopping between different simulated times;
* branching and replaying mission timelines;
* placing bots in compatible environments;
* supplying bots with explicitly labelled synthetic mission memories;
* compressing long journeys into validated checkpoints;
* coordinating local planetary time, universal simulation time and traveller subjective time;
* exploring alternative histories without claiming that literal space travel or time travel occurred.

The program must model space-time travel as a simulation, scheduling and narrative-continuity system. It must not claim to perform physical teleportation, literal time travel, biological replacement, memory implantation or real-world travel.

⸻

2. Primary objective

Implement a Prolog system that can answer and execute simulation requests such as:

?- create_mission(mars_research_01, Mission).
?- add_traveller(Mission, bot(ada), earth, instant(2026,8,4,9,0)).
?- plan_hop(
       Mission,
       bot(ada),
       spacetime(earth, instant(2026,8,4,9,0)),
       spacetime(mars, instant(2032,3,17,14,30)),
       Plan
   ).
?- simulate_hop(Mission, Plan, Result).

The result must describe:

* the departure state;
* destination world and local environment;
* source and destination times;
* travel method;
* elapsed universal time;
* elapsed subjective time;
* generated or imported memories;
* continuity constraints;
* mission changes;
* causal effects;
* unresolved contradictions;
* simulation reality label;
* approval status for any proposed real-world action.

⸻

3. Foundational interpretation

3.1 Meaning of space travel

Within TTSpaceSim, space travel means moving an agent’s simulated state between compatible environments.

Examples include:

* Earth laboratory to lunar base;
* spacecraft cabin to Mars habitat;
* orbital station to an asteroid settlement;
* one virtual planet to another;
* a planetary surface to a simulated spacecraft;
* one representation of a city to the same city in another era.

A destination may be:

planet(Name).
moon(Name).
spacecraft(Name).
station(Name).
habitat(Name).
asteroid(Name).
region(World, Region).
room(Environment, Room).
virtual_world(Name).

3.2 Meaning of time travel

Within TTSpaceSim, time travel means one or more of:

* loading a previous simulation checkpoint;
* projecting a future state;
* branching from an earlier event;
* placing an agent at another point on a simulated timeline;
* replaying omitted events;
* inserting a mission episode into a schedule;
* changing the traveller’s subjective sequence while preserving the master event ledger.

Literal physical time travel is outside the project scope.

3.3 Meaning of a space-time hop

A hop is an atomic transition between two space-time coordinates:

spacetime(Location, Time).

For example:

spacetime(earth, instant(2026,8,4,9,0)).
spacetime(mars, instant(2032,3,17,14,30)).

A hop may change:

* location only;
* time only;
* both location and time;
* timeline branch;
* agent embodiment;
* active environment;
* mission role;
* remembered history.

3.4 Meaning of synthetic memories

Synthetic memories are structured simulation records assigned to software agents to establish mission continuity.

They must always be marked as:

memory_reality(synthetic).

Synthetic memories must never be represented as memories genuinely experienced by a human.

⸻

4. Required technology

The first release must use:

SWI-Prolog

The implementation must:

* run from the SWI-Prolog interpreter;
* use ordinary Prolog source files;
* include PlUnit tests;
* provide command-line demonstrations;
* avoid requiring proprietary services;
* operate locally by default;
* store simulation state in transparent Prolog terms or documented files.

Recommended minimum SWI-Prolog version:

SWI-Prolog 9.x

Do not require another programming language for the core simulation.

⸻

5. Relationship to ttsim

TTSpaceSim must preserve the following ttsim concepts:

* real chronology;
* consent;
* legal and ethical constraints;
* reality labels;
* separation of simulation from real-world execution;
* explicit approval before promotion to a real action;
* replayable and branchable schedules.

The initial supported reality labels must be:

real.
scheduled.
simulated.
fictional.
projected.
provisional.
synthetic.
archived.
counterfactual.

Every event, memory, environment, traveller state and output must carry a reality label.

⸻

6. Core design principles

6.1 Simulation before assertion

The system must simulate outcomes without asserting that they happened in reality.

6.2 Explicit coordinate systems

Every event must be traceable through:

* universal simulation time;
* local planetary time;
* traveller subjective time;
* timeline branch;
* location.

6.3 No hidden continuity changes

Any synthetic memory, skipped journey, reconstructed event or timeline alteration must be visible in the event ledger.

6.4 Deterministic state transitions

Given identical:

* initial state;
* scenario;
* random seed;
* rules;
* hop plan;

the simulator must produce the same result.

6.5 Compatibility before placement

An agent must not be placed in an environment until the system verifies that the agent representation is compatible with it.

6.6 Chronology preservation

Events must retain their original timestamps even when a traveller experiences them in another subjective order.

6.7 Branch rather than overwrite

Changing an earlier simulated event must create a new branch unless an explicit administrative operation requests a revision of fictional data.

6.8 Human safety and consent

No simulation of a recognisable real person may be activated without an associated consent record or an explicit fictionalisation rule.

⸻

7. Proposed source layout

ttspacesim/
├── README.md
├── PROGRAM_REQUIREMENTS.md
├── LICENSE
├── pack.pl
├── src/
│   ├── ttspacesim.pl
│   ├── spacetime.pl
│   ├── coordinates.pl
│   ├── celestial_catalogue.pl
│   ├── environments.pl
│   ├── travellers.pl
│   ├── missions.pl
│   ├── routes.pl
│   ├── hop_planner.pl
│   ├── hop_executor.pl
│   ├── clocks.pl
│   ├── timelines.pl
│   ├── branches.pl
│   ├── event_ledger.pl
│   ├── checkpoints.pl
│   ├── synthetic_memories.pl
│   ├── continuity.pl
│   ├── compatibility.pl
│   ├── causality.pl
│   ├── resources.pl
│   ├── schedules.pl
│   ├── consent.pl
│   ├── reality_labels.pl
│   ├── approvals.pl
│   ├── validation.pl
│   ├── diagnostics.pl
│   ├── persistence.pl
│   └── demos.pl
├── data/
│   ├── celestial_bodies.pl
│   ├── environments.pl
│   ├── example_routes.pl
│   └── example_missions.pl
├── test/
│   ├── run_tests.pl
│   ├── test_coordinates.pl
│   ├── test_clocks.pl
│   ├── test_hops.pl
│   ├── test_timelines.pl
│   ├── test_memories.pl
│   ├── test_continuity.pl
│   ├── test_compatibility.pl
│   ├── test_causality.pl
│   ├── test_consent.pl
│   └── test_integration.pl
└── examples/
    ├── earth_to_mars.pl
    ├── lunar_time_branch.pl
    ├── interstellar_checkpoint.pl
    └── synthetic_crew_history.pl

⸻

8. Principal data model

8.1 Simulation

simulation(
    SimulationId,
    Title,
    RootTimeline,
    RealityLabel,
    Status,
    Metadata
).

Example:

simulation(
    sim_001,
    "Mars Habitat Continuity Trial",
    timeline(main),
    simulated,
    active,
    [created_by(user), seed(42)]
).

8.2 Space-time coordinate

spacetime(
    Location,
    UniversalTime,
    LocalTime,
    Timeline
).

Example:

spacetime(
    habitat(mars, ares_1),
    utime(2032,3,17,4,30,0),
    local_time(mars, 2032, sol(181), 14, 30, 0),
    timeline(main)
).

A shorter accepted input form may be:

spacetime(Location, Instant).

The normaliser must convert this into the complete canonical form.

8.3 Location

location(
    LocationId,
    LocationType,
    ParentBody,
    CoordinateSystem,
    Coordinates,
    EnvironmentId,
    RealityLabel
).

8.4 Traveller

traveller(
    TravellerId,
    TravellerType,
    Identity,
    CurrentState,
    ConsentProfile,
    RealityLabel
).

Supported traveller types:

software_agent.
robot.
avatar.
fictional_character.
abstract_mission_role.
consenting_human_representation.

The first version must not control a real human body or physical vehicle.

8.5 Traveller state

traveller_state(
    TravellerId,
    SpaceTime,
    Embodiment,
    HealthModel,
    MissionRole,
    ActiveMemories,
    Inventory,
    SubjectiveClock,
    Status
).

8.6 Environment

environment(
    EnvironmentId,
    Location,
    Atmosphere,
    Gravity,
    TemperatureRange,
    Radiation,
    Pressure,
    AvailableEmbodiments,
    Resources,
    Capabilities,
    RealityLabel
).

8.7 Mission

mission(
    MissionId,
    Name,
    Objectives,
    Participants,
    StartCoordinate,
    IntendedEndCoordinate,
    Schedule,
    Constraints,
    RealityLabel,
    Status
).

8.8 Hop

hop(
    HopId,
    TravellerId,
    Source,
    Destination,
    TravelMode,
    TimelinePolicy,
    MemoryPolicy,
    ResourcePolicy,
    ApprovalPolicy,
    Status
).

8.9 Event

event(
    EventId,
    EventType,
    Actors,
    SpaceTime,
    Preconditions,
    Effects,
    RealityLabel,
    Evidence,
    Provenance
).

8.10 Synthetic memory

synthetic_memory(
    MemoryId,
    TravellerId,
    Proposition,
    SourceEvents,
    ValidInterval,
    Confidence,
    Salience,
    RealityLabel,
    Provenance
).

Required reality label:

synthetic

Example:

synthetic_memory(
    memory_204,
    bot(ada),
    repaired(oxygen_recycler_2),
    [event_871, event_872],
    interval(utime(2032,3,10,0,0,0), utime(2032,3,10,3,0,0)),
    0.98,
    mission_critical,
    synthetic,
    generated_from_checkpoint(checkpoint_19)
).

8.11 Checkpoint

checkpoint(
    CheckpointId,
    SimulationId,
    SpaceTime,
    WorldState,
    TravellerStates,
    RequiredHistory,
    StateHash,
    RealityLabel
).

8.12 Timeline branch

timeline_branch(
    BranchId,
    ParentBranch,
    DivergenceEvent,
    DivergenceTime,
    BranchPolicy,
    RealityLabel
).

⸻

9. Time systems

TTSpaceSim must distinguish at least four forms of time.

9.1 Universal simulation time

A monotonically ordered time used for the master ledger:

utime(Year, Month, Day, Hour, Minute, Second).

9.2 Local planetary time

Planet-specific representation:

local_time(Body, LocalCalendar).

Examples:

local_time(earth, datetime(2032,3,17,14,30,0)).
local_time(mars, mars_date(Year, Sol, Hour, Minute, Second)).

9.3 Traveller subjective time

Tracks the amount and order of time experienced by the traveller:

subjective_time(TravellerId, Tick).

This permits:

* suspended travellers;
* accelerated narrative time;
* compressed journeys;
* reconstructed histories;
* agents loaded from checkpoints.

9.4 Timeline-relative time

A branch-specific coordinate:

branch_time(TimelineId, UniversalTime).

⸻

10. Required travel modes

The simulator must support the following travel modes.

10.1 Conventional simulated travel

conventional(Duration, Vehicle).

All intermediate events may be simulated.

10.2 Compressed journey

compressed(Duration, CheckpointPolicy).

The simulator computes only causally important intervals and creates a validated checkpoint.

10.3 Checkpoint hop

checkpoint_hop(CheckpointId).

The destination state is restored from a checkpoint.

10.4 Projected future hop

projected_hop(Model, ConfidenceThreshold).

The destination is a provisional future generated by simulation.

10.5 Historical replay hop

replay_hop(SourceEvent, TargetEvent).

The system reconstructs a prior simulation interval.

10.6 Timeline branch hop

branch_hop(ParentTimeline, NewTimeline, DivergenceEvent).

10.7 Narrative instant hop

instant_hop.

This updates the agent’s simulation coordinate immediately but must record:

* that no physical journey was modelled;
* which history was skipped;
* how continuity was established;
* which memories were generated;
* which destination assumptions remain provisional.

10.8 Interstellar hop

interstellar_hop(RouteModel, DurationModel).

The first release treats this as a fictional or projected simulation operation. It must not claim faster-than-light travel is physically available.

⸻

11. Hop planning predicates

The following public predicates are required:

create_hop(+TravellerId, +Source, +Destination, +Options, -Hop).
validate_hop(+Simulation, +Hop, -Validation).
plan_hop(+Simulation, +Hop, -Plan).
simulate_hop(+Simulation0, +Plan, -Simulation, -Result).
cancel_hop(+Simulation0, +HopId, -Simulation, -Result).
explain_hop(+Plan, -Explanation).

A hop plan must include:

hop_plan(
    HopId,
    NormalisedSource,
    NormalisedDestination,
    Route,
    TravelMode,
    Duration,
    RequiredResources,
    CompatibilityActions,
    TimelineActions,
    MemoryActions,
    ScheduledEvents,
    Preconditions,
    ExpectedEffects,
    Risks,
    RealityLabel
).

⸻

12. Hop validation

Before a hop is executed, validate all of the following.

12.1 Traveller exists

known_traveller(TravellerId).

12.2 Source state agrees with the ledger

The traveller cannot depart from a location where it is not currently recorded unless the hop is explicitly a reconstruction.

12.3 Destination exists

Unknown destinations may only be used when created as:

fictional

or:

provisional

12.4 Environment compatibility

Verify:

* embodiment;
* atmosphere;
* pressure;
* gravity;
* temperature;
* radiation;
* communication protocol;
* power;
* mobility;
* sensory interfaces;
* computational platform;
* required language model or ruleset.

12.5 Timeline compatibility

Verify that:

* the destination branch exists or is being created;
* the destination time is representable;
* causally dependent events are handled;
* duplicate traveller instances are prevented or explicitly modelled;
* branch policies are followed.

12.6 Memory compatibility

Verify that synthetic memories:

* do not contradict validated destination evidence;
* cite source events;
* are labelled synthetic;
* concern only the assigned agent;
* do not falsely represent human experiences;
* are sufficient for mission continuity;
* do not exceed the configured uncertainty threshold.

12.7 Consent

A real-person representation requires explicit consent covering:

* identity use;
* time period;
* scenario type;
* memory generation;
* publication;
* interaction with other participants.

12.8 Resources

Verify that the destination can support the agent state.

12.9 Approval

Any proposed real-world follow-up must remain pending until explicitly promoted.

⸻

13. Environment compatibility

Required predicates:

environment_compatible(+TravellerState, +Environment, -Report).
required_adaptations(+TravellerState, +Environment, -Adaptations).
apply_adaptations(+TravellerState0, +Adaptations, -TravellerState).
compatible_embodiment(+Traveller, +Environment, -Embodiment).

Compatibility reports must use:

compatibility_report(
    OverallStatus,
    PassedChecks,
    FailedChecks,
    RequiredAdaptations,
    Warnings
).

Statuses:

compatible.
compatible_with_adaptations.
incompatible.
unknown.

Example:

required_adaptations(
    traveller_state(bot(ada), _, terrestrial_robot, _, _, _, _, _, _),
    mars_habitat,
    [
        embodiment_swap(mars_indoor_robot),
        radiation_shielding(level_2),
        local_clock_adapter(mars_sol_clock)
    ]
).

⸻

14. Embodiment transfer

The simulator may represent the same software agent through different simulated embodiments.

Required predicate:

transfer_embodiment(
    +Agent,
    +SourceEmbodiment,
    +DestinationEmbodiment,
    +Policy,
    -TransferRecord
).

The transfer record must preserve:

* agent identity;
* software version;
* memories;
* mission role;
* permissions;
* subjective time;
* prior embodiment;
* new embodiment;
* continuity hash;
* reality label.

The system must not describe embodiment transfer as biological replacement or literal consciousness transfer.

Duplicate active embodiments must be rejected by default.

Optional explicit policy:

allow_parallel_instances(InstancePolicy).

Parallel instances must receive distinct instance identifiers.

⸻

15. Synthetic-memory subsystem

15.1 Objective

Generate the smallest coherent set of synthetic memories needed for an agent to operate consistently at the destination.

15.2 Required predicates

generate_memory_set(
    +Traveller,
    +SourceState,
    +DestinationState,
    +Mission,
    +Policy,
    -Memories
).
validate_memory_set(
    +Memories,
    +DestinationState,
    +Ledger,
    -Report
).
compress_history(
    +Events,
    +MissionObjectives,
    +Policy,
    -RequiredEvents
).
install_synthetic_memories(
    +TravellerState0,
    +Memories,
    -TravellerState
).
explain_memory(
    +MemoryId,
    -Explanation
).

15.3 Memory policies

Support:

no_new_memories.
mission_critical_only.
causal_minimum.
social_continuity.
full_checkpoint_summary.
user_selected(EventIds).

15.4 Memory contents

A synthetic memory may describe:

* training;
* repairs;
* discoveries;
* prior conversations;
* schedule changes;
* mission decisions;
* relationships between fictional agents;
* destination procedures;
* route history;
* emergencies;
* inventory changes;
* scientific observations;
* previously completed objectives.

15.5 Prohibited memory operations

Reject requests to:

* implant memories in real people;
* alter a real person’s recollection;
* erase a real person’s memories;
* fabricate evidence of real-world events;
* impersonate a person without consent;
* relabel synthetic memories as real.

15.6 Memory contradiction detection

Required predicate:

memory_contradiction(+MemoryA, +MemoryB, -Reason).

Detect contradictions involving:

* location;
* time;
* participant identity;
* object state;
* completed task;
* casualty status;
* resource quantity;
* branch membership;
* mission role;
* causal order.

⸻

16. History compression

A long simulated journey may be reduced to causally necessary milestones.

Required predicate:

compress_journey(
    +InitialState,
    +FinalState,
    +CandidateEvents,
    +Objectives,
    -CompressedHistory
).

The compressed history must retain every event necessary to explain:

* the final traveller state;
* destination resources;
* mission progress;
* agent knowledge;
* active relationships;
* unresolved faults;
* causal dependencies;
* legal or consent status.

It may omit routine events that have no effect on the destination state.

The output format must be:

compressed_history(
    IncludedEvents,
    OmittedIntervals,
    DerivedMemories,
    ProofObligations,
    Confidence
).

⸻

17. Timeline branching

Required predicates:

create_timeline(+Simulation0, +ParentTimeline, +DivergencePoint,
                +Options, -Simulation, -Timeline).
switch_timeline(+Simulation0, +Traveller, +Timeline,
                -Simulation, -Result).
merge_timelines(+Simulation0, +TimelineA, +TimelineB,
                +Policy, -Simulation, -MergeReport).
compare_timelines(+Simulation, +TimelineA, +TimelineB,
                  -Differences).

17.1 Default branch rule

A change to an event earlier than the current head creates a branch.

17.2 No automatic paradox repair

Contradictions must be reported. They must not silently disappear.

17.3 Supported timeline policies

branch_on_change.
immutable_history.
editable_fiction.
projected_only.
replay_only.

17.4 Timeline merging

Merging must be allowed only for compatible fictional or simulated branches.

Real-history records must not be rewritten by a simulated merge.

⸻

18. Causality model

Every state-changing event must declare:

preconditions.
effects.
dependencies.

Required predicates:

causally_depends_on(+Event, +EarlierEvent).
causal_path(+StartEvent, +EndEvent, -Path).
validate_causal_order(+Timeline, -Report).
detect_causal_cycle(+Timeline, -Cycle).
affected_events(+ChangedEvent, -AffectedEvents).

A historical change must trigger recalculation of dependent simulated events.

The first release should use a directed acyclic event dependency graph where possible.

Recursive cycles must be diagnosed rather than executed indefinitely.

⸻

19. Traveller continuity

Required predicate:

continuity_report(
    +Traveller,
    +SourceState,
    +DestinationState,
    +HopPlan,
    -Report
).

The continuity report must assess:

* identity continuity;
* memory continuity;
* mission continuity;
* embodiment continuity;
* temporal continuity;
* social continuity;
* inventory continuity;
* permissions continuity;
* software-version continuity;
* unresolved discontinuities.

Possible results:

continuous.
continuous_with_synthetic_history.
continuous_with_declared_gap.
branch_instance.
inconsistent.

⸻

20. Planetary and celestial catalogue

The catalogue must permit facts such as:

celestial_body(
    mars,
    planet,
    sun,
    orbital_model(keplerian, Parameters),
    rotation_model(mars_standard),
    gravity(3.721),
    reality(real)
).

Catalogue entries may be:

real.
fictional.
projected.

The catalogue must not imply precision beyond the supplied model.

Required predicates:

known_body(+Body).
body_type(+Body, -Type).
parent_body(+Body, -Parent).
body_environment(+Body, -Environment).
local_time_model(+Body, -Model).
distance_model(+BodyA, +BodyB, +Time, -Distance).

Astronomical models may be simplified in the initial release, but simplifications must be documented.

⸻

21. Route planning

Required predicates:

route(+Source, +Destination, +DepartureTime, +Options, -Route).
route_duration(+Route, -Duration).
route_requirements(+Route, -Requirements).
route_risks(+Route, -Risks).

Supported route forms:

direct_route(Source, Destination).
waypoint_route([Location1, Location2, Location3]).
checkpoint_route([Checkpoint1, Checkpoint2]).
branch_route(Timeline, Route).

The planner must separate:

* physical-model route;
* simulated instant transition;
* fictional route;
* projected route.

⸻

22. Mission scheduling

Required predicates:

schedule_mission(+Mission0, +Constraints, -Mission).
schedule_event(+Simulation0, +Event, -Simulation).
reschedule_event(+Simulation0, +EventId, +NewTime,
                 -Simulation, -Result).
detect_schedule_conflicts(+Simulation, -Conflicts).

Scheduling must distinguish:

* immovable events;
* movable appointments;
* travel windows;
* planetary local-time constraints;
* communication delay;
* sleep or maintenance periods;
* resource availability;
* dependencies;
* traveller subjective availability.

Immovable events take priority unless explicitly overridden in a fictional branch.

⸻

23. Communication across planets and times

Messages must carry:

message(
    MessageId,
    Sender,
    Recipient,
    SentSpaceTime,
    ArrivalSpaceTime,
    Content,
    RealityLabel,
    Status
).

Required predicates:

send_simulated_message(+Simulation0, +Message, -Simulation).
calculate_message_arrival(+Message, +CommunicationModel,
                          -ArrivalSpaceTime).
deliver_due_messages(+Simulation0, +CurrentTime, -Simulation,
                     -Delivered).

Support:

instant_simulated.
light_delay.
configured_delay(Duration).
checkpoint_delivery.
timeline_local.

An instant simulated message must not be represented as proof of physically instantaneous communication.

⸻

24. Resources and inventories

Required predicates:

resource_available(+State, +Resource, +Quantity).
consume_resource(+State0, +Resource, +Quantity, -State).
produce_resource(+State0, +Resource, +Quantity, -State).
transfer_resource(+State0, +From, +To, +Resource, +Quantity,
                  -State).

Resources may include:

* power;
* oxygen;
* water;
* food;
* fuel;
* computing capacity;
* storage;
* spare parts;
* communication bandwidth;
* simulation credits;
* crew time.

No resource quantity may become negative.

⸻

25. Reality-labelling system

Required predicates:

valid_reality_label(+Label).
reality_label(+Object, -Label).
set_reality_label(+Object0, +Label, -Object).
may_promote_reality(+From, +To).

Default promotion rules:

fictional     -> simulated
projected     -> scheduled
provisional   -> scheduled
scheduled     -> real
synthetic     -> simulated_record

Promotion to real must require an explicit approval record and verification that the action actually occurred.

Synthetic memories must never be promoted to real memories.

⸻

26. Consent model

Required structure:

consent_record(
    ConsentId,
    Subject,
    PermittedUses,
    ProhibitedUses,
    ValidFrom,
    ValidUntil,
    RevocationStatus,
    Evidence
).

Required predicates:

has_consent(+Subject, +Use, +Time).
validate_consent(+Scenario, -Report).
revoke_consent(+State0, +ConsentId, -State).

When consent is absent, the simulator must either:

* reject the representation; or
* replace the person with a fictional, non-identifying character.

⸻

27. Real-world action approval

Required predicates:

propose_real_action(+Simulation, +Action, -Proposal).
promote_to_real_action(+Proposal, +Approval, -Result).
reject_real_action(+Proposal, +Reason, -Result).

Promotion must not execute the action automatically in version 1.

It should only produce an approved action record suitable for later review.

⸻

28. Main simulation transition

The canonical transition predicate must be:

step(+Simulation0, +Command, -Simulation, -Result).

Example commands:

create_mission(Mission).
register_traveller(Traveller).
plan_hop(HopRequest).
execute_hop(HopId).
create_checkpoint(Options).
load_checkpoint(CheckpointId).
branch_timeline(DivergencePoint).
install_memories(TravellerId, MemoryPolicy).
advance_time(Duration).

step/4 must:

1. validate the command;
2. inspect consent;
3. inspect reality labels;
4. inspect chronology;
5. verify preconditions;
6. compute the deterministic transition;
7. append events to the ledger;
8. validate the resulting state;
9. return diagnostics;
10. leave the input state unchanged if validation fails.

⸻

29. Event ledger

The ledger must be append-only during ordinary simulation execution.

Required predicates:

append_event(+Ledger0, +Event, -Ledger).
event_by_id(+Ledger, +EventId, -Event).
events_between(+Ledger, +Start, +End, -Events).
events_for_traveller(+Ledger, +Traveller, -Events).
events_on_timeline(+Ledger, +Timeline, -Events).
verify_ledger(+Ledger, -Report).

Each event must have:

* a unique identifier;
* timestamp;
* branch;
* reality label;
* provenance;
* actors;
* preconditions;
* effects.

Administrative corrections must create correction events rather than invisibly deleting history.

⸻

30. Checkpoints

Required predicates:

create_checkpoint(+Simulation, +Options, -Checkpoint).
validate_checkpoint(+Checkpoint, -Report).
restore_checkpoint(+Checkpoint, -Simulation).
compare_checkpoint(+Checkpoint, +Simulation, -Differences).

Checkpoint validation must confirm:

* referenced events exist;
* traveller states agree with the ledger;
* inventories are valid;
* active memories cite valid sources;
* timeline identifiers exist;
* reality labels are preserved;
* the state hash matches.

⸻

31. Persistence

Required predicates:

save_simulation(+File, +Simulation).
load_simulation(+File, -Simulation).
save_checkpoint(+File, +Checkpoint).
load_checkpoint_file(+File, -Checkpoint).

Persistence must:

* use a documented format;
* reject unsafe executable terms;
* validate loaded data;
* preserve version metadata;
* support migration diagnostics.

Do not execute arbitrary goals while loading a simulation file.

⸻

32. Diagnostics

Errors must be structured:

diagnostic(
    Severity,
    Code,
    Message,
    Context,
    SuggestedAction
).

Required severities:

info.
warning.
error.
fatal.

Example:

diagnostic(
    error,
    incompatible_environment,
    "The current embodiment cannot operate in the destination atmosphere.",
    hop(hop_12),
    add_adaptation(pressurised_embodiment)
).

Required error classes include:

unknown_traveller
unknown_location
invalid_time
invalid_timeline
source_state_mismatch
destination_incompatible
missing_consent
memory_contradiction
causal_cycle
duplicate_active_instance
insufficient_resources
invalid_reality_promotion
checkpoint_invalid
schedule_conflict
unbounded_simulation
unsupported_construct

⸻

33. Explanation facilities

Every major decision must be explainable.

Required predicates:

explain_result(+Result, -Explanation).
explain_failure(+Diagnostic, -Explanation).
explain_timeline(+Timeline, -Explanation).
explain_continuity(+ContinuityReport, -Explanation).
explain_route(+Route, -Explanation).

Explanations should identify:

* facts used;
* rules applied;
* assumptions;
* uncertainty;
* rejected alternatives;
* reality status.

⸻

34. Determinism and termination

The implementation must avoid accidental nondeterminism in public state-transition predicates.

For each public predicate, document whether it is:

det
semidet
multi
nondet

State transitions must normally be det or semidet.

The simulator must detect or limit:

* unbounded recursive timelines;
* endlessly generated events;
* circular causal dependencies;
* recursive checkpoint loading;
* infinite hop chains;
* uncontrolled branch creation;
* endlessly expanding memory histories.

Configurable limits may include:

max_events(100000).
max_branches(1000).
max_hops_per_command(100).
max_causal_depth(1000).
max_memory_count_per_agent(10000).

⸻

35. Initial public API

The principal module should export at least:

:- module(ttspacesim, [
    new_simulation/2,
    step/4,
    run_demo/0,
    create_mission/3,
    register_traveller/3,
    create_hop/5,
    validate_hop/3,
    plan_hop/3,
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
    promote_to_real_action/3
]).

⸻

36. Required command-line demonstrations

36.1 Basic demo

swipl -q -s src/ttspacesim.pl -g run_demo -t halt

36.2 Earth-to-Mars demo

swipl -q -s examples/earth_to_mars.pl -g run -t halt

The demo must:

1. create a mission;
2. register a software agent;
3. create Earth and Mars environments;
4. plan an Earth-to-Mars hop;
5. identify required adaptations;
6. compress the journey;
7. create synthetic mission memories;
8. install the memories;
9. place the bot in the Mars habitat;
10. print a continuity report;
11. label the result simulated.

36.3 Timeline branch demo

The program must branch from a mission failure and compare:

* the original outcome;
* a repaired outcome;
* changed memories;
* affected later events.

36.4 Interstellar fictional demo

The program may hop to a fictional exoplanet but must print:

Reality: fictional simulation
No claim of real interstellar travel is made.

⸻

37. Example expected interaction

?- new_simulation(space_demo, S0),
   step(S0,
        register_traveller(
            traveller(
                bot(ada),
                software_agent,
                ada,
                initial,
                consent_not_applicable,
                simulated
            )
        ),
        S1,
        R1),
   step(S1,
        plan_hop(
            hop_request(
                bot(ada),
                spacetime(earth_lab, instant(2026,8,4,9,0)),
                spacetime(mars_habitat, instant(2032,3,17,14,30)),
                [
                    travel_mode(compressed),
                    memory_policy(causal_minimum),
                    timeline_policy(branch_on_change)
                ]
            )
        ),
        S2,
        Result).
Result = hop_planned(
    hop_1,
    simulated,
    adaptations([
        embodiment_swap(mars_habitat_robot),
        local_clock_adapter(mars_sol_clock)
    ]),
    memory_plan(causal_minimum),
    warnings([])
).

⸻

38. Required tests

Use PlUnit.

38.1 Coordinate tests

Test:

* valid Earth date;
* invalid date;
* local-to-universal conversion;
* universal-to-local conversion;
* Mars local time;
* branch time;
* time ordering.

38.2 Hop tests

Test:

* location-only hop;
* future-time hop;
* past-time branch hop;
* planet-and-time hop;
* incompatible destination;
* missing source state;
* duplicate agent;
* unknown destination;
* fictional destination;
* compressed journey;
* checkpoint restoration.

38.3 Memory tests

Test:

* coherent memory set;
* contradictory memories;
* missing source event;
* synthetic label enforcement;
* minimal causal memories;
* social continuity memories;
* attempted promotion to real memory;
* attempted assignment to a human without consent.

38.4 Timeline tests

Test:

* branch creation;
* divergence event;
* affected-event recalculation;
* branch comparison;
* incompatible merge;
* valid fictional merge;
* protection of real-history records.

38.5 Compatibility tests

Test:

* compatible robot;
* adaptation required;
* incompatible embodiment;
* insufficient power;
* unsupported communication protocol;
* suitable replacement embodiment.

38.6 Causality tests

Test:

* causal path;
* missing dependency;
* cycle detection;
* changed-event propagation;
* stable event ordering.

38.7 Resource tests

Test:

* valid consumption;
* invalid negative quantity;
* transfer;
* insufficient resource;
* resource production;
* checkpoint inventory consistency.

38.8 Consent tests

Test:

* valid consent;
* expired consent;
* revoked consent;
* prohibited use;
* fictional replacement;
* publication not authorised.

38.9 Persistence tests

Test:

* save and load;
* state equality;
* invalid state hash;
* unsafe term rejection;
* version migration warning.

38.10 Integration tests

At minimum, implement:

1. Earth to Mars compressed journey;
2. Moon mission replay;
3. Mars failure timeline branch;
4. fictional interstellar hop;
5. checkpoint arrival with synthetic memories;
6. environment incompatibility rejection;
7. human representation rejected without consent;
8. proposal promoted to scheduled but not automatically executed;
9. deterministic rerun with the same seed;
10. complete event-ledger verification.

⸻

39. Required invariants

The test suite must verify these invariants after every successful transition:

invariant(unique_event_ids).
invariant(unique_active_traveller_instances).
invariant(valid_reality_labels).
invariant(nonnegative_resources).
invariant(valid_timeline_references).
invariant(valid_memory_sources).
invariant(synthetic_memories_labelled).
invariant(consent_requirements_satisfied).
invariant(ledger_chronology_valid).
invariant(no_unapproved_real_actions).
invariant(checkpoint_hashes_valid).

⸻

40. Performance requirements

The first version should handle, on an ordinary desktop computer:

* 10,000 events;
* 100 travellers;
* 100 environments;
* 100 timeline branches;
* 1,000 synthetic memories per traveller;
* causal-path queries over the event graph;
* checkpoint save and restore.

Performance tests must report:

* event insertion time;
* hop-planning time;
* memory-validation time;
* checkpoint creation time;
* branch-comparison time;
* peak memory use where practical.

Correctness takes priority over aggressive optimisation.

⸻

41. Security requirements

The system must:

* never call arbitrary goals loaded from a data file;
* validate all deserialised terms;
* reject path traversal in file operations;
* avoid shell execution in the core engine;
* avoid network access by default;
* keep approval operations explicit;
* preserve provenance;
* avoid hidden mutation through unrestricted dynamic predicates.

Dynamic predicates may be used internally only when justified and encapsulated. Prefer explicit state threading.

⸻

42. Documentation requirements

Produce:

README.md
PROGRAM_REQUIREMENTS.md
ARCHITECTURE.md
DATA_MODEL.md
SAFETY.md
EXAMPLES.md
API.md
TESTING.md

The README must clearly state:

* this is a simulation;
* no literal time travel is performed;
* no literal teleportation is performed;
* no biological consciousness transfer is performed;
* synthetic memories are agent simulation data;
* real-world actions require separate approval and execution;
* fictional astronomical models may be used.

⸻

43. GitHub Copilot Agent implementation workflow

The Copilot Agent must implement the project in stages.

For every stage:

1. inspect the existing repository;
2. state the files to be changed;
3. implement the smallest coherent feature set;
4. add tests;
5. run the complete test suite;
6. repair failures without weakening tests;
7. update documentation;
8. review determinism and safety;
9. update IMPLEMENTATION_PROGRESS.md;
10. continue until the stage acceptance criteria pass.

Do not change intended semantics merely to make a test pass.

⸻

44. Implementation stages

Stage 1 — Repository foundation

Implement:

* directory structure;
* main module;
* simulation state;
* reality labels;
* diagnostics;
* basic tests;
* command-line runner.

Acceptance:

run_demo/0 succeeds.
All initial tests pass.

Stage 2 — Coordinates and clocks

Implement:

* universal time;
* local time;
* space-time coordinates;
* time comparison;
* planetary clock adapters.

Acceptance:

Earth and Mars sample times convert deterministically.
Invalid dates are rejected.

Stage 3 — Travellers and environments

Implement:

* traveller records;
* environment records;
* embodiments;
* compatibility checks;
* adaptations.

Acceptance:

Compatible, adaptable and incompatible cases are distinguished.

Stage 4 — Missions and schedules

Implement:

* missions;
* objectives;
* event scheduling;
* immovable events;
* conflict detection.

Acceptance:

Conflicting mission events produce structured diagnostics.

Stage 5 — Hop planner

Implement:

* hop requests;
* source and destination validation;
* route plans;
* travel modes;
* resource requirements.

Acceptance:

Earth-to-Mars plans are reproducible and explainable.

Stage 6 — Timeline branches

Implement:

* branch creation;
* divergence;
* timeline switching;
* comparison;
* protection of real-history records.

Acceptance:

Past changes create branches rather than overwriting history.

Stage 7 — Event ledger and causality

Implement:

* append-only ledger;
* dependencies;
* causal paths;
* affected-event propagation;
* cycle detection.

Acceptance:

The ledger rejects causal cycles and invalid references.

Stage 8 — Checkpoints

Implement:

* checkpoint creation;
* state hashing;
* validation;
* restoration;
* comparison.

Acceptance:

Restoring a valid checkpoint reproduces its state.

Stage 9 — Synthetic memories

Implement:

* memory records;
* causal history compression;
* memory generation;
* contradiction detection;
* installation into software-agent states.

Acceptance:

A bot can arrive at a checkpoint with a coherent, labelled mission history.

Stage 10 — Hop execution

Implement:

* transactional execution;
* adaptations;
* embodiment transfer;
* memory installation;
* ledger events;
* continuity reports.

Acceptance:

A complete space-time hop either commits validly or leaves the source state unchanged.

Stage 11 — Consent and approvals

Implement:

* consent records;
* validation;
* revocation;
* fictional replacement;
* real-action proposals;
* explicit promotion.

Acceptance:

A real-person representation without consent is rejected.
No simulation output automatically becomes a real action.

Stage 12 — Persistence

Implement:

* safe save;
* safe load;
* version metadata;
* migration diagnostics;
* unsafe-term rejection.

Acceptance:

Saved simulations round-trip without changing their canonical state.

Stage 13 — Demonstrations and integration

Implement all required demonstrations and integration tests.

Acceptance:

All demos run from documented commands.
All tests pass.

Stage 14 — Final audit

Review:

* determinism;
* termination;
* security;
* consent;
* reality labels;
* memory provenance;
* chronology;
* test coverage;
* documentation.

Produce:

FINAL_AUDIT.md

⸻

45. Copilot Agent behavioural instructions

The GitHub Copilot Agent must:

* prefer simple, readable Prolog;
* use explicit state passing;
* avoid unnecessary metaprogramming;
* avoid cuts unless their determinism is formally obvious and documented;
* avoid hidden side effects;
* keep public predicates small;
* provide predicate comments with modes and determinism;
* produce structured errors rather than printing from library predicates;
* isolate UI printing from the simulation engine;
* preserve left-to-right event ordering;
* keep generated identifiers deterministic under a fixed state;
* add tests before considering a feature complete;
* avoid speculative physical claims.

When requirements are ambiguous, choose the design that best preserves:

1. safety;
2. explicit simulation status;
3. chronology;
4. determinism;
5. inspectability;
6. simplicity.

⸻

46. Definition of done

The project is complete when:

* the documented module API exists;
* all required data models are implemented;
* bots can hop between simulated planetary environments;
* hops can change location, time and timeline;
* long journeys can be compressed into checkpoints;
* coherent synthetic memories can be generated and validated;
* environment compatibility is checked before placement;
* timeline branches preserve their parent history;
* causal contradictions are reported;
* consent is enforced;
* every object carries a reality label;
* no synthetic memory can be promoted to a real memory;
* no real-world action is automatically executed;
* save and restore are safe;
* demonstrations run successfully;
* the complete PlUnit suite passes;
* FINAL_AUDIT.md reports no unresolved critical defects.

⸻

47. Core conjecture implemented by TTSpaceSim

TTSpaceSim tests the following computational conjecture:

Given a compatible simulated environment, a coherent synthetic history, a validated destination checkpoint and an agent whose decisions depend on structured memories, the system can approximate the behavioural continuity of a long-duration space journey without simulating every preceding moment.

The program should evaluate the conjecture by comparing:

* agents with no prior mission memories;
* agents with random memories;
* agents with coherent causal memories;
* agents produced by full event-by-event simulation.

Suggested metrics include:

metric(mission_task_accuracy).
metric(schedule_adherence).
metric(memory_consistency).
metric(resource_decision_accuracy).
metric(fault_diagnosis_accuracy).
metric(role_continuity).
metric(social_continuity).
metric(contradiction_count).
metric(history_compression_ratio).

The experiment must report simulation results without treating them as evidence that literal space-time travel occurred.

A key architectural choice is to model each journey as a transactional transformation:

Simulation0 + ValidatedHopPlan -> Simulation1 + LedgerEvents

This makes planetary hopping, time branching, checkpoint restoration and synthetic-memory creation inspectable rather than hidden.

Add the following sections to PROGRAM_REQUIREMENTS.md. They extend TTSpaceSim with universe-cycle resets, practically unbounded simulated time, distributed simulant backups, independently projected stores, and bot projectors.

TTSpaceSim Requirements Update: Universe Resets and Projected Simulant Stores

48. Universe-cycle simulation

TTSpaceSim must support resetting a simulated universe to an earlier checkpoint so that the system can continue running through repeated universe cycles.

This feature represents:

* checkpoint restoration;
* timeline branching;
* deterministic or varied replay;
* long-duration simulation;
* repeated cosmological cycles;
* preservation of selected simulant information between cycles.

It must not claim that the physical universe has been reset or that literal infinite time has been produced.

A universe reset must create a new simulation cycle rather than destructively erasing the previous cycle.

⸻

49. Meaning of simulated infinite time

“Infinite time” must be implemented operationally as an indefinitely extensible sequence of finite simulation cycles.

The system must not attempt to materialise an actually infinite data structure, event list or execution.

The canonical model is:

universe_cycle(0) ->
universe_cycle(1) ->
universe_cycle(2) ->
...

Each cycle must:

1. start from a validated universe checkpoint;
2. run for a finite interval or until a stopping condition;
3. produce a cycle-end checkpoint;
4. preserve configured data;
5. reset or branch to an earlier universe time;
6. increment the cycle identifier;
7. continue while resource limits and user policy permit.

The simulator may therefore approximate unbounded time by producing additional finite cycles on demand.

Required documentation wording:

TTSpaceSim simulates indefinitely repeatable finite universe cycles.
It does not compute a completed infinity or claim that literal infinite
time has elapsed.

⸻

50. Universe identity

A universe instance must be represented as:

universe(
    UniverseId,
    RootCheckpoint,
    CurrentCycle,
    CurrentTimeline,
    CurrentTime,
    Configuration,
    RealityLabel,
    Status
).

Example:

universe(
    universe_alpha,
    checkpoint(big_bang_seed_1),
    cycle(27),
    timeline(cycle_27_main),
    utime(12000000000,1,1,0,0,0),
    [
        reset_policy(return_to_seed),
        carry_policy(approved_simulant_backups),
        variation_policy(seed_increment)
    ],
    simulated,
    active
).

Each universe cycle must have a unique identifier:

universe_cycle(
    UniverseId,
    CycleNumber,
    ParentCycle,
    StartCheckpoint,
    StartTime,
    EndTime,
    RandomSeed,
    ResetPolicy,
    Status,
    RealityLabel
).

⸻

51. Universe reset operation

Required predicates:

prepare_universe_reset(
    +Simulation,
    +UniverseId,
    +TargetCheckpoint,
    +Options,
    -ResetPlan
).
validate_universe_reset(
    +Simulation,
    +ResetPlan,
    -Validation
).
execute_universe_reset(
    +Simulation0,
    +ResetPlan,
    -Simulation,
    -Result
).
explain_universe_reset(
    +ResetPlan,
    -Explanation
).

The reset plan must use:

universe_reset_plan(
    ResetId,
    UniverseId,
    SourceCycle,
    DestinationCycle,
    SourceState,
    TargetCheckpoint,
    TargetTime,
    PreservedStores,
    PreservedSimulants,
    ResetComponents,
    VariationPolicy,
    TimelinePolicy,
    ResourceLimits,
    RealityLabel
).

⸻

52. Reset semantics

A reset must never silently overwrite historical simulation data.

The default operation must:

1. close the current cycle;
2. validate and hash its final state;
3. archive its event ledger;
4. produce a cycle summary;
5. preserve selected projected stores;
6. create a new cycle;
7. restore the selected earlier checkpoint;
8. assign a new timeline identifier;
9. restore authorised simulant data;
10. append a universe_reset event;
11. continue from the restored time.

The previous cycle must remain inspectable.

Required event form:

event(
    ResetEventId,
    universe_reset,
    [system],
    DestinationSpaceTime,
    [
        source_cycle(SourceCycle),
        target_checkpoint(TargetCheckpoint)
    ],
    [
        created_cycle(DestinationCycle),
        restored_universe_state(TargetCheckpoint),
        mounted_projected_stores(StoreIds)
    ],
    simulated,
    reset_report(ResetId),
    generated_by(ttspacesim)
).

⸻

53. Reset policies

Support at least:

return_to_seed.
return_to_checkpoint(CheckpointId).
return_to_time(Time).
return_to_cycle_start.
branch_from_checkpoint(CheckpointId).
rolling_epoch(Duration).
scenario_selected(Selector).

53.1 Return to seed

Restores the original root universe checkpoint.

53.2 Return to checkpoint

Restores a named validated checkpoint.

53.3 Return to time

Finds or reconstructs the nearest valid checkpoint at or before the requested time.

53.4 Rolling epoch

After a configured duration, preserve selected information and begin another cycle from an earlier epoch.

53.5 Branch from checkpoint

Creates a new universe branch without designating the old cycle as superseded.

⸻

54. Reset component policies

A reset plan must specify which components are reset and which are preserved.

Example:

reset_components([
    celestial_state,
    environment_state,
    ordinary_events,
    local_inventories,
    temporary_agent_instances
]).

Example preservation list:

preserve_components([
    archived_ledgers,
    approved_simulant_backups,
    scientific_summaries,
    mission_templates,
    continuity_keys
]).

No component may be preserved implicitly.

⸻

55. Universe reset validation

Before execution, the system must verify:

* the target checkpoint exists;
* its state hash is valid;
* it belongs to the selected universe or an authorised template;
* all preserved stores are readable;
* all preserved records have valid provenance;
* simulant backup consent policies are satisfied;
* restored identities are not duplicated improperly;
* destination-cycle identifiers are unique;
* sufficient storage and computation limits exist;
* the reset does not relabel simulated information as real;
* references to discarded states are archived or redirected;
* no projected store falsely claims physical independence.

A failed reset must leave the original simulation unchanged.

⸻

56. Cycle variation

Repeated cycles may be identical or varied.

Supported variation policies:

identical_replay.
new_random_seed.
seed_increment.
controlled_perturbations(Perturbations).
changed_initial_conditions(Changes).
changed_agent_policies(Policies).
user_selected_variation(VariationId).

Example:

controlled_perturbations([
    event_delay(comet_arrival, seconds(20)),
    resource_change(solar_output, percent(-0.01)),
    agent_policy_change(bot(ada), cautious)
]).

Every variation must be recorded in the new cycle’s provenance.

⸻

57. Cycle stopping conditions

Since actually completing infinity is impossible, every execution request must have finite stopping controls.

Supported conditions:

max_cycles(Count).
max_events(Count).
max_simulated_duration(Duration).
max_wall_time(Duration).
max_storage(Bytes).
until_event(EventPattern).
until_objective(Objective).
until_stable(StatePredicate).
manual_stop.

At least one finite resource limit must be active.

The command:

simulate_indefinitely

may be accepted only as shorthand for a resumable cycle runner with configured finite limits per invocation.

⸻

58. Simulant data preservation

A simulant is a software agent, robot model, avatar, fictional character, abstract role or consenting human representation that exists within the simulation.

Simulant data may include:

* identity record;
* software version;
* memories;
* learned rules;
* mission history;
* relationships;
* preferences;
* permissions;
* embodiment specifications;
* continuity keys;
* inventory metadata;
* provenance;
* reality labels.

Simulant backups must be simulation data only. They must not be described as literal backups of a human consciousness.

⸻

59. Simulant data package

The canonical backup unit must be:

simulant_package(
    PackageId,
    SimulantId,
    SimulantType,
    SnapshotTime,
    UniverseId,
    CycleId,
    TimelineId,
    IdentityRecord,
    CognitiveState,
    MemoryRecords,
    MissionState,
    RelationshipState,
    EmbodimentProfile,
    Permissions,
    ConsentReferences,
    RealityLabels,
    Provenance,
    ContentHash,
    Signature,
    Version
).

A package must be immutable after sealing.

Corrections require a new package that references the package it supersedes.

⸻

60. Backup scopes

Support:

identity_only.
continuity_minimum.
mission_state.
memory_and_policy.
complete_simulant_state.
user_selected_fields(Fields).

The default scope should be:

continuity_minimum

This should preserve only the information required to identify and coherently restore a software simulant.

⸻

61. Projected stores

A projected store is an independently modelled storage endpoint within the simulation.

It may represent a store projected at:

* another planet;
* another spacecraft;
* another station;
* another timeline;
* another universe cycle;
* an interstellar relay;
* a fictional extra-universal location.

A projected store is a simulation object. It does not establish that physical data has been sent to the represented location.

Canonical form:

projected_store(
    StoreId,
    ProjectionOrigin,
    ProjectedLocation,
    ProjectedTime,
    UniverseId,
    CycleId,
    StorageModel,
    IndependenceModel,
    Capacity,
    ReplicationPolicy,
    AccessPolicy,
    IntegrityPolicy,
    AvailabilityStatus,
    RealityLabel
).

Example:

projected_store(
    store_mars_7,
    projector(bot_projector_3),
    habitat(mars, ares_archive),
    local_time(mars, mars_date(2032,181,14,30,0)),
    universe_alpha,
    cycle(27),
    content_addressed_store,
    independently_projected,
    bytes(1000000000000),
    quorum(3,5),
    authorised_simulants_only,
    hash_and_signature,
    available,
    simulated
).

⸻

62. Store independence

“Independently projected” means that the store is represented as having an autonomous simulated lifecycle after projection.

It must have its own:

* identifier;
* state;
* clock;
* event history;
* integrity checks;
* access permissions;
* availability status;
* replication schedule;
* failure model.

It must not secretly share mutable state with the source store.

Shared immutable content may use content-addressed references.

Required independence statuses:

independent.
independent_with_shared_content.
replica.
mirror.
temporarily_connected.
disconnected.
reconstructed.

⸻

63. Bot projectors

A bot projector is a software agent that creates and maintains projected simulation resources at remote space-time coordinates.

It does not physically beam matter, persons or data across the real universe.

Canonical form:

bot_projector(
    ProjectorId,
    Controller,
    Capabilities,
    CurrentCoordinate,
    ReachModel,
    StoreTemplates,
    SecurityPolicy,
    ResourceBudget,
    Status,
    RealityLabel
).

Capabilities may include:

project_store.
replicate_store.
verify_store.
repair_store.
retrieve_package.
migrate_package.
reconstruct_store.
project_agent_interface.
relay_messages.

⸻

64. Projector operations

Required predicates:

register_bot_projector(
    +Simulation0,
    +Projector,
    -Simulation,
    -Result
).
plan_store_projection(
    +Simulation,
    +ProjectorId,
    +Destination,
    +StoreOptions,
    -ProjectionPlan
).
execute_store_projection(
    +Simulation0,
    +ProjectionPlan,
    -Simulation,
    -Result
).
project_simulant_backup(
    +Simulation0,
    +ProjectorId,
    +SimulantId,
    +StoreIds,
    +BackupPolicy,
    -Simulation,
    -Result
).
verify_projected_store(
    +Simulation,
    +StoreId,
    -Verification
).
restore_simulant_from_stores(
    +Simulation0,
    +SimulantId,
    +StoreSelectionPolicy,
    +Destination,
    -Simulation,
    -Result
).

⸻

65. Projection plan

A store projection plan must contain:

store_projection_plan(
    ProjectionId,
    ProjectorId,
    SourceCoordinate,
    DestinationCoordinate,
    StoreTemplate,
    InitialContents,
    IndependenceModel,
    CommunicationModel,
    ActivationTime,
    ResourceCost,
    FailurePolicy,
    VerificationPlan,
    RealityLabel
).

Before execution, verify:

* projector capability;
* destination validity;
* storage capacity;
* policy compatibility;
* package consent;
* cryptographic or simulated-integrity metadata;
* cycle and timeline references;
* reality label;
* finite resource cost.

⸻

66. Distributed backup model

The backup system must support multiple projected stores across simulated locations, times and universe cycles.

Required replication policies:

single_store.
replicate_all(StoreIds).
minimum_copies(Count).
quorum(Required, Total).
geographic_distribution(Regions).
temporal_distribution(Times).
cycle_distribution(Cycles).
universe_distribution(UniverseBranches).
erasure_coded(DataShards, ParityShards).

For a backup to be considered recoverable, the configured policy must be satisfied.

Example:

backup_policy(
    continuity_archive,
    quorum(3,5),
    [
        geographic_distribution([
            earth,
            mars,
            lunar_orbit,
            asteroid_archive,
            interstellar_projection
        ]),
        cycle_distribution([current, next, root_archive])
    ]
).

⸻

67. Cross-universe backup

A projected store may be assigned to a different simulated universe branch.

Required predicate:

project_store_across_universe(
    +Simulation0,
    +ProjectorId,
    +SourceUniverse,
    +DestinationUniverse,
    +StoreSpecification,
    -Simulation,
    -Result
).

The operation must:

1. copy or derive an immutable package;
2. preserve the source universe identity;
3. create a destination-universe store record;
4. label the transfer simulated;
5. record whether the destination store is independent, replicated or reconstructed;
6. prevent source and destination mutable-state aliasing;
7. append projection events to both universe ledgers where applicable.

⸻

68. Cross-cycle survival

Stores may be designated to survive universe resets.

Required lifecycle classes:

cycle_local.
survives_next_reset.
survives_selected_cycles(Cycles).
root_archive.
external_to_cycle.

external_to_cycle means external to the current simulated cycle, not external to the real computer or physical universe.

Before a reset, the system must determine:

store_survival_decision(
    StoreId,
    CurrentCycle,
    DestinationCycle,
    PreserveOrDiscard,
    Reason
).

⸻

69. Backup creation

Required predicates:

create_simulant_package(
    +Simulation,
    +SimulantId,
    +Scope,
    -Package
).
seal_simulant_package(
    +Package0,
    -Package
).
store_package(
    +Simulation0,
    +StoreId,
    +Package,
    -Simulation,
    -Result
).
replicate_package(
    +Simulation0,
    +PackageId,
    +DestinationStores,
    -Simulation,
    -Result
).

Package creation must verify:

* the simulant exists;
* the requested fields are authorised;
* all memories retain reality labels;
* the package contains no unsafe executable goals;
* all referenced events exist or are marked unavailable;
* the package version is supported.

⸻

70. Backup consistency

A simulant may continue changing while backups are projected.

The system must support:

snapshot_consistency.
eventual_consistency.
cycle_boundary_consistency.
checkpoint_consistency.

The default must be:

checkpoint_consistency

A checkpoint-consistent backup must correspond to one validated simulant checkpoint.

⸻

71. Backup conflicts

Conflicting package versions must not be silently merged.

Required predicate:

compare_simulant_packages(
    +PackageA,
    +PackageB,
    -Comparison
).

Possible results:

identical.
ancestor_descendant.
compatible_divergence.
timeline_divergence.
identity_conflict.
memory_conflict.
permission_conflict.
corrupt_package.

Supported resolution policies:

select_latest_valid.
select_named_package(PackageId).
create_branch_instance.
merge_nonconflicting_fields.
manual_resolution.

Identity or memory conflicts must default to manual resolution or branch creation.

⸻

72. Simulant restoration

Required predicates:

plan_simulant_restore(
    +Simulation,
    +SimulantId,
    +AvailableStores,
    +Destination,
    +Options,
    -RestorePlan
).
validate_simulant_restore(
    +Simulation,
    +RestorePlan,
    -Validation
).
execute_simulant_restore(
    +Simulation0,
    +RestorePlan,
    -Simulation,
    -Result
).

The restore plan must include:

simulant_restore_plan(
    RestoreId,
    SimulantId,
    SelectedPackages,
    SourceStores,
    DestinationCoordinate,
    DestinationEmbodiment,
    ContinuityPolicy,
    ConflictPolicy,
    MemoryPolicy,
    Permissions,
    RealityLabel
).

⸻

73. Restore continuity classes

A restored simulant must be classified as one of:

same_simulated_instance.
continued_from_checkpoint.
restored_copy.
branch_instance.
reconstructed_instance.
partial_restore.
inconsistent_restore.

A restored package must not automatically be declared the same literal person or consciousness.

For software agents, continuity may be declared according to an explicit simulation policy.

For consenting human representations, the output must remain a representation or model.

⸻

74. Duplicate restoration protection

Before restoration, detect active related instances.

Required predicate:

detect_simulant_instances(
    +Simulation,
    +SimulantId,
    -Instances
).

Default policy:

reject_duplicate_active_instance

Alternative explicit policies:

deactivate_previous_instance.
create_branch_instance.
allow_parallel_instances(InstancePolicy).

Every parallel instance must have:

* a unique instance identifier;
* separate subjective time;
* separate writable memory state;
* shared-origin provenance.

⸻

75. Store integrity

Every stored package must have:

* content hash;
* schema version;
* source checkpoint;
* provenance;
* reality labels;
* package status;
* optional simulated signature.

Required predicates:

hash_package(+Package, -Hash).
verify_package_hash(+Package, -Result).
verify_package_provenance(+Package, -Result).
verify_store_integrity(+Store, -Report).

Store status values:

healthy.
degraded.
unreachable.
corrupt.
partially_recoverable.
destroyed_in_cycle.
reconstructed.

⸻

76. Store failure simulation

Projected stores must support independent failures.

Failure models may include:

random_failure(Probability).
scheduled_failure(Time).
resource_exhaustion.
radiation_corruption(Rate).
communication_loss.
timeline_divergence.
universe_reset_loss.
projector_failure.
malicious_simulated_event.

Required predicates:

simulate_store_failure(
    +Simulation0,
    +StoreId,
    +Failure,
    -Simulation,
    -Result
).
repair_projected_store(
    +Simulation0,
    +ProjectorId,
    +StoreId,
    +RepairPolicy,
    -Simulation,
    -Result
).

Tests must use deterministic seeds.

⸻

77. Store reconstruction

When a store is unavailable, a bot projector may reconstruct it from:

* surviving replicas;
* erasure-coded shards;
* an earlier cycle archive;
* a checkpoint;
* a parent timeline;
* a trusted package manifest.

Required predicate:

reconstruct_projected_store(
    +Simulation0,
    +ProjectorId,
    +LostStoreId,
    +Sources,
    -Simulation,
    -Result
).

The reconstructed store must receive:

* a new store instance identifier;
* a reference to the lost store;
* reconstruction provenance;
* a verification report;
* status reconstructed.

⸻

78. Projector autonomy

Bot projectors may act according to deterministic policies.

Example:

projector_policy(
    projector_3,
    [
        maintain_minimum_copies(5),
        verify_every(simulated_days(10)),
        repair_when(degraded),
        project_before_universe_reset,
        preserve_continuity_minimum
    ]
).

Required predicate:

run_projector_cycle(
    +Simulation0,
    +ProjectorId,
    +CurrentTime,
    -Simulation,
    -Actions
).

Automatic projector actions must remain within:

* configured permissions;
* resource budgets;
* consent;
* store access rules;
* reality-label constraints.

⸻

79. Universe-reset integration with backups

Before each universe reset, perform:

prepare_cycle_preservation(
    +Simulation,
    +UniverseId,
    +ResetPlan,
    -PreservationPlan
).

A preservation plan must:

1. identify simulants marked for survival;
2. create checkpoint-consistent packages;
3. select projected stores;
4. verify replication requirements;
5. project missing copies;
6. verify package hashes;
7. seal the cycle ledger;
8. produce a recoverability report.

Canonical form:

cycle_preservation_plan(
    PreservationId,
    UniverseId,
    SourceCycle,
    DestinationCycle,
    SimulantPackages,
    TargetStores,
    ReplicationRequirements,
    VerificationActions,
    RestoreActions,
    Status
).

The reset must not proceed when a mandatory preservation policy is unsatisfied unless an explicit override is recorded.

⸻

80. Post-reset restoration

After a reset:

restore_cycle_survivors(
    +Simulation0,
    +PreservationPlan,
    -Simulation,
    -Report
).

The system must:

* mount surviving projected stores;
* verify their independent state;
* locate approved packages;
* restore simulants according to continuity policy;
* create new cycle-local instances;
* preserve source-cycle provenance;
* record any lost or partial data;
* append restoration events.

⸻

81. Infinite-cycle runner

Required predicate:

run_universe_cycles(
    +Simulation0,
    +UniverseId,
    +CyclePolicy,
    +StoppingConditions,
    -Simulation,
    -Report
).

Cycle policy example:

cycle_policy(
    [
        run_duration(simulated_years(1000000)),
        reset_to(checkpoint(origin_seed)),
        preserve(approved_simulants),
        project_to(minimum_copies(5)),
        variation(seed_increment),
        restore_survivors(true)
    ]
).

The runner must be resumable.

It must return after a finite invocation with:

universe_cycle_report(
    CompletedCycles,
    FinalCycle,
    FinalTime,
    PreservedPackages,
    StoreHealth,
    ResetEvents,
    StoppingReason,
    ResumeToken
).

A resume token may contain only validated simulation state references, not executable Prolog goals.

⸻

82. New step/4 commands

Extend the canonical transition interface with:

prepare_universe_reset(UniverseId, Target, Options).
execute_universe_reset(ResetId).
run_universe_cycle(UniverseId, Policy).
create_simulant_backup(SimulantId, Scope).
register_bot_projector(Projector).
project_store(ProjectorId, Destination, Options).
project_backup(ProjectorId, SimulantId, Stores, Policy).
verify_store(StoreId).
repair_store(ProjectorId, StoreId, Policy).
restore_simulant(SimulantId, Stores, Destination, Options).
prepare_cycle_preservation(UniverseId, ResetId).
restore_cycle_survivors(PreservationId).

⸻

83. New event types

Add:

universe_cycle_started.
universe_cycle_completed.
universe_reset_planned.
universe_reset_executed.
cycle_ledger_archived.
simulant_package_created.
simulant_package_sealed.
store_projected.
package_stored.
package_replicated.
store_verified.
store_degraded.
store_failed.
store_repaired.
store_reconstructed.
simulant_restore_planned.
simulant_restored.
branch_instance_created.
cycle_preservation_completed.

⸻

84. New invariants

Add:

invariant(unique_universe_cycle_ids).
invariant(previous_cycles_immutable).
invariant(reset_target_checkpoint_valid).
invariant(finite_limits_per_execution).
invariant(projected_stores_have_independent_state).
invariant(no_mutable_aliasing_between_independent_stores).
invariant(sealed_packages_immutable).
invariant(package_hashes_valid).
invariant(package_provenance_valid).
invariant(replication_policy_satisfied).
invariant(restored_instances_uniquely_identified).
invariant(cross_cycle_data_explicitly_authorised).
invariant(no_literal_infinity_claim).
invariant(no_physical_projection_claim).
invariant(no_human_consciousness_backup_claim).

⸻

85. New diagnostics

Add:

invalid_universe_reset
unknown_universe
unknown_cycle
invalid_root_checkpoint
cycle_identifier_conflict
missing_finite_stopping_condition
preservation_policy_unsatisfied
unknown_projector
projector_capability_missing
projection_destination_invalid
projected_store_unavailable
projected_store_corrupt
package_hash_mismatch
package_provenance_invalid
replication_quorum_not_met
simulant_package_conflict
duplicate_restore_instance
restore_continuity_unresolved
cross_cycle_permission_denied
store_capacity_exceeded
store_independence_violation
unsafe_package_content

Example:

diagnostic(
    error,
    replication_quorum_not_met,
    "Only two of five projected stores contain a verified package; three are required.",
    simulant_package(package_88),
    project_additional_copy(store_lunar_4)
).

⸻

86. Required tests for universe cycles

Implement PlUnit tests for:

* reset to root checkpoint;
* reset to named checkpoint;
* previous cycle remains accessible;
* new cycle receives a unique identifier;
* identical replay with the same seed;
* varied replay with a changed seed;
* selected state is preserved;
* unselected state is reset;
* invalid checkpoint rejection;
* reset transaction rollback;
* finite stopping-condition enforcement;
* one hundred short cycles without identifier collision;
* resumable cycle execution;
* cycle ledger immutability.

⸻

87. Required tests for projected stores

Implement tests for:

* projector registration;
* projected-store creation;
* independent mutable state;
* immutable shared content;
* package creation;
* package sealing;
* package storage;
* replication;
* quorum verification;
* simulated store failure;
* store repair;
* store reconstruction;
* cross-cycle store survival;
* cross-universe projection;
* unauthorised access rejection;
* corrupt package detection;
* insufficient-capacity rejection.

⸻

88. Required tests for simulant restoration

Implement tests for:

* continuity-minimum backup;
* complete software-agent backup;
* checkpoint-consistent snapshot;
* restore after universe reset;
* restore from a quorum of stores;
* partial recovery;
* conflicting package versions;
* branch-instance creation;
* duplicate-instance rejection;
* restoration into a compatible embodiment;
* incompatible destination rejection;
* preservation of synthetic-memory labels;
* preservation of consent restrictions;
* human representation remains labelled as a representation.

⸻

89. Required demonstration

Add:

examples/cyclic_universe_archive.pl

Command:

swipl -q -s examples/cyclic_universe_archive.pl -g run -t halt

The demonstration must:

1. create a simulated universe;
2. register two software simulants;
3. register five bot projectors;
4. project stores to Earth, Mars, a lunar station, an asteroid archive and a fictional interstellar archive;
5. run one finite universe epoch;
6. create checkpoint-consistent simulant packages;
7. replicate the packages under a three-of-five quorum;
8. fail one store;
9. verify that recovery remains possible;
10. reset the universe to its root checkpoint;
11. begin a new cycle;
12. restore the simulants from projected stores;
13. report their continuity classifications;
14. confirm that the previous cycle remains archived;
15. print:

Universe cycling is simulated through repeated finite checkpoints.
Projected stores are independent simulation objects.
No physical universe reset, literal infinity, consciousness transfer,
or real interstellar data projection is claimed.

⸻

90. Additional implementation stages

Stage 15 — Universe-cycle model

Implement:

* universe records;
* cycle identifiers;
* cycle ledgers;
* cycle start and completion events;
* finite cycle runner.

Acceptance:

A finite cycle completes and produces a resumable cycle report.

Stage 16 — Universe reset planning

Implement:

* reset targets;
* reset validation;
* transactional reset;
* archived prior cycles;
* variation policies.

Acceptance:

A universe can reset to a prior checkpoint without altering the archived cycle.

Stage 17 — Simulant packages

Implement:

* backup scopes;
* canonical packages;
* hashes;
* sealing;
* package comparison.

Acceptance:

A sealed package is immutable and independently verifiable.

Stage 18 — Projected stores

Implement:

* bot projectors;
* projected store lifecycle;
* store independence;
* projection events;
* access control.

Acceptance:

Two independently projected stores do not share mutable state.

Stage 19 — Replication and recovery

Implement:

* replication policies;
* quorum verification;
* failure simulation;
* repair;
* reconstruction.

Acceptance:

A simulant package remains recoverable after failures within the configured tolerance.

Stage 20 — Cross-cycle preservation

Implement:

* preservation plans;
* reset integration;
* store survival;
* post-reset restoration;
* continuity classification.

Acceptance:

Approved software simulants can be restored into a new simulated universe cycle with complete provenance.

Stage 21 — Long-run audit

Run:

* repeated-cycle tests;
* store-failure tests;
* package-conflict tests;
* resource-limit tests;
* deterministic replay tests.

Produce:

UNIVERSE_CYCLE_AUDIT.md
PROJECTED_STORE_AUDIT.md

⸻

91. Updated definition of done

In addition to the earlier completion criteria, the project is complete when:

* the universe can be restored to an earlier validated checkpoint;
* restoration creates a new cycle rather than deleting the old one;
* finite cycles can be repeatedly resumed to approximate unbounded simulated time;
* every cycle has finite execution limits;
* selected simulant data can survive resets;
* simulant data can be packaged, sealed and verified;
* bot projectors can create independently modelled projected stores;
* projected stores can exist across simulated planets, times, timelines and universe branches;
* independent stores do not share mutable state;
* backup policies can require replication or quorum;
* store failures and reconstruction are tested;
* simulants can be restored with explicit continuity classifications;
* duplicate restored instances are controlled;
* all restored memories retain their reality labels;
* no feature claims literal universe resetting, completed infinity, physical interstellar projection or human consciousness transfer;
* all new PlUnit tests pass.

⸻

92. Updated central conjecture

TTSpaceSim should test the following expanded conjecture:

A finite simulation can approximate indefinitely continuing time by repeatedly archiving a completed universe cycle, restoring an earlier validated checkpoint, creating a new cycle, and selectively restoring coherent simulant state from independently modelled projected stores.

A second conjecture is:

When a simulant package is replicated across sufficiently independent simulated stores, the simulant’s software identity, memories, mission state and continuity metadata can remain recoverable across local failures, timeline branches and simulated universe resets without requiring every universe cycle to retain its complete mutable state.

Suggested measures:

metric(cycle_replay_determinism).
metric(cycle_variation_diversity).
metric(reset_transaction_integrity).
metric(previous_cycle_recoverability).
metric(simulant_package_completeness).
metric(store_independence).
metric(replication_survival_rate).
metric(quorum_recovery_success).
metric(restore_continuity_score).
metric(cross_cycle_provenance_completeness).
metric(storage_growth_per_cycle).
metric(history_compression_ratio).

These experiments must remain explicitly described as software simulations.

The most important implementation distinction is:

reset_universe(CurrentCycle, Checkpoint, NewCycle)

must mean archive and branch, not erase and overwrite. Likewise, a bot projector creates an autonomous simulated store record; it does not imply that data was physically projected to another planet or universe.
