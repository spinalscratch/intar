%D'Occhio	Mario	900002

%rappresentazione degli infiniti
pos_infinity(pos_infinity).
neg_infinity(neg_infinity).

%intervallo vuoto
empty_interval([]).

%addizione su reali estesi
plus_e(0).
plus_e(X, Result) :- (number(X);
					 X = pos_infinity;
					 X = neg_infinity),
					 Result = X.
plus_e(X, Y, Result) :- (number(X), number(Y)) 
							-> Result is X + Y;
						(X = pos_infinity, number(Y)) 
							-> Result = pos_infinity;
						(X = neg_infinity, number(Y))
							-> Result = neg_infinity;
						(number(X), Y = pos_infinity)
							-> Result = pos_infinity;
						(number(X), Y = neg_infinity)
							-> Result = neg_infinity;
						(X = pos_infinity, Y = pos_infinity)
							-> Result = pos_infinity;
						(X = neg_infinity, Y = neg_infinity)
							-> Result = neg_infinity;
						fail.

%differenza su reali estesi
minus_e(X, Result) :-  number(X) -> Result is -X;
					   X = pos_infinity -> Result = neg_infinity;
					   X = neg_infinity -> Result = pos_infinity.
minus_e(X, Y, Result) :- (number(X), number(Y))
							-> Result is X - Y;
						 (X = pos_infinity, number(Y))
							-> Result = pos_infinity;
						 (X = neg_infinity, number(Y))
							-> Result = neg_infinity;
						 (number(X), Y = pos_infinity)
							-> Result = neg_infinity;
						 (number(X), Y = neg_infinity)
							-> Result = pos_infinity;
						 (X = pos_infinity, Y = neg_infinity)
							-> Result = pos_infinity;
						 (X = neg_infinity, Y = pos_infinity)
							-> Result = neg_infinity.

%prodotto su reali estesi
times_e(1).
times_e(X, Result) :-
	(number(X); X = pos_infinity; X = neg_infinity), 
		Result = X.
times_e(X, Y, Result) :-
	(number(X), number(Y))
		-> Result is X * Y;
	(X = pos_infinity, Y = pos_infinity)
		-> Result = pos_infinity;
	(X = neg_infinity, Y = neg_infinity)
		-> Result = pos_infinity;
	(X = pos_infinity, Y = neg_infinity)
		-> Result = neg_infinity;
	(X = neg_infinity, Y = pos_infinity)
		-> Result = neg_infinity;
	(X = pos_infinity, number(Y), Y < 0)
		-> Result = neg_infinity;
	(X = pos_infinity, number(Y), Y > 0)
		-> Result = pos_infinity;
	(X = neg_infinity, number(Y), Y < 0)
		-> Result = pos_infinity;
	(X = neg_infinity, number(Y), Y > 0)
		-> Result = neg_infinity;
	(number(X), X < 0, Y = pos_infinity)
		-> Result = neg_infinity;
	(number(X), X > 0, Y = pos_infinity)
		-> Result = pos_infinity;
	(number(X), X < 0, Y = neg_infinity)
		-> Result = pos_infinity;
	(number(X), X > 0, Y = neg_infinity)
		-> Result = neg_infinity.

%divisione su reali estesi
div_e(X, Result) :-
	(number(X); X = pos_infinity; X = neg_infinity),
	(X \= 0),
	(X = neg_infinity -> Result = 0;
	 X = pos_infinity -> Result = 0;
	 Result is 1 / X).
div_e(X, Y, Result) :-
	(number(X), number(Y), Y \= 0)
		-> Result is X / Y;
	(X = 0, Y = neg_infinity)
		-> Result = 0;
	(X = 0, Y = pos_infinity)
		-> Result = 0;
	(X = neg_infinity, number(Y), Y \= 0)
		-> (Y > 0 -> Result = neg_infinity;
			Y < 0 -> Result = pos_infinity);
	(X = pos_infinity, number(Y), Y \= 0)
		-> (Y > 0 -> Result = pos_infinity;
			Y < 0 -> Result = neg_infinity);
	(number(X), X \= 0, Y = neg_infinity)
		-> Result = 0;
	(number(X), X \= 0, Y = pos_infinity)
		-> Result = 0.
		
%prima di passare agli intervalli, i seguenti predicati
%di supporto estendono gli operatori di confronto agli infiniti.
gte(X, Y) :-
	(number(X), number(Y), X > Y);
	(number(X), neg_infinity(Y));
	(pos_infinity(X), number(Y));
	(pos_infinity(X), neg_infinity(Y)).

lte(X, Y) :-
	(number(X), number(Y), X < Y);
	(neg_infinity(X), number(Y));
	(number(X), pos_infinity(Y));
	(neg_infinity(X), pos_infinity(Y)).

eq_gte(X, Y) :-
	(number(X), number(Y), X >= Y);
	(pos_infinity(X), number(Y));
	(pos_infinity(X), neg_infinity(Y));
	(pos_infinity(X), pos_infinity(Y));	
	(number(X), neg_infinity(Y));
	(neg_infinity(X), neg_infinity(Y)).
	
eq_lte(X, Y) :-
	(number(X), number(Y), X =< Y);
	(neg_infinity(X), number(Y));
	(neg_infinity(X), neg_infinity(Y));
	(neg_infinity(X), pos_infinity(Y));		
	(pos_infinity(X), pos_infinity(Y));
	(number(X), pos_infinity(Y)).
	
numbere(X) :-
	number(X);
	pos_infinity(X);
	neg_infinity(X).

%predicati per la definizione degli intervalli.
interval([]).

interval(X, SI) :-
	nonvar(X),
	numbere(X),
	SI = [X, X], !.
	
interval(L, H, I) :-
	nonvar(L), nonvar(H), 
	numbere(L), numbere(H), 
	eq_lte(L, H), I = [L, H], !.

interval(L, H, []) :-
	nonvar(L), nonvar(H),
	numbere(L), numbere(H), 
	gte(L, H), !.
	
%predicato vero se l'argomento è un intervallo.
is_interval([]).

is_interval(I) :-
	I = [L, H],
	nonvar(L),
	nonvar(H),
	numbere(L),
	numbere(H),
	eq_lte(L, H).
	
%predicato che ritorna true se l'argomento rappresenta l'intero 
%intervallo R.
whole_interval(R) :-
	R = [neg_infinity, pos_infinity].

%predicato che verificano i limiti inferiore e superiore
%di un intervallo.
iinf(I, L) :-
	is_interval(I),
	\+ empty_interval(I),
	I = [L, _].

isup(I, H) :-
	is_interval(I),
	\+ empty_interval(I),
	I = [_, H].

%predicato che ritorna true se l'argomento è un intervallo
%singleton.
is_singleton(S) :-
	S = [];
	(is_interval(S),
	iinf(S, L),
	isup(S, H),
	L = H).

%predicato che ritorna true se I contiene X, che può essere
%un numero o un altro intervallo.
icontains(I, X) :-
	(numbere(X), iinf(I, L), isup(I, H), eq_lte(L, X), eq_gte(H, X));
	(is_interval(X), iinf(I, LI), isup(I, HI),
					 iinf(X, LX), isup(X, HX),
					 eq_lte(LI, LX), eq_gte(HI, HX)).

%predicato che verifica se due intervalli sono overlapped,
%ci sono due possibilità per l'overlap.
%ho escluso gli intervalli vuoti.
ioverlap(I1, I2) :-
	is_interval(I1),
	is_interval(I2),
	\+ empty_interval(I1),
	\+ empty_interval(I2),
	iinf(I1, L1), isup(I1, H1),
	iinf(I2, L2), isup(I2, H2),
	(eq_lte(L1, H2), eq_gte(H1, L2);
	 eq_lte(L2, H1), eq_gte(H2, L1)).

%predicati che verificano la somma di intervalli.
iplus(ZI) :-
	is_interval(ZI),
	\+ empty_interval(ZI).

iplus(X, R) :-
	(is_interval(X), \+ empty_interval(X), R = X);
	(nonvar(X), numbere(X), interval(X, R)).	 

iplus(X, Y, R) :-
	(is_interval(X), \+ empty_interval(X);
     nonvar(X), numbere(X)),
	(is_interval(Y), \+ empty_interval(Y);
	 nonvar(Y), numbere(Y)),
	iplus(X, XI), iplus(Y, YI),
	iinf(XI, LX), isup(XI, HX),
	iinf(YI, LY), isup(YI, HY),
	plus_e(LX, LY, LR), plus_e(HX, HY, HR),
	interval(LR, HR, R).

%predicati che verificano la differenza di intervalli.
iminus(X, R) :-
	(is_interval(X), \+ empty_interval(X),
	 iinf(X, LX), isup(X, HX),
	 minus_e(LX, LR), minus_e(HX, HR),
	 interval(HR, LR, R));
	(nonvar(X), numbere(X), iminus([X, X], R)).

iminus(X, Y, R) :-
	(is_interval(X), \+ empty_interval(X),
	 is_interval(Y), \+ empty_interval(Y),
	 iinf(X, LX), isup(X, HX),
	 iinf(Y, LY), isup(Y, HY),
	 minus_e(LX, HY, LR), minus_e(HX, LY, HR),
	 interval(LR, HR, R));
	(nonvar(X), numbere(X), iminus([X, X], Y, R));
	(nonvar(Y), numbere(Y), iminus(X, [Y, Y], R)).

%prima di passare alla moltiplicazione, i prossimi predicati
%vogliono estendere la ricerca di massimo e minimo di una lista
%agli infiniti.
%minimo:
listmine([H | T], Min) :-
	listmine(T, H, Min).

listmine([H | T], TempMin, Min) :-
	(H == neg_infinity) -> Min = neg_infinity;
	(TempMin == neg_infinity) -> listmine(T, H, Min);
	(lte(H, TempMin)) -> listmine(T, H, Min);
	listmine(T, TempMin, Min).

listmine([], Min, Min).

%massimo:
listmaxe([H | T], Max) :-
	listmaxe(T, H, Max).

listmaxe([H | T], TempMax, Max) :-
	(H == pos_infinity) -> Max = pos_infinity;
	(TempMax == pos_infinity) -> listmaxe(T, H, Max);
	(gte(H, TempMax)) -> listmaxe(T, H, Max);
	listmaxe(T, TempMax, Max).

listmaxe([], Max, Max).

%quindi abbiamo il prodotto di intervalli.
%ho usato findall per gestire la lista di risultati.
itimes(ZI) :-
	is_interval(ZI),
	\+ empty_interval(ZI).

itimes(X, R) :-
	(is_interval(X), \+ empty_interval(X), R = X);
	(nonvar(X), numbere(X), interval(X, R)).

itimes(X, Y, R) :-
	(is_interval(X), \+ empty_interval(X);
	 nonvar(X), numbere(X)),
	(is_interval(Y), \+ empty_interval(X);
	 nonvar(Y), numbere(Y)),
	itimes(X, XI), itimes(Y, YI),
	iinf(XI, LX), isup(XI, HX),
	iinf(YI, LY), isup(YI, HY),
	findall(P, ((times_e(LX, LY, P));
				(times_e(LX, HY, P));
				(times_e(HX, LY, P));
				(times_e(HX, HY, P))), Products),
	listmine(Products, Min), listmaxe(Products, Max),
	interval(Min, Max, R).
	
%predicati di supporto prima di scrivere la divisione
%tra intervalli.
%verifica se un intervallo è P0, P1, M, N0, N1:
is_p0(I) :-
	iinf(I, L), isup(I, H),
	L = 0, gte(H, 0).

is_p1(I) :-
	iinf(I, L), isup(I, H),
	gte(L, 0), gte(H, 0).

is_m(I) :-
	iinf(I, L), isup(I, H),
	lte(L, 0), gte(H, 0).

is_n0(I) :-
	iinf(I, L), isup(I, H),
	lte(L, 0), H = 0.

is_n1(I) :-
	iinf(I, L), isup(I, H),
	lte(L, 0), lte(H, 0).

%vediamo quindi la divisione tra intervalli.
idiv(X, R) :-
	(is_interval(X), \+ empty_interval(X),
	 iinf(X, LX), isup(X, HX),
	 div_e(LX, LR), div_e(HX, HR),
	 interval(HR, LR, R));
	(nonvar(X), numbere(X), idiv([X, X], R)).
	
idiv(X, Y, R) :-
	(is_interval(X), \+ empty_interval(X),
	 is_interval(Y), \+ empty_interval(Y),
	 idiv_helper(X, Y, R));
	(nonvar(X), numbere(X), idiv(X, XI), idiv(XI, Y, R), !);
	(nonvar(Y), numbere(Y), idiv(Y, YI), idiv(X, YI, R), !).

%predicato che contiene i vari casi:
idiv_helper(In, Id, R) :-
	iinf(In, A), isup(In, B),
	iinf(Id, C), isup(Id, D),
	(is_p0(In), is_p0(Id) ->
		interval(0, pos_infinity, R);
	 is_p0(In), is_p1(Id) ->
		div_e(B, C, H), interval(0, H, R);
	 is_p0(In), is_m(Id) ->
		whole_interval(R);
	 is_p0(In), is_n0(Id) ->
		interval(neg_infinity, 0, R);
	 is_p0(In), is_n1(Id) ->
		div_e(B, D, L), interval(L, 0, R);	
	
	 is_p1(In), is_p0(Id) -> 
		div_e(A, D, L), interval(L, pos_infinity, R);
	 is_p1(In), is_p1(Id) ->
		div_e(A, D, L), div_e(B, C, H), interval(L, H, R);
	 is_p1(In), is_m(Id) -> 
		div_e(A, C, H), div_e(A, D, L),
		interval(neg_infinity, H, R1), interval(L, pos_infinity, R2),
		R = [R1, R2];
	 is_p1(In), is_n0(Id) ->
		div_e(A, C, H), interval(neg_infinity, H, R);
     is_p1(In), is_n1(Id) ->
		div_e(B, D, L), div_e(A, C, H), interval(L, H, R);
	
	 is_m(In), is_p0(Id) ->
		whole_interval(R);
	 is_m(In), is_p1(Id) ->
		div_e(A, C, L), div_e(B, C, H), interval(L, H, R);
	 is_m(In), is_m(Id) ->
		whole_interval(R);
	 is_m(In), is_n0(Id) ->
		whole_interval(R);
	 is_m(In), is_n1(Id) ->
		div_e(B, D, L), div_e(A, D, H), interval(L, H, R);
	
	 is_n0(In), is_p0(Id) ->
		interval(neg_infinity, 0, R);
	 is_n0(In), is_p1(Id) ->
		div_e(A, C, L), interval(L, 0, R);
	 is_n0(In), is_m(Id) ->
		whole_interval(R);
	 is_n0(In), is_n0(Id) ->
		interval(0, pos_infinity, R);
	 is_n0(In), is_n1(Id) ->
		div_e(A, D, H), interval(0, H, R);
	
	 is_n1(In), is_p0(Id) ->
		div_e(B, D, H), interval(neg_infinity, H, R);
	 is_n1(In), is_p1(Id) ->
		div_e(A, C, L), div_e(B, D, H), interval(L, H, R);
	 is_n1(In), is_m(Id) -> 
		div_e(B, D, H), div_e(B, C, L),
		interval(neg_infinity, H, R1), interval(L, pos_infinity, R2),
		R = [R1, R2];
	 is_n1(In), is_n0(Id) ->
		div_e(B, C, L), interval(L, pos_infinity, R);
	 is_n1(In), is_n1(Id) ->
		div_e(B, C, L), div_e(A, D, H), interval(L, H, R)).




