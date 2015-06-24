function path = potential(W, X_start, X_goal, graph3D)

%parameters

offset=6;                   %min distance from obstacles
step=1/50;                  %resolution
x_max=15;                   %x max
y_max=8;                    %y max
i_max=401;
j_max=753;
R=3;                        %sensor radius
R_inf=100;                  %saturated value
d_star=3;                   %threshold for damping of attractive potential
zeta=step;                  %factor for atractive potential
eta=step/10;                %factor for repulsive potential
alpha=1;                    %gradient descendent
epsilon=step/20;            %local minima

j_s=round(X_start(1)/step)+1;
i_s=round((y_max-X_start(2))/step)+1;

j_g=round(X_goal(1)/step)+1;
i_g=round((y_max-X_goal(2))/step)+1;



%path planning

%X_start=[.5, .5];
%X_goal=[7, 3.5];
X(1,:)=X_start;

goal = 0;
error = 0;
mot = 1;


while goal == 0 && error == 0      %   mot < 2
    
    rho = sensor(W, X(mot,:), step, x_max, y_max, j_max, i_max, R, R_inf);
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
    rho_im = rho_i+floor(length(n_min)/2);   %angle + 1 of distance vector
    if rho_im  < 1
        rho_im = 360+rho_im;                 %if interval across 0 get angle + 1 of distance vector
    end
    
    % attractive potential and gradient
    d_mot_goal = sqrt((X(mot,1)-X_goal(1))^2+(X(mot,2)-X_goal(2))^2);
    v_mot_goal = [X_goal(1)-X(mot,1),X_goal(2)-X(mot,2)];
    
    if d_mot_goal <= d_star
        Ua(mot)=1/2*zeta*d_mot_goal^2;
        a_direction(mot,1:2)=zeta*v_mot_goal;
        if norm(a_direction(mot,1:2))< step/2               %minimum velocity by Ua
            a_direction(mot,1:2)=v_mot_goal/norm(v_mot_goal)*step/2;
        end
    else
        Ua(mot)=d_star*zeta*d_mot_goal-1/2*zeta*d_star^2;
        a_direction(mot,1:2)=d_star*zeta*v_mot_goal/d_mot_goal;
    end  
    
    % repulsive potential and gradient
    if rho_min == 0                          % if rho_min goes to zero rho_min = step/3
        Ur(mot)=1/2*eta*(1/(step/2)-1/R)^2;
        r_direction(mot,1:2)=eta*(1/(step/2)-1/R)*(1/(step/2))*[-cos((rho_im-1)*pi/180), -sin((rho_im-1)*pi/180)];
    elseif rho_min <= R
        Ur(mot)=1/2*eta*(1/rho_min-1/R)^2;
        r_direction(mot,1:2)=eta*(1/rho_min-1/R)*(1/rho_min)*[-cos((rho_im-1)*pi/180), -sin((rho_im-1)*pi/180)];
    else
        Ur(mot)=0;
        r_direction(mot,1:2)=[0,0];
    end
    
    %global potential and gradient
    U(mot)=Ua(mot)+Ur(mot);
    direction(mot,1:2)=a_direction(mot,1:2)+r_direction(mot,1:2);
    
    X(mot+1,1:2)=X(mot,1:2)+alpha*direction(mot,1:2);       
    
    
    %goal reached
    if sqrt((X_goal(1)-X(mot,1))^2+(X_goal(2)-X(mot,2))^2) < step
        goal=1;
    end


    %impossible solution
    if norm(direction(mot,1:2)) < epsilon
        error=1;
    end
    
    
    %infinite loop control
    if mot == 2000
        error=1;
    end
    
    mot=mot+1;
    
    plot(X(:,1),X(:,2));
    
end

path=X;


% potential field

if graph3D == 1

    %U_f=zeros(i_max,j_max);
    iU=1;
    jU=1;
    for i=1:5:i_max
        for j=1:5:j_max
            
            x=step*(j-1);
            y=y_max-step*(i-1);
   
            if W(i,j)==0        
                U_f(iU,jU)=1/2*(eta/20)*(1/(step/3)-1/R)^2+.5;   % obstacle potential
            else
                rho = sensor(W, [x,y], step, x_max, y_max, j_max, i_max, R, R_inf);
                rho_min = min(rho);
    
                % attractive potential
                d_mot_goal = sqrt((x-X_goal(1))^2+(y-X_goal(2))^2);
                v_mot_goal = [X_goal(1)-x,X_goal(2)-y];
    
                if d_mot_goal <= d_star
                    Ua_f=1/2*zeta*d_mot_goal^2;
                else
                    Ua_f=d_star*zeta*d_mot_goal-1/2*zeta*d_star^2;
                end  
    
                % repulsive potential
                if rho_min == 0
                    Ur_f=1/2*(eta/20)*(1/(step/3)-1/R)^2;  % if rho_min goes to zero rho_min = step/3
                elseif rho_min <= R
                    Ur_f=1/2*(eta/20)*(1/rho_min-1/R)^2;
                else
                    Ur_f=0;
                end
    
                %global potential
                U_f(iU,jU)=Ua_f+Ur_f;
                clear rho rho_min;
            end
            jU=jU+1;
        end
        jU=1;
        iU=iU+1;
    end

    figure(2);
    U_f(1,1)=2.5;
    [iU_max,jU_max]=size(U_f);
    surf(1:1:jU_max, iU_max:-1:1, U_f);
    shading interp;
    title('Potential field');
end