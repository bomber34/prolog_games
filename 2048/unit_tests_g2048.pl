:- consult('g2048.pl').
:- cls.

:- begin_tests(row_movement).
test(move_rows):-
    move_rows([[0,0,0,0]], [[0,0,0,0]]).
    
test(move_rows):-
    move_rows([[2,2,0,0]], [[4,0,0,0]]).
    
test(move_rows):-
    move_rows([[0,2,0,2]], [[4,0,0,0]]).
    
test(move_rows):-
    move_rows([[4,0,0,4]], [[8,0,0,0]]).
    
test(move_rows):-
    move_rows([[2,2,2,2]], [[4,4,0,0]]).
    
test(move_rows):-
    move_rows([[2,4,8,16]], [[2,4,8,16]]).
    
test(move_rows):-
    move_rows([[4,4,8,16]], [[8,8,16,0]]).
    
test(move_rows):-
    move_rows([[16, 8, 4, 4]], [[16, 8, 8, 0]]).
:- end_tests(row_movement).

%Test if at start a valid map is created
:- begin_tests(map_creation).

test(create_field):-
    create_field(Map, 4), length(Map, 16).

test(create_field):-
    create_field(Map, 5), length(Map, 25).

test(create_field):-
    create_field(Map, 4), select(2,Map, Map1), select(2,Map1, Map2), !, \+ (member(X,Map2), X =\= 0).

:- end_tests(map_creation).

:- begin_tests(map_movement).

test(map_movement):-
    Map = 
        [
        0, 4, 0, 0,
        2, 0, 0, 2,
        0, 2, 8, 0,
        2, 2, 8, 0
        ],
    apply_move_to_map(Map, 4, "left", NewMap),
    NewMap =
        [
        4, 0, 0, 0,
        4, 0, 0, 0,
        2, 8, 0, 0,
        4, 8, 0, 0
        ].
        
test(map_movement):-
    Map = 
        [
        0, 4, 0, 0,
        2, 0, 0, 2,
        0, 2, 8, 0,
        2, 2, 8, 0
        ],
    apply_move_to_map(Map, 4, "right", NewMap),
    NewMap =
        [
        0, 0, 0, 4,
        0, 0, 0, 4,
        0, 0, 2, 8,
        0, 0, 4, 8
        ].
        
test(map_movement):-
    Map = 
        [
        0, 4, 0, 0,
        2, 0, 0, 2,
        0, 2, 8, 0,
        2, 2, 8, 0
        ],
    apply_move_to_map(Map, 4, "down", NewMap),
    NewMap =
        [
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 4, 0, 0,
        4, 4, 16, 2
        ].

test(map_movement):-
    Map = 
        [
        0, 4, 0, 0,
        2, 0, 0, 2,
        0, 2, 8, 0,
        2, 2, 8, 0
        ],
    apply_move_to_map(Map, 4, "up", NewMap),
    NewMap =
        [
        4, 4, 16, 2,
        0, 4, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0
        ].
:- end_tests(map_movement).


:- begin_tests(win_state).
   
test(win_state):-   
    Map = 
    [
        0, 0, 0, 0,
        0, 2, 4, 8, 
        16, 32, 64, 128, 
        256, 512, 1024, 2048
    ],
    win_condition(Map).

test(win_state):-   
    Map = 
    [
        0, 0, 0, 0,
        0, 2, 4, 8, 
        16, 32, 64, 128, 
        256, 256, 1024, 1024
    ],
    apply_move_to_map(Map, 4, "right", NewMap),
    win_condition(NewMap).
    
:- end_tests(win_state).

:- begin_tests(lose_state).
test(lose_state):-
    Map = 
    [2, 4, 8, 16,
    32, 64, 128, 256,
    64, 32, 8, 16,
    2, 4, 256, 32],
    \+ valid_state(Map, 4).
    
% edge cases with borders
test(lose_state):-
    Map = 
    [64, 4, 8, 16,
    16, 64, 128, 256,
    256, 32, 8, 64,
    64, 4, 256, 32],
    \+ valid_state(Map, 4).
:- end_tests(lose_state).

:- begin_tests(transpose).
test(transpose):-
    Map = 
    [0, 1, 2, 3,
     4, 5, 6, 7,
     8, 9, a, b,
     c, d, e ,f],
     transpose_list(Map, 4, TMap),
     TMap = 
     [0, 4, 8, c,
      1, 5, 9, d,
      2, 6, a, e,
      3, 7, b, f].
      
test(transpose):-
    Map = 
    [0, 1, 2, 3,
     4, 5, 6, 7,
     8, 9, a, b,
     c, d, e ,f],
     transpose_list(Map, 4, TMap),
     transpose_list(TMap, 4, Map).
:- end_tests(transpose).

:- begin_tests(score_update).

test(score_update):-
    Map = 
    [0,0,0,0,
    0,0,0,0,
    2,0,0,2,
    0,0,0,0],
    apply_move_to_map(Map, 4, "right", NewMap),
    get_score_update(Map, NewMap, Score),
    assertion(Score =:= 4).

test(score_update):-
    Map = 
    [0,0,0,0,
    0,0,0,0,
    2,0,0,2,
    0,0,0,0],
    apply_move_to_map(Map, 4, "up", NewMap),
    get_score_update(Map, NewMap, Score),
    assertion(Score =:= 0).

:- end_tests(score_update).

%Run all when file is opened in prolog 
:- run_tests.