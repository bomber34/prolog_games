% 2048 is a simple game where a field of numbers can be moved in 4 directions
% the goal is to form a tile with the value 2048

% Starts the game
start:-
    create_field(Map, 4),
    play(Map, 4).

% Create start field of size N^2, fill 2 tiles with start val 2 and rest with 0
create_field(Map, Size):-
    MapSize is Size*Size,
    length(Map, MapSize),
    random_between(1,MapSize,N),
    (
        repeat,
        random_between(1,MapSize,M),
        N =\= M
    ),
    !,
    nth1(N, Map, 2),
    nth1(M, Map, 2),
    fill_rest(Map),!.
    
fill_rest([]).
fill_rest([0|T]):-
    fill_rest(T),!.
fill_rest([M|T]):-
    integer(M), 
    %test legitimatecy of M, M must be in a power of 2
    log(M)/log(2) =:= floor(log(M) / log(2)),
    fill_rest(T).

% state is valid if there exists a single 0, two pairs can be filled up which are next to each other
valid_state(Map, LineSize):-
    (
    member(0,Map); 
    get_rows(Map, LineSize, Rows), member(Row, Rows), nextto(N,N,Row);  
    transpose_list(Map, LineSize, TMap), get_rows(TMap, LineSize, Rows), member(Row, Rows), nextto(N,N,Row)
    ),!.
    
% transposes a list as if it is a matrix
transpose_list(Map, LineSize, TransposedMap):-
    transpose_list_(Map,0, LineSize, TransposedMap).  
transpose_list_(_, Pos, LineSize, []):-
    Pos >= LineSize * LineSize, !.
transpose_list_(Map,Pos, LineSize, [H|T]):-
    divmod(Pos, LineSize, Div, Mod),
    MapPos is LineSize * Mod + Div,
    nth0(MapPos, Map, H),
    succ(Pos, NPos),
    transpose_list_(Map, NPos, LineSize, T).

%0 1 2 3 | 0 4 8 C
%4 5 6 7 | 
%8 9 A B |
%C D E F |
 
% Play the game until the end
play(Map, Size):-
    draw_map(Map, Size),
    win_condition(Map) -> writeln('You have won');
    \+ valid_state(Map, Size) -> writeln('You have lost');
    get_move(Move),
    format("You have moved ~w~n", [Move]),
    apply_move_to_map(Map, Size, Move, TransfMap),
    (TransfMap = Map -> 
        play(TransfMap, Size);
        add_random_tile(TransfMap, NextMap),
        play(NextMap, Size)
    ).

win_condition(Map):-
    member(2048, Map).

add_random_tile(Map, NewMap):-
    findall(Index, nth1(Index, Map, 0), Indices),
    random_member(RandomIndex, Indices),
    nth1(RandomIndex, Map, 0, Rest), %swap two elements
    random_member(RandomVal, [2,4]),
    nth1(RandomIndex,NewMap,RandomVal,Rest). 

%Apply move to all tiles, add two pairs together
apply_move_to_map(Map, Size, "up", NewMap):-
    transpose_list(Map, Size, TMap),
    apply_move_to_map(TMap, Size, "left", TNewMap),
    transpose_list(TNewMap, Size, NewMap),!.
    
apply_move_to_map(Map, Size, "down", NewMap):-
    transpose_list(Map, Size, TMap),
    apply_move_to_map(TMap, Size, "right", TNewMap),
    transpose_list(TNewMap, Size, NewMap),!.
    
apply_move_to_map(Map, Size, "right", NewMap):-
    reverse(Map,RevMap),
    apply_move_to_map(RevMap, Size, "left", RNewMap),
    reverse(RNewMap, NewMap), !.
    
apply_move_to_map(Map, Size, "left", NewMap):-
    get_rows(Map, Size, RowMap),
    move_rows(RowMap, MovedRowMaps),
    flatten(MovedRowMaps, NewMap).
    
% helper function, move needs to be applied only to single rows
move_rows([],[]):- !.
move_rows([Row|Rows],[MovedRow|T]):-
    length(Row, Len),
    move_row(Row, MovedRow_),
    move_rows(Rows, T),
    length(MovedRow_, NewRowLen),
    (
        Len =:= NewRowLen -> MovedRow = MovedRow_; 
        FillRestLen is Len - NewRowLen,
        length(Rest, FillRestLen),
        fill_rest(Rest),
        append(MovedRow_, Rest, MovedRow)
    ).

% helper function, apply movement to single row
move_row([],[]):- !.
move_row([A], [A]):- !.
move_row([0,0|T], T2):-
    move_row(T,T2),!.
move_row([0,A|T], T2):-
    A > 0,
    move_row([A|T],T2),!.
move_row([A,0|T], T2):-
    A > 0,
    move_row([A|T],T2),!.
move_row([A,B|T], [A|T2]):-
    A =\= B,
    A > 0,
    B > 0,
    move_row([B|T],T2),!.
move_row([A,A|T], [B|T2]):-
    A > 0,
    B is A+A,
    move_row(T,T2),!.
   
% Helper function turns map of size N^2 to list of lists of size N
get_rows([],_,[]):- !.
get_rows(Map, Size, [Row|T]):-
    length(Row,Size),
    append(Row, Rows, Map),
    get_rows(Rows, Size, T).

%Asks user for input and waits until input was valid
get_move(Move):-
    writeln("Press an arrow key to move the board"),
    repeat,
    get_single_char(K),
    get_key(K, Move),nl, !.

%Key codes for the arrow keys
get_key(-1, "fail"). %if user tries to close program during input
get_key(14, "down").
get_key(16, "up").
get_key(2, "left").
get_key(6, "right").
    
% Draw map on screen
draw_map(Map,Size):-
    draw_map_(Map, Size, Size).

draw_map_([], 0,_):- format('~n~n~n'),!.
draw_map_(Map,0,Size):-
    format('~n~n'),
    draw_map_(Map, Size, Size),!.
draw_map_([N|T],S,Size):-
    format('~a \t',[N]),
    succ(S1,S),
    draw_map_(T,S1,Size).