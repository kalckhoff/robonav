function c = eval_c(x1, x2)

if abs(x2(3)-x1(3)) > 1
    c=sqrt(abs(x2(1)-x1(1))+abs(x2(2)-x1(2))+1);
else
    c=sqrt(abs(x2(1)-x1(1))+abs(x2(2)-x1(2))+abs(x2(3)-x1(3)));
end