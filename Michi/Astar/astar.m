function [path, error] = astar(Q, q_start, q_goal)
% vector x [f(x), x_i, x_j, x_k, g(x), bp_i, bp_j, bp_k]

error=0;
[i_max, j_max, k_max] = size(Q);

H=zeros(i_max, j_max, k_max);
%H=init_dist(q_goal, H, i_max, j_max, k_max);

large_c=10000;
step=0;
stop=0;
O = [0, q_start, 0, q_start];
C = zeros(0,8);

while stop == 0
    x=O(1,:);
    [O, C] = pop(O, C, x);
    if x(2:4) == q_goal;
        stop = 1;
        break;
    end
    star_x = expand(x, i_max, j_max, k_max);
    [ms, ns] = size(star_x);

    for i=1:ms
        if find(C(:,2)==star_x(i,2) & C(:,3)==star_x(i,3) & C(:,4)==star_x(i,4))
            % in C
        else
            % not in C
            O_row = find(O(:,2)==star_x(i,2) & O(:,3)==star_x(i,3) & O(:,4)==star_x(i,4));
            if O_row
                % in O
                if Q(star_x(i,2), star_x(i,3), star_x(i,4)) == 255
                    temp=x(5)+eval_c(x(2:4),star_x(i,2:4));
                else
                    temp=x(5)+large_c;    
                end
                if temp <= O(O_row,5)
                    O(O_row,5)=temp;
                    O(O_row,1)=temp+d_euc(star_x(i,2:4), q_goal, k_max);    %+H(star_x(i,2), star_x(i,3), star_x(i,4));
                    O(O_row,6:8)=star_x(i,6:8);                
                end                
            else
                % not in O
                if Q(star_x(i,2), star_x(i,3), star_x(i,4)) == 255
                    star_x(i,5)=x(5)+eval_c(x(2:4),star_x(i,2:4));
                else
                    star_x(i,5)=x(5)+large_c;    
                end
                star_x(i,1)=star_x(i,5)+d_euc(star_x(i,2:4), q_goal, k_max);  %+H(star_x(i,2), star_x(i,3), star_x(i,4));
                if star_x(i,1)>=large_c
                    C = [C; star_x(i,:)];
                else
                    O = [O; star_x(i,:)];
                end
            end
            clear O_row temp;
            step=step+1;
        end
    end

    O=sortrows(O);
    [mO, nO]=size(O);
    if mO==0;
        stop = 1
    end

    clear star_x ms ns mO nO;
end
step

C=sortrows(C);
path = q_goal;
stop = 0;
i=1;
while stop == 0
    C_row = find(C(:,2)==path(i,1) & C(:,3)==path(i,2) & C(:,4)==path(i,3));
    if C_row
        i=i+1;
        path(i,1:3)=C(C_row, 6:8);
        if path(i,1:3) == q_start;
            stop = 1;
            break;
        end
    else
        disp('No path is possible');
        stop = 1;
        error = 1;
    end
end