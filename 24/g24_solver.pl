:- use_module(library(clpfd)).
:- consult('g24.pl').

solve:-
    generate_digits(L),
    format('I am trying to find a valid combination to get 24 using ~w~n',[L]),
    solve(L).
    
solve(L):-
    permutation(L, Perm),
    get_to_24(Perm, Ops),
    display_solution(Perm, Ops).
    
get_to_24([D],[]):- D =:= 24,!.
get_to_24([D1,D2|Ds],['+'|Ops]):-
    Partial is D1 + D2,
    get_to_24([Partial|Ds],Ops).
get_to_24([D1,D2|Ds],['-'|Ops]):-
    Partial is D1 - D2,
    get_to_24([Partial|Ds],Ops).
get_to_24([D1,D2|Ds],['*'|Ops]):-
    Partial is D1 * D2,
    get_to_24([Partial|Ds],Ops).
get_to_24([D1,D2|Ds],['/'|Ops]):-
    Partial is D1 / D2,
    get_to_24([Partial|Ds],Ops).
    
display_solution(Perm, Ops):-
    reverse(Perm, RevPerm),
    reverse(Ops, RevOps),
    display_solution(RevPerm, RevOps, RevString),
    reverse_string(RevString, String),
    writeln(String).
    
% example
% (((1+2)+3)+4)    

%We use a reverse notation to get our solution
%however this means that we need to mirror the parenthesis
display_solution([D1,D2],[Op],String):- atomics_to_string([ ')', D1, Op, D2, '(' ], String), !.
display_solution([D|Ds],[Op|Ops], String):- 
    display_solution(Ds,Ops, SubString),
    format(string(String), ')~d~a~s(',[D, Op, SubString]).
    
% quick and dirty string reversal
reverse_string(String, ReverseStr):-
    string_chars(String, Chars),
    reverse(Chars, RevChars),
    string_chars(ReverseStr, RevChars).