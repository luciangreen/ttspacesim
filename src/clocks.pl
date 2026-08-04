:- module(clocks, [
    valid_instant/1,
    instant_to_utime/2,
    utime_to_instant/2,
    local_to_universal/3,
    universal_to_local/3,
    compare_utime/3,
    add_seconds/3
]).

:- use_module(library(error)).

valid_instant(instant(Year, Month, Day, Hour, Minute)) :-
    valid_instant(instant(Year, Month, Day, Hour, Minute, 0)).
valid_instant(instant(Year, Month, Day, Hour, Minute, Second)) :-
    catch((
        date_time_stamp(date(Year, Month, Day, Hour, Minute, Second, 0, -, -), Timestamp),
        stamp_date_time(Timestamp, date(Year2, Month2, Day2, Hour2, Minute2, SecondFloat, _, _, _), 'UTC'),
        Second2 is floor(SecondFloat),
        Year =:= Year2,
        Month =:= Month2,
        Day =:= Day2,
        Hour =:= Hour2,
        Minute =:= Minute2,
        Second =:= Second2
    ),
        _,
        fail
    ).

instant_to_utime(instant(Year, Month, Day, Hour, Minute), UTime) :-
    instant_to_utime(instant(Year, Month, Day, Hour, Minute, 0), UTime).
instant_to_utime(instant(Year, Month, Day, Hour, Minute, Second), utime(Year, Month, Day, Hour, Minute, Second)) :-
    must_be(integer, Year),
    must_be(integer, Month),
    must_be(integer, Day),
    must_be(integer, Hour),
    must_be(integer, Minute),
    must_be(integer, Second),
    valid_instant(instant(Year, Month, Day, Hour, Minute, Second)).

utime_to_instant(utime(Year, Month, Day, Hour, Minute, Second), instant(Year, Month, Day, Hour, Minute, Second)).

local_to_universal(earth, local_time(earth, instant(Year, Month, Day, Hour, Minute, Second)), UTime) :-
    instant_to_utime(instant(Year, Month, Day, Hour, Minute, Second), UTime).
local_to_universal(earth, local_time(earth, instant(Year, Month, Day, Hour, Minute)), UTime) :-
    instant_to_utime(instant(Year, Month, Day, Hour, Minute), UTime).
local_to_universal(World, local_time(World, instant(Year, Month, Day, Hour, Minute, Second)), UTime) :-
    World \= mars,
    instant_to_utime(instant(Year, Month, Day, Hour, Minute, Second), UTime).
local_to_universal(World, local_time(World, instant(Year, Month, Day, Hour, Minute)), UTime) :-
    World \= mars,
    instant_to_utime(instant(Year, Month, Day, Hour, Minute), UTime).
local_to_universal(mars, local_time(mars, mars_date(MarsYear, Sol, Hour, Minute, Second)), UTime) :-
    mars_epoch_timestamp(Epoch),
    mars_seconds_per_sol(SecondsPerSol),
    OffsetSeconds is (((MarsYear - 2026) * 668) + (Sol - 1)) * SecondsPerSol + Hour * 3600 + Minute * 60 + Second,
    Timestamp is Epoch + OffsetSeconds,
    stamp_date_time(Timestamp, date(Year, Month, Day, UHour, UMinute, USecondFloat, _, _, _), 'UTC'),
    USecond is floor(USecondFloat),
    UTime = utime(Year, Month, Day, UHour, UMinute, USecond).

universal_to_local(earth, UTime, local_time(earth, Instant)) :-
    utime_to_instant(UTime, Instant).
universal_to_local(World, UTime, local_time(World, Instant)) :-
    World \= mars,
    utime_to_instant(UTime, Instant).
universal_to_local(mars, utime(Year, Month, Day, Hour, Minute, Second), local_time(mars, mars_date(MarsYear, Sol, LocalHour, LocalMinute, LocalSecond))) :-
    utime_timestamp(utime(Year, Month, Day, Hour, Minute, Second), Timestamp),
    mars_epoch_timestamp(Epoch),
    mars_seconds_per_sol(SecondsPerSol),
    Delta is Timestamp - Epoch,
    TotalSols is floor(Delta / SecondsPerSol),
    SolSecondsFloat is Delta - (TotalSols * SecondsPerSol),
    SolSeconds is max(0, floor(SolSecondsFloat)),
    MarsYear is 2026 + TotalSols // 668,
    Sol is 1 + (TotalSols mod 668),
    LocalHour is SolSeconds // 3600,
    LocalMinute is (SolSeconds mod 3600) // 60,
    LocalSecond is SolSeconds mod 60.

compare_utime(A, B, Ordering) :-
    utime_timestamp(A, TimestampA),
    utime_timestamp(B, TimestampB),
    compare(Ordering, TimestampA, TimestampB).

add_seconds(UTime, Seconds, NewUTime) :-
    utime_timestamp(UTime, Timestamp),
    NewTimestamp is Timestamp + Seconds,
    stamp_date_time(NewTimestamp, date(Year, Month, Day, Hour, Minute, SecondFloat, _, _, _), 'UTC'),
    Second is floor(SecondFloat),
    NewUTime = utime(Year, Month, Day, Hour, Minute, Second).

utime_timestamp(utime(Year, Month, Day, Hour, Minute, Second), Timestamp) :-
    valid_instant(instant(Year, Month, Day, Hour, Minute, Second)),
    date_time_stamp(date(Year, Month, Day, Hour, Minute, Second, 0, -, -), Timestamp).

mars_epoch_timestamp(Timestamp) :-
    date_time_stamp(date(2026, 1, 1, 0, 0, 0, 0, -, -), Timestamp).

mars_seconds_per_sol(88775.244).
