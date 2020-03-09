
start:-
    generate_digits(L),
    play(L).
    
play(L):-
    repeat,
    format('calculate 24 by using these digits ~w~n', [L]),
    get_user_input(UserInput),
    (UserInput = end_of_file -> abort; true),
    (member(UserInput, ["quit", "q", "end", "I give up"]) -> abort; true),
    remove_whitespace(UserInput, NoWhiteSpace),
    (\+ check_expression(NoWhiteSpace, L) -> format('Your input can only contain the given digits which are not concatinated, parenthesis and the basic math operators +-*/~n'), fail; true),
    eval_expression(NoWhiteSpace, Res),
    (Res =:= inf -> format('Your expression could not be calculated~n'), fail; true),
    (\+ check_result(Res) -> format('Your expression did not evaluate to 24, it evaluated to ~a~n',[Res]), fail; true),
    format('congratulations, you did it!'),!.
    
generate_digits(L):-
    length(L,4),
    maplist([N] >> (random_between(1,9,N)), L).
    
get_user_input(X):-
    writeln("Type your expression:"),
    read_line_to_string(user, X),nl.
    
remove_whitespace(String, NoWhiteSpace):-
    string_chars(String, Chars),
    exclude([C]>> (char_type(C,space);char_type(C,white)), Chars, NoWhiteSpaceChars),
    string_chars(NoWhiteSpace, NoWhiteSpaceChars).
    
check_expression(String, DigitList):-
    string_chars(String, Chars),
    maplist(valid_symbol, Chars),
    \+ (nextto(A,B, Chars), is_digit(A), is_digit(B)),
    \+ (nextto(A,B, Chars), OPs = ['+','-','*','/'], member(A,OPs), member(B, OPs)),
    used_only_given_digits(Chars,DigitList).
    
used_only_given_digits([],[]):- !.
used_only_given_digits([C|T],List):-
    char_type(C, digit),
    atom_number(C,D),
    select(D,List, Rest),
    used_only_given_digits(T,Rest),!.
used_only_given_digits([_|T],List):-
    used_only_given_digits(T,List).
    
valid_symbol(Symbol):-
    member(Symbol, ['(', '+', '-', '*', '/', ')']),!;
    is_digit(Symbol).
    
eval_expression(String, Result):-
    catch(term_string(Term, String),_, Result = inf),
    (var(Result) -> Result is Term; true).
    
check_result(Res):-
    Res =:= 24.