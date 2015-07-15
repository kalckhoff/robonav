function [poses_mark, poses_rob, num] = moveforcalib()

jTcpObj = connectCamera();

%% Load Locator
LoadLocator(jTcpObj, 'Needle_grp3');

jAngles = getPositionJoints();
pose = getPositionHomRowWise();
%best_config = getStatus();
best_config = ['flip ' 'up ' 'lefty'];
num = 30;

for i=1:num  
    
    newAngles = [jAngles(1:3), jAngles(4)+randi([-10,10],1,1), jAngles(5)+randi([-10,10],1,1), jAngles(6)+randi([-10,10],1,1)];
    
    new_pose = forward_kinematics(newAngles);
    
    t = rand(3,1);
    t = t/norm(t);
    t = t*randi([-100,100],1);
    
    new_pose = [new_pose(1:3,1:3),new_pose(1:3,4)+t];
    
    movetoconfig(new_pose, best_config);
    
    pause;
    
    poses_rob{i} = [new_pose;0,0,0,1];
    
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'Needle_grp3');
    
    poses_mark{i} = [T];
    
    pause(0.2);
    
end
   

end