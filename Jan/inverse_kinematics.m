function target_jAngles  = inverse_kinematics(pos_target, pos_end_effector)
global A D ALPHA
%INVERSE_KINEMATICS Summary of this function goes here
%   Detailed explanation goes here

p_x=0;
p_y=0;
y_x=0;
y_y=0;
x_x=0;
x_y=0;
p05_x =0;
p05_y =0;
Rot = eye(3,3);

center = o - D(6)*Rot*[0,0,1];

R=sqrt(pow(p05_x,2)+pow(p05_y,2));
theta = zeros (6,2);
theta (1,1) = atan2(p05_y, p05_x)+ acos(D(4)/R)+PI/2;
theta (1,2) = atan2(p05_y, p05_x)- acos(D(4)/R)+PI/2;
theta (5,1) = + acos((p_x*sin(theta(1,1))-p_y*cos(theta(1,1))-D(4))/D(6));
theta (5,2) = - acos((p_x*sin(theta(1,1))-p_y*cos(theta(1,1))-D(4))/D(6));
theta(6,1)= atan2(((-y_x*sin(theta(1,1)))+(y_y*cos(theta(1,1))))/sin(theta(5,1)),(-(-x_x*sin(theta(1,1))+x_y*cos(theta(1,1)))/sin(theta(5,1)))

end

