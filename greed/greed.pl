game:-
    create_field(22, 79, Field, Cursor),
    print_field(Field),
    writeln(Cursor).

create_field(Height, Width, Field, cursor(X,Y)):-
    Size is Height * Width,
    length(Map, Size),
    random_member(@, Map),
    maplist([X] >> (once(random_between(1, 9, X) ; X == @)), Map),
    once(split_list(Map, Width, ColList)),
    length(FieldCols, Height),
    dismember_field(Field, FieldCols, ColList),
    once(nth0(Index, Map, @)),
    X is Index mod Width,
    Y is Index // Width.

split_list([], _, []).
split_list(Map, Width, [Row|T]):-
    length(Row, Width),
    append(Row, Rest, Map),
    split_list(Rest, Width, T).

dismember_field(Field, FieldCols, ColList):-
    Field =.. [field | FieldCols],
    maplist([ColObj, Col] >> (ColObj =.. [col|Col]), FieldCols, ColList).

print_field(Field):-
    dismember_field(Field, _, ColList),
    maplist(writeln, ColList), nl.
