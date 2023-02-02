%% run phone-email
%% set parameters
topK = [1,10,30,50,100];    % HIT@K
sepRwrIter = 100; % rwr on separated graphs
prodRwrIter = 50;  % rwr on product graph
alpha = 0.5;    % balance rwr and node attributes
beta = 0.15;    % restart probability
gamma = 0.7;    % discounted factor
inIter = 5;     % inner loop iteration
outIter = 10;   % outer loop iteartion
l1 = 5e-4;    % update step penalty weight
l2 = 5e-3;    % smoothness penalty
l3 = 5e-4;    % prior penalty
l4 = 2e-5;    % balancing GWD & WD

%% Poistion-aware OT
load('phone-email.mat');
[n1,n2] = size(H);
[S, W, res] = parrot(sparse(phone),sparse(email),{},{},H,sepRwrIter,prodRwrIter,alpha,beta,gamma,inIter,outIter,l1,l2,l3,l4);
reshape(S,length(phone),[]);
[p, mrr] = get_hits(S,gnd,H',topK);
for i=1:length(topK)
    fprintf('top %d: %.3f\n',topK(i),p(i));
end
fprintf('mrr: %.3f\n',mrr);