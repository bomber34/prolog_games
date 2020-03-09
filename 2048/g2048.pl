cls :- write('\e[H\e[2J').
welcome_msg :-
    format('Type start. to play on a default 4x4 map~nType start(N) with X being an integer >3 to play on a NxN map.').
    
:- cls, welcome_msg, format('~n~n~n~n').

% 2048 is a simple game where a field of numbers can be moved in 4 directions
% the goal is to form a tile with the value 2048

%default start the game
start:-
    start(4).

% Starts the game with a given size
start(Size):-
    integer(Size),
    (Size < 4 -> format('Map is too small~n'),abort; true),
    (Size > 12 -> format('Map is too huge~n'),abort; true),
    cls,
    create_field(Map, Size),
    display_score(0),
    format('Use the arrow keys to move the field or press ESC to quit ~n~n'),
    draw_map(Map, Size),
    play(Map, Size, 0).

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
    
% Fill the free spaces with zeros
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

% Play the game until the end
play(Map, Size, Score):-
    win_condition(Map) -> writeln('You have won');
    \+ valid_state(Map, Size) -> writeln('You have lost');
    get_move(Move),
    (Move = "quit" -> abort; true),
    apply_move_to_map(Map, Size, Move, TransfMap),
    (TransfMap = Map -> 
        play(TransfMap, Size, Score);
        cls,
        update_score(Map, TransfMap, Score, NewScore),
        display_score(NewScore),
        format("Your last move was: ~w~n~n", [Move]),
        add_random_tile(TransfMap, NextMap),
        draw_map(NextMap, Size),
        format("Press an arrow key to move the board or press ESC to quit~n~n"),
        play(NextMap, Size, NewScore)
    ).

% game is won, when a 2048 tile exists
win_condition(Map):-
    member(2048, Map).

%Update current score with new MapState
update_score(MapState, NewMapState, OldScore, Score):-
    get_score_update(MapState, NewMapState, Update),
    Score is OldScore + Update.

% Score is the sum of the subtraction between List 1 and List 2
get_score_update([], NewState, Score):-
    sum_list(NewState, Score),!.
get_score_update([H|T], NewState, Score):-
    select(H,NewState, NextState) ->
    get_score_update(T, NextState, Score);
    get_score_update(T, NewState, Score).

%After a successful move, a random 0 tile gets replaced by either 2 or 4
add_random_tile(Map, NewMap):-
    findall(Index, nth1(Index, Map, 0), Indices),
    random_member(RandomIndex, Indices),
    nth1(RandomIndex, Map, 0, Rest), %swap two elements
    random_member(RandomVal, [2,2,2,2,2,2,2,2,2,4]), %10 percent chance that 4 is selected
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
    repeat,
    get_single_char(K),
    write('\r\b'),
    get_key(K, Move),nl, !.

%Key codes for the arrow keys
get_key(-1, "fail"). %if user tries to close program during input
get_key(27, "quit"). %escape key to quit game
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
    get_padding(N, Padding),
    format('~s~a',[Padding, N]),
    succ(S1,S),
    draw_map_(T,S1,Size).
  
%Show current score on screen  
display_score(Score):-
    get_padding(Score, Padding),
    format('Score:~s~a~n',[Padding,Score]).
    
% Depending of num length, get padding
get_padding(N, Padding):-
    WhiteSpace = "          ",
    string_length(N, Length),
    sub_string(WhiteSpace, Length,_,0,Padding) -> true; Padding = "". %safety condition if score gets too huge