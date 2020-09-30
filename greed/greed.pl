%%%%%%%%%%%% setup %%%%%%%%%%%% 
width(79).
height(22).

game:-
    width(W), height(H),
    create_field(H, W, Field, Cursor),
    print_field(Field),
    once(turn_start(Field, Cursor)).

%%%%%%%%%%%% Init %%%%%%%%%%%% 
create_field(Height, Width, Field, cursor(X,Y)):-
    Size is Height * Width,
    length(Map, Size),
    random_member(@, Map),
    maplist([X] >> (once(random_between(1, 9, X) ; X == @)), Map),
    once(split_list(Map, Width, ColList)),
    length(FieldCols, Height),
    dismember_field(Field, FieldCols, ColList),
    once(nth0(Index, Map, @)),
    X is (Index mod Width) + 1,
    Y is (Index // Width) + 1.

split_list([], _, []).
split_list(Map, Width, [Row|T]):-
    length(Row, Width),
    append(Row, Rest, Map),
    split_list(Rest, Width, T).

dismember_field(Field, FieldRows, RowList):-
    Field =.. [field | FieldRows],
    maplist([RowObj, Row] >> (RowObj =.. [row|Row]), FieldRows, RowList).

%%%%%%%%%%%% Logic %%%%%%%%%%%% 
turn_start(Field, Cursor):-
    update_screen(Field),
    possible_moves(Field, Cursor, PossibleMoves),
    (PossibleMoves == [] -> 
        game_over; % TODO: End game message
        turn(Field, Cursor, PossibleMoves)).

turn(Field, Cursor, PossibleMoves):-
    repeat,
    get_direction(Direction),
    continue_game(Direction),
    member(Direction, PossibleMoves),
    get_number(Field, Cursor, Direction, Move),
    go_direction(Field, Cursor, Direction, Move, NewCursor),
    once(turn_start(Field, NewCursor)).

continue_game(quit):- cls, welcome_msg, abort.
continue_game(_).

get_number(Field, cursor(X, Y), vec(VecX, VecY), Value):-
    X1 is X + VecX,
    Y1 is Y + VecY,
    arg(Y1, Field, Row),
    arg(X1, Row, Value),
    number(Value).

possible_moves(Field, Cursor, PossibleMoves):-
    once(possible_moves_(Field, Cursor, [vec(-1,-1), vec(0, -1), vec(1, -1), vec(-1, 0), vec(1, 0), vec(-1, 1), vec(0,1), vec(1, 1)], PossibleMoves)).

possible_moves_(_, _, [], []).
possible_moves_(Field, Cursor, [Vec|T1], [Vec|T2]):-
    get_number(Field, Cursor, Vec, Moves),
    is_in_boundary(Cursor, Vec, Moves),
    check_direction(Field, Cursor, Vec, Moves),
    possible_moves_(Field, Cursor, T1, T2).
possible_moves_(Field, Cursor, [_|T1], PossibleMoves):-
    possible_moves_(Field, Cursor, T1, PossibleMoves).
    
is_in_boundary(cursor(X,Y), vec(VecX, VecY), Moves):-
    PosX is X + (VecX*Moves),
    PosY is Y + (VecY*Moves),
    height(H),
    width(W),
    between(1, W, PosX),
    between(1, H, PosY).

check_direction(_, _, _, 0).
check_direction(Field, cursor(X,Y), vec(VecX, VecY), Move0):-
    Move0 > 0,
    arg(Y, Field, Row),
    arg(X, Row, Value),
    once((number(Value); Value == @)),
    succ(Move1, Move0),
    X1 is X + VecX,
    Y1 is Y + VecY,
    check_direction(Field, cursor(X1, Y1),  vec(VecX, VecY), Move1).

go_direction(Field, Cursor, _, 0, Cursor):-
    Cursor = cursor(X, Y),
    arg(Y, Field, Row),
    setarg(X, Row, @).
go_direction(Field, cursor(X,Y), vec(VecX, VecY), Move0, NewCursor):-
    Move0 > 0,
    arg(Y, Field, Row),
    setarg(X, Row, ' '),
    succ(Move1, Move0),
    X1 is X + VecX,
    Y1 is Y + VecY,
    go_direction(Field, cursor(X1, Y1), vec(VecX, VecY), Move1, NewCursor).

get_score(Field, Score):-
    dismember_field(Field, _, Rows),
    count_spaces(Rows, 0, Score).

% score is the number of empty spaces in the field
count_spaces([], Score, Score).
count_spaces([Row|T], Acc, Score):-
    count_spaces_(Row, 0, RowScore),
    Acc1 is Acc + RowScore,
    count_spaces(T, Acc1, Score).

count_spaces_([], RowScore, RowScore).
count_spaces_([' '| T], Acc, RowScore):-
    succ(Acc, Acc1),
    count_spaces_(T, Acc1, RowScore).
count_spaces_([Elem|T], Acc, RowScore):-
    Elem \== ' ',
    count_spaces_(T, Acc, RowScore).

%%%%%%%%%%%% Visuals %%%%%%%%%%%%
cls :- write('\e[H\e[2J').

update_screen(Field):-
    cls,
    print_field(Field),
    print_score(Field).

print_field(Field):-
    dismember_field(Field, _, RowList),
    % TODO: colorize @
    maplist(writeln, RowList), nl.

print_score(Field):-
    get_score(Field, Score),
    get_padding(Score, Padding),
    format("Score: ~w~d~n~n", [Padding, Score]).

get_padding(Score, ""):-
    Score >= 1000.
get_padding(Score, "0"):-
    between(100, 999, Score).
get_padding(Score, "00"):-
    between(10, 99, Score).
get_padding(Score, "000"):-
    Score < 10.

welcome_msg:-
    maplist(writeln, [  "Welcome to greed!",
                        "You move with the numpad keys.",
                        "You move into that direction n-times for the first field you hit.",
                        "Try to clear up the map as much as possible!",
                        "",
                        "Start the game by typing 'game.' into the query!",
                        ""
                    ]).
game_over:- format("Game Over.~nType 'reset.' to read the welcome message again or 'game.' to restart the game").
reset:- cls, welcome_msg.
:- set_prolog_flag(verbose, silent), reset.


%%%%%%%%%%% Controls %%%%%%%%%%%% 
get_direction(Direction):-
    repeat,
    get_single_char(InputCode),
        (InputCode == -1 -> Direction = quit;
        char_code(Input, InputCode),
        map_input(Input, Direction)).
    
map_input('\033\', quit).
map_input(q, quit).
map_input('1', vec(-1,  1)).
map_input('2', vec( 0,  1)).
map_input('3', vec( 1,  1)).
map_input('4', vec(-1,  0)).
map_input('6', vec( 1,  0)).
map_input('7', vec(-1, -1)).
map_input('8', vec( 0, -1)).
map_input('9', vec( 1, -1)).
    