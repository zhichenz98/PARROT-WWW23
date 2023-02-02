function [p, mrr] = get_hits(s,gnd,H,topK)
% calculate Hits@K and MRR
% Input:
%   s: alignment score
%   gnd: groundtruth alignment
%   H: anchor nodes
%   topK: top-k (list)
% Output:
%   p: Hits@K
%   mrr: Mean Reciprocal Rank

    [~,I] = sort(s,2,'descend');
    [anchor1, anchor2] = find(H);
    anchors = [anchor1,anchor2];
    tests = setdiff(gnd, anchors, 'rows');
    len = length(tests);
    ind = [];
    mrr = 0;
    for i = 1:len
       tempind = find(I(tests(i,1),:)==tests(i,2));
       ind = [ind;tempind];
       mrr = mrr+1/tempind;
    end
    mrr = mrr / len;
    p = [];
    for i = 1:length(topK)
        p = [p;length(find(ind<=topK(i)))];
    end
    p = p / len;
end