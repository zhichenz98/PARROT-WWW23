function [r1, r2] = get_sep_rwr(T1, T2, H, beta, sepRwrIter)
% rwr on separated graphs
% Input:
%   T1: transition matrix for graph 1, shape=n1*n1
%   T2: transition matrix for graph 2, shape=n2*n2
%   H: anchor links, shape=n1*n2
%   beta: restart probability
%   sepRwrIter: maximum number of iterations for RWR calculation
% Output:
%   r1: RWR score for graph 1
%   r2: RWR score for graph 2
    eps = 1e-5;
    [anchor1, anchor2] = find(H');
    n1 = length(T1);
    n2 = length(T2);
    a = length(anchor1);
    %% construct anchor links
    e1 = zeros(n1,a);
    e2 = zeros(n2,a);
    e1(sub2ind([n1,a],anchor1',1:a)) = 1;
    e2(sub2ind([n2,a],anchor2',1:a)) = 1;
    r1 = zeros(n1,a);
    r2 = zeros(n2,a);
    i = 0;
    res = inf;
    while i < sepRwrIter && res > eps
        r1_old = r1;
        r2_old = r2;
        r1 = (1-beta)*T1*r1 + beta*e1;
        r2 = (1-beta)*T2*r2 + beta*e2;
        res = max(max(abs(r1-r1_old),[],"all"), max(abs(r2-r2_old),[],"all"));
        i = i + 1;
    end
end

