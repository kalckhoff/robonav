function rho = sensor(W, X, step, x_max, y_max, j_max, i_max, R, R_inf)

rho=ones(1,360)*R_inf;              %saturated distance function 
OS_factor=2;                        %oversampling
maxR=round(R/step*OS_factor);       %step


for k=1:360
    for l=0:maxR
        x=X(1)+l*step/OS_factor*cos(k*pi/180);
        y=X(2)+l*step/OS_factor*sin(k*pi/180);
        j=round(x/step)+1;
        i=round((y_max-y)/step)+1;
        if i>i_max || i<1 || j>j_max || j<1
            rho(k)=(l-1)*step/OS_factor;
            break;
        end
        if W(i,j) == 0
            rho(k)=l*step/OS_factor;
            break;
        end
    end
end

%theta = (0:1:359)*pi/180;
%polar(theta,rho);