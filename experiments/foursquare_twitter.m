%% run foursquare-twitter
%% set parameters
topK = [1,10,30,50,100];    % HIT@K
rwrIter = 100; % rwr on separated graphs
rwIter = 50;  % rwr on product graph
alpha = 0.5;    % balance rwr and node attributes
beta = 0.15;    % restart probability
gamma = 0.8;    % discounted factor
inIter = 5;     % inner loop iteration
outIter = 10;   % outer loop iteartion
l1 = 1e-3;  % proximal operator, lambda_p
l2 = 5e-3;  % neighborhood, lambda_n
l3 = 5e-4;  % preference, lambda_a
l4 = 3e-6;  % edge, lambda_e

%% Poistion-aware OT
load('foursquare-twitter.mat');
[S, W, res] = parrot(foursquare,twitter,{},{},H,rwrIter,rwIter,alpha,beta,gamma,inIter,outIter,l1,l2,l3,l4);
reshape(S,length(foursquare),[]);
[p, mrr] = get_hits(S,gnd,H',topK);
for i=1:length(topK)
    fprintf('top %d: %.3f\n',topK(i),p(i));
end
fprintf('mrr: %.3f\n',mrr);