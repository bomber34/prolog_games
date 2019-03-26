
info:-
	format("Tic Tac Toe:~nThe Player who matches a row a column or a diagonal in their symbol wins.~nThe Numpad's keys 1 to 9 match their position on the field.~n~n~ngame. %starts the game~ninfo. %displays this message again~n~n",[]).

:- info.
	
game:-
	set_mode,
	length(FIELD,9),
	display_field(FIELD),
	two_players(FIELD,0),!,
	reset_global.

set_mode:-
	writeln('Select a mode'),
	writeln('1: 2 Player'),
	writeln('2: random bot'),
	writeln('3: good bot'),
	make_selection(NUMBER, 3),
	set_options(NUMBER).

reset_global:-
	nb_delete(mode),
	nb_delete(bot1),
	nb_delete(bot2),
	nb_delete(diff).
	
make_selection(NUMBER, LIMIT):-
	repeat,
	prompt(_,''),
	get_single_char(C),
	char_code(KEY, C),
	atom_number(KEY, NUMBER),
	NUMBER >= 1,
	NUMBER =< LIMIT,
	!.

set_options(1):- nb_setval(mode, multi).
set_options(2):- nb_setval(mode, cpu), set_player(random).
set_options(3):- nb_setval(mode, cpu), set_player(good).

set_player(DIFFICULTY):-
	nb_setval(diff, DIFFICULTY),
	writeln('Choose your mark:'),
	writeln('1: x (player 1)'),
	writeln('2: o (player 2)'),
	writeln('3: Bot vs bot'),
	make_selection(NUMBER, 3),
	set_player_(NUMBER).
	
set_player_(1):- 
	nb_setval(bot2,cpu).
set_player_(2):-
	nb_setval(bot1,cpu).
set_player_(3):-
	set_player_(1), set_player_(2).
	
which_player(TURN, computer, x):- nb_current(bot1,cpu),TURN mod 2 =:= 0,!.
which_player(TURN, player_1, x):- TURN mod 2 =:= 0,!.
which_player(TURN, computer, o):- nb_current(bot2,cpu),TURN mod 2 =:= 1,!.
which_player(TURN, player_2, o):- TURN mod 2 =:= 1.

two_players(_,11):- which_player(12, Player,_),format('~w wins',[Player]),nl,!.
two_players(_,22):- which_player(23, Player,_),format('~w wins',[Player]),nl,!.
two_players(_, 9):- writeln('draw'),!.
two_players(FIELD, TURN):-
	play(FIELD, TURN, NEXT_TURN),
	(check(FIELD) -> 
		(
		NEXT_TURN mod 2 =:= 1, two_players(_,11), !;
		two_players(_,22)
		);
	two_players(FIELD, NEXT_TURN)).

play(FIELD, TURN, NEXT_TURN):-
	which_player(TURN, Player, Mark),
	repeat,
	get_player_input(FIELD, Player, CELL),
	CELL = Mark,
	display_field(FIELD),
	NEXT_TURN is TURN + 1.
	
get_player_input(FIELD, computer, CELL):-
	nb_current(diff, random),
	repeat,
	random_member(CELL, FIELD),
	var(CELL),
	sleep(0.3),
	!.

%TODO write a good bot
	
get_player_input(FIELD, Player, CELL):-
	format('~w: choose a field~n',[Player]),
	prompt(_,''),
	%get_single_char(N),
	%char_code(CHAR,N),
	%atom_number(CHAR, NUMBER),
	make_selection(NUMBER, 9),
	convert_numpad(NUMBER, NUMPAD),
	nth1(NUMPAD,FIELD,CELL),
	var(CELL), !.
	
%Controls
convert_numpad(1, 7).
convert_numpad(2, 8).
convert_numpad(3, 9).
convert_numpad(4, 4).
convert_numpad(5, 5).
convert_numpad(6, 6).
convert_numpad(7, 1).
convert_numpad(8, 2).
convert_numpad(9, 3).

% Display everything done so far	
display_field(FIELD):-
	convert(FIELD, CLEAN_FIELD),
	format('~w|~w|~w~n-----~n~w|~w|~w~n-----~n~w|~w|~w~n~n',CLEAN_FIELD).
	
convert([],[]).
convert([N|T],[-|T2]):-
	var(N),!,
	convert(T,T2).
convert([x|T],[x|T2]):-
	convert(T,T2).
convert([o|T],[o|T2]):-
	convert(T,T2).

%Win conditions
	
check(FIELD):-
	check_rows(FIELD),!;
	check_cols(FIELD),!;
	check_diagonal(FIELD).

are_nonvars([]).
are_nonvars([A|T]):-
		nonvar(A),
		are_nonvars(T).

are_equal([A,A,A]).

check_rows([]):- fail.
check_rows([A,B,C|_]):-
	are_nonvars([A,B,C]),
	are_equal([A,B,C]),!.
check_rows([_,_,_|T]):-
	check_rows(T).
	

check_cols([A,_,_,B,_,_,C,_,_]):-
		are_nonvars([A,B,C]),
		are_equal([A,B,C]),!.
check_cols([_,A,_,_,B,_,_,C,_]):-
		are_nonvars([A,B,C]),
		are_equal([A,B,C]),!.
check_cols([_,_,A,_,_,B,_,_,C]):-
		are_nonvars([A,B,C]),
		are_equal([A,B,C]),!.
		
check_diagonal([A,_,_,_,B,_,_,_,C]):-
	are_nonvars([A,B,C]),
	are_equal([A,B,C]),!.
	
check_diagonal([_,_,A,_,B,_,C,_,_]):-
	are_nonvars([A,B,C]),
	are_equal([A,B,C]),!.