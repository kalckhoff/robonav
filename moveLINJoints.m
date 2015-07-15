function moveLINJoints(newJointAngles)
global IP_ADDRESS;

%% Open the TCP/IP-Connection
jTcpObj = jtcp('request', IP_ADDRESS, 5005,'serialize',false);
%mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('Hello Robot'));
pause(0.5)
mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

jtcp('write',jTcpObj,int8('EnableLin'));
pause(0.5)
mssg = char(jtcp('read',jTcpObj)); 

jtcp('write',jTcpObj,int8('SetUR5Speed 0.05'));
pause(0.5)
mssg = char(jtcp('read',jTcpObj)); 



%mssgInt8 = int8(['MovePTPJoints ' num2str(newJointAngles,30)]);
mssgInt8 = int8(['MoveLINJoints ' num2str(newJointAngles,30)]);
jtcp('write',jTcpObj,mssgInt8);
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); %disp(mssg);

jTcpObj = jtcp('close',jTcpObj);
end