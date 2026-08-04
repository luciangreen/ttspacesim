:- module(resources, [
    consume_resource/4,
    transfer_resource/5,
    produce_resource/4
]).

:- use_module(library(lists)).

consume_resource(Inventory0, ResourceName, Quantity, Inventory) :-
    Quantity >= 0,
    select(resource(ResourceName, Existing), Inventory0, Rest),
    Existing >= Quantity,
    Remaining is Existing - Quantity,
    Inventory = [resource(ResourceName, Remaining) | Rest].

transfer_resource(Source0, Destination0, ResourceName, Quantity, Source-Destination) :-
    consume_resource(Source0, ResourceName, Quantity, Source),
    produce_resource(Destination0, ResourceName, Quantity, Destination).

produce_resource(Inventory0, ResourceName, Quantity, Inventory) :-
    Quantity >= 0,
    (   select(resource(ResourceName, Existing), Inventory0, Rest)
    ->  Updated is Existing + Quantity,
        Inventory = [resource(ResourceName, Updated) | Rest]
    ;   Inventory = [resource(ResourceName, Quantity) | Inventory0]
    ).

