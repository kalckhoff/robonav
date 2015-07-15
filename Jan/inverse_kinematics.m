function target_jAngles  = inverse_kinematics(pos_end_inv, pos_end_effector)
global A D ALPHA R O;
%INVERSE_KINEMATICS Summary of this function goes here
%   Detailed explanation goes here

%%Defining a rotational part and a translational part
%%"orientation/position-decoupling"

endpos = getPositionHomRowWise()

rot = endpos(1:3,1:3)
O = endpos (1:3,4)

%Oc = (O-D(6)*[rot(1,3);rot(2,3);rot(3,3)]);
Oc = (O-D(6)*rot*[0;0;1]);
T_Matrix_06 = endpos;

%%solving position problem

r=sqrt(Oc(1)^2+Oc(2)^2);
theta = zeros (6,8);

%% shoulder left/right
theta (1,1) = atan2(Oc(2), Oc(1))+ acos(D(4)/r)+pi/2;
theta (1,2) = atan2(Oc(2), Oc(1))- acos(D(4)/r)+pi/2;

%%
T_Matrix_01b =[cos(theta(1,2)), -sin(theta(1,2))*cos(ALPHA(1)), sin(theta(1,2))*sin(ALPHA(1)), A(1)*cos(theta(1,2)); 
    sin(theta(1,2)), cos(theta(1,2))*cos(ALPHA(1)), -cos(theta(1,2))*sin(ALPHA(1)), A(1)*sin(theta(1,2));
          0, sin(ALPHA(1)), cos(ALPHA(1)), D(1);
          0, 0, 0, 1];
      
T_Matrix_01a =[cos(theta(1,1)), -sin(theta(1,1))*cos(ALPHA(1)), sin(theta(1,1))*sin(ALPHA(1)), A(1)*cos(theta(1,1)); 
    sin(theta(1,1)), cos(theta(1,1))*cos(ALPHA(1)), -cos(theta(1,1))*sin(ALPHA(1)), A(1)*sin(theta(1,1));
          0, sin(ALPHA(1)), cos(ALPHA(1)), D(1);
          0, 0, 0, 1];      

T_Matrix_10b = inv(T_Matrix_01b);

T_Matrix_10a = inv(T_Matrix_01a);

T_Matrix_61b = inv(T_Matrix_10b*T_Matrix_06);

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
      
T_Matrix_14a = T_Matrix_16a*(inv(T_Matrix_45a*T_Matrix_56a));
T_Matrix_14b = T_Matrix_16a*(inv(T_Matrix_45c*T_Matrix_56b));
T_Matrix_14c = T_Matrix_16b*(inv(T_Matrix_45b*T_Matrix_56c));
T_Matrix_14d = T_Matrix_16b*(inv(T_Matrix_45d*T_Matrix_56d));

P_13a=T_Matrix_14a*[0;-D(4);0;1]-[0;0;0;1];
P_13b=T_Matrix_14b*[0;-D(4);0;1]-[0;0;0;1];
P_13c=T_Matrix_14c*[0;-D(4);0;1]-[0;0;0;1];
P_13d=T_Matrix_14d*[0;-D(4);0;1]-[0;0;0;1];

P_13a_1=[P_13a(1,1);P_13a(2,1)];
P_13b_1=[P_13b(1,1);P_13b(2,1)];
P_13c_1=[P_13c(1,1);P_13c(2,1)];
P_13d_1=[P_13d(1,1);P_13d(2,1)];

theta(3,1) = + acos((((norm(P_13a_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
theta(3,2) = + acos((((norm(P_13b_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
theta(3,3) = + acos((((norm(P_13c_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
theta(3,4) = + acos((((norm(P_13d_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
theta(3,5) = - acos((((norm(P_13a_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
theta(3,6) = - acos((((norm(P_13b_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
theta(3,7) = - acos((((norm(P_13c_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
theta(3,8) = - acos((((norm(P_13d_1))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));


%% ELbow UP/Down 2

theta(2,1) = - atan2((P_13a(2,1)),(-(P_13a(1,1))))+asin((A(3)*sin(theta(3,1)))/(norm(P_13a_1)));
theta(2,2) = - atan2((P_13b(2,1)),(-(P_13b(1,1))))+asin((A(3)*sin(theta(3,2)))/(norm(P_13b_1)));
theta(2,3) = - atan2((P_13c(2,1)),(-(P_13c(1,1))))+asin((A(3)*sin(theta(3,3)))/(norm(P_13c_1)));
theta(2,4) = - atan2((P_13d(2,1)),(-(P_13d(1,1))))+asin((A(3)*sin(theta(3,4)))/(norm(P_13d_1)));
theta(2,5) = - atan2((P_13a(2,1)),(-(P_13a(1,1))))+asin((A(3)*sin(theta(3,5)))/(norm(P_13a_1)));
theta(2,6) = - atan2((P_13b(2,1)),(-(P_13b(1,1))))+asin((A(3)*sin(theta(3,6)))/(norm(P_13b_1)));
theta(2,7) = - atan2((P_13c(2,1)),(-(P_13c(1,1))))+asin((A(3)*sin(theta(3,7)))/(norm(P_13c_1)));
theta(2,8) = - atan2((P_13d(2,1)),(-(P_13d(1,1))))+asin((A(3)*sin(theta(3,8)))/(norm(P_13d_1)));


T_Matrix_12a=[cos(theta(2,1)), -sin(theta(2,1))*cos(ALPHA(2)), sin(theta(2,1))*sin(ALPHA(2)), A(2)*cos(theta(2,1)); 
    sin(theta(2,1)), cos(theta(2,1))*cos(ALPHA(2)), -cos(theta(2,1))*sin(ALPHA(2)), A(2)*sin(theta(2,1));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];
      
T_Matrix_12b =[cos(theta(2,2)), -sin(theta(2,2))*cos(ALPHA(2)), sin(theta(2,2))*sin(ALPHA(2)), A(2)*cos(theta(2,2)); 
    sin(theta(2,2)), cos(theta(2,2))*cos(ALPHA(2)), -cos(theta(2,2))*sin(ALPHA(2)), A(2)*sin(theta(2,2));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];
      
T_Matrix_12c=[cos(theta(2,3)), -sin(theta(2,3))*cos(ALPHA(2)), sin(theta(2,3))*sin(ALPHA(2)), A(2)*cos(theta(2,3)); 
    sin(theta(2,3)), cos(theta(2,3))*cos(ALPHA(2)), -cos(theta(2,3))*sin(ALPHA(2)), A(2)*sin(theta(2,3));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];

T_Matrix_12d=[cos(theta(2,4)), -sin(theta(2,4))*cos(ALPHA(2)), sin(theta(2,4))*sin(ALPHA(2)), A(2)*cos(theta(2,4)); 
    sin(theta(2,4)), cos(theta(2,4))*cos(ALPHA(2)), -cos(theta(2,4))*sin(ALPHA(2)), A(2)*sin(theta(2,4));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];
     
 T_Matrix_12e=[cos(theta(2,5)), -sin(theta(2,5))*cos(ALPHA(2)), sin(theta(2,5))*sin(ALPHA(2)), A(2)*cos(theta(2,5)); 
    sin(theta(2,5)), cos(theta(2,5))*cos(ALPHA(2)), -cos(theta(2,5))*sin(ALPHA(2)), A(2)*sin(theta(2,5));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];
      
T_Matrix_12f=[cos(theta(2,6)), -sin(theta(2,6))*cos(ALPHA(2)), sin(theta(2,6))*sin(ALPHA(2)), A(2)*cos(theta(2,6)); 
    sin(theta(2,6)), cos(theta(2,6))*cos(ALPHA(2)), -cos(theta(2,6))*sin(ALPHA(2)), A(2)*sin(theta(2,6));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];   

T_Matrix_12g=[cos(theta(2,7)), -sin(theta(2,7))*cos(ALPHA(2)), sin(theta(2,7))*sin(ALPHA(2)), A(2)*cos(theta(2,7)); 
    sin(theta(2,7)), cos(theta(2,7))*cos(ALPHA(2)), -cos(theta(2,7))*sin(ALPHA(2)), A(2)*sin(theta(2,7));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];
      
T_Matrix_12h=[cos(theta(2,8)), -sin(theta(2,8))*cos(ALPHA(2)), sin(theta(2,8))*sin(ALPHA(2)), A(2)*cos(theta(2,8)); 
    sin(theta(2,8)), cos(theta(2,8))*cos(ALPHA(2)), -cos(theta(2,8))*sin(ALPHA(2)), A(2)*sin(theta(2,8));
          0, sin(ALPHA(2)), cos(ALPHA(2)), D(2);
          0, 0, 0, 1];      
      
T_Matrix_23a =[cos(theta(3,1)), -sin(theta(3,1))*cos(ALPHA(3)), sin(theta(3,1))*sin(ALPHA(3)), A(3)*cos(theta(3,1)); 
    sin(theta(3,1)), cos(theta(3,1))*cos(ALPHA(3)), -cos(theta(3,1))*sin(ALPHA(3)), A(3)*sin(theta(3,1));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];
      
T_Matrix_23b =[cos(theta(3,2)), -sin(theta(3,2))*cos(ALPHA(3)), sin(theta(3,2))*sin(ALPHA(3)), A(3)*cos(theta(3,2)); 
    sin(theta(3,2)), cos(theta(3,2))*cos(ALPHA(3)), -cos(theta(3,2))*sin(ALPHA(3)), A(3)*sin(theta(3,2));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];
      
T_Matrix_23c =[cos(theta(3,3)), -sin(theta(3,3))*cos(ALPHA(3)), sin(theta(3,3))*sin(ALPHA(3)), A(3)*cos(theta(3,3)); 
    sin(theta(3,3)), cos(theta(3,3))*cos(ALPHA(3)), -cos(theta(3,3))*sin(ALPHA(3)), A(3)*sin(theta(3,3));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];

T_Matrix_23d =[cos(theta(3,4)), -sin(theta(3,4))*cos(ALPHA(3)), sin(theta(3,4))*sin(ALPHA(3)), A(3)*cos(theta(3,4)); 
    sin(theta(3,4)), cos(theta(3,4))*cos(ALPHA(3)), -cos(theta(3,4))*sin(ALPHA(3)), A(3)*sin(theta(3,4));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];
      
T_Matrix_23e=[cos(theta(3,5)), -sin(theta(3,5))*cos(ALPHA(3)), sin(theta(3,5))*sin(ALPHA(3)), A(3)*cos(theta(3,5)); 
    sin(theta(3,5)), cos(theta(3,5))*cos(ALPHA(3)), -cos(theta(3,5))*sin(ALPHA(3)), A(3)*sin(theta(3,5));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];
      
T_Matrix_23f=[cos(theta(3,6)), -sin(theta(3,6))*cos(ALPHA(3)), sin(theta(3,6))*sin(ALPHA(3)), A(3)*cos(theta(3,6)); 
    sin(theta(3,6)), cos(theta(3,6))*cos(ALPHA(3)), -cos(theta(3,6))*sin(ALPHA(3)), A(3)*sin(theta(3,6));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];
      
T_Matrix_23g=[cos(theta(3,7)), -sin(theta(3,7))*cos(ALPHA(3)), sin(theta(3,7))*sin(ALPHA(3)), A(3)*cos(theta(3,7)); 
    sin(theta(3,7)), cos(theta(3,7))*cos(ALPHA(3)), -cos(theta(3,7))*sin(ALPHA(3)), A(3)*sin(theta(3,7));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];
      
T_Matrix_23h=[cos(theta(3,8)), -sin(theta(3,8))*cos(ALPHA(3)), sin(theta(3,8))*sin(ALPHA(3)), A(3)*cos(theta(3,8)); 
    sin(theta(3,8)), cos(theta(3,8))*cos(ALPHA(3)), -cos(theta(3,8))*sin(ALPHA(3)), A(3)*sin(theta(3,8));
          0, sin(ALPHA(3)), cos(ALPHA(3)), D(3);
          0, 0, 0, 1];
      
T_Matrix_34a = (inv(T_Matrix_12a*T_Matrix_23a))*T_Matrix_14a;
T_Matrix_34b = (inv(T_Matrix_12b*T_Matrix_23b))*T_Matrix_14b;
T_Matrix_34c = (inv(T_Matrix_12c*T_Matrix_23c))*T_Matrix_14c;
T_Matrix_34d = (inv(T_Matrix_12d*T_Matrix_23d))*T_Matrix_14d;
T_Matrix_34e = (inv(T_Matrix_12e*T_Matrix_23e))*T_Matrix_14a;
T_Matrix_34f = (inv(T_Matrix_12f*T_Matrix_23f))*T_Matrix_14b;
T_Matrix_34g = (inv(T_Matrix_12g*T_Matrix_23g))*T_Matrix_14c;
T_Matrix_34h = (inv(T_Matrix_12h*T_Matrix_23h))*T_Matrix_14d;


theta(4,1) = atan2(T_Matrix_34a(2,1),T_Matrix_34a(1,1));
theta(4,2) = atan2(T_Matrix_34b(2,1),T_Matrix_34b(1,1));
theta(4,3) = atan2(T_Matrix_34c(2,1),T_Matrix_34c(1,1));
theta(4,4) = atan2(T_Matrix_34d(2,1),T_Matrix_34d(1,1));
theta(4,5) = atan2(T_Matrix_34e(2,1),T_Matrix_34e(1,1));
theta(4,6) = atan2(T_Matrix_34f(2,1),T_Matrix_34f(1,1));
theta(4,7) = atan2(T_Matrix_34g(2,1),T_Matrix_34g(1,1));
theta(4,8) = atan2(T_Matrix_34h(2,1),T_Matrix_34h(1,1));

theta()*180/pi

end
