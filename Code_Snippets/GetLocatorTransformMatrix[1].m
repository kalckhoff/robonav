function [T, timestamp] = GetLocatorTransformMatrix(jTcpObj, name)
% GetLocatorTransformMatrix  Gets the transform matrix of the locator
% 'name'.
% TCP/IP object associated with the CambarServer needs to be provided as
% well.
%   T = GetLocatorTransformMatrix(jTcpObj, name)

jtcp('write',jTcpObj,int8(['GetLocatorPosition ' name]));
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); disp(mssg)
mssgSplit = strsplit(mssg,' ');
mssgSplitD = str2double(mssgSplit);
% Format:
% 1. timestamp
% 2. visible-flag
% 3. 4x4 position ,matrix of the locator:
%   R00, R01, R02, X, R10, R11, R12, Y, R20, R21, R22, Z, 0, 0, 0, 1
T = reshape(mssgSplitD(3:end), 4,4)';

timestamp = mssgSplitD(1);
end