
/* Retract all rules by Pred/Arity form. */
retract_pred([]).
retract_pred([H|T]) :-
        retract_pred(H),
        retract_pred(T).
retract_pred(Pred/Arity) :-
        functor(Term, Pred, Arity),
        retractall(Term).

/* Assert multiple facts. */
assert_multiple([]).
assert_multiple([T|H]) :-
        assert(T),
        assert_multiple(H).

/* Swap bytes. */
swap_bytes(big, bytes(A, B), bytes(A, B)).
swap_bytes(big, bytes(A, B, C, D), bytes(A, B, C, D)).
swap_bytes(little, bytes(A, B), bytes(B, A)).
swap_bytes(little, bytes(A, B, C, D), bytes(D, C, B, A)).
