info:-
	format('Chess: TODO<Add information>~n~n',[]).
	
:- info.

%start game
game:-
	true.
	
%%%% generate Board
%first letter: color -> w = white, b = black
%second letter: figure ->
%	p = pawn,
%	%r = rook,
%	%s = jumper (necessary name change due to collision with king & knight
%	b = bishop,
%	q = queen,
%	k = king
load_board(Board):-
	Board = 
	[
		(1,[wr,wj,wb,wq,wk,wb,wj,wr]),
		(2,[wp,wp,wp,wp,wp,wp,wp,wp]),
		(3,[_ ,_ ,_ ,_ ,_ ,_ ,_ ,_ ]),
		(4,[_ ,_ ,_ ,_ ,_ ,_ ,_ ,_ ]),
		(5,[_ ,_ ,_ ,_ ,_ ,_ ,_ ,_ ]),
		(6,[_ ,_ ,_ ,_ ,_ ,_ ,_ ,_ ]),
		(7,[bp,bp,bp,bp,bp,bp,bp,bp]),
		(8,[br,bj,bb,bq,bk,bb,bj,br])
	].
		