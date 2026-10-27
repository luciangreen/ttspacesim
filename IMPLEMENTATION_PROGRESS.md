# Implementation progress

## Shipped

- Repository structure, SWI-Prolog package metadata, and the explicit-state public API.
- Deterministic coordinates and clocks; traveller/environment registration and compatibility; mission construction; hop validation, planning, execution, and continuity reporting.
- Timeline branch creation/comparison; event-ledger and causality validation; synthetic memory generation/validation; checkpoints and persistence.
- Reality labels, structured diagnostics, consent checks, approval promotion, and resource-list consumption/production/transfers.
- Finite universe cycles and reset planning; simulant packages and hashes; projected stores, replication, verification, repair, reconstruction, and restoration.
- Command-line demos and PlUnit tests for the implemented surfaces. The resource helpers now have direct tests in `test/test_resources.pl`.

## Remaining against `PROGRAM_REQUIREMENTS.md`

The current implementation is a working subset of the full requirements, not a complete implementation of every listed predicate or scenario. Outstanding feature work includes:

- Simulated communication messages, delivery timing models, and due-message delivery.
- Complete mission scheduling, event scheduling/rescheduling, and the broader route-planning interface.
- Timeline switching and compatible-branch merging; expanded causal-order validation and changed-event propagation.
- History compression, synthetic memory installation/explanations, and contradiction detection beyond current validation.
- Full consent lifecycle and scenario validation, plus the complete set of explanation predicates.
- State-level inventory/resource integration, including availability and inventory consistency through checkpoints.
- Remaining requirement-driven integration and acceptance tests, including broad persistence migration, approval, consent, route, schedule, and universe/store failure cases.

See the feature inventory and runnable commands in `README.md`. Run `swipl -q -s test/run_tests.pl` for the complete current suite; individual groups and all demo commands are also documented there.
