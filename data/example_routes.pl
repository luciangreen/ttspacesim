:- module(data_example_routes, [
    route_template/5
]).

route_template(earth_to_mars_compressed, earth_lab, mars_habitat, compressed, [resource(fuel, 10), resource(compute, 5)]).
route_template(moon_replay, lunar_base, lunar_base, historical_replay, [resource(compute, 2)]).
route_template(interstellar_fictional, earth_lab, fictional_exoplanet, interstellar, [resource(compute, 20), resource(archive, 5)]).

