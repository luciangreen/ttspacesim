:- initialization(main, main).

main(_) :-
    Dir = 'test',
    load_test_file(Dir, 'test_support.pl'),
    load_test_file(Dir, 'test_coordinates.pl'),
    load_test_file(Dir, 'test_clocks.pl'),
    load_test_file(Dir, 'test_hops.pl'),
    load_test_file(Dir, 'test_timelines.pl'),
    load_test_file(Dir, 'test_memories.pl'),
    load_test_file(Dir, 'test_compatibility.pl'),
    load_test_file(Dir, 'test_causality.pl'),
    load_test_file(Dir, 'test_consent.pl'),
    load_test_file(Dir, 'test_persistence.pl'),
    load_test_file(Dir, 'test_integration.pl'),
    run_tests,
    halt.

load_test_file(Dir, File) :-
    directory_file_path(Dir, File, Path),
    ensure_loaded(Path).
