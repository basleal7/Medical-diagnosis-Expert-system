:- dynamic symptom/1.

% Clear previous symptoms
clear :-
    retractall(symptom(_)).

% ==============================
% Diagnosis Rules
% ==============================

diagnose(flu) :-
    symptom(fever),
    symptom(cough),
    symptom(headache).

diagnose(cold) :-
    symptom(cough),
    symptom(sneezing),
    symptom(runny_nose).

diagnose(malaria) :-
    symptom(fever),
    symptom(chills),
    symptom(sweating).

diagnose(typhoid) :-
    symptom(fever),
    symptom(abdominal_pain),
    symptom(weakness).

diagnose(dengue) :-
    symptom(fever),
    symptom(joint_pain),
    symptom(rash).

diagnose(unknown).

% ==============================
% Treatment Rules
% ==============================

treatment(flu,
"Rest, drink fluids, and take paracetamol.").

treatment(cold,
"Drink warm fluids and get enough rest.").

treatment(malaria,
"Take antimalarial medication and consult a doctor.").

treatment(typhoid,
"Use antibiotics prescribed by a doctor.").

treatment(dengue,
"Drink plenty of fluids and seek medical attention.").

treatment(unknown,
"Consult a healthcare professional.").

% ==============================
% Precaution Rules
% ==============================

precaution(flu,
"Wash hands regularly and avoid close contact.").

precaution(cold,
"Keep warm and maintain hygiene.").

precaution(malaria,
"Use mosquito nets and avoid mosquito bites.").

precaution(typhoid,
"Drink clean water and eat hygienic food.").

precaution(dengue,
"Remove standing water and prevent mosquito bites.").

precaution(unknown,
"Maintain good hygiene and visit a doctor.").