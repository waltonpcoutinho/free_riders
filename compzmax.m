function zmax = compzmax(partitions,sets,payoffs,vi_max)
%compzmax: computes the matrix zmax.
%
% zmax is a matrix with n rows and 2^n-1 entries. Column no. i of zmax 
% corresponds to subset i of { 1, \ldots, n }, as stored in the output of
% comp(n). If T is subset no. i, then zmax(k, i) = z_k^{max} (T), the
% latter as defined in Subsection 2.2.1.
%
% Inputs:
% partitions: cell array with all partitions to consider
% sets: all sets to consider
% payoffs: payoff values for all partitions that are considered
% vi_max: cell array. If P=partitions{j} and vi_max_P=vi_max{j}, then
% vi_max_P(i) isthe largest right-hand side showing up in the imputation 
% constraints x_i \geq v( \{ i \} ; .... ) of I(P).

% Known bugs: none, but the for-loops can be reordered for further
% efficiency. Suggest to place the k-loop (players) innermost.

% Author: Joerg Fliege
% Date: 01/11/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

[n m] = size(sets);
B = length(partitions);
zmax = ones(n,m);
zmax = -Inf*zmax;

for k=1:n % players
    c = zeros(n,1);
    c(k) = -1;
    for i=1:m % sets
        S = sets(:,i);
        for j=1:B % partitions
            P = partitions{j};
            valP = payoffs{j}';
            if setinpartition(S,P)
               vi_max_P = vi_max{j};
               [A1, A2, b1, b2] = construct_imputations(P, valP, vi_max_P);
               [ x, fval, exitflag, output] = linprog(c, A2, b2, A1, b1);
               if (exitflag>0)
                  fval = -fval;
               else 
                   fval = -Inf;
               end % if problem feasible
               zmax(k,i) = max(zmax(k,i), fval);
            end % if
        end % for j
    end % for i
end % for k

zmax = max(zmax, -100);
% To prevent numerical instabilities in any linear solver.
% Assumes that all payoffs are larger than -100.

end