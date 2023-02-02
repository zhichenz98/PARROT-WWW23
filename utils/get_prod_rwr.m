function crossCost = get_prod_rwr(L1, L2, nodeCost, H, beta, gamma, prodRwrIter)
% rwr cost on product graph
% Input:
%   L1: Laplacian matrix for graph 1, shape=n1*n1
%   L2: Laplacian matrix for graph 2, shape=n2*n2
%   crossC: cross-graph cost matrix, shape=n1*n2
%   H: anchor links, shape=n2*n1
%   gamma: discounted factor
%   prodRwrIter: maximum number of iteartion for Bellman equation
% Output:
%   crossCost: random walk cost, shape=n1*n2
    eps = 1e-2;
    [nx, ny] = size(H');
    HInd = find(H');
    crossCost = zeros(nx,ny);
    i = 0;
    res = inf;
    while i < prodRwrIter && res > eps
        rwCost_old = crossCost;
        crossCost = (1+gamma*beta)*nodeCost + (1-beta)*gamma*L1*crossCost*L2';
        crossCost(HInd) = 0;
        res = max(abs(crossCost-rwCost_old),[],"all");
        i = i + 1;
    end
    crossCost = (1-gamma)*crossCost;
    crossCost(HInd) = 0;
end