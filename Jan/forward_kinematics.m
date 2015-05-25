function pos_end_effector  = forward_kinematics(jAngles)
global D1 D4 D5 A2 A3;

theta_1=jAngles(:,1);
theta_2=jAngles(:,2);
theta_3=jAngles(:,3);
theta_4=jAngles(:,4);
theta_5=jAngles(:,5);
theta_6=jAngles(:,6);
pos_end_effector=1;
%matrix_transformation = jAngles;
%n_x=c6(s1s5 + ((c1c234 ? s1s234)c5)/2.0 + ((c1c234 + s1s234)c5)/2.0) ? (s6((s1c234 + c1s234) ? (s1c234 ? c1 s234 )))/2.0
n_y=0;
n_z=0;
o_x=0;
o_y=0;
o_z=0;
a_x=0;
a_y=0;
a_z=0;
p_x=0;
p_y=0;
p_z=0;

end

