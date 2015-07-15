function dh_matrix = dhtransformation(i,j)
global A D ALPHA theta;

dh_matrix = zeros(4,4);

dh_matrix =[cos(theta(i,j)), -sin(theta(i,j))*cos(ALPHA(i)), sin(theta(i,j))*sin(ALPHA(i)), A(i)*cos(theta(i,j));
    sin(theta(i,j)), cos(theta(i,j))*cos(ALPHA(i)), -cos(theta(i,j))*sin(ALPHA(i)), A(i)*sin(theta(i,j));
    0, sin(ALPHA(i)), cos(ALPHA(i)), D(i);
    0, 0, 0, 1];

end