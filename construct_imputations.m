function [A1 A2 b1 b2] = construct_imputations(P, valP)
%construct_imputations: takes a permutation P and the values v(S, P) stored
% in the vector valP and constructs matrices A1, A2, and vectors b1, b2
% such that x is an imputation if and only if A1*x=b1 and A2*x <= b2.

% Known bugs: lower bounds on x_i are all set to x_i \geq 0.

% Author: Joerg Fliege
% Date: 29/10/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

A1 = P';
b1 = valP';
% hahahahahahahahaaaaaaaaaaa, genius move, right?

% We are going to build up A2, b2 iteratively:

A2 = [];
b2 = [];

[n m] = size(P); % m = number of subsets in P
for s=1:m 
    subset = P(:,s);
    A2 = [A2; -diag(subset) ];
    b2 = [b2; zeros(n,1) ]; % HARDCODED, KNOWN BUG: this means v({i}; ...) = 0.
end

end