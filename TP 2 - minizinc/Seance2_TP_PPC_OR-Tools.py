"""
Test du solveur ortools sur le cas exedbike

**Code généré par gemini/mistral**

G. Raty 2026-10-14

"""

# %% Initialisation

from ortools.sat.python import cp_model
# print(cp_model)

# =============================================================================
# . Creation du modele
# =============================================================================

model = cp_model.CpModel()

# Donnees du probleme
noms = ["Urban", "Cargo", "Sport"]
durees = [3, 5, 4]  # durees en heures
horizon = 15

# Variables d'intervalle pour chaque tache
taches = []
variables_fin = []

# i = 0
for i,_ in enumerate(noms):
    # print(i)
    
    # Variable de debut (entre 0 et l'horizon)
    # start_var = model.NewIntVar(0, horizon, f"{noms[i]}_start")
    start_var = model.new_int_var(0, horizon, f"{noms[i]}_start")
    
    # Variable de fin (calculee automatiquement ou declaree)
    end_var = model.new_int_var(0, horizon, f"{noms[i]}_end")
    
    # Creation de l'intervalle avec CP-SAT
    interval_var = model.new_interval_var(start_var, durees[i], end_var, f"{noms[i]}_interval")
    
    taches.append(interval_var)
    variables_fin.append(end_var)
    
# 2. Contrainte de non-chevauchement (l'equivalent de disjunctive en MiniZinc)
model.add_no_overlap(taches)

# 3. Objectif : minimiser le makespan (la date de fin du dernier lot)
makespan = model.new_int_var(0, horizon, "makespan")

# Le makespan doit etre superieur ou egal a la fin de toutes les taches
model.add_max_equality(makespan, variables_fin)

# On demande de minimiser cette variable
model.minimize(makespan)

# 4. Resolution
solver = cp_model.CpSolver()

# %% partie solveur
status = solver.solve(model)

# check des stats
print(solver.response_stats())

# =============================================================================
# %% 5. Affichage des resultats
# =============================================================================
if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
    print(f"Makespan optimal = {solver.Value(makespan)}h\n")
    for i in range(len(noms)):
        print(f"{noms[i]} : debut={solver.Value(taches[i].StartExpr())}h, fin={solver.Value(taches[i].EndExpr())}h")
else:
    print("Aucune solution trouvee.")

# %%
