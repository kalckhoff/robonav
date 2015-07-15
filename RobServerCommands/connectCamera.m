function jTcpObj = connectCamera()

%% Open the TCP/IP-Connection
% IP address of the PC on which cambarserver is running.
ipAddr = '134.28.45.63';

jTcpObj = jtcp('request', ipAddr, 3000,'serialize',false); pause(0.1);
mssg = char(jtcp('read',jTcpObj)); disp(mssg)

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('mtec')); pause(0.1);
mssg = char(jtcp('read',jTcpObj)); disp(mssg)

end