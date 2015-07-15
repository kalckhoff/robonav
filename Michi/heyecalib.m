function [X,Y] = heyecalib()

jAngles = getPositionJoints();
% M = forward_kinematics(jAngles);

load('camHTMs.mat');
load('robHTMs.mat');
M = camHTMs;
Ng = robHTMs;
num = 50;

for i = 1:num
    rotM = M(1:3,1:3,i);
    N = inv(Ng(:,:,i));
    transM = M(1:3,4,i);
    
    rotA = [rotM*N(1,1),rotM*N(2,1),rotM*N(3,1),zeros(3);
            rotM*N(1,2),rotM*N(2,2),rotM*N(3,2),zeros(3);
            rotM*N(1,3),rotM*N(2,3),rotM*N(3,3),zeros(3);
            rotM*N(1,4),rotM*N(2,4),rotM*N(3,4),rotM];
        
    Ai = [rotA, -eye(12)];
    
    bi = [zeros(9,1); -transM];
    
    switch i
        case 1  
            A = Ai;
            b = bi;
        otherwise
            A = [A;Ai];
            b = [b;bi];
    end
end

[Q,R] = qr(A);
% R = R(1:24,1:24);
% Q = Q(:,1:24);
% w = inv(R)*(Q'*b);
w = R\Q'*b;
X = [w(1:3),w(4:6),w(7:9),w(10:12);0,0,0,1];
Y = [w(13:15),w(16:18),w(19:21),w(22:24);0,0,0,1];


% Error

for i = 1:num
    error = sum(norm((M(:,:,i)*X-Y*Ng(:,:,i)), 'fro'));
end

end