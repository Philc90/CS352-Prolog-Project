/*

Grammar structures we may be interested in
Statements:
Questions: Interrogative(Determiner)
Both: Determiner, Quantifier(Determiner), Verb, Noun/Pronoun, Preposition

*/

s --> statement. %% | question.

statement --> np, prep_p, vp.

np --> det, n | n.

vp --> v, np.
%% Preposition phrase e.g. "of the car"
prep_p --> prep, np.

%% Interrogative Determiner
inter_det --> [what].

det --> [the] | [a].

n --> [color] | [car] | [blue].

v --> [is].
%% Preposition
prep --> [of].
