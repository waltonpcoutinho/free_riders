function [bool, Q, valQ, y] = checkdom_T1(P, x, partitions, payoffs, vi_max, zmax)
%checkdom_T1 Checks if (P, x) can be dominated or not by using the
%criterion from Theorem 1 (p. 9).
%
% Output: 
% bool: binary variable
%       bool=1 if (P, x) can be dominated
%       bool=0 if (P, x) cannot be dominated
% (Q, y): if bool=1 then (Q, y) dominates (P, x)
%         else y=0, Q the last partition in 'partitions'.
% valQ: payoff values of coalitions in Q.  
%
% By Theorem 1, we need to test (P, x) against all partitions in \Pi. Here,
% we will use the partitions from the cell array argument 'partitions', in
% case some preprocessing was able to reduce the number of tests needed.
%
% If (P, x) can be dominated then (Q, y) is the first dominating pair
% encountered in the search process. This depends on the ordering of the
% partitions in 'partitions'.

% Author: Joerg Fliege
% Date: 01/11/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

bool=0;
y=0;
[n, m] = size(P);
c = zeros(n+1,1);
c(n+1) = -1;

for i = 1:length(partitions)
    Q = partitions{i};
    [n, m] = size(Q);
    valQ = payoffs{i};
    vi_max_Q = vi_max{i};
    for j = 1:m % sets
        T = Q(:,j);
        [c, A1, A2, b1, b2] = constructLP_T1(P, x, zmax, Q, T, valQ, vi_max_Q);
        [yw, fval, exitflag, output] = linprog(c, A2, b2, A1, b1);
        fval=-fval;  
        if ((exitflag>=1) & (fval>0)) 
            % Problem from Th.1 feasible and optimal obj fun value > 0
            bool = 1; % Certificate found that (P, x) can be dominated.
            % Q=Q;
            y = yw(1:n);
            return; % exit subroutine
            %
            % Might be worthwhile to store (Q,y) in another cell array and
            % run over all (Q, T) pairs, to find all dominating pairs.
            %
        end % end if
    end % for j
end % for i

end