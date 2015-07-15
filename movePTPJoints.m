function movePTPJoints(newJointAngles)
global IP_ADDRESS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function moves the robot to a target position using the movePTPJoints
%
% Input: 	newJointAngles:		joint angles of the target pose
%
% output: 	---
%
% global:	IP_ADDRESS:		IP address of the rob6server
%
% Robotics and Navigation in Medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Open the TCP/IP-Connection
jTcpObj = jtcp('request', IP_ADDRESS, 5005,'serialize',false);
%mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('Hello Robot'));
pause(0.5)
mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

jtcp('write',jTcpObj,int8('SetUR5Speed 0.2'));
pause(0.5)
mssg = char(jtcp('read',jTcpObj)); 


mssgInt8 = int8(['MovePTPJoints ' num2str(newJointAngles,30)]);
jtcp('write',jTcpObj,mssgInt8);
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); %disp(mssg);

jTcpObj = jtcp('close',jTcpObj);
end
