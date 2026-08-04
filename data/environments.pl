:- module(data_environments, [
    sample_environment/1
]).

sample_environment(environment(
    earth_lab_env,
    earth_lab,
    breathable,
    gravity(earth_standard),
    celsius(18, 24),
    radiation(low),
    pressure(earth_normal),
    [software_runtime, earth_lab_robot, human_representation_suite],
    [power(grid, 1000), bandwidth(relay, 1000)],
    [software_runtime, protocol(relay), protocol(laser), power_source(grid)],
    simulated
)).

sample_environment(environment(
    lunar_base_env,
    lunar_base,
    controlled,
    gravity(lunar),
    celsius(16, 23),
    radiation(medium),
    pressure(low_pressurised),
    [software_runtime, lunar_surface_robot],
    [power(fusion, 500), bandwidth(relay, 250)],
    [software_runtime, protocol(relay), protocol(delay_tolerant), power_source(fusion)],
    simulated
)).

sample_environment(environment(
    mars_habitat_env,
    mars_habitat,
    controlled,
    gravity(martian),
    celsius(18, 22),
    radiation(medium),
    pressure(low_pressurised),
    [software_runtime, mars_habitat_robot, pressurised_robot],
    [power(solar, 200), bandwidth(relay, 400)],
    [software_runtime, protocol(relay), protocol(delay_tolerant), power_source(solar)],
    simulated
)).

sample_environment(environment(
    mars_archive_env,
    mars_archive,
    controlled,
    gravity(martian),
    celsius(12, 20),
    radiation(medium),
    pressure(low_pressurised),
    [software_runtime, archive_robot],
    [power(solar, 600), bandwidth(relay, 800)],
    [software_runtime, protocol(relay), protocol(laser), power_source(solar)],
    simulated
)).

sample_environment(environment(
    asteroid_archive_env,
    asteroid_archive,
    controlled,
    gravity(micro),
    celsius(-10, 15),
    radiation(high),
    pressure(low_pressurised),
    [software_runtime, archive_robot],
    [power(fusion, 800), bandwidth(delay_tolerant, 1200)],
    [software_runtime, protocol(delay_tolerant), protocol(relay), power_source(fusion)],
    simulated
)).

sample_environment(environment(
    interstellar_archive_env,
    interstellar_archive,
    virtual,
    gravity(simulated),
    celsius(20, 20),
    radiation(simulated),
    pressure(simulated),
    [software_runtime, archive_robot],
    [power(simulated, 1000000), bandwidth(relay, 1000000)],
    [software_runtime, protocol(relay), protocol(quantum_fictional), power_source(simulated)],
    fictional
)).

sample_environment(environment(
    fictional_exoplanet_env,
    fictional_exoplanet,
    fictional,
    gravity(simulated),
    celsius(-40, 10),
    radiation(high),
    pressure(variable),
    [software_runtime, exoplanet_drone],
    [power(simulated, 1000), bandwidth(relay, 1000)],
    [software_runtime, protocol(relay), protocol(quantum_fictional), power_source(simulated)],
    fictional
)).

