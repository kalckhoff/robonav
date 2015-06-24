function [O, m] = int_cont(rho, step, X, X_goal, R_inf)

m=1;
O=[0,0,0];
continuity_jump=8;

for k = 2:360
    delta = abs(rho(k)-rho(k-1));
    if delta > continuity_jump*step             %  !!!!!!!!  continuity jump
        if rho(k-1) < R_inf,
            O(m,1)=k-1;
            O(m,2)=-1;
            O(m,3)=sqrt((X(1)+rho(k-1)*cos((k-2)*pi/180)-X_goal(1))^2+(X(2)+rho(k-1)*sin((k-2)*pi/180)-X_goal(2))^2);
            m=m+1;
        end
        if rho(k) < R_inf,
            O(m,1)=k;
            O(m,2)=1;
            O(m,3)=sqrt((X(1)+rho(k)*cos((k-1)*pi/180)-X_goal(1))^2+(X(2)+rho(k)*sin((k-1)*pi/180)-X_goal(2))^2);
            m=m+1;
        end            
    end
end

delta = abs(rho(1)-rho(360));
if delta > continuity_jump*step             %  !!!!!!!!  continuity jump
    if rho(360) < R_inf,
        O(m,1)=360;
        O(m,2)=-1;
        O(m,3)=sqrt((X(1)+rho(360)*cos((359)*pi/180)-X_goal(1))^2+(X(2)+rho(360)*sin((359)*pi/180)-X_goal(2))^2);
        m=m+1;
    end
    if rho(1) < R_inf,
        O(m,1)=1;
        O(m,2)=1;
        O(m,3)=sqrt((X(1)+rho(1)-X_goal(1))^2+(X(2)-X_goal(2))^2);
        m=m+1;
    end            
end

m=m-1;