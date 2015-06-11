function target_jAngles  = inverse_kinematics(pos_target, pos_end_effector)
global A D ALPHA R O ;
%INVERSE_KINEMATICS Summary of this function goes here
%   Detailed explanation goes here

rot = zeros(3,3);

rot(1,1) = cos(R(2))*cos(R(3));
rot(1,2) = -cos(R(1))*sin(R(3)) + sin(R(1))*sin(R(2))*cos(R(3));
rot(1,3) = sin(R(1))*sin(R(3)) + cos(R(1))*sin(R(2))*cos(R(3));

rot(2,1) = cos(R(2))*sin(R(3));
rot(2,2) = cos(R(1))*cos(R(3)) + sin(R(1))*sin(R(2))*sin(R(3));
rot(2,3) = -sin(R(1))*cos(R(3)) + cos(R(1))*sin(R(2))*sin(R(3));

rot(3,1) = -sin(R(2));
rot(3,2) = sin(R(1))*cos(R(2));
rot(3,3) = cos(R(1))*cos(R(2));

Oc = (O-D(6)*[rot(1,3);rot(2,3);rot(3,3)])

%r=sqrt(pow(Oc(1),2)+pow(Oc(2),2));
r=sqrt(Oc(1)^2+Oc(2)^2);
theta = zeros (6,2);
theta (1,1) = atan2(Oc(2), Oc(1))+ acos(D(4)/r)+pi/2;
theta (1,2) = atan2(Oc(2), Oc(1))- acos(D(4)/r)+pi/2;

theta(1,1)*180/pi
theta(1,2)*180/pi

theta(5,1) = acos((O(1)*sin(theta(1,1))-O(2)*cos(theta(1,1))-D(4))/D(6));
theta(5,2) = acos((O(1)*sin(theta(1,2))-O(2)*cos(theta(1,2))-D(4))/D(6));
theta(5,3) = -acos((O(1)*sin(theta(1,1))-O(2)*cos(theta(1,1))-D(4))/D(6));
theta(5,4) = -acos((O(1)*sin(theta(1,2))-O(2)*cos(theta(1,2))-D(4))/D(6));

theta(5,1)*180/pi
theta(5,2)*180/pi

theta(5,3)*180/pi
theta(5,4)*180/pi


theta(6,1) = atan2((rot(1,2)*sin(theta(1,1))+rot(2,2)*cos(theta(1,1)))/sin(theta(5,1)),-(-rot(1,1)*sin(theta(1,1))+rot(2,1)*cos(theta(1,1)))/sin(theta(5,1)));
theta(6,2) = atan2((rot(1,2)*sin(theta(1,2))+rot(2,2)*cos(theta(1,2)))/sin(theta(5,1)),-(-rot(1,1)*sin(theta(1,2))+rot(2,1)*cos(theta(1,2)))/sin(theta(5,1)));
theta(6,3) = atan2((rot(1,2)*sin(theta(1,2))+rot(2,2)*cos(theta(1,2)))/sin(theta(5,2)),-(-rot(1,1)*sin(theta(1,2))+rot(2,1)*cos(theta(1,2)))/sin(theta(5,2)));
theta(6,4) = atan2((rot(1,2)*sin(theta(1,1))+rot(2,2)*cos(theta(1,1)))/sin(theta(5,2)),-(-rot(1,1)*sin(theta(1,1))+rot(2,1)*cos(theta(1,1)))/sin(theta(5,2)));
theta(6,5) = atan2((rot(1,2)*sin(theta(1,1))+rot(2,2)*cos(theta(1,1)))/sin(theta(5,3)),-(-rot(1,1)*sin(theta(1,1))+rot(2,1)*cos(theta(1,1)))/sin(theta(5,3)));
theta(6,6) = atan2((rot(1,2)*sin(theta(1,1))+rot(2,2)*cos(theta(1,1)))/sin(theta(5,4)),-(-rot(1,1)*sin(theta(1,1))+rot(2,1)*cos(theta(1,1)))/sin(theta(5,4)));
theta(6,7) = atan2((rot(1,2)*sin(theta(1,2))+rot(2,2)*cos(theta(1,2)))/sin(theta(5,3)),-(-rot(1,1)*sin(theta(1,2))+rot(2,1)*cos(theta(1,2)))/sin(theta(5,3)));
theta(6,8) = atan2((rot(1,2)*sin(theta(1,2))+rot(2,2)*cos(theta(1,2)))/sin(theta(5,4)),-(-rot(1,1)*sin(theta(1,2))+rot(2,1)*cos(theta(1,2)))/sin(theta(5,4)));

for i=1:8
    theta(6,i)*180/pi
end









% p_x=0;
% p_y=0;
% y_x=0;
% y_y=0;
% x_x=0;
% x_y=0;
% p05_x =0;
% p05_y =0;
% Rot = eye(3,3);
% 
% center = o - D(6)*Rot*[0,0,1];
% 
% r=sqrt(pow(p05_x,2)+pow(p05_y,2));
% theta = zeros (6,2);
% theta (1,1) = atan2(p05_y, p05_x)+ acos(D(4)/r)+PI/2;
% theta (1,2) = atan2(p05_y, p05_x)- acos(D(4)/r)+PI/2;
% theta (5,1) = + acos((p_x*sin(theta(1,1))-p_y*cos(theta(1,1))-D(4))/D(6));
% theta (5,2) = - acos((p_x*sin(theta(1,1))-p_y*cos(theta(1,1))-D(4))/D(6));
% theta(6,1)= atan2(((-y_x*sin(theta(1,1)))+(y_y*cos(theta(1,1))))/sin(theta(5,1)),(-(-x_x*sin(theta(1,1))+x_y*cos(theta(1,1)))/sin(theta(5,1)))

end