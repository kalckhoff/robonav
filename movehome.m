function movehome()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function moves the robot to its home position using movePTPJoints
%
% Input:    ---
%
% output: 	---
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get current joint angles
jAngles = getPositionJoints();

% change the joint angles joint by joint
newAngles = [0 -89 jAngles(3) jAngles(4) jAngles(5) jAngles(6);
    0 -89 jAngles(3) jAngles(4) 91 0;
    0 -89 jAngles(3) -89 91 0;
    0 -89 0 -89 91 0];

% move the robot joint by joint
for i=1:4
    
    movePTPJoints(newAngles(i,:));    
    while getPositionJoints() ~= newAngles(i,:);
        % wait until the movement of the joint stopped
    end
    
end

end