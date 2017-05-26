s(s(NP, VP)) --> np(subject,NP),vp(VP).
np(_,np(Det,N)) --> det(Det), n(N).
np(X, np(Pro)) --> pro(X, Pro).
vp(vp(V,NP)) --> v(V), np(object, NP).
vp(vp(V)) --> v(V).
det(det(the)) --> [the].
det(det(a)) --> [a].
n(n(woman)) --> [woman].
n(n(man)) --> [man].
v(v(shoots)) --> [shoots].
pro(subject,pro(he)) --> [he].
pro(subject,pro(she)) --> [she].
pro(object,pro(him)) --> [him].
pro(object,pro(her)) --> [her].
