function newlist = convertlist(list)
%convertlist Converts elements of the list into unsigned 8-bit integer
%structures.

% Author: Joerg Fliege
% Date: 30/10/2024
% Version: 1.0
% (c) Nucleolus Software Ltd

for i = 1:length(list)
    newlist{i} = uint8(list{i});
end % for

end