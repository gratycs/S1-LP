% ============================================================================

% G. Raty 2026-10-14

% Optimisation pour l'IA — Séance 2 — TD-TP PPC, Exercice 6
% Ordonnancement ExedBike en MiniZinc — même instance qu'au TP2 (Exercice 4,
% CP-SAT/OR-Tools) : 3 lots sur une même ligne, non-chevauchement, minimiser
% le makespan. En MiniZinc, la contrainte globale de non-chevauchement
% d'intervalles est "disjunctive".
% ============================================================================

include "disjunctive.mzn";

int: horizon = 15;
array[1..3] of string: noms = ["Urban", "Cargo", "Sport"];
array[1..3] of int: dur = [3, 5, 4];  % durées en heures

array[1..3] of var 0..horizon: s;  % dates de début
array[1..3] of var 0..horizon: e;  % dates de fin

% --- ETAPE 1 : lier début, durée et fin (déjà écrit) ------------------------
constraint forall(i in 1..3)(e[i] = s[i] + dur[i]);

% --- ETAPE 2 : non-chevauchement --------------------------------------------
% La ligne ne peut traiter qu'un lot à la fois : utilisez la contrainte
% globale "disjunctive(s, dur)" (elle prend directement les tableaux de
% débuts et de durées).
%
% A COMPLETER (1 ligne) :
% https://docs.minizinc.dev/en/2.10.1/lib-globals-scheduling.html#disjunctive
% disjunctive(start, duration) fait deja tout le travail
constraint disjunctive(s, dur);


% --- ETAPE 3 : objectif = minimiser la date de fin du dernier lot ----------
var 0..horizon: makespan;
%
% A COMPLETER (2 lignes : contrainte liant makespan à max(e), puis solve minimize) :
constraint makespan = max(e);

solve minimize makespan ;

output [ noms[i] ++ " : début=" ++ show(s[i]) ++ "h, fin=" ++ show(e[i]) ++ "h\n" | i in 1..3 ]
      ++ ["makespan = ", show(makespan), "h"];
      
/*
solution :
    Cargo : début=0h, fin=5h
    Sport : début=5h, fin=9h
    Urban : début=9h, fin=12h
    makespan = 12h

La durée minimale est 3+4+5 = 12. peut importe l'ordre. Puisqu'on ne produit qu'un seul lot a la fois et qu'ils s'enchainent.
c'est bien la solution minimale que l'on attendait (durée = 0 entre les lots)

*/

/*
Question 3 :
cf. cours slide 44 : 
IntervalVar(start, duration, end) : représente une tâche à placer dans le temps
NoOverlap([...]) : contrainte globale – les intervalles d’une même ressource ne se chevauchent pas

L'avantage de l'utilisation de la fonction minizinc disjunctive(s, dur), permet de définir en une seule ligne 
a la fois les intervalles et a la fois la constrainte de disjonction

*/


