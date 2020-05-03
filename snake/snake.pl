width(42).
height(22).

% creates an initial state without the player
create_map(Map):-
    width(W), height(H),
    length(Map,H), 
    maplist({W}/[Col] >> (length(Col, W)), Map),
    make_border(Map),!.
    
make_border(Map):-
    Map = [FirstRow|Rest],
    maplist(=('#'),FirstRow),
    append(Middle, [LastRow], Rest),
    maplist(=('#'),LastRow),
    maplist( [Row] >> ( Row = ['#'| Cols], 
                        append(MiddleCols, ['#'], Cols),
                        maplist(=(' '), MiddleCols)
                        ), 
            Middle).
            
spawn_player(Initial, Spawn):-
    Initial = Spawn. % TODO: replace middle ' ' with 'x'
            
display_map([]).
display_map([Row|Rest]):-
    maplist([Col] >> (write(Col)), Row), nl,
    display_map(Rest).
    