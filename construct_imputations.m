function [Aeq, A2, beq, b2] = construct_imputations(P, valP, vi_max_P)
%construct_imputations: takes a partition P and the values v(S, P) stored
% in the vector valP and constructs matrices Aeq, A2, and vectors beq, b2
% such that x is an imputation if and only if Aeq*x=beq and A2*x <= b2.

% Inputs:
% P: partition
% valP: payoff values for all coalitions in P
% vi_max_P: vector of length n, with vi_max(i) the largest right-hand side
% showing up in the imputation constraints x_i \geq v( \{ i \} ; .... )

% Author: Joerg Fliege
% Date: 01/11/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

Aeq = P';
beq = valP';
% hahahahahahahahaaaaaaaaaaa, genius move, right?

[n m] = size(P);
A2 = -eye(n);
b2 = -vi_max_P;

% We are going to build up A2, b2 iteratively:
%A2 = [];
%b2 = [];
%
%[n m] = size(P); % m = number of subsets in P
%for s=1:m 
%    subset = P(:,s);
%    A2 = [A2; -diag(subset) ];
%    b2 = [b2; -vi_max_P ]; 
%end

end