import numpy as np
from scipy.optimize import linprog
from itertools import chain, combinations

def Maskins_payoff(S, P):
   '''
   Returns the payoff function for the Maskin example:

   Input:
   S: A coallition from the partition P, ex: S = [2,3]
   P: A given partition, ex: P = [[1], [2,3]]

   Returns:
   val: The payoff value for (S,P)
   '''
   val = 0  # Default value
   
   if P == [[0], [1], [2]]:
      val = 0
   elif P == [[0], [1, 2]]:
      if S == [0]:
         val = 9
      elif S == [1, 2]:
         val = 14
   elif P == [[1], [0, 2]]:
      if S == [1]:
         val = 9
      elif S == [0, 2]:
         val = 13
   elif P == [[2], [0, 1]]:
      if S == [2]:
         val = 9
      elif S == [0, 1]:
         val = 12
   elif P == [[0, 1, 2]]:
      val = 24

   return val

def solve_lp(x, v, Q, T, Uhat, R, cuts):
   '''
   Function that solves the linear programming subproblems in the Coutinhovic 
   domination algorithm

   Input:

   x: \in R^N allocation vector of pair (P,x)
   v(S,P): payoff function for a given coalition S and partition P
   Q: Array with a given partition structure, ex: Q = [[1], [2,3]]
   T: A given coallition T \in Q, ex: T = [2,3]
   Uhat: set of unhappy players, ex: Uhat = [1,3]
   R: Some other partition that contains T and Uhat
   cuts: list of cuts of the type \sum_{k \in Uhat} y_k > v(Uhat; R)
   '''

   # Decision variables [y_0, y_1, y_N-1, w]
   # Coeficients of variables in the objective
   c = np.zeros(len(x) + 1)
   c[-1] = -1  # maximise w

   # Coefficients variables in the constraints
   A_eq, A_ineq = [], []

   # RHS
   b_eq, b_ineq = [], []

   # Coefficients of inequality constraints (w <= y_i - x_i, \forall i in T)
   for i in T:
      row = np.zeros(len(x) + 1)
      row[i] = -1  # -y_i
      row[-1] = 1  # +w
      A_ineq.append(row)
   b_ineq = [-x[i] for i in T]

   # Inputation constraints y \in I(Q), 
   # with I(Q) = \{ x \in \R^N \mid \forall S \in Q : E(x, S; Q) = 0, \forall i \in S: 
   # x_i \geq v(\{i\}; \{\{i\}, S \backslash \{ i\}, Q\backslash S\})
   # This constraint is divided into 2 parts, the first one is excess computation, and
   # the second one is the individual rationality

   # Part 1: The excess of a coallition S relative to partition Q is 
   # E(y, S, Q) = v(S, Q) - \sum_{i \in S} y_i
   for S in Q:
      row = np.zeros(len(x) + 1)
      for i in S:
         row[i] = 1
      A_eq.append(row)
      b_eq.append(Maskins_payoff(S, Q))

      # Part 2: Individual rationalities given by
      # x_i \geq v(\{i\}; \{\{i\}, S \backslash \{ i\}, Q\backslash S\})
      for i in S:
         row = np.zeros(len(x) + 1)
         row[i] = -1  # -y_i
         A_ineq.append(row)
         S_minus_i = [j for j in S if j != i]
         P_new = [[i], S_minus_i] + [C for C in Q if C != S]
         b_ineq.append(-Maskins_payoff([i], P_new))

   # Add cuts to the set of inequality constraints \sum_{k \in Uhat} y_k > v(Uhat; R)
   for cut in cuts:
      row = np.zeros(len(x) + 1)
      row[cut] = -1  # -\sum_{k \in Uhat} y_k
      A_ineq.append(row)
      b_ineq.append(-Maskins_payoff(cut, R) - 1e-6)  # Strict inequality

   # Convert the python lists into arrays
   A_eq, A_ineq, b_eq, b_ineq = map(np.array, (A_eq, A_ineq, b_eq, b_ineq))

   # Call scipy's linear programming solver
   res = linprog(c, A_ineq, b_ineq, A_eq, b_eq)

   # Get the optimisation status
   status = res.message

   val = -1
   # Get the optimal o.f. value if the problem is feasible
   if res.success:
      val = -res.fun

   return val, status

# Test example for solve_lp function
def test_solve_lp():
    print("Testing solve_lp function...")
    
    # Basic test case
    x = np.array([4.0, 5.0, 6.0])
    Q = [[0], [1, 2]]
    T = [1, 2]
    Uhat = [0]
    R = [[0, 1, 2]]
    cuts = []
    
    val, status = solve_lp(x, Maskins_payoff, Q, T, Uhat, R, cuts)
    print(f"Result: {val}, Status: {status}")

# Run the test if this script is executed directly
if __name__ == "__main__":
    test_solve_lp()
