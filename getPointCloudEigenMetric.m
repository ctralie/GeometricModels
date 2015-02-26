function [ XE ] = getPointCloudEigenMetric( X, maxR, NR, NEigs )
    N = size(X, 1);
    XE = zeros(N, NR*NEigs);
    R = linspace(0, maxR, NR);
    for ii = 1:N
        fprintf(1, 'Doing %i of %i\n', ii, N);
        thisEigs = zeros(NR, NEigs);
        dR = X - repmat(X(ii, :), size(X, 1), 1);
        dR = sqrt(sum(dR.*dR, 2));
        for kk = 1:NR
            x = X(dR < R(kk), :);
            [~, ~, eigs] = pca(x);
            thisNEigs = min(NEigs, length(eigs));
            thisEigs(kk, 1:thisNEigs) = eigs(1:thisNEigs);
        end
        XE(ii, :) = thisEigs(:);
    end
end