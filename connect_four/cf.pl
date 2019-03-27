%Connect four is a 7x6 field
info:-
	format('Connect 4~n
	The Player who manages to align 4 tokens of the same color in a row column or diagonal wins~n
	Pick a column by pressing a number between 1 <= N <= 7.
	~ngame. %starts the game~ninfo. %show help~n~n~n',[]).
	
:- info.

test:-
	findall(Num, between(1,42,Num),L),
	get_cols(L,Cols),
	writeCols(Cols).
	
writeCols([]).
writeCols([H|T]):-
	writeln(H),
	writeCols(T).

game:-
	length(L,42),
	display_field(L).
	
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