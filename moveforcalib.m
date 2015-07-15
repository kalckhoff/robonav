function [poses_mark, poses_rob, num] = moveforcalib()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function moves the robot in a sphere for the hand eye calibration
%
% Input: 	---
%
% output: 	poses_mark:	all recorded marker poses in camera coordinateframe
%			poses_rob:	all recorded robot poses in robot coordinateframe
%			num:		number of recorded poses
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% connect to camera
jTcpObj = connectCamera();

%% Load Locator
LoadLocator(jTcpObj, 'Needle_grp3');

fprintf('press any key after the robot has moved to take the Transformation-Matrix, press a key after every single movement');

% get current joint angles
jAngles = getPositionJoints();

% get current pose
pose = getPositionHomRowWise();

% define the wanted configuration
%best_config = getStatus();
best_config = ['flip ' 'up ' 'lefty'];

% number of poses to record
num = 50;

% record poses
for i=1:num  
    
	%% random movement of the robot in a sphere
    % random orientation
	newAngles = [jAngles(1:3), jAngles(4)+randi([-15,15],1,1), jAngles(5)+randi([-15,15],1,1), jAngles(6)+randi([-15,15],1,1)];
    new_pose = forward_kinematics(newAngles);
    
	% random translation
    t = rand(3,1);
    t = t/norm(t);
    t = t*randi([-150,150],1);
    
	% move
    new_pose = [new_pose(1:3,1:3),new_pose(1:3,4)+t];
    movetoconfig(new_pose, best_config);
    
    pause;
    
	% save the pose of the robot
    poses_rob{i} = [new_pose;0,0,0,1];
    
	% save the pose of the marker
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'Needle_grp3');
    poses_mark{i} = [T];
    
    pause(1);
	
end
   

end