:- begin_tests(persistence).

:- use_module('../src/ttspacesim').
:- use_module(test_support).

test(save_and_load_round_trip) :-
    registered_traveller_simulation(bot(ada), Simulation),
    tmp_file_stream(text, File, Stream),
    close(Stream),
    save_simulation(Simulation, File),
    load_simulation(File, Loaded),
    Loaded.id = Simulation.id,
    delete_file(File).

test(invalid_saved_term_rejected, [fail]) :-
    tmp_file_stream(text, File, Stream),
    write(Stream, ttspacesim_saved(v1, bad_hash, unsafe(call(evil)))) ,
    write(Stream, '.\n'),
    close(Stream),
    load_simulation(File, _),
    delete_file(File).

:- end_tests(persistence).

