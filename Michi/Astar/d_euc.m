function d = d_euc(X, Y, k_max)

d=0;

d1=sqrt((X(1)-Y(1))^2+(X(2)-Y(2))^2+(X(3)-Y(3))^2);

if Y(3) < X(3)
    d2=sqrt((X(1)-Y(1))^2+(X(2)-Y(2))^2+(k_max-X(3)+Y(3))^2);
else
    d2=sqrt((X(1)-Y(1))^2+(X(2)-Y(2))^2+(k_max+X(3)-Y(3))^2);
end
d=min([d1,d2]);




