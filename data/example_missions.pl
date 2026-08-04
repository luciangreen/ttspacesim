:- module(data_example_missions, [
    example_mission/2
]).

example_mission(mars_research_01, mission(
    mars_research_01,
    "Mars Research 01",
    [collect_soil_samples, preserve_continuity],
    [],
    spacetime(earth_lab, instant(2026, 8, 4, 9, 0)),
    spacetime(mars_habitat, instant(2032, 3, 17, 14, 30)),
    [],
    [requires(simulated_only)],
    simulated,
    draft
)).

