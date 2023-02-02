%% run ACM-DBLP (plain)
%% set parameters
topK = [1,10,30,50,100];    % HIT@K
rwrIter = 100; % rwr on separated graphs
rwIter = 50;  % rwr on product graph
alpha = 0.1;    % balance rwr and node attributes
inIter = 5;     % inner loop iteration
outIter = 10;   % outer loop iteartion
beta = 0.5;    % restart probability
gamma = 0.9;   % discounted factor
l1 = 1e-3;  % proximal operator, lambda_p
l2 = 4e-4;  % neighborhood, lambda_n
l3 = 1e-2;  % preference, lambda_a 
l4 = 1e-5;  % edge, lambda_e

%% Poistion-aware OT
load('ACM-DBLP-P.mat');
[S, W, res] = parrot(ACM,DBLP,ACM_node_feat,DBLP_node_feat,H,rwrIter,rwIter,alpha,beta,gamma,inIter,outIter,l1,l2,l3,l4);
reshape(S,length(ACM),[]);
[p, mrr] = get_hits(S,gnd,H',topK);
for i=1:length(topK)
    fprintf('top %d: %.3f\n',topK(i),p(i));
end
fprintf('mrr: %.3f\n',mrr);