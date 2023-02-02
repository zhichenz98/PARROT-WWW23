function [T, W, res] = parrot(A1,A2,V1,V2,H,sepRwrIter,prodRwrIter,alpha,beta,gamma,inIter,outIter,l1,l2,l3,l4)
% position-aware optimal transport for network alignment
% Input:
%   A1: adjacency matrix for graph 1, shape=n1*n1
%   A2: adjacency matrix for graph 2, shape=n2*n2
%   V1: node attributes for graph 1, shape=n1*d
%   V2: node attributes for graph 2, shape=n2*d
%   H: anchor links, shape=n2*n1
%   sepRwrIter: number of iteartion for rwr on separated graphs
%   prodRwrIter: number of iteration for rwr on product graph
%   alpha: weight balancing attribute cost and rwr cost
%   beta: rwr restart ratio
%   gamma: discounted factor of Bellman equation
%   inIter: number of inner iteration for logipot algorithm
%   outIter: number of outer iteration for logipot algorithm
%   l1: weight for update step regularization
%   l2: weight for smoothness regularization
%   l3: weight for prior knowledge regularization
%   eps: weight balancing Wasserstein and Gromov-Wasserstein distance
% Output:
%   T: trasnport plan/alignment score, shape=n1*n2
%   W: Wasserstein distance along the distance, shape=outIter
%   res: diff between two consecutive alignment scores, shape=outIter
    [nx, ny] = size(H');
    row1 = find(sum(A1,2)==0);
    row2 = find(sum(A2,2)==0);
    A1(row1,:) = ones(length(row1),nx);
    A2(row2,:) = ones(length(row2),ny);
    L1 = A1./sum(A1,2); % Laplacian matrix
    L2 = A2./sum(A2,2);
    
    %% calculate cross-graph/intra-graph cost if not pre-computed
    [crossC, intraC1, intraC2] = get_cost(A1,A2,V1,V2,H,sepRwrIter,prodRwrIter,alpha,beta,gamma); 
    [T, W, res] = cpot(L1,L2,crossC,intraC1,intraC2,inIter,outIter,H,l1,l2,l3,l4);
end

