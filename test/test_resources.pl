:- begin_tests(resources).

:- use_module('../src/resources').

test(consume_resource, [nondet]) :-
    consume_resource(
        [resource(fuel, 5), resource(water, 2)],
        fuel,
        3,
        [resource(fuel, 2), resource(water, 2)]
    ).

test(negative_consumption_rejected, [fail]) :-
    consume_resource([resource(fuel, 5)], fuel, -1, _).

test(insufficient_resource_rejected, [fail]) :-
    consume_resource([resource(fuel, 2)], fuel, 3, _).

test(produce_existing_resource) :-
    produce_resource([resource(fuel, 2)], fuel, 3, [resource(fuel, 5)]).

test(produce_new_resource) :-
    produce_resource([resource(fuel, 2)], water, 3, [resource(water, 3), resource(fuel, 2)]).

test(transfer_resource) :-
    transfer_resource(
        [resource(fuel, 5)],
        [resource(fuel, 1)],
        fuel,
        3,
        [resource(fuel, 2)]-[resource(fuel, 4)]
    ).

:- end_tests(resources).
