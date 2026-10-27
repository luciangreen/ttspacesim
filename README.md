# TTSpaceSim

TTSpaceSim is a deterministic SWI-Prolog simulation framework for labelled space-time travel, timeline branching, synthetic memories, checkpoint restoration, and finite universe-cycle replay. It models these behaviours explicitly as software simulations and does **not** claim literal teleportation, physical time travel, consciousness transfer, completed infinity, or real interstellar projection.

## Requirements

- SWI-Prolog 9.x or newer

## Repository layout

```text
src/       Core modules and public API
data/      Sample catalogue, environments, routes, and missions
examples/  Command-line demonstrations
test/      PlUnit coverage and the test runner
```

## Public entry points

Load the main module:

```prolog
?- [src/ttspacesim].
```

Primary exported predicates include:

- `new_simulation/2`
- `step/4`
- `create_mission/2` and `create_mission/3`
- `register_traveller/3`
- `register_environment/3`
- `create_hop/5`
- `validate_hop/3`
- `plan_hop/3`
- `plan_hop/5`
- `simulate_hop/4`
- `create_timeline/6` and `compare_timelines/4`
- `generate_memory_set/6` and `validate_memory_set/4`
- `continuity_report/5`
- `environment_compatible/3`
- `create_checkpoint/3`
- `restore_checkpoint/2`
- `save_simulation/2` and `load_simulation/2`
- `explain_result/2` and `promote_to_real_action/3`
- `create_universe/6`
- `prepare_universe_reset/5`, `validate_universe_reset/3`, and `execute_universe_reset/4`
- `run_universe_cycles/6`
- `create_simulant_package/4`
- `seal_simulant_package/2`, `hash_package/2`, and `verify_package_hash/2`
- `register_bot_projector/4`
- `plan_store_projection/5` and `execute_store_projection/4`
- `project_simulant_backup/7`
- `verify_projected_store/3`
- `restore_simulant_from_stores/6`

## Implemented features

| Area | Shipped behavior | Main implementation |
|---|---|---|
| Simulation state | Explicit state passed between deterministic commands; simulated reality labels and structured diagnostics | `src/ttspacesim.pl`, `src/diagnostics.pl`, `src/reality_labels.pl` |
| Space-time | Validated instants, universal/local clocks, planetary location conversion, canonical coordinates and ordering | `src/clocks.pl`, `src/coordinates.pl`, `src/celestial_catalogue.pl` |
| Travellers and environments | Traveller registration, sample environments, compatibility checks and adaptation reports | `src/travellers.pl`, `src/environments.pl`, `src/compatibility.pl` |
| Missions and routes | Mission construction, sample route durations and resource estimates, schedule-conflict detection | `src/ttspacesim.pl`, `src/routes.pl`, `src/schedules.pl`, `data/` |
| Hops | Request construction, validation, plans for supported travel modes, execution, reality labels and continuity reports | `src/hop_planner.pl`, `src/hop_executor.pl`, `src/continuity.pl` |
| Timelines and causality | Branch creation/comparison, causal paths, graph validation, dependency checks and cycle detection | `src/timelines.pl`, `src/branches.pl`, `src/causality.pl` |
| Memories and checkpoints | Synthetic memory generation/validation, checkpoint creation/restoration, state persistence and package integrity checks | `src/synthetic_memories.pl`, `src/checkpoints.pl`, `src/persistence.pl` |
| Consent and approvals | Consent checks, fictional replacement helper, and explicit promotion to a scheduled action record | `src/consent.pl`, `src/approvals.pl` |
| Inventory helpers | Non-negative resource consumption/production and transfers over resource lists | `src/resources.pl` |
| Universe cycles and projected stores | Finite reset/cycle execution, sealed packages, projector/store operations, replication, verification, repair, reconstruction and restoration | `src/ttspacesim.pl`, `src/validation.pl` |

These are the implemented surfaces, not a claim that every requirement in
`PROGRAM_REQUIREMENTS.md` is complete. In particular, the current API does not
yet provide simulated message delivery, full mission scheduling/rescheduling,
timeline switching/merging, causal memory-history compression and installation,
full consent lifecycle/validation, or the full specified explanation API.
Resource helpers currently operate on resource lists rather than simulation
state inventories. See `IMPLEMENTATION_PROGRESS.md` for the tracked remaining
work.

## Example command showcase

Each example can be run directly from the repository root with SWI-Prolog.
All scenarios are labelled simulations; no physical travel, consciousness transfer,
or literal infinite cycles are performed.

---

### Quick smoke test — `run_demo`

Loads the public API and prints a single confirmation that a simulation was started.

```sh
swipl -q -s src/ttspacesim.pl -g run_demo -t halt
```

**Sample output**

```
simulation_started(space_demo,simulated)
```

---

### Earth → Mars hop — `examples/earth_to_mars.pl`

Creates a mission, registers a software-agent traveller (`bot(ada)`), plans and
executes a compressed hop from `earth_lab` (2026-08-04) to `mars_habitat`
(2032-03-17), then prints the mission record, the hop plan, the simulation
result, and a continuity report.

```sh
swipl -q -s examples/earth_to_mars.pl -g run -t halt
```

**Sample output**

```
mission(mars_research_01,_,_,_,_,_,_,_,_,_)
hop_plan(bot(ada),spacetime(earth_lab,instant(2026,8,4,9,0)),spacetime(mars_habitat,instant(2032,3,17,14,30)),_,_)
hop_simulated(bot(ada),spacetime(mars_habitat,instant(2032,3,17,14,30)),_)
continuity_report(bot(ada),spacetime(mars_habitat,instant(2032,3,17,14,30)),_,_)
Reality: simulated
```

---

### Lunar time-branch — `examples/lunar_time_branch.pl`

Registers traveller `bot(selene)`, plans a historical-replay hop to `lunar_base`
with `branch_on_change` timeline policy, executes it, and compares the resulting
branched timeline against the main timeline.

```sh
swipl -q -s examples/lunar_time_branch.pl -g run -t halt
```

**Sample output**

```
hop_simulated(bot(selene),spacetime(lunar_base,instant(2026,8,4,7,0)),_)
timeline_comparison(main,timeline_2,_)
```

---

### Interstellar checkpoint — `examples/interstellar_checkpoint.pl`

Validates a fictional interstellar hop request (Earth → `fictional_exoplanet`)
and attempts to build a plan.  Because interstellar travel is outside the
near-system envelope the plan may be unavailable; the example prints whichever
outcome occurs and includes an explicit disclaimer.

```sh
swipl -q -s examples/interstellar_checkpoint.pl -g run -t halt
```

**Sample output**

```
hop_validated(bot(archive),spacetime(fictional_exoplanet,instant(2032,3,17,14,30)),_)
plan_unavailable
Reality: fictional simulation
No claim of real interstellar travel is made.
```

---

### Synthetic crew history — `examples/synthetic_crew_history.pl`

Generates a `social_continuity` memory set for traveller `bot(crew_ada)` seeded
with check-in and handover events, then prints the resulting memory-set term.

```sh
swipl -q -s examples/synthetic_crew_history.pl -g run -t halt
```

**Sample output**

```
memory_set(bot(crew_ada),social_continuity,[event(check_in),event(handover)],spacetime(earth_lab,instant(2026,8,4,9,0)),_)
```

---

### Cyclic universe archive — `examples/cyclic_universe_archive.pl`

The most comprehensive demo.  It:

1. Registers five environments (Earth, Mars, Lunar, Asteroid, Interstellar).
2. Creates two software-agent travellers (`bot(ada)` and `bot(turing)`).
3. Stamps an origin-seed checkpoint and initialises `universe_alpha`.
4. Registers five bot-projectors and projects archive stores to each destination.
5. Backs up both simulants across the store quorum (3-of-5).
6. Runs one universe cycle (reset to origin checkpoint).
7. Simulates a store communication failure, verifies the store, then restores
   both simulants from the remaining stores.

```sh
swipl -q -s examples/cyclic_universe_archive.pl -g run -t halt
```

**Sample output**

```
universe_cycle_report(universe_alpha,1,_,_,_)
store_verification(_,communication_loss,degraded)
simulant_restored(bot(ada),spacetime(earth_lab,instant(2026,8,4,9,0)),_)
simulant_restored(bot(turing),spacetime(earth_lab,instant(2026,8,4,9,0)),_)
Universe cycling is simulated through repeated finite checkpoints.
Projected stores are independent simulation objects.
No physical universe reset, literal infinity, consciousness transfer,
or real interstellar data projection is claimed.
```

---

## Tests

Run the complete PlUnit suite, including resource helper tests:

```sh
swipl -q -s test/run_tests.pl
```

Run one test group (available groups: `coordinates`, `clocks`, `resources`,
`hops`, `timelines`, `memories`, `compatibility`, `causality`, `consent`,
`persistence`, and `integration`):

```sh
swipl -q -s test/test_resources.pl -g "run_tests(resources)" -t halt
```

To run each test file independently, use the same command with the desired
`test/test_*.pl` file and its group name. The complete runner loads shared test
fixtures and all test groups.

The examples above cover the demos. To execute every example in one shell
session from the repository root:

```sh
for file in examples/*.pl; do
  swipl -q -s "$file" -g run -t halt || exit $?
done
```

## Simulation wording

TTSpaceSim simulates indefinitely repeatable finite universe cycles. It does not compute a completed infinity or claim that literal infinite time has elapsed.
