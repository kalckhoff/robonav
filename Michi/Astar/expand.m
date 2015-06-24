function star_x = expand(x, i_max, j_max, k_max)

% vector x [f(x), x_i, x_j, x_k, g(x), bp_i, bp_j, bp_k]

star_x = zeros(0,8);
step=1;

for i = x(2)-1:step:x(2)+1
    for j = x(3)-1:step:x(3)+1
        for k = x(4)-1:step:x(4)+1
            if (i>0 && i<=i_max) && (j>0 && j<=j_max)
                if k==0
                    star_x=[star_x; 0, i, j, k_max, 0, x(2:4)];
                elseif k==k_max+1
                    star_x=[star_x; 0, i, j, 1, 0, x(2:4)];
                else
                    star_x=[star_x; 0, i, j, k, 0, x(2:4)];
                end
            end
        end
    end
end
