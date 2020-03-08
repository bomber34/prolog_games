:- consult('g2048.pl').

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

%L = [0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f],length(L,M),S is floor(sqrt(M)), draw_map(L,S), transpose_list(L, S, TL), draw_map(TL, S), 
% transpose_list(TL, S, TTL),draw_map(TTL, S).

%Run all when file is opened in prolog 
:- run_tests.