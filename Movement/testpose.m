function T_testpose_inRobot = testpose()

jTcpObj = connectCamera();

pause

LoadLocator(jTcpObj, 'stylus');

for i=1:2
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'stylus');
    poses_test{i} = [T];
    t{i} = T(1:3,4);
    pause;
end

Rz = (t{2}-t{1});
Rz = Rz/norm(Rz);
Ry = cross(t{2},t{1});
Ry = Ry/norm(Ry);
Rx = cross(Ry,Rz);
Rx = Rx/norm(Rx);

T_testpose_inCamera = [Rx,Ry,Rz,t{1};0,0,0,1];

T_testpose_inRobot = Y * T_testpose_inCamera * inv(T_ToolmarkerTip) * inv(X);

t_testpose_inRobot_2cm = (T_testpose_inRobot(1:3,4)-20*T_testpose_inRobot(1:3,1:3)*[0;0;1]);

T_testpose_inRobot = [T_testpose_inRobot(1:3,1:3),t_testpose_inRobot_2cm;0,0,0,1];


% T_target_inRobot = Y * poses_test{1};
% 
% t_target_inRobot = T_target_inRobot(1:3,4);
% 
% T_orient = getPositionHomRowWise();
% 
% T_testpose_inRobot = [T_orient(1:3,1:3),t_target_inRobot;0,0,0,1];

end