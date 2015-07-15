function [T_testpose_inRobot, T_ultrapose_inRobot] = testpose(T_ultrasound,X,Y,T_ToolmarkerTip)

jTcpObj = connectCamera();

fprintf('point at the window with the stylus and press any key')

pause

LoadLocator(jTcpObj, 'stylus');

for i=1:1
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'stylus');
    poses_test{i} = T;
    t{i} = T(1:3,4);
    pause;
end
%T_ultrasound = poses_test{2};
poses_test{2} = T_ultrasound;
t{2} = T_ultrasound(1:3);


Rz = (t{2}-t{1});
Rz = Rz/norm(Rz);
Ry = cross(t{2},t{1});
Ry = Ry/norm(Ry);
Rx = cross(Ry,Rz);
Rx = Rx/norm(Rx);

T_testpose_inCamera = [Rx,Ry,Rz,t{1};0,0,0,1];

T_testpose_inRobot = Y * T_testpose_inCamera * inv(T_ToolmarkerTip) * inv(X);

t_testpose_inRobot_3cm = (T_testpose_inRobot(1:3,4)-30*T_testpose_inRobot(1:3,1:3)*[0;0;1]);

T_testpose_inRobot = [T_testpose_inRobot(1:3,1:3),t_testpose_inRobot_3cm;0,0,0,1];

T_ultrapose_inCamera = [Rx,Ry,Rz,t{2};0,0,0,1];

T_ultrapose_inRobot = Y * T_ultrapose_inCamera * inv(T_ToolmarkerTip) * inv(X);

T_ultrapose_inRobot = [T_ultrapose_inRobot(1:3,1:3), (T_ultrapose_inRobot(1:3,4)+10*T_ultrapose_inRobot(1:3,1:3)*[0;0;1]);0,0,0,1];

T_ultrapose_inRobot = [T_ultrapose_inRobot;0,0,0,1];

end