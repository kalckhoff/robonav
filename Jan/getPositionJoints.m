function jointAngles = getPositionJoints(jTcpObj)

jtcp('write',jTcpObj,int8('GetPositionJoints'));
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); disp(mssg)
mssgSplit = strsplit(mssg,' ');
% Format: joint angles 1-6
jointAngles = str2double(mssgSplit);
