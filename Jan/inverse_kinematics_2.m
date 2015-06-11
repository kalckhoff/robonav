function target_jAngles  = inverse_kinematics_2(pos_end_inv, pos_end_effector)
global A D ALPHA R O;
%INVERSE_KINEMATICS Summary of this function goes here
%   Detailed explanation goes here

%%Defining a rotational part and a translational part
%%"orientation/psoition-decoupling"

% T61 = pos_end_inv;
% T61(2,1)

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

%Oc = (O-D(6)*[rot(1,3);rot(2,3);rot(3,3)]);
Oc = (O-D(6)*rot*[0;]);

T_Matrix_06 = [rot(1,1), rot(1,2), rot(1,3), O(1,1); rot(2,1), rot(2,2), rot(2,3), O(2,1); rot(3,1), rot(3,2), rot(3,3), O(3,1); 0, 0, 0, 1 ];

%%solving position problem

%r=sqrt(pow(Oc(1),2)+pow(Oc(2),2));
r=sqrt(Oc(1)^2+Oc(2)^2);
theta = zeros (6,8);

%% shoulder left/right
theta (1,1) = atan2(Oc(2), Oc(1))+ acos(D(4)/r)+pi/2;
theta (1,2) = atan2(Oc(2), Oc(1))- acos(D(4)/r)+pi/2;

T_Matrix_01b=[cos(theta(1,2)), -sin(theta(1,2))*cos(ALPHA(1)), sin(theta(1,2))*sin(ALPHA(1)), A(1)*cos(theta(1,2)); 
    sin(theta(1,2)), cos(theta(1,2))*cos(ALPHA(1)), -cos(theta(1,2))*sin(ALPHA(1)), A(1)*sin(theta(1,2));
          0, sin(ALPHA(1)), cos(ALPHA(1)), D(1);
          0, 0, 0, 1];
      
T_Matrix_01a=[cos(theta(1,1)), -sin(theta(1,1))*cos(ALPHA(1)), sin(theta(1,1))*sin(ALPHA(1)), A(1)*cos(theta(1,1)); 
    sin(theta(1,1)), cos(theta(1,1))*cos(ALPHA(1)), -cos(theta(1,1))*sin(ALPHA(1)), A(1)*sin(theta(1,1));
          0, sin(ALPHA(1)), cos(ALPHA(1)), D(1);
          0, 0, 0, 1];      

T_Matrix_10b = inv(T_Matrix_01b);

T_Matrix_61b = inv(T_Matrix_10b*T_Matrix_06);

T_Matrix_10a = inv(T_Matrix_01a);

T_Matrix_61a = inv(T_Matrix_10a*T_Matrix_06);

T_Matrix_16a = inv(T_Matrix_61a);

T_Matrix_16b = inv(T_Matrix_61b);

theta(5,1) = acos((O(1)*sin(theta(1,1))-O(2)*cos(theta(1,1))-D(4))/D(6));
theta(5,2) = acos((O(1)*sin(theta(1,2))-O(2)*cos(theta(1,2))-D(4))/D(6));
theta(5,3) = -acos((O(1)*sin(theta(1,1))-O(2)*cos(theta(1,1))-D(4))/D(6));
theta(5,4) = -acos((O(1)*sin(theta(1,2))-O(2)*cos(theta(1,2))-D(4))/D(6));

theta(6,1) = atan2((-T_Matrix_61a(2,3)/sin(theta(5,1))), (T_Matrix_61a(1,3)/sin(theta(5,1))));
theta(6,2) = atan2((-T_Matrix_61a(2,3)/sin(theta(5,2))), (T_Matrix_61a(1,3)/sin(theta(5,2))));
theta(6,3) = atan2((-T_Matrix_61a(2,3)/sin(theta(5,3))), (T_Matrix_61a(1,3)/sin(theta(5,3))));
theta(6,4) = atan2((-T_Matrix_61a(2,3)/sin(theta(5,4))), (T_Matrix_61a(1,3)/sin(theta(5,4))));
theta(6,5) = atan2((-T_Matrix_61b(2,3)/sin(theta(5,1))), (T_Matrix_61b(1,3)/sin(theta(5,1))));
theta(6,6) = atan2((-T_Matrix_61b(2,3)/sin(theta(5,2))), (T_Matrix_61b(1,3)/sin(theta(5,2))));
theta(6,7) = atan2((-T_Matrix_61b(2,3)/sin(theta(5,3))), (T_Matrix_61b(1,3)/sin(theta(5,3))));
theta(6,8) = atan2((-T_Matrix_61b(2,3)/sin(theta(5,4))), (T_Matrix_61b(1,3)/sin(theta(5,4))));


%theta(6,5) = (-174.96/180)*pi;
%theta(6,7) = (-174.96/180)*pi;



%% Elbow Up/Down

T_Matrix_45a =[cos(theta(5,1)), -sin(theta(5,1))*cos(ALPHA(5)), sin(theta(5,1))*sin(ALPHA(5)), A(5)*cos(theta(5,1)); 
    sin(theta(5,1)), cos(theta(5,1))*cos(ALPHA(5)), -cos(theta(5,1))*sin(ALPHA(5)), A(5)*sin(theta(5,1));
          0, sin(ALPHA(5)), cos(ALPHA(5)), D(5);
          0, 0, 0, 1];
      
T_Matrix_45b =[cos(theta(5,2)), -sin(theta(5,2))*cos(ALPHA(5)), sin(theta(5,2))*sin(ALPHA(5)), A(5)*cos(theta(5,2)); 
    sin(theta(5,2)), cos(theta(5,2))*cos(ALPHA(5)), -cos(theta(5,2))*sin(ALPHA(5)), A(5)*sin(theta(5,2));
          0, sin(ALPHA(5)), cos(ALPHA(5)), D(5);
          0, 0, 0, 1];   
      
T_Matrix_45c =[cos(theta(5,3)), -sin(theta(5,3))*cos(ALPHA(5)), sin(theta(5,3))*sin(ALPHA(5)), A(5)*cos(theta(5,3)); 
    sin(theta(5,3)), cos(theta(5,3))*cos(ALPHA(5)), -cos(theta(5,3))*sin(ALPHA(5)), A(5)*sin(theta(5,3));
          0, sin(ALPHA(5)), cos(ALPHA(5)), D(5);
          0, 0, 0, 1];
      
T_Matrix_45d =[cos(theta(5,4)), -sin(theta(5,4))*cos(ALPHA(5)), sin(theta(5,4))*sin(ALPHA(5)), A(5)*cos(theta(5,4)); 
    sin(theta(5,4)), cos(theta(5,4))*cos(ALPHA(5)), -cos(theta(5,4))*sin(ALPHA(5)), A(5)*sin(theta(5,4));
          0, sin(ALPHA(5)), cos(ALPHA(5)), D(5);
          0, 0, 0, 1];            

T_Matrix_56a =[cos(theta(6,1)), -sin(theta(6,1))*cos(ALPHA(6)), sin(theta(6,1))*sin(ALPHA(6)), A(6)*cos(theta(6,1)); 
    sin(theta(6,1)), cos(theta(6,1))*cos(ALPHA(6)), -cos(theta(6,1))*sin(ALPHA(6)), A(6)*sin(theta(6,1));
          0, sin(ALPHA(6)), cos(ALPHA(6)), D(6);
          0, 0, 0, 1];
      
T_Matrix_56b =[cos(theta(6,3)), -sin(theta(6,3))*cos(ALPHA(6)), sin(theta(6,3))*sin(ALPHA(6)), A(6)*cos(theta(6,3)); 
    sin(theta(6,3)), cos(theta(6,3))*cos(ALPHA(6)), -cos(theta(6,3))*sin(ALPHA(6)), A(6)*sin(theta(6,3));
          0, sin(ALPHA(6)), cos(ALPHA(6)), D(6);
          0, 0, 0, 1];   
      
T_Matrix_56c =[cos(theta(6,5)), -sin(theta(6,5))*cos(ALPHA(6)), sin(theta(6,5))*sin(ALPHA(6)), A(6)*cos(theta(6,5)); 
    sin(theta(6,5)), cos(theta(6,5))*cos(ALPHA(6)), -cos(theta(6,5))*sin(ALPHA(6)), A(6)*sin(theta(6,5));
          0, sin(ALPHA(6)), cos(ALPHA(6)), D(6);
          0, 0, 0, 1];   
      
T_Matrix_56d =[cos(theta(6,7)), -sin(theta(6,7))*cos(ALPHA(6)), sin(theta(6,7))*sin(ALPHA(6)), A(6)*cos(theta(6,7)); 
    sin(theta(6,7)), cos(theta(6,7))*cos(ALPHA(6)), -cos(theta(6,7))*sin(ALPHA(6)), A(6)*sin(theta(6,7));
          0, sin(ALPHA(6)), cos(ALPHA(6)), D(6);
          0, 0, 0, 1];   
      
T_Matrix_14a = T_Matrix_16a*inv(T_Matrix_45a*T_Matrix_56a);
T_Matrix_14b = T_Matrix_16a*inv(T_Matrix_45b*T_Matrix_56b);
T_Matrix_14c = T_Matrix_16b*inv(T_Matrix_45c*T_Matrix_56c);
T_Matrix_14d = T_Matrix_16b*inv(T_Matrix_45d*T_Matrix_56d);

P_13a=T_Matrix_14a*[0;-D(4);0;1]-[0;0;0;1]
P_13b=T_Matrix_14b*[0;-D(4);0;1]-[0;0;0;1]
P_13c=T_Matrix_14c*[0;-D(4);0;1]-[0;0;0;1]
P_13d=T_Matrix_14d*[0;-D(4);0;1]-[0;0;0;1]

P_13a_1= [P_13a(1,1);P_13a(2,1)]
P_13b_1=[P_13b(1,1);P_13b(2,1)]
P_13c_1=[P_13c(1,1);P_13c(2,1)]
P_13d_1=[P_13d(1,1);P_13d(2,1)]

theta(3,1)=+acos((((norm(P_13a_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));
theta(3,2)=+acos((((norm(P_13b_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));
theta(3,3)=+acos((((norm(P_13c_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));
theta(3,4)=+acos((((norm(P_13d_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));
theta(3,5)=-acos((((norm(P_13a_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));
theta(3,6)=-acos((((norm(P_13b_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));
theta(3,7)=-acos((((norm(P_13c_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));
theta(3,8)=-acos((((norm(P_13d_1)).^2)-(A(2).^2)-(A(3).^2))/(2*(A(2))*(A(3))));

%% ELbow UP/Down 2



%Elbow up/down
% theta (3,1) = acos((P13^2-A(2)^2-A(3)^2)/A(2)*A(3));
% theta (3,2) = -acos((P13^2-A(2)^2-A(3)^2)/A(2)*A(3));
% 
% theta (2,1) = -atan2(P13y,-P13x)+ asin((A(3)*sin(theta(3,1)))/P13);
% theta (2,2) = -atan2(P13y,-P13x)+ asin((A(3)*sin(theta(3,2)))/P13);

% theta (4,1) = atan2(T34_xy, T34_xx);

%%solving orientation problem




theta()*180/pi





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
