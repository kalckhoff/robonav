clear all;
%% Globale Definition IP-Adresse des UR5
global IP_ADDRESS;
IP_ADDRESS = '10.37.129.4';

%%
%% Globale Definition der UR5 Armlängen in mm (D4 u D5 können auch vertauscht sein !?)
global A D ALPHA R O;
%D =[ 0.0892, 0.0 ,0.0 , 0.1093, 0.09475, 0.0825];
%A = [0.0 , -0.425, -0.392, 0.0 , 0.0 , 0.0];
D = 1000*[0.089159, 0.0, 0.0, 0.10915, 0.09465, 0.0823];
A = 1000*[0.0, -0.425, -0.39225, 0 , 0, 0];
ALPHA = [pi/2, 0, 0, pi/2, -pi/2,0];
% R = [-0.0012; 3.1163; 0.0389];
% O = [-0.12011; -0.40825; -0.14401];
%ALPHA = [90, 0, 0, 90, -90, 0];

%% GetPositionJoints
jAngles = getPositionJoints;

%% Berechnung der der Position des End Effectors durch Forwardkinematics
pos_end_effector = forward_kinematics(jAngles)


%% Berechnung der der Zielposition durch Inversekinematics
pos_target = [-0.12011; -0.43176; -0.25393];

target_joints_angels=inverse_kinematics(pos_target, pos_end_effector);

%% Senden der neuen Winkel zur Erreichung des berechneten Targets
%target_joints_angels = [126 75 53 87 23.645623 7];

movePTPJoints(target_joints_angels);

pause(1)
 
%jAngles = getPositionJoints

%% Open the TCP/IP-Connection
%%jTcpObj = jtcp('request', IP_ADDRESS, 5005,'serialize',false);
%%mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

% %% Send the keyword to authorize the client
% jtcp('write',jTcpObj,int8('Hello Robot'));
% mssg = char(jtcp('read',jTcpObj)); 
% disp(mssg);
% 
% jtcp('write',jTcpObj,int8('GetPositionHomRowWise'));
% pause(0.1)
% mssg = char(jtcp('read',jTcpObj)); disp(mssg)
% mssgSplit = strsplit(mssg,' ');
% 

%%
%jAngles = getPositionJoints;

%%
% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
%jTcpObj = jtcp('close',jTcpObj);
%/
