%Programmer: Chris Tralie

%Purpose: To build a full cover tree on a point cloud sampled from a 
%stratified space using the Euclidean metric, and to walk up the tree
%from the bottom up, merging points that have a similar radial eigen metric

%NOTE: This is not efficient!  Mainly because there are excess recursive 
%queries to get nodes in a subtree.  So for now it's just exploratory

addpath('BillsCode');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%VARIABLES THAT CHANGE WHAT POINT CLOUD IS EXAMINED
%%%%%%%%%%%AND WHEN TO SUBDIVIDE
DM = load('DM.txt');
X = load('pc.txt');
N = size(X, 1);
maxDiam = 2;%The diameter at which to stop subdividing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A.theta = .5;%Radius of the cover tree
A.numlevels = N;%Maximum number of levels
%Other parameters for optimizing speed (keep these as is)
A.minlevel=int32(0);
A.NTHREADS=int32(4);
A.BLOCKSIZE=int32(32);

A.numlevels = int32(N);
B = covertree(A, X');%Note: Bill's code expects the transpose of Matlab's
%convention for point clouds expressed as a matrix!

rootLevel = B.outparams(2);
maxLevel = max(B.levels(:, 1));

%Look at the subtrees level by level
label = zeros(1, N);
centers = [];
for ii = 1:max(B.levels(:, 1))-min(B.levels(:, 1))
    level = ii + rootLevel - 1;
    subtree = getSubtreesAtLevel(B, level);
    for jj = 1:length(subtree)
        c = subtree{jj};
        if sum(label(c) > 0) == 0 %If none of these points are already part of a center
            DMSub = DM(c, c);
            if max(DMSub(:)) < maxDiam
                %If the diameter is lower than the chosen bound, stop
                %dividing here
                label(c) = length(centers)+1;
                centers(end+1) = c(1);
            end
        end
    end
end

%Plot the results, picking different colors
clf;
C = colormap('jet');
cidx = randperm(64);
hold on;
for ii = 1:length(unique(label))
    idx = 1:N;
    idx = idx(label == ii);
    thiscidx = cidx(mod(ii-1, size(C, 1))+1);
    scatter(X(idx, 1), X(idx, 2), 20, C(thiscidx, :), 'fill');
end
label = arrayfun(@(x) {sprintf('%i', x)}, label);
Y = X + 0.002;
%text(Y(:, 1), Y(:, 2), label);
scatter(X(centers, 1), X(centers, 2), 100, 'x', 'k');
title(sprintf('Cover Tree Eigen Metric Diameter %g', maxDiam));