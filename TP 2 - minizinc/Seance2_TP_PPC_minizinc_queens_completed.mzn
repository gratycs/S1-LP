% ============================================================================
% Optimisation pour l'IA — Séance 2 — TD-TP PPC, Exercice 4
% Les n reines en MiniZinc — Modèle 1 (compact) vu en cours (Modélisation PPC) :
% une variable par colonne, son domaine = la ligne occupée.
% ============================================================================

int: n = 8;  % passez à 8 pour la Question 3 (le problème classique des 8 reines)

array[1..n] of var 1..n: q;  % q[i] = ligne de la reine de la colonne i

% --- ETAPE 1 : pas deux reines sur la même ligne ----------------------------
% (déjà écrit — rien à modifier ici)
include "alldifferent.mzn";

% --- ETAPE 2 : pas deux reines sur la même diagonale montante --------------
% Deux reines i != j s'attaquent sur une diagonale montante ssi q[i]+i = q[j]+j.
% Il faut donc que les valeurs (q[i]+i) soient toutes différentes.
% Syntaxe MiniZinc :  alldifferent([ expression | i in 1..n ])
%
% A COMPLETER (1 ligne) :
% si deux reines s'attaquent ssi q[i]+i = q[j]+j, il suffit donc que tous les q[i]+i soit différents
% en fait au lieu du terme "montante", on va préférer le terme bas.gauche <-> haut.droit

constraint alldifferent([q[i]+i | i in 1..n]);

% --- ETAPE 3 : pas deux reines sur la même diagonale descendante -----------
% Même idée avec (q[i]-i).
%
% A COMPLETER (1 ligne) :
% pour diag descendente le sens c'est du haut.gauche <-> bas.droit
constraint alldifferent([q[i]-i | i in 1..n]);

% --- ETAPE 4 : contrainte "pas sur la même ligne" (déjà donnée ci-dessus) --
constraint alldifferent(q);

solve satisfy;

output ["q = ", show(q)];

/*
QUESTION 2 : n=4
Avec l'option A, lo solveur trouve 2 solutions
Running Seance2_TP_PPC_minizinc_queens_completed.mzn	251msec
q = [3, 1, 4, 2]
----------
q = [2, 4, 1, 3]
----------
==========
%%%mzn-stat: failures=4
%%%mzn-stat: initTime=0.0004954
%%%mzn-stat: nodes=11
%%%mzn-stat: peakDepth=2
%%%mzn-stat: propagations=163
%%%mzn-stat: propagators=11
%%%mzn-stat: restarts=0
%%%mzn-stat: solutions=2
%%%mzn-stat: solveTime=0.0001091
%%%mzn-stat: variables=12
%%%mzn-stat-end
%%%mzn-stat: nSolutions=2
%%%mzn-stat-end
Finished in 251msec.
*/


/*
QUESTION 4 : n=8
	Running Seance2_TP_PPC_minizinc_queens_completed.mzn	287msec
q = [4, 2, 7, 3, 6, 8, 5, 1]
----------
…
----------
q = [5, 7, 2, 6, 3, 1, 4, 8]
----------
==========
%%%mzn-stat: failures=270
%%%mzn-stat: initTime=0.0005775
%%%mzn-stat: nodes=723
%%%mzn-stat: peakDepth=8
%%%mzn-stat: propagations=21601
%%%mzn-stat: propagators=19
%%%mzn-stat: restarts=0
%%%mzn-stat: solutions=92
%%%mzn-stat: solveTime=0.0039114
%%%mzn-stat: variables=24
%%%mzn-stat-end
%%%mzn-stat: nSolutions=92
%%%mzn-stat-end
Finished in 287msec.


Il y a 92 solutions
*/

