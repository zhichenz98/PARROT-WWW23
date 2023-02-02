%% run cora
%% set parameters
topK = [1,10,30,50,100];    % HIT@K
rwrIter = 100; % rwr on separated graphs
rwIter = 50;  % rwr on product graph
alpha = 0.5;    % balance rwr and node attributes
beta = 0.3;     % restart probability
gamma = 0.2;    % discounted factor
inIter = 5;     % inner loop iteration
outIter = 10;   % outer loop iteartion
l1=2e-3;    % proximal operator, lambda_p
l2=1e-2;    % neighborhood, lambda_n
l3=2e-3;    % preference, lambda_a
l4=1e-6;    % edge, lambda_e

%% Poistion-aware OT
load('cora.mat');
[S, W, res] = parrot(cora1,cora2,cora1_node_feat,cora2_node_feat,H,rwrIter,rwIter,alpha,beta,gamma,inIter,outIter,l1,l2,l3,l4);
reshape(S,length(cora1),[]);
[p, mrr] = get_hits(S,gnd,H',topK);
for i=1:length(topK)
    fprintf('top %d: %.3f\n',topK(i),p(i));
end
fprintf('mrr: %.3f\n',mrr);