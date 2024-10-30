function [c, A1, A2, b1, b2] = constructLP(P, x, zmax, Q, T, valQ)
% constructLP:
% constructs the LP from Theorem 1 (p. 9) for a given pair (P, x) and a
% partition Q and a set T with T \in Q.
%
% x is a vector in R^n.
%
% P is a partition of the set { 1, \ldots, n } stored in matrix form,
% that is P has 0/1 entries, n rows, and P*e_m = e_n, where e_m, e_n are 
% vectors of 1's of length m and n.
%
% zmax is a matrix with n rows and 2^n-1 entries. Column no. i of zmax 
% corresponds to subset i of { 1, \ldots, n }, as stored in the output of
% comp(n). If T is subset no. i, then zmax(k, i) = z_k^{max} (T), the
% latter as defined in Subsection 2.2.1.
% 
% Q: some other partition, stored in the same way as P.
%
% T: a subset of {1, \ldots, n} that shows up in Q (i.e. a column of Q).
%
% valQ: column vector of values v(S, Q) for all subsets S of Q. Values are
% stored in the same order as subsets S are stored in the matrix Q.

% We write the decision vector of the LP as z := [y; w] with y, w as in 
% Theorem 1.
%
% Output:
% Vectors c, b1, b2 and matrices A1, A2, by which we write the LP as
% min c' * z 
% s.t. A1*z =  b1, 
%      A2*z <= b2.

% Author: Joerg Fliege
% Date: 29/10/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

[n, m] = size(Q);

% Zeroth step, encode the objective max w:
c = zeros(1, n+1);
c(n+1) = -1;

% First step, encode $y \in I(Q)$:
[A1, A2, b1, b2] = construct_imputations(Q, valQ);
[n2_old, m2_old] = size(A2); % store these values for later

% Second step, encode $y step_k = z_k^{max} (T)$ for k \notin T:
notT = ones(n, 1) - T;

A1 = [ A1; diag(notT)];

allsets = compA(n);
for i=1:2^n-1
    if T==allsets(:,i)
        indexT=i;
    end % if
end % for

b1 = [ b1; notT .* zmax(indexT) ];
% This is obviously not efficient, as many of these equations just say 0=0.

% Third step, encode -y_i \leq -x_i for all i \in T:
A2 = [ A2; -diag(T)];
b2 = [b2; T .* (-x)];

% Finally, extend A1 and A2 by one column so that we can build the 
% products A1*[y;w] and A2*[y; w]:
[n1 m1] = size(A1);
A1 = [A1, zeros(n1, 1) ];
A2 = [A2, [ zeros(n2_old, 1); ones(n, 1) ] ];

end % function