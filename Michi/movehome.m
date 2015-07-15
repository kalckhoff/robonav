function movehome()

jAngles = getPositionJoints();

newAngles = [0 -90 jAngles(3) jAngles(4) jAngles(5) jAngles(6);
    0 -90 jAngles(3) jAngles(4) 0 0;
    0 -90 jAngles(3) -90 0 0;
    0 -90 0 -90 0 0];

for i=1:4
    
    movePTPJoints(newAngles(i,:));
    
    while getPositionJoints() ~= newAngles(i,:);
        %
    end
    
end

end