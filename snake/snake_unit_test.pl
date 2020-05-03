
:- consult('snake.pl').

:- begin_tests(map).
test(map):-
    create_map(Map),
    length(Map, Rows),
    height(Rows),
    Map = [Col|Cols],
    length(Col, ColLength),
    width(ColLength),
    maplist(same_length(Col), Cols).
:- end_tests(map).

:- begin_tests(spawn).

test(spawn, all([_]):-
    create_map(InitialMap),
    spawn_player(InitialMap, Map),
    append([_|PlayField],[_],Map),
    member(Row, PlayField),
    member('x', Row).

:- end_tests(spawn).

:- run_tests.

% Ignore the banner message
:- set_prolog_flag(verbose, silent).