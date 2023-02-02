function crossCost = get_cross_cost(V1,V2,H)
% calculate cross-graph cost: exp^(-V1*V2')
% Input:
%   V1: node attributes of graph 1, shape=n1*d
%   V2: node attributes of graph 2, shape=n2*d
%   H: prior knowledge, shape=n1*n2
% Output:
%   crossCost: alignment cost based on node attributes, shape=n1*n2
    %% Consine dissimilarity
    row1 = find(sum(abs(V1),2)==0);
    row2 = find(sum(abs(V2),2)==0);
    [~,d] = size(V1);
    V1 = V1./sqrt(sum(V1.*V1,2));
    V2 = V2./sqrt(sum(V2.*V2,2));
    V1(row1,:) = sqrt(1/d);
    V2(row2,:) = sqrt(1/d);
    crossCost = exp(-V1 * V2');
    HInd=find(H');
    crossCost(HInd)=0;
end