%    prodoku.pro A Sudoku solver in Prolog (SWI-Prolog version)
%    Copyright (C) 2011 Sakis Kasampalis <faif at dtek period gr> 

%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY% without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


% CLP is required for using all_different since
% native backtracking causes an infinite loop...
:- use_module(library(clpfd)).

% representation of the example puzzle
% one list per row
puzzle([5, 3, _, _, 7, _, _, _, _],
       [6, _, _, 1, 9, 5, _, _, _],
       [_, 9, 8, _, _, _, _, 6, _],
       [8, _, _, _, 6, _, _, _, 3],
       [4, _, _, 8, _, 3, _, _, 1],
       [7, _, _, _, 2, _, _, _, 6],
       [_, 6, _, _, _, _, 2, 8, _],
       [_, _, _, 4, 1, 9, _, _, 5],
       [_, _, _, _, 8, _, _, 7, 9]).

% some more puzzles for testing
puzzle2([_,6,_,1,_,4,_,5,_],
	[_,_,8,3,_,5,6,_,_],
	[2,_,_,_,_,_,_,_,1],
	[8,_,_,4,_,7,_,_,6],
	[_,_,6,_,_,_,3,_,_],
	[7,_,_,9,_,1,_,_,4],
	[5,_,_,_,_,_,_,_,2],
	[_,_,7,2,_,6,9,_,_],
	[_,4,_,5,_,8,_,7,_]).

puzzle3([_,4,3,_,8,_,2,5,_],
	[6,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,1,_,9,4],
	[9,_,_,_,_,4,_,7,_],
	[_,_,_,6,_,8,_,_,_],
	[_,1,_,2,_,_,_,_,3],
	[8,2,_,5,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,5],
	[_,3,4,_,9,_,7,1,_]).

% solve(List)
% the starting point of the program
% prints the result in a nice way and
% saves it in List as a single (flat) list
solve(FS) :-
	% save the rows into variables
	puzzle(R1, R2, R3, R4, R5, R6, R7, R8, R9),
	% solve for each row
	allunique(R1), allunique(R2), allunique(R3),
	allunique(R4), allunique(R5), allunique(R6),
	allunique(R7), allunique(R8), allunique(R9),
	% create the columns first
	% column 1
	nth1(1, R1, C11), nth1(1, R2, C12), nth1(1, R3, C13),
	nth1(1, R4, C14), nth1(1, R5, C15), nth1(1, R6, C16),
        nth1(1, R7, C17), nth1(1, R8, C18), nth1(1, R9, C19),
	C1 = [C11, C12, C13, C14, C15, C16, C17, C18, C19],
	% column 2
	nth1(2, R1, C21), nth1(2, R2, C22), nth1(2, R3, C23),
	nth1(2, R4, C24), nth1(2, R5, C25), nth1(2, R6, C26),
        nth1(2, R7, C27), nth1(2, R8, C28), nth1(2, R9, C29),
	C2 = [C21, C22, C23, C24, C25, C26, C27, C28, C29],
	% column 3
	nth1(3, R1, C31), nth1(3, R2, C32), nth1(3, R3, C33),
	nth1(3, R4, C34), nth1(3, R5, C35), nth1(3, R6, C36),
        nth1(3, R7, C37), nth1(3, R8, C38), nth1(3, R9, C39),
	C3 = [C31, C32, C33, C34, C35, C36, C37, C38, C39],
	% column 4
	nth1(4, R1, C41), nth1(4, R2, C42), nth1(4, R3, C43),
	nth1(4, R4, C44), nth1(4, R5, C45), nth1(4, R6, C46),
        nth1(4, R7, C47), nth1(4, R8, C48), nth1(4, R9, C49),
	C4 = [C41, C42, C43, C44, C45, C46, C47, C48, C49],
	% column 5
	nth1(5, R1, C51), nth1(5, R2, C52), nth1(5, R3, C53),
	nth1(5, R4, C54), nth1(5, R5, C55), nth1(5, R6, C56),
        nth1(5, R7, C57), nth1(5, R8, C58), nth1(5, R9, C59),
	C5 = [C51, C52, C53, C54, C55, C56, C57, C58, C59],
	% column 6
	nth1(6, R1, C61), nth1(6, R2, C62), nth1(6, R3, C63),
	nth1(6, R4, C64), nth1(6, R5, C65), nth1(6, R6, C66),
        nth1(6, R7, C67), nth1(6, R8, C68), nth1(6, R9, C69),
	C6 = [C61, C62, C63, C64, C65, C66, C67, C68, C69],
	% column 7
	nth1(7, R1, C71), nth1(7, R2, C72), nth1(7, R3, C73),
	nth1(7, R4, C74), nth1(7, R5, C75), nth1(7, R6, C76),
        nth1(7, R7, C77), nth1(7, R8, C78), nth1(7, R9, C79),
	C7 = [C71, C72, C73, C74, C75, C76, C77, C78, C79],
	% column 8
	nth1(8, R1, C81), nth1(8, R2, C82), nth1(8, R3, C83),
	nth1(8, R4, C84), nth1(8, R5, C85), nth1(8, R6, C86),
        nth1(8, R7, C87), nth1(8, R8, C88), nth1(8, R9, C89),
	C8 = [C81, C82, C83, C84, C85, C86, C87, C88, C89],
	% column 9
	nth1(9, R1, C91), nth1(9, R2, C92), nth1(9, R3, C93),
	nth1(9, R4, C94), nth1(9, R5, C95), nth1(9, R6, C96),
        nth1(9, R7, C97), nth1(9, R8, C98), nth1(9, R9, C99),
	C9 = [C91, C92, C93, C94, C95, C96, C97, C98, C99],
	% and solve for each column
	allunique(C1), allunique(C2), allunique(C3),
	allunique(C4), allunique(C5), allunique(C6),
	allunique(C7), allunique(C8), allunique(C9),
	% the final step are the small grids
	% grid 1
	G1 = [C11, C21, C31, C12, C22, C32, C13, C23, C33],
	% grid 2
	G2 = [C41, C51, C61, C42, C52, C62, C43, C53, C63],
	% grid 3
	G3 = [C71, C81, C91, C72, C82, C92, C73, C83, C93],
	% grid 4
	G4 = [C14, C24, C34, C15, C25, C35, C16, C26, C36],
	% grid 5
	G5 = [C44, C54, C64, C45, C55, C65, C46, C56, C66],
	% grid 6
	G6 = [C74, C84, C94, C75, C85, C95, C76, C86, C96],
	% grid 7
	G7 = [C17, C27, C37, C18, C28, C38, C19, C29, C39],
	% grid 8
	G8 = [C47, C57, C67, C48, C58, C68, C49, C59, C69],
	% grid 9
	G9 = [C77, C87, C97, C78, C88, C98, C79, C89, C99],
	% solve for each small grid
	allunique(G1), allunique(G2), allunique(G3),
	allunique(G4), allunique(G5), allunique(G6),
	allunique(G7), allunique(G8), allunique(G9),
	% create and print the final solution
	S = [R1, R2, R3, R4, R5, R6, R7, R8, R9],
	% flatten the list to print it recursively
	flatten(S, FS),
	% try out all values until a solution is found
	label(FS),
	% print the final solution
	printpuzzle(FS).

% allunique(List)
% Succeeds if all the numbers of List are between 1-9
% and each number exists only once
allunique(L) :-
	length(L, 9),		% make sure that the length is the expected
	L ins 1..9,		% put numbers (to the empty items) from 1-9
	all_different(L).	% make sure that all numbers are different

% print(List)
% Prints the List by 9 elements per row
printpuzzle([]).

printpuzzle([H1, H2, H3, H4, H5, H6, H7, H8, H9|T]) :-
	format('~d ~d ~d | ~d ~d ~d | ~d ~d ~d \n', [H1, H2, H3, H4, H5, H6, H7, H8, H9]),
	printpuzzle(T).
