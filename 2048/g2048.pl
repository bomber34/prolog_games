% 2048 is a simple game where a field of numbers can be moved in 4 directions
% the goal is to form a tile with the value 2048

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
    
% Starts the game
start:-
    create_field(Map, 4),
    draw_map(Map, 4),
    play(Map, 4).
 
play(Map, Size):-
    member(2048, Map) -> draw_map(Map, Size), writeln('You have won');
    get_move(Move),
    format("You have moved ~w", [Move]).

%Asks user for input and waits until input was valid
get_move(Move):-
    writeln("Press an arrow key to move the board"),
    repeat,
    get_single_char(K),
    get_key(K, Move), !.

%Key codes for the arrow keys
get_key(-1, "fail"). %if user tries to close program during input
get_key(14, "down").
get_key(16, "up").
get_key(2, "left").
get_key(6, "right").
    
% Draw map on screen
draw_map(Map,Size):-
    draw_map_(Map, Size, Size).

draw_map_([], 0,_):- nl,!.
draw_map_(Map,0,Size):-
    nl,
    draw_map_(Map, Size, Size),!.
draw_map_([N|T],S,Size):-
    format('~d ',[N]),
    succ(S1,S),
    draw_map_(T,S1,Size).