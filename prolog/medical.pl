:- dynamic symptom/1.

clear :- retractall(symptom(_)).

% Main diagnosis (Top 3 results, formatted)
diagnose(FinalResults) :-
    findall(P-D, disease_percentage(D, P), Raw),
    sort(Raw, Sorted),              % ascending
    reverse(Sorted, Desc),          % descending
    take_top(Desc, 3, Top),         % take top 3 only
    format_results(Top, FinalResults).

% Disease definitions
disease(flu, [fever, cough, headache]).
disease(cold, [cough, sneezing, runny_nose]).
disease(malaria, [fever, chills, sweating]).
disease(typhoid, [fever, abdominal_pain, weakness]).
disease(dengue, [fever, joint_pain, rash]).

% Percentage calculation (rounded to integer)
disease_percentage(Disease, PercentRounded) :-
    disease(Disease, Symptoms),
    count_matches(Symptoms, Match),
    length(Symptoms, Total),
    (Total > 0 ->
        Percent is (Match / Total) * 100
    ;
        Percent is 0
    ),
    PercentRounded is round(Percent).

% Count matching symptoms
count_matches(Symptoms, Count) :-
    findall(S, (member(S, Symptoms), symptom(S)), Matches),
    length(Matches, Count).

% Take top N results
take_top(_, 0, []) :- !.
take_top([], _, []).
take_top([H|T], N, [H|R]) :-
    N1 is N - 1,
    take_top(T, N1, R).

% Format output as Disease-Percent (only >0)
format_results([], []).
format_results([P-D|T], [D-P|R]) :-
    P > 0,
    format_results(T, R).
format_results([P-_|T], R) :-
    P =:= 0,
    format_results(T, R).