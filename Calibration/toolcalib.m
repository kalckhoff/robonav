function T_ToolmarkerTip = toolcalib()

jTcpObj = connectCamera();

pause

LoadLocator(jTcpObj, 'Needle_grp3');
j=0;
for i=1:50
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'Needle_grp3');
    if T(1,1) ~= 0
        j=j+1;
        poses_tooltip{j} = [T];
        pause(0.5);
    end
end



pause

LoadLocator(jTcpObj, 'stylus');
n = 0;
for i=1:4
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'stylus');
    if T(1,1) ~= 0
        n = n+1;
        poses_cloud{n} = [T];
    end
    pause;
end

pause

%load('camHTMs.mat');
T = poses_tooltip;
num = j;


for i = 1:num
    rotT = T{i}(1:3,1:3);
    transT = T{i}(1:3,4);
    
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

t_Cloud = cloud(poses_cloud,n);
Rz = (t_Tip-t_Cloud);
Rz = Rz/norm(Rz);
Ry = cross(t_Tip,t_Cloud);
Ry = Ry/norm(Ry);
Rx = cross(Ry,Rz);
Rx = Rx/norm(Rx);
T_ToolmarkerTip = [Rx,Ry,Rz,t_Tip;0,0,0,1];

end