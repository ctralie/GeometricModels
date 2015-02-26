addpath('BillsCode');

XE = load('XE.mat');
XE = XE.XE;
X = load('pc.txt');
N = size(X, 1);

A.theta = .5;%Radius of the cover tree
A.numlevels = N;%Maximum number of levels
%Other parameters for optimizing speed (keep these as is)
A.minlevel=int32(0);
A.NTHREADS=int32(4);
A.BLOCKSIZE=int32(32);

A.numlevels = int32(N);
B = covertree(A, XE');%Note: Bill's code expects the transpose of Matlab's
%convention for point clouds expressed as a matrix!

rootLevel = B.outparams(2);

C = colormap;
idx = 1:31:size(C, 1)*11;
idx = mod(idx-1, size(C, 1))+1;
C = C(idx, :);

th = 0:0.1:2*pi+0.1;
for ii = 1:max(B.levels(:, 1))-min(B.levels(:, 1))
    clf;
    hold on;
    level = ii + rootLevel - 1;
    
    centers = getSubtreesAtLevel(B, level);
    for jj = 1:length(centers)
        cidx = mod(jj-1, size(C, 1))+1;
        idx = centers{jj}(1);
        plot(X(centers{jj}, 1), X(centers{jj}, 2), '.', 'color', C(cidx, :));
        scatter(X(idx, 1), X(idx, 2), 50, C(cidx, :), 'X');
    end
    print('-dpng', '-r300', sprintf('%i.png', ii));
end