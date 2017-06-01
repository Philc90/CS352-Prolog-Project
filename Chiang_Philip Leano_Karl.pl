/*

Grammar structures we may be interested in
Statements:
Questions: Interrogative(Determiner)
Both: Determiner, Quantifier(Determiner), Verb, Noun/Pronoun, Preposition

Q's:
The color of the car is blue. =?= The color of a car is blue. =?= The color of this car is blue. =?= The color of my car is blue.
How to link DCG with facts

*/

%% TODO: Just for testing the parse tree. remove before final submission
%% execute(List, Ans) :- s(ParseTree, List, []), Ans = ParseTree.

%% execute: the first execution rule. Generate a parse tree through 's' which is
%% the grammar, then go to executeIntermediate
execute(List, Ans) :- s(ParseTree, List, []), executeIntermediate(ParseTree, Ans).

%% executeIntermediate: try to figure out the structure of the parse tree.
%% cases:
%% parse tree is a stmt with no adjective
%% parse tree is a stmt with adjective
%% parse tree is a query
%% parse tree is unidentified; i.e. user entered something weird
executeIntermediate(ParseTree, Ans) :-
    ParseTree = s(stmt(p(_, n(Property)), prep_p(_, p(_, n(Object))), vp(_, p(n(PropertyValue))))),
    executeHelper(Object, Property, PropertyValue, Ans), !.

executeIntermediate(ParseTree, Ans) :-
    ParseTree = s(question(_, p(_, n(Property)), prep_p(_, p(_, n(Object))))),
    executeQuery(Object, Property, Ans), !.

%% User entered something weird
executeIntermediate(ParseTree, Ans) :- Ans = ["I don't know."], !.

%% Fact is already in the database.
executeHelper(Object, Property, PropertyValue, Ans) :-
    fact(Object, Property, PropertyValue),
    Ans = [i, know], !.

%% Conflicting fact is in the database.
executeHelper(Object, Property, PropertyValue, Ans) :-
    fact(Object, Property, ExistingPropertyValue),
    ExistingPropertyValue \= PropertyValue,
    append([no, it, is], ExistingPropertyValue, Ans), !.

%% Object is in the database, but user wants to define new property & property value.
executeHelper(Object, Property, PropertyValue, Ans) :-
    fact(Object, ExistingProperty, _),
    Property \= ExistingProperty,
    assert(fact(Object, Property, PropertyValue)),
    Ans = [ok], !.

%% Fact isn't in database
executeHelper(Object, Property, PropertyValue, Ans) :-
    not(fact(Object, _, _)),
    assert(fact(Object, Property, PropertyValue)),
    Ans = [ok], !.

%% Query of database
executeQuery(Object, Property, Ans) :-
    fact(Object, Property, PropertyValue),
    append([it, is], PropertyValue, Ans), !.

s(s(STATEMENT)) --> stmt(STATEMENT).

s(s(QUESTION)) --> question(QUESTION).

stmt(stmt(P, PREP_P, VP)) --> p(property, P), prep_p(PREP_P), vp(VP).

question(question(INTER_P, P, PREP_P)) --> inter_p(INTER_P), p(property, P), prep_p(PREP_P).

%% Thing is the type of each noun in the phrase: object, property, or property_value
p(Thing, p(DET,N)) --> det(DET), n(Thing, N).
p(Thing, p(N)) --> n(Thing, N).

%% Interrogative phrase: e.g. "what is"
inter_p(inter_p(INTER_DET, V)) --> inter_det(INTER_DET), v(V).

%% Interrogative Determiner
inter_det(inter_det(what)) --> [what].

%% Preposition phrase e.g. "of the car"
prep_p(prep_p(PREP, P)) --> prep(PREP), p(object,P).

vp(vp(V, P)) --> v(V), p(property_value, P).

det(det(the)) --> [the].
det(det(a)) --> [a].

n(object, n(Obj)) --> [Obj].

n(property, n(Prop)) --> [Prop].

n(property_value, n(PropVal), PropValList, _) :- PropVal = PropValList.

v(v(is)) --> [is].
%% Preposition
prep(prep(of)) --> [of].

%% Database is stored as a series of terms:
%% fact(object, property, property_value)
fact(car, color, [blue]).
fact(boat, color, [dark, blue]).
