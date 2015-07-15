function check = isPossible(target_pos, best_config)
global IP_ADDRESS;

firstrow = num2str(target_pos(1,:));
secondrow = num2str(target_pos(2,:));
thirdrow = num2str(target_pos(3,:));

%% Open the TCP/IP-Connection
jTcpObj = jtcp('request', IP_ADDRESS, 5005,'serialize',false);
mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg);

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('Hello Robot'));
mssg = char(jtcp('read',jTcpObj)); 
disp(mssg);

jtcp('write',jTcpObj,int8(['IsPossible ' firstrow ' ' secondrow ' ' thirdrow ' ' best_config]));
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); disp(mssg)
mssgSplit = strsplit(mssg,' ');

% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
jTcpObj = jtcp('close',jTcpObj);

check = cell2mat(mssgSplit);

end