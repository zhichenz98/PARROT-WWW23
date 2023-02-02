function [crossC, intraC1, intraC2] = get_cost(A1,A2,V1,V2,H,rwrIter,rwIter,alpha,beta,gamma)
% calculate cross/intra-graph cost based on attribute/rw
% Input:
%   A1: adjacency matrix for graph 1, shape=n1*n1
%   A2: adjacency matrix for graph 2, shape=n2*n2
%   V1: node attributes for graph 1, shape=n1*d
%   V2: node attributes for graph 2, shape=n2*d
%   H: anchor links, shape=n2*n1
%   crossC: cross-graph cost matrix, shape=n1*n2
%   intraC1: intra-graph cost matrixfor graph 1, shape=n1*n1
%   intraC2: intra-graph cost matrixfor graph 2, shape=n2*n2
%   rwrIter: number of iteartion for random walk with restart
%   rwIter: number of iteration for random walk
%   alpha: weight balancing attribute cost and rwr cost
%   beta: rwr restart ratio
%   gamma: discounted factor of Bellman equation
% Output:
%   crossC: cross-graph cost matrix, shape=n1*n2
%   intraC1: intra-graph cost matrix for graph 1, shape=n1*n1

    tCostStart = tic;    
    %% calculate rwr
    T1 = cal_trans(A1,{});
    T2 = cal_trans(A2,{});
    [rwr1, rwr2] = get_sep_rwr(T1, T2, H, beta, rwrIter);
    rwrCost = get_cross_cost(rwr1,rwr2,H);
    
    %% cross/intra-graph cost based on node attributes
    if isempty(V1) || isempty(V2)   % plain graph with rwr
        V1 = rwr1;
        V2 = rwr2;
    end
    intraC1 = sparse(get_intra_cost(V1).*A1);
    intraC2 = sparse(get_intra_cost(V2).*A2);
    crossC = get_cross_cost(V1,V2,H);

    %% rwr on the product graph
    crossC = crossC + alpha*rwrCost;
    L1 = A1./sum(A1,2); % Laplacian matrix
    L2 = A2./sum(A2,2);
    crossC = get_prod_rwr(L1,L2,crossC,H,beta,gamma,rwIter); 
    tCostEnd = toc(tCostStart);
    fprintf("time for cost matrix: %.2fs\n",tCostEnd);

