:- dynamic symptom/1.

clear :- retractall(symptom(_)).

diagnose(Disease) :-
    (   flu -> Disease = flu
    ;   cold -> Disease = cold
    ;   malaria -> Disease = malaria
    ;   typhoid -> Disease = typhoid
    ;   dengue -> Disease = dengue
    ;   Disease = unknown
    ).

flu :-
    symptom(fever),
    symptom(cough),
    symptom(headache).

cold :-
    symptom(cough),
    symptom(sneezing),
    symptom(runny_nose).

malaria :-
    symptom(fever),
    symptom(chills),
    symptom(sweating).

typhoid :-
    symptom(fever),
    symptom(abdominal_pain),
    symptom(weakness).

dengue :-
    symptom(fever),
    symptom(joint_pain),
    symptom(rash).