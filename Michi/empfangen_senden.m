clear all;
close all;
%% Globale Definition IP-Adresse des UR5
global IP_ADDRESS;
%IP_ADDRESS = '192.168.56.101';
IP_ADDRESS = '134.28.45.95';

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

%% Berechnung der der Position des End Effectors durch Forwardkinematics
pos_end_effector = forward_kinematics(jAngles);


%% Berechnung der der Zielposition durch Inversekinematics
target_joints_angles = inverse_kinematics(endpos);

%% Berechnung der Positionen der Joints

matrix_joint = mjoint(target_joints_angles);

for i = 1:8
    for k=1:6
        pos_joint{k,i} = [matrix_joint{k,i}(1,4); matrix_joint{k,i}(2,4); matrix_joint{k,i}(3,4)];
    end
end

% for i=1:8
%     laenge_link4(i) = norm(pos_joint{4,i}-pos_joint{3,i});
% end

%% Plotten der möglichen config-Positionen

showpose(pos_joint);


%% Anfahren der Home-Position

%movehome();

%% Anfahren des Targets

new_config = ['noflip' ' ' 'up' ' ' 'righty'];

check = isPossible(target_pos, new_config)

movetoconfig(target_pos, new_config);

% movetotarget(target_joints_angles);

%% Senden der neuen Winkel zur Erreichung des berechneten Targets
%moveLINJoints(target_joints_angels);

% new_angles = target_joints_angles +20;
%movePTPJoints(-19.244678 -121.423508 88.558649 -151.915749 4.570095 -265.614639);

%pause(1)
 
%jAngles_check = getPositionJoints


