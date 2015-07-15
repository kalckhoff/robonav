function t_Toolmarker = cloud()

load('camHTMs.mat');
T = camHTMs;
num = 50;
trans = zeros(4,1);

for i = 1:num
    transT = T(1:4,4,i);
    
    trans = transT + trans;
end

t_Camera = trans/num;

% Transformation


T_CameraToolmarker = camHTMs(:,:,1);
T_ToolmarkerCamera = inv(T_CameraToolmarker);

t_Toolmarker = T_ToolmarkerCamera*t_Camera;
t_Toolmarker = t_Toolmarker(1:3);
end