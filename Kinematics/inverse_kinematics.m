function target_joints_angles  = inverse_kinematics(endpos)
global A D ALPHA theta;
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
theta (1,2) = theta (1,1);
theta (1,3) = theta (1,1);
theta (1,4) = theta (1,1);
theta (1,5) = atan2(Oc(2), Oc(1))- acos(D(4)/r)+pi/2;
theta (1,6) = theta (1,5);
theta (1,7) = theta (1,5);
theta (1,8) = theta (1,5);

n = [1 5];
for i=1:2
    j = n(i);
    T_Matrix_01{i} = dhtransformation(1,j);
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

k = [1 5];
for i=1:2
    l = k(i);
    theta(5,l) = acos((O(1)*sin(theta(1,l))-O(2)*cos(theta(1,l))-D(4))/D(6));
    theta(5,l+1) = theta (5,l);
end

n = [3 7];
k = [1 5];
for i=1:2
    j = n(i);
    l = k(i);
    theta(5,j) = -acos((O(1)*sin(theta(1,l))-O(2)*cos(theta(1,l))-D(4))/D(6));
    theta(5,j+1) = theta (5,j);
end


% Theta 6
for i=1:4
    n=1;
    theta(6,i) = atan2((-T_Matrix_61{n}(2,3)/sin(theta(5,i))), (T_Matrix_61{1}(1,3)/sin(theta(5,i))));
end    
g = [5 6 7 8];
for i=1:4
    n=2;
    h = g(i);
    theta(6,h) = atan2((-T_Matrix_61{n}(2,3)/sin(theta(5,h))), (T_Matrix_61{n}(1,3)/sin(theta(5,h)))); 
end

%% Solving Position Problem

% Transformation45 and Transformation56

for i=1:8
    T_Matrix_45{i} = dhtransformation(5,i);
end
for i=1:8
    T_Matrix_56{i} = dhtransformation(6,i);
end

% Transformation14

for i=1:4
        n = 1;
        T_Matrix_14{i} = T_Matrix_16{n}*(inv(T_Matrix_45{i}*T_Matrix_56{i}));
end
for i=5:8
        n = 2;
        T_Matrix_14{i} = T_Matrix_16{n}*(inv(T_Matrix_45{i}*T_Matrix_56{i}));
end

% Vektor to Joint 3

for i=1:8
    P_13{i} = T_Matrix_14{i}*[0;-D(4);0;1]-[0;0;0;1];
end

for i=1:8
    P_13xy{i}=[P_13{i}(1,1);P_13{i}(2,1)];
end

% Theta 3


n = [1 3 5 7];
for i=1:4
    j = n(i);
    theta(3,j) = + acos((((norm(P_13xy{j}))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
    check = isreal(theta(3,j));
        if check == 0
            theta(3,j) = 0;
        end
end
n = [2 4 6 8];
for i=1:4
    j = n(i);
    theta(3,j) = - acos((((norm(P_13xy{j}))^2)-(A(2)^2)-(A(3)^2))/(2*(A(2))*(A(3))));
    check = isreal(theta(3,j));
        if check == 0
            theta(3,j) = 0;
        end
end

% Theta 2
n = [1 3 5 7];
for i=1:4
    j = n(i);
    theta(2,j) = - atan2((P_13{j}(2,1)),(-(P_13{j}(1,1))))+asin((A(3)*sin(theta(3,j)))/(norm(P_13xy{j})));
    check = isreal(theta(2,j));
        if check == 0
            theta(2,j) = 0;
        end
end
n = [2 4 6 8];
for i=1:4
    j = n(i);
    theta(2,j) = - atan2((P_13{j}(2,1)),(-(P_13{j}(1,1))))+asin((A(3)*sin(theta(3,j)))/(norm(P_13xy{j})));
    check = isreal(theta(2,j));
        if check == 0
            theta(2,j) = 0;
        end
end

%% Solving last part of wrist-orientation

for i=1:8
    T_Matrix_12{i} = dhtransformation(2,i);
end

for i=1:8
    T_Matrix_23{i} = dhtransformation(3,i);
end


for i = 1:8
    T_Matrix_34{i} = (inv(T_Matrix_12{i}*T_Matrix_23{i}))*T_Matrix_14{i};
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
