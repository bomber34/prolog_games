% :-style_check(-singleton).

miep:-
	catch(thread_signal(nums, abort), _, true).
test:-
	thread_create(number_countdown, ID1, [alias(nums)]),
	thread_create(letter_countdown, ID2, [alias(lets), at_exit(miep)]),
	thread_join(ID2),
	catch(thread_join(ID1),_, true),
	write('both countdowns were successful'),nl.

number_countdown:-
	number_countdown(2).
	
letter_countdown:-
	letter_countdown(5).

letter_countdown(0):- !.
letter_countdown(N):-
		N>0,
		Letter is 64 + N,
		char_code(L, Letter),
		write(L), nl,
		N1 is N-1,
		sleep(1),
		letter_countdown(N1).

number_countdown(0):- !.
number_countdown(N):- 
	N > 0,
	N1 is N-1,
	write(N), nl,
	sleep(1),
	number_countdown(N1).