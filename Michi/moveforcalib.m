function moveforcalib()

jAngles = getPositionJoints();
pose = getPositionHomRowWise();
best_config = getStatus();
best_config = ['noflip ' 'down ' 'righty'];
for i=1:30
    
    
    
    newAngles = [jAngles(1:3), jAngles(4)+randi([-10,10],1,1), jAngles(5)+randi([-10,10],1,1), jAngles(6)+randi([-10,10],1,1)];
    
    new_pose = forward_kinematics(newAngles);
    
    t = rand(3,1);
    t = t/norm(t);
    t = t*randi([-100,100],1);
    
    new_pose = [new_pose(1:3,1:3),new_pose(1:3,4)+t];
    
    movetoconfig(new_pose, best_config);
    
    poses{i} = [new_pose;0,0,0,1];
    
    markers = MatlabExampleCambarServer();
    
    pause;
    
    
end
   

end