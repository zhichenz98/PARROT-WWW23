function [T, WRecord, resRecord] = cpot(L1,L2,crossC,intraC1,intraC2,inIter,outIter,H,l1,l2,l3,l4)
% cpot: constraint proximal point iteration for optimal transport
% Input:
%   C: cross-graph cost matrix, shape=[n1,n2]
%   C1: intra-graph cost matrixfor graph 1, shape=[n1,n1]
%   C2: intra-graph cost matrixfor graph 2, shape=[n2,n2]
%   inIter: maximum number of inner iteration
%   outIter: maximum number of outer iteration
%   H: preference matrix, shape=[n1,n2]
%   l1: weight for entropy term
%   l2: weight for smoothness term
%   l3: weight for perference term
%   l4: weight for GWD
    [nx,ny] = size(crossC);
    l4 = l4*nx*ny;
    eps = 0;
    %% Define initial matrix values
    a = ones(nx,1)/nx;
    b = ones(1,ny)/ny;
    r = ones(nx,1)/nx;
    c = ones(1,ny)/ny;
    l =l1 + l2 + l3;
    
    T = ones(nx,ny)/(nx*ny);    % inital alignment score
    H = H' + ones(nx,ny)/ny; % prior knowledge, in case of zero

    %% functions for OT
    mina = @(H,epsilon)-epsilon*log(sum(a .* exp(-H/epsilon),1));
    minb = @(H,epsilon)-epsilon*log(sum(b .* exp(-H/epsilon),2));
    minaa = @(H,epsilon)mina(H-min(H,[],1),epsilon) + min(H,[],1);
    minbb = @(H,epsilon)minb(H-min(H,[],2),epsilon) + min(H,[],2);
    temp1 = 0.5*intraC1.^2*r*ones(1,ny) + 0.5*ones(nx,1)*c*(intraC2.^2)'; % const term in GWD
    i = 0;
    res = inf;
    resRecord = [];
    WRecord = [];
    tIpotStart=tic;
    outIter = min(outIter,max(crossC,[],'all')*log(max(nx,ny))*eps^(-3));
    while i < outIter
        T_old = T;
        CGW =  temp1 - intraC1*T*intraC2'; % Frobenius GWD
        C = crossC - l2 * log(L1 * T * L2') - l3 * log(H) + l4 * CGW;   % modified cost
        if i==0
            C_old = C;
        else
            W_old = sum(T.*C_old,'all'); % <C_{t-1}, T_t>
            W = sum(T.*C,'all');    % <C_t,T_t>
            if W <= W_old   % satisfy constraint, new optimization <C_t,T>
                C_old = C;
            else    % violate constraint, original optimization <C_{t-1},T>
                C = C_old;
            end
        end
        Q = C - l1 * log(T);
        for j=1:inIter
            a = minaa(Q-b,l);
            b = minbb(Q-a,l);
        end
        T = 0.05 * T_old + 0.95 * r.* exp((a+b-Q)/l).*c; % soft update
        res = sum(abs(T - T_old),'all');
        resRecord = [resRecord,res];
        WRecord = [WRecord, sum(T.*C,'all')];
        i = i + 1;
    end
    tIpotEnd = toc(tIpotStart);
    fprintf("time for optimization: %.2fs\n",tIpotEnd);
end