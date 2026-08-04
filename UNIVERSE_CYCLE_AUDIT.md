# Universe cycle audit

- Universe resets archive and branch instead of overwriting prior cycle records.
- Cycle execution is finite and resumable through `run_universe_cycles/6`.
- Root-checkpoint restoration keeps projected stores available for cross-cycle recovery in the shipped implementation.
- Reset events remain simulation-labelled and make no physical-world claims.

