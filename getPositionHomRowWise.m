function T = getPositionHomRowWise()
global IP_ADDRESS;

%% Open the TCP/IP-Connection
jTcpObj = jtcp('request', IP_ADDRESS, 5005,'serialize',false);
mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('Hello Robot'));pause(0.5)
mssg = char(jtcp('read',jTcpObj)); 
disp(mssg);

jtcp('write',jTcpObj,int8('GetPositionHomRowWise'));
pause(0.5)
mssg = char(jtcp('read',jTcpObj)); disp(mssg)
mssgSplit = strsplit(mssg,' ');

% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
jTcpObj = jtcp('close',jTcpObj);

% Format: joint angles 1-6
if isnan (str2double(mssgSplit)) 
    disp('Fehler bei RobServer Verbindung! Falsche IP-Adresse oder Server neustarten!');
else
    T = [reshape(str2double(mssgSplit),4,3)'; [0 0 0 1]];
end
