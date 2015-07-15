function LoadLocator(jTcpObj, name)
% LoadLocator  Loads the locator 'name'. Please make sure that locator
% exists at the path "C:\locators\<name>.xml" on the computer where the
% cambarserver is running.
%
% TCP/IP object associated with the CambarServer needs to be provided as
% well.
%   LoadLocator(jTcpObj, 'name')

jtcp('write',jTcpObj,int8(['LoadLocator ' name]));
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); disp(mssg)
end