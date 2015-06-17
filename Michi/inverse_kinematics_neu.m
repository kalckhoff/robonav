function target_joints_angles  = inverse_kinematics(pos_end_effector)
global A D ALPHA endpos theta;
%INVERSE_KINEMATICS Summary of this function goes here
%Detailed explanation goes here

%%Defining a rotational part and a translational part
%%"orientation/position-decoupling"

rot = endpos(1:3,1:3)
O = endpos (1:3,4)

% joint5 position
Oc = (O-D(6)*rot*[0;0;1]);
T_Matrix_06 = endpos;

%% Solving first part of orientation problem

r=sqrt(Oc(1)^2+Oc(2)^2);
theta = zeros (6,8);

% Theta 1
theta (1,1) = atan2(Oc(2), Oc(1))+ acos(D(4)/r)+pi/2;
theta (1,2) = atan2(Oc(2), Oc(1))- acos(D(4)/r)+pi/2;

for i=1:2
    T_Matrix_01{i} = dhtransformation(1,i);
end

for i=1:2
    T_Matrix_10{i} = inv(T_Matrix_01{i});
end

for i=1:2
    T_Matrix_61{i} = inv(T_Matrix_10{i}*T_Matrix_06);
end

for i=1:2
    T_Matrix_16{i} = inv(T_Matrix_61{i});
end

% Theta 5

for i=1:2:3
    n=1;
    theta(5,i) = acos((O(1)*sin(theta(1,n))-O(2)*cos(theta(1,n))-D(4))/D(6));
end
for i=2:2:4
    n=2;
    theta(5,i) = -acos((O(1)*sin(theta(1,n))-O(2)*cos(theta(1,n))-D(4))/D(6));
end

% Theta 6

for i=1:4
    n=1;
    theta(6,i) = atan2((-T_Matrix_61{n}(2,3)/sin(theta(5,i))), (T_Matrix_61{1}(1,3)/sin(theta(5,i))));
end    
j = 1;
for i=5:8
    n=2;
    theta(6,i) = atan2((-T_Matrix_61{n}(2,3)/sin(theta(5,j))), (T_Matrix_61{n}(1,3)/sin(theta(5,j))));
    j=j+1;
end

%% Solving Position Problem

% Transformation45 and Transformation56

for i=1:4
    T_Matrix_45{i} = dhtransformation(5,i);
end

n = [1 2 5 6];
for i=1:4
    for j = n(i)
    T_Matrix_56{i} = dhtransformation(6,j);    
    end
end

% Transformation14

for i=1:2
        n = 1;
        T_Matrix_14{i} = T_Matrix_16{n}*(inv(T_Matrix_45{i}*T_Matrix_56{i}));
end
for i=3:4
        n = 2;
        T_Matrix_14{i} = T_Matrix_16{n}*(inv(T_Matrix_45{i}*T_Matrix_56{i}));
end

% Vektor to Joint 3

for i=1:4
    P_13{i} = T_Matrix_14{i}*[0;-D(4);0;1]-[0;0;0;1];
end

for i=1:4
    P_13xy{i}=[P_13{i}(1,1);P_13{i}(2,1)];
end

% Theta 3

for i=1:4
    theta(3,i) = + acos((((norm(P_13xy{i}))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
    check = isreal(theta(3,i));
        if check == 0
            theta(3,i) = 0;
        end
end
n = 1;
for i=5:8
    theta(3,i) = - acos((((norm(P_13xy{n}))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
    n = n+1;
    check = isreal(theta(3,i));
        if check == 0
            theta(3,i) = 0;
        end
end

% Theta 2
for i=1:4
    theta(2,i) = - atan2((P_13{i}(2,1)),(-(P_13{i}(1,1))))+asin((A(3)*sin(theta(3,i)))/(norm(P_13xy{i})));
    check = isreal(theta(2,i));
        if check == 0
            theta(2,i) = 0;
        end
end
n = 1;
for i=5:8
    theta(2,i) = - atan2((P_13{n}(2,1)),(-(P_13{n}(1,1))))+asin((A(3)*sin(theta(3,i)))/(norm(P_13xy{n})));
    n=n+1;
    check = isreal(theta(2,i));
        if check == 0
            theta(2,i) = 0;
        end
end

%% Solving last part of wrist-orientation

for i=1:8
    T_Matrix_12{i} = dhtransformation(2,i);
end

for i=1:8
    T_Matrix_23{i} = dhtransformation(3,i);
end

for i=1:4
    T_Matrix_34{i} = (inv(T_Matrix_12{i}*T_Matrix_23{i}))*T_Matrix_14{i};
end
n = 1;
for i=5:8
    T_Matrix_34{i} = (inv(T_Matrix_12{i}*T_Matrix_23{i}))*T_Matrix_14{n};
    n=n+1;
end

% Theta 4

for i=1:8
    theta(4,i) = atan2(T_Matrix_34{i}(2,1),T_Matrix_34{i}(1,1));
    check = isreal(theta(4,i));
        if check == 0
            theta(4,i) = 0;
        end
end

target_joints_angles = theta()*180/pi

end
