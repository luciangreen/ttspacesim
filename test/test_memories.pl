:- begin_tests(memories).

:- use_module('../src/ttspacesim').
:- use_module(test_support).

test(coherent_memory_set) :-
    registered_traveller_simulation(bot(ada), Simulation),
    generate_memory_set(Simulation, bot(ada), causal_minimum, [], spacetime(mars_habitat, instant(2032, 3, 17, 14, 30)), MemorySet),
    validate_memory_set(Simulation, MemorySet, bot(ada), validation(ok, [])).

test(contradictory_memories) :-
    registered_traveller_simulation(bot(ada), Simulation),
    MemorySet = memory_set(memory_conflict, bot(ada), causal_minimum, [
        synthetic_memory(m1, bot(ada), [], summary(fact(status, nominal)), memory_reality(synthetic), generated_by(ttspacesim)),
        synthetic_memory(m2, bot(ada), [], summary(fact(status, failed)), memory_reality(synthetic), generated_by(ttspacesim))
    ], simulated, pending),
    validate_memory_set(Simulation, MemorySet, bot(ada), validation(error, Diagnostics)),
    member(diagnostic(error, contradictory_memories, _, _, _), Diagnostics).

:- end_tests(memories).

