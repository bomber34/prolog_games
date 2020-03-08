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


%Run all when file is opened in prolog 
:- run_tests.