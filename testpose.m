function [T_testpose_inRobot, T_ultrapose_inRobot] = testpose(T_ultrasound,X,Y,T_ToolmarkerTip)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function calculates the target positions in robot coordinateframe
%
% Input: 	T_ultrasound:		position of the point in the ultrasound image in camera coordinateframe	
%			X:					transformationmatrix X
%			Y:					transformationmatrix Y
%			T_ToolmarkerTip:	transformationmatrix from needletip to needlemarker
%
% output: 	T_testpose_inRobot:		position of the point in the window in robot coordinateframe	
%			T_ultrapose_inRobot:	position of the point in the ultrasound image in robot coordinateframe
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  connect to camera
jTcpObj = connectCamera();

fprintf('point at the window with the stylus and press any key')

pause

% load the stylus marker
LoadLocator(jTcpObj, 'stylus');

% take one measurement of a point on the window
for i=1:1
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'stylus');
    poses_test{i} = T;
    t{i} = T(1:3,4);
    pause;
end

% get the translational part of the point from the ultrasound image
poses_test{2} = T_ultrasound;
t{2} = T_ultrasound(1:3);

% calculate the orientation between window point and ultrasound point
Rz = (t{2}-t{1});
Rz = Rz/norm(Rz);
Ry = cross(t{2},t{1});
Ry = Ry/norm(Ry);
Rx = cross(Ry,Rz);
Rx = Rx/norm(Rx);


%% First Target Point
% build transformation in camera coordinateframe
T_testpose_inCamera = [Rx,Ry,Rz,t{1};0,0,0,1];

% translate in robot coordinateframe
T_testpose_inRobot = Y * T_testpose_inCamera * inv(T_ToolmarkerTip) * inv(X);

% the robot must take a position with 3cm distance to the window
t_testpose_inRobot_3cm = (T_testpose_inRobot(1:3,4)-30*T_testpose_inRobot(1:3,1:3)*[0;0;1]);
T_testpose_inRobot = [T_testpose_inRobot(1:3,1:3),t_testpose_inRobot_3cm;0,0,0,1];

%% Secound Target Point
% build transformation in camera coordinateframe
T_ultrapose_inCamera = [Rx,Ry,Rz,t{2};0,0,0,1];

% translate in robot coordinateframe
T_ultrapose_inRobot = Y * T_ultrapose_inCamera * inv(T_ToolmarkerTip) * inv(X);

T_ultrapose_inRobot = [T_ultrapose_inRobot(1:3,1:3), (T_ultrapose_inRobot(1:3,4)+10*T_ultrapose_inRobot(1:3,1:3)*[0;0;1]);0,0,0,1];
T_ultrapose_inRobot = [T_ultrapose_inRobot;0,0,0,1];

end