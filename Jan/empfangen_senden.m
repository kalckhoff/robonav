%% Globale Definition IP-Adresse des UR5
global IP_ADDRESS;
IP_ADDRESS = '192.168.22.123'; 
%%

%% Globale Definition der UR5 Armlängen in mm (D4 u D5 können auch vertauscht sein !?)
global D1 D4 D5 D6 A2 A3 jTcpObj;
D1= 89.2; D4=109.3; D5=94.75; D6=82.5; A2=425; A3=392;

%% GetPositionJoints
jAngles = getPositionJoints;

%% Berechnung der der Position des End Effectors durch Forwardkinematics
pos_end_effector = forward_kinematics(jAngles);


%% Berechnung der der Zielposition durch Inversekinematics

%target_joints_angels=inverse_kinematics(pos_end_effector);

%% Senden der neuen Winkel zur Erreichung des berechneten Targets
target_joints_angels = [0 0 0 0 0 0];
%movePTPJoints(jTcpObj, target_joints_angels);

pause(1)

%%
jAngles = getPositionJoints;

%%
% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
%jTcpObj = jtcp('close',jTcpObj);
%/
