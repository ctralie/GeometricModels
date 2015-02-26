%Return a cell array of all clusters at level "level"
%The first element of each cell is the index of the cluster center
%and the rest of the elements are in that cluster's subtree
function [ centers ] = getSubtreesAtLevel( B, level )
    CentersIdx = 1:size(B.levels, 1);
    CentersIdx = CentersIdx(B.levels(:, 1) <= level);
    centers = cell(1, length(CentersIdx));
    
    %B.levels contains:
    %   int* levels;
    %   int* parents;
    %   int* numchildren;
    %   int* childoffsets;
    %   int* children;    
    
    for jj = 1:length(CentersIdx)
        %Now find all of the children
        NChildren = B.levels(CentersIdx(jj), 3);

        ChildrenIdx = (1:NChildren) + B.levels(CentersIdx(jj), 4);
        
        children = CentersIdx(jj);
        for kk = ChildrenIdx
            child = B.levels(kk, 5)+1;
            children = getChildrenInCluster(children, B, child, level);
        end
        centers{jj} = children;
    end
end

