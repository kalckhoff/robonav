function movetotarget(target_joints_angles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function moves the robot to a defined joint angles using movePTPJoints funciton
%
% Input: 	target_joint_angles:	joint angles to move to
%
% output: 	----
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get current joint angles
jAngles = getPositionJoints();

% find the correct solution out of all possible ones
v = 0;
for i=1:4
   if 0 > target_joints_angles(2,i) > -90
      if target_joints_angles(2,i) < v
          v = target_joints_angles(2,i);
          loc = i;
      end
   end
end

% drive the joints step by step (not used in current version - line 33 takes the 4th configuration instantly)
newAngles = [target_joints_angles(1,loc) jAngles(2) jAngles(3) jAngles(4) target_joints_angles(5,loc) target_joints_angles(6,loc);
    target_joints_angles(1,loc) target_joints_angles(2,loc) jAngles(3) jAngles(4) target_joints_angles(5,loc) target_joints_angles(6,loc);
    target_joints_angles(1,loc) target_joints_angles(2,loc) target_joints_angles(3,loc) jAngles(4) target_joints_angles(5,loc) target_joints_angles(6,loc);
    target_joints_angles(1,loc) target_joints_angles(2,loc) target_joints_angles(3,loc) target_joints_angles(4,loc) target_joints_angles(5,loc) target_joints_angles(6,loc)];

	
% move the robot 
for i=4:4
    
    movePTPJoints(newAngles(i,:));
    
    pause
    
% wait until the robot is in a certain position (not used in current version)
%     while getPositionJoints() ~= newAngles(i,:);
%         %
%     end
    
end
   

end
