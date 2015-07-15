function [O, C] = pop(O, C, x)

% vector x [f(x), x_i, x_j, x_k, g(x), bp_i, bp_j, bp_k]

i=x(2);
j=x(3);
k=x(4);
[mO,nO]=size(O);

r = find(O(:,2)==i & O(:,3)==j & O(:,4)==k);

if r ~= 0
    r=r(1);
    O=[O(1:r-1,:);O(r+1:mO,:)];
    C=[C;x];
end