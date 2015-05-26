function movePTPJoints(newJointAngles)
global jTcpObj IP_ADDRESS;




mssgInt8 = int8(['MovePTPJoints ' num2str(newJointAngles,30)]);
jtcp('write',jTcpObj,mssgInt8);
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); disp(mssg)
