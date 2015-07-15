function [X,Y,error,error_old] = heyecalib(poses_rob, poses_mark, num)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function performs the hand eye calibration
%
% Input: 	poses_mark:	all recorded marker poses in camera coordinateframe
%			poses_rob:	all recorded robot poses in robot coordinateframe
%			num:		number of recorded poses	
%
% output: 	X:			transformationmatrix X
%			Y:			transformationmatrix Y
%			error:		error with frobenius norm (after orthonormalization)
%			error_old:	error with frobenius norm (befor orthonormalization)
%
% Robotics and Navigation in Medicine
% Group 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load M and Ng Matrix
% load('poses_mark.mat');
% load('poses_rob.mat');
Ng = poses_mark;
M = poses_rob;

% build A and b
j = 0;
for i = 1:num
	% only use valid data
    if Ng{i}(1,1) ~= 0
        j = j+1;
        
		% split M in rotational and translational part / build the inverse of N
		rotM = M{j}(1:3,1:3);
		transM = M{j}(1:3,4);
        N = inv(Ng{j}(:,:));
       
        % build the rotational part of A matrix
        rotA = [rotM*N(1,1),rotM*N(2,1),rotM*N(3,1),zeros(3);
            rotM*N(1,2),rotM*N(2,2),rotM*N(3,2),zeros(3);
            rotM*N(1,3),rotM*N(2,3),rotM*N(3,3),zeros(3);
            rotM*N(1,4),rotM*N(2,4),rotM*N(3,4),rotM];
        
        Ai = [rotA, -eye(12)];    
        bi = [zeros(9,1); -transM];
        
        switch j
            case 1
                A = Ai;
                b = bi;
            otherwise
                A = [A;Ai];
                b = [b;bi];
        end
    end
end

% QR factorization
[Q,R] = qr(A);
w = R\Q'*b;

% build X and Y transformationmatrices
X = [w(1:3),w(4:6),w(7:9),w(10:12);0,0,0,1];
Y = [w(13:15),w(16:18),w(19:21),w(22:24);0,0,0,1];

% single value decomposition for orthonormalization of X and Y
[u,s,v]=svd(Y(1:3,1:3));
YR_orth = u*v ';
Y_old = Y;
X_old = X;
Y(1:3,1:3) = YR_orth;
X = inv(poses_rob{1})*Y*poses_mark{1};

% Error calculation usind frobenius norm

for i = 1:j
    error = sum(norm((M{i}(:,:)*X-Y*Ng{i}(:,:)), 'fro'));
    error_old = sum(norm((M{i}(:,:)*X_old-Y_old*Ng{i}(:,:)), 'fro'));
end

end