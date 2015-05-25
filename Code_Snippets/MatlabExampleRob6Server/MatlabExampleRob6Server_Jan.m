%% Open the TCP/IP-Connection
jTcpObj = jtcp('request', '192.168.22.123', 5005,'serialize',false);
mssg = char(jtcp('read',jTcpObj)); disp(mssg)

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('Hello Robot'));
mssg = char(jtcp('read',jTcpObj)); disp(mssg)

%% GetPositionJoints
jAngles = getPositionJoints(jTcpObj);

%%
newJointAngles = jAngles+1;
movePTPJoints(jTcpObj, newJointAngles)

pause(1)

%%
jAngles = getPositionJoints(jTcpObj);

%%
% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
jTcpObj = jtcp('close',jTcpObj);