function list = CompPart(n)
    %CompPart computes all partitions of the set \mathcal{N} = \{ 1, \ldots, n \}.
    %   Output: list. A cell array of length B_n, where B_n is Bell's number
    %           (The number of partitions of \mathcal{N}.)
    % Partitions are stored in the same way than subsets of \mathcal{N}.
    % Each partition is stored as a matrix of size n times m, where m is the
    % number of elements in the partition. Each column corresponds to one
    % subset of the partition. Each column is a 0/1 vector of length n, where
    % a 1 in row k indicates membership of element k in the set.

    % Author: Joerg Fliege
    % Date: 30/10/2024
    % Version: 1.0
    % (c) Nucleolus Software Ltd

    % tic; list = CompPart(12); toc
    % Elapsed time is 18.074701 seconds.
    % tic; list = CompPart(13); toc % Starts swapping to disk.
    % Elapsed time is 276.479086 seconds.

    % Declare output list
    list = cell(lookupBell(n),1);

    if n==2
       list{1} = [1; 1];
       list{2} = [1 0 ; 0 1];
    else
        list1 = CompPart(n-1);
        B = length(list1);
        for i=1:B
            % Add the column vector (0, ..., 0, 1)' as the rightmost column
            % to P. In other words, add the set \{ n \} to P.
            list{i} = [list1{i}, zeros(size(list1{i}, 1),1); zeros(1, size(list1{i}, 2)), 1];
        end % for i
        c = B+1; % counter for list
        for i=1:B
            for j = 1:size(list1{i},2)
                % Add the element n to set no. j of partition P.
                list{c} = [list1{i} ; zeros(1, j-1), 1, zeros(1, size(list1{i},2)-j)];
                c = c+1;
            end % for j
        end % for i
    end % if

end
