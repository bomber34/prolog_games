:- set_prolog_flag(verbose, silent).

width(23).
height(23).

my_list(1,
[
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
]).

start :- my_list(1, L), game_of_life(L).

game_of_life(List):-
    write("\e[H\e[2J"),
    game_of_life(List, 0), !.
    
game_of_life(_, 100):- !.
game_of_life(L, Iteration):-
    write("\e[H"),
    Iteration < 100,
    display_field(L, Iteration), 
    sleep(0.2),
    next_iteration(L, 1, Next),
    (Next == L -> writeln("Equilibrium was reached");
    succ(Iteration, NextIt),
    game_of_life(Next, NextIt)).
    
next_iteration(_, Index, []):-
    width(W), height(H),
    Index > W * H.
next_iteration(L, Index, [X|T]):-
    width(W), height(H),
    Index =< W * H,
    count_neighbours(L,Index, NumNeighbours),
    nth1(Index, L, Current),
    ((Current =:= 0, NumNeighbours =:= 3;
    Current =:= 1, between(2,3,NumNeighbours))
    -> X = 1; X = 0),
    succ(Index, NextIndex),
    next_iteration(L, NextIndex ,T).
        
count_neighbours(L, Index, NumNeighbours):-
    width(W),
    LN is Index-1,
    RN is Index+1,
    UN is Index - W,
    DN is Index + W,
    ULN is Index - W - 1,
    URN is Index - W + 1,
    DLN is Index + W - 1,
    DRN is Index + W + 1,
    findall(N, (member(N, [LN,RN,UN,DN, ULN, URN, DLN, DRN]), is_living(L, N)), LivingNeigbours),
    length(LivingNeigbours, NumNeighbours).
    
is_living(L, Index):-
    nth1(Index, L, 1).
    
    
display_field([], Iteration):- format("Iteration: ~d~n", [Iteration]).
display_field([0|T], Iteration):-
    write(' '),
    length(T, Len),
    width(W),
    ignore((Len mod W =:= 0, nl)),
    display_field(T, Iteration).
display_field([1|T], Iteration):-
    write('\e[40m \e[0m'),
    length(T, Len),
    width(W),
    ignore((Len mod W =:= 0, nl)),
    display_field(T, Iteration).