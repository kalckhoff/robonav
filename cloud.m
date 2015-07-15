function t_Toolmarker = cloud(poses_cloud,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function calculates the target positions in robot coordinateframe
%
% Input: 	poses_cloud:	poses of the points around the needlebase	
%			n:				number of poses	
%
% output:	t_Toolmarker:	position of the needlebase in camera coordinateframe	
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% connect to camera
jTcpObj = connectCamera();

fprintf('press any key to take one measurement of the build-in marker for reference');

pause

% load needlelocator
LoadLocator(jTcpObj, 'Needle_grp3');

% save the current pose of the needlelocator
[T_CameraToolmarker,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'Needle_grp3');

% load the cloud poses and the number of poses
%load('camHTMs.mat');
T = poses_cloud;
num = n;

% calculate the average position of all cloud poses
trans = zeros(4,1);
for i = 1:num
    transT = T{i}(1:4,4);
    trans = transT + trans;
end
t_Camera = trans/num;


% calculate the position of the base in camera coordinateframe
T_ToolmarkerCamera = inv(T_CameraToolmarker);
t_Toolmarker = T_ToolmarkerCamera*t_Camera;
t_Toolmarker = t_Toolmarker(1:3);


end

