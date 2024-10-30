function A = compA(n)
%compA computes all subsets of a base set of size n >= 2.
% Each subset is represented by a 0/1 column vector of length n. 
% Let c be such a column vector, representing the subset S. 
% Then i \in S if and only if c(i)==1.
%
% We will use the column numbers of the matrix A=compA(n) as the canonical 
% order of all the nonempty subsets of { 1, \ldots, n }.

% Author: Joerg Fliege
% Date: 29/10/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

if (n==2) 
    A = [1 0 1; 0 1 1];
else
   A1 = compA(n-1);
   [n1 m1] = size(A1);
   e = ones(1, m1+1);
   A = [ A1, zeros(n1,1), A1 ;
         zeros(1, m1), e ];
end % if
end