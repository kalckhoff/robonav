function path = tangent(W, X_start, X_goal)

%parameters

offset=6;                   %min distance from obstacles
step=1/50;                  %resolution
x_max=15;                   %x max
y_max=8;                    %y max
i_max=401;
j_max=753;
R=.8;                       %sensor radius
R_inf=100;                  %saturated value

%path planning

%X_start=[.5, .5];
%X_goal=[7, 3.5];
X(1,:)=X_start;

goal = 0;
error = 0;
mot = 1;

following=0;
d_reach=100;
d_followed=100;
eur_min=100;
eur_angle=1;
block=0;

rho = sensor(W, X(1,:), step, x_max, y_max, j_max, i_max, R, R_inf);

while goal == 0 && error == 0      %   mot < 2
    
    %  theta and theta_dis to goal
    theta_g = atan2(X_goal(2)-X(mot,2),X_goal(1)-X(mot,1));  
    if theta_g < 0
        theta_g = 2*pi+theta_g;
    end
    theta_dis = round(theta_g*180/pi) + 1;
    if theta_dis == 361
        theta_dis=1;
    end
    
    if rho(theta_dis) == R_inf && following == 0

        eur_min=100;
        X(mot+1,1) = X(mot,1) + step*cos(theta_g);
        X(mot+1,2) = X(mot,2) + step*sin(theta_g);
        
    else
        
        [O, dim_O] = int_cont(rho, step, X(mot,:), X_goal, R_inf);
               
        for i=1:dim_O
            euristik(i) = rho(O(i,1))+O(i,3);
        end
        
        if (min(euristik) >= eur_min) || (following == 1)
            
            if following == 0;
                following = 1;
            end
            
            [d_reach, eur_angle, block] = d_check(O, rho, X(mot,:), X_goal, eur_angle, theta_dis);
            if block == 1;
                d_followed = min([d_reach, d_followed]);
            end

            X(mot+1,1) = X(mot,1) + step*cos((eur_angle-1)*pi/180);
            X(mot+1,2) = X(mot,2) + step*sin((eur_angle-1)*pi/180);
            
            if d_reach < d_followed
                following = 0;
                d_followed = 100;
                eur_min=100;
            end

        else
             
            [eur_min, eur_i] = min(euristik);
            eur_angle = O(eur_i,1);
            X(mot+1,1) = X(mot,1) + step*cos((eur_angle-1)*pi/180);
            X(mot+1,2) = X(mot,2) + step*sin((eur_angle-1)*pi/180);
            
        end
        
        clear euristik  O dim_O;
        
    end
    
    mot = mot+1;
    rho = sensor(W, X(mot,:), step, x_max, y_max, j_max, i_max, R, R_inf);
    
    % along an object
    if min(rho) < offset*step    %|| following == 1
         
        [rho_min, rho_i] = min(rho);
        
        %molteplicity
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
        
        
        mot_ort = 1;
        
        %check direction
        tan_sig = 1;
        if mot > 2
            if [X(mot-1,1)-X(mot-2,1),X(mot-1,2)-X(mot-2,2)]*[-sin((rho_im-1)*pi/180),cos((rho_im-1)*pi/180)]' < 0
                tan_sig = -1;
            end
        end
         
        for l = 1:length(n_min)
            % direction further from boundary
            rho_temp=sensor(W, [X(mot-1,1) - tan_sig*step*sin((n_min(l)-1)*pi/180),X(mot-1,2) + tan_sig*step*cos((n_min(l)-1)*pi/180)], step, x_max, y_max, j_max, i_max, R, R_inf);
            if min(rho_temp) >= offset*step
                rho_i=n_min(l);
                rho=rho_temp;
                X(mot,1) = X(mot-1,1) - tan_sig*step*sin((rho_i-1)*pi/180);
                X(mot,2) = X(mot-1,2) + tan_sig*step*cos((rho_i-1)*pi/180);
                mot_ort = 0;
                break;
            end
        end
        
        if mot_ort == 1;
            X(mot,1) = X(mot-1,1) - step*cos((rho_im-1)*pi/180) - tan_sig*step*sin((rho_im-1)*pi/180);
            X(mot,2) = X(mot-1,2) - step*sin((rho_im-1)*pi/180) + tan_sig*step*cos((rho_im-1)*pi/180);
            rho = sensor(W, X(mot,:), step, x_max, y_max, j_max, i_max, R, R_inf);
        end
        
        clear n_min rho_min rho_i tan_sig;
    
    end       
    
    %goal reached
    if sqrt((X_goal(1)-X(mot,1))^2+(X_goal(2)-X(mot,2))^2) < 2*step
        goal=1;
    end
    
    %impossible solution
    if mot > 1
        x_imp = find(X(1:mot-1,1)==X(mot,1));
        for qc = 1:length(x_imp)
            if X(x_imp(qc),2)==X(mot,2)
                error=1;
                break;
            end
        end
    end
    
      
    %infinite loop control
    if mot == 2000
        error=1;
    end
    
    %plot(X(:,1),X(:,2))
    
end

path=X;