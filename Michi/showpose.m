function showpose(pos_joint)

[x,y,z] = sphere;
x_size = size(x);
X = reshape(x,[x_size(2)^2,1]);
Y = reshape(y,[x_size(2)^2,1]);
Z = reshape(z,[x_size(2)^2,1]);

DT = delaunayTriangulation(X,Y,Z);
K = convexHull(DT);

% figure
% hold on
% box on
% grid on
% axis([-500 500 -500 500 -200 1000])
%trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','cyan')

figure;

for k = 1:8
    subplot(2,4,k);
    hold on;
    box on;
    grid on;
    xlabel('x');ylabel('y');zlabel('z');
    view(-20,20);
    axis([-800 800 -800 800 -200 1000]);
    
    switch k
        case 1
            title('flip up lefty');
        case 2
            title('flip down lefty');
        case 3
            title('noflip up lefty');
        case 4
            title('noflip down lefty');
        case 5
            title('flip up righty');
        case 6
            title('flip down righty');
        case 7
            title('noflip up righty');
        case 8
            title('noflip down righty');
    end
            
    
    surf(25*x,25*y,25*z)
    surf(25*x+pos_joint{6,k}(1), 25*y+pos_joint{6,k}(2), 25*z+pos_joint{6,k}(3))
    plot3([0 pos_joint{1,k}(1)],[0 pos_joint{1,k}(2)], [0 pos_joint{1,k}(3)], 'LineWidth', 3)
    
    for i = 1:5
        surf(25*x+pos_joint{i,k}(1), 25*y+pos_joint{i,k}(2), 25*z+pos_joint{i,k}(3))
        plot3([pos_joint{i,k}(1) pos_joint{i+1,k}(1)], [pos_joint{i,k}(2) pos_joint{i+1,k}(2)], [pos_joint{i,k}(3) pos_joint{i+1,k}(3)], 'LineWidth', 3)
    end
end

end