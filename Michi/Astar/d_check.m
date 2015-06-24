function [d, O_angle, block] = d_check(O, rho, X, X_goal, eur_angle, theta_dis)

d=100;
[rho_min, rho_i] = min(rho);
if rho_i == 1
    cont=0;
    for q=360:-1:1
        if rho(q)==rho_min
            cont=cont+1;
        else
            rho_i=-cont;
            break;
        end
    end
end    
n_min = (find(rho == rho_min));
rho_im = rho_i+floor(length(n_min)/2);
if rho_im  < 1
    rho_im = 360+rho_im;
end
    
    

Oi_start=find(O(:,2) == 1);
for k = 1:length(Oi_start)
    if Oi_start(k)+1 <= length(O(:,2))
        Oi_end=Oi_start(k)+1;
    else
        Oi_end=1;
    end
    
    if length(Oi_start)>1
        if ((O(Oi_start(k),1) <= O(Oi_end,1)) && ((rho_im >= O(Oi_start(k),1)) &&  (rho_im <= O(Oi_end,1)))) ||  ((O(Oi_start(k),1) > O(Oi_end,1)) && ((rho_im <= O(Oi_end,1)) || (rho_im >= O(Oi_start(k),1))))
            O_start=O(Oi_start(k),1);
            O_end=O(Oi_end,1);
            break;
        end
    else
        O_start=O(Oi_start(k),1);
        O_end=O(Oi_end,1);
    end
end        


if O_end > O_start
    for i = O_start:O_end
        d=min([d,sqrt((X(1)+rho(i)*cos((i-1)*pi/180)-X_goal(1))^2+(X(2)+rho(i)*sin((i-1)*pi/180)-X_goal(2))^2)]);
    end
else
    for i = O_start:360
        d=min([d,sqrt((X(1)+rho(i)*cos((i-1)*pi/180)-X_goal(1))^2+(X(2)+rho(i)*sin((i-1)*pi/180)-X_goal(2))^2)]);
    end
    for i = 1:O_end
        d=min([d,sqrt((X(1)+rho(i)*cos((i-1)*pi/180)-X_goal(1))^2+(X(2)+rho(i)*sin((i-1)*pi/180)-X_goal(2))^2)]);
    end
end

if [cos((O_end-1)/180*pi),sin((O_end-1)/180*pi)]*[cos((eur_angle-1)/180*pi);sin((eur_angle-1)/180*pi)] > [cos((O_start-1)/180*pi),sin((O_start-1)/180*pi)]*[cos((eur_angle-1)/180*pi);sin((eur_angle-1)/180*pi)]
   O_angle=O_end; 
else
   O_angle=O_start;
end

% old

%blocking check
block=0;
Oi_start=find(O(:,2) == 1);
for k = 1:length(Oi_start)
    if Oi_start(k)+1 <= length(O(:,2))
        Oi_end=Oi_start(k)+1;
    else
        Oi_end=1;
    end

    if ((O(Oi_start(k),1) <= O(Oi_end,1)) && ((theta_dis >= O(Oi_start(k),1)) &&  (theta_dis <= O(Oi_end,1)))) ||  ((O(Oi_start(k),1) > O(Oi_end,1)) && ((theta_dis <= O(Oi_end,1)) || (theta_dis >= O(Oi_start(k),1))))
        block=1;
        break;
    end
end 

