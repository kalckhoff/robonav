%% Globale Definition IP-Adresse des UR5
global IP_ADDRESS;
IP_ADDRESS = '192.168.22.123'; 
%%

%% Globale Definition der UR5 Arml�ngen
global D1 D4 D5 A2 A3;
D1= 1; D4=10; D5=10; A2=15; A3=5;

%% GetPositionJoints
jAngles = getPositionJoints;

%% Berechnung der der Position des End Effectors durch Forwardkinematics
pos_end_effector = forward_kinematics(jAngles);


%% Berechnung der der Zielposition durch Inversekinematics

%target_joints_angels=inverse_kinematics(pos_end_effector);

%% Senden der neuen Winkel zur Erreichung des berechneten Targets

%movePTPJoints(jTcpObj, target_joints_angels);

pause(1)

%%
jAngles = getPositionJoints;

%%
% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
%jTcpObj = jtcp('close',jTcpObj);
%/