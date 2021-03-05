fromIndex(X, [Y, Z]) :-
        divmod(X, 3, Y1, Z1),
        Y is Y1 + 1,
        Z is Z1 + 1.

toIndex([X, Y], Z) :-
        Z is (X-1)*3 + (Y-1).

index(Elem, [Elem|_], 0) :- !.
index(Elem, [_|Xs], In) :-
        index(Elem, Xs, In1),
        !,
        In is In1 + 1.

dManh([W, X], [Y, Z], Out) :-
        Out is abs(Y - W) + abs(Z - X).

sumOfDists([X|Xs], Sum) :-
        sumOfDists_([X|Xs], 0, Sum).

sumOfDists_([], _, 0).
sumOfDists_([X|Xs], Pos, Sum) :-
        X_ is X - 1,
        fromIndex(X_, P1),
        fromIndex(Pos, P2),
        dManh(P1, P2, D),
        Pos_ is Pos + 1,
        sumOfDists_(Xs, Pos_, Sum_),
        Sum__ is Sum_ + D,
        (D > 0 -> Sum is Sum__+1; Sum is Sum__+0).

suma([], 0).
suma([X | Xs], Y) :-
        include(>(X), Xs, Xss),
        length(Xss, L),
        suma(Xs, Yi),
        Y is L + Yi.

esResoluble(X) :-
        flatten(X, Y),
        index(9, Y, In),
        fromIndex(In, [Px, Py]),
        dManh([Px, Py], [3, 3], D),
        suma(Y, Z),
        Sum is Z + D,
        0 is mod(Sum, 2).

ordered([]).
ordered([_]).
ordered([X,Y|Z]) :-
        X =< Y,
        ordered([Y|Z]).

split_at(0, L, [], L) :- !.
split_at(N, [H|T], [H|L1], L2) :-
        M is N -1,
        split_at(M, T, L1, L2).

move(L, In1, In2, S) :- % In1 is 9 ALWAYS!!!11!1!!1!!111!
        split_at(In2, L, B2, [HA2|TA2]),
        append(B2, [9|TA2], L1),
        split_at(In1, L1, B1, [_|TA1]),
        append(B1, [HA2|TA1], S).

up(L, S) :-
        index(9, L, I9),
        fromIndex(I9, [F9, C9]),
        F9 > 1,
        Fn is F9 - 1,
        toIndex([Fn, C9], In),
        move(L, I9, In, S).

down(L, S) :-
        index(9, L, I9),
        fromIndex(I9, [F9, C9]),
        F9 < 3,
        Fn is F9 + 1,
        toIndex([Fn, C9], In),
        move(L, I9, In, S).

right(L, S) :-
        index(9, L, I9),
        fromIndex(I9, [F9, C9]),
        C9 < 3,
        Cn is C9 + 1,
        toIndex([F9, Cn], In),
        move(L, I9, In, S).

left(L, S) :-
        index(9, L, I9),
        fromIndex(I9, [F9, C9]),
        C9 > 1,
        Cn is C9 - 1,
        toIndex([F9, Cn], In),
        move(L, I9, In, S).

moves_(L, S) :- up(L, S).
moves_(L, S) :- down(L, S).
moves_(L, S) :- left(L, S).
moves_(L, S) :- right(L, S).

moves(L, S) :-
        findall(N, moves_(L, N), List),
        map_list_to_pairs(sumOfDists, List, R),
        keysort(R, X),
        pairs_values(X, S).

gensol([1, 2, 3, 4, 5, 6, 7, 8, 9], _, C, C).
gensol(L, Queue, C, N) :-
        not(member(L, Queue)),
        C >= 0,
        C < 32,
        moves(L, [SS|S]),
        C_ is C+1,
        (
                gensol(SS, [L|Queue], C_, N);
                nth0(0, S, S1), gensol(S1, [L|Queue], C_, N);
                nth0(1, S, S2), gensol(S2, [L|Queue], C_, N);
                nth0(2, S, S3), gensol(S3, [L|Queue], C_, N)
        ).

rompecabezas(X, N) :-
        esResoluble(X),
        flatten(X, Y),
	once(gensol(Y, [], 0, N_)),
	N is N_.
