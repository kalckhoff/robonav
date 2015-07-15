function movetoconfig(target_pos, best_config)
global IP_ADDRESS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function moves the robot to a target position using the HomRowWise
%
% Input: 	target_pos:		pose of the target
%			best_config:	wanted configuration of the robot
%
% output: 	---
%
% global:	IP_ADDRESS:		IP address of the rob6server
%
% Robotics and Navigation in Medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

firstrow = num2str(target_pos(1,:));
secondrow = num2str(target_pos(2,:));
thirdrow = num2str(target_pos(3,:));

%% Open the TCP/IP-Connection
jTcpObj = jtcp('request', IP_ADDRESS, 5005,'serialize',false);
%mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('Hello Robot'));
%mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

mssgInt8 = int8(['MoveMinChangeRowWiseStatus ' firstrow ' ' secondrow ' ' thirdrow ' ' best_config]);
jtcp('write',jTcpObj,mssgInt8);
pause(0.1)
%mssg = char(jtcp('read',jTcpObj)); disp(mssg);

jTcpObj = jtcp('close',jTcpObj);

end