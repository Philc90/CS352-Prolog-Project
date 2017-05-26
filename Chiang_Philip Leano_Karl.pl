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

s --> statement. %% | question.

statement --> p(property), prep_p, vp.
%% Thing is each type of phrase: object, property, or property_value
p(Thing) --> det, n(Thing) | n(Thing).

%% Preposition phrase e.g. "of the car"
prep_p --> prep, p(object).

vp --> v, p(property_value).

det --> [the] | [a].

n(object) --> [car].

n(property) --> [color].

n(property_value) --> [blue].

v --> [is].
%% Preposition
prep --> [of].

%% Interrogative Determiner
inter_det --> [what].

%% fact(object, property, property_value)
fact(car, color, blue).
