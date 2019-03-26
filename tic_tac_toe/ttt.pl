game:-
	length(FIELD,9),
	display_field(FIELD),
	play(FIELD,0),!.

which_player(TURN, player_1, x):- TURN mod 2 =:= 0,!.
which_player(TURN, player_2, o):- TURN mod 2 =:= 1.
	
play(FIELD, TURN):-
	TURN >= 9 -> writeln('draw');
	which_player(TURN, Player, Mark),
	repeat,
	get_player_input(FIELD, Player, CELL),
	CELL = Mark,
	display_field(FIELD),
	(check(FIELD) -> format('~w wins',[Player]),nl,!;
	NEXT_TURN is TURN + 1,
	play(FIELD, NEXT_TURN)).
	
get_player_input(FIELD, Player, CELL):-
	format('~w: choose a field~n',[Player]),
	prompt(_,''),
	get_single_char(N),
	char_code(CHAR,N),
	atom_number(CHAR, NUMBER),
	convert_numpad(NUMBER, NUMPAD),
	nth1(NUMPAD,FIELD,CELL),
	var(CELL), !.
	
convert_numpad(1, 7).
convert_numpad(2, 8).
convert_numpad(3, 9).
convert_numpad(4, 4).
convert_numpad(5, 5).
convert_numpad(6, 6).
convert_numpad(7, 1).
convert_numpad(8, 2).
convert_numpad(9, 3).

%display_field([x,o,x,o,x,o,x,o,x]).
%display_field([x,o,x,o,_,_,x,o,x]).
	
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