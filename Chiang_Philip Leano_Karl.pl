/*

Grammar structures we may be interested in
Statements:
Questions: Interrogative(Determiner)
Both: Determiner, Quantifier(Determiner), Verb, Noun/Pronoun, Preposition

Q's:
The color of the car is blue. =?= The color of a car is blue. =?= The color of this car is blue. =?= The color of my car is blue.
How to link DCG with facts

*/

neg(Goal) :- Goal,!,fail.
neg(Goal).

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
    ParseTree = s(stmt(p(_, n(Property)), prep_p(_, p(_, n(Object))), vp(_, p(n(Adj, PropertyValue))))),
    executeHelper2(Object, Property, Adj, PropertyValue, Ans), !.

executeIntermediate(ParseTree, Ans) :-
    ParseTree = s(question(_, p(_, n(Property)), prep_p(_, p(_, n(Object))))),
    executeQuery(Object, Property, Ans), !.

%% User entered something weird
executeIntermediate(ParseTree, Ans) :- Ans = ["I don't know."], !.

%% Fact is already in the database.
executeHelper(Object, Property, PropertyValue, Ans) :-
    fact(Object, Property, PropertyValue),
    Ans = ["I know."], !.

%% Conflicting fact is in the database.
executeHelper(Object, Property, PropertyValue, Ans) :-
    fact(Object, Property, ExistingPropertyValue),
    ExistingPropertyValue \= PropertyValue,
    Ans = ["No, it's", ExistingPropertyValue], !.

%% Object is in the database, but user wants to define new property & property value.
executeHelper(Object, Property, PropertyValue, Ans) :-
    fact(Object, ExistingProperty, _),
    Property \= ExistingProperty,
    assert(fact(Object, Property, PropertyValue)),
    Ans = ["OK."], !.

%% Fact isn't in database
executeHelper(Object, Property, PropertyValue, Ans) :-
    not(fact(Object, _, _)),
    assert(fact(Object, Property, PropertyValue)),
    Ans = ["OK."], !.

%% Fact is already in the database.
executeHelper2(Object, Property, Adj, PropertyValue, Ans) :-
    fact(Object, Property, Adj, PropertyValue),
    Ans = ["I know."], !.

%% Conflicting fact is in the database.
executeHelper2(Object, Property, Adj, PropertyValue, Ans) :-
    fact(Object, Property, ExistingAdj, ExistingPropertyValue),
    ExistingAdj \= Adj, ExistingPropertyValue \= PropertyValue,
    Ans = ["No, it's", ExistingAdj, ExistingPropertyValue], !.

%% Object is in the database, but user wants to define new property & property value.
executeHelper2(Object, Property, Adj, PropertyValue, Ans) :-
    fact(Object, ExistingProperty, _),
    Property \= ExistingProperty,
    assert(fact(Object, Property, PropertyValue)),
    Ans = ["OK."], !.

%% Fact isn't in database
executeHelper2(Object, Property, Adj, PropertyValue, Ans) :-
    not(fact(Object, _, _, _)),
    assert(fact(Object, Property, Adj, PropertyValue)),
    Ans = ["OK."], !.

%% Query of database
executeQuery(Object, Property, Ans) :-
    fact(Object, Property, PropertyValue),
    Ans = ["It's ", PropertyValue], !.

executeQuery(Object, Property, Ans) :-
    fact(Object, Property, Adj, PropertyValue),
    Ans = ["It's ", Adj, PropertyValue], !.

s(s(STATEMENT)) --> stmt(STATEMENT).

s(s(QUESTION)) --> question(QUESTION).

stmt(stmt(P, PREP_P, VP)) --> p(property, P), prep_p(PREP_P), vp(VP).

question(question(INTER_P, P, PREP_P)) --> inter_p(INTER_P), p(property, P), prep_p(PREP_P).

%% Thing is the type of each noun in the phrase: object, property, or property_value
p(Thing, p(DET,N)) --> det(DET), n(Thing, N).
%%p(Thing, p(ADJ, DET, N)) --> det(DET), adj(ADJ), n(Thing, N).
p(Thing, p(N)) --> n(Thing, N).
%%p(Thing, p(ADJ, N)) --> adj(ADJ), n(Thing, N).

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

n(property_value, n(PropVal)) --> [PropVal].

n(property_value, n(Adj, PropVal)) --> [Adj, PropVal].

v(v(is)) --> [is].
%% Preposition
prep(prep(of)) --> [of].

%% Database is stored as a series of terms:
%% fact(object, property, property_value)
fact(car, color, blue).
fact(boat, color, dark, blue).
