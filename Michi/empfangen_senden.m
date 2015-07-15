clear all;
close all;
%% Globale Definition IP-Adresse des UR5
global IP_ADDRESS;
IP_ADDRESS = '192.168.56.101';


%% Globale Definition der UR5 Arml�ngen in mm (D4 u D5 k�nnen auch vertauscht sein !?)
global A D ALPHA;

D = 1000*[0.089159, 0.0, 0.0, 0.10915, 0.09465, 0.0823];
A = 1000*[0.0, -0.425, -0.39225, 0 , 0, 0];
ALPHA = [pi/2, 0, 0, pi/2, -pi/2, 0];

%% GetTargetPosition
endpos = getPositionHomRowWise();
target_pos = endpos(1:3,1:4);

%% GetPositionJoints
jAngles = getPositionJoints;
config = getStatus();
config = cell2mat(config);

%% Random new Endpos
randompose = random();

%% Berechnung der der Zielposition durch Inversekinematics
target_joints_angles = inverse_kinematics(endpos);


%% Berechnung der der Position des End Effectors durch Forwardkinematics
pos_end_effector = forward_kinematics(jAngles);


%% Berechnung der Positionen der Joints

pos_joint = mjoint(target_joints_angles);

best_config = bestconfig(pos_joint);
best_config = cell2mat(best_config);

% for i=1:8
%     laenge_link4(i) = norm(pos_joint{4,i}-pos_joint{3,i});
% end

%% Plotten der möglichen config-Positionen

showpose(pos_joint);

%% Anfahren der Home-Position

movehome();

%% Anfahren des Targets

movetotarget(target_joints_angles);

% new_config = ['noflip ' 'up ' 'lefty'];
% 
% check = isPossible(target_pos, best_config);
% 
% movetoconfig(target_pos, new_config);

% movetotarget(target_joints_angles);

%% Senden der neuen Winkel zur Erreichung des berechneten Targets
%moveLINJoints(target_joints_angels);

% new_angles = target_joints_angles +20;
% movePTPJoints();

%pause(1)
 
%jAngles_check = getPositionJoints


