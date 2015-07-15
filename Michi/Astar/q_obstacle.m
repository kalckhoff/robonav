function [X, Y, num] = q_obstacle(robot_X, robot_Y, robot_num, robot_n, obstacle_X, obstacle_Y, obstacle_num, obstacle_n, R_ref_i, O_ref_i)

num = robot_num + obstacle_num;
QR_ref_i=[0,0];
QO_ref_i=[0,0];
Oi=1;
Ri=1;

[temp, index] = sort([robot_n, obstacle_n]);

% check direction polygons
robot_direction_v = cross([robot_X(2)-robot_X(1),robot_Y(2)-robot_Y(1),0],[robot_X(3)-robot_X(2),robot_Y(3)-robot_Y(2),0]);
if robot_direction_v(3) > 0
    robot_direction=-1;
else
    robot_direction=1;
end
obstacle_direction_v = cross([obstacle_X(2)-obstacle_X(1),obstacle_Y(2)-obstacle_Y(1),0],[obstacle_X(3)-obstacle_X(2),obstacle_Y(3)-obstacle_Y(2),0]);
if obstacle_direction_v(3) > 0
    obstacle_direction=1;
else
    obstacle_direction=-1;
end

% first side
if index(1)>robot_num                           % obstacle side
    X(1)=obstacle_X(index(1)-robot_num);
    Y(1)=obstacle_Y(index(1)-robot_num);
    if index(1)-robot_num == O_ref_i; QO_ref_i(Oi)=1; Oi=Oi+1; end
    if index(1) < num                               % not obstacle last side
        X(2)=obstacle_X(index(1)-robot_num+1);
        Y(2)=obstacle_Y(index(1)-robot_num+1);
        if index(1)-robot_num+1 == O_ref_i; QO_ref_i(Oi)=2; Oi=Oi+1; end
    else                                            % obstacle last side
        X(2)=obstacle_X(1);
        Y(2)=obstacle_Y(1);
        if 1 == O_ref_i; QO_ref_i(Oi)=2; Oi=Oi+1; end
    end
    if obstacle_direction == -1
        x=X(1); y=Y(1); X(1)=X(2); Y(1)=Y(2); X(2)=x; Y(2)=y;
    end
else                                           % robot's side
    X(1)=robot_X(index(1));
    Y(1)=robot_Y(index(1));
    if index(1) == R_ref_i; QR_ref_i(Ri)=2; Ri=Ri+1; end
    if index(1) < robot_num                               % not robot's last side
        X(2)=robot_X(index(1)+1);
        Y(2)=robot_Y(index(1)+1);
        if index(1)+1 == R_ref_i; QR_ref_i(Ri)=1; Ri=Ri+1; end
    else                                            % robot's last side
        X(2)=robot_X(1);
        Y(2)=robot_Y(1);
        if 1 == R_ref_i; QR_ref_i(Ri)=1; Ri=Ri+1; end
    end
    if robot_direction == -1
        x=X(1); y=Y(1); X(1)=X(2); Y(1)=Y(2); X(2)=x; Y(2)=y;
    end
end



% other sides
for i=2:num-1                                 
    if index(i)>robot_num                           % obstacle side
        if index(i)-robot_num == O_ref_i; QO_ref_i(Oi)=i; Oi=Oi+1; end
        if index(i) < num                               % not obstacle last side
            DX=obstacle_X(index(i)-robot_num+1)-obstacle_X(index(i)-robot_num);
            DY=obstacle_Y(index(i)-robot_num+1)-obstacle_Y(index(i)-robot_num);
            if index(i)-robot_num+1 == O_ref_i; QO_ref_i(Oi)=i+1; Oi=Oi+1; end
        else                                            % obstacle last side
            DX=obstacle_X(1)-obstacle_X(index(i)-robot_num);
            DY=obstacle_Y(1)-obstacle_Y(index(i)-robot_num);
            if 1 == O_ref_i; QO_ref_i(Oi)=i+1; Oi=Oi+1; end
        end
        X(i+1) = X(i) + obstacle_direction*DX;
        Y(i+1) = Y(i) + obstacle_direction*DY;
    else                                           % robot's side
        if index(i) == R_ref_i; QR_ref_i(Ri)=i+1; Ri=Ri+1; end
        if index(i) < robot_num                         % not robot's last side
            DX=robot_X(index(i)+1)-robot_X(index(i));
            DY=robot_Y(index(i)+1)-robot_Y(index(i));
            if index(i)+1 == R_ref_i; QR_ref_i(Ri)=i; Ri=Ri+1; end
        else                                            % robot's last side
            DX=robot_X(1)-robot_X(index(i));
            DY=robot_Y(1)-robot_Y(index(i));
            if 1 == R_ref_i; QR_ref_i(Ri)=i; Ri=Ri+1; end
        end
        X(i+1) = X(i) + robot_direction*DX;
        Y(i+1) = Y(i) + robot_direction*DY;
    end
end


% last side
if index(num)>robot_num                           % obstacle side
    if index(num)-robot_num == O_ref_i; QO_ref_i(Oi)=num; Oi=Oi+1; end
    if index(num) < num                               % not obstacle last side
        if index(num)-robot_num+1 == O_ref_i; QO_ref_i(Oi)=1; Oi=Oi+1; end
    else                                            % obstacle last side
        if 1 == O_ref_i; QO_ref_i(Oi)=1; Oi=Oi+1; end
    end
else                                           % robot's side
    if index(num) == R_ref_i; QR_ref_i(Ri)=1; Ri=Ri+1; end
    if index(num) < robot_num                         % not robot's last side
        if index(num)+1 == R_ref_i; QR_ref_i(Ri)=num; Ri=Ri+1; end
    else                                            % robot's last side
        if 1 == R_ref_i; QR_ref_i(Ri)=num; Ri=Ri+1; end
    end
end


% translation

if O_ref_i==0
    ref_obs=find(obstacle_X == min(obstacle_X));
    ref_Q_obs=find(round(100000*X) == min(round(100000*X)));
else
    ref_obs=O_ref_i;        
    if QO_ref_i(1) == QO_ref_i(2)
        ref_Q_obs=QO_ref_i(1);
    elseif QR_ref_i(1) == QR_ref_i(2)
        ref_Q_obs=QR_ref_i(1);
    elseif QO_ref_i(1)==QR_ref_i(1)
        ref_Q_obs=QO_ref_i(1);
    elseif QO_ref_i(1)==QR_ref_i(2)
        ref_Q_obs=QO_ref_i(1);
    elseif QO_ref_i(2)==QR_ref_i(1)
        ref_Q_obs=QO_ref_i(2);
    elseif QO_ref_i(2)==QR_ref_i(2)
        ref_Q_obs=QO_ref_i(2);
    end      
end

y_min=obstacle_Y(ref_obs(1));
y_Q_min=Y(ref_Q_obs(1));
for i=2:length(ref_obs)
    if obstacle_Y(ref_obs(i)) < y_min
        y_min=obstacle_Y(ref_obs(i));
    end
    if Y(ref_Q_obs(i)) < y_Q_min
        y_Q_min=Y(ref_Q_obs(i));
    end
end
    
DX=obstacle_X(ref_obs(1))-X(ref_Q_obs(1));
DY=y_min-y_Q_min;
X=X+DX;
Y=Y+DY;




















