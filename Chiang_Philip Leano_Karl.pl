/*

Grammar structures we may be interested in
Statements:
Questions: Interrogative(Determiner)
Both: Determiner, Quantifier(Determiner), Verb, Noun/Pronoun, Preposition

Q's:
The color of the car is blue. =?= The color of a car is blue. =?= The color of this car is blue. =?= The color of my car is blue.
How to link DCG with facts

*/

%% execute(S, E) :- s(S, M), write("I know.").

%%=============================================================================

%% Fact is in the database.
%% execute(S, E) :- S = [the, Prop, of, the, Obj, is, Prop_val], fact(Obj, Prop, Prop_val),
%%    write("I know."), !.

%% Conflicting fact is in the database.
%% execute(S, E) :- S = [the, Prop, of, the, Obj, is, Prop_val], fact(Obj, Prop, Actual_prop_val),
%%    format("That's not true. The ~w of the ~w is ~w.", [Prop, Obj, Actual_prop_val]), !.

%% Object is in the database, but user wants to define new property & property value.
%% execute(S, E) :- S = [the, Prop, of, the, Obj, is, Prop_val], fact(Obj, Existing_prop, _),
%%    Existing_prop \= Prop, assert(fact(Obj, Prop, Prop_val)), write("OK."), !.

%% Fact isn't in database
%% execute(S, E) :- S = [the, Prop, of, the, Obj, is, Prop_val],
%%    fact(Existing_obj, _, _), Existing_obj \= Obj,
%%    assert(fact(Obj, Prop, Prop_val)), write("OK."), !.

%% User entered something weird
%% execute(_,_) :- write("I don't know."), !.

%%=============================================================================

s(s(STATEMENT)) --> statement(STATEMENT).

%% s --> question.

statement(statement(P, PREP_P, VP)) --> p(property, P), prep_p(PREP_P), vp(VP).
%% Thing is each type of phrase: object, property, or property_value
p(Thing, p(DET,N)) --> det(DET), n(Thing, N).
p(Thing, p(N)) --> n(Thing, N).

%% Preposition phrase e.g. "of the car"
prep_p(prep_p(PREP, P)) --> prep(PREP), p(object,P).

vp(vp(V, P)) --> v(V), p(property_value, P).

det(det(the)) --> [the].
det(det(a)) --> [a].

n(object, n(car)) --> [car].

n(property, n(color)) --> [color].

n(property_value, n(blue)) --> [blue].

v(v(is)) --> [is].
%% Preposition
prep(prep(of)) --> [of].

%% Interrogative Determiner
%% inter_det --> [what].

%% fact(object, property, property_value)
fact(car, color, blue).
