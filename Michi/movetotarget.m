function movetotarget(target_joints_angles)

jAngles = getPositionJoints();

v = 0;
for i=1:4
   if 0 > target_joints_angles(2,i) > -90
      if target_joints_angles(2,i) < v
          v = target_joints_angles(2,i)
          loc = i;
      end
   end
end

newAngles = [target_joints_angles(1,loc) jAngles(2) jAngles(3) jAngles(4) target_joints_angles(5,loc) target_joints_angles(6,loc);
    target_joints_angles(1,loc) target_joints_angles(2,loc) jAngles(3) jAngles(4) target_joints_angles(5,loc) target_joints_angles(6,loc);
    target_joints_angles(1,loc) target_joints_angles(2,loc) target_joints_angles(3,loc) jAngles(4) target_joints_angles(5,loc) target_joints_angles(6,loc);
    target_joints_angles(1,loc) target_joints_angles(2,loc) target_joints_angles(3,loc) target_joints_angles(4,loc) target_joints_angles(5,loc) target_joints_angles(6,loc)]

for i=1:4
    
    movePTPJoints(newAngles(i,:));
    
    while getPositionJoints() ~= newAngles(i,:)
        %
    end
    
end
   

end
