function bool = setinpartition(S,P)
%setinpartition Check if set S is member of partition P.

% Author: Joerg Fliege
% Date: 30/10/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

bool = 0;
[n m] = size(P);
for i=1:m
    if (S==P(:,i)) 
        bool = 1;
    end % if
end % for i

end