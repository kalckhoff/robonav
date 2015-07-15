function T_tiptomarker = toolcalib()

load('camHTMs.mat');
T = camHTMs;
num = 50;


for i = 1:num
    rotT = T(1:3,1:3,i);
    transT = T(1:3,4,i);
    
    Ai = [-eye(3), rotT];
    
    bi = [-transT];
    
    switch i
        case 1  
            A = Ai;
            b = bi;
        otherwise
            A = [A;Ai];
            b = [b;bi];
    end
end

[Q,R] = qr(A);
% R = R(1:24,1:24);
% Q = Q(:,1:24);
% w = inv(R)*(Q'*b);
x = R\Q'*b;
p = x(1:3);
t_Tip = x(4:6);

% Orientation

t_Cloud = cloud();
Rz = (t_Tip-t_Cloud);
Rz = Rz/norm(Rz);
Ry = cross(t_Tip,t_Cloud);
Ry = Ry/norm(Ry);
Rx = cross(Ry,Rz);
Rx = Rx/norm(Rx);
T_ToolmarkerTip = [Rx,Ry,Rz,t_Tip;0,0,0,1];

end