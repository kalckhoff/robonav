function matrix_joint = mjoint(n, jAngles)
global A D ALPHA;


for i=1:n
    theta_i=(jAngles(:,i)/180)*pi;
    alpha_i= ALPHA(:,i);
    a_i = A(:,i);
    d_i = D (:,i);
    T_Matrix{i} =[cos(theta_i), -sin(theta_i)*cos(alpha_i), sin(theta_i)*sin(alpha_i), a_i*cos(theta_i);
        sin(theta_i), cos(theta_i)*cos(alpha_i), -cos(theta_i)*sin(alpha_i), a_i*sin(theta_i);
        0, sin(alpha_i), cos(alpha_i), d_i;
        0, 0, 0, 1];
end;

matrix_joint = {T_Matrix{1}, T_Matrix{1}*T_Matrix{2}, T_Matrix{1}*T_Matrix{2}*T_Matrix{3}, T_Matrix{1}*T_Matrix{2}*T_Matrix{3}*T_Matrix{4}, T_Matrix{1}*T_Matrix{2}*T_Matrix{3}*T_Matrix{4}*T_Matrix{5}, T_Matrix{1}*T_Matrix{2}*T_Matrix{3}*T_Matrix{4}*T_Matrix{5}*T_Matrix{6}};

end