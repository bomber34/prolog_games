%Connect four is a 7x6 field
info:-
	format('Connect 4~n
	The Player who manages to align 4 tokens of the same color in a row column or diagonal wins~n
	Pick a column by pressing a number between 1 <= N <= 7.
	~ngame. %starts the game~ninfo. %show help~n~n~n',[]).
	
:- info.

test1:-
	findall(Num, between(1,42,Num),L),
	get_cols(L,Cols),
	writeCols(Cols).
	
exampleField(L,1):-
	L = [
		x,_,_,_,_,_,_,
		_,x,_,_,_,_,_,
		_,_,x,_,_,_,_,
		_,_,_,x,_,_,_,
		_,_,_,_,_,_,_,
		_,_,_,_,_,_,_].
		
exampleField(L,2):-
	L = [
		_,x,_,_,_,_,_,
		_,_,x,_,_,_,_,
		_,_,_,x,_,_,_,
		_,_,_,_,x,_,_,
		_,_,_,_,_,_,_,
		_,_,_,_,_,_,_].

exampleField(L,3):-
	L = [
		_,_,_,_,_,_,_,
		x,_,_,_,_,_,_,
		_,x,_,_,_,_,_,
		_,_,x,_,_,_,_,
		_,_,_,x,_,_,_,
		_,_,_,_,_,_,_].
		
exampleField(L,4):-
	L = [
		_,_,_,_,_,_,_,
		_,_,_,_,_,_,_,
		_,_,_,x,_,_,_,
		_,_,_,_,x,_,_,
		_,_,_,_,_,x,_,
		_,_,_,_,_,_,x].
		
exampleField(L,5):-
	L = [
		_,_,_,_,_,_,_,
		_,_,_,_,_,_,_,
		_,_,_,o,_,_,_,
		_,_,o,_,_,_,_,
		_,o,_,_,_,_,_,
		o,_,_,_,_,_,_].
		
test2:-
	exampleField(L,_),
	display_field(L),
	check_diagonals(L).
	
writeCols([]).
writeCols([H|T]):-
	writeln(H),
	writeCols(T).

game:-
	length(L,42),
	display_field(L),
	play(L, 0),!.

get_player(Turn, player_1, x):- Turn mod 2 =:= 0.
get_player(Turn, player_2, o):- Turn mod 2 =:= 1.	

%play
play(Field, Turn):-
	Turn >= 42, format('draw'),!;
	get_player(Turn, Player, Mark),
	get_cols(Field, Cols),
	pick_col(Cols, Cell),
	Next_Turn is Turn+1,
	Cell = Mark,
	display_field(Field),
	(check_field(Field) -> format('~w wins',[Player]),!;
	play(Field, Next_Turn)).
	
pick_col(Cols, Cell):-
	writeln('pick a free column'),
	repeat,
	make_selection(Number, 7),
	get_free_spot(Cols, Number, Cell),
	!.
	
get_free_spot(Cols, Number, Cell):-
	nth1(Number, Cols, Col),
	get_free_spot_(Col, Cell).
	
get_free_spot_([A],Cell):-
	var(A), A = Cell,!.

get_free_spot_([A,B|_], Cell):-
	var(A), nonvar(B), A = Cell,!.

get_free_spot_([_|T],Cell):-
	get_free_spot_(T,Cell).
	

make_selection(NUMBER, LIMIT):-
	repeat,
	prompt(_,''),
	get_single_char(C),
	char_code(KEY, C),
	atom_number(KEY, NUMBER),
	NUMBER >= 1,
	NUMBER =< LIMIT,
	!.
	
	
%get information about field
get_rows([],[]).
get_rows([A,B,C,D,E,F,G|T],[[A,B,C,D,E,F,G]|T2]):-
		get_rows(T,T2).
		
get_cols(Field, Cols):-
	get_rows(Field, Rows),
	get_cols_(Rows,Cols).
	
get_cols_([[],[],[],[],[],[]],[]).
get_cols_([[A|As],[B|Bs],[C|Cs],[D|Ds],[E|Es],[F|Fs]],[[A,B,C,D,E,F]|Cols]):-
	get_cols_([As,Bs,Cs,Ds,Es,Fs],Cols).

%check win condition
check_field(Field):-
	check_row(Field),!;
	check_col(Field),!;
	check_diagonals(Field).

check_row(Field):-
	get_rows(Field,Rows),
	check_row_(Rows).

check_row_([[A,B,C,D|_]|_]):-
		nonvar(A), nonvar(B), nonvar(C), nonvar(D),
		A=B,A=C,A=D,!.
check_row_([[_|T]|T2]):-
	check_row_([T|T2]).

check_row_([_|T]):-
	check_row_(T).
	
check_col(Field):-
	get_cols(Field,Cols),
	check_row_(Cols).
	
check_diagonals(Field):-
	get_cols(Field, Cols),
		(check_right_diagonals(Cols),!;
		reverse(Cols,RevCols), check_right_diagonals(RevCols)),!.
	
%check_right_diagonals([[A,_,_,_|_],[B,_,_|_],[C,_|_],[D|_]|_]):-
%	nonvar(A), nonvar(B), nonvar(C), nonvar(D),
%	A = B, A = C, A = D, !.
	
check_right_diagonals([[A,_,_,_|_],[_,B,_,_|_],[_,_,C,_|_],[_,_,_,D|_]|_]):-
	nonvar(A), nonvar(B), nonvar(C), nonvar(D),
	A = B, A = C, A = D, !.

check_right_diagonals([[_|AT],[_|BT],[_|CT],[_|DT]|_]):-
	L = [AT,BT,CT,DT],
	check_right_diagonals(L).
	
check_right_diagonals([_|T]):-
	check_right_diagonals(T).

%Field display 
display_field(L):-
	get_rows(L, Rows),
	display_line,
	display_rows(Rows).

display_rows([]).
display_rows([Row|Rows]):-
		display_row(Row),
		display_line,
		display_rows(Rows).

display_row([]):- writeln('|').
display_row([H|T]):-
	write('|'),
	(var(H) -> write(' '); write(H)),
	display_row(T).

display_line:-
	display_line(15).
	
display_line(0):- nl.
display_line(Times):-
	Times > 0,
	T1 is Times-1,
	write('-'),
	display_line(T1).