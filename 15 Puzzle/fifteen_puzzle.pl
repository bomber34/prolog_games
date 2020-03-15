:- use_module(library(clpfd)).

:- writeln('Type start. to play the game'), writeln('Or type start(X) to select a puzzle'), writeln('X = 1 or 2 is a predefined puzzle, all other inputs will give you a random puzzle').

cls :- write('\e[H\e[2J').

puzzle(1, [[f,e,1,6],[9,b,4,c],[0,a,7,3],[d,8,5,2]]).
puzzle(2, [[0,c,9,d],[f,b,a,e],[3,7,2,5],[4,8,6,1]]).
puzzle(_, P):-
    length(Puzzle, 16),
    PossibleNumbers = [0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f],
    repeat,
    randomize(Puzzle, PossibleNumbers, 16),
    inversion_sum(Puzzle,InverseSum),
    nth0(ZeroPos, Puzzle, 0),
    ZeroRow is (ZeroPos // 4) + 1,
    0 =:= (InverseSum +ZeroRow) mod 2,!,
    partition(Puzzle,P).
    
partition([],[]).
partition([A,B,C,D|T],[[A,B,C,D]|T2]):-
    partition(T,T2).
    
randomize([], [], 0).
randomize([N|T], PossibleNumbers, Length):-
    random_between(1,Length, RandomIndex),
    nth1(RandomIndex, PossibleNumbers, N, RestPosNums),
    succ(PLen, Length),
    randomize(T,RestPosNums, PLen).
    
inversion_sum([],0).
inversion_sum([0|T],Sum):- inversion_sum(T,Sum).
inversion_sum([X|T], Sum):-
    inversion_sum(T,PartialSum),
    PossibleNumbers = [0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f],
    nth0(IndX, PossibleNumbers, X),
    count_smaller_members(IndX,T,PossibleNumbers,Count),
    Sum is PartialSum + Count.
    
count_smaller_members(_,[],_,0).
count_smaller_members(IndX,[Y|T], PossibleNumbers ,C):-
    nth0(IndY, PossibleNumbers, Y),
    ((IndX > IndY, IndY > 0) -> count_smaller_members(IndX,T,PossibleNumbers,C1), succ(C1,C);
    count_smaller_members(IndX, T, PossibleNumbers, C)).
    

start:- 
    start(1).
start(X):-
    puzzle(X, P),
    cls,
    display_puzzle(P, 0),
    play(P, 0),!.
    
goal([[1,2,3,4],[5,6,7,8],[9,a,b,c],[d,e,f,0]]).

play(Puzzle, Moves):-
    goal(Puzzle) -> format('You have solved the puzzle in ~d moves', [Moves]);
    get_move(Puzzle,Move),
    (Move = quit -> abort; true),
    apply_move(Puzzle, Move, NewPuzzleState),
    cls,
    succ(Moves, NextMoveCount),
    display_puzzle(NewPuzzleState, NextMoveCount),
    play(NewPuzzleState, NextMoveCount).

apply_move(Map, r, NewState):-
    make_move(Map, r, NewState).
apply_move(Map, l, NewState):-
    make_move(Map, l, NewState).
apply_move(Map, u, NewState):-
    transpose(Map, TMap),
    make_move(TMap, l, NewTMap),
    transpose(NewTMap, NewState).
apply_move(Map, d, NewState):-
    transpose(Map, TMap),
    make_move(TMap, r, NewTMap),
    transpose(NewTMap, NewState).
    
make_move([], _, []):- !.
make_move([Row|Rows], Direction, [Row|Rows2]):-
    \+ member(0, Row),
    make_move(Rows, Direction, Rows2),!.
make_move([Row|Rows], Direction, [NewRow|Rows]):-
    member(0, Row),
    (Direction = r -> nextto(0, X, Row), swap(0-X, Row, NewRow);
                      nextto(X,0,Row), swap(X-0, Row, NewRow)).
                      
swap(L-R, [L,R|Rest], [R,L|Rest]):- !.
swap(L-R, [X,Y|Rest], [X|T2]):-
    X \= L, swap(L-R, [Y|Rest],T2).

get_move(Puzzle, Move):-
    repeat,
    get_single_char(Direction),
    write('\r\b'),
    move(Direction, Move),
    is_valid(Puzzle, Move),nl,!.

%set of valid inputs
move(16, u).
move(14, d).
move(2, l).
move(6, r).
move(27, quit).
move(-1, quit).

is_valid(_, quit).
is_valid(P, l):-
    \+ include([Row]>>(nextto(_,0,Row)),P, []).
is_valid(P, r):-
    \+ include([Row]>>(nextto(0,_,Row)),P, []). 
is_valid(P, u):-
    transpose(P, TransP),
    \+ include([Row]>>(nextto(_,0,Row)),TransP, []).    
is_valid(P, d):-
    transpose(P, TransP),
    \+ include([Row]>>(nextto(0,_,Row)),TransP, []).    

display_puzzle(P, M):- 
    get_padding(M, Padding),
    format('Moves: ~s~d~n~n', [Padding, M]), 
    display_puzzle(P).
display_puzzle([]):- nl,!.
display_puzzle([Row|Rows]):-
    writeln(Row),
    display_puzzle(Rows).
    
get_padding(M, Padding):-
    between(0,9,M) -> Padding = "    ";
    between(10,99,M) -> Padding = "   ";
    between(100,999,M) -> Padding = "  ";
    between(1000,9999,M) -> Padding = " ";
    Padding = "".