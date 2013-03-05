
%% Convert a predicate to bool. 1 if has a solution.
to_bool(T, 1) :- T, !.
to_bool(_, 0).

%% pick (names, bits, res).
pick([], [], []).
pick([_|NmsX], [0|Bts], NmsY) :- pick(NmsX, Bts, NmsY).
pick([N|NmsX], [1|Bts], [N|NmsY]) :- pick(NmsX, Bts, NmsY).

%% delete (elem, list1, list2).
delete(X, [X|T], T).
delete(X, [H|T], [H|NT]) :- delete(X,T,NT).

%% permute (list1, list2).
permute([], []).
permute(List, [H|Perm]) :- delete(H, List, Rest), permute(Rest, Perm).

%% print_list(List).
print_list([]).
print_list([H|T]) :- write(H), nl, print_list(T).

%% sum lists
sum_list([], 0).
sum_list([T|H], S) :- sum_list(H, S1), S is T + S1.

%% Standard list predictes: append.
append([], Ys, Ys).
append([X|Xs], Ys, [X|Zs]) :- append(Xs, Ys, Zs).

%% Standard list predictes: member.
member(X, [X|_]).
member(X, [_|R]) :- member(X, R).

%% Standard list predictes: subtract.
subtract([], _, []) :- !.
subtract([E|T], D, R) :-
	memberchk(E, D), !,
	subtract(T, D, R).
subtract([H|T], D, [H|R]) :-
	subtract(T, D, R).

%% read_file(FileName, List).
read_file(Name, List) :-
        open(Name, read, Stream),
        read_bytes(Stream, List),
        close(Stream).

%% read_bytes(Stream, List).
read_bytes(Stream, List) :-
        get_byte(Stream, C),
        read_bytes(Stream, List, C).
read_bytes(_, [], -1) :- !.
read_bytes(Stream, [C|T], C) :- read_bytes(Stream, T).

%% intersection(+Set1, +Set2, -Set3).
intersection([], _, []) :- !.
intersection([X|T], L, Intersect) :-
	memberchk(X, L), !, 
	Intersect = [X|R], 
	intersection(T, L, R).
intersection([_|T], L, R) :-
	intersection(T, L, R).

%% no_intersection(Set1, Set2).
no_intersection(A, B) :-
        intersection(A, B, []).

intersects(A, B) :-
        intersection(A, B, [_|_]).

%% bit operations
bit(0).
bit(1).
bit(A, B) :- bit(A), bit(B).
bit(A, B, C) :- bit(A, B), bit(C).
bit(A, B, C, D) :- bit(A, B, C), bit(D).
bit_neg(0, 1).
bit_neg(1, 0).

%% Get bounds: Compute High bound from Low and Count Reversible.
int_bounds(Low, High, Count) :-
        nonvar(Count), plus(Low, Count, High1), succ(High, High1).
int_bounds(Low, High, Count) :-
        nonvar(High), succ(High, High1), plus(Low, Count, High1).


%% v_sum/3
v_sum([], [], []).
v_sum([V1|R1], [V2|R2], [S|RS]) :-
	S is V1 + V2,
	v_sum(R1, R2, RS).

%% x_sum/3, x_sum/2
x_sum(F1, F2, S) :-
        F1 =.. [N|F1_Args], F2 =.. [N|F2_Args],
        v_sum(F1_Args, F2_Args, S_Args),
        S =.. [N|S_Args].
x_sum([F|T], S) :- T \== [], !,
        x_sum(T, S1),
        x_sum(F, S1, S).
x_sum([A], A).

