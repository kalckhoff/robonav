function movehome()

jAngles = getPositionJoints();

newAngles = [0 -89 jAngles(3) jAngles(4) jAngles(5) jAngles(6);
    0 -89 jAngles(3) jAngles(4) 91 0;
    0 -89 jAngles(3) -89 91 0;
    0 -89 0 -89 91 0];

for i=1:4
    
    movePTPJoints(newAngles(i,:));
    
    while getPositionJoints() ~= newAngles(i,:);
        %
    end
    
end

end