function [poses_mark, poses_rob, num] = moveforcalib()

jTcpObj = connectCamera();

%% Load Locator
LoadLocator(jTcpObj, 'Needle_grp3');

fprintf('press any key after the robot has moved to take the Transformation-Matrix, press a key after every single movement');

jAngles = getPositionJoints();
pose = getPositionHomRowWise();
%best_config = getStatus();
best_config = ['flip ' 'up ' 'lefty'];
num = 50;

for i=1:num  
    
    newAngles = [jAngles(1:3), jAngles(4)+randi([-15,15],1,1), jAngles(5)+randi([-15,15],1,1), jAngles(6)+randi([-15,15],1,1)];
    
    new_pose = forward_kinematics(newAngles);
    
    t = rand(3,1);
    t = t/norm(t);
    t = t*randi([-150,150],1);
    
    new_pose = [new_pose(1:3,1:3),new_pose(1:3,4)+t];
    
    movetoconfig(new_pose, best_config);
    
    pause;
    
    poses_rob{i} = [new_pose;0,0,0,1];
    
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'Needle_grp3');
    
    poses_mark{i} = [T];
    
    pause(1);
    
end
   

end