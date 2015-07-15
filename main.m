%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calibrating the UR5 robot, the ultrasound probe and the needle to hit a target in a phantom
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%% global definition of rob6server IP adress
global IP_ADDRESS;
IP_ADDRESS = '134.28.45.95'; %'192.168.56.101';

%% global definition of DH parameter
global A D ALPHA;

D = 1000*[0.089159, 0.0, 0.0, 0.10915, 0.09465, 0.0823];
A = 1000*[0.0, -0.425, -0.39225, 0 , 0, 0];
ALPHA = [pi/2, 0, 0, pi/2, -pi/2, 0];

%% Calibration

% Tooltip-Calibration
T_ToolmarkerTip = toolcalib();

pause;

% Get Transformations for hand-eye
[poses_mark, poses_rob, num] = moveforcalib();

pause;

% hand-eye-calibration
[X,Y,error,error_old] = heyecalib(poses_rob, poses_mark, num);

%% GetCurrentPosition
current_config = getStatus();
current_config = cell2mat(current_config);
current_pos = getPositionHomRowWise();

% for movetoconfig, last shot
% target_pos = T_testpose_inRobot(1:3,1:4);

%% GetPositionJoints
jAngles = getPositionJoints;


%% Ultrasound
T_ultrasound = UltraSound_TumorControl();

%% calculate target position and orientation
[T_testpose_inRobot, T_ultrapose_inRobot] = testpose(T_ultrasound,X,Y,T_ToolmarkerTip);
% T_testpose_inRobot(3,4) = T_testpose_inRobot(3,4) + 150;
% T_ultrapose_inRobot(3,4) = T_ultrapose_inRobot(3,4) + 150;
%% Berechnung der der Zielposition durch Inversekinematics
target_joints_angles = inverse_kinematics(current_pos);
target_joints_angles1 = inverse_kinematics(T_testpose_inRobot);
target_joints_angles2 = inverse_kinematics(T_ultrapose_inRobot);


%% calculate jount position

pos_joint = mjoint(target_joints_angles);
best_config = bestconfig(pos_joint);
best_config = cell2mat(best_config);

for i=1:8
    laenge_link4(i) = norm(pos_joint{4,i}-pos_joint{3,i});
end

%% Plotten der möglichen config-Positionen
showpose(pos_joint);

%% Anfahren der Home-Position
% movehome();

%% Anfahren des Targets
 movetotarget(target_joints_angles1);
 pause;
 moveLINJoints(target_joints_angles1(1:6,1)');

% best_config = ['noflip ' 'up ' 'lefty'];
% 
% check = isPossible(target_pos, best_config);
% target_pos = T_testpose_inRobot
% movetoconfig(target_pos, best_config);

% movetotarget(target_joints_angles);

%% Senden der neuen Winkel zur Erreichung des berechneten Targets
%moveLINJoints(target_joints_angels);

% new_angles = target_joints_angles +20;
% movePTPJoints();

%pause(1)
 
%jAngles_check = getPositionJoints


