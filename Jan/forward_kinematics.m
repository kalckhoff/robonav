function pos_end_effector  = forward_kinematics(jAngles)
global D1 D4 D5 D6 A2 A3;

theta_1=jAngles(:,1); %shoulder pan 
theta_2=jAngles(:,2); %shoulder lift
theta_3=jAngles(:,3); %elbow
theta_4=jAngles(:,4); %wrist 1
theta_5=jAngles(:,5); %wrist 2
theta_6=jAngles(:,6); %wrist 3
%matrix_transformation = jAngles;
n_x=cos(theta_6)*(sin(theta_1)*sin(theta_5) + ((cos(theta_1)*cos(theta_2+theta_3+theta_4) - sin(theta_1)*sin(theta_2+theta_3+theta_4))*cos(theta_5))/2.0 + ((cos(theta_1)*cos(theta_2+theta_3+theta_4) + sin(theta_1)*sin(theta_2+theta_3+theta_4))*cos(theta_5))/2.0) - (sin(theta_6)*((sin(theta_1)*cos(theta_2+theta_3+theta_4) + cos(theta_1)*sin(theta_2+theta_3+theta_4)) - (sin(theta_1)*cos(theta_2+theta_3+theta_4) - cos(theta_1)*sin(theta_2+theta_3+theta_4) )))/2.0;
n_y=cos(theta_6)*(((sin(theta_1)*cos(theta_2+theta_3+theta_4) + cos(theta_1)*sin(theta_2+theta_3+theta_4))*cos(theta_5))/2.0 - cos(theta_1)*sin(theta_5) + ((sin(theta_1)*cos(theta_2+theta_3+theta_4) - cos(theta_1)*sin(theta_2+theta_3+theta_4))*cos(theta_5))/2.0) + sin(theta_6)*((cos(theta_1)*cos(theta_2+theta_3+theta_4) - sin(theta_1)*sin(theta_2+theta_3+theta_4))/2.0 - (cos(theta_1)*cos(theta_2+theta_3+theta_4) + sin(theta_1)*sin(theta_2+theta_3+theta_4) )/2.0);
n_z=(sin(theta_2+theta_3+theta_4)*cos(theta_6) + cos(theta_2+theta_3+theta_4)*sin(theta_6))/2.0 + sin(theta_2+theta_3+theta_4)*cos(theta_5)*cos(theta_6) - (sin(theta_2+theta_3+theta_4)*cos(theta_6) - cos(theta_2+theta_3+theta_4)*sin(theta_6))/2.0;
o_x=-(cos(theta_6)*((sin(theta_1)*cos(theta_2+theta_3+theta_4) + cos(theta_1)*sin(theta_2+theta_3+theta_4)) - (sin(theta_1)*cos(theta_2+theta_3+theta_4) - cos(theta_1)*sin(theta_2+theta_3+theta_4))))/2.0 - sin(theta_6)*(sin(theta_1)*sin(theta_5) + ((cos(theta_1)*cos(theta_2+theta_3+theta_4) - sin(theta_1)*sin(theta_2+theta_3+theta_4))*cos(theta_5))/2.0 + ((cos(theta_1)*cos(theta_2+theta_3+theta_4) + sin(theta_1)*sin(theta_2+theta_3+theta_4))*cos(theta_5))/2.0);
o_y=0;
o_z=0;
a_x=0;
a_y=0;
a_z=0;
p_x= - (D5*(sin(theta_1)*cos(theta_2+theta_3+theta_4) - cos(theta_1)*sin(theta_2+theta_3+theta_4)))/2.0 + (D5*(sin(theta_1)*cos(theta_2+theta_3+theta_4) +cos(theta_1)*sin(theta_2+theta_3+theta_4)))/2.0  + D4*sin(theta_1) -  (D6*(cos(theta_1)*cos(theta_2+theta_3+theta_4) - sin(theta_1)*sin(theta_2+theta_3+theta_4))*sin(theta_5))/2.0 - (D6*(cos(theta_1)*cos(theta_2+theta_3+theta_4) + sin(theta_1)*sin(theta_2+theta_3+theta_4))*sin(theta_5))/2.0 + A2*cos(theta_1)*cos(theta_2) + D6*cos(theta_5)*sin(theta_1) + A3*cos(theta_1)*cos(theta_2)*cos(theta_3) - A3*cos(theta_1)*sin(theta_2)*sin(theta_3);
p_y= - (D5*(cos(theta_1)*cos(theta_2+theta_3+theta_4) - sin(theta_1)*sin(theta_2+theta_3+theta_4)))/2.0 + (D5*(cos(theta_1)*cos(theta_2+theta_3+theta_4) + sin(theta_1)*sin(theta_2+theta_3+theta_4)))/2.0 - D4*cos(theta_1) - (D6*(sin(theta_1)*cos(theta_2+theta_3+theta_4) +cos(theta_1)*sin(theta_2+theta_3+theta_4))*sin(theta_5))/2.0- (D6*(sin(theta_1)*cos(theta_2+theta_3+theta_4) - cos(theta_1)*sin(theta_2+theta_3+theta_4))*sin(theta_5))/2.0 - D6*cos(theta_1)*cos(theta_5) + A2*cos(theta_2)*sin(theta_1) + A3*cos(theta_2)*cos(theta_3)*sin(theta_1) - A3*sin(theta_1)*sin(theta_2)*sin(theta_3);
p_z= D1 + (D6*(cos(theta_2+theta_3+theta_4)*cos(theta_5) - sin(theta_2+theta_3+theta_4)*sin(theta_5)))/2.0 + A3*(sin(theta_2)*cos(theta_3) + cos(theta_2)*sin(theta_3)) + A2*sin(theta_2) - (D6*(cos(theta_2+theta_3+theta_4)*cos(theta_5) + sin(theta_2+theta_3+theta_4)*sin(theta_5)))/2.0 - D5*cos(theta_2+theta_3+theta_4);



% Neue DH-Matrix 


pos_end_effector=[n_x o_x a_x p_x;  n_y o_y a_y p_y; n_z o_z a_z p_z; 0 0 0 1];

end
