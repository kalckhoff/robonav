function pos_end_effector  = forward_kinematics(jAngles)
global D A ALPHA;

% Neue DH-Matrix
AT_Matrix = eye(4,4);

for i=1:6
    theta_i=(jAngles(:,i)/180)*pi;
    alpha_i= ALPHA(:,i);
    a_i = A(:,i);
    d_i = D (:,i);
    T_Matrix=[cos(theta_i), -sin(theta_i)*cos(alpha_i), sin(theta_i)*sin(alpha_i), a_i*cos(theta_i);
        sin(theta_i), cos(theta_i)*cos(alpha_i), -cos(theta_i)*sin(alpha_i), a_i*sin(theta_i);
        0, sin(alpha_i), cos(alpha_i), d_i;
        0, 0, 0, 1];
    AT_Matrix = AT_Matrix*T_Matrix;
    
end;

pos_end_effector=AT_Matrix;

end
