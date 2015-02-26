function [ newchildren ] = getChildrenInCluster( inchildren, B, idx, level )
    if B.levels(idx, 1) > level
        newchildren = [inchildren idx];
    else
        newchildren = inchildren;
        return;
    end

    NChildren = B.levels(idx, 3);
    
    ChildrenIdx = (1:NChildren) + B.levels(idx, 4);
    for jj = ChildrenIdx
        child = B.levels(jj, 5)+1;
        newchildren = getChildrenInCluster(newchildren, B, child, level);
    end
end