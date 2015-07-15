function T_ToolmarkerTip = toolcalib()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function calibrates the tip of the needle with respect to the marker on the needle
%
% Input: ---
%
% Output: T_ToolmarkerTip: transformation from needletip to needlemarker in marker coordinateframe
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% connect to camera
jTcpObj = connectCamera();

fprintf('press any key to start the calibration for the needle tip, don't forget to rotate the needle');

pause

% Load needle marker and take 50 measurements
LoadLocator(jTcpObj, 'Needle_grp3'); pause(1)
j=0;
for i=1:50
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'Needle_grp3');
    
	% only count valid data
	if T(1,1) ~= 0
        j=j+1;
        poses_tooltip{j} = [T];
        pause(1);
    end
end

fprintf('stop rotating the needle, build in the needle, take 8 points at the end of the needle nearby the marker, press any key to continue');
pause


% load stylus marker and take 8 measurements around the needle base
LoadLocator(jTcpObj, 'stylus'); pause(1)
n = 0;
for i=1:8
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'stylus');
    if T(1,1) ~= 0
        n = n+1;
        poses_cloud{n} = [T];
    end
    pause;
end

fprintf('measurement done, press any key for computation')
pause

T = poses_tooltip;
num = j;

% split rotational and translational part and build A and b
for i = 1:num
    rotT = T{i}(1:3,1:3);
    transT = T{i}(1:3,4);
    
    Ai = [-eye(3), rotT];
    
    bi = [-transT];
    
    switch i
        case 1  
            A = Ai;
            b = bi;
        otherwise
            A = [A;Ai];
            b = [b;bi];
    end
end


% QR factorisation
[Q,R] = qr(A);
x = R\Q'*b;
p = x(1:3);

% position vector from marker to tooltip
t_Tip = x(4:6);

% Orientation
t_Cloud = cloud(poses_cloud,n);
Rz = (t_Tip-t_Cloud);
Rz = Rz/norm(Rz);
Ry = cross(t_Tip,t_Cloud);
Ry = Ry/norm(Ry);
Rx = cross(Ry,Rz);
Rx = Rx/norm(Rx);

% transformation from marker to tooltip 
T_ToolmarkerTip = [Rx,Ry,Rz,t_Tip;0,0,0,1];

end