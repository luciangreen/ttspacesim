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
- `create_mission/2`
- `register_traveller/3`
- `create_hop/5`
- `validate_hop/3`
- `plan_hop/3`
- `simulate_hop/4`
- `create_checkpoint/3`
- `restore_checkpoint/2`
- `create_universe/6`
- `run_universe_cycles/6`
- `create_simulant_package/4`
- `register_bot_projector/4`
- `restore_simulant_from_stores/6`

## Demo commands

```sh
swipl -q -s src/ttspacesim.pl -g run_demo -t halt
swipl -q -s examples/earth_to_mars.pl -g run -t halt
swipl -q -s examples/lunar_time_branch.pl -g run -t halt
swipl -q -s examples/interstellar_checkpoint.pl -g run -t halt
swipl -q -s examples/synthetic_crew_history.pl -g run -t halt
swipl -q -s examples/cyclic_universe_archive.pl -g run -t halt
```

## Tests

Run the full PlUnit suite:

```sh
swipl -q -s test/run_tests.pl
```

## Simulation wording

TTSpaceSim simulates indefinitely repeatable finite universe cycles. It does not compute a completed infinity or claim that literal infinite time has elapsed.
