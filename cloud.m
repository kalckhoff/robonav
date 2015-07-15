function t_Toolmarker = cloud(poses_cloud,n)

jTcpObj = connectCamera();

fprintf('press any key to take one measurement of the build-in marker for reference');

pause

LoadLocator(jTcpObj, 'Needle_grp3');

[T_CameraToolmarker,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'Needle_grp3');

%load('camHTMs.mat');
T = poses_cloud;
num = n;
trans = zeros(4,1);

for i = 1:num
    transT = T{i}(1:4,4);
    
    trans = transT + trans;
end

t_Camera = trans/num;

% Transformation

T_ToolmarkerCamera = inv(T_CameraToolmarker);

t_Toolmarker = T_ToolmarkerCamera*t_Camera;
t_Toolmarker = t_Toolmarker(1:3);
end