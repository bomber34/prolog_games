:- consult('g24.pl').

:- begin_tests(generate_digits).
test(generate_digits):-
    generate_digits(L),
    maplist(integer, L),
    length(L,4).
:- end_tests(generate_digits).


:- begin_tests(eval_expression).
test(eval_expression):-
    eval_expression("1+2+3+4", Res),
    assertion(Res =:= 10).
    
test(eval_expression):-
    eval_expression("(1+2)*(3+4)", Res),
    assertion(Res =:= 21).
    
test(eval_expression):-
    eval_expression("1+2*3+4", Res),
    assertion(Res =:= 11).
    
:- end_tests(eval_expression).


:- begin_tests(check_string).
test(check_string):-
    \+ check_expression("12+21", [1,2,2,1]).

test(check_string):-
    \+ check_expression("1**2+2//1", [1,2,2,1]).
    
test(check_string):-
    check_expression("(1+2)*(2+1)", [1,2,2,1]).
    
test(check_string):-
    \+ check_expression("((1+3)*(4+1))", [1,2,3,4]).
    
test(check_string):-
    \+ check_expression("((1+3)*(4+2)+1)", [1,2,3,4]).
:- end_tests(check_string).

:- begin_tests(remove_whitespace).
test(remove_whitespace):-
    String = " 1 + 2 + 3 + 4 ",
    remove_whitespace(String, "1+2+3+4").
    
test(remove_whitespace):-
    String = "1+2+3+4",
    remove_whitespace(String, "1+2+3+4").
:- end_tests(remove_whitespace).

:- begin_tests(check_goal).
test(check_goal):-
    eval_expression("((6*4)/5)*5", Res),
    check_result(Res).
:- end_tests(check_goal).


%Run test suite
:- run_tests.


