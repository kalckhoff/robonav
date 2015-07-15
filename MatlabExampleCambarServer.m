%% Open the TCP/IP-Connection
% IP address of the PC on which cambarserver is running.
ipAddr = '134.28.45.63';

jTcpObj = jtcp('request', ipAddr, 3000,'serialize',false); pause(0.1);
mssg = char(jtcp('read',jTcpObj)); disp(mssg)

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('mtec')); pause(0.1);
mssg = char(jtcp('read',jTcpObj)); disp(mssg)

%% Load Locator
LoadLocator(jTcpObj, 'stylus');
%%
% A loop to aquire data continously
N = 10;
p = zeros(4,N);
i=1;
while (i<=N)
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'stylus');
    if (sum(T(:))~=1)
        % transform marker center point in camera coordinates
        p(:,i) = T * [0,0,0,1]';
        % plot the marker position
        plot3(p(1,1:i),p(2,1:i),p(3,1:i),'ko');
        title(timestamp);
        % wait 0.001 seconds
        pause(0.5);
    else
        disp('All zero T')
    end
    i=i+1;
end

%%
% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('quit'));
jTcpObj = jtcp('close',jTcpObj);