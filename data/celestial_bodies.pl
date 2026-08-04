:- module(data_celestial_bodies, [
    celestial_body/3,
    location_fact/5,
    route_fact/4
]).

celestial_body(earth, planet, real).
celestial_body(moon, moon, real).
celestial_body(mars, planet, simulated).
celestial_body(asteroid_belt, asteroid_region, simulated).
celestial_body(kepler_442b, exoplanet, fictional).

location_fact(earth, planet(earth), earth, earth_surface_env, real).
location_fact(earth_lab, room(earth_lab, main_lab), earth, earth_lab_env, simulated).
location_fact(lunar_base, habitat(moon, tranquility), moon, lunar_base_env, simulated).
location_fact(lunar_station, station(lunar_station), moon, lunar_station_env, simulated).
location_fact(mars, planet(mars), mars, mars_surface_env, simulated).
location_fact(mars_habitat, habitat(mars, ares_1), mars, mars_habitat_env, simulated).
location_fact(mars_archive, habitat(mars, ares_archive), mars, mars_archive_env, simulated).
location_fact(asteroid_archive, asteroid(vesta_archive), asteroid_belt, asteroid_archive_env, simulated).
location_fact(interstellar_archive, virtual_world(interstellar_archive), kepler_442b, interstellar_archive_env, fictional).
location_fact(fictional_exoplanet, virtual_world(fictional_exoplanet), kepler_442b, fictional_exoplanet_env, fictional).

route_fact(earth_lab, lunar_base, conventional, seconds(900)).
route_fact(earth_lab, mars_habitat, conventional, seconds(189302400)).
route_fact(earth_lab, mars_habitat, compressed, seconds(120)).
route_fact(lunar_base, mars_habitat, compressed, seconds(180)).
route_fact(mars_habitat, mars_archive, narrative_instant, seconds(1)).
route_fact(earth_lab, fictional_exoplanet, interstellar, seconds(240)).

