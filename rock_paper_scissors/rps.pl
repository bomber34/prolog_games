:- use_module(library(threadutil)).
:- dynamic item/1.
item(nothing).

game:-
	write('Rock Paper Scissors:'),nl,
	write('when the game starts, select an item in 3 seconds'),nl,
	write("if you fail to do so, you'll lose"),nl,nl,
	repeat,
	turn,
	newgame,
	!.

newgame:-
	write('Type n to stop or anything else to retry: '),
	get_single_char(N), nl,
	N = 110.
	
cancel_choose:-
	catch(thread_signal(choice, abort), _, true).

turn:-
	var(PLAYER_ITEM),
	catch(thread_create(countdown(3), ID_COUNTDOWN, []),_,PLAYER_ITEM = nothing),
	catch(choose(PLAYER_ITEM),_,true),
	catch(thread_join(ID_COUNTDOWN),_,PLAYER_ITEM = nothing),
	ai_pick(AI_ITEM),
	item(PLAYER_ITEM),!,
	play(PLAYER_ITEM, AI_ITEM),
	(PLAYER_ITEM = nothing -> true,!; retract(item(PLAYER_ITEM))),!.

play(PLAYER_ITEM, AI_ITEM):-
	nonvar(PLAYER_ITEM),PLAYER_ITEM = nothing, write('You did not choose an item and lost'),nl,!;
	play(PLAYER_ITEM, WORD, AI_ITEM),
	format('player wins: ~w ~w ~w', [PLAYER_ITEM, WORD, AI_ITEM]),nl, !;
	play(AI_ITEM, WORD, PLAYER_ITEM),
	format('computer wins: ~w ~w ~w', [AI_ITEM, WORD, PLAYER_ITEM]),nl, !;
	format('draw: ~w ~w ~w', [PLAYER_ITEM, draws, AI_ITEM]),nl.
	
play(rock, destroys, scissor).
play(scissor, cuts, paper).
play(paper, wraps, rock).

choose(ITEM):-
	repeat,
	write('Choose your item:'),nl,
	write('1: rock'),nl,
	write('2: paper'),nl,
	write('3: scissor'),nl,
	get_single_char(C),
	valid_choice(C, ITEM), 
	%ITEM = rock,
	asserta(item(ITEM)),
	format('you picked: ~w', [ITEM]),nl, !.
	
valid_choice(CHAR, ITEM):-
	%ITEM = paper, !;
	char_code(PICK, CHAR),
	atom_number(PICK, NUMBER),
	nth1(NUMBER, [rock, paper, scissor], ITEM), !; write('invalid choice'),nl,fail.

ai_pick(ITEM):-
	random_member(ITEM, [rock, paper, scissor]).
	
countdown(0):- !.
countdown(N):-	
	N > 0,
	write(N), nl,
	sleep(1),
	N1 is N-1,
	countdown(N1).