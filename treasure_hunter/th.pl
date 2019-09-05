game(1,L,3,4):-
	L = [
		1,1,1,3,
		2,2,3,4,
		3,3,1,1
		].

start(Game):-
	game(Game,State,Height,Width),
	display_map(State,Height,Width),
	solve(State,Height,Width).

solve(State,_,_):-
	all_cleared(State),!.
	
solve(State,Height,Width):-
	Size is Height * Width,
	length(WorkState,Size),
	get_coordinates(State,Height, Width,X,Y),
	has_valid_position(State,Width,Height,X,Y),
	remove_fields(State,Height, Width, X,Y,WorkState),
	update_neighbours(State,Size,Width,1,WorkState),
	finish_update(WorkState,NextState),
	display_map(NextState,Height,Width),
	solve(NextState,Height,Width).
	
all_cleared([]).
all_cleared([o|T]):- all_cleared(T).	
	
finish_update([],[]).
finish_update([x|T],[o|T2]):- finish_update(T,T2).
finish_update([H|T],[H|T2]):- H \= x, finish_update(T,T2).	

display_map(Map,Height,Width):-
	display_map(Map,Width,Height,Width).

display_map([],_,_,0):- nl,nl,!.	
display_map(Map,Width,H,0):-
	nl,
	NextH is H-1,
	display_map(Map,Width,NextH,Width),!.
display_map([Field|T],Width,H,W):-
	write(Field),write(','),
	NextW is W-1,
	display_map(T,Width,H,NextW).

update_neighbours(_, Size,_, Position, _):- Position > Size, !.
update_neighbours(State, Size,Width,Position,NextState):-
	nth1(Position,NextState, Spot, _),
	var(Spot),
	nth1(Position,State, Value, _),
	((neighbour_got_removed(Size,Width,Position,NextState), Value \= o) ->
	
		NextVal is Value + 1,
		update_val(NextVal,Spot),!;
		Spot = Value
	),
	NextPos is Position + 1,
	update_neighbours(State, Size, Width, NextPos, NextState), !.
	
update_neighbours(State, Size,Width,Position,NextState):-
	nth1(Position,NextState, Spot, _),
	nonvar(Spot),
	NextPos is Position + 1,
	update_neighbours(State, Size,Width, NextPos, NextState).
	
update_val(Val,Spot):-
		Val < 5,
		Spot = Val.
update_val(5,Spot):-
	Spot = 1.
	
neighbour_got_removed(Size,Width,Position,NextState):- 
	EPos is Position+1,
	WPos is Position-1,
	NPos is Position-Width,
	SPos is Position+Width,
	(
	not(1 is EPos mod Width), neighbour_got_removed(Size,EPos,NextState),!;
	not(0 is WPos mod Width), neighbour_got_removed(Size,WPos,NextState),!;
	neighbour_got_removed(Size,NPos,NextState),!;
	neighbour_got_removed(Size,SPos,NextState)
	).
	
neighbour_got_removed(Size,Pos,NextState):-
	Pos =< Size,
	Pos > 0,
	nth1(Pos,NextState,Spot,_),
	nonvar(Spot),
	Spot = x.

is_not_prev(_,1,_).
is_not_prev(State,Position,Width):-
	Position > Width,
	WPos is Position - 1,
	NPos is Position - Width,
	nth1(Position,State,Val,_),
	not(nth1(WPos,State,Val,_)),
	not(nth1(NPos,State,Val,_)),!.
is_not_prev(State,Position,_):-
	Position > 1,
	WPos is Position - 1,
	nth1(Position,State,Val,_),
	not(nth1(WPos,State,Val,_)),!.

get_coordinates(State,Height, Width, X, Y):-
	between(1,Width,X),
	between(1,Height, Y),
	Position is ((Y-1) * Width) + X,
	is_not_prev(State,Position,Width),
	nth1(Position, State, Value, _),
	Value \= x,
	Value \= o,
	(
		X < Width, XEast is X + 1, NextPos is ((Y-1) * Width) + XEast, nth1(NextPos, State, Value,_);
		X > 1, XWest is X - 1, NextPos is ((Y-1) * Width) + XWest, nth1(NextPos, State, Value,_);
		Y > 1, YNorth is Y - 1, NextPos is ((YNorth-1) * Width) + X, nth1(NextPos, State, Value,_);
		Y < Height, YSouth is Y + 1, NextPos is ((YSouth-1) * Width) + X, nth1(NextPos, State, Value,_)
	).

remove_fields(State,Height, Width, X,Y,NextState):-
	Position is ((Y-1) * Width) + X,
	nth1(Position, State, Value, _),
	nth1(Position, NextState, x, _),
	remove_neighbours(State, Height, Width, Value,X,Y,NextState).

remove_neighbours(State, Height, Width, Value,X,Y,NextState):-
	XWest is X - 1,
	XEast is X + 1,
	YNorth is Y - 1,
	YSouth is Y + 1,
	remove_neighbour(State, Height, Width, Value,XWest,Y,NextState),
	remove_neighbour(State, Height, Width, Value,XEast,Y,NextState),
	remove_neighbour(State, Height, Width, Value,X,YNorth,NextState),
	remove_neighbour(State, Height, Width, Value,X,YSouth,NextState),!.

remove_neighbour(State, Height, Width, Value,X,Y,NextState):-
	X > 0, X =< Width,
	Y > 0, Y =< Height,
	Position is ((Y-1) * Width) + X,
	nth1(Position, State, Value, _),
	nth1(Position, NextState, FreeSpot, _),
	var(FreeSpot),
	FreeSpot = x,
	remove_neighbours(State, Height, Width, Value,X,Y,NextState).

remove_neighbour(_, _, _, _,_,_,_):- true.

has_valid_position(State,Width,Height,X,Y):-
	Position is ((Y-1) * Width) + X,
	nth1(Position, State, Value, _),
	(
		X>1, XEast is X - 1, NextPos is ((Y-1) * Width) + XEast, nth1(NextPos, State, Value,_),!;
		X < Width, XWest is X + 1, NextPos is ((Y-1) * Width) + XWest, nth1(NextPos, State, Value,_),!;
		Y > 1, YNorth is Y - 1, NextPos is ((YNorth-1) * Width) + X, nth1(NextPos, State, Value,_),!;
		Y < Height, YSouth is Y + 1, NextPos is ((YSouth-1) * Width) + X, nth1(NextPos, State, Value,_),!
	).
	
