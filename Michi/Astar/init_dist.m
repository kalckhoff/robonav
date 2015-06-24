function H = init_dist(q_goal, H_in, i_max, j_max, k_max)

step=0;
stop=0;
H=H_in;
O = [0, q_goal, 0, q_goal];
C = zeros(0,8);
[mO, nO]=size(O);

while stop == 0
    [temp i_min]=min(O(:,1));
    x=O(i_min(1),:);
    [O, C] = pop(O, C, x);
    star_x = expand(x, i_max, j_max, k_max);
    [ms, ns] = size(star_x);

    for i=1:ms
        if  H(star_x(i,2), star_x(i,3), star_x(i,4)) == 0
            temp=H(x(2), x(3), x(4)) + eval_c(x(2:4), star_x(i,2:4));
            H(star_x(i,2), star_x(i,3), star_x(i,4))=temp;
            star_x(i,1)=temp;
            O=[O; star_x(i,:)];
            step=step+1;
        end
    end

    %O=sortrows(O);
    [mO, nO]=size(O);

    if mO==0;
        stop = 1;
    end
    
    clear star_x ms ns mO nO;
end
H(q_goal(1), q_goal(2), q_goal(3))=0;
step