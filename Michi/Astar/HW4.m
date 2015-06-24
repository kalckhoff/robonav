


%1 rotation about configuration point OK!

%2 build 3D obtacles 

%3 define translation

%4 build 3D configuration space

%5 A* for searching within C-space


x0=2;
y0=3;
Px=[1 2 2 1];
Py=[1 2 3 3];

inside = vertex_check(fliplr(Px(2:4)),fliplr(Py(2:4)),[3,2,3],[4,3,2])


hold on
patch(Px,Py,[0,0,0,0],'blu');
patch([4,3,4],[4,3,2],[0,0,0]);
axis([-2,6,-2,6]);

for i = 1:2:358
    theta=pi/180*i;

    R=[cos(theta), -sin(theta); sin(theta), cos(theta)];

    data=R*[Px-x0; Py-y0];
    Px_r=data(1,:)+x0;
    Py_r=data(2,:)+y0;
    
    patch(Px_r, Py_r, [i,i,i,i], 'red', 'FaceColor', 'none');

end