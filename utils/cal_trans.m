function [T] = cal_trans(A,V)
% calculate transition probability based on node attributes
% Input:
%   A: adjacency matrix, shape = n*n
%   V: attribute matrix, shape = n*d
% Output:
%   T: transition matrix, shape = n*n
    n = length(A);
    T = A;
    if isempty(V)   % without node attribute
        V = ones(n,1);
    end
    V = V./sqrt(sum(V.*V,2));
    sim = V*V';
    T = sim.*A;
    for row=1:n
        k = find(A(row,:)); % Find the index which value is not 0.
        T(row,k)=softmax(T(row,k).').';
    end
end

