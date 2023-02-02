function intraCost = get_intra_cost(V)
% calculate intra-graph cost: exp^(-V*V')
% Input:
%   V: node attributes, shape=n1*d
% Output:
%   crossCost: alignment cost based on node attributes, shape=n1*n2
    %% Consine dissimilarity
    row = find(sum(abs(V),2)==0);
    [~,d] = size(V);
    V = V./sqrt(sum(V.*V,2));
    V(row,:) = sqrt(1/d);
    intraCost = exp(-V * V');
end