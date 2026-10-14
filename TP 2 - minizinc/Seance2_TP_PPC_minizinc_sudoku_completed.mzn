% ============================================================================
% Optimisation pour l'IA — Séance 2 — TD-TP PPC, Exercice 5
% Le Sudoku du cours, en MiniZinc — grille 9x9 partiellement remplie (30
% indices donnés). Sa solution est EXACTEMENT la grille 9x9 des diapositives
% (section Modélisation PPC, "Le même modèle, à toutes les échelles").
% ============================================================================

include "alldifferent.mzn";

int: N = 9;

array[1..N,1..N] of int: given = array2d(1..N, 1..N, [
  0, 3, 0, 0, 0, 0, 0, 0, 2,
  0, 0, 0, 1, 0, 0, 3, 0, 0,
  1, 9, 8, 0, 0, 2, 0, 0, 0,
  0, 0, 0, 7, 0, 1, 4, 0, 0,
  4, 0, 0, 8, 0, 0, 0, 9, 0,
  0, 0, 0, 0, 2, 4, 0, 5, 6,
  0, 6, 1, 5, 3, 7, 0, 0, 4,
  2, 0, 7, 0, 0, 9, 0, 3, 0,
  0, 0, 0, 0, 0, 6, 1, 0, 0
]);

array[1..N,1..N] of var 1..N: cell;

% --- ETAPE 1 : respecter les indices donnés (déjà écrit) -------------------
constraint forall(i,j in 1..N where given[i,j] > 0)(cell[i,j] = given[i,j]);

% --- ETAPE 2 : une valeur par ligne -----------------------------------------
% Syntaxe :  forall(i in 1..N)(alldifferent([cell[i,j] | j in 1..N]))
%
% A COMPLETER (1 ligne) :
% pour une ligne donnée, les cellule de la ligne (donc pour chaque colonne) sont différents
constraint forall(i in 1..N)(alldifferent([cell[i,j] | j in 1..N]));

% --- ETAPE 3 : une valeur par colonne ---------------------------------------
%
% A COMPLETER (1 ligne) :
% Idem mais on inverse les i j 
constraint forall(j in 1..N)(alldifferent([cell[i,j] | i in 1..N]));


% --- ETAPE 4 : une valeur par bloc 3x3 --------------------------------------
% Indice : bi,bj in 0..2 indexent les 9 blocs ; la case (bi*3+i, bj*3+j) pour
% i,j in 1..3 parcourt les 9 cases du bloc (bi,bj).
%
% A COMPLETER (1 ligne, peut être coupée sur 2 lignes) :
% exemple bi=1 (ligne 2), bij=2 (colonne 3) : ca remplie les case 4 5 6 (ligne 1*3 +1..3) de la colonne 7, puis 8 puis 9 (2*3 + 1..3) 
constraint forall(bloc_i, bloc_j in 0..2)(alldifferent([cell[bloc_i*3 + i, bloc_j*3 + j] | i,j in 1..3]));


% question bonus pour sommer les lignes/colonnes/
constraint forall(i in 1..N)(sum(j in 1..N)(cell[i,j]) = 45);
constraint forall(j in 1..N)(sum(i in 1..N)(cell[i,j]) = 45);
constraint forall(bloc_i, bloc_j in 0..2)(sum(i,j in 1..3)(cell[bloc_i*3+i,bloc_j*3+j]) = 45);
/*
Le résultat ne change pas, la contrainte alldifferent + le domaine 1 à 9 ne permettent deja pas autre chose qu'une somme à 45
45 = 1+2+3+4+5+6+7+8+9
Une contrainte redondante peut améliorer le pb (renforcement de la propagation) mais ici le solveur met le même temps :
    - sans contrainte sup : solveTime=0.0001834
    - avec : solveTime=0.0001884
*/

solve satisfy;

output [ if j = 1 then "\n" else " " endif ++ show(cell[i,j]) | i in 1..N, j in 1..N ];


/*
	Running Seance2_TP_PPC_minizinc_sudoku_completed.mzn	472msec
5 3 4 6 7 8 9 1 2
6 7 2 1 9 5 3 4 8
1 9 8 3 4 2 5 6 7
8 5 9 7 6 1 4 2 3
4 2 6 8 5 3 7 9 1
7 1 3 9 2 4 8 5 6
9 6 1 5 3 7 2 8 4
2 8 7 4 1 9 6 3 5
3 4 5 2 8 6 1 7 9
----------
==========
%%%mzn-stat: failures=0
%%%mzn-stat: initTime=0.0006015
%%%mzn-stat: nodes=1
%%%mzn-stat: peakDepth=0
%%%mzn-stat: propagations=27
%%%mzn-stat: propagators=0
%%%mzn-stat: restarts=0
%%%mzn-stat: solutions=1
%%%mzn-stat: solveTime=0.0001136
%%%mzn-stat: variables=0
%%%mzn-stat-end
%%%mzn-stat: nSolutions=1
%%%mzn-stat-end
Finished in 472msec.

  
Même avec le paramètre "-a", il existe une seule solution (solver lancé avec -a donne une seule solution)
